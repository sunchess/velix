defmodule Velix.Mixfile do
  use Mix.Project

  def project do
    [
      app: :velix,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :verx]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      {:verx, git: "git://github.com/sunchess/verx.git", override: true, branch: :master},
      {:quickrand, "~> 1.7.2"}
    ]
  end
end
