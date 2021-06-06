defmodule Moleculer.LocalBus do
  @moduledoc false

  use Supervisor

  def start_link(_) do
    Supervisor.start_link(__MODULE__, name: __MODULE__)
  end

  @impl true
  def init(_) do
    children = [
      %{
        id: __MODULE__,
        start: {Registry, :start_link, [[keys: :duplicate, name: __MODULE__]]}
      },
      {Task.Supervisor, name: Moleculer.LocalBus.TaskSupervisor}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def on(topic, listener) do
    elements = String.split(topic, ".") |> Enum.reverse()

    Registry.register(__MODULE__, topic, listener)

    for {key, val} <- elements do
    end
  end

  def listeners do
    Registry.count(__MODULE__)
  end

  def emit(topic, payload = %{}) do
    elements = String.split(topic, ".") |> Enum.reverse()

    Registry.dispatch(__MODULE__, topic, fn entries ->
      for cb <- entries do
      end
    end)
  end
end
