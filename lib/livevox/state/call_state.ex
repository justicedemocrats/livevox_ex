defmodule Livevox.State.Calls do
  use Agent
  import ShortMaps

  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def handle_call_event(call_event) do
    IO.inspect(call_event)
  end
end
