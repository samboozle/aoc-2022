defmodule Day5 do
  @instruction ~r/move (\d+) from (\d+) to (\d+)/

  def run(path \\ "assets/d5full.txt") do
    {crates, instructions} = parse_input(path)
    {solution_1(crates, instructions), solution_2(crates, instructions)}
  end

  def parse_input(path) do
    [crates, instructions] =
      File.read!(path)
      |> String.split("\n\n", trim: true)

    crates =
      String.split(crates, "\n", trim: true)
      |> Enum.map(
        &(String.codepoints(&1)
          |> Enum.chunk_every(3, 4)
          |> Enum.map(fn [_, b, _] -> b end))
      )
      |> Enum.reverse()
      |> Enum.drop(1)
      |> Enum.reduce(%{}, fn row, acc ->
        Enum.with_index(row)
        |> Enum.reduce(acc, fn
          {" ", _}, subacc -> subacc
          {box, idx}, subacc -> Map.update(subacc, idx + 1, [box], fn col -> [box | col] end)
        end)
      end)

    instructions =
      String.split(instructions, "\n", trim: true)
      |> Enum.map(
        &(Regex.run(@instruction, &1)
          |> Enum.drop(1)
          |> Enum.map(fn n -> String.to_integer(n) end))
      )

    {crates, instructions}
  end

  def solution_1(crates, instructions) do
    Enum.reduce(instructions, crates, &move_crates/2)
    |> map_heads()
  end

  def solution_2(crates, instructions) do
    Enum.reduce(instructions, crates, &move_piles/2)
    |> map_heads()
  end

  defp move_crates([0, _, _], crates), do: crates

  defp move_crates([amount, from, to], crates) do
    {head_at, crates} =
      Map.get_and_update(crates, from, fn
        [] -> {nil, []}
        [head | tail] -> {head, tail}
      end)

    crates = Map.update(crates, to, [head_at], fn stack -> [head_at | stack] end)

    move_crates([amount - 1, from, to], crates)
  end

  defp move_piles([amount, from, to], crates) do
    {pile_at, crates} = Map.get_and_update(crates, from, &seq_take(&1, amount))

    Map.update(crates, to, pile_at, fn stack ->
      Enum.reduce(pile_at, stack, fn el, acc -> [el | acc] end)
    end)
  end

  defp seq_take(list, count, acc \\ [])
  defp seq_take([], _, acc), do: {acc, []}
  defp seq_take(list, 0, acc), do: {acc, list}
  defp seq_take([head | tail], count, acc), do: seq_take(tail, count - 1, [head | acc])

  defp map_heads(crates) do
    Enum.sort_by(crates, fn {k, _} -> k end, :desc)
    |> Enum.reduce([], fn {_, [h | _]}, acc -> [h | acc] end)
    |> Enum.join()
  end
end
