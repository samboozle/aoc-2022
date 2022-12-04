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
end
