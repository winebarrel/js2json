# js2json

It is a library to convert from JavaScript to JSON.

[![Gem Version](https://badge.fury.io/rb/js2json.png)](http://badge.fury.io/rb/js2json)
[![Build Status](https://drone.io/github.com/winebarrel/js2json/status.png)](https://drone.io/github.com/winebarrel/js2json/latest)

## Installation

Add this line to your application's Gemfile:

    gem 'js2json'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install js2json

## Usage

```ruby
require 'js2json'

json = Js2json.js2json(<<-EOS)
function plus(a, b) {
  return a + b;
};

// Comment
({
  foo: "bar",
  "zoo": plus(1, 2),
  'BAZ': 'A' + 'B',
  plus: plus,
});
EOS

puts json # => {
          #      "foo": "bar",
          #      "zoo": 3,
          #      "BAZ": "AB",
          #      "plus": "function plus(a, b) {\n  return a + b;\n}"
          #    }
```

### Use Ruby in JavaScript

```ruby
require 'js2json'

json = Js2json.js2json(<<-EOS)
Ruby.Kernel.require('net/http');

var page = Ruby.Net.HTTP.start('example.com', 80, function(http) {
  return http.get('/').body();
});

({
  site: 'example.com',
  page: page,
});
EOS
```

### Auto bracket script

```ruby
require 'js2json'

json = Js2json.js2json(<<-EOS, :bracket_script => true)
{
  foo: "bar",
  zoo: "baz",
}
EOS

puts json # => {
          #      "foo": "bar",
          #      "zoo": "baz"
          #    }
```

### Command line tool

    $ echo '{foo:"bar", zoo:"baz"}' | js2json --bracket-script

## Contributing

1. Fork it ( http://github.com/winebarrel/js2json/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
