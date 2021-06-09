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

  describe "remote? when true" do
    setup do
      start_supervised!(%{
        id: :"test-service",
        start: {TestService, :start_link, [%{remote: true}]}
      })

      :ok
    end

    test "should return true" do
      assert GenServer.call(:"test-service", :remote?)
    end
  end

  describe "remote? when false" do
    setup do
      start_supervised!(%{
        id: :"test-service",
        start: {TestService, :start_link, [%{remote: false}]}
      })

      :ok
    end

    test "should return false" do
      refute GenServer.call(:"test-service", :remote?)
    end
  end
end
