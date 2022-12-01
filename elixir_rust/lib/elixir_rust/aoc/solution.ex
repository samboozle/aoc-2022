defmodule ElixirRust.AOC.Solution do
  use Ecto.Schema
  import Ecto.Changeset

  schema "solutions" do
    field :code, :string
    field :language, :string
    field :puzzle_id, :id

    timestamps()
  end

  @doc false
  def changeset(solution, attrs) do
    solution
    |> cast(attrs, [:language, :code])
    |> validate_required([:language, :code])
  end
end
