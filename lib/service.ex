defmodule Moleculer.Service do
  defstruct [:name, :settings]

  @type service_settings :: %{
          optional(:secure_settings) => Map.t(),
          optional(any()) => any()
        }

  @type t :: %__MODULE__{
          name: String.t(),
          settings: service_settings()
        }

  alias Moleculer.DynamicAgent

  @callback name(state :: __MODULE__) :: atom()

  defmacro __using__(_) do
    quote do
      use Moleculer.DynamicAgent
      @behaviour Moleculer.Service

      def start_link(node) do
        Moleculer.Service.start_link(
          __MODULE__,
          node,
          %Moleculer.Service{
            name: name(%{})
          }
        )
      end

      @impl true
      def init(state) do
        children = []

        Moleculer.DynamicAgent.init(children, state, name: state[:name])
      end

      @spec settings() :: Moleculer.Service.service_settings()
      def settings() do
        %{}
      end

      defoverridable settings: 0, start_link: 1
    end
  end

  def start_link(module, node, state) do
    updated = %{state | name: "#{node}.#{state[:name]}"}

    Moleculer.DynamicAgent.start_link(module, updated, name: updated[:name])
  end

  def fetch(spec, :name) do
    {:ok, name} = Map.fetch(spec, :name)

    if is_atom(name) do
      {:ok, name}
    else
      {:ok, String.to_atom(name)}
    end
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
