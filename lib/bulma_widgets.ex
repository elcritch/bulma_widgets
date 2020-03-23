defmodule BulmaWidgets do
  import Phoenix.LiveView
  require Logger

  @type widget_id :: {atom(), module()}
  @type widget_ids :: %{atom() => module()}
  @type widgets :: %{atom() => any()}

  @doc """
  Imports various helpers to handle widget activations and state management.

  Two variables `:widgets` and `:widget_ids` are set in the socket assigns. The
  variable `:widget_ids` maintains a list of widget ids which enables both interactaction
  with widgets. The variable `:widgets` maintains assigns sent from the widgets, generally
  to store the current selection or user input for use elsewhere in the LiveView. The state
  is maintained in the widget itself, so this value is intened to be read-only.

  One usage of this to close all other widgets that have an `active` state such as drop down menus.
  This makes using the widgets feel more cohesive and reduces the work required to configured
  similar behavior with uncennected widgets.
  """
  defmacro __using__(_opts) do
    quote do
      import BulmaWidgets

      def handle_widget(socket, :update, id, updates) do
        socket
      end

      def handle_event("bulma-widgets-close-all", _params, socket) do
        {:noreply, socket |> widget_close_all()}
      end

      def handle_info({:widgets, :register, widget}, socket) do
        {:noreply, socket |> widget_register(widget)}
      end

      def handle_info({:widgets, :active, id, toggle}, socket) do
        {:noreply, socket |> widget_close_all(except: {id, toggle})}
      end

      defoverridable handle_widget: 4
    end
  end

  def widgets_init(socket) do
    socket |> assign(widget_ids: %{}) |> assign(widgets: %{})
  end

  @doc """
  Helper function to register a widget in the LiveView's socket assigns under the `:widgets` variable.
  """
  @spec widget_register(Phoenix.LiveView.Socket.t(), BulmaWidget.widget_id()) :: Phoenix.LiveView.Socket.t()
  def widget_register(socket, {widget_id, widget_module}) do
    widget_ids = socket.assigns[:widget_ids] || %{}
    socket |> assign(widget_ids: Map.put(widget_ids, widget_id, widget_module))
  end

  @doc """
  Helper function to update a widget.
  """
  def widget_update(socket, widget_id, value) when is_list(value) do
    widget_module = socket.assigns.widget_ids[widget_id]
    send_update(widget_module, [id: widget_id, type: :command] ++ value)
    socket
  end

  @doc """
  Open widget.
  """
  def widget_open(socket, widget_id) do
    socket |> widget_update(widget_id, active: true)
  end

  @doc """
  Close widget.
  """
  def widget_close(socket, widget_id) do
    socket |> widget_update(widget_id, active: false)
  end

  @doc """
  Helper function to close all active widgets like dropdowns or other menus.

  An option can be provided to exlucde a single widget:

      iex> socket |> widget_close_all(except: {:widget_id, true || false})

  """
  @spec widget_close_all(Phoenix.LiveView.Socket.t(), [] | [except: {atom(), boolean()}]) :: Phoenix.LiveView.Socket.t()
  def widget_close_all(socket, opts \\ []) do
    {id, toggle} = opts[:except] || {nil, false}

    for {widget_id, module} <- socket.assigns.widget_ids do
      unless widget_id == id && toggle do
        send_update(module, id: widget_id, type: :command, active: false)
      end
    end

    socket
  end

end
