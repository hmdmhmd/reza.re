require "stringex"

class Jekyll < Thor
  desc "new", "create a new post"
  method_option :editor, :default => "mate"
  def new(*title)
    title = title.join(" ")
    date = Time.now.strftime('%Y-%m-%d')
    datepost = Time.now.strftime('%Y-%m-%d %T')
    filename = "_posts/#{date}-#{title.to_url}.md"

    if File.exist?(filename)
      abort("#{filename} already exists!")
    end

    puts "Creating new post: #{filename}"
    open(filename, 'w') do |post|
      post.puts "---"
      post.puts "layout: post"
      post.puts "title: \"#{title.gsub(/&/,'&amp;')}\""
      post.puts "date: #{datepost}"
      post.puts "tags:"
      post.puts "---"
    end

    system(options[:editor], filename)
  end
end
