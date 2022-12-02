defmodule ElixirSolutionsTest do
  use ExUnit.Case
  doctest ElixirSolutions

  test "Day 1" do
    assert ElixirSolutions.solve(1) == {:ok, {74_711, 209_481}}
  end

  test "Day 2" do
    assert ElixirSolutions.solve(2) == {:ok, {17189, 13490}}
  end
end
