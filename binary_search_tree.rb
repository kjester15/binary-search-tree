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
      puts current_node.data
      if value == current_node.data
        puts 'Duplicate value found - node not inserted.'
        return
      elsif value < current_node.data
        if current_node.left.nil? then break end

        current_node = current_node.left
      elsif value > current_node.data
        if current_node.right.nil? then break end

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
      puts current_node.data
      if value < current_node.data
        # delete leaf - DONE
        if value == current_node.left.data
          if current_node.left.left.nil? && current_node.left.right.nil?
            current_node.left = nil
            break
          # delete node with 1 child
          elsif current_node.left.left.nil? || current_node.left.right.nil?
            if current_node.left.left.nil?
              current_node.left = current_node.left.right
            else
              current_node.left = current_node.left.left
            end
            break
          # delete node with 2 children (find next biggest - look in right subtree, replace node to be deleted with left subtree of furthest right node)
          else
          
            break
          end
        end
        current_node = current_node.left
      elsif value > current_node.data
        if value == current_node.right.data
          # delete leaf - DONE
          if current_node.right.left.nil? && current_node.right.right.nil?
            current_node.right = nil
            break
          # delete node with 1 child
          elsif current_node.right.left.nil? || current_node.right.right.nil?
            if current_node.right.left.nil?
              current_node.right = current_node.right.right
            else
              current_node.right = current_node.right.left
            end
            break
          # delete node with 2 children
          else

            break
          end
        end
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
array = [20, 30, 32, 34, 36, 40, 50, 60, 65, 66, 70, 75, 80, 85]
new_tree.build_tree(array, 0, array.length - 1)
new_tree.pretty_print
new_tree.insert(31)
new_tree.pretty_print
# new_tree.delete(60)
# new_tree.pretty_print
