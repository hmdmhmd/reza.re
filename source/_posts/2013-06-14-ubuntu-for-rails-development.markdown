---
layout: post
title: "Ubuntu for Ruby on Rails Development"
date: 2013-06-14 06:55
comments: true
categories: rubyonrails
---

Setting up Ubuntu for [Ruby on Rails](http://rubyonrails.org) development is very easy. Even it's not as easy
as installing Rails in Windows, developing Rails in Ubuntu is way better than in
Windows. I will show you how to build a good environment for Rails development in
Ubuntu 13.04 (and work on lower version to).

<!-- more -->

## Installing Ruby Version Manager (RVM)
Before installing [RVM](http://rvm.io), Ruby, RubyGems, Rails, etc we need install some required packages
including git and nodejs.

    $ sudo apt-get install build-essential curl git git-core nodejs

RVM is a command-line tool which allows you to easily install, manage, and work
with multiple ruby environments from interpreters to sets of gems. Install RVM
from command-line:

    $ curl -L https://get.rvm.io | bash

To get RVM work flawlessly we need to add a line to `.bashrc` on our home directory.

    $ echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"' >> ~/.bashrc

That line will load RVM into a shell session as a function. Check our RVM installation
from command-line:

    $ type rvm | head -1

If the output is `rvm is a function` we have a very functionally RVM. Installing Ruby need several
additional packages, we can use RVM to automatically install those packages:

    $ rvm requirements

After installing additional packages we can start install Ruby using RVM.

_Notes: This RVM installation method is for single user only, to install for multi user
run those commands from root._

## Installing Ruby on Rails
We use RVM to install Ruby binary, with RVM we can install many version of Ruby and simply manage it. To see
list of Ruby version:

    $ rvm list known

To install Ruby 1.9.3-p429 or Ruby 2.0.0-p0

    $ rvm install 1.9.3
    $ rvm install 2.0.0p0

RVM will automatically install Ruby and RubyGems. If there are no Ruby binaries available, RVM will build it for source.
This may take a while depending on our CPU. Set a Ruby version to use it as default Ruby:

    $ rvm use 1.9.3 --default

After we have a working Ruby binary, we can installing Rails by using:

    $ gem install rails --no-rdoc --no-ri

If you do not want install rdoc and ri documentation every installing a gem, add this line to `.gemrc` on home directory:

    $ echo 'gem: --no-rdoc --no-ri' >> ~/.gemrc

You may have to create `.gemrc` manually.

## Git Configuration
Now that you have Git installed, it's time to configure your settings.

### Username and Email
First you need to tell git your name, so that it can properly label the commits you make.

    $ git config --global user.name "Your Name Here"

Git saves your email address into the commits you make.

    $ git config --global user.email "your_email@example.com"

After setting up the basic environment you are ready to create Rails project. The advance environment (database, deployment, etc) are in the second part of this post.
