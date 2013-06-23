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
Ubuntu 13.04 (and work on lower version too).

<!-- more -->

## Installing Ruby Version Manager (RVM)
Before installing [RVM](http://rvm.io), Ruby, Rubygems, Rails, etc we need install some required packages
including git and nodejs.

    $ sudo apt-get install build-essential curl git git-core nodejs

RVM is a command-line tool which allows you to easily install, manage, and work
with multiple ruby environments from interpreters to sets of gems. Install RVM
from command-line:

    $ curl -L https://get.rvm.io | bash

To get RVM work flawlessly we need to add a line to `.bashrc` on your home directory.

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
