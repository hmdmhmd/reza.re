---
layout: post
title: "Hosting Rails Applications on Nginx"
date: 2012-10-13 01:18:13 +0700
description: How to install nginx web server with Phusion Passenger support and hosting Rails applications
categories: [nginx]
---

Hosting and deploying Ruby on Rails application became very easy with [Phusion Passenger](http://www.modrails.com/) or `mod_rails`. Phusion Passenger is an nginx module, which makes deploying Ruby and Ruby on Rails applications on nginx a breeze. This guide describes the required process for deploying Ruby on Rails with Passenger and the nginx web server on CentOS 6. Assume we have installed nginx and Ruby on Rails.

## Install Nginx with Phusion Passenger
First, install the Phusion Passenger gem by running:
{% codeblock %}
# gem install passenger
{% endcodeblock %}
Next, run the Phusion Passenger installer for nginx:
{% codeblock %}
# passenger-install-nginx-module
{% endcodeblock %}
When promted, choose "1" to allow the installer to automatically download, compile, and install nginx on the system (on `opt` folder by default). Because we have installed nginx before, copy `/opt/nginx/sbin/nginx` to `/usr/sbin/`. If nginx daemon are running, stop it first.
{% codeblock %}
# /etc/init.d/nginx stop
# cp /opt/sbin/nginx /usr/sbin/
{% endcodeblock %}
Now, we have a new nginx binary with Passenger support without changing any existing configurations. To enable Passenger support, add these lines to `/etc/nginx/nginx.conf`.
{% codeblock %}
http {
	...
	passenger_root /usr/local/rvm/gems/ruby-1.9.3-p194/gems/passenger-3.0.17;
	passenger_ruby /usr/local/rvm/wrappers/ruby-1.9.3-p194/ruby;
	...
{% endcodeblock %}
To see Ruby path:
{% codeblock %}
# which ruby
{% endcodeblock %}
Passenger root folder usually lies in `/yourruby/gems/passenger-x.x.x`. Even the installation will recognize your Ruby and Passenger location, it's good the check it manually.

## Hosting Rails Application
As I mentioned before, hosting Rails applications became very simple with Passenger. As simple as creating a new virtual host. Create a new configuration files, for example `railsapp.example.org.conf` in `/etc/nginx/conf.d/`, add these lines:
{% codeblock %}
server {
	listen 80;
	server_name railsapp.example.org;
	passenger_enabled on;
	passenger_use_global_queue on;
	root /path/to/railsapp/public;
}
{% endcodeblock %}
Start nginx to reload new configurations.
{% codeblock %}
# /etc/init.d/nginx start
{% endcodeblock %}
For detailed guides see [Passenger documentation](http://www.modrails.com/documentation/).