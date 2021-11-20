module Tags
	def tags_dir; "tags"; end

	def get_all_tags(dir)
		all_tags = Dir.entries(dir)
			.map { |file| get_tags_in( File.join( dir, file ) ) }
			.flatten
			.uniq
			.compact
			.sort
	end

	def get_tags_in(file)
		tags = []
		return tags if File.directory?(file)
		File.readlines(file).each do |line|
			next unless line.start_with?('tags:')
			line.chomp!
			line.sub( /\Atags:\s*/, "" ).split( /\s+/ ).each do |tag|
				tags.push(tag)
			end
			break
		end
		tags.flatten.uniq.compact.sort
	end
end
