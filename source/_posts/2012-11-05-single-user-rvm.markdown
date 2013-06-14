---
layout: post
title: "Single User RVM"
date: 2012-11-05 00:32
comments: true
categories: ruby
---

Using RVM we can manage multiple Ruby version along with it's gemsets. Installing RVM for single user is very easy, especially on Ubuntu. Install `build-essential` and `git-core` package.

{% codeblock %}
$ sudo apt-get install build-essential git git-core curl
$ bash
{% endcodeblock %}

Next, install RVM using `curl` from the terminal.

{% codeblock %}
$ curl -L https://get.rvm.io | bash -s stable
{% endcodeblock %}

Add these following line into `bashrc` file.

{% codeblock %}
$ echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"' >> ~/.bashrc
$ . .bashrc
{% endcodeblock %}

To test if our installation of RVM was succesfull, we can run a command and check its output.

{% codeblock %}
$ type rvm | head -1
rvm is a function
{% endcodeblock %}

If the output of the above command is equivalent to rvm is a function, then we now have a working RVM installation. To install additional RVM dependencies, run the following command:

{% codeblock %}
$ rvm requirements
{% endcodeblock %}

Now we have fully working RVM with dependencies. Now we can install Ruby using RVM command.

{% codeblock %}
$ rvm install 1.9.3
$ rvm use 1.9.3 --default
{% endcodeblock %}
