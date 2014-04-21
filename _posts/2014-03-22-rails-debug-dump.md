---
layout: post
title: "Rails Debug Dump"
date: 2014-03-22 07:32
comments: true
categories: rubyonrails
---

For displaying debug dump in Rails on development environment,
edit `application.html.erb`. Add this lines inside the `<body>` tag.

{% highlight erb %}
<body>
  <%= yield %>
  <%= debug(params) if Rails.env.development? %>
</body>
{% endhighlight %}

<!-- more -->

To make things look nicer add some SCSS.

{% highlight scss %}
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
{% endhighlight %}
