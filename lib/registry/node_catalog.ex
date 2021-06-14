defmodule Moleculer.Registry.NodeCatalog do
  @moduledoc """
  Catalog for Moleculer nodes
  """
  alias Moleculer.Registry.Catalog
  alias Moleculer.Registry.ServiceCatalog
  alias Moleculer.Node

  use Catalog

  def add(name) do
    add(Node, name, %{ver: 4, sender: name, services: %{}})
  end

  defp additional_children do
    [
      {Task, fn -> add(LocalNode) end}
    ]
  end
end
