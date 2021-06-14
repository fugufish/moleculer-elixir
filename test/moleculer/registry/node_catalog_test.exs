defmodule Moleculer.Registry.NodeCatalogTest do
  use ExUnit.Case

  alias Moleculer.Registry.NodeCatalog

  setup do
    start_supervised!({NodeCatalog, []})

    :ok
  end

  test "it adds the local node to the catalog" do
    assert NodeCatalog.lookup(NodeCatalog.LocalNode)
  end

  describe "add/1" do
    test "its adds nodes correctly" do
      NodeCatalog.add(SomeNode)

      assert NodeCatalog.lookup(SomeNode)
    end
  end
end
