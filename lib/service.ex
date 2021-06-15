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

  alias Moleculer.DynamicAgent

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
    DynamicAgent.get(service, fn spec -> spec[:name] end)
  end

  def settings(service) do
    DynamicAgent.get(service, fn spec -> spec[:settings] end)
  end
end
