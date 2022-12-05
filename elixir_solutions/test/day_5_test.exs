defmodule Day5Test do
  use ExUnit.Case
  doctest ElixirSolutions

  @test_input "assets/d5test.txt"

  # test "parses input into [{{int, int}, {int, int}}]" do
  #   assert Day5.parse_input(@test_input)
  #          |> Enum.all?(fn
  #            {{_, _}, {_, _}} -> true
  #            _ -> false
  #          end)
  # end

  test "Solution 1 with small input" do
    assert Day5.parse_input(@test_input)
           |> (fn {crates, instructions} -> Day5.solution_1(crates, instructions) end).()
           |> (&(&1 == "CMZ")).()
  end

  # test "Solution 2 with small input" do
  #   assert Day5.parse_input(@test_input)
  #          |> Day5.solution_2()
  #          |> (&(&1 == 4)).()
  # end
end
