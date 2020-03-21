defmodule BulmaWidgets.DropdownComponent do
  use Phoenix.LiveComponent
  require Logger

  defstruct id: nil, active: false, selected: nil, index: nil, items: []

  def update(%{type: :command, active: active?, id: _id} = _cmd, socket) do
    {:ok, socket |> assign(active: active?)}
  end

  def update(assigns, socket) do
    # Logger.debug("bulma updating widget: #{__MODULE__}: assigns: #{inspect([assigns: assigns])}")
    # Logger.debug("bulma updating widget: #{__MODULE__}: socket: #{inspect([assigns: socket])}")
    unless assigns[:items] do
        raise(%ArgumentError{
          message: "dropdown requires :items keyword not found in #{inspect(assigns)}"
        })
    end

    items = for {v, i} <- Enum.with_index(assigns.items) do {"#{i}-idx", v} end
    {default_index, default_selected} = Enum.at(items, 0, {nil, nil})

    assigns =
      assigns
      |> Map.put_new(:assign_value, false)
      |> Map.put_new(:active, false)
      |> Map.put_new(:icon, 'fa fa-angle-down')
      |> Map.put_new(:index, socket.assigns[:index] || default_index)
      |> Map.put_new(:selected, socket.assigns[:selected] || default_selected)

    send(self(), {:widgets, :register, {assigns.id, __MODULE__}})
    {:ok, socket |> assign(assigns) |> assign(items: items)}
  end

  def render(assigns) do
    ~L"""
      <div class="dropdown widgets-dropdown widgets-dropdown-width <%= if @active do 'is-active' end %>"
           id="bulma-dropdown-<%= @id %>" >
        <div class="dropdown-trigger widgets-dropdown-width ">
          <button class="button widgets-dropdown-width "
                  aria-haspopup="true"
                  aria-controls="bulma-dropdown-menu-<%= @id %>"
                  phx-click="clicked"
                  phx-target="#bulma-dropdown-<%= @id %>" >
            <span><%= if @selected do @selected else 'Dropdown' end %></span>
            <span class="icon is-small">
              <i class="<%= @icon %>" aria-hidden="true"></i>
            </span>
          </button>
        </div>
        <div class="dropdown-menu widgets-dropdown-width " id="bulma-dropdown-menu-<%= @id %>" role="menu">
          <div class="dropdown-content widgets-dropdown-width ">
            <%= for {key, item} <- @items do %>
              <a href="#" class="dropdown-item <%= if key == @index do 'is-active' end %>"
                  phx-value-key="<%= key %>"
                  phx-click="selected"
                  phx-target="#bulma-dropdown-<%= @id %>" >
                <%= item %>
              </a>
            <% end %>
          </div>
        </div>
      </div>
    """
  end

  def handle_event("clicked", _params, socket) do
    send(self(), {:widgets, :active, socket.assigns.id, !socket.assigns.active})
    {:noreply, socket |> assign(active: !socket.assigns.active)}
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
