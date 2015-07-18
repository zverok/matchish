# encoding: utf-8
require_relative '../lib/matchish'
require_relative '../lib/matchish/ma'
include Matchish

p String.ma(length: (l = any)) === 'wtf'
p l.value

p String.ma(length: (3..5).ma.as(:l)) === 'wtf'
p Matchish.last_match

p String.ma(length: (4..5).ma.as(:l)) === 'wtf'
