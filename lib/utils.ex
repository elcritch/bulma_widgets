defmodule BulmaWidgets.Utils do

  def is_proplist(lst) when is_list(lst) do
    Enum.all?(lst, fn
      {_, _} -> true
      _ -> false
    end)
  end
end
