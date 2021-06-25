defmodule Moleculer.Serializer do
  @moduledoc """
  Transporter needs a serializer module which serializes & deserializes the transferred packets.
  The default serializer is the JSONSerializer but there are several built-in serializer.
  """

  defmacro __using__(_) do
    quote do
      use GenServer

      def start_link(_) do
        GenServer.start_link(__MODULE__, [], name: Moleculer.Broker.Serializer)
      end

      def init(_) do
        {:ok, nil}
      end
    end
  end

  @callback handle_call({:serializer, packet :: term()}, from :: term(), state :: term()) ::
              {:reply, String.t(), any()}
  @callback handle_call({:deserialize, packet :: term()}, from :: term(), state :: term()) ::
              {:reply, String.t(), any()}
end
