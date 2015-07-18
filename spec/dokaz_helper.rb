$LOAD_PATH.unshift 'lib'
require 'rspec'
require 'rspec/mocks'
include RSpec::Mocks::ArgumentMatchers

require 'matchish/matchers'
require 'matchish/ma'
require 'matchish/m'
require 'matchish/decompose/bind'
require 'matchish/decompose/as'
include Matchish
