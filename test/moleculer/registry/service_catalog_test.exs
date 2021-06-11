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
      start_supervised!(%{
        id: :"test-service",
        start: {ServiceCatalog, :start_link, [%{}]}
      })

      :ok
    end

    test "it returns true when the service of the given name exists" do
      ServiceCatalog.add(TestService)

      assert ServiceCatalog.exists?(:"test-service")
    end
  end

  describe "lookup/2 when options.remote == true" do
    setup do
      start_supervised!(%{
        id: :"test-service",
        start: {ServiceCatalog, :start_link, [%{}]}
      })

      :ok
    end

    test "it returns the correct services" do
      ServiceCatalog.add(TestService, remote: true)

      services = ServiceCatalog.lookup(:"test-service", remote: true)
    end
  end

  describe "lookup/2 when options.local == true" do
    setup do
      start_supervised!(%{
        id: :"test-service",
        start: {ServiceCatalog, :start_link, [%{}]}
      })

      :ok
    end

    test "it returns the correct services" do
      ServiceCatalog.add(TestService, remote: false)

      services = ServiceCatalog.lookup(:"test-service", local: true)
    end
  end
end
