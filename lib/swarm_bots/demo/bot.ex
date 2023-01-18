defmodule SwarmBots.Demo.Bot do
  @moduledoc """
  A bot has an X/Y tuple property for position: X axis means horizontally from the game board perspective, Y axis means vertically.

  A bot can rotates in 8 differents degrees:
    - 0 is facing down & 180 is facing up,
    - the incrementation of degrees is clockwise, decrementation anti-clockwise.
  """
  @rotations [0, 45, 90, 135, 180, 225, 270, 315]

  defstruct position: {5, 5}, rotation: 0, life: 100, attack: 100

  def new_random_bot(), do: new_bot([random_start_position(), random_rotation()])
  def new_bot(options \\ []), do: __struct__(options)

  def scan_collisions(%__MODULE__{position: position} = _bot, arena),
    do: position |> scan_boundaries() && !(position |> scan_bots(arena))

  # SHIFT FUNCTIONS
  def move_bot(%__MODULE__{rotation: 0, position: {x, y}} = bot),
    do: %{bot | position: {x, y + 1}}

  def move_bot(%__MODULE__{rotation: 45, position: {x, y}} = bot),
    do: %{bot | position: {x - 1, y + 1}}

  def move_bot(%__MODULE__{rotation: 90, position: {x, y}} = bot),
    do: %{bot | position: {x - 1, y}}

  def move_bot(%__MODULE__{rotation: 135, position: {x, y}} = bot),
    do: %{bot | position: {x - 1, y - 1}}

  def move_bot(%__MODULE__{rotation: 180, position: {x, y}} = bot),
    do: %{bot | position: {x, y - 1}}

  def move_bot(%__MODULE__{rotation: 225, position: {x, y}} = bot),
    do: %{bot | position: {x + 1, y - 1}}

  def move_bot(%__MODULE__{rotation: 270, position: {x, y}} = bot),
    do: %{bot | position: {x + 1, y}}

  def move_bot(%__MODULE__{rotation: 315, position: {x, y}} = bot),
    do: %{bot | position: {x + 1, y + 1}}

  # ROTATION FUNCTIONS
  def rotate_bot(%__MODULE__{rotation: rotation} = bot, degrees),
    do: %{bot | rotation: (rotation + degrees) |> check_rotation()}

  # PRIVATES
  defp random_start_position(), do: {:position, {0..10 |> Enum.random(), 0..10 |> Enum.random()}}
  defp random_rotation(), do: {:rotation, @rotations |> Enum.random()}

  defp check_rotation(rotation) when rotation >= 360, do: rotation - 360
  defp check_rotation(rotation) when rotation < 0, do: rotation + 360

  defp scan_boundaries({x, _y}) when x < 0 or x > 720, do: false
  defp scan_boundaries({_x, y}) when y < 0 or y > 480, do: false

  defp scan_bots({x, y}, arena), do: !!arena[{x, y}]
end