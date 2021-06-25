defmodule Moleculer.Serializers.JSONTest do
  use ExUnit.Case

  setup do
    start_supervised!(Moleculer.Serializers.JSON)

    :ok
  end

  describe "serialize/1" do
    test "that it serializes data correctly" do
      serialized = GenServer.call(Moleculer.Broker.Serializer, {:serialize, %{foo: "bar"}})

      assert serialized == "{\"foo\":\"bar\"}"
    end
  end

  describe "test deserialize/1" do
    test "that it deserializes data correctly" do
      deserialized =
        GenServer.call(Moleculer.Broker.Serializer, {:deserialize, "{\"foo\":\"bar\"}"})

      assert deserialized == %{"foo" => "bar"}
    end
  end
end
