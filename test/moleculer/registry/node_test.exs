defmodule Moleculer.Registry.NodeTest do
  use ExUnit.Case

  alias Moleculer.Registry.Node

  setup do
    start_supervised!({Node, node_spec()})

    :ok
  end

  describe "struct" do
    test "sender should return a symbol" do
      assert node_spec()[:sender] == :"test-node"
    end

    test "ver should be 4" do
      assert node_spec()[:ver] == 4
    end
  end

  describe "name/1" do
    test "that it returns the name of the node" do
      assert Node.name(:"test-node") == :"test-node"
    end
  end

  describe "services/1" do
    test "it returns the service list" do
      assert Node.services(:"test-node") == []
    end
  end

  def node_spec() do
    %Node{
      sender: "test-node"
    }
  end
end
