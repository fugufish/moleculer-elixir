defmodule Moleculer.Service.Remote do
  defmacro __using__(_) do
    quote do
      use Moleculer.Service

      def name(spec) do
        {:ok, sender} = Map.fetch(spec, :sender)

        String.to_atom(sender)
      end

      def actions(spec) do
        {}
      end

      def remote() do
        true
      end
    end
  end
end
