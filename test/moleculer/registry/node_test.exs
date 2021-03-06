defmodule Moleculer.Registry.NodeTest do
  use ExUnit.Case

  alias Moleculer.Registry.Node

  setup do
    start_supervised!({Node, node_spec()})

    Node.wait_for_services(:"test-node")
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

    test "that it returns the name of the node when passed a struct" do
      assert Node.name(node_spec) == :"test-node"
    end
  end

  describe "services/1" do
    test "that it returns the srevices" do
      svcs = Node.services(:"test-node")
      assert Moleculer.Service.name(svcs[:"test-service"]) == :"test-service"
    end
  end

  describe "spec/1" do
    test "it returns the node spec" do
      assert Node.spec(:"test-node") == node_spec()
    end
  end

  def node_spec() do
    %Node{
      sender: "test-node",
      services: [
        %Moleculer.Service{
          name: :"test-service",
          settings: %{},
          actions: %{}
        }
      ]
    }
  end
end
