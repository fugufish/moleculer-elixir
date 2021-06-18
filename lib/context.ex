defmodule Moleculer.Context do
  defstruct id: nil,
            node_id: nil,
            action: nil,
            event: nil,
            event_name: nil,
            event_type: nil,
            event_groups: nil,
            caller: nil,
            request_id: nil,
            parent_id: nil,
            params: nil,
            meta: nil,
            locals: nil,
            level: 1,
            span: nil

  @type t :: %__MODULE__{
          id: String.t(),
          node_id: String.t(),
          action: Moleculer.Service.Action.t()
        }

  def fetch(context, key) do
    Map.fetch(context, key)
  end
end
