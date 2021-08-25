defmodule ZiglerRaytracer do
  @moduledoc """
  ZiglerRaytracer keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias ZiglerRaytracer.RayTracer

  def ray_trace(x_start, y_start) do
    x_start..(x_start + 499)
    |> Enum.map(fn ray_x ->
      y_start..(y_start + 499)
      |> Enum.map(fn ray_y ->
        RayTracer.ray_trace(ray_x / 1, ray_y / 1)
      end)
    end)
    |> List.flatten()
  end
end
