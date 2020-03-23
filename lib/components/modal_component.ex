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
      |> Map.put_new(:header?, true)
      |> Map.put_new(:active, false)
      |> Map.put_new(:target, "#bulma-modal-#{assigns.id}")

    send(self(), {:widgets, :register, {assigns.id, __MODULE__}})
    {:ok, socket |> assign(assigns)}
  end

  def render(assigns) do
    ~L"""
      <div class="modal bulma-widgets-modals <%= if @active do 'is-active' end %>"
          id="bulma-modal-<%= @id %>"
          phx-click="modal-click"
          phx-target="<%= @target %>" >
        <div class="modal-background">
        </div>
        <div class="modal-card">
          <header class="modal-card-head">
            <% if @header? do %>
              <%= @inner_content.([modal: :card_header, target: @target]) %>
            <% else %>
              <p class="modal-card-title">
                <%= @inner_content.([modal: :card_title, target: @target]) %>
              </p>
              <button class="delete" aria-label="close">
              </button>
            <% end %>
          </header>

          <section class="modal-card-body">
            <%= @inner_content.([modal: :card_content, target: @target]) %>
          </section>

          <footer class="modal-card-foot">
            <%= @inner_content.([modal: :card_footer, target: @target]) %>
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

  def handle_event("close", _params, socket) do
    {:noreply, socket |> assign(active: false)}
  end

  def handle_event(event, params, socket) do
    Logger.warn("Unhandled modal event: #{inspect event}")
    {:noreply, socket}
  end

end
