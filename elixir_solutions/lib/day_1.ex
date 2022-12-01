defmodule Day1 do
  def parse_input(path) do
    File.read!(path)
    |> String.split("\n\n")
    |> Enum.map(fn line ->
      String.split(line, "\n")
      |> Enum.reduce([], fn s, acc ->
        case s do
          "" -> acc
          _ -> [String.to_integer(s) | acc]
        end
      end)
      |> Enum.reverse()
    end)
  end

  def run do
    elf_backpacks = parse_input("assets/d1p1.txt")

    {solution_1(elf_backpacks), solution_2(elf_backpacks)}
  end

  def solution_1(elf_backpacks) do
    elf_backpacks
    |> Enum.map(&Enum.sum/1)
    |> Enum.max()
  end

  def solution_2(elf_backpacks) do
    elf_backpacks
    |> Enum.reduce([], fn
      backpack, t3 = [_, _, _] ->
        [Enum.sum(backpack) | t3]
        |> Enum.sort(:desc)
        |> Enum.take(3)

      backpack, tx ->
        [Enum.sum(backpack) | tx]
    end)
    |> Enum.sum()
  end
end
