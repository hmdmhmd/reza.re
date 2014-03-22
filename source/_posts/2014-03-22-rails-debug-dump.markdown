---
layout: post
title: "Rails Debug Dump"
date: 2014-03-22 07:32
comments: true
categories: rubyonrails
---

For displaying debug dump in Rails on development environment,
edit `application.html.erb`. Add this lines inside the `<body>` tag.

{% codeblock application.html.erb lang:erb %}
...

<body>
  <%= yield %>
  <%= debug(params) if Rails.env.development? %>
</body>

...
{% endcodeblock %}

<!-- more -->

To make things look nicer add some SCSS.

{% codeblock debug.css.scss lang:scss %}
@mixin box_sizing {
 -moz-box-sizing: border-box;
 -webkit-box-sizing: border-box;
 box-sizing: border-box;
}

.debug_dump {
  clear: both;
  float: left;
  width: 100%;
  margin-top: 45px;
  @include box_sizing;
}
{% endcodeblock %}

The debug dump code will look something like this.

{% img /images/image_post/debug_dump.png %}
