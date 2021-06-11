defmodule Moleculer.Service do
  @moduledoc """
  The Service represents a microservice in the Moleculer framework.

  ### Module
  Modules that use Moleculer.Service have some main callbacks: 
  `name`, `version`, `settings`, `actions`, `methods`, and `events`.

  ```elixir
  defmodule MyService do
    use Moleculer.Service

    def name() do
      :"my-service"
    end

    def actions() do
      %{
          add: :add,
          sub: :sub
       }
    end

    def add(context) do
      contex.params.a + contex.params.b
    end

    def sub(context) do
      context.params.a - context.params.b
    end
  end
  ```
  """

  @callback name() :: atom()
  @callback actions() :: Map.t()

  defmacro __using__(_) do
    quote do
      @behaviour Moleculer.Service

      use GenServer

      def start_link(service_options) do
        GenServer.start_link(__MODULE__, service_options,
          name: Map.get(service_options, :name, name())
        )
      end

      def init(options) do
        {:ok, options}
      end

      def handle_call(:remote?, _from, state) do
        {:ok, has_key} = Map.fetch(state, :remote)

        {:reply, has_key || false, state}
      end

      def handle_call(:name, _from, state) do
        {:reply, Map.get(state, :name, name()), state}
      end
    end
  end

  @doc """
  Returns the name of the service.
  """
  @spec name(service :: __MODULE__ | atom()) :: String.t()
  def name(service) do
    GenServer.call(service, :name)
  end

  @doc """
  Returns true if the service is remote.
  """
  @spec remote?(service :: __MODULE__ | atom()) :: boolean()
  def remote?(service) do
    GenServer.call(service, :remote?)
  end

  @doc """
  Returns true of the service is local, otherwise false.
  """
  @spec local?(service :: __MODULE__) :: boolean()
  def local?(service) do
    !remote?(service)
  end
end
