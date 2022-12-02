defmodule Day2Test do
  use ExUnit.Case
  doctest ElixirSolutions

  @test_input "assets/d2test.txt"

  test "parses input into [{move, move}]" do
    opponent = MapSet.new([:A, :B, :C])
    player = MapSet.new([:X, :Y, :Z])

    assert Day2.parse_input(@test_input)
           |> Enum.all?(fn {k, v} ->
             MapSet.member?(opponent, k) && MapSet.member?(player, v)
           end)
  end

  test "Solution 1 with small input" do
    assert Day2.parse_input(@test_input)
           |> Day2.solution_1()
           |> (&(&1 == 15)).()
  end

  test "Solution 2 with small input" do
    assert Day2.parse_input(@test_input)
           |> Day2.solution_2()
           |> (&(&1 == 12)).()
  end
end
