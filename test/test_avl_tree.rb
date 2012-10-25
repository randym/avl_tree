require File.expand_path('./helper', File.dirname(__FILE__))
class TestAvlTree < Test::Unit::TestCase

  def setup
    @tree = AvlTree.new
  end

  def build_tree(node_keys)
    node_keys.each_with_index {  |key, value| @tree.insert(key, value) }
  end

  def test_first_insert_creates_root
    @tree.insert('C', 1)
    assert_equal(1, @tree['C'])
  end

  def test_right_insertion
    @tree.insert('A', 1)
    assert_equal(1, @tree.root.value)
    @tree.insert('B', 2)
    assert_equal(2, @tree['B'])
    assert_equal('B', @tree.right.key)
  end

  def test_left_insertion
    @tree.insert('B', 2)
    assert_equal('B', @tree.root.key)
    @tree.insert('A', 1)
    assert_equal('A', @tree.left.key)
  end

  def test_value_update_with_insert
    @tree.insert('A', 1)
    assert_equal(1, @tree['A'])
    @tree.insert('A', 2)
    assert_equal(2, @tree['A'])
    @tree.insert('A', 2)
  end

  def test_value_update_with_hash_like_access
    @tree.insert('A', 1)
    assert_equal(1, @tree['A'])
    @tree['A'] = 2
    assert_equal(2, @tree['A'])
  end

  def test_hash_like_access
    @tree.insert('A', 1)
    @tree.insert('B', 2)
    @tree.insert('C', 3)
    assert_equal(1, @tree['A'])
    assert_equal(2, @tree['B'])
    assert_equal(3, @tree['C'])
  end

  def test_not_found
    assert_equal(nil, @tree['D'])
  end

  def test_rotate_left
    build_tree %w(C D E)
    assert_equal('C', @tree.left.key)
    assert_equal('E', @tree.right.key)
  end

  def test_rotate_right
    build_tree %w(E D C)
    assert_equal('C', @tree.left.key)
    assert_equal('E', @tree.right.key)
  end

  def test_double_rotate_right_left
    build_tree %w(5 9 7)
    assert_equal('7', @tree.root.key)
  end

  def test_double_rotate_left_right
    build_tree [9, 5, 7]
    assert_equal(7, @tree.root.key)
  end

  def test_multi_genration_right_side_building
    build_tree %w(C D E F G H I)
    assert_equal('D', @tree.left.key)
    assert_equal('C', @tree.left.left.key)
    assert_equal('E', @tree.left.right.key)
    assert_equal('H', @tree.right.key)
    assert_equal('G', @tree.right.left.key)
    assert_equal('I', @tree.right.right.key)
  end

  def test_multi_generation_left_side_building
    build_tree %w(G F E D C B A)
    assert_equal('G', @tree.right.right.key)
    assert_equal('E', @tree.right.left.key)
    assert_equal('F', @tree.right.key)
    assert_equal('B', @tree.left.key)
    assert_equal('C', @tree.left.right.key)
    assert_equal('A', @tree.left.left.key)
  end

  def test_delete_root_from_single_node_tree
    build_tree %w(A)
    @tree.delete 'A'
    assert(@tree.root.is_a?(AvlTree::Node::TerminalNode))
  end

  def test_delete_barren_child
    build_tree %w(A B)
    @tree.delete 'B'
    assert(@tree.right.is_a?(AvlTree::Node::TerminalNode))
  end

  def test_delete_with_single_child
    build_tree %w(A B)
    @tree.delete 'A'
    assert_equal('B', @tree.root.key)
  end

  def test_delete_barren_child_with_rebalance
    build_tree %w(D C A B E F G)
    @tree.delete 'B'
    assert_equal('E', @tree.root.key)
    assert_equal('C', @tree.left.key)
    assert_equal('F', @tree.right.key)
    assert_equal('D', @tree.left.right.key)
    assert_equal('A', @tree.left.left.key)
    assert_equal('G', @tree.right.right.key)
  end

  def test_delete_using_in_order_successor
    build_tree %w(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20)
    @tree.delete '14'
    assert_equal('17', @tree.root.key)
    assert_equal('11', @tree.left.key)
    assert_equal('15', @tree.left.right.key)
  end

  def test_delete_using_in_order_predecessor
    build_tree (1..10).to_a
    @tree.delete 8
    assert_equal(7, @tree.right.key)
  end

  def delete_not_found
    build_tree (1..3).to_a
    @tree.delete('a')
    assert_equal(2, @tree.root.key)
  end
end
