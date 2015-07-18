# encoding: utf-8
require_relative '../lib/matchish'
require_relative '../lib/matchish/ma'

# external conditions:

matchme = true
p 'test'.ma.guard{matchme} === 'test'

matchme = false
p 'test'.ma.guard{matchme} === 'test'

# matched object
p 'test'.ma.guard{|s| s.length == 4} === 'test'
