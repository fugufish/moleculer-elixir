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

  end
