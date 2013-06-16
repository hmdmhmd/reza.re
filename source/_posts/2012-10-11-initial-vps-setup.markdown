---
layout: post
title: "Initial Virtual Private Server Setup"
date: 2012-10-11 04:21:34 +0700
description: Initial setup and configuration Centos 6.3 virtual private server
categories: [vps, nginx]
---

This is initial setup for my CentOS 6.3 virtual private server. I want to use it for deploying Rails application and hosting my website. This article only cover basic installation for web server, Ruby with RVM, Rails, and crontab.

## Preparation
I will use [server.example.org](http://server.example.org/) as my VPS hostname. I will not install DNS server to save some physical memory on VPS. On the DNS registrar management create address record or `A` record for server and point it to the VPS public ip address. Access VPS via SSH or [putty](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html) if using Windows.

{% codeblock %}
[reza@local ~]$ ssh root@server.example.org
{% endcodeblock %}

As usual, run update after OS installation:

{% codeblock %}
[root@server ~]# yum -y update
{% endcodeblock %}

By default, the VPS comes with Apache HTTP web server, but I will use [nginx](http://nginx.org/) for my web server. Removing Apache web server:

{% codeblock %}
[root@server ~]# yum remove httpd
{% endcodeblock %}

To add nginx yum repository, create a file named `/etc/yum.repos.d/nginx.repo` and paste the configuration below:

{% codeblock %}
[nginx]
name=nginx
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
gpgcheck=0
enabled=1
{% endcodeblock %}

Install nginx using yum:

{% codeblock %}
[root@server ~]# yum update
[root@server ~]# yum install nginx
{% endcodeblock %}

Start nginx daemon and add link to system startup:

{% codeblock %}
[root@server ~]# /etc/init.d/nginx start
[root@server ~]# chkconfig --levels 235 nginx on
{% endcodeblock %}

See [server.example.org](http://server.example.org/) to check nginx installation.

## Development Tools and Git
Install development tools for RubyGems dependencies:

{% codeblock %}
[root@server ~]# yum groupinstall 'Development Tools'
[root@server ~]# yum install zlib zlib-devel sqlite-devel libffi-devel openssl-devel readline-devel
{% endcodeblock %}

Install git for source code management:

{% codeblock %}
[root@server ~]# yum install git-core
{% endcodeblock %}

## Ruby with RVM
Before install Ruby Version Manager or [RVM](https://rvm.io/rvm/) via `curl` command, we need to install `libyaml-devel` to prevent psych error. Add new yum repository from [repoforge.org](http://repoforge.org/use/), then install `libyaml-devel`:

{% codeblock %}
[root@server ~]# yum install libyaml-devel
{% endcodeblock %}

Next, we can install RVM without any trouble.

{% codeblock %}
[root@server ~]# curl -L https://get.rvm.io | bash -s stable
[root@server ~]# bash
{% endcodeblock %}

Using RVM we can install many Ruby version, see [RVM docs](https://rvm.io/rvm/install/) for detailed instructions. For now, I just need Ruby 1.9.3, to install this version:

{% codeblock %}
[root@server ~]# rvm install 1.9.3
[root@server ~]# rvm use 1.9.3 --default
{% endcodeblock %}

To check Ruby and RubyGems installation:

{% codeblock %}
[root@server ~]# ruby -v
ruby 1.9.3p194 (2012-04-20 revision 35410) [i686-linux]
[root@server ~]# gem -v
1.8.24
{% endcodeblock %}

With Ruby and RubyGems loaded, you can install all of [Rails](http://rubyonrails.org/) and its dependencies (approximately 29 gems) through the command line:

{% codeblock %}
[root@server ~]# gem install rails
{% endcodeblock %}

## Crontab
I will use [crontab](http://crontab.org/) for automatic update once a week. Create a shell script `/etc/cron.weekly/yum.sh` and add script below:

{% codeblock yum.sh lang:bash %}
#!/bin/bash
YUM=/usr/bin/yum
$YUM -y -R 120 -d 0 -e 0 update yum
$YUM -y -R 10 -e 0 -d 0 update
{% endcodeblock %}

Make sure you setup executable permission:

{% codeblock %}
[root@server ~]# chmod +x /etc/cron.weekly/yum.sh
{% endcodeblock %}

Using crontab, we can schedule jobs (commands or shell scripts) to run periodically at certain times or dates, see [wiki page](http://en.wikipedia.org/wiki/Cron) for further reading.