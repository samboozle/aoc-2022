defmodule ElixirSolutionsTest do
  use ExUnit.Case
  doctest ElixirSolutions

  test "Day 1" do
    assert ElixirSolutions.solve(1) == {:ok, {74_711, 209_481}}
  end

  test "Day 2" do
    assert ElixirSolutions.solve(2) == {:ok, {17_189, 13_490}}
  end

  test "Day 3" do
    assert ElixirSolutions.solve(3) == {:ok, {7_581, 2_525}}
  end

  test "Day 4" do
    assert ElixirSolutions.solve(4) == {:ok, {431, 823}}
  end

  test "Day 5" do
    assert ElixirSolutions.solve(5) == {:ok, {"ZRLJGSCTR", "PRTTGRFPB"}}
  end

  test "Day 6" do
    assert ElixirSolutions.solve(6) == {:ok, {1_929, 3_298}}
  end

  test "Day 7" do
    assert ElixirSolutions.solve(7) == {:ok, {1_490_523, 12_390_492}}
  end

  test "Day 8" do
    assert ElixirSolutions.solve(8) == {:ok, {1_870, 517_440}}
  end

  @tag :pending
  test "Day 9" do
    assert ElixirSolutions.solve(9) == {:ok, {1_870, 517_440}}
  end

  @tag :pending
  test "Day 10" do
    assert ElixirSolutions.solve(10) == {:ok, {1_870, 517_440}}
  end

  test "Day 11" do
    assert ElixirSolutions.solve(11) == {:ok, {56120, 24_389_045_529}}
  end

  test "Day 12" do
    assert ElixirSolutions.solve(12) == {:ok, {440, 439}}
  end

  test "Day 13" do
    assert ElixirSolutions.solve(12) == {:ok, {440, 439}}
  end
end
