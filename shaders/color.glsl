#ifndef COLOR_GLSL_INCLUDED
#define COLOR_GLSL_INCLUDED


// sRGB-encoded value (what the bytes of a colour texture mean) -> linear light.
// The exact piecewise curve, not pow(c, 2.2).
vec3 srgb_to_linear(vec3 c) {
  return mix(
    c/12.92,
    pow((c+0.055)/1.055,vec3(2.4)),
    step(vec3(0.0405),c)
  );
}


// Linear light -> sRGB-encoded value (what the UNORM target and the screen expect).
// The exact inverse of srgb_to_linear.
vec3 linear_to_srgb(vec3 c) {
  return mix(
    12.92*c,
    1.055*pow(c,vec3(1.0/2.4))-0.055,
    step(vec3(0.0031308),c)
  );
}


// A debug view for albedo textures: luminance of the LINEAR colour, too dark
// (< 0.04) shows blue, too bright (> 0.9) shows red, anything else shows that
// luminance as a grey, encoded for display.
vec3 albedo_check(vec3 lin) {
  float l=dot(lin,vec3(0.2126,0.7152,0.0722));
  return mix(
    vec3(0.0,0.0,1.0),
    mix(
      linear_to_srgb(vec3(l)),
      vec3(1.0,0.0,0.0),
      step(0.9,l)
    ),
    step(0.04,l)
  );
}

#endif
