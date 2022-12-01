defmodule ElixirSolutionsTest do
  use ExUnit.Case
  doctest ElixirSolutions

  test "greets the world" do
    assert ElixirSolutions.hello() == :world
  end
end
