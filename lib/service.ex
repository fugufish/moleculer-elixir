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

      require Logger
      alias Moleculer.Service

      def start_link() do
        start_link(%{})
      end

      def start_link(spec) do
        start_link(Moleculer.Registry.LocalNode, spec)
      end

      def start_link(node, spec) when is_atom(node) do
        Logger.debug(
          "starting service process '#{name(spec)}'@'#{Service.fqn(node, name(spec))}'"
        )

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
        {:reply, name(state), state}
      end

      def handle_call(:settings, _from, state) do
        {:reply, settings(state), state}
      end

      def handle_call(:actions, _from, state) do
        {:reply, actions(state), state}
      end

      def handle_call({:call_action, action, context}, _from, state) do
        if actions(state)[action] do
          {:ok, return} = actions(state)[action] |> process_action(context)

          {:reply, return, state}
        else
          {:error, "No such action exists"}
        end
      end

      defp process_action(action, context) when is_function(action) do
        {:ok, action.(context)}
      end

      defp process_action(action, context) when is_atom(action) do
        process_action(fn context -> apply(__MODULE__, action, [context]) end, context)
      end

      defp process_action(action, context) when is_map(action) do
        process_action(action[:handler], context)
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

  def actions(service) do
    GenServer.call(service, :actions)
  end

  def call(service, action, context) do
    GenServer.call(service, {:call_action, action, context})
  end

  def fqn(node, name) do
    :"#{node}.#{name}"
  end
end
