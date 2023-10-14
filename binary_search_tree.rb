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

  def insert(value, node = @root)
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

  def delete(value, node = @root)
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
    # if both children exist
    else
      successor_parent = node
      # find successor
      successor = node.right
      # while loop traverses left down right subtree until no further left options
      while !successor.left.nil?
        successor_parent = successor
        successor = successor.left
      end

      if successor_parent != node
        successor_parent.left = successor.right
      else
        successor_parent.right = successor.right
      end

      # copy successor data to root
      node.data = successor.data

      # delete successor and return root
      successor = nil
      node
    end
  end

  def find(value, node = @root)
    # base case
    if node.nil?
      nil
    end

    # recursively find node to delete
    if node.data > value
      found_node = find(value, node.left)
      return found_node
    elsif node.data < value
      found_node = find(value, node.right)
      return found_node
    end

    # return node if found, otherwise nil
    node.data == value ? node : nil
  end

  def level_order_iterate
    # iteration method
    return nil if self.root.nil?

    current_node = self.root
    queue = [current_node]
    values = []
    loop do
      values << queue[0].data
      queue.shift
      unless current_node.left.nil? then queue << current_node.left end

      unless current_node.right.nil? then queue << current_node.right end

      current_node = queue[0]
      break if queue.empty?
    end

    values
  end

  def level_order_recursive(queue = [root], values = [], node = @root)
    # recursion method
    # base case
    return if queue.empty?

    values << queue[0].data
    queue.shift

    unless node.left.nil? then queue << node.left end
    unless node.right.nil? then queue << node.right end

    unless queue.empty?
      level_order_recursive(queue, values, queue[0])
    end

    values
  end

  def inorder(values = [], node = @root)
    if node.nil? then return end

    inorder(values, node.left)
    values << node.data
    inorder(values, node.right)

    values
  end

  def preorder(values = [], node = @root)
    if node.nil? then return end

    values << node.data
    preorder(values, node.left)
    preorder(values, node.right)

    values
  end

  def postorder(values = [], node = @root)
    if node.nil? then return end

    postorder(values, node.left)
    postorder(values, node.right)
    values << node.data

    values
  end

  def height(node = @root, left = 0, right = 0)
    if node.nil? then return end
    # track size of left and right sides
    unless node.left.nil?
      left += 1
      left += height(node.left)
    end
    unless node.right.nil?
      right += 1
      right += height(node.right)
    end
    # return greater of two sides
    if left > right
      left
    elsif right > left
      right
    else
      left
    end
  end

  def depth(node = @root, value, count)
    if node.nil? then return end

    if value < node.data
      count += 1
      depth(node.left, value, count)
    elsif value > node.data
      count += 1
      depth(node.right, value, count)
    elsif value == node.data
      count
    end
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
# new_tree.pretty_print
new_tree.delete(35)
new_tree.pretty_print
puts new_tree.find(65)
p new_tree.level_order_iterate
p new_tree.level_order_recursive
p new_tree.inorder
p new_tree.preorder
p new_tree.postorder
puts new_tree.depth(80, 0)
puts new_tree.height
