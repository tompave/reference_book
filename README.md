# ReferenceBook

A multi-context configuration library and DSL.  
**ReferenceBook** provides an easy interface to define, validate and query **multi-context** configuration data.

What does **multi-context** mean?
Any setting that should be static and that exist in different alternative versions.




## Usage

TODO: Write usage instructions here

## Examples

Lots are available [in the repo](https://github.com/tompave/reference_book/tree/master/examples).




## Features/Problems

* requires Ruby >= 2.0.0
* simple configuration DSL, with validations
* configuration data exists as frozen objects, not namespaced constants
* library and books metaphor
* easy and flexible query interface







## Rubies

**ReferenceBook** requires a Ruby patch level `>= 2.0`.
It doesn't use any _2-only_ syntax features, but it does rely on some core classes' methods that only appeared with MRI 2.0.0.

**MRI**: supported, tested with 2.0 and 2.1.
**JRuby**: tested with 2.0 mode (`JRUBY_OPTS=--2.0 rake test`).
**Rubinius**: not supported, even in 2.1 mode its standard library classes seem to espose a 1.9 interface.


## Tests

`rake test`




## To Do

* add support for different libraries, each with an enforced book structure
* make it work with `Ruby 1.9.3` (involves implementing methods that at the moment are provided by core classes).


## Installation


Add this line to your application's Gemfile:

    gem 'reference_book'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install reference_book


## Contributing

1. Fork it ( https://github.com/[my-github-username]/reference_book/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
