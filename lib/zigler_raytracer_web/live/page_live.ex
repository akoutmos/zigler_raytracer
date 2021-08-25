defmodule ZiglerRaytracerWeb.PageLive do
  use ZiglerRaytracerWeb, :live_view

  @shift_factor 10

  @impl true
  def mount(_params, _session, socket) do
    image = generate_image(1, 1)

    {:ok, assign(socket, image: image, x: 1, y: 1)}
  end

  @impl true
  def handle_event("up", _, socket) do
    new_y = socket.assigns.y + @shift_factor
    image = generate_image(socket.assigns.x, new_y)

    {:noreply, assign(socket, y: new_y, image: image)}
  end

  def handle_event("down", _, socket) do
    new_y = socket.assigns.y - @shift_factor
    image = generate_image(socket.assigns.x, new_y)

    {:noreply, assign(socket, y: new_y, image: image)}
  end

  def handle_event("left", _, socket) do
    new_x = socket.assigns.x - @shift_factor
    image = generate_image(new_x, socket.assigns.y)

    {:noreply, assign(socket, x: new_x, image: image)}
  end

  def handle_event("right", _, socket) do
    new_x = socket.assigns.x + @shift_factor
    image = generate_image(new_x, socket.assigns.y)

    {:noreply, assign(socket, x: new_x, image: image)}
  end

  defp generate_image(x, y) do
    Pngex.new()
    |> Pngex.set_type(:rgb)
    |> Pngex.set_depth(:depth8)
    |> Pngex.set_size(500, 500)
    |> Pngex.generate(ZiglerRaytracer.ray_trace(x, y))
    |> :erlang.list_to_binary()
    |> Base.encode64()
  end
end
