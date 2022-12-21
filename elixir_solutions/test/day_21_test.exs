defmodule Day21Test do
  use ExUnit.Case
  doctest ElixirSolutions

  @test_input "assets/d21test.txt"

  test "Solution 1 with small input" do
    assert Day21.parse_input(@test_input)
           |> Day21.solution_1()
           |> (&(&1 == 152)).()
  end

  @tag :pending
  test "Solution 2 with small input" do
    assert Day21.parse_input(@test_input)
           |> Day21.solution_2()
           |> (&(&1 == 301)).()
  end
end
