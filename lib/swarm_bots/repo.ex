defmodule SwarmBots.Repo do
  use Ecto.Repo,
    otp_app: :swarm_bots,
    adapter: Ecto.Adapters.Postgres
end
