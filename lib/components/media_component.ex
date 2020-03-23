defmodule BulmaWidgets.MediaComponent do
  use Phoenix.LiveComponent
  require Logger

  defstruct id: nil, active: false, selected: nil, index: nil, items: []

  def update(%{type: :command, active: active?, id: id}, socket) do
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
      <div class="media bulma-medias-modals <%= if @active do 'is-active' end %>"
          id="bulma-medias-<%= @id %>" >
        <div class="media-left">
          <%= unless @left do %>
            <%= @inner_content.(item: :left, target: @target) %>
          <%= else %>
            <figure class="image <%= @left[:left_classes] %>">
              <img src="<%= @left[:url] %>" alt="<%= @left[:url_alt] %>">
            </figure>
          <%= end %>
        </div>
        <div class="media-content">
          <%= @inner_content.(item: :left, target: @target) %>
        </div>
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
