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

  def insert(value)
    current_node = self.root
    # traverse nodes until reaching leaf
    loop do
      if value == current_node.data
        puts 'Duplicate value found - node not inserted.'
        return
      elsif value < current_node.data
        if current_node.left.nil? && current_node.right.nil? then break end

        current_node = current_node.left
      elsif value > current_node.data
        if current_node.left.nil? && current_node.right.nil? then break end

        current_node = current_node.right
      end
    end
    # create node on appropriate side of leaf
    if value < current_node.data
      current_node.left = Node.new(value)
    else
      current_node.right = Node.new(value)
    end
  end

  def delete(value)
    current_node = self.root
    # traverse nodes until reaching leaf
    loop do
      if value < current_node.data
        # delete leaf
        if value == current_node.left.data
          if current_node.left.left.nil? && current_node.left.right.nil?
            current_node.left = nil
            break
          end
        end
        # delete node with 1 child

        current_node = current_node.left
      elsif value > current_node.data
        # delete leaf
        if value == current_node.right.data
          if current_node.right.left.nil? && current_node.right.right.nil?
            current_node.right = nil
            break
          end
        end
        # delete node with 1 child
        
        current_node = current_node.right
      end
    end
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

new_tree = Tree.new
array = [1, 2, 3, 4, 5, 6, 7, 8, 9]
new_tree.build_tree(array, 0, array.length - 1)
# new_tree.pretty_print
new_tree.insert(5)
new_tree.pretty_print
new_tree.delete(7)
new_tree.pretty_print
