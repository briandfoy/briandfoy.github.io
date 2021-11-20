require 'fileutils'
require_relative '../lib/Categories.rb'

include Categories

# https://jekyllrb.com/docs/plugins/hooks/
Jekyll::Hooks.register :site, :after_init do |post|
	FileUtils.rm_rf(categories_dir)
	FileUtils.mkdir_p(categories_dir)
	puts "Jekyll Categories: Generating category pages"

	categories = get_all_categories("_posts")

    categories.each do |category|
		File.open( File.join( categories_dir, "#{category}.md" ), "wb") do |file|
			file.puts <<~"HERE"
				---
				layout: category_page
				category: #{category}
				generated-by: #{__FILE__}
				generated-at: #{Time.new}
				permalink: /categories/#{category}/
				---

				HERE
		end
    end
end
