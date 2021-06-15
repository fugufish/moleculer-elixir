defmodule Moleculer.Service.Action do
  @enforce_keys [:name]
  defstruct [:name, :node_id, :handler]

  @type t :: %__MODULE__{
          name: String.t(),
          node_id: String.t()
        }

  alias Moleculer.Service

  use GenServer

  def start_link(spec) do
    GenServer.start_link(__MODULE__, spec, name: spec[:name])
  end

  @impl true
  def init(spec) do
    {:ok, spec}
  end

  @impl true
  def handle_call({:call, context}, _from, spec) do
    {:reply, spec[:handler].(context), spec}
  end

  def call(action, context) do
    GenServer.call(action, {:call, context})
  end

  def fetch(action, :name) do
    {:ok, name} = Map.fetch(action, :name)

    {:ok, String.to_atom(name)}
  end

  def fetch(action, key) do
    Map.fetch(action, key)
  end
end
