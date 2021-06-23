defmodule Moleculer.Registry.NodeCatalog do
  @moduledoc """
  Catalog for Moleculer nodes
  """
  use Moleculer.DynamicAgent

  alias Moleculer.DynamicAgent

  def init(_) do
    DynamicAgent.init([], %{}, name: __MODULE__)
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
    %Moleculer.Service{
      name: service[:name],
      settings: service[:settings],
      actions: service[:actions]
    }
  end
end
