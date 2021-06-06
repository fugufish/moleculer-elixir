defmodule Moleculer.Utils do
  @moduledoc false
  def get_node_id() do
    {:ok, hostname} = :inet.gethostname()

    "#{hostname}-#{:erlang.unique_integer()}"
  end
end
