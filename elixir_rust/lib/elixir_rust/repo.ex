defmodule ElixirRust.Repo do
  use Ecto.Repo,
    otp_app: :elixir_rust,
    adapter: Ecto.Adapters.Postgres
end
