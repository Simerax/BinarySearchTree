require "./spec_helper"

describe BinarySearchTree do
  describe "BinarySearchTree::Node(Int32)" do
    describe "#insert" do
      it "correctly inserts a new element" do
        root = createInt32Node(5)
        root.insert(6).should be_true
      end
      it "correctly inserts multiple elements in a row" do
        root = createInt32Node(5)
        root.insert(6).should be_true
        root.insert(4).should be_true
      end
      it "refuses redundant Nodes" do
        root = createInt32Node(5)
        root.insert(5).should be_false
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
