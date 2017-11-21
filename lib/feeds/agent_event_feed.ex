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
        Task.start_link(fn -> get_calls() end)
      end

      def get_activity do
        resp =
          %{body: %{"token" => token}} =
          Livevox.Api.post("realtime/v6.0/agentEvent/feed", body: %{}, timeout: 12_000)

        resp.body["agentEvent"]
        |> Enum.each(fn event -> spawn(fn -> handle_event(event) end) end)

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

        resp.body["agentEvent"]
        |> Enum.each(fn event -> spawn(fn -> handle_event(event) end) end)

        get_activity(new_token)
      end
    end
  end
end
