defmodule Moleculer.Registry.NodeCatalog do
  @moduledoc """
  Catalog for Moleculer nodes
  """
  use Supervisor

  def start_link(_) do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    children = [
      {Registry, [keys: :duplicate, name: __MODULE__.Registry]},
      {DynamicSupervisor, [name: __MODULE__.ServiceSupervisor, strategy: :one_for_one]}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def lookup(name) do
    Registry.lookup(__MODULE__.Registry, name)
  end

  def add(spec) do
    services = parse_services(spec[:services])

    {:ok, pid} =
      DynamicSupervisor.start_child(
        __MODULE__.ServiceSupervisor,
        {Moleculer.Registry.Node, %Moleculer.Registry.Node{spec | services: services}}
      )

    Registry.register(__MODULE__.Registry, spec[:sender], pid)

    :ok
  end

  defp parse_services(services) do
    Enum.map(services, fn service -> parse_service(service) end)
  end

  defp parse_service(service) when is_atom(service) do
    service
  end

  defp parse_service(service) when is_map(service) do
    {Moleculer.Service.Remote,
     [
       %Moleculer.Service{
         name: service[:name],
         settings: service[:settings],
         actions: service[:actions]
       }
     ]}
  end
end
