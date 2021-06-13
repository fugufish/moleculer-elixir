defmodule Moleculer.NodeTest do
  use ExUnit.Case

  alias Moleculer.Node

  setup do
    start_supervised!(%{
      id: :"test-node",
      start: {Node, :start_link, [node_spec()]}
    })

    :ok
  end

  describe "spec/1" do
    test "it returns the spec" do
      assert Map.equal?(Node.spec("test-node"), node_spec())
    end
  end

  describe "service_specs/1" do
    test "it returns the services" do
      {:ok, services} = Map.fetch(node_spec(), :services)
      assert Map.equal?(Node.service_specs("test-node"), services)
    end
  end

  defp node_spec do
    %{
      ver: 4,
      sender: "test-node",
      services: %{
        name: "greeter",
        settings: {},
        metadata: {},
        events: {}
      }
    }
  end
end
