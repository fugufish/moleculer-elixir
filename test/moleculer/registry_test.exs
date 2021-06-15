defmodule Moleculer.RegistryTest do
  use ExUnit.Case

  setup do
    start_supervised!(%{
      id: Moleculer.Registry,
      start: {Moleculer.Registry, :start_link, []}
    })

    :ok
  end

  describe "init" do
    test "it adds the local node to the catalog" do
      assert Moleculer.Registry.NodeCatalog.lookup(Moleculer.Registry.LocalNode)
    end
  end
end
