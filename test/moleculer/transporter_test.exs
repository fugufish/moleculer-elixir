defmodule Moleculer.TransporterTest do
  use ExUnit.Case

  describe "get_topic_name/2" do
    test "it returns the correct topic name" do
      assert Moleculer.Transporter.get_topic_name("test", "test-node") == "MOL.test-node.test"
    end
  end
end
