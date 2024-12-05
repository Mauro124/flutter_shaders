#version 460 core

#include <flutter/runtime_effect.glsl>
precision mediump float;

layout(location = 0) uniform vec2 screenSize;
layout(location = 1) uniform float time;
uniform lowp sampler2D inputImageTexture;

out vec4 fragColor;

// Constantes del shader original
const int lookupSize = 64;
const float errorCarry = 0.8;

// Función para calcular la escala de grises
float getGrayscale(vec2 coords) {
    vec2 uv = coords / screenSize;
    vec3 sourcePixel = texture(inputImageTexture, uv).rgb;
    return dot(sourcePixel, vec3(0.2126, 0.7152, 0.0722)); // Fórmula para escala de grises
}

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;

    int topGapY = int(screenSize.y - fragCoord.y);
    int cornerGapX = int((fragCoord.x < 10.0) ? fragCoord.x : screenSize.x - fragCoord.x);
    int cornerGapY = int((fragCoord.y < 10.0) ? fragCoord.y : screenSize.y - fragCoord.y);
    int cornerThreshold = ((cornerGapX == 0) || (topGapY == 0)) ? 5 : 4;

    if (cornerGapX + cornerGapY < cornerThreshold) {
        fragColor = vec4(0.0, 0.0, 0.0, 1.0);
    } else if (topGapY < 20) {
        if (topGapY == 19) {
            fragColor = vec4(0.0, 0.0, 0.0, 1.0);
        } else {
            fragColor = vec4(1.0, 1.0, 1.0, 1.0);
        }
    } else {
        float xError = 0.0;
        for (int xLook = 0; xLook < lookupSize; xLook++) {
            float grayscale = getGrayscale(fragCoord + vec2(-float(lookupSize) + float(xLook), 0.0));
            grayscale += xError;
            float bit = grayscale >= 0.5 ? 1.0 : 0.0;
            xError = (grayscale - bit) * errorCarry;
        }

        float yError = 0.0;
        for (int yLook = 0; yLook < lookupSize; yLook++) {
            float grayscale = getGrayscale(fragCoord + vec2(0.0, -float(lookupSize) + float(yLook)));
            grayscale += yError;
            float bit = grayscale >= 0.5 ? 1.0 : 0.0;
            yError = (grayscale - bit) * errorCarry;
        }

        float finalGrayscale = getGrayscale(fragCoord);
        finalGrayscale += xError * 0.5 + yError * 0.5;
        float finalBit = finalGrayscale >= 0.5 ? 1.0 : 0.0;

        fragColor = vec4(finalBit, finalBit, finalBit, 1.0);
    }
}
