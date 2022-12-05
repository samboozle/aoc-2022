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
    |> Enum.sort_by(fn {k, _} -> k end, :desc)
    |> Enum.reduce([], fn {_, [h | _]}, acc -> [h | acc] end)
    |> Enum.join()
  end

  def solution_2(crates, instructions) do
    nil
  end

  def move_crates([0, _, _], crates), do: crates

  def move_crates([amount, from, to], crates) do
    {head_at, crates} =
      Map.get_and_update(crates, from, fn
        [] -> {nil, []}
        [head | tail] -> {head, tail}
      end)

    crates = Map.update(crates, to, [head_at], fn stack -> [head_at | stack] end)

    move_crates([amount - 1, from, to], crates)
  end
end
