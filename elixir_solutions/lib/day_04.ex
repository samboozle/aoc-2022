defmodule Day04 do
  @row_regex ~r/(\d+)-(\d+),(\d+)-(\d+)/

  def run(path \\ "assets/d4full.txt") do
    input = parse_input(path)
    {solution_1(input), solution_2(input)}
  end

  def parse_input(path) do
    File.read!(path)
    |> String.split("\n", trim: true)
    |> Enum.reduce([], fn row, acc ->
      case Regex.run(@row_regex, row)
           |> tl()
           |> Enum.map(&String.to_integer/1) do
        [a, b, x, y] -> [{{a, b}, {x, y}} | acc]
        _ -> acc
      end
    end)
    |> Enum.reverse()
  end

  def solution_1(rangepairs) do
    cmp_rangepairs(rangepairs, fn {{a, b}, {x, y}} ->
      (a < x && b < y) || (a > x && b > y)
    end)
  end

  def solution_2(rangepairs) do
    cmp_rangepairs(rangepairs, fn {{a, b}, {x, y}} ->
      (a < y && b < x) || (a > y && b > x)
    end)
  end

  defp acc_unless(false, acc), do: acc + 1
  defp acc_unless(true, acc), do: acc

  defp cmp_rangepairs(rangepairs, fun) do
    Enum.reduce(rangepairs, 0, &(fun.(&1) |> acc_unless(&2)))
  end
end
