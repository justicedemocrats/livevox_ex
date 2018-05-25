defmodule LivevoxEx.Mixfile do
  use Mix.Project

  def project do
    [
      app: :livevox,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Livevox.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpotion, "~> 3.0.3"},
      {:poison, "~> 3.1"},
      {:timex, "~> 3.1"},
      {:short_maps, "~> 0.1.2"}
    ]
  end
end
