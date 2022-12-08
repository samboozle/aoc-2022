defmodule Day8Test do
  use ExUnit.Case
  doctest ElixirSolutions

  @test_input "assets/d8test.txt"

  test "Solution 1 with small input" do
    assert Day8.parse_input(@test_input)
           |> Day8.solution_1()
           |> (&(&1 == 21)).()
  end

  test "Solution 2 with small input" do
    assert Day8.parse_input(@test_input)
           |> Day8.solution_2()
           |> (&(&1 == 8)).()
  end
end
