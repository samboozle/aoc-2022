defmodule Day11.Monkey do
  defstruct items: :queue.new(),
            inspections: 0,
            operation: nil,
            test: 1,
            targets: {nil, nil}

  def process_profile_line(
        <<"Starting items: "::utf8, items::binary>>,
        {monkey = %__MODULE__{}, lcm}
      ) do
    {%__MODULE__{
       monkey
       | items:
           String.split(items, ", ", trim: true)
           |> Enum.map(&String.to_integer/1)
           |> :queue.from_list()
     }, lcm}
  end

  def process_profile_line(
        <<"Operation: new = old "::utf8, op::binary>>,
        {monkey = %__MODULE__{}, lcm}
      ) do
    {%__MODULE__{
       monkey
       | operation:
           case String.split(op, " ", trim: true) do
             ["*", "old"] -> &(&1 * &1)
             ["+", "old"] -> &(&1 + &1)
             ["*", n] -> &(&1 * String.to_integer(n))
             ["+", n] -> &(&1 + String.to_integer(n))
             ["-", n] -> &(&1 - String.to_integer(n))
             _ -> nil
           end
     }, lcm}
  end

  def process_profile_line(
        <<"Test: divisible by "::utf8, test::binary>>,
        {monkey = %__MODULE__{}, _}
      ) do
    divisor = String.to_integer(test)

    {%__MODULE__{
       monkey
       | test: &rem(&1, divisor)
     }, divisor}
  end

  def process_profile_line(
        <<"If true: throw to monkey "::utf8, t_monkey::binary>>,
        {monkey = %__MODULE__{targets: {_, f_monkey}}, lcm}
      ) do
    {%__MODULE__{
       monkey
       | targets: {String.to_integer(t_monkey), f_monkey}
     }, lcm}
  end

  def process_profile_line(
        <<"If false: throw to monkey "::utf8, f_monkey::binary>>,
        {monkey = %__MODULE__{targets: {t_monkey, _}}, lcm}
      ) do
    {%__MODULE__{
       monkey
       | targets: {t_monkey, String.to_integer(f_monkey)}
     }, lcm}
  end

  def process_profile_line(_, monkey), do: monkey
end
