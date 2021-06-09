defmodule Moleculer.Registry.ServiceCatalog do
  @moduledoc false

  def start_link(_) do
    Registry.start_link(keys: :duplicate, name: __MODULE__)
  end

  @doc "Adds a new service to the catalog"
  def add(service) do
    Registry.register(__MODULE__, service.name(), service)
  end
end
