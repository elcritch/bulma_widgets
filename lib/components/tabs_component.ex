defmodule BulmaWidgets.TabsComponent do
  use Phoenix.LiveComponent
  require Logger

  defstruct id: nil, active: false, selected: nil, index: nil, items: []

  def update(%{type: :command, active: _active?, id: _id}, socket) do
    {:ok, socket}
  end

  def update(assigns, socket) do
    unless assigns[:items] do
        raise(%ArgumentError{
          message: "tabs component requires :items keyword not found in #{inspect(assigns)}"
        })
    end

    items = for {v, i} <- Enum.with_index(assigns.items) do {"#{i}-idx", v} end
    {default_index, default_selected} = Enum.at(items, 0, {nil, nil})

    assigns =
      assigns
      |> Map.put_new(:assign_value, false)
      |> Map.put_new(:icons, %{})
      |> Map.put_new(:index, socket.assigns[:index] || default_index)
      |> Map.put_new(:selected, socket.assigns[:selected] || default_selected)

    send(self(), {:widgets, :register, {assigns.id, __MODULE__}})
    {:ok, socket |> assign(assigns) |> assign(items: items)}
  end

  def render(assigns) do
    ~L"""
      <div class="tabs bulma-widgets-tabs widgets-tabs-width <%= @classes %>"
           id="bulma-tabs-<%= @id %>" >
        <ul>
          <%= for {key, item} <- @items do %>
            <li href="#" class="tabs-item <%= if key == @index do 'is-active' end %>"
                phx-value-key="<%= key %>"
                phx-click="selected"
                phx-target="#bulma-tabs-<%= @id %>" >
              <a>
                <%= case @icons[item] do %>
                  <%= nil -> %>
                    <%= item %>
                  <%= icon -> %>
                    <span class="icon is-small"><i class="<%= icon %>" aria-hidden="true"></i></span>
                    <span><%= item %></span>
                <%= end %>
              </a>
            </li>
          <%= end %>
        </ul>
      </div>
      <div class="tabs-content ">
        <%= for {key, item} <- @items do %>
          <div style="<%= if key != @index do 'display: none;' end %>">
            <%= @inner_content.([item: item]) %>
          </div>
        <%= end %>
      </div>

    """
  end

  def handle_event("selected", params, socket) do
    {key, item} = socket.assigns.items |> List.keyfind(params["key"], 0)

    send(self(), {:widgets, :active, socket.assigns.id, false})
    if socket.assigns.assign_value do
      send(self(), {:widgets, :assign_value, socket.assigns.id, item})
    end
    {:noreply, socket |> assign(index: key, selected: item)}
  end
end
