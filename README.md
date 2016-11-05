# BatchTranslations

Helper that renders globalize_translations fields on a per-locale basis, so you can use them
separately in the same form and still saving them all at once in the same request.

This is forked from https://github.com/wooandoo/batch_translations
and based on work from Szymon Fiedler & Jose Alvarez Rilla

## Changes

 * converted into a gem.
 * fixed to work with rails-bootstrap-forms

There are no tests.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'batch_translations'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install batch_translations
```

## Model configuration

In model, which uses Globalize after definition

```ruby
translates :title, :teaser, :body # or any other fields, which you translate
```

place

```ruby
accepts_nested_attributes_for :translations
```

so it'll look like

```ruby
  class Post < ActiveRecord::Base
    translates :title, :teaser, :body

    accepts_nested_attributes_for :translations
    class Translation
      attr_accessible :locale # mandatory to read a locale version that doesn't exist yet
      attr_accessible :title, :teaser, :body, :locale, as: :admin
    end
  end
```

Is necessary for it work properly.

## Usage

Now, use it in your view file, like as below:

```html+erb
  <h1>Editing post</h1>

  <%= form_for(@post) do |f| %>
    <%= f.error_messages %>

    <h2>English (default locale)</h2>
    <p><%= f.text_field :title %></p>
    <p><%= f.text_field :teaser %></p>
    <p><%= f.text_field :body %></p>

    <hr/>

    <h2>Spanish translation</h2>
    <%= f.globalize_fields_for :es do |g| %>
      <p><%= g.text_field :title %></p>
      <p><%= g.text_field :teaser %></p>
      <p><%= g.text_field :body %></p>
    <% end %>

    <hr/>

    <h2>French translation</h2>
    <%= f.globalize_fields_for :fr do |g| %>
      <p><%= g.text_field :title %></p>
      <p><%= g.text_field :teaser %></p>
      <p><%= g.text_field :body %></p>
    <% end %>

    <%= f.submit "Save" %>
  <% end %>
```

## Contributing

Fork, test, pull-request.

## License

Copyright (c) 2010 Szymon Fiedler http://github.com/fidel, released under MIT License.
