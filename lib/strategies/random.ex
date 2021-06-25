defmodule Moleculer.Strategies.Random do
  @moduledoc """
  Selects services at random
  """

  @behaviour Moleculer.Strategy

  @spec select(services :: list(pid())) :: pid()
  def select(list) do
    Enum.random(list)
  end
end
