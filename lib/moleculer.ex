defmodule Moleculer do
  @moduledoc """
  Moleculer is a fast, modern and powerful microservices framework with 
  implementations in multiple languages.. It helps you to build efficient, 
  reliable & scalable services. Moleculer provides many features for building 
  and managing your microservices.
  """

  @doc """
  Get the loaded version of Moleculer
  """
  def version() do
    {:moleculer, _, version} =
      Enum.find(:application.loaded_applications(), fn {app, _, _version} ->
        app == :moleculer
      end)

    to_string(version)
  end

  @doc """
  Namespace of nodes to segment your nodes on the same network (e.g.: 
  “development”, “staging”, “production”). Default: ""
  """
  def namespace do
    Application.get_env(:broker, :namespace, "")
  end

  def node_id do
    Application.get_env(:broker, :node_id, "")
  end
end
