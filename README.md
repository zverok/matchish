# Matchish

*Matchish* is an exercise in implementing pattern-matching for Ruby. It
is *not* a production-level code (and *not* released as a gem therefore),
but just a proof-of-concept.

You can look at corresponding [blog post](http://zverok.github.io/blog/***)
to see the rationale and overview, and also the rationale of why it is
not a gem.

Nevertheless, features:

* As natural to Ruby as it could be:

```ruby
require 'matchish'
require 'matchish/ma' # shortening of all "matchish" to "ma"
include Ma

case arg
when String # your usual Ruby check
when Fixnum.ma.guard{|x| x > 3} # Matchish!
when [any.as(:x), *any].ma # Matchish!

end

# Or, another example:

%w[one two three].grep(/tw/) # your usual Ruby grep
%w[one two three].grep(String.ma(length: 3)) # Matchish!
```

* Complex patterns and Ruby types being algebraic

```ruby
case arg
when [{test: String.ma}.ma, any, *Hash.ma].ma
  # catches ONLY array with:
  # * first item being a hash with exactly one key: :test, and value - kind of string,
  # * second item being any value
  # * then any number of items, each of them should be hashes
when Time.ma(year: 2015)
  # catches ONLY time with year == 2015
end
```

* On-the-fly deconstruction

```ruby
# local variable flavor
case arg
when [(x = Fixnum.ma), x, *any] # matches [1,1,3,4], but not [1,2,3,4]
  p x.value # => 1
end

# as/match flavor
case arg
when [Fixnum.ma.as(:x), any.as(:x), *any] # matches [1,1,3,4], but not [1,2,3,4]
  p Matchish.last_match[:x] # => 1
end
```

* Guards

```ruby
flag = true

case x
when (1..3).ma.guard{flag} # only matches when flag is true
when (1..3) # matches otherwise
end
```

## Playing with code

```
git clone git@github.com:zverok/dokaz.git
bundle install
bundle exec dokaz Article.md
```

NB: several examples from Article.md are failing. It's ok - they are showing,
exactly, parts of Ruby syntax which are NOT working.
