defmodule Day03Test do
  use ExUnit.Case
  doctest ElixirSolutions

  @test_input "assets/d3test.txt"

  test "Solution 1 with small input" do
    assert Day03.parse_input(@test_input)
           |> Day03.solution_1()
           |> (&(&1 == 157)).()
  end

  test "Solution 2 with small input" do
    assert Day03.parse_input(@test_input)
           |> Day03.solution_2()
           |> (&(&1 == 70)).()
  end
end
