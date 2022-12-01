defmodule ElixirRustWeb.PageController do
  use ElixirRustWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
