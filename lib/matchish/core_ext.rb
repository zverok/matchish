# encoding: utf-8
class Object
  def matchish
    Matchish::Matcher.new(self)
  end
end

class Array
  def matchish
    Matchish::ArrayMatcher.new(self)
  end
end

class Hash
  def matchish
    Matchish::HashMatcher.new(self)
  end
end
