#!/usr/bin/ruby
require 'rss'
require 'open-uri'

rss_url =  "http://www.metmuseum.org/collection/artwork-of-the-day?rss=1"
target_dir = ENV['HOME']+"/metIotd"

def cmd shell_command
    `set -x; #{shell_command}`
    if $?.nil? or not $?.success?
        raise Exception.new "command '#{shell_command}' failed"
    end
end

def find_large_image_url image_overview_page
    link_to_image = image_overview_page[/.*class="download"\s*href="([^"]*)".*/,1]
    return link_to_image
end

def find_small_image_url image_overview_page
    link_to_image = image_overview_page[/.*rel="image_src"\s*href="([^"]*)".*/,1]
    return link_to_image
end

def clean_up_target output_path
    output_dir = File.dirname output_path
    Dir.mkdir(output_dir) unless File.exists?(output_dir)
    FileUtils.rm_rf("#{output_dir}/.", secure: true)
end

def download_image_to url, output_path
    cmd "wget --output-document=\'#{output_path}\' #{url}"
end

def get_url_and_output_path rss_url, target_dir
    rss_content = open(rss_url){|f|f.read}
    rss = RSS::Parser.parse(rss_content, false)

    title = rss.channel.item.title.strip
    description = rss.channel.item.description.strip
    artist = description[/.*Artist:\s*([^\(]*).*/,1]
    artist = " (#{artist.strip})" unless artist.nil?
    image_overview_page_url = description[/<a\s*href="([^"]*)"/,1].strip
    image_overview_page = open(image_overview_page_url){|f|f.read}
    image_url = find_large_image_url image_overview_page

    if (! image_url)
        image_url = find_small_image_url image_overview_page
        puts "No large image available, using #{image_url}"
    end

    output_path = "#{target_dir}/#{title}#{artist}.jpg"

    return image_url, output_path
end

image_url, output_path = get_url_and_output_path rss_url, target_dir
clean_up_target output_path
download_image_to image_url, output_path




