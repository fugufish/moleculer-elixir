defmodule Moleculer.DynamicAgent do
  @typep supervisor_return ::
           {:ok, {:supervisor.sup_flags(), [:supervisor.child_spec()]}} | :ignore

  require Logger

  import Moleculer.Utils.Naming

  defmacro __using__(_) do
    quote do
      use Supervisor
      import Moleculer.Utils.Naming

      def which_children(name) do
        Moleculer.DynamicAgent.which_children(name)
      end

      def start_child(name, spec) do
        Moleculer.DynamicAgent.start_child(name, spec)
      end
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
        {DynamicSupervisor, strategy: :one_for_one, name: name |> dynamic_supervisor_name},
        {Task.Supervisor, strategy: :one_for_one, name: name |> task_supervisor_name}
      ] ++ children

    Supervisor.init(ch, strategy: :one_for_one)
  end

  def start_child(name, child_spec) do
    DynamicSupervisor.start_child(name |> dynamic_supervisor_name, child_spec)
  end

  def which_children(name) do
    DynamicSupervisor.which_children(name |> dynamic_supervisor_name)
  end

  @doc """
  Returns a state value of the provided agent
  """
  @spec get(module :: atom(), callback :: fun()) :: term()
  def get(module, cb) do
    agent_name(module) |> Agent.get(cb)
  end
end
