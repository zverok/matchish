# encoding: utf-8
module Matchish
  class Matcher
    def bind_value(val)
      @context.bound << self
      @bound_value = val
      @is_bound = true # need this, because just !@bound_value is bad check: bound value can also be nil or false
    end

    # after it, matcher is not bound any more and hypothetically can be used again
    # and catched value can be received
    def unbind!
      @is_bound = false
      @value, @bound_value = @bound_value, nil
    end

    attr_reader :value

    alias_method :match_no_bind?, :match?
    alias_method :post_match_no_bind, :post_match

    def match?(object, context = nil)
      @is_bound ? @bound_value == object : match_no_bind?(object, context)
    end

    def post_match(object, res)
      bind_value(object) if res
      post_match_no_bind(object, res)
    end
  end

  class Context
    alias_method :initialize_no_bind, :initialize
    alias_method :cleanup_no_bind, :cleanup

    def initialize
      initialize_no_bind
      @bound = []
    end

    attr_reader :bound

    def cleanup
      @bound.each{|m| m.unbind!}
      @bound.clear
    end
  end
end
