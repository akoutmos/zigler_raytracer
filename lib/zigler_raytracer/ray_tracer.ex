defmodule ZiglerRaytracer.RayTracer do
  use Zig, local_zig: true

  ~Z"""
  const INF = 100000000;

  const Color = struct {
    r: f64,
    g: f64,
    b: f64,

    pub fn new(r: f64, g: f64, b: f64) Color {
      return Color{
        .r = r,
        .g = g,
        .b = b,
      };
    }
  };

  const Sphere = struct {
    color: Color,

    x: f64,
    y: f64,
    z: f64,

    radius: f64,

    pub fn new(radius: f64, r: f64, g: f64, b: f64, x: f64, y: f64, z: f64) Sphere {
      return Sphere{
        .color = Color.new(r, g, b),
        .radius = radius,
        .x = x,
        .y = y,
        .z = z,
      };
    }

    pub fn intersection(sphere: Sphere, ray_x: f64, ray_y: f64) [2]f64 {
      const dx: f64 = ray_x - sphere.x;
      const dy: f64 = ray_y - sphere.y;
      const radius_squared = sphere.radius * sphere.radius;

      if (dx * dx + dy * dy < radius_squared) {
        const dz: f64 = @sqrt(radius_squared - dx*dx - dy*dy);
        const n: f64 = dz / @sqrt(radius_squared);

        return [_]f64{dz + sphere.z, n};
      }

      return [_]f64{-INF, 0.0};
    }
  };

  const spheres = [_]Sphere{
    Sphere.new(15.0, 1.0, 0.0, 0.0, 100.0, 60.0, 10.0),
    Sphere.new(75.0, 0.6, 0.3, 0.2, 375.0, 100.0, 2.0),
    Sphere.new(45.0, 0.0, 1.0, 0.0, 165.0, 310.0, 10.0),
    Sphere.new(25.0, 0.1, 0.4, 0.2, 165.0, 450.0, 4.0),
    Sphere.new(25.0, 0.0, 0.0, 1.0, 180.0, 215.0, 10.0),
    Sphere.new(50.0, 0.3, 0.1, 0.3, 450.0, 450.0, 1.0)
  };

  /// nif: ray_trace/2
  fn ray_trace(env: beam.env, ray_x: f64, ray_y: f64) beam.term {
    var maxz: f64 = -INF;
    var pixel_color: Color = Color.new(0.0, 0.0, 0.0);

    for (spheres) |sphere| {
      const result: [2]f64 = sphere.intersection(ray_x, ray_y);
      const intersection_point: f64 = result[0];
      const color_adjustment: f64 = result[1];

      if (intersection_point > maxz) {
        pixel_color.r = sphere.color.r * color_adjustment;
        pixel_color.g = sphere.color.g * color_adjustment;
        pixel_color.b = sphere.color.b * color_adjustment;

        maxz = intersection_point;
      }
    }

    var tuple_slice: []beam.term = beam.allocator.alloc(beam.term, 3) catch |err| return 0;
    defer beam.allocator.free(tuple_slice);

    tuple_slice[0] = beam.make_i32(env, @floatToInt(i32, pixel_color.r * 255.0));
    tuple_slice[1] = beam.make_i32(env, @floatToInt(i32, pixel_color.g * 255.0));
    tuple_slice[2] = beam.make_i32(env, @floatToInt(i32, pixel_color.b * 255.0));

    return beam.make_tuple(env, tuple_slice);
  }
  """
end
