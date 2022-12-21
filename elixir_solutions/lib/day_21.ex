defmodule Day21 do
  def run(path \\ "assets/d21full.txt") do
    parse_input(path)
    |> (&{solution_1(&1), solution_2(&1)}).()
  end

  def parse_input(path) do
    File.read!(path)
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{}, fn line, acc ->
      [monk, func] = String.split(line, ": ")

      func =
        case {monk, String.split(func, " ")} do
          {"root", [left, fun, right]} ->
            fun = String.to_atom(fun)

            fn
              map, nil -> trunc(apply(Kernel, fun, [map[left].(map, nil), map[right].(map, nil)]))
              map, acc -> trunc(solve({map[left].(map, acc), map[right].(map, acc)}))
            end

          {"humn", [num]} ->
            fn
              _, nil -> String.to_integer(num)
              _, acc -> acc
            end

          {_, [left, fun, right]} ->
            fun = String.to_atom(fun)

            fn
              map, nil ->
                apply(Kernel, fun, [map[left].(map, nil), map[right].(map, nil)])

              map, acc ->
                left = map[left].(map, acc)
                right = map[right].(map, acc)

                case {is_number(left), is_number(right)} do
                  {true, true} -> apply(Kernel, fun, [left, right])
                  {false, true} -> [fun, right | left]
                  {true, false} -> [left, fun | right]
                end
            end

          {_, [x]} ->
            fn _, _ -> String.to_integer(x) end
        end

      Map.put(acc, monk, func)
    end)
  end

  def inv(:+), do: :-
  def inv(:-), do: :+
  def inv(:*), do: :/
  def inv(:/), do: :*

  def solve({rpn, num}) when is_list(rpn), do: solve({num, rpn})
  def solve({num, rpn}), do: solve(num, rpn)
  def solve(num, []), do: trunc(num)
  def solve(x, [y, :- | tail]), do: solve(y - x, tail)
  def solve(x, [y, :/ | tail]), do: solve(y / x, tail)
  def solve(x, [y, f | t]) when is_atom(f), do: solve({apply(Kernel, inv(f), [x, y]), t})
  def solve(x, [fun, y | tail]), do: solve({apply(Kernel, inv(fun), [x, y]), tail})

  def solution_1(monkeys), do: monkeys["root"].(monkeys, nil)
  def solution_2(monkeys), do: monkeys["root"].(monkeys, [])
end
