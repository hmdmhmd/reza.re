---
layout: post
title: "Pow and Chruby"
date: 2014-04-21 11:50:26
tags: rails
---

[Pow](http://pow.cx) is a zero-config Rack server for Mac OS X. Have it serving your apps
locally in under a minute.

# Install Pow

To install or upgrade Pow, open a terminal and run this command:

    $ curl get.pow.cx | sh

To set up a Rack app, just symlink it into `~/.pow`:

    $ cd ~/.pow
    $ ln -s /path/to/myapp

That’s it! Your app will be up and running at [`http://myapp.dev`](#).
See the user’s [manual](http://pow.cx/manual.html) for more information.

# Pow with `chruby`
To make Pow works with `chruby`, add `.powrc` file to our application root folder.

{% highlight bash %}
source /usr/local/opt/chruby/share/chruby/chruby.sh
chruby ruby-2.1.1
{% endhighlight %}

Now, you can access your app in your browser at [`http://myapp.dev`](#).
