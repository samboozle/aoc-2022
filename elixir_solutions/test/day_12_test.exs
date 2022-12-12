defmodule Day12Test do
  use ExUnit.Case
  doctest ElixirSolutions

  @test_input "assets/d12test.txt"

  test "Solution 1 with small input" do
    assert Day12.parse_input(@test_input)
           |> Day12.solution_1()
           |> (&(&1 == 31)).()
  end

  @tag :pending
  test "Solution 2 with small input" do
    assert Day12.parse_input(@test_input)
           |> Day12.solution_2()
           |> (&(&1 == 2_713_310_158)).()
  end
end
