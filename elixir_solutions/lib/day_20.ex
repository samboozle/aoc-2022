defmodule Day20 do
  def run(path \\ "assets/d20full.txt") do
    parse_input(path)
    |> (&{solution_1(&1), solution_2(&1)}).()
  end

  def parse_input(path) do
    File.read!(path)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def wrap(x, limit) when x < 0, do: wrap(x + limit, limit)
  def wrap(x, limit) when x > limit, do: rem(x, limit)
  def wrap(0, limit), do: limit
  def wrap(limit, limit), do: limit
  def wrap(x, _), do: x

  def mix(_, state, 0), do: state

  def mix(truth, state, iter) do
    len = length(truth) - 1

    state =
      Enum.reduce(truth, state, fn {val, idx}, state ->
        {front, [el | back]} = Enum.split_while(state, &(elem(&1, 1) != idx))

        List.insert_at(front ++ back, rem(len + length(front) + val, len) |> wrap(len), el)
      end)

    mix(truth, state, iter - 1)
  end

  def mix_and_zero(numbers, mixes \\ 1, multiplier \\ 1) do
    len = length(numbers)
    indexed = Enum.map(numbers, &(&1 * multiplier)) |> Enum.with_index()

    final_list = mix(indexed, indexed, mixes) |> Enum.map(&elem(&1, 0))

    zero = Enum.find_index(final_list, &(&1 == 0))

    [1_000, 2_000, 3_000]
    |> Enum.reduce(0, fn idx, acc -> acc + Enum.at(final_list, rem(idx + zero, len)) end)
  end

  def solution_1(numbers), do: mix_and_zero(numbers)
  def solution_2(numbers), do: mix_and_zero(numbers, 10, 811_589_153)
end
