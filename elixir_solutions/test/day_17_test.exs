defmodule Day17Test do
  use ExUnit.Case
  doctest ElixirSolutions

  @test_input "assets/d17test.txt"

  test "Solution 1 with small input" do
    assert Day17.parse_input(@test_input)
           |> Day17.solution_1()
           |> (&(&1 == 3_068)).()
  end

  test "Solution 2 with small input" do
    assert Day17.parse_input(@test_input)
           |> Day17.solution_2()
           |> (&(&1 == 1_514_285_714_288)).()
  end
end
