require "helper"

class TestTrick < Test::Unit::TestCase
  test "the highest H card is the winner in NT game H trick and single suit" do
    trick = Bridge::Trick.new("H2", "H3", "H4", "H5")
    assert_equal Bridge::Card.new("H5"), trick.winner
  end

  test "the highest H card is the winner in NT game H trick and multiple suits" do
    trick = Bridge::Trick.new("H2", "C3", "D4", "S5")
    assert_equal Bridge::Card.new("H2"), trick.winner
  end

  test "the highest H card is the winner in S game H trick and single suit" do
    trick = Bridge::Trick.new("H2", "H5", "H4", "H3", :trump => "S")
    assert_equal Bridge::Card.new("H5"), trick.winner
  end

  test "the highest H card is the winner in S game H trick and multiple suits" do
    trick = Bridge::Trick.new("H2", "D5", "C4", "H3", :trump => "S")
    assert_equal Bridge::Card.new("H3"), trick.winner
  end

  test "the only trump is the winner in S game H trick and multiple suits" do
    trick = Bridge::Trick.new("H2", "D5", "S2", "H3", :trump => "S")
    assert_equal Bridge::Card.new("S2"), trick.winner
  end

  test "the highest trump is the winner in S game H trick and multiple suits" do
    trick = Bridge::Trick.new("H2", "SA", "S2", "H3", :trump => "S")
    assert_equal Bridge::Card.new("SA"), trick.winner
  end

  test "the highest trump is the winner in S game S trick and multiple suits" do
    trick = Bridge::Trick.new("S2", "HA", "CA", "DA", :trump => "S")
    assert_equal Bridge::Card.new("S2"), trick.winner
  end
end
