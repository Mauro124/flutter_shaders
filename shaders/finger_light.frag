#version 460 core

#include <flutter/runtime_effect.glsl>
precision mediump float;

layout(location = 0) uniform vec2 screenSize;       // Dimensiones de la pantalla
layout(location = 1) uniform vec2 mousePosition;   // Posición del dedo o cursor
layout(location = 2) uniform float time;            // Tiempo transcurrido
uniform lowp sampler2D inputImageTexture;          // Textura de entrada

out vec4 fragColor;

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;                // Coordenadas del fragmento
    vec2 uv = fragCoord / screenSize;                      // Coordenadas normalizadas
    vec2 lightCenter = mousePosition / screenSize;         // Centro del círculo de luz normalizado

    // Calcular la distancia del píxel al centro del círculo de luz
    float distanceToLight = length(uv - lightCenter);

    // Determinar cuánto del fondo se muestra según la distancia
    float lightIntensity = smoothstep(0.0, 0.5, distanceToLight);

    // Obtener el color de la textura de entrada
    vec4 baseColor = texture(inputImageTexture, uv);

    // Mezclar el color original con el fondo, dependiendo de la intensidad de la luz
    vec4 revealedColor = vec4(baseColor.rgb * (1.0 - lightIntensity), baseColor.a);

    // Asignar el color de salida
    fragColor = revealedColor;
}
