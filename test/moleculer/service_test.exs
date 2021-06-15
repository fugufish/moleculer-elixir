defmodule Moleculer.ServiceTest do
  use ExUnit.Case

  alias Moleculer.Service

  defmodule TestService do
    use Service

    @impl true
    def name(_) do
      :"test-service"
    end

    def settings() do
      %{some_setting: true}
    end
  end

  setup do
    start_supervised!({TestService, :"test-node"})

    :ok
  end

  describe "name/1" do
    test "that it returns the name of the service" do
      assert Service.name(:"test-node.test-service") == :"test-node.test-service"
    end
  end

  describe "settings/1" do
    test "it returns the service settings" do
      assert Service.settings(:"test-service") == %{some_setting: true}
    end
  end

  def service_spec() do
    %Service{
      settings: %{
        some_setting: true
      }
    }
  end
end
