defmodule SwarmBotsWeb.PageController do
  use SwarmBotsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
