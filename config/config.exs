import Config

# config :logger, :console, metadata: [:shard, :guild, :channel]

if File.exists?("config/secret.exs"), do: import_config("secret.exs")
