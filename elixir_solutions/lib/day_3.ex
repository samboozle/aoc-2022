defmodule Day3 do
  def run(path \\ "assets/d3full.txt") do
    input = parse_input(path)
    {solution_1(input), solution_2(input)}
  end

  def parse_input(path) do
    File.read!(path)
    |> String.split("\n", trim: true)
  end

  def solution_1(rucksacks) do
    Enum.reduce(rucksacks, 0, fn string, acc ->
      acc +
        (String.to_charlist(string)
         |> find_dupe
         |> priority)
    end)
  end

  def solution_2(rucksacks) do
    Stream.chunk_every(rucksacks, 3)
    |> Stream.map(fn chunk ->
      Stream.map(chunk, &String.to_charlist/1)
      |> Stream.map(&MapSet.new/1)
      |> Enum.reduce(&MapSet.intersection/2)
      |> MapSet.to_list()
      |> (fn
            [] -> 0
            [c | _] -> priority(c)
          end).()
    end)
    |> Enum.sum()
  end

  defp priority(char) do
    cond do
      char in ?a..?z -> char - 96
      char in ?A..?Z -> char - 38
      :otherwise -> 0
    end
  end

  defp find_dupe(list) do
    Enum.split(list, div(length(list), 2))
    |> (fn {front, back} ->
          pool = MapSet.new(front)
          Enum.find(back, &MapSet.member?(pool, &1))
        end).()
  end
end
