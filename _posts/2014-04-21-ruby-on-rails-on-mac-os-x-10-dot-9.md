---
layout: post
title: "Ruby on Rails on Mac OS X 10.9"
date: 2014-04-21 07:06:25
tags: rails
---

This is simple guide to setting up [Ruby on Rails](http://rubyonrails.org)
development environment on Mac OS X 10.9 Mavericks *without modifying core files*.
Older versions of OS X are mostly compatible with this guide, if you run into a problem,
then try Googling it.

#  Command Line Tools
First of all we need Command Line Tools from the terminal.

    $ xcode-select --install

We will see pop-up window appear asking to install.

#  Homebrew
[Homebrew](http://brew.sh) allow us to install and compile software packages
we need that Apple didn’t provide. It is similar to [MacPorts](http://www.macports.org).
To install Homebrew, run this command:

    $ ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"

Now check our Homebrew configurations.

    $ brew doctor

Check Homebrew by installing some packages.

    $ brew install sqlite wget

For more information about Homebrew, visit the wiki page on
[GitHub](https://github.com/Homebrew/homebrew/wiki).

# Ruby with Chruby
[`Chruby`](https://github.com/postmodern/chruby) is a very simple Ruby version manager,
we are using `chruby` for change the current Ruby. To install Ruby we need to install
`ruby-build` using Homebrew.

    $ brew install chruby ruby-build

Install Ruby using `ruby-build` in `~/.rubies` directory.

    $ ruby-build 2.1.1 ~/.rubies/ruby-2.1.1
    $ chruby 2.1.1

Sit back and wait for it to finish. After Ruby installed, add this line to `~/.bashrc`
or `~/.zshrc` if we are using `zsh`.

{% highlight bash %}
source /usr/local/opt/chruby/share/chruby/auto.sh
source /usr/local/opt/chruby/share/chruby/chruby.sh
chruby ruby-2.1.1
{% endhighlight %}

For skip installing gems doc.

    echo 'gem: --no-document' >> ~/.gemrc

# Rails Gem
Installing Rails is very simple after we've install Ruby.

    $ gem install rails

Verify our Rails version.

    $ rails -v

# Configure Git
We'll be using Git for our version control system so we're going to set it up
to match our [GitHub](https://github.com) account. If you don't already have a GitHub account,
make sure to register. It will come in handy for the future.

    $ git config --global color.ui true
    $ git config --global user.name "User Example"
    $ git config --global user.email "user@example.com"
    $ ssh-keygen -t rsa -C "user@example.com"

Run the following code to copy the key to your clipboard.

    $ pbcopy < ~/.ssh/id_rsa.pub

Paste it [here](https://github.com/settings/ssh) and see if it worked.

    $ ssh -T git@github.com
    Hi user! You've successfully authenticated, but GitHub does not provide shell access.

# PostgreSQL
Install PostgreSQL from Homebrew.

    $ brew install postgresql

Create a new database (as explained after installing).

    $ initdb /usr/local/var/postgres -E utf8

We are using `lunchy` to will allow us to easily start and stop Postgres.

    $ gem install lunchy
    $ mkdir -p ~/Library/LaunchAgents
    $ cp /usr/local/Cellar/postgresql/9.2.1/homebrew.mxcl.postgresql.plist ~/Library/LaunchAgents/

To start PostgreSQL process.

    $ lunchy start postgres

By default the PostgreSQL user is your current OS X username with no password.

# Final Step
Let's create our first Rails application.

    $ rails new myapp

if we want to using PostgreSQL.

    $ rails new myapp -d postgresql

Check our new application if it worked as we want it.

    $ cd myapp
    $ bundle exec rake db:create
    $ rails s

We can now visit [`http://localhost:3000`](http://localhost:3000) to view our new website.
