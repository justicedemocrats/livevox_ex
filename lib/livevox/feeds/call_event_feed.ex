defmodule Livevox.CallEventFeed do
  @moduledoc """
  Documentation for Livevox.
  """

  @doc """
  """
  defmacro __using__(_) do
    quote do
      use Agent

      def start_link do
        Task.start_link(fn -> get_calls() end)
      end

      def get_calls do
        resp =
          %{body: %{"token" => token}} =
          Livevox.Api.post("realtime/v6.0/callEvent/feed", body: %{}, timeout: 12_000)

        handle_events(resp.body["callEvent"])

        get_calls(token)
      end

      def get_calls(token) do
        resp =
          %{body: %{"token" => new_token}} =
          Livevox.Api.post("realtime/v6.0/callEvent/feed", body: %{token: token}, timeout: 12_000)

        num_calls = Map.get(resp.body, "callEvent", []) |> length()

        handle_events(resp.body["callEvent"])

        get_calls(new_token)
      end

      def handle_events(events) do
        IO.puts("Calls: #{length(events)} events")
        Enum.each(events, fn ev -> spawn(fn -> handle_call_event(ev) end) end)
      end
    end
  end
end
