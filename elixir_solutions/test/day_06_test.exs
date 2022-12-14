defmodule Day06Test do
  use ExUnit.Case
  doctest ElixirSolutions

  @test_input "assets/d6test.txt"

  test "Solution 1 with small input" do
    assert Day06.parse_input(@test_input)
           |> Day06.solution_1()
           |> (&(&1 == 7)).()
  end

  test "Solution 2 with small input" do
    assert Day06.parse_input(@test_input)
           |> Day06.solution_2()
           |> (&(&1 == 19)).()
  end
end
