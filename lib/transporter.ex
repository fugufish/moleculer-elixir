defmodule Moleculer.Transporter do
  @moduledoc """
  In order to communicate with other nodes (ServiceBrokers) you need to configure a 
  transporter. Most of the supported transporters connect to a central message broker 
  that provide a reliable way of exchanging messages among remote nodes. These 
  message brokers mainly support publish/subscribe messaging pattern.

  Transporter is an important module if you are running services on multiple nodes. 
  Transporters communicate with other nodes. It transfers events, calls requests and 
  processes responses …etc. If multiple instances of a service are running on different
  nodes then the requests will be load-balanced among them.
  """

  alias Moleculer.{Transporter, Serializer, Broker, Packets}

  defmacro __using__(_) do
    quote do
      use GenServer

      @behaviour Moleculer.Transporter

      def start_link(_) do
        GenServer.start_link(__MODULE__, [], name: Broker.Transporter)
      end
    end
  end

  @callback connect() :: :ok
  @callback disconnect() :: :ok
  @callback subscribe(topic :: atom(), node_id :: atom()) :: :ok
  @callback send(topic :: atom(), data :: term()) :: :ok

  @doc """
  Receive is called by the transporter implmentation when a message is rceived from the
  transport bus.
  # """
  # @spec receive_message(topic :: atom(), msg :: String.t())
  # def receive_message(topic, msg) do
  #   process_message_for_topic(String.split(topic, "."), message)
  # end

  @doc """
  Returns the topic name
  """
  @spec get_topic_name(topic :: String.t(), node_id :: String.t()) :: String.t()
  def get_topic_name(topic, node_id) do
    ["MOL", Broker.namespace(), node_id, topic]
    |> Enum.filter(&(!is_nil(&1)))
    |> Enum.join(".")
  end

  defp process_message_for_topic([_, "DISCOVER", _], msg) do
    process_discover_packet(msg)
  end

  defp process_message_for_topic(["MOL", "DISCOVER"], msg) do
    process_discover_packet(msg)
  end

  defp process_discover_packet(msg) do
    Serializer.deserialize(msg, %Packets.Discover{})
  end
end
