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
        mult: fn ctx -> ctx[:params][:a] * ctx[:params][:b] end,
        div: %{
          handler: fn ctx -> ctx[:params][:a] / ctx[:params][:b] end
        }
      }
    end

    def sum(context) do
      context[:params][:a] + context[:params][:b]
    end

    def sub(context) do
      context[:params][:a] - context[:params][:b]
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

  describe "call/1" do
    test " that it calls the action correctly when defined as an atom" do
      assert Service.call(
               :"Elixir.Moleculer.Registry.LocalNode.test-service",
               :sum,
               %Moleculer.Context{
                 params: %{
                   a: 2,
                   b: 2
                 }
               }
             ) == 4
    end

    test "that it calls the action correctly when defined as a funtion" do
      assert Service.call(
               :"Elixir.Moleculer.Registry.LocalNode.test-service",
               :mult,
               %Moleculer.Context{
                 params: %{
                   a: 2,
                   b: 2
                 }
               }
             ) == 4
    end

    test "that it calls the action correctly when defined as a map" do
      assert Service.call(
               :"Elixir.Moleculer.Registry.LocalNode.test-service",
               :sub,
               %Moleculer.Context{
                 params: %{
                   a: 4,
                   b: 2
                 }
               }
             ) == 2

      assert Service.call(
               :"Elixir.Moleculer.Registry.LocalNode.test-service",
               :div,
               %Moleculer.Context{
                 params: %{
                   a: 4,
                   b: 2
                 }
               }
             ) == 2
    end
  end
end
