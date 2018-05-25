defmodule Livevox.State.Services do
  use Agent
  import ShortMaps

  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def handle_agent_event(agent_event) do
    ~m(agentId timestamp agentServiceId eventType sessionId callServiceId) = agent_event

    Agent.update(__MODULE__, fn state ->
      if Map.has_key?(state, agentServiceId) do
        state
      else
        Map.put(state, agentServiceId, %{
          calls_in_progress: 0,
          logged_in_agents: 0,
          ready_agents: 0
        })
      end
    end)

    case eventType do
      "LOGON" ->
        gen_modifier([agentServiceId, :logged_in_agents], 1)

      "LOGOFF" ->
        gen_modifier([agentServiceId, :logged_in_agents], -1)

      "READY" ->
        gen_modifier([agentServiceId, :ready_agents], 1)

      "NOT_READY" ->
        gen_modifier([agentServiceId, :ready_agents], -1)

      "IN_CALL" ->
        gen_modifier([agentServiceId, :calls_in_progress], 1)

      # What's done?
      "WRAP_UP" ->
        gen_modifier([agentServiceId, :calls_in_progress], -1)

      _ ->
        nil
    end
  end

  defp gen_modifier(path, additive) do
    fn ->
      Agent.update(__MODULE__, fn state ->
        n = get_in(state, path)
        put_in(state, path, n + additive)
      end)
    end
  end
end
