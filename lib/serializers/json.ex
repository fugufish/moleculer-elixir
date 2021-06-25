defmodule Moleculer.Serializers.JSON do
  @moduledoc """
  This is the default serializer. It serializes the packets to JSON string and deserializes the received data to packet.
  """

  alias Moleculer.Serializer

  use Serializer

  @behaviour Serializer

  @impl true
  def handle_call({:serialize, packet}, _from, state) do
    {:reply, Poison.encode!(packet), state}
  end

  def handle_call({:deserialize, packet}, _from, state) do
    {:reply, Poison.decode!(packet), state}
  end
end
