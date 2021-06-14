defmodule Moleculer.Registry.ServiceCatalogTest do
  use ExUnit.Case

  alias Moleculer.Registry.ServiceCatalog

  defmodule TestService do
    use Moleculer.Service

    def name() do
      :"test-service"
    end

    def actions() do
      %{}
    end
  end

  describe "exists/1" do
    setup do
      start_supervised!({ServiceCatalog, []})

      :ok
    end

    test "it returns true when the service of the given name exists" do
      ServiceCatalog.add(TestService)

      assert ServiceCatalog.lookup(:"test-service")
    end
  end
end
