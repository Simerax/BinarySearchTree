require "spec"
require "../src/BinarySearchTree"

def createInt32Node(val : Int32)
  obj = BinarySearchTree::Node(Int32).new(val)
  obj
end

def createInt32DummyTree(values : Array(Int32))
  obj = BinarySearchTree::Node(Int32).new(values.shift)
  values.each do |v|
    obj.insert(v)
  end
  obj
end

#             5
#         4       6
#     2               9
# 1       3
def createInt32PredefinedDummyTree
  createInt32DummyTree([5, 4, 6, 9, 2, 3, 1])
end

# helper to list every nodes data in ascending order
#
# root = createInt32DummyTree([5,4,6,8,9])
# ordered(root).should eq [4,5,6,8,9]
def ordered(root : BinarySearchTree::Node(Int32))
  found = Array(Int32).new
  root.traverse_inorder do |e|
    found << e.data
  end

  found
end
