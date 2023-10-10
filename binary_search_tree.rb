require 'pry-byebug'

class Node
  attr_accessor :data, :left, :right

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end

  # include comparable module
end

class Tree
  attr_accessor :root, :array

  def initialize
    @root = nil
    @array = nil
  end

  def build_tree(array, start_point, end_point)
    if start_point > end_point then return end

    mid_point = (start_point + end_point) / 2
    @root = Node.new(array[mid_point])
    @root.left = Tree.new.build_tree(array, start_point, mid_point - 1)
    @root.right = Tree.new.build_tree(array, mid_point + 1, end_point)

    @root
  end

  def insert(value, node = root)
    # return nil if node exists
    return nil if value == node.data

    # create a new node with value if tree has no root node
    if node.nil?
      Node.new(value)
    end

    # if not empty, recursively find end of tree
    if value < node.data
      node.left.nil? ? node.left = Node.new(value) : insert(value, node.left)
    else
      node.right.nil? ? node.right = Node.new(value) : insert(value, node.right)
    end
  end

  def delete(value, node = root)
    # base case - return root if node is nil
    if node.nil?
      node
    end

    # recursively find node to delete
    if node.data > value
      node.left = delete(value, node.left)
      return node
    elsif node.data < value
      node.right = delete(value, node.right)
      return node
    end

    # if one child is empty
    if node.left.nil?
      temp = node.right
      node = nil
      return temp
    elsif node.right.nil?
      temp = node.left
      node = nil
      return temp
    end

    # if both children exist
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

new_tree = Tree.new
array = [20, 30, 35, 40, 50, 60, 65, 70, 75, 80, 85, 90]
new_tree.build_tree(array, 0, array.length - 1)
new_tree.insert(76)
new_tree.pretty_print
new_tree.delete(40)
new_tree.pretty_print