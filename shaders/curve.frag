#version 460 core

#include <flutter/runtime_effect.glsl>
precision mediump float;

layout(location = 0) uniform vec2 screenSize;
layout(location = 1) uniform float time;
uniform lowp sampler2D inputImageTexture;

out vec4 fragColor;

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 uv = fragCoord / screenSize;
    uv.x += sin(uv.y * 10.0 + time) / 10.0;
    vec4 color = texture(inputImageTexture, uv);
    fragColor = color;
}
