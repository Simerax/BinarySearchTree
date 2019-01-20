# TODO: Write documentation for `BinarySearchTree`
module BinarySearchTree
  VERSION = "0.1.6"

  # The Node Class is used to create Binary Trees.
  # Every Node holds *data*.
  # Every Node can have a *left* and a *right* child.
  # Non existing Childs are **nil**
  #
  # ```
  # root = BinarySearchTree::Node(Int32).new(15)
  # root.insert(5)        # will be the left child of root
  # root.insert(20)       # will be the right child of root
  # root.insert(18)       # will be the left child of '20'
  # root.find(20)         # => BinarySearchTree::Node(Int32)
  # root.find(256)        # => nil
  # root.delete_node(18)  # => true
  # root.delete_node(256) # => false
  # ```
  class Node(T)
    # *left* child of the `Node(T)`
    property left : Node(T) | Nil

    # *right* child of the `Node(T)`
    property right : Node(T) | Nil

    # *parent* of the `Node(T)`
    property parent : Node(T) | Nil

    # *data* which is being hold by the `Node(T)`
    property data : T

    def initialize(@data, @parent = nil)
      left = nil
      right = nil
    end

    # Balances the tree
    #
    # This Process is time and memory consuming and should not be done often
    #

    def balance
      data = Array(T).new

      self.traverse_inorder do |e|
        data << e.data
      end
      if data.size > 0
        self.data = data[middle_index(data)]
        self.left = nil
        self.right = nil
        middle_value(data, self)
      end
    end

    private def middle_value(input : Array(T), node : Node(T))
      if input.size == 1
        node.insert(input[0])
      else
        middle = middle_index(input)
        node.insert(input[middle])
        middle_value(input[0...middle], node)
        middle_value(input[middle + 1..input.size - 1], node)
      end
    end

    private def middle_index(arr : Array(T))
      (arr.size / 2).as(Int32)
    end

    # Inserts a new element into the tree
    #
    #
    # Insertion is done by finding a `Node(T)` which does not have a child yet and appending it to that one (by creating a new `Node(T)`)
    # The Child is being inserted in the *left* child if the data is smaller then the one of the current `Node(T)` otherwise in the *right* one
    #
    # ```
    # root = BinarySearchTree::Node(Int32).new(15)
    # root.insert(5)
    # ```
    def insert(val : T)
      insert(Node(T).new(val))
    end

    def insert(node : Node(T))
      if root = self
        while root
          if root.data == node.data
            return false
          elsif node.data < root.data
            if left_child = root.left
              root = left_child
            else
              root.left = node
              node.parent = root
              return true
            end
          elsif node.data > root.data
            if right_child = root.right
              root = right_child
            else
              root.right = node
              node.parent = root
              return true
            end
          end
        end
      end
      return false
    end

    # Recursive Version of the `insert` method
    def insert_recursive(val : T)
      insert_recursive(Node(T).new(val))
    end

    def insert_recursive(node : Node(T))
      if self == node || self.data == node.data
        return false
      else
        if node.data <= self.data
          if left = @left
            return left.insert(node)
          else
            @left = node
            node.parent = self
            return true
          end
        else
          if right = @right
            return right.insert(node)
          else
            @right = node
            node.parent = self
            return true
          end
        end
      end
    end

    # Finds an Element in the tree by the *data* it contains
    #
    # In case the element is not found **nil** is returned
    #
    # ```
    # root = BinarySearchTree::Node(Int32).new(15)
    # root.insert(20)
    # root.insert(26)
    # root.insert(22)
    # root.find(26)  # => BinarySearchTree::Node(Int32)
    # root.find(256) # => nil
    # ```
    def find(val : T)
      if root = self
        while root
          if root.data == val
            return root
          elsif val < root.data
            if left_child = root.left
              root = left_child
            else
              return nil
            end
          elsif val > root.data
            if right_child = root.right
              root = right_child
            else
              return nil
            end
          end
        end
      else
        return nil
      end
    end

    # Recursive version of the `find` method
    def find_recursive(val : T)
      if self.data == val
        return self
      else
        if val <= self.data
          if left = @left
            return left.find(val)
          else
            return nil
          end
        else
          if right = @right
            return right.find(val)
          else
            return nil
          end
        end
      end
    end

    # NO NO NO | Should never be called directly! | NO NO NO
    #
    # NO NO NO
    def remove_parent_relation
      if self.parent != nil
        if par = self.parent
          if par.left == self
            par.left = nil
          elsif par.right == self
            par.right = nil
          else
            raise "Node has a parent but the parent does not have the given node as child!"
          end
        end
      end
    end

    # deletes the `Node(T)` with the given *val*. This method does only delete the specific `Node(T)` and not the childs/subtree of the given `Node(T)`
    #
    #
    #
    # ```
    # root = BinarySearchTree::Node(Int32).new(5)
    # root.insert(4)
    #
    # root.delete_node(4) # => true
    # root.delete_node(4) # => false
    # ```
    #
    def delete_node(val : T)
      # ntd = note to delete
      if ntd = self.find(val)
        # no child nodes
        if ntd.left == nil && ntd.right == nil
          ntd.remove_parent_relation
          ntd = nil
          GC.collect
          return true
          # left child but no right child
        elsif ntd.left != nil && ntd.right == nil
          ntd.remove_parent_relation
          if par = ntd.parent
            if left_child = ntd.left
              par.insert(left_child)
              ntd = nil
              GC.collect
              return true
            else
              return false
            end
          end
          # right child but no left child
        elsif ntd.left == nil && ntd.right != nil
          ntd.remove_parent_relation
          if par = ntd.parent
            if right_child = ntd.right
              par.insert(right_child)
              ntd = nil
              GC.collect
              return true
            else
              return false
            end
          end
          # left and right child
        elsif ntd.left != nil && ntd.right != nil
          # smallest_node = ntd.find_smallest_child
          if r_child = ntd.right
            # We look for the smallest Child in the right subtree.
            # every value in that Subtree has to be bigger then any value of the left subtree
            # it is also smaller than any other value from the right subtree.
            # This means it is right in between and is a perfect fit for our node
            smallest_node = r_child.find_smallest_child

            ntd.data = smallest_node.data
            smallest_node.remove_parent_relation # we have to break the relation to the parent otherwise the GC wont collect it

            # If the smallest_node has a right subtree we need to update the reference
            if smallest_node_right_child = smallest_node.right
              ntd.right = smallest_node_right_child
              smnr_parent = ntd
            end

            smallest_node = nil
            GC.collect
            return true
          else
            return false
          end
        end
      end
      return false
    end

    # Finds the smallest child of the given `Node(T)`
    def find_smallest_child
      if left = @left
        return left.find_smallest_child
      else
        return self
      end
    end

    # traverses the tree in 'preorder'. *&block* is called on every `Node(T)`
    def traverse_preorder(&block : Node(T) -> Nil)
      block.call(self)
      if left = @left
        left.traverse_preorder(&block)
      end
      if right = @right
        right.traverse_preorder(&block)
      end
    end

    # traverses the tree in 'inorder' (sorted from smallest to largest). *&block* is called on every `Node(T)`
    def traverse_inorder(&block : Node(T) -> Nil)
      if left = @left
        left.traverse_inorder(&block)
      end
      block.call(self)
      if right = @right
        right.traverse_inorder(&block)
      end
    end

    # traverses the tree in 'postorder'. *&block* is called on every `Node(T)`
    def traverse_postorder(&block : Node(T) -> Nil)
      if left = @left
        left.traverse_postorder(&block)
      end
      if right = @right
        right.traverse_postorder(&block)
      end
      block.call(self)
    end
  end
end
