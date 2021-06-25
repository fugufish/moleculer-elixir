defmodule Moleculer.Serializers.JSONTest do
  use ExUnit.Case

  setup do
    start_supervised!(Moleculer.Serializers.JSON)

    :ok
  end

  describe "serialize/1" do
    test "that it serializes data correctly" do
      serialized =
        Moleculer.Serializer.serialize(%Moleculer.Packets.Discover{ver: 4, sender: "test-node"})

      assert serialized == ~s({"ver":4,"sender":"test-node"})
    end
  end

  describe "test deserialize/1" do
    test "that it deserializes data correctly" do
      deserialized =
        Moleculer.Serializer.deserialize(
          ~s({"ver": 4, "sender": "test-node"}),
          %Moleculer.Packets.Discover{}
        )

      assert deserialized == %Moleculer.Packets.Discover{ver: 4, sender: "test-node"}
    end
  end
end
