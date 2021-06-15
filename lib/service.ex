defmodule Moleculer.Service do
  import Moleculer.Utils.Naming
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
      use Moleculer.DynamicAgent

      def start_link(state) do
        Moleculer.DynamicAgent.start_link(__MODULE__, state, name: state[:name])
      end

      @impl true
      def init(state) do
        children = []

        Moleculer.DynamicAgent.init(children, state, name: state[:name])
      end
    end
  end

  def fetch(spec, :name) do
    {:ok, name} = Map.fetch(spec, :name)

    {:ok, String.to_atom(name)}
  end

  def fetch(spec, key) do
    Map.fetch(spec, key)
  end

  def name(service) do
    agent_name(service) |> Agent.get(fn spec -> spec[:name] end)
  end

  def settings(service) do
    agent_name(service) |> Agent.get(fn spec -> spec[:settings] end)
  end
end
