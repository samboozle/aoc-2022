defmodule Day16Test do
  use ExUnit.Case
  doctest ElixirSolutions

  @test_input "assets/d16test.txt"

  test "Solution 1 with small input" do
    assert Day16.parse_input(@test_input)
           |> Day16.solution_1()
           |> (&(&1 == 1651)).()
  end

  test "Solution 2 with small input" do
    assert Day16.parse_input(@test_input)
           |> Day16.solution_2()
           |> (&(&1 == 1707)).()
  end
end
