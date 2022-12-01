defmodule ElixirRust.AOC.Input do
  use Ecto.Schema
  import Ecto.Changeset

  schema "inputs" do
    field :content, :string
    field :expected_resulti, :string
    field :puzzle_id, :id

    timestamps()
  end

  @doc false
  def changeset(input, attrs) do
    input
    |> cast(attrs, [:content, :expected_resulti])
    |> validate_required([:content, :expected_resulti])
  end
end
