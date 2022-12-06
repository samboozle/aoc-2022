defmodule Day6 do
  def run(path \\ "assets/d6full.txt") do
    line = parse_input(path)
    {solution_1(line), solution_2(line)}
  end

  def parse_input(path) do
    File.read!(path)
    |> String.trim()
  end

  def solution_1(line), do: line |> nth_window(4)
  def solution_2(line), do: line |> nth_window(14)

  defp nth_window(line, width) do
    String.to_charlist(line)
    |> Stream.chunk_every(width, 1)
    |> Stream.map(&MapSet.new/1)
    |> Enum.find_index(&(MapSet.size(&1) == width))
    |> (&(&1 + width)).()
  end
end
