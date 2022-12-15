defmodule Day15Test do
  use ExUnit.Case
  doctest ElixirSolutions

  @test_input "assets/d15test.txt"

  test "Solution 1 with small input" do
    assert Day15.parse_input(@test_input)
           |> Day15.solution_1(10)
           |> (&(&1 == 26)).()
  end

  test "Solution 2 with small input" do
    assert Day15.parse_input(@test_input)
           |> Day15.solution_2({0, 20})
           |> (&(&1 == 56_000_011)).()
  end
end
