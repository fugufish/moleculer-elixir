defmodule Moleculer.Utils.Naming do
  @moduledoc """
  Utility functions
  """

  @doc """
  Builds a consistent agent name
  """
  @spec agent_name(mod :: atom()) :: atom()
  def agent_name(mod) do
    Module.concat(mod, Agent)
  end

  @doc """
  Builds a consistent dynamic supervisor name
  """
  @spec dynamic_supervisor_name(mod :: atom()) :: atom()
  def dynamic_supervisor_name(mod) do
    Module.concat(mod, DynamicSupervisor)
  end

  @doc """
  Builds a consistent task supervisor name
  """
  @spec task_supervisor_name(mod :: atom()) :: atom()
  def task_supervisor_name(mod) do
    Module.concat(mod, TaskSupervisor)
  end


  @doc """
  Builds a consistent registry name
  """
  @spec registry_name(mod :: atom()) :: atom()
  def registry_name(mod) do
    Module.concat(mod, Registry)
  end
end
