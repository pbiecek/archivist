---
layout: page
title: Categories
---

<!-- thanks to Houssain Mohd Faysel, https://stackoverflow.com/questions/20945944/jekyll-liquid-output-category-list-with-post-count/21080786#21080786 .  Adapted slightly.-->

<ul class="tag-box inline">
{% assign tags_list = site.categories %}  
  {% if tags_list.first[0] == null %}
    {% for tag in tags_list %} 
      <li><a href="#{{ tag }}">{{ tag | capitalize }} <span>{{ site.tags[tag].size }}</span></a></li>
    {% endfor %}
  {% else %}
    {% for tag in tags_list %}
    {% assign post_number = tag[1].size %}
      <li><a href="#{{ tag[0] }}">{{ tag[0] | capitalize }}: <span>{{ post_number }} </span><span>
      {% if post_number > 1 %}
        {{ 'posts' }}
      {% else %}
        {{ 'post' }}
      {% endif %}
      </span></a></li>
    {% endfor %}
  {% endif %}
  {% assign tags_list = nil %}
  
  
</ul>
{% for tag in site.categories %} 
  <h2 id="{{ tag[0] }}">{{ tag[0] | capitalize }}</h2>
  <ul class="post-list">
    {% assign pages_list = tag[1] %}  
    {% for post in pages_list %}
      {% if post.title != null %}
      {% if group == null or group == post.group %}
      <li><a href="{{ site.baseurl }}{{ post.url }}" class = "post-title">
            {{ post.title }}<span class="entry-date"><time datetime="{{ post.date | date_to_xmlschema }}" itemprop="datePublished">:  {{ post.date | date: "%B %d, %Y" }}</time></span></a></li>
      {% endif %}
      {% endif %}
    {% endfor %}
    {% assign pages_list = nil %}
    {% assign group = nil %}
  </ul>
{% endfor %}
