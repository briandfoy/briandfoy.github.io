---
layout: post
title: LeanPub Monthly Sales
categories: publishing programming
tags: leanpub numbers cheatsheet
stopwords:
last_modified:
original_url:
---

At the beginning of each month I look at my sales and royalties for  my various books. My latest two, *[Mojo Web Clients](https://www.leanpub.com/mojo_web_clients)* and *[Learning Perl Exercises](https://www.leanpub.com/learning_perl_exercises)*, are on LeanPub. They make it easy to sell books but they don't make it easy to find what I need.

<!--more-->

I can get a spreadsheet of sales if I dig around the site enough. My link is [https://leanpub.com/u/briandfoy/generate_all_royalties_csv](https://leanpub.com/u/briandfoy/generate_all_royalties_csv); you'll have to add your own account name. Now I can use this cheatsheet to go right to that link. Sadly, I can ask for the CSV file there but they send me the actual link in email. That's annoying, but it's once a month.

Once downloaded, I want to look at it in Numbers (because I'm a Mac weenie who doesn't pay for Excel, perhaps the most important software ever written). But, I want to group it by months, and that's been a hassle the last two times.

Here's where I mess up: I need to format the "Date Purchased (UTC)" column as a date. It's not very smart that organizing a column as a date does not either format it as a date for me or warn me that I haven't formatted it. That's the part that I never remember because without this step, categorizing still thinks it's a date and can still organize by the days of the month no matter which period I choose.

![](/images/numbers-categorize/date-format.png)

After that, it's a simple matter of "organizing" (the round button with three horizontal lines in the upper right), choosing the date column, and selecting "Month":

![](/images/numbers-categorize/categorize.png)

I thought I'd write this cheatsheet after googling to find the same thing I did the last two times, but I gave up and wrote a Perl program to do it for me. This is actually better because I get all the information I want without messing with a UI:

{% highlight perl %}
use v5.30;
use warnings;

use Text::CSV_XS;

my $file = $ARGV[0];
die "No such file <$file>\n" unless -e $file;

open my $fh, '<:utf8', $file or die "Could not open file <$file>\n\t$!\n";

my $csv = Text::CSV_XS->new;

$csv->header( $fh );

my %Grand;
my %Totals;
while( my $row = $csv->getline_hr( $fh ) ) {
    my( $year, $month ) =
        $row->{'date purchased (utc)'} =~ m/\A(\d{4})-(\d{2})/;
    my $title = $row->{'book title'};
    $Grand{$title}{$year}{$month}{_count}++;
    $Grand{$title}{$year}{$month}{_sales}     += $row->{'total paid for book'};
    $Grand{$title}{$year}{$month}{_royalties} += $row->{'total book royalty'};

    $Totals{$title}{_count}++;
    $Totals{$title}{_sales}     += $row->{'total paid for book'};
    $Totals{$title}{_royalties} += $row->{'total book royalty'};
    }

foreach my $title ( sort keys %Grand ) {
    state @keys = qw(_count _sales _royalties);

    printf "%s\n%s\n  Copies: %d  Sales: %.2f  Royalties: %.2f\n%s\n",
        '=' x 50,
        $title,
        $Totals{$title}->@{@keys},
        '-' x 50;

    foreach my $year ( sort { $a <=> $b } keys $Grand{$title}->%* ) {
        foreach my $month ( sort { $a <=> $b } keys $Grand{$title}{$year}->%* ) {
            my $g = $Grand{$title}{$year}{$month};
            printf "  %4d/%02d  %3d  %6.2f  %6.2f\n",
                $year, $month, $g->@{@keys};
            }
        }

    print "\n";
    }
{% endhighlight %}
