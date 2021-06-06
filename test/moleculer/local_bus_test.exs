defmodule Moleculer.LocalBusTest do
  use ExUnit.Case

  setup do
    {:ok, _} =
      Supervisor.start_link([Moleculer.LocalBus], strategy: :one_for_one, name: __MODULE__)

    :ok
  end

  describe "on/2" do
    test "it adds a subscription" do
      Moleculer.LocalBus.on("test", fn -> true end)

      assert Moleculer.LocalBus.listeners() == 1
    end
  end
end
