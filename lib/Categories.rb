module Categories
	def categories_dir; "categories"; end

	def get_all_categories(dir)
		all_categories = Dir.entries(dir)
			.map { |file| get_categories_in( File.join( dir, file ) ) }
			.flatten
			.uniq
			.compact
			.sort
	end

	def get_categories_in(file)
		categories = []
		return categories if File.directory?(file)
		File.readlines(file).each do |line|
			next unless line.start_with?('categories:')
			line.chomp!
			line.sub( /\Acategories:\s*/, "" ).split( /\s+/ ).each do |category|
				categories.push(category)
			end
			break
		end
		categories.flatten.uniq.compact.sort
	end
end
