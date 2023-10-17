require 'pry-byebug'

class Node
  attr_accessor :data, :left, :right

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
end

class Tree
  attr_accessor :root, :array

  def initialize(array)
    @root = nil
    @array = array.sort.uniq
  end

  def build_tree(array = @array, start_point = 0, end_point = array.length - 1)
    if start_point > end_point then return end

    mid_point = (start_point + end_point) / 2
    @root = Node.new(array[mid_point])
    @root.left = Tree.new(array).build_tree(array, start_point, mid_point - 1)
    @root.right = Tree.new(array).build_tree(array, mid_point + 1, end_point)

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

    # recursively find node
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

  def height(value = 0, node = find(value))
    if node.nil? then return -1 end
    # track size of left and right sides
    left_height = height(value, node.left)
    right_height = height(value, node.right)
    # return greater of two sides
    [left_height, right_height].max + 1
  end

  def depth(value, node = @root, count = 0)
    if node.nil? then return end

    if value < node.data
      count += 1
      depth(value, node.left, count)
    elsif value > node.data
      count += 1
      depth(value, node.right, count)
    elsif value == node.data
      count
    end
  end

  def balanced?(node = @root)
    left_height = height(node.left.data)
    right_height = height(node.right.data)
    if (left_height - right_height).abs < 2
      true
    else
      false
    end
  end

  def rebalance
    array = self.inorder
    @root = build_tree(array, 0, array.length - 1)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

# Create a binary search tree from an array of random numbers
array = (Array.new(15) { rand(1..100) }).sort
binary_search_tree = Tree.new(array)
binary_search_tree.build_tree
binary_search_tree.pretty_print

# Confirm that the tree is balanced by calling #balanced?
puts "Balanced?: #{binary_search_tree.balanced?}"

# Print out all elements in level, pre, post, and in order
p "Level: #{binary_search_tree.level_order_recursive}"
p "Inorder: #{binary_search_tree.inorder}"
p "Preorder: #{binary_search_tree.preorder}"
p "Postorder: #{binary_search_tree.postorder}"

# Unbalance the tree by adding several numbers > 100
5.times do
  binary_search_tree.insert(rand(100..200))
end
binary_search_tree.pretty_print

# Confirm that the tree is unbalanced by calling #balanced?
puts "Balanced?: #{binary_search_tree.balanced?}"

# Balance the tree by calling #rebalance
binary_search_tree.rebalance
binary_search_tree.pretty_print

# Confirm that the tree is balanced by calling #balanced?
puts "Balanced?: #{binary_search_tree.balanced?}"

# Print out all elements in level, pre, post, and in order
p "Level: #{binary_search_tree.level_order_recursive}"
p "Inorder: #{binary_search_tree.inorder}"
p "Preorder: #{binary_search_tree.preorder}"
p "Postorder: #{binary_search_tree.postorder}"
