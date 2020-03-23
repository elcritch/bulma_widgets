defmodule BulmaWidgets.ModalComponent do
  use Phoenix.LiveComponent
  require Logger

  defstruct id: nil, active: false, selected: nil, index: nil, items: []

  def update(%{type: :command, active: active?, id: id}, socket) do
    Logger.warn("modal open: #{inspect id}")
    {:ok, socket |> assign(active: active?)}
  end

  def update(assigns, socket) do

    assigns =
      assigns
      |> Map.put_new(:title, nil)
      |> Map.put_new(:footer, nil)
      |> Map.put_new(:active, false)
      |> Map.put_new(:target, "#bulma-modal-#{assigns.id}")

    send(self(), {:widgets, :register, {assigns.id, __MODULE__}})
    {:ok, socket |> assign(assigns)}
  end

  def render(assigns) do
    ~L"""
      <div class="modal bulma-widgets-modals <%= if @active do 'is-active' end %>"
          id="bulma-modal-<%= @id %>" >
        <div class="modal-background" >
        </div>
        <div class="modal-card" phx-click="modal-click" phx-target="<%= @target %>" >
          <header class="modal-card-head">
            <%= if @title do %>
              <p class="modal-card-title"> <%= @title %> </p>
              <button class="delete" phx-click="delete" phx-target="<%= @target %>" aria-label="close">
              </button>
            <%= else %>
              <%= @inner_content.([modal: :card_header, target: @target]) %>
            <%= end %>
          </header>

          <section class="modal-card-body">
            <%= @inner_content.([modal: :card_content, target: @target]) %>
          </section>

          <footer class="modal-card-foot">
            <%= if @footer do %>
              <button class="button <%= @footer[:ok_classes] || 'is-success' %>" phx-click="save" phx-target="<%= @target %>">
                <%= @footer[:ok] || "Ok" %>
              </button>
              <button class="button <%= @footer[:cancel_classes] || '' %>" phx-click="cancel" phx-target="<%= @target %>">
                <%= @footer[:cancel]  || "Cancel"%>
              </button>
            <%= else %>
              <%= @inner_content.([modal: :card_footer, target: @target]) %>
            <%= end %>
          </footer>
        </div>
      </div>
    """
  end

  def handle_event("modal-click", _params, socket) do
    Logger.warn("modal click: #{inspect _params}")
    {:noreply, socket}
  end

  def handle_event("save", _params, socket) do
    case socket.assigns[:save] do
      func when is_function(func) ->
        func.()
      nil ->
        :ok
    end
    {:noreply, socket |> assign(active: false)}
  end

  def handle_event("cancel", _params, socket) do
    {:noreply, socket |> assign(active: false)}
  end

  def handle_event("delete", _params, socket) do
    {:noreply, socket |> assign(active: false)}
  end

  def handle_event("close", _params, socket) do
    {:noreply, socket |> assign(active: false)}
  end

  def handle_event(event, params, socket) do
    Logger.warn("Unhandled modal event: #{inspect event}")
    {:noreply, socket}
  end

end
