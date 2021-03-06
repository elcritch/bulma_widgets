defmodule BulmaWidgets.CardComponent do
  use Phoenix.LiveComponent
  require Logger

  defstruct id: nil, active: false, selected: nil, index: nil, items: []


  def update(assigns, socket) do

    assigns =
      assigns
      |> Map.put_new(:header, nil)
      |> Map.put_new(:image, nil)
      |> Map.put_new(:content, nil)
      |> Map.put_new(:footers, nil)
      |> Map.put_new(:target, "#bulma-card-#{assigns.id}")

    send(self(), {:widgets, :register, {assigns.id, __MODULE__}})
    {:ok, socket |> assign(assigns)}
  end

  def render(assigns) do
    ~L"""
      <div class="card bulma-widgets-cards " id="<%= @target %>" >
        <header class="card-header">
          <%= unless @header do %>
            <%= @inner_content.(item: :header, target: @target) %>
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
          <%= unless @header do %>
            <%= @inner_content.(item: :image, target: @target) %>
          <%= else %>
            <figure class="image <%= @image[:classes] || 'fa fa-angle-down' %>">
              <img src="<%= @image[:url] %>" alt="<%= @image[:alt_text] %>">
            </figure>
          <%= end %>
        </div>

        <div class="card-content">
          <%= @inner_content.(item: :content, target: @target) %>

          <div class="content">
            <%= @inner_content.(item: :content_item, target: @target) %>
          </div>
        </div>

        <footer class="card-footer">
          <%= unless @footers do %>
            <%= @inner_content.(item: :footer, target: @target) %>
          <%= else %>
            <%= for {name, event_name} <- @footers || [] do %>
              <a phx-click="<%= event_name %>" class="card-footer-item"><%= name %></a>
            <%= end %>
          <%= end %>
        </footer>

      </div>
    """
  end

end
