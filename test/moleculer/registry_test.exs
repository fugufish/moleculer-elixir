defmodule Moleculer.RegistryTest do
  use ExUnit.Case
  alias Moleculer.{Registry, Registry.Node, Service}

  setup do
    start_supervised!({Registry, []})

    :ok
  end

  describe "add_node/1" do
    test "it adds the node" do
      Registry.add_node(%Node{
        ver: 4,
        sender: "test-node",
        services: []
      })

      assert Registry.lookup_node(:"test-node")
    end

    test "that it adds the services to the registry" do
      Registry.add_node(%Node{
        ver: 4,
        sender: "test-node",
        services: [
          %Service{
            name: "test-service"
          }
        ]
      })

      assert Registry.lookup_service(:"test-service")
    end

    test "that it registers the actions" do
      Registry.add_node(%Node{
        ver: 4,
        sender: "test-node",
        services: [
          %Service{
            name: "test-service",
            actions: %{
              "test-action": "action"
            }
          }
        ]
      })

      assert Registry.lookup_service_for_action(:"test-service.test-action")
    end
  end
end
