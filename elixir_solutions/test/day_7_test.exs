defmodule Day7Test do
  use ExUnit.Case
  doctest ElixirSolutions

  @test_input "assets/d7test.txt"

  test "Solution 1 with small input" do
    assert Day7.parse_input(@test_input)
           |> Day7.solution_1()
           |> (&(&1 == 95_437)).()
  end

  test "Solution 2 with small input" do
    assert Day7.parse_input(@test_input)
           |> Day7.solution_2()
           |> (&(&1 == 24_933_642)).()
  end
end
