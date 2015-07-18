$LOAD_PATH.unshift 'lib'
require 'rspec'
require 'rspec/mocks'
include RSpec::Mocks::ArgumentMatchers

require 'matchish/matchers'
require 'matchish/decompose/bind'
require 'matchish/decompose/as'
include Matchish
