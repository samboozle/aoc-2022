defmodule Day7 do
  @sized_file ~r/(\d+) (\S+)/

  def run(path \\ "assets/d7full.txt") do
    dir = parse_input(path)
    {solution_1(dir), solution_2(dir)}
  end

  def parse_input(path) do
    File.read!(path)
    |> String.split("\n", trim: true)
    |> Enum.drop(1)
    |> process_commands()
    |> elem(0)
  end

  def solution_1(dir) do
    Map.values(dir)
    |> Enum.reduce({0, 0, 100_000}, &count_and_size/2)
    |> elem(0)
  end

  def solution_2(dir) do
    Map.values(dir)
    |> Enum.reduce({0, 0, 100_000}, &count_and_size/2)
    |> elem(0)
  end

  defp count_and_size(node, {count, size, limit}) when is_number(node) do
    {count, size + node, limit}
  end

  defp count_and_size(node, {count, size, limit}) when is_map(node) do
    {count, local_size, limit} =
      Enum.reduce(Map.values(node), {count, 0, limit}, &count_and_size/2)

    cond do
      local_size <= limit -> {count + local_size, size + local_size, limit}
      :otherwise -> {count, size + local_size, limit}
    end
  end

  defp process_commands(commands, dir \\ %{})
  defp process_commands([], dir), do: {dir, []}
  defp process_commands(["$ cd .." | commands], dir), do: {dir, commands}
  defp process_commands(["$ ls" | commands], dir), do: process_commands(commands, dir)

  defp process_commands([<<"$ cd "::utf8, dirname::binary>> | commands], dir) do
    {subdir, commands} = process_commands(commands)

    process_commands(
      commands,
      Map.put(dir, dirname, subdir)
    )
  end

  defp process_commands([command | commands], dir) do
    case Regex.run(@sized_file, command) do
      [_, size, filename] ->
        process_commands(commands, Map.put(dir, filename, String.to_integer(size)))

      _ ->
        process_commands(commands, dir)
    end
  end
end
