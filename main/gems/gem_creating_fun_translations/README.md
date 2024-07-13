# FunTranslations API Ruby interface

![Gem](https://img.shields.io/gem/v/fun_translations)
![CI](https://github.com/bodrovis/fun_translations/actions/workflows/ci.yml/badge.svg)
[![Coverage Status](https://coveralls.io/repos/github/bodrovis/fun_translations/badge.svg?branch=master)](https://coveralls.io/github/bodrovis/fun_translations?branch=master)
[![Maintainability](https://api.codeclimate.com/v1/badges/6ec16854cfb5d7e4df17/maintainability)](https://codeclimate.com/github/bodrovis/fun_translations/maintainability)
![Downloads total](https://img.shields.io/gem/dt/fun_translations)

This is a Ruby client that enables you to easily perform translations using [FunTranslations API](https://api.funtranslations.com/).

*If would like to learn how this gem was built, please check out [this and subsequent lessons](https://www.youtube.com/watch?v=FEfHExlN6-8) on my YT channel (currently only available in Russian).*

## Prerequisites

[Ruby 2.7+](https://www.ruby-lang.org/en/) and [RubyGems subsystem](https://rubygems.org/) is required.

## Installation

Install this gem by running:

```
$ gem install fun_translations
```

Or add it to your `Gemfile`:

```ruby
gem 'fun_translations'
```

And run:

```
bundle install
```

## Usage

Include the client in your script:

```ruby
require 'fun_translations'
```

Next, instantiate the client:

```ruby
client = FunTranslations.client
```

And perform translations:

```ruby
translation_yoda = client.translate :yoda, "Hello, my padawan"
translation_klingon = client.translate :klingon, "We are klingons."
translation_morse = client.translate 'morse/audio', "Morse code is dit and dash."
```

### Additional request parameters

In most cases you will only need to pass the text to translate. However, certain translators (for example, `'morse/audio'`) might require additional params. You can specify these params as a third hash argument:

```ruby
translation_morse = client.translate 'morse/audio', "Morse code is dit and dash.", speed: 5, tone: 700
```

### Translation object

The `translate` method returns an instance of the `FunTranslations::Translation` class. It responds to the following methods:

* `translated_text` — the actual translation result. Please note that in very rare cases this method will return `nil`, specifically, when you are using `'morse/audio'` translator that returns encoded audio only.
* `original_text` — your initial (base) text.
* `translation` — translator that you've chosen.

```ruby
translation_yoda.translated_text # => 'A planet, master obi wan lost'
translation_yoda.original_text # => 'Master Obi Wan lost a planet'
translation_yoda.translation # => 'yoda'
```

There are additional methods available only for "audio" translators:

* `audio` — returns base64-encoded audio stream.
* `speed` — audio speed.
* `tone` — audio tone.

```ruby
translation_morse = client.translate 'morse/audio', "Morse code is dit and dash.", speed: 5, tone: 700

translation_yoda.audio # => 'data:audio/wave;base64,UklGRjiBCQBXQVZFZm1...'
translation_yoda.speed # => '5 WPM'
translation_yoda.tone # => '700 Hz'

# Please note that the `translation` method returns a hash in this case:

translation_yoda.translation['source'] # => 'english'
translation_yoda.translation['destination'] # => 'morse audio'
```

### API token

FunTranslations API has a free pricing plan which does not require registering and obtaining an API key. In other words, you can start using the gem right away. However, please be aware that the free plan allows only 5 requests per hour and 60 requests per day. Therefore, you might want to purchase a paid plan and obtain an API key. Then, simply pass this key when instantiating the client:

```ruby
client = FunTranslations.client('123abc')
```

Then perform translations as usual.

## Running tests

Tests are written in RSpec (all HTTP requests are stubbed):

```
rspec .
```

Observe test results and coverage.

## Copyright and license

Licensed under the [MIT license](./LICENSE.md).

Copyright (c) 2022 [Ilya Krukowski](http://bodrovis.tech)
