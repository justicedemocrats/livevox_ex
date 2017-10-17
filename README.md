# Livevox

Elixir API client for Livevox.

## Installation

```elixir
def deps do
  [
    {:livevox, git: "https://github.com/BrandNewCongress/livevox_ex.git"}
  ]
end
```

## Usage

To use the Livevox API, you need to contact their support to get a token. Then,
you'll need to configure `:livevox` with that token, your client name, username,
and password.

```elixir
config :livevox,
  access_token: "401m418098j1m248f9acmasd23d",
  clientname: "myclient",
  username: "myuser",
  password: "mypass"
```

This library will automatically login on the first request using the
`session/v5.0/login` endpoint, and store your credentials in an Elixir agent.
The token will be renewed within an hour before it expires (25 hours).

This library extends HTTPotion.Base, so you can do
```elixir
Livevox.Api.post "reporting/v5.0/standard/agent/activity",
  [body: %{startDate: Timex.shift(Timex.now(), minutes: -5), endDate: Timex.now()}]
```
and your request will be authenticated and serialized properly.

## Call Event Feed

This library was built primarily to access the Call Event Feed, which is a
long-polling process by which a developer can be notified of each call as it happens
in the system.

To use this feature, you must implement a `handle_call` function, import a
Macro, and then start that module as a worker.
```elixir
defmodule MyApp.CallHandler do
  use Livevox.CallEventFeed

  def handle_call(call) do
    if call["agentLoginId"] == "Joey" do
      Logger.info "Joey made a call in livevox"
    end
  end
end
```

and then elsewhere...
```elixir
MyApp.CallHandler.start_link()
```

or in your supeprvision tree:
```elixir
children = [
  worker(MyApp.CallHandler, [])
]
```
