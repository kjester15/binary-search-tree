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
    # return new node if tree is empty
    return nil if value == node.data

    # if not empty, recursively find end of tree
    if value < node.data
      node.left.nil? ? node.left = Node.new(value) : insert(value, node.left)
    else
      node.right.nil? ? node.right = Node.new(value) : insert(value, node.right)
    end
  end

  def delete(value)
    # root = self.root

    # if root.nil?
    #   return root
    # end

    # if value > root.data
    #   root.right = delete(value)
    #   return root
    # elsif value < root.data
    #   root.left = root.left.delete(value)
    #   return root
    # end

    # if root.left.nil?
    #   temp = root.right
    #   return temp
    # elsif root.right.nil?
    #   temp = root.left
    #   return temp
    # end
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
# new_tree.delete(70)
# new_tree.pretty_print