defmodule Moleculer.Service do
  @moduledoc """
  The Service represents a microservice in the Moleculer framework.

  ### Schema
  """

  @callback name() :: String.t()
  @callback actions() :: Map.t()

  defmacro __using__(_) do
    quote do
      @behaviour Moleculer.Service

      use GenServer

      def start_link(service_options) do
        GenServer.start_link(__MODULE__, service_options, name: name())
      end

      def init(options) do
        {:ok, options}
      end

      def handle_call(:remote?, _from, state) do
        {:ok, has_key} = Map.fetch(state, :remote)

        {:reply, has_key || false, state}
      end

      def handle_call(:local?, _from, state) do
        {:ok, has_key} = Map.fetch(state, :remote)

        {:reply, !has_key, state}
      end
    end
  end
end
