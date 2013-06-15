---
layout: post
title: "Improving Octopress Performance"
date: 2013-06-13 12:08
comments: true
categories: [octopress, blog, heroku]
---

This is how I improving octopress website based, it's covers Cloudflare DNS/CDN management and configuration of heroku and sinatra.

## DNS and CDN Management ##

CloudFlare is more than just a DNS, their service includes a CDN, page acceleration, security checking, DDOS protection, and more. However, you can switch all that off and just use their DNS. They delivered marginally the best performance. In terms of pricing, if you don’t need SSL, it’s free; if you do need SSL, then your first site is $240 per year, subsequent sites $60 per year.

## Heroku and Sinatra ##
 The default configuration for Octopress and Heroku is to use Sinatra, which in turn means that Heroku will serve your traffic using Webrick. The result is one Heroku instance running one web server. If you use Unicorn, you can get multiple instances running within it; in the configuration described below, this results in four times the capacity.

Add Unicorn to the `Gemfile` outside of the development group:

{% codeblock Gemfile lang:ruby %}
source "http://rubygems.org"

group :development do
  # all default gems
end

gem 'sinatra', '~> 1.4.2'
gem 'unicorn'

{% endcodeblock %}

Add a `unicorn.rb` file in the root directory of your application:

{% codeblock unicorn.rb lang:ruby %}
worker_processes 4
timeout 30
preload_app true
{% endcodeblock %}

Add a `Procfile` file in the root directory of your application:

{% codeblock Procfile lang:ruby %}
web: bundle exec unicorn -p $PORT -c ./unicorn.rb
{% endcodeblock %}

That's it. You can test your website performance score using [Google PageSpeed](https://developers.google.com/speed/pagespeed/insights#) and see suggestion summary.