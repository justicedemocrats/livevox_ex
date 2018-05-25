defmodule Livevox.AgentEventFeed do
  @moduledoc """
  Documentation for Livevox.
  """

  @doc """
  """
  defmacro __using__(_) do
    quote do
      use Agent

      def start_link do
        Task.start_link(fn -> get_activity() end)
      end

      def get_activity do
        resp =
          %{body: %{"token" => token}} =
          Livevox.Api.post("realtime/v6.0/agentEvent/feed", body: %{}, timeout: 12_000)

        handle_events(resp.body["agentEvent"])

        get_activity(token)
      end

      def get_activity(token) do
        resp =
          %{body: %{"token" => new_token}} =
          Livevox.Api.post(
            "realtime/v6.0/agentEvent/feed",
            body: %{token: token},
            timeout: 12_000
          )

        handle_events(resp.body["agentEvent"])

        get_activity(new_token)
      end

      defp handle_events(events) do
        IO.puts("Agents: #{length(events)} events")
        Enum.each(events, fn ev -> spawn(fn -> handle_agent_event(ev) end) end)
      end
    end
  end
end
