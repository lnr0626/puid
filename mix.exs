defmodule Puid.Mixfile do
  use Mix.Project

  def project do
    [
      app: :puid,
      version: "2.3.0",
      elixir: "~> 1.14",
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:crypto]
    ]
  end

  defp deps do
    [
      {:dialyxir, "~> 1.4", only: :dev, runtime: false},
      {:earmark, "~> 1.4", only: :dev},
      {:ex_doc, "~> 0.34", only: :dev},
      {:entropy_string, "~> 1.3", only: :test},
      {:misc_random, github: "lnr0626/misc_random", branch: "master", only: :test},
      {:nanoid, "~> 2.1", only: :test},
      {:randomizer, "~> 1.1", only: :test},
      {:secure_random_ex, "~> 0.6", only: :test},
      {:ulid, "~> 0.2", only: :test},
      {:uniq, "~> 0.1", only: :test}
    ]
  end

  defp description do
    """
    Simple, fast, flexible and efficient generation of probably unique identifiers (`puid`, aka
    random strings) of intuitively specified entropy using pre-defined or custom characters.
    """
  end

  defp package do
    [
      maintainers: ["Paul Rogers"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/puid/Elixir",
        "README" => "https://puid.github.io/Elixir/",
        "Docs" => "https://hexdocs.pm/puid/api-reference.html"
      }
    ]
  end
end
