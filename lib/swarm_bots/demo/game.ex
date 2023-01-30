defmodule SwarmBots.Demo.Game do
  alias SwarmBots.Demo.Bot
  defstruct [:target, :swarm, arena: %{}, game_over: false]

  def new_game(number_of_bots),
    do: __struct__() |> generate_bots(number_of_bots)

  def move_bots(%__MODULE__{arena: arena} = game) do
    new_arena =
      arena
      |> Enum.reduce(%{}, fn {bot_position, bot}, acc ->
        new = bot |> Bot.move_bot()

        new
        |> Bot.scan_collisions(bot_position, arena)
        |> case do
          false ->
            acc |> Map.put(new.position, new)

          true ->
            rotated_bot =
              bot |> Bot.rotate_bot([45, 90, 135, 180, -45, -90, -135] |> Enum.random())

            acc |> Map.put(bot_position, rotated_bot)
        end
      end)

    %{game | arena: new_arena}
  end

  defp generate_bots(game, number_of_bots) do
    1..number_of_bots
    |> Enum.reduce(game, fn _, acc ->
      acc |> generate_bot()
    end)
  end

  defp generate_bot(game) do
    new_bot = Bot.new_random_bot()

    %{game | arena: game.arena |> Map.put(new_bot.position, new_bot)}
  end
end
