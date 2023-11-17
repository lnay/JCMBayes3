import Config

config :nostrum,
  gateway_intents: [
    :guild_messages,
    :guild_message_reactions,
    :message_content
  ]
# config :logger, :console, metadata: [:shard, :guild, :channel]

if File.exists?("config/secret.exs"), do: import_config("secret.exs")
