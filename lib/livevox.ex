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
        resp = %{body: %{"token" => token}} = Livevox.Api.post("realtime/v5.0/callEvent/feed", [body: %{}, timeout: 12_000])

        resp.body["callEvent"]
        |> Enum.each(fn call -> spawn(fn -> handle_call(call) end) end)

        get_calls(token)
      end

      def get_calls(token) do
        resp = %{body: %{"token" => new_token}} = Livevox.Api.post("realtime/v5.0/callEvent/feed", [body: %{token: token}, timeout: 12_000])

        num_calls = Map.get(resp.body, "callEvent", []) |> length()

        resp.body["callEvent"]
        |> Enum.each(fn call -> spawn(fn -> handle_call(call) end) end)

        IO.puts "POST to realtime/v5.0/callEvent/feed with body #{inspect(%{token: token})}. Got response #{inspect(resp.body)}"

        get_calls(new_token)
      end
    end
  end
end
