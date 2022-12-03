defmodule Day2 do
  @moves %{
    A: :rock,
    B: :paper,
    C: :scissors,
    X: :rock,
    Y: :paper,
    Z: :scissors
  }

  @outcomes %{
    X: :lose,
    Y: :draw,
    Z: :win
  }

  @counters %{
    rock: :paper,
    paper: :scissors,
    scissors: :rock
  }

  @points %{
    rock: 1,
    paper: 2,
    scissors: 3,
    lose: 0,
    draw: 3,
    win: 6
  }

  def run(path \\ "assets/d2full.txt") do
    input = parse_input(path)
    {solution_1(input), solution_2(input)}
  end

  def parse_input(path) do
    File.read!(path)
    |> String.split("\n", trim: true)
    |> Enum.reduce([], fn line, acc ->
      case String.split(line, ~r"\s+") |> Enum.map(&String.to_atom/1) do
        [a, b] -> [{a, b} | acc]
        _ -> acc
      end
    end)
    |> Enum.reverse()
  end

  def solution_1(turns) do
    turns
    |> Enum.reduce(0, fn {a, b}, acc ->
      [a, b] = Enum.map([a, b], &@moves[&1])
      acc + @points[b] + @points[outcome(a, b)]
    end)
  end

  def solution_2(turns) do
    turns
    |> Enum.reduce(0, fn {opponent, outcome}, acc ->
      outcome = @outcomes[outcome]
      opponent = @moves[opponent]

      acc +
        case outcome do
          :win -> @points[@counters[opponent]] + @points[outcome]
          :draw -> @points[opponent] + @points[outcome]
          :lose -> @points[@counters[@counters[opponent]]] + @points[outcome]
        end
    end)
  end

  defp outcome(x, x), do: :draw
  defp outcome(:rock, :scissors), do: :lose
  defp outcome(:scissors, :paper), do: :lose
  defp outcome(:paper, :rock), do: :lose
  defp outcome(_, _), do: :win
end
