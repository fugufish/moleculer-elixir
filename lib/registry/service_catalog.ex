defmodule Moleculer.Registry.ServiceCatalog do
  @moduledoc false

  use Supervisor

  def start_link(_) do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(_) do
    children = [
      {Registry, [keys: :duplicate, name: __MODULE__.Registry]},
      {DynamicSupervisor, [name: __MODULE__.ServiceSupervisor, strategy: :one_for_one]}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  @doc """
  Adds a local service to the catalog.
  """
  @spec add(service :: Moleculer.Service) :: :ok
  def add(service) do
    add(service, remote: false)
  end

  @doc """
  Adds a new service to the catalog with the provided options.
  """
  @spec add(service :: Moleculer.Service, options :: map()) :: :ok
  def add(service, options) do
    {:ok, pid} = DynamicSupervisor.start_child(__MODULE__.ServiceSupervisor, {service, options})

    Registry.register(__MODULE__.Registry, service.name(), pid)

    :ok
  end

  @doc """
  Returns true if the service of the given name exists. Otherwise false.
  """
  @spec exists?(name :: atom()) :: boolean()
  def exists?(name) do
    entries = lookup(name)

    Enum.count(entries) > 0
  end

  @doc """
  Returns a list of `pid`s for the provided service name.
  """
  @spec lookup(name :: atom()) :: [{pid(), any()}]
  def lookup(name) do
    Registry.lookup(__MODULE__.Registry, name)
  end

  def lookup(name, remote: true) do
    entries = lookup(name)

    Enum.filter(entries, fn e -> send(elem(e, 0), :remote?) end)
  end

  def lookup(name, local: true) do
    entries = lookup(name)

    Enum.filter(entries, fn e -> send(elem(e, 0), :local?) end)
  end
end
