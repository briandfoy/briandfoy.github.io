---
layout: post
title: Backing up my WordPress blogs
---

The holidays is the time I have to fix up all the niggling system things that have been failing since last Christmas. This year involves a sad but inevitable migration from FreeBSD on [Arp Networks](https://arpnetworks.com) to ArchLinux on [Linode](https://www.linode.com) because I'd grown less fond of */usr/ports* over the past decade. And, while I'm changing, why not do something drastically different?

More on that in a moment though. First, I used to have a process to backup my WordPress blogs automatically. I even had those backups in git and hosted in private repositories on three different services. That all broke in the migration and I never really bothered to fix it. Secretly, I kinda hoped everything would meltdown and I'd permanently lose all the data. That would fix the need to back up anything.

Previously, I used the `root` user with *mysqldump* even though I know that was a bad idea. It's an easy and convenient idea because the `root` user is already there. It's bad because it's the `root` user, which can do anything, but it also needs a password. In a non-interactive session, such as a cron job, you end up exposing that (or putting it in plaintext in */etc/my.conf*):

	% mysqldump -u backup -pSomePassword learning_perl_wordpress

But I can create another user which doesn't have a password so I can run it like this:

	% mysqldump -u backup learning_perl_wordpress

I can create a user with no password. That's insecure in general, but just about everything this user can get at is already public. I'm a big fan of multiple database users with precise permissions. I grant the minimal permissions I think *mysqldump* needs in my case:

	% mysql -u root -p
	Enter password:...
	MariaDB [(none)]> CREATE USER 'backup'@'localhost'
	MariaDB [(none)]> GRANT SELECT, SHOW VIEW, EVENT, TRIGGER ON *.* TO 'backup'@'localhost';
	MariaDB [(none)]> GRANT LOCK TABLES ON *.* TO 'backup'@'localhost';
	MariaDB [(none)]> FLUSH PRIVILEGES;

No big whoop.

The next part is harder. I need to get this to run unattended, but I'm on ArchLinux now. There's no *cron*. The *crontab* was easy and life was good. Edit a file to add single lines, save it, then stuff happens on the schedule you specified. I didn't need to know anything about how it worked to use it. I can [install various packages](https://wiki.archlinux.org/index.php/cron) to do it.

But, my personal contract with ArchLinux is that I'd do things the way it wants me to do it. Instead of *cron*, there's *systemd*. It's arrangement is not so simple, but it's not really designed for users tasks either. It's designed to get a system up and running.

I could easily have set up a system-level *systemd* [unit](https://www.digitalocean.com/community/tutorials/understanding-systemd-units-and-unit-files) to run my WordPress backup command, but I'm a bit allergic to root-level automated tasks that aren't related to system operation. Instead, I need to setup user-level units for my personal tasks.


First, user-level units do their thing when the user is logged in, and not when they aren't. That's no good. I want it to run on its schedule regardless of my login status (although I could complicate it with a cronjob from elsewhere to log in, which I've done for some systems). But, I can setup a "linger" for my user:

	$ sudo loginctl enable-linger username

At least, I should be able to do that. Running it give an incorrect error message. The [issue in GitHub](https://github.com/systemd/systemd/issues/12401) lays it out, but on my up-to-date system I still have the problem:

	$ sudo loginctl enable-linger username
	Could not enable linger: Read-only file system

Peeking under the hood, it doesn't find the directory it wants and doesn't create it if it's missing, nor does it warn if the permissions are incorrect. Instead, I fall back on my Unix roots to make the file myself:

	$ sudo mkdir -p /var/lib/systemd/linger
	$ sudo touch /var/lib/systemd/linger/brian

I can check that its enabled:

	$ loginctl show-user brian --property=Linger
	Linger=yes

Now my units will continue to do their job even if I am not logged in.

But, I have to create the unit. I've made simple, system-level units and remember that pain. I know I have to make some files, but where do I put them? Not in the group-writable */etc/systemd/system* because I'm a normal user who's not in the `wheel` group.

The ArchLinux [SystemD/User](https://wiki.archlinux.org/index.php/Systemd/User) has godo instructions

However, almost everything I've found deals with setting system-level units. That makes me nervous in the same way that putting my user tasks in a root *crontab* would. The ArchLinux [SystemD/User](https://wiki.archlinux.org/index.php/Systemd/User) is pretty good.

I need to put something in *~/.config/systemd/user*, although that's a bit deep. I'll give myself a shortcut:

	$ mkdir -p ~/.config/systemd/user
	$ ln -s !$ ~/units

I started with a test that wouldn't do anything else complicated. A sort-of "Hello World". Here's *~/.config/systemd/user/test.service* that executes the *date* command, and appends the output to a file in my home directory, and to do this every 60 seconds:

	[Unit]
	Description=A test

	[Service]
	ExecStart=date
	Restart=always
	RestartSec=60
	StandardOutput=append:/home/brian/datetest.txt

	[Install]
	WantedBy=default.target

The file is there, but who cares? Not *systemd*, until you tell it to care:

	$ systemctl --user enable test
	Created symlink /home/brian/.config/systemd/user/default.target.wants/test.service → /home/brian/.config/systemd/user/test.service.

My new unit shows up in the list of services:

	$ systemctl --user list-unit-files --type service
	UNIT FILE                      STATE
	dbus.service                   static
	dirmngr.service                static
	gpg-agent.service              static
	p11-kit-server.service         disabled
	systemd-exit.service           static
	systemd-tmpfiles-clean.service static
	systemd-tmpfiles-setup.service disabled
	test.service                   enabled

But, its status is still inactive. It's merely enabled, not running:

	$ systemctl --user status test
	● test.service - A test
		 Loaded: loaded (/home/brian/.config/systemd/user/test.service; enabled; vendor preset: enabled)
		 Active: inactive (dead)

Just like with the system units, I need to start it. Now its doing its thing:

	$ systemctl --user start test
	$ systemctl --user status test
	● test.service - A test
		 Loaded: loaded (/home/brian/.config/systemd/user/test.service; enabled; vendor preset: enabled)
		 Active: activating (auto-restart) since Wed 2020-01-01 18:37:03 EST; 8s ago
		Process: 3641717 ExecStart=/usr/bin/date (code=exited, status=0/SUCCESS)
	   Main PID: 3641717 (code=exited, status=0/SUCCESS)

After this, I know that something is working. I stop and disable it:

	$ systemctl --user stop test
	$ systemctl --user disable test
	Removed /home/brian/.config/systemd/user/default.target.wants/test.service.

	$ systemctl --user status test
	● test.service - A test
		 Loaded: loaded (/home/brian/.config/systemd/user/test.service; disabled; vendor preset: enabled)
		 Active: inactive (dead)

	Jan 01 18:43:04 m113 systemd[24670]: test.service: Scheduled restart job, restart counter is at 6.
	Jan 01 18:43:04 m113 systemd[24670]: Stopped A test.
	Jan 01 18:43:04 m113 systemd[24670]: Started A test.
	Jan 01 18:43:04 m113 systemd[24670]: test.service: Succeeded.
	Jan 01 18:44:04 m113 systemd[24670]: test.service: Service RestartSec=1min expired, scheduling restart.

Here's the actual unit, with the *date* command replaced by a program that does all of the hard work:

	[Unit]
	Description=Dump the Wordpress backups

	[Service]
	ExecStart=/home/brian/bin/backup-wordpress
	Restart=always
	RestartSec=86400
	StandardOutput=append:/home/brian/backups/log.txt
	StandardError=append:/home/brian/backups/error_log.txt

	[Install]
	WantedBy=default.target

The file is there, so I enable and start it:

	$ systemctl --user enable wordpress-backup
	$ systemctl --user start wordpress-backup

But, of course, I made a mistake and I changed the file. I need to pick up the changes while the service was already running. Since my file has changed, I can't stop the service (because units can have instructions on what to do then):

	$ systemctl --user stop wordpress-backup
	Warning: The unit file, source configuration file or drop-ins of wordpress-backup.service changed on disk. Run 'systemctl --user daemon-reload' to reload units.

So I reload everything to get my changes:

	$ systemctl --user daemon-reload

And finally, here's the program I run. I use *mysqldump* to get out the SQL version, but I also use the [wp](https://wp-cli.org) tool to export to an XML format. It also reads the *wp-config.php* file to get the database name.

	#!/usr/bin/perl
	use strict;
	use warnings;
	use v5.10;
	use utf8;

	use File::Basename;
	use File::Path qw(make_path);
	use File::Spec::Functions qw(catfile rel2abs);

	chdir '/home/brian/Blogs';

	my @blogs = map { rel2abs( $_ ) }
		glob( '*/wp-config.php */public_html/wp-config.php' );

	my $backup_dir = "/home/mango/backups";
	make_path( $backup_dir, { mode => 0700 } );
	die "Backup dir <$backup_dir> is missing\n"
		unless -d $backup_dir;

	foreach my $file ( glob( "$backup_dir/*.gz" ) ) {
			unlink $file if -M $file > 7;
			}

	my $mysqldump = '/usr/bin/mysqldump';

	chdir $backup_dir;
	foreach my $file ( @blogs ) {
		my $db   = `wp config get DB_NAME`;
		chomp($db);

		my $time = sprintf "%4d%02d%02d%02d%02d",
				(localtime)[5] + 1900, (localtime)[4] + 1,
				(localtime)[3,2,1];

		my $result_file = "$db-$time.sql";
		system $mysqldump,
				'--add-drop-table',
				'-u', 'backup',
				"--result-file=$result_file",
				$db;

		my $path = dirname $file;
		system '/home/brian/bin/wp', 'export', "--path=$path";
		}

	foreach my $file ( glob( "*.sql *.xml" ) ) {
		system '/usr/bin/gzip', '-f', $file;
		unlink $file;
		system 'git', 'add', "$file.gz";
		}

	system 'git', 'commit', '-a', '-m', "Backup for " . localtime;
	system 'git', 'push', 'origin', 'master';

