defmodule Moleculer.Registry.ServiceCatalog do
  @moduledoc false

  use Moleculer.Registry.Catalog

  alias Moleculer.Service

  @doc """
  Adds a new service to the catalog with the provided options.
  """
  @spec add(service :: Service) :: :ok
  def add(service) do
    add(service, service.name(), %{})
  end
end
