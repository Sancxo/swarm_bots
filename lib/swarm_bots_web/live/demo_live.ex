defmodule SwarmBotsWeb.DemoLive do
  use SwarmBotsWeb, :live_view
  use Phoenix.HTML
  alias SwarmBots.Demo.{Game, Bot}

  def mount(_params, _session, socket) do
    if connected?(socket), do: :timer.send_interval(12, :tick)
    {:ok, socket |> assign(game: Game.new_game())}
  end

  def handle_info(:tick, %{assigns: %{game: game}} = socket),
    do: {:noreply, socket |> assign(game: game |> Game.move_bots())}

  def render(assigns) do
    ~H"""
    <svg width="720" height="480">
      <rect width="720" height="480" style="fill:rgb(255,255,255);" stroke="black" stroke-width="3" />
      <%= assigns |> render_bots() %>
    </svg>
    <pre>Arena: <%= @game.arena |> inspect() %></pre>
    """
  end

  defp render_bots(assigns) do
    ~H"""
    <%= for {{x, y}, bot} <- @game.arena do %>
      <circle cx={x} cy={y} r="22" stroke="black" stroke-width="3" fill="gray" />
      <%= bot |> render_led() %>
    <% end %>
    """
  end

  defp render_led(%Bot{position: {x, y}, rotation: 0}), do: render_led(%{x: x, y: y + 10})

  defp render_led(%Bot{position: {x, y}, rotation: 45}), do: render_led(%{x: x - 7.5, y: y + 7.5})

  defp render_led(%Bot{position: {x, y}, rotation: 90}), do: render_led(%{x: x - 10, y: y})

  defp render_led(%Bot{position: {x, y}, rotation: 135}),
    do: render_led(%{x: x - 7.5, y: y - 7.5})

  defp render_led(%Bot{position: {x, y}, rotation: 180}), do: render_led(%{x: x, y: y - 10})

  defp render_led(%Bot{position: {x, y}, rotation: 225}),
    do: render_led(%{x: x + 7.5, y: y - 7.5})

  defp render_led(%Bot{position: {x, y}, rotation: 270}),
    do: render_led(%{x: x + 10, y: y})

  defp render_led(%Bot{position: {x, y}, rotation: 315}),
    do: render_led(%{x: x + 7.5, y: y + 7.5})

  defp render_led(%{x: x, y: y} = assigns) do
    ~H"""
    <circle cx={x} cy={y} r="2" fill="chartreuse">
      <animate attributeName="opacity" values="1;0;1" dur="2s" repeatCount="indefinite" />
    </circle>
    """
  end
end
