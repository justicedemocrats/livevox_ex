defmodule Livevox.Recorder.Call do
  use Livevox.CallEventFeed

  @call_event_out File.open("./call-event-out.json", [:write])

  def handle_call_event(call_event) do
    IO.inspect(call_event)
    as_json = Poison.encode!(call_event)
    line = as_json <> "\n"
    IO.binwrite(@call_event_out, line)
  end
end
