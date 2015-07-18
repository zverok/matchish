# encoding: utf-8
require_relative '../lib/matchish'
require_relative '../lib/matchish/ma'

# a) .as(name) flavour

p [Fixnum.ma.as(:i), 2, Fixnum.ma.as(:i)].ma === [1, 2, 1]
p Matchish.last_match

p [Fixnum.ma.as(:i), 2, Fixnum.ma.as(:i)].ma === [1, 2, 3]

# b) x = matcher flavour

pattern = [i = Fixnum.ma, 2, i].ma

p pattern === [1, 2, 1]
p i.value

# rebound after evaluation
p pattern === [5, 2, 5]
p i.value

p pattern === [1, 2, 3]

