defmodule Moleculer.ServiceTest do
  use ExUnit.Case
  doctest(Moleculer.Service)

  defmodule TestService do
    use Moleculer.Service

    @impl true
    def name do
      :"test-service"
    end

    @impl true
    def actions do
      %{}
    end
  end

  describe "remote? and local? when remote is true" do
    setup do
      start_supervised!(%{
        id: :"test-service",
        start: {TestService, :start_link, [%{remote: true}]}
      })

      :ok
    end

    test "remote? should return true" do
      assert GenServer.call(:"test-service", :remote?)
    end

    test "local? should return false" do
      refute GenServer.call(:"test-service", :local?)
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
      refute GenServer.call(:"test-service", :remote?)
    end

    test "local? should return true" do
      assert GenServer.call(:"test-service", :local?)
    end
  end
end
