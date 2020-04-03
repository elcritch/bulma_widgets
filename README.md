# BulmaWidgets

Simple LiveComponent wrappers around Bulma "widgets" for Phoenix LiveView. This library is intended to wrap the basic Bulma elements into largely self-contained components making developing interactive UI's in LiveView much simpler. There are a few additional components for use on touch screen and embedded devices for basic's like number inputs. In the future I'd like to have a simialr library for Bootstrap as well. 

## Example Phoenix Project

See [example project](https://github.com/elcritch/bulma_widgets_phx_test) for more examples of usage. Especially [Gallery Live](https://github.com/elcritch/bulma_widgets_phx_test/blob/master/lib/bulma_widgets_phx_test_web/live/gallery_live.ex).

## Usage

Example usage in a Phoenix LiveView component: 

```elixir
defmodule WidgetExampleLive do
  use BulmaWidgets
  alias BulmaWidgets.DropdownComponent
  alias BulmaWidgets.TabsComponent
  use Phoenix.LiveView
  require Logger

  def mount(_params, _session, socket) do
    socket = socket |> assign(test_var: "some example value")
    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <div phx-click="bulma-widgets-close-all" >
      <h1>LiveView is awesome!</h1>
      <section class="section">
        <h1 class="title"> Bulma Widget </h1>

        <%= live_component @socket, DropdownComponent,
              id: :dm_test1,
              items: ["Menu 1", "Menu 2"] %>

        <div class="box">
          <%= live_component @socket, TabsComponent,
                  id: :bw_tabs2,
                  items: ["Info 1", "Info 2"],
                  icons: %{"Info 1" => "fa fa-car"},
                  classes: 'is-centered is-toggle is-toggle-rounded' do %>
            <%= case @item do %>
              <%= "Info 1" -> %>
                <h1 class="title">First Tab</h1>

              <%= "Info 2" -> %>

                <h1 class="title">Second Tab</h1>
                <h2 class="subtitle"><%= @test_var %></h2>

                <%= live_component(@socket, DropdownComponent,
                      id: :dm_test2,
                      items: ["Menu 1", "Menu 2"]) %>

              <%= other -> %>

                <h1><%= other %></h1>

            <% end %>
          <% end %>
      </section>

      <style>
        .widgets-dropdown-width {
          width: 12em;
        }
      </style>
    </div>
    """
  end

  def handle_widget(socket, {:update, BulmaWidgets.DropdownComponent}, id, updates) do
    Logger.warn("updating widget: DropdownComponent: #{inspect({id, updates})}")
    socket
  end

end
```


## Related

Checkout [Surface](https://github.com/msaraiva/surface) for a more full featured "component library". 

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `bulma_widgets` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:bulma_widgets, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/bulma_widgets](https://hexdocs.pm/bulma_widgets).

