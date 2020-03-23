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
      |> Map.put_new(:left, nil)
      |> Map.put_new(:right, nil)
      |> Map.put_new(:target, "#bulma-media-#{assigns.id}")

    send(self(), {:widgets, :register, {assigns.id, __MODULE__}})
    {:ok, socket |> assign(assigns)}
  end

  def render(assigns) do
    ~L"""
      <article class="media bulma-medias-modals " id="<%= @target %>" >
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
          <div class="content">
            <%= @inner_content.(item: :content, target: @target) %>
          </div>
        </div>
        <div class="media-right">
          <%= unless @right do %>
            <%= @inner_content.(item: :right, target: @target) %>
          <%= else %>
            <button class="delete"></button>
          <%= end %>
        </div>
      </article>
    """
  end

end
