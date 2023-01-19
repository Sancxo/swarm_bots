defmodule SwarmBotsWeb.DemoLive do
  use SwarmBotsWeb, :live_view
  use Phoenix.HTML
  alias SwarmBots.Demo.{Game, Bot}

  def mount(_params, _session, socket) do
    if connected?(socket), do: :timer.send_interval(50, :tick)
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

  defp render_led(%Bot{position: {x, y}, rotation: 0} = assigns) do
    ~H"""
    <circle cx={x} cy={y + 10} r="2" fill="chartreuse">
      <%= animate_led(%{}) %>
    </circle>
    """
  end

  defp render_led(%Bot{position: {x, y}, rotation: 45} = assigns) do
    ~H"""
    <circle cx={x - 7.5} cy={y + 7.5} r="2" fill="chartreuse">
      <%= animate_led(%{}) %>
    </circle>
    """
  end

  defp render_led(%Bot{position: {x, y}, rotation: 90} = assigns) do
    ~H"""
    <circle cx={x - 10} cy={y} r="2" fill="chartreuse">
      <%= animate_led(%{}) %>
    </circle>
    """
  end

  defp render_led(%Bot{position: {x, y}, rotation: 135} = assigns) do
    ~H"""
    <circle cx={x - 7.5} cy={y - 7.5} r="2" fill="chartreuse">
      <%= animate_led(%{}) %>
    </circle>
    """
  end

  defp render_led(%Bot{position: {x, y}, rotation: 180} = assigns) do
    ~H"""
    <circle cx={x} cy={y - 10} r="2" fill="chartreuse">
      <%= animate_led(%{}) %>
    </circle>
    """
  end

  defp render_led(%Bot{position: {x, y}, rotation: 225} = assigns) do
    ~H"""
    <circle cx={x + 7.5} cy={y - 7.5} r="2" fill="chartreuse">
      <%= animate_led(%{}) %>
    </circle>
    """
  end

  defp render_led(%Bot{position: {x, y}, rotation: 270} = assigns) do
    ~H"""
    <circle cx={x + 10} cy={y} r="2" fill="chartreuse">
      <%= animate_led(%{}) %>
    </circle>
    """
  end

  defp render_led(%Bot{position: {x, y}, rotation: 315} = assigns) do
    ~H"""
    <circle cx={x + 7.5} cy={y + 7.5} r="2" fill="chartreuse">
      <%= animate_led(%{}) %>
    </circle>
    """
  end

  def animate_led(assigns) do
    ~H"""
    <animate attributeName="opacity" values="1;0;1" dur="2s" repeatCount="indefinite" />
    """
  end
end
