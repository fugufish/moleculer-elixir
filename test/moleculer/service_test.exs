defmodule Moleculer.ServiceTest do
  use ExUnit.Case

  alias Moleculer.Service

  defmodule TestService do
    use Service

    @impl true
    def name(_) do
      :"test-service"
    end

    @impl true
    def settings(_) do
      %{some_setting: true}
    end

    @impl true
    def actions(_) do
      %{
        sum: :sum,
        sub: %{
          handler: :sub
        },
        mult: %{
          handler: fn ctx -> ctx[:params][:a] * ctx[:params][:b] end
        }
      }
    end
  end

  setup do
    start_supervised!(TestService)

    :ok
  end

  describe "name/1" do
    test "that it returns the name of the service" do
      assert Service.name(:"Elixir.Moleculer.Registry.LocalNode.test-service") == :"test-service"
    end
  end

  describe "settings/1" do
    test "it returns the service settings" do
      assert Service.settings(:"Elixir.Moleculer.Registry.LocalNode.test-service") == %{
               some_setting: true
             }
    end
  end
end
