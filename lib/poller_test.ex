defmodule Livevox.PollerTest do
  use Livevox.Poller

  def handle_call(call) do
    IO.puts "I'm extending handle_call!"
  end
end
