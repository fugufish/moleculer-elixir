defmodule Simple.MathService do
  use Moleculer.Service

  @impl true
  def name do
    "math"
  end

  @impl true
  def actions do
    %{
      add: %{
        function: :add
      },
      subtract: %{
        function: :subtract
      },
      mult: %{
        function: :mult,
        params: %{
          a: :number,
          b: :number
        }
      },
      div: {
        params: %{
          a: {
            type: :number,
            notEqualTo: 0
          },
          b: {
            type: :number,
            notEqualTo: 0
          }
        }
      }
    }
  end

  def add(context) do
  end

end
