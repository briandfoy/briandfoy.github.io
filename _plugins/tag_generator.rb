require 'fileutils'
require_relative '../lib/Tags.rb'

include Tags

# https://jekyllrb.com/docs/plugins/hooks/
Jekyll::Hooks.register :site, :after_init do |post|
	FileUtils.rm_rf(tags_dir)
	FileUtils.mkdir_p(tags_dir)
	puts "Jekyll Tags: Generating tag pages"

	tags = get_all_tags("_posts")

    tags.each do |tag|
		File.open( File.join( tags_dir, "#{tag}.md" ), "wb") do |file|
			file.puts <<~"HERE"
				---
				layout: tag_page
				tag: #{tag}
				generated-by: #{__FILE__}
				generated-at: #{Time.new}
				permalink: /tags/#{tag}/
				---

				HERE
		end
    end
end
