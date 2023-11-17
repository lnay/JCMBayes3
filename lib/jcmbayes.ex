require Logger


defmodule Jcmbayes.Application do
  use Application

  def start(_type, _args) do
    Logger.info("Starting Jcmbayes...")
    children = [ExampleConsumer]
    Supervisor.start_link(children, strategy: :one_for_one)
  end

  def hello do
    :world
  end
end

defmodule Jcmbayes.Supervisor do
  use Supervisor

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    children = [ExampleConsumer]

    Supervisor.init(children, strategy: :one_for_one)
  end
end

defmodule ExampleConsumer do
  use Nostrum.Consumer
  @channel_id Application.compile_env(:nostrum, :channel)
  @permissible_message ~r/^(?<location>jcmb|bayes)(\s+[a-z0-9_\-:\.]+)?[!?]?$/ix

  alias Nostrum.Api

  def handle_event({
    :MESSAGE_CREATE,
    %{
      :content => content,
      :channel_id => @channel_id, # Only listen to channel specified in config
    },
    _ws_state}
  ) do
    # TODO ignore messages from this bot
    Logger.info("handling event")
    case Regex.named_captures(@permissible_message, content) do
      %{"location" => location} ->
        Api.create_message(@channel_id, "location: #{location}")
      _ ->
        :ignore
    end
  end

  # Default event handler, if you don't include this, your consumer WILL crash if
  # you don't have a method definition for each event type.
  def handle_event(_event) do
    :noop
  end
end
