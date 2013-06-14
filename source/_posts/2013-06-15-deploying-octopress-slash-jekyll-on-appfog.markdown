---
layout: post
title: "Deploying Octopress/Jekyll on AppFog"
date: 2013-06-15 04:55
comments: true
categories: octopress
---

Deploying Jekyll or Octopress based website to Heroku is really easy and simple, because Heroku use git for source code management. Heroku will create automatically our server based on our type of application, but we can't choose server location. With AppFog we can choose nearest server from our location. I live in Indonesia, so the nearest infrastucture is AWS Singapore. We can have very little response time compared to Heroku.

## Preparation ##
Deploying to AppFog is not as easy as deploying to Heroku. We need to configure Octopress. Before that, lets install af gem. It's similar to heroku gem.

```
$ gem install af
```

After installing af gem, go to our Octopress directory. Login to AppFog by running the following command:

```
$ af login
```

Create an `app.rb` file to handle `SinatraStaticServer` class.

{% codeblock app.rb lang:ruby %}
require 'bundler/setup'
require 'sinatra'

# The project root directory
$root = ::File.dirname(__FILE__)

  get(/.+/) do
    send_sinatra_file(request.path) {404}
  end

  not_found do
    send_file(File.join(File.dirname(__FILE__), 'public', '404.html'), {:status => 404})
  end

  def send_sinatra_file(path, &missing_file_block)
    file_path = File.join(File.dirname(__FILE__), 'public',  path)
    file_path = File.join(file_path, 'index.html') unless file_path =~ /\.[a-z]+$/i
    File.exist?(file_path) ? send_file(file_path) : missing_file_block.call
  end
{% endcodeblock %}

Create `.afignore`, it's similar to `.gitignore` in git.

{% codeblock .afignore %}
# Local config
config.ru

.sass-cache/
.gist-cache/
.pygments-cache/

.themes/

.gitignore
.gitattributes
{% endcodeblock %}

We include `config.ru` because we already have `app.rb` to handle Sinatra.

## Deploying ##
We can create new AppFog app by using website or directly from command line.

```
$ af push --runtime ruby193
```

Choose Sinatra application not Rack application. Save the configuration file, it's looks like this.

{% codeblock manifest.yml lang:yaml %}
---
applications:
  .:
    name: rezare
    framework:
      name: sinatra
      info:
        mem: 128M
        description: Sinatra Application
        exec: 
    infra: ap-aws
    url: ${name}.${target-base}
    mem: 512M
    instances: 1
{% endcodeblock %}

To update our application run:

```
$ git add .
$ git commit -m "Site updated"
$ af update
```

## Conclusion ##
Using AppFog for deploying Octopress is slightly different than Heroku, but it's offer better response time. AppFog do not use source code management, but we can use GitHub or bitbucket to store our website code. And one more thing, we can not use custom domain on free plans.