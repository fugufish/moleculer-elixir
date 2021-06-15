defmodule Moleculer.Service do
  defstruct [:name, :settings]

  @type settings :: %{
          optional(:secure_settings) => Map.t(),
          optional(any()) => any()
        }

  @type t :: %__MODULE__{
          name: String.t(),
          settings: settings
        }

  defmacro __using__(_) do
    quote do
      use Supervisor

      def start_link(spec) do
        Supervisor.start_link(__MODULE__, spec, name: spec[:name])
      end

      def init(spec) do
        children = [
          %{
            id: agent_name(spec[:name]),
            start: {Agent, :start_link, [fn -> spec end, [name: agent_name(spec[:name])]]}
          }
        ]

        Supervisor.init(children, strategy: :one_for_one)
      end

      defp agent_name(name) do
        Module.concat(name, Definition)
      end
    end
  end

  def fetch(spec, :name) do
    {:ok, name} = Map.fetch(spec, :name)

    {:ok, String.to_atom(name)}
  end

  def fetch(spec, key) do
    {:ok, value} = Map.fetch(spec, key)

    {:ok, value}
  end

  def name(service) do
    Agent.get(agent_name(service), fn spec -> spec[:name] end)
  end

  def settings(service) do
    Agent.get(agent_name(service), fn spec -> spec[:settings] end)
  end

  defp agent_name(service) do
    Module.concat(service, Definition)
  end
end
