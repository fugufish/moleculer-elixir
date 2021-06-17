defmodule Moleculer.Service do
  defstruct [:name, :settings, :node, :actions]

  alias Moleculer.Service.Action
  alias Moleculer.DynamicAgent
  alias Moleculer.Service

  @type service_settings :: %{
          optional(:secure_settings) => Map.t(),
          optional(any()) => any()
        }

  @type t :: %__MODULE__{
          name: String.t(),
          settings: service_settings(),
          node: atom()
        }

  @type action_list_spec :: %{
          optional(atom()) => Action,
          optional(atom()) => atom(),
          optional(atom()) => %{
            optional(:name) => String.t(),
            optional(:handler) => atom() | Action.callback()
          }
        }

  @callback name(state :: __MODULE__) :: atom()
  @callback settings(state :: __MODULE__) :: service_settings()
  @callback actions(state :: __MODULE__) :: action_list_spec()

  defmacro __using__(_) do
    quote do
      use GenServer
      @behaviour Moleculer.Service

      alias Moleculer.Service

      def start_link() do
        start_link(%{})
      end

      def start_link(spec) do
        start_link(Moleculer.Registry.LocalNode, spec)
      end

      require Logger

      def start_link(node, spec) do
        Logger.debug("starting service '#{name(spec)}'@'#{Service.fqn(node, name(spec))}'")

        GenServer.start_link(
          __MODULE__,
          %Service{
            name: name(spec),
            settings: settings(spec),
            actions: actions(spec)
          },
          name: Service.fqn(node, name(spec))
        )
      end

      @impl true
      def init(spec) do
        {:ok, spec}
      end

      def settings(_) do
        %{}
      end

      def actions(_) do
        %{}
      end

      @impl true
      def handle_call(:name, _from, state) do
        {:reply, state[:name], state}
      end

      def handle_call(:settings, _from, state) do
        {:reply, state[:settings], state}
      end

      defoverridable settings: 1, actions: 1
    end
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
    GenServer.call(service, :name)
  end

  def settings(service) do
    GenServer.call(service, :settings)
  end

  def fqn(node, name) do
    :"#{node}.#{name}"
  end
end
