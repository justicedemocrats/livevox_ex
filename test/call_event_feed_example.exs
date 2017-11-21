defmodule Livevox.PollerTest do
  use Livevox.CallEventFeed

  def handle_call(call) do
    IO.puts("I'm extending handle_call!")
    IO.inspect(call)
  end
end
