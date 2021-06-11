defmodule Moleculer.ServiceTest do
  use ExUnit.Case
  doctest(Moleculer.Service)

  alias Moleculer.Service

  defmodule TestService do
    use Service

    @impl true
    def name do
      :"test-service"
    end

    @impl true
    def actions do
      %{}
    end
  end

  describe "name/1 should return the service default name" do
    setup do
      start_supervised!(%{
        id: :"test-service",
        start: {TestService, :start_link, [%{}]}
      })

      :ok
    end

    test "it returns the service name" do
      assert Service.name(:"test-service") == :"test-service"
    end
  end

  describe "name/1 should return the explicit service name when defined" do
    setup do
      start_supervised!(%{
        id: :"alternat-service",
        start: {TestService, :start_link, [%{name: :"alternate-service"}]}
      })

      :ok
    end

    test "it returns the explicit service name" do
      assert Service.name(:"alternate-service") == :"alternate-service"
    end
  end

  describe "remote?/1 and local?/1 when remote is true" do
    setup do
      start_supervised!(%{
        id: :"test-service",
        start: {TestService, :start_link, [%{remote: true}]}
      })

      :ok
    end

    test "remote?/1 should return true" do
      assert Service.remote?(:"test-service")
    end

    test "local?/1 should return false" do
      refute Service.local?(:"test-service")
    end
  end

  describe "remote? and local? when remote is false" do
    setup do
      start_supervised!(%{
        id: :"test-service",
        start: {TestService, :start_link, [%{remote: false}]}
      })

      :ok
    end

    test "remote? should return false" do
      refute Service.remote?(:"test-service")
    end

    test "local? should return true" do
      assert Service.local?(:"test-service")
    end
  end
end
