defmodule ElixirRust.Repo.Migrations.CreateInputs do
  use Ecto.Migration

  def change do
    create table(:inputs) do
      add :content, :text
      add :expected_result, :string
      add :puzzle_id, references(:puzzles, on_delete: :nothing)

      timestamps()
    end

    create index(:inputs, [:puzzle_id])
  end
end
