defmodule Moleculer.Service.ActionTest do
  use ExUnit.Case
  alias Moleculer.Service.Action

  setup do
    start_supervised!(
      {Action,
       %Action{
         name: "test-action",
         node_id: "test-node",
         handler: fn ctx -> true end
       }}
    )

    :ok
  end

  describe "call/1" do
    test "it calls the action handler" do
      assert Action.call(:"test-action", %Moleculer.Context{})
    end
  end
end
