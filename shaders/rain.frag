#version 460 core

#include <flutter/runtime_effect.glsl>
precision mediump float;

// Uniformes para el shader
layout(location = 0) uniform vec2 screenSize;       // Dimensiones de la pantalla
layout(location = 1) uniform float time;           // Tiempo animado
uniform lowp sampler2D inputImageTexture;          // Textura de entrada

out vec4 fragColor;

// Función suavizada
#define S(a, b, t) smoothstep(a, b, t)

// Funciones auxiliares para la generación de ruido
vec3 N13(float p) {
    vec3 p3 = fract(vec3(p) * vec3(.1031, .11369, .13787));
    p3 += dot(p3, p3.yzx + 19.19);
    return fract(vec3((p3.x + p3.y) * p3.z, (p3.x + p3.z) * p3.y, (p3.y + p3.z) * p3.x));
}

float Saw(float b, float t) {
    return S(0.0, b, t) * S(1.0, b, t);
}

// Función para calcular gotas estáticas
float StaticDrops(vec2 uv, float t) {
    uv *= 20.0;
    vec2 id = floor(uv);
    uv = fract(uv) - 0.5;
    vec3 n = N13(id.x * 107.45 + id.y * 3543.654);
    vec2 p = (n.xy - 0.5) * 0.9;
    float d = length(uv - p);
    float fade = Saw(0.025, fract(t + n.z));
    return S(0.3, 0.0, d) * fract(n.z * 10.0) * fade;
}

// Función principal para gotas
vec2 Drops(vec2 uv, float t, float l0, float l1, float l2) {
    float s = StaticDrops(uv, t) * l0;
    float c = s; // Solo estáticas por simplicidad para compatibilidad
    c = S(0.3, 0.5, c);
    return vec2(c, 0.0);
}

// Función principal del shader
void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 uv = (fragCoord - 0.5 * screenSize) / screenSize.y;
    vec2 UV = fragCoord / screenSize;

    float T = time;  // Tiempo para animaciones
    float t = T * 0.2;

    // Ajustar cantidad de lluvia (valor fijo por ahora)
    float rainAmount = 0.8;

    // Calcular gotas
    float staticDrops = S(0.0, 0.4, rainAmount) * 4.0;
    float layer1 = S(0.25, 0.75, rainAmount);
    float layer2 = S(0.0, 0.5, rainAmount);
    vec2 c = Drops(uv, t, staticDrops, layer1, layer2);

    // Aplicar efecto de gotas a la textura base
    vec3 col = texture(inputImageTexture, UV).rgb * c.x;

    // Fade-in inicial
    float fade = S(0.4, 2.0, T);
    col *= fade;

    // Asignar color de salida
    fragColor = vec4(col, 1.0);
}
