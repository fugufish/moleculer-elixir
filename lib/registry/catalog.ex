defmodule Moleculer.Registry.Catalog do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      @bahavior Moleculer.Registry.Catalog

      use Supervisor

      def start_link(_) do
        Supervisor.start_link(__MODULE__, [], name: __MODULE__)
      end

      def init(_) do
        children =
          [
            {Registry, [keys: :duplicate, name: __MODULE__.Registry]},
            {DynamicSupervisor, [name: __MODULE__.ServiceSupervisor, strategy: :one_for_one]}
          ] ++ additional_children()

        Supervisor.init(children, strategy: :one_for_one)
      end

      def lookup(name) do
        Moleculer.Registry.Catalog.lookup(__MODULE__, name)
      end

      defp add(item, name, args) do
        Moleculer.Registry.Catalog.add(__MODULE__, item, name, args)
      end

      defp additional_children do
        []
      end

      defoverridable additional_children: 0
    end
  end

  def add(module, item, name, args) do
    {:ok, pid} =
      DynamicSupervisor.start_child(Module.concat(module, ServiceSupervisor), {item, args})

    Registry.register(Module.concat(module, Registry), name, pid)

    :ok
  end

  def lookup(module, name) do
    Registry.lookup(Module.concat(module, Registry), name)
  end
end
