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
end
