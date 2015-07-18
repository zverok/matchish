module Matchish
  class Context
    def initialize
      @level = 0
    end

    def increase!
      @level += 1
    end

    def decrease!
      @level -= 1
      @level < 0 and fail("Never should be")
      cleanup if @level.zero?
    end

    def cleanup
    end
  end
end
