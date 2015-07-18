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

class Class
  def matchish(attrs = {})
    attrs.empty? ?
      Matchish::Matcher.new(self) :
      Matchish::TypeMatcher.new(self, attrs)
  end
end
