require 'pry-byebug'

class Node
  attr_accessor :value, :left_child, :right_child

  def initialize
    @value = nil
    @left_child = nil
    @right_child = nil
  end

  # include comparable module
end

class Tree
  attr_accessor :root, :array

  def initialize
    @root = nil
    @array = nil
  end
end