# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :zigler_raytracer, ZiglerRaytracerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "RjtccQxZP2ow9tjlQ+0SXczCmBh4qu33t6fpNGV+9tFINmBqiJoYZuI1v6ayGJiC",
  render_errors: [view: ZiglerRaytracerWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ZiglerRaytracer.PubSub,
  live_view: [signing_salt: "d4ncEW9W"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
