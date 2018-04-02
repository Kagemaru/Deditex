defmodule Deditex.MixProject do
  use Mix.Project

  def project do
    [
      app: :deditex,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:hexfmt, github: "miwee/hexfmt"},
      {:credo, "~> 0.9.0", only: [:dev, :test]},
      {:dialyxir, "~> 0.5.1", only: [:dev], runtime: false},
      {:benchfella, "~> 0.3.5", only: [:dev, :test]},
      {:stubr, "~> 1.5.0", only: [:test]},
      {:bitmap, "~> 1.0", only: [:dev, :test]},
      {:excoveralls, "~> 0.8", only: :test}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end
