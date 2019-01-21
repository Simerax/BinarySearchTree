require "./spec_helper"

describe BinarySearchTree do
  describe "BinarySearchTree::Node(Int32)" do
    describe "#bulk_insert" do
      it "inserts multiple elements in one call" do
        root = BinarySearchTree::Node(Int32).new(5)
        root.bulk_insert([4, 6, 9, 2, 3, 1])

        preorder = Array(Int32).new
        root.traverse_preorder do |e|
          preorder << e.data
        end
        preorder.should eq [5, 4, 2, 1, 3, 6, 9]
      end

      it "calls the block on every element" do
        root = BinarySearchTree::Node(Int32).new(5)
        root.bulk_insert([4, 6, 9, 2, 3, 1]) do |value, success|
          success.should be_true
        end
      end
    end

    describe "#delete_node_and_childs" do
      it "deletes the given node and its childs" do
        root = createInt32DummyTree([5, 4, 6, 9, 2, 3, 1])
        root.delete_node_and_childs(4).should be_true
        inorder = Array(Int32).new
        root.traverse_inorder do |e|
          inorder << e.data
        end

        inorder.should eq [5, 6, 9]
      end

      it "does not delete non existing values" do
        root = createInt32DummyTree([5, 4, 6, 9, 2, 3, 1])
        root.delete_node_and_childs(256).should be_false
        inorder = Array(Int32).new
        root.traverse_inorder do |e|
          inorder << e.data
        end

        inorder.should eq [1, 2, 3, 4, 5, 6, 9]
      end

      it "does not delete itself" do
        root = createInt32DummyTree([5, 4, 6, 9, 2, 3, 1])
        root.delete_node_and_childs(5).should be_false

        inorder = Array(Int32).new
        root.traverse_inorder do |e|
          inorder << e.data
        end

        inorder.should eq [1, 2, 3, 4, 5, 6, 9]
      end
    end

    describe "#balance" do
      it "rebalances a tree" do
        root = createInt32DummyTree([1, 2, 3, 4, 5, 6, 9])
        root.balance

        preordered = Array(Int32).new
        root.traverse_preorder do |e|
          preordered << e.data
        end

        preordered.should eq [4, 2, 1, 3, 6, 5, 9]
      end

      it "rebalances a empty tree" do
        root = BinarySearchTree::Node(Int32).new(5)
        root.balance

        preordered = Array(Int32).new
        root.traverse_preorder do |e|
          preordered << e.data
        end

        preordered.should eq [5]
      end
      it "rebalances a tree with 2 elements" do
        root = BinarySearchTree::Node(Int32).new(5)
        root.insert(26)
        root.balance

        preordered = Array(Int32).new
        root.traverse_preorder do |e|
          preordered << e.data
        end

        preordered.should eq [26, 5]
      end

      it "rebalances a tree with 3 elements" do
        root = BinarySearchTree::Node(Int32).new(5)
        root.insert(26)
        root.insert(3)
        root.balance

        preordered = Array(Int32).new
        root.traverse_preorder do |e|
          preordered << e.data
        end

        preordered.should eq [5, 3, 26]
      end
    end

    describe "#insert" do
      it "correctly inserts a new element" do
        root = createInt32Node(5)
        root.insert(6).should be_true

        ordered(root).should eq [5, 6]
      end
      it "correctly inserts multiple elements in a row" do
        root = createInt32Node(5)
        root.insert(6).should be_true
        root.insert(4).should be_true

        ordered(root).should eq [4, 5, 6]
      end
      it "refuses redundant Nodes" do
        root = createInt32Node(5)
        root.insert(5).should be_false

        ordered(root).should eq [5]
      end

      it "inserts the same way as insert_recursive" do
        root_iterative = createInt32Node(5)
        root_iterative.insert(4)
        root_iterative.insert(6)
        root_iterative.insert(9)
        root_iterative.insert(2)
        root_iterative.insert(3)
        root_iterative.insert(1)

        iterative_preorder = Array(Int32).new
        root_iterative.traverse_preorder do |e|
          iterative_preorder << e.data
        end

        root_recursive = createInt32Node(5)
        root_recursive.insert_recursive(4)
        root_recursive.insert_recursive(6)
        root_recursive.insert_recursive(9)
        root_recursive.insert_recursive(2)
        root_recursive.insert_recursive(3)
        root_recursive.insert_recursive(1)

        recursive_preorder = Array(Int32).new
        root_recursive.traverse_preorder do |e|
          recursive_preorder << e.data
        end

        iterative_preorder.should eq recursive_preorder
      end
    end

    describe "#insert_recursive" do
      it "correctly insert_recursives a new element" do
        root = createInt32Node(5)
        root.insert_recursive(6).should be_true

        ordered(root).should eq [5, 6]
      end
      it "correctly insert_recursives multiple elements in a row" do
        root = createInt32Node(5)
        root.insert_recursive(6).should be_true
        root.insert_recursive(4).should be_true

        ordered(root).should eq [4, 5, 6]
      end
      it "refuses redundant Nodes" do
        root = createInt32Node(5)
        root.insert_recursive(5).should be_false

        ordered(root).should eq [5]
      end
    end

    describe "#find" do
      it "finds an existing element" do
        root = createInt32DummyTree([5, 4, 6, 9, 2, 3, 1])
        root.find(3).should be_a(BinarySearchTree::Node(Int32))
        root.find(9).should be_a(BinarySearchTree::Node(Int32))
      end
      it "returns nil if element does not exist" do
        root = createInt32DummyTree([5, 4, 6, 9, 2, 3, 1])
        root.find(32).should be_nil
      end
    end

    describe "#find_recursive" do
      it "find_recursives an existing element" do
        root = createInt32DummyTree([5, 4, 6, 9, 2, 3, 1])
        root.find_recursive(3).should be_a(BinarySearchTree::Node(Int32))
        root.find_recursive(9).should be_a(BinarySearchTree::Node(Int32))
      end
      it "returns nil if element does not exist" do
        root = createInt32DummyTree([5, 4, 6, 9, 2, 3, 1])
        root.find_recursive(32).should be_nil
      end
    end

    describe "#traverse_preorder" do
      it "traverses the tree" do
        values = [5, 4, 6, 9, 2, 3, 1]
        found = Array(Int32).new
        root = createInt32DummyTree(values)
        root.traverse_preorder do |e|
          found << e.data
        end
        found.should eq [5, 4, 2, 1, 3, 6, 9]
      end
    end

    describe "#traverse_inorder" do
      it "traverses the tree in-order" do
        values = [5, 4, 6, 9, 2, 3, 1]
        found = Array(Int32).new
        root = createInt32DummyTree(values)
        root.traverse_inorder do |e|
          found << e.data
        end

        found.should eq [1, 2, 3, 4, 5, 6, 9]
      end
    end

    describe "#traverse_postorder" do
      it "traverses the tree post-order" do
        values = [5, 4, 6, 9, 2, 3, 1]
        found = Array(Int32).new
        root = createInt32DummyTree(values)
        root.traverse_postorder do |e|
          found << e.data
        end

        found.should eq [1, 3, 2, 4, 9, 6, 5]
      end
    end

    describe "#delete_node" do
      it "deletes a node with no children" do
        values = [5, 4, 6, 9, 2, 3, 1]
        found = Array(Int32).new
        root = createInt32DummyTree(values)
        root.delete_node(1).should be_true

        # make sure all the other data is still there
        found = Array(Int32).new
        root.traverse_inorder do |e|
          found << e.data
        end

        found.should eq [2, 3, 4, 5, 6, 9]
      end

      it "deletes a node with a left child but no right child" do
        values = [5, 4, 6, 9, 2, 3, 1]
        found = Array(Int32).new
        root = createInt32DummyTree(values)
        root.delete_node(4).should be_true

        # make sure all the other data is still there
        found = Array(Int32).new
        root.traverse_preorder do |e|
          found << e.data
        end

        found.should eq [5, 2, 1, 3, 6, 9]
      end
      it "deletes a node with a right child but no left child" do
        values = [5, 4, 6, 9, 2, 3, 1]
        found = Array(Int32).new
        root = createInt32DummyTree(values)
        root.delete_node(6).should be_true

        # make sure all the other data is still there
        found = Array(Int32).new
        root.traverse_preorder do |e|
          found << e.data
        end

        found.should eq [5, 4, 2, 1, 3, 9]
      end
      it "deletes a node with a left and a right child" do
        values = [5, 4, 6, 9, 2, 3, 1]
        found = Array(Int32).new
        root = createInt32DummyTree(values)
        root.delete_node(2).should be_true

        # make sure all the other data is still there
        found = Array(Int32).new
        root.traverse_preorder do |e|
          found << e.data
        end

        found.should eq [5, 4, 3, 1, 6, 9]
      end
      it "deletes the root node" do
        values = [5, 4, 6, 9, 2, 3, 1]
        found = Array(Int32).new
        root = createInt32DummyTree(values)
        root.delete_node(5).should be_true

        # make sure all the other data is still there
        found = Array(Int32).new
        root.traverse_preorder do |e|
          found << e.data
        end

        found.should eq [6, 4, 2, 1, 3, 9]
      end
    end
  end
end
