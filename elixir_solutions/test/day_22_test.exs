defmodule Day22Test do
  use ExUnit.Case
  doctest ElixirSolutions

  @test_input "assets/d22test.txt"

  test "Solution 1 with small input" do
    assert Day22.parse_input(@test_input)
           |> Day22.solution_1()
           |> (&(&1 == 152)).()
  end

  test "Solution 2 with small input" do
    assert Day22.parse_input(@test_input)
           |> Day22.solution_2()
           |> (&(&1 == 301)).()
  end
end
