defmodule Moleculer.Service.RemoteTest do
  use ExUnit.Case

  alias Moleculer.Service
  alias Moleculer.Service.Remote

  setup do
    start_supervised!(%{
      id: :"test-remote",
      start:
        {Remote, :start_link,
         [
           :"test-node",
           %{
             name: :"test-remote",
             settings: %{test_setting: true}
           }
         ]}
    })

    :ok
  end

  describe "name" do
    test "it sets the name" do
      assert Service.name(:"test-node.test-remote") == :"test-remote"
    end
  end

  describe "settings" do
    test "it sets the settings" do
      assert Service.settings(:"test-node.test-remote") == %{test_setting: true}
    end
  end
end
