defmodule Moleculer.DynamicAgent do
  @typep supervisor_return ::
           {:ok, {:supervisor.sup_flags(), [:supervisor.child_spec()]}} | :ignore

  @callback init(state :: any(), name: name :: atom()) :: supervisor_return()

  import Moleculer.Utils.Naming

  defmacro __using__(_) do
    quote do
      use Supervisor
      import Moleculer.Utils.Naming
    end
  end

  def start_link(module, state, name: name) do
    Supervisor.start_link(module, state, name: name)
  end

  @spec init(children :: list(:supervisor.child_spec()), state :: term(), name: name :: atom()) ::
          supervisor_return()
  def init(children, state, name: name) do
    ch =
      [
        %{
          id: name |> agent_name,
          start: {Agent, :start_link, [fn -> state end, [name: name |> agent_name]]}
        },
        {DynamicSupervisor, strategy: :one_for_one, name: name |> dynamic_supervisor_name}
      ] ++ children

    Supervisor.init(ch, strategy: :one_for_one)
  end
end
