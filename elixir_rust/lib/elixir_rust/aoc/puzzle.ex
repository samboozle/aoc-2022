defmodule ElixirRust.AOC.Puzzle do
  use Ecto.Schema
  import Ecto.Changeset

  schema "puzzles" do
    field :day, :integer
    field :description, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(puzzle, attrs) do
    puzzle
    |> cast(attrs, [:title, :description, :day])
    |> validate_required([:title, :description, :day])
  end
end
