module Matchish
  class GuardedMatcher < Matcher
    def initialize(pattern, &block)
      super(pattern)
      @block = block
    end

    def match_internal?(object)
      super(object) && @block.call(object)
    end
  end

  class Matcher
    def guard(&block)
      GuardedMatcher.new(self, &block)
    end
  end
end
