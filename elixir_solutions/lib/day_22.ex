defmodule Day22 do
  def run(path \\ "assets/d22full.txt") do
    parse_input(path)
    |> (&{solution_1(&1)}).()
  end

  def parse_input(path) do
    [maze, moves] =
      File.read!(path)
      |> String.split("\n\n", trim: true)

    length =
      String.split(maze, "\n", trim: true)
      |> Enum.map(&String.length/1)
      |> Enum.max()

    maze =
      String.split(maze, "\n", trim: true)
      |> Enum.map(&String.pad_trailing(&1, length))
      |> Enum.map(&String.to_charlist/1)

    rows =
      Enum.with_index(maze)
      |> Enum.reduce(%{}, fn {line, row}, acc ->
        Map.put(
          acc,
          row,
          Enum.with_index(line)
          |> Enum.filter(fn {char, _} -> char != ?\s end)
        )
      end)

    cols =
      rotate(maze)
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {line, row}, acc ->
        Map.put(
          acc,
          row,
          Enum.with_index(line)
          |> Enum.filter(fn {char, _} -> char != ?\s end)
        )
      end)

    face_size = gcd(Enum.count(rows), Enum.count(cols))

    # cube =

    moves =
      String.trim(moves)
      |> String.codepoints()
      |> Enum.chunk_by(&Regex.match?(~r/\d/, &1))
      |> Enum.chunk_every(2, 2)
      |> Enum.map(&Enum.map(&1, fn x -> Enum.join(x) end))
      |> Enum.map(fn
        [x, y] -> [String.to_integer(x), y]
        [x] -> [String.to_integer(x)]
      end)

    {rows, cols, moves}
  end

  def gcd(a, 0), do: abs(a)
  def gcd(a, b), do: gcd(b, rem(a, b))

  def rotate(list), do: Enum.zip_with(list, & &1)

  def turn("R", 3), do: 0
  def turn("R", 0), do: 1
  def turn("R", 1), do: 2
  def turn("R", 2), do: 3
  def turn("L", 3), do: 2
  def turn("L", 2), do: 1
  def turn("L", 1), do: 0
  def turn("L", 0), do: 3

  def turn({x, y, z}, dir), do: {x, y, turn(dir, z)}

  def move({x, y, 0}, rows, _, distance) do
    [{_, y}] =
      Stream.cycle(rows[x])
      |> Stream.drop_while(&(elem(&1, 1) != y))
      |> Stream.take_while(&(elem(&1, 0) != ?#))
      |> Stream.take(distance + 1)
      |> Enum.take(-1)

    {x, y, 0}
  end

  def move({x, y, 1}, _, cols, distance) do
    [{_, x}] =
      Stream.cycle(cols[y])
      |> Stream.drop_while(&(elem(&1, 1) != x))
      |> Stream.take_while(&(elem(&1, 0) != ?#))
      |> Stream.take(distance + 1)
      |> Enum.take(-1)

    {x, y, 1}
  end

  def move({x, y, 2}, rows, _, distance) do
    [{_, y}] =
      Enum.reverse(rows[x])
      |> Stream.cycle()
      |> Stream.drop_while(&(elem(&1, 1) != y))
      |> Stream.take_while(&(elem(&1, 0) != ?#))
      |> Stream.take(distance + 1)
      |> Enum.take(-1)

    {x, y, 2}
  end

  def move({x, y, 3}, _, cols, distance) do
    [{_, x}] =
      Enum.reverse(cols[y])
      |> Stream.cycle()
      |> Stream.drop_while(&(elem(&1, 1) != x))
      |> Stream.take_while(&(elem(&1, 0) != ?#))
      |> Stream.take(distance + 1)
      |> Enum.take(-1)

    {x, y, 3}
  end

  def navigate_maze({x, y, z}, _, _, []), do: 1000 * (x + 1) + 4 * (y + 1) + z

  def navigate_maze(pos, rows, cols, [[distance, turn] | moves]) do
    move(pos, rows, cols, distance)
    |> turn(turn)
    |> navigate_maze(rows, cols, moves)
  end

  def navigate_maze(pos, rows, cols, [[distance] | moves]) do
    move(pos, rows, cols, distance)
    |> navigate_maze(rows, cols, moves)
  end

  def solution_1({rows, cols, moves}) do
    start = Enum.at(rows[0], 0) |> elem(1)

    navigate_maze({0, start, 0}, rows, cols, moves)
  end
end
