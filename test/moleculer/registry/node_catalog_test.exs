defmodule Moleculer.Registry.NodeCatalogTest do
  use ExUnit.Case

  alias Moleculer.Registry.NodeCatalog
  alias Moleculer.Registry.Node

  setup do
    start_supervised!(NodeCatalog)
    :ok
  end

  describe "add/1" do
    test "it adds the node to the catalog" do
      NodeCatalog.add(%Node{
        ver: 4,
        sender: :"test-node",
        services: []
      })

      assert Node.name(NodeCatalog.lookup(:"test-node")) == "test-node"
    end
  end
end
