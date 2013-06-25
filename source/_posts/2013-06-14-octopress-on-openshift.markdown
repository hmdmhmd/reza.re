---
layout: post
title: "Octopress on OpenShift"
date: 2013-06-14 06:55
comments: true
categories: octopress
---

Deploying [Octopress](http://octopress.org/) or [Jekyll](http://jekyllrb.com/) based website on [GitHub Pages](http://pages.github.com/)
is really easy, just create a repo named `username.github.io` or
create gh-pages branch in the project repository. Or we can deploy it to [Heroku](https://www.heroku.com/). A website generated from
Jekyll is a real static website. What you see is really what you see. The dynamic content laying on embedding Javascript in the html pages.

With [OpenShift](https://www.openshift.com/) we can host Octopress based website like on GitHub pages. We just host the static content and managing it with git. I found two methods to do this. First, just using Webrick server. Second, install nginx on our hosting platform.

<!-- more -->

## The Easy Way
The easy way is the first method. Create an application with _Do It Yourself_ catridge. We can do it from Web console or witn command-line:

    $ rhc app create myapp diy-0.1

Clone our application using git. And create a folder named public. Open `diy/testrubyserver.rb` using text editor, and edit some lines.

{% codeblock testrubyserver.rb lang:ruby %}
#!/usr/bin/env ruby
require 'webrick'
include WEBrick

dir = ENV['OPENSHIFT_REPO_DIR']

config = {}
config.update(:Port => 8080)
config.update(:BindAddress => ARGV[0])
config.update(:DocumentRoot => dir + 'public')
server = HTTPServer.new(config)
['INT', 'TERM'].each {|signal|
  trap(signal) {server.shutdown}
}

server.start
{% endcodeblock %}

We can manually copy our generated website to public folder and push it. Or we can modify `Rakefile` to automatically doing it for us. I made some changes in Octopress default `Rakefile` and posted on gist. Move your app directory to Octopress root directory. Use `rake deploy` to automatically generate and push our website.


## The Less Easy Way
The second method is using nginx as a web server to host our generated website. Ofcourse we have to install nginx first. To do this log in into your
application using ssh. Use `rhc show -a myapp` to see ssh address of our application. Or you can use some repo templates for automatically install nginx
on OpenShift.

    $ ssh <random-string>@myapp-mydomain.rhcloud.com

Now we can start the nginx installation. Navigate to the tmp dir and download the nginx source.

    $ cd $OPENSHIFT_TMP_DIR
    $ wget http://nginx.org/download/nginx-1.4.1.tar.gz
    $ wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.31.tar.bz2
    $ tar jxf pcre-8.31.tar.bz2
    $ tar zxf nginx-1.4.1.tar.gz
    $ cd nginx-1.4.1
    $ ./configure --prefix=$OPENSHIFT_DATA_DIR --with-pcre=$OPENSHIFT_TMP_DIR/pcre-8.31

Now we can compile and install nginx.

    $ make install

See this page to read more about OpenShift environment variables. OpenShift only allow an internal IP address and port for your application which are available through `$OPENSHIFT_DIY_IP` and `$OPENSHIFT_DIY_PORT` enviroment variables. And these values may change. We need to do a little trick here to bind the internal IP address and port in nginx configuration dynamically. I preffer using the `erb` command. Rename the default configuration file.

    $ mv $OPENSHIFT_DATA_DIR/conf/nginx.conf $OPENSHIFT_DATA_DIR/conf/nginx.conf.def

We will modify create the configuration file using when the start action hook is called. Now browse to our app directory, and open
`.openshift/action_hooks/start` using text editor. Add these lines:

{% codeblock start lang:bash %}
#!/bin/bash
# The logic to start up your application should be put in this
# script.

TEMPLATES_DIR=${OPENSHIFT_REPO_DIR}/.openshift/templates
INSTALL_DIR=${OPENSHIFT_HOMEDIR}/app-root/data

erb ${TEMPLATES_DIR}/nginx.conf.erb > ${INSTALL_DIR}/conf/nginx.conf

echo "Starting nginx..."
nohup ${INSTALL_DIR}/sbin/nginx > ${INSTALL_DIR}/logs/server.log 2>&1 &
{% endcodeblock %}

Modify `.openshift/action_hooks/stop` so nginx also stop everytime we make a push.

{% codeblock stop lang:bash %}
#!/bin/bash
# The logic to stop your application should be put in this script.

INSTALL_DIR=${OPENSHIFT_HOMEDIR}/app-root/data

echo "Stopping nginx..."
kill -QUIT `cat ${INSTALL_DIR}/logs/nginx.pid`
exit 0
{% endcodeblock %}

Create a folder named templates on `.openshift` folder. And create file named `nginx.conf.erb` in templates folder.
Content of this file is just default nginx configuration with some modification on `listen` and `location` directive.

{% codeblock nginx.conf.erb %}
...

server {
        listen       <%= ENV['OPENSHIFT_DIY_IP'] %>:<%= ENV['OPENSHIFT_DIY_PORT'] %>;
        server_name  localhost;

...

location / {
            root   <%= ENV['OPENSHIFT_REPO_DIR'] %>/public;
            index  index.html index.htm;
        }

...
{% endcodeblock %}
