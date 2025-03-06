#version 460 core
precision highp float;
#include <flutter/runtime_effect.glsl>

#define KERNEL_SIZE 56

uniform vec2 iResolution;
uniform sampler2D iChannel0;
out vec4 fragColor;

float mapRadius(vec2 position, vec2 size, float offset, float interpolation, float radius, float direction) {
    float mapped;
    if (direction == 0.0) {
        mapped = max((position.y / size.y - offset) / interpolation, 0.0);
    } else if (direction == 1.0) {
        mapped = max(0.5 - (position.y / size.y - offset) / interpolation, 0.0);
    } else if (direction == 2.0) {
        mapped = max((position.x / size.x - offset) / interpolation, 0.0);
    } else if (direction == 3.0) {
        mapped = max(0.5 - (position.x / size.x - offset) / interpolation, 0.0);
    }
    return min(mapped * radius, radius);
}

vec4 blur(vec2 position, vec2 resolution, float radius, float offset, float interpolation, float direction, bool isVertical) {
    float r = mapRadius(position, resolution, offset, interpolation, radius, direction);
    if (r == 0.0) {
        return texture(iChannel0, position / resolution);
    }
    vec4 result = vec4(0.0);
    float totalWeight = 0.0;
    for (int i = 0; i < KERNEL_SIZE; ++i) {
        float offsetPixels = float(i - (KERNEL_SIZE / 2)) * r;
        vec2 samplePos = position;
        if (isVertical) {
            samplePos.y += offsetPixels;
        } else {
            samplePos.x += offsetPixels;
        }
        samplePos = clamp(samplePos, vec2(0.0), resolution - 1.0);
        float x = float(i - (KERNEL_SIZE / 2)) / (float(KERNEL_SIZE) / 2.0);
        float weight = exp(-0.005 * x * x);
        result += texture(iChannel0, samplePos / resolution) * weight;
        totalWeight += weight;
    }
    return result / totalWeight;
}

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 uv = fragCoord / iResolution.xy;
    // Parameters (you can expose these as uniforms if needed)
    float radius = 5.0; // Adjusted for smaller kernel size
    float offset = 0.0;
    float interpolation = 0.4;
    float direction = 1.0;

    // Apply horizontal blur
    vec4 blurredX = blur(fragCoord, iResolution.xy, radius, offset, interpolation, direction, false);
    // Apply vertical blur to the result of horizontal blur
    vec4 blurredY = blur(fragCoord, iResolution.xy, radius, offset, interpolation, direction, true);
    fragColor = (blurredX + blurredY) * 0.5;
}