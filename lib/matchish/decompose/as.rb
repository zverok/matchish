module Matchish
  class << self
    attr_reader :last_match
  end

  class Context
    alias_method :initialize_no_as, :initialize
    alias_method :cleanup_no_as, :cleanup

    def initialize
      initialize_no_as
      @named = {}
    end

    attr_reader :named

    def cleanup
      cleanup_no_as
      Matchish.instance_variable_set('@last_match', @named)
    end
  end

  class NamedMatcher < Matcher
    def initialize(pattern, name)
      super(pattern)
      @name = name
    end

    def to_a
      [NamedSplatMatcher.new(@pattern, @name)]
    end

    def match_internal?(object)
      if @context.named.key?(@name)
        object == @context.named[@name]
      else
        match_pattern?(@pattern, object)
      end
    end

    def post_match(object, res)
      @context.named[@name] = object if res
      super
    end
  end

  class NamedSplatMatcher < SplatMatcher
    def initialize(pattern, name)
      super(pattern)
      @name = name
    end
    
    def post_match(object, res)
      @context.named[@name] = object if res
      super
    end
  end

  class Matcher
    def as(name)
      NamedMatcher.new(self, name)
    end
  end
end
