defmodule Livevox.State.Agents do
  use Agent
  import ShortMaps

  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def handle_agent_event(agent_event) do
    ~m(agentId timestamp agentServiceId eventType sessionId callServiceId) = agent_event

    agent_exists =
      Agent.get(__MODULE__, fn state ->
        Map.has_key?(state, agentId)
      end)

    case eventType do
      "LOGON" ->
        add_agent(agent_event)

      "LOGOFF" ->
        remove_agent(agent_event)

      "READY" ->
        mark_ready(agent_event)

      "NOT_READY" ->
        mark_not_ready(agent_event)

      # What's done?
      "WRAP_UP" ->
        record_result(agent_event)
    end
  end

  # TODO -> increment logged in agents for each service
  #   - number of calls made
  #   - what session they were in
  defp add_agent(agent_event) do
    ~m(agentId timestamp agentServiceId eventType sessionId callServiceId) = agent_event

    Agent.update(__MODULE__, fn state ->
      Map.put(state, agentId, %{
        state: eventType,
        state_history: [{timestamp, %{state: eventType, service: agentServiceId}}]
      })
    end)
  end

  # TODO -> Save session record with
  #   - number of calls made
  #   - what session they were in
  defp remove_agent(agent_event) do
    IO.inspect(agent_event)
  end

  # TODO -> Update agent state
  defp begin_call(agent_event) do
    IO.inspect(agent_event)
  end

  # TODO -> Save call record
  #   - post result to action kit
  #   - maybe something else
  defp record_result(agent_event) do
    IO.inspect(agent_event)
  end

  # TODO ->
  #   -
  defp mark_ready(agent_event) do
    IO.inspect(agent_event)
  end

  # TODO ->
  #   -
  defp mark_not_ready(agent_event) do
    IO.inspect(agent_event)
  end
end
