shader_type canvas_item;

void fragment() {
  vec2 uv = UV;
  // Flip vertically every other repeat
  float repeat_count = floor(uv.y); // Count vertical repeats
  if (mod(repeat_count, 2.0) == 1.0) { // Flip odd-numbered repeats
    uv.y = 1.0 - fract(uv.y); // Flip vertically
  } else {
    uv.y = fract(uv.y); // Keep even repeats normal
  }
  COLOR = texture(TEXTURE, uv);
}