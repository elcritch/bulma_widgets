defmodule BulmaWidgets.CardComponent do
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
      <div class="card bulma-widgets-cards " id="bulma-card-<%= @id %>" >
      <div class="card">

        <header class="card-header">
          <%= unless @header do %>
            <%= @inner_content.([modal: :header, target: @target]) %>
          <%= else %>
            <p class="card-header-title">
              <%= @header[:title] %>
            </p>
            <a href="<%= @header[:url] %>" class="card-header-icon" aria-label="<%= @header[:aria] %>">
              <span class="icon">
                <i class="<%= @header[:icon] %>" aria-hidden="true"></i>
              </span>
            </a>
          <%= end %>
        </header>

        <div class="card-image">
          <figure class="image is-4by3">
            <img src="https://bulma.io/images/placeholders/1280x960.png" alt="Placeholder image">
          </figure>
        </div>

        <div class="card-content">

          <div class="media">
            <div class="media-left">
              <figure class="image is-48x48">
                <img src="https://bulma.io/images/placeholders/96x96.png" alt="Placeholder image">
              </figure>
            </div>
            <div class="media-content">
              <p class="title is-4">John Smith</p>
              <p class="subtitle is-6">@johnsmith</p>
            </div>
          </div>

          <div class="content">
            Lorem ipsum dolor sit amet, consectetur adipiscing elit.
            Phasellus nec iaculis mauris. <a>@bulmaio</a>.
            <a href="#">#css</a> <a href="#">#responsive</a>
            <br>
            <time datetime="2016-1-1">11:09 PM - 1 Jan 2016</time>
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
