defmodule Livevox.Recorder.Agent do
  use Livevox.AgentEventFeed

  @agent_event_out File.open("./agent-event-out.json", [:write])

  def handle_agent_event(agent_event) do
    IO.inspect(agent_event)
    as_json = Poison.encode!(agent_event)
    line = as_json <> "\n"
    IO.binwrite(@call_event_out, line)
  end
end
