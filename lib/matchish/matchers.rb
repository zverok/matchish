# encoding: utf-8
require_relative 'context'

module Matchish
  class Matcher
    def initialize(pattern)
      @pattern = pattern
    end

    def ===(object)
      match?(object)
    end

    def to_a
      [SplatMatcher.new(self)]
    end

    def which(options)
      WhichMatcher.new(self, options)
    end

    def with(options)
      WithMatcher.new(self, options)
    end

    #def including(*values)
      #IncludingMatcher.new(self, *values)
    #end

    def dup
      self.class.new(@pattern)
    end

    protected

    def match?(object, context = nil)
      pre_match(context)
      match_internal?(object).tap do |res|
        post_match(object, res)
      end
    end

    def pre_match(context)
      @context = context || Context.new
      @context.increase!
    end

    def post_match(object, res)
      @context.decrease!
      @context = nil
    end

    def match_internal?(object)
      match_pattern?(@pattern, object)
    end

    def match_pattern?(pattern, object)
      case pattern
      when Matcher
        pattern.match?(object, @context)
      else
        pattern === object
      end
    end
  end

  class ArrayMatcher < Matcher
    def including
      ArrayIncludingMatcher.new(@pattern)
    end

    def match_internal?(object)
      # FIXME: for real production code, we should support splat matcher
      # in any position; and even several splat matchers.
      # But for showcase, it's enough
      if @pattern.last.is_a?(SplatMatcher)
        return false if (@pattern.length - 1) > object.length
        normal = object[0...@pattern.length-1]
        splat = object[@pattern.length-1..-1] || []
        
        @pattern[0..-2].zip(object).all?{|p, o| match_pattern?(p, o)} &&
          match_pattern?(@pattern.last, splat)
      else
        @pattern.length == object.length && 
          @pattern.zip(object).all?{|p, o| match_pattern?(p, o)}
      end
    end
  end

  class HashMatcher < Matcher
    def match_internal?(object)
      # FIXME: it's again "showcase-strenght solution.
      # It implies not only key/value pairs matching, but also
      # matching of the order!
      object.is_a?(Hash) && @pattern.length == object.length && 
        @pattern.to_a.zip(object.to_a).all?{|(pk,pv), (ok,ov)|
          match_pattern?(pk, ok) && match_pattern?(pv, ov)
        }
    end
  end

  class IncludingMatcher < Matcher
    def initialize(base_pattern, *include_patterns)
      super(base_pattern)
      @include_patterns = include_patterns
    end
    
    def match_internal?(object)
      super(object) &&
        @include_patterns.all?{|p|
          object.detect{|o| match_pattern?(p, o)}
        }
    end
  end

  class SplatMatcher < Matcher
    def match_internal?(object)
      object.all?{|o| match_pattern?(@pattern.dup, o)}
    end
  end

  class AnyMatcher < Matcher
    def initialize(*)
      super(nil)
    end
    
    def match_internal?(object)
      true
    end
  end

  class WithMatcher < Matcher
    def initialize(pattern, attrs)
      super(pattern)
      @attrs = attrs
    end

    def match_internal?(object)
      super(object) &&
        @attrs.all?{|a, v| match_pattern?(v, object.send(a))}
    end
  end

  class WhichMatcher < Matcher
    def initialize(pattern, methods)
      super(pattern)
      @methods = methods
    end

    def match_internal?(object)
      super(object) &&
        @methods.all?{|m, *args| object.send(m, *args)}
    end
  end
end

require_relative 'core_ext'
