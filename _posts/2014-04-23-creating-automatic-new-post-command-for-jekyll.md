---
layout: post
title: "New Jekyll Post From Command Line"
date: 2014-04-23 00:29:37
tags: jekyll
---

This is how I create new post for Jekyll using command line with [Thor](https://github.com/erikhuda/thor).
So when I'm creating a new post, I don't have to create post file manually.

Add these gems to `Gemfile` and run `bundle install`.
{% highlight ruby %}
gem 'thor'
gem 'stringex'
{% endhighlight %}

Create a `jekyll.thor` file with the following contents.

{% highlight ruby %}
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
{% endhighlight %}

Use the new created command:

    $ thor jekyll:new The Post Title Without Apostrophes

Specify which editor to open the files:

    $ thor jekyll:new The Post Title Without Apostrophes --editor=vim

The default editor is on line 4 if you want to change it.
