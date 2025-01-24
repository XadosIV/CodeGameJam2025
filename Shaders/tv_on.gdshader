shader_type canvas_item;

uniform float time : hint_range(0.0, 5.0); // Contrôle l'animation.
uniform vec4 screen_color : source_color = vec4(0.8, 0.9, 1.0, 1.0); // Couleur de l'écran.

void fragment() {
    vec2 uv = FRAGCOORD.xy / SCREEN_PIXEL_SIZE.xy; // Coordonnées normalisées
    vec2 center = vec2(0.5, 0.5); // Centre de l'écran.
    float aspect_ratio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;

    // Calcul de la largeur de la ligne lumineuse qui s'ouvre avec le temps.
    float line_width = 0.03 + time * 0.2; 
    float line_position = abs(uv.y - center.y) / line_width;

    // Simule une courbure d'écran CRT (effet de distorsion).
    float curve = pow((uv.x - center.x) * aspect_ratio, 2.0) * 0.5;

    // Bruit pour simuler l'effet CRT (imprécision du signal).
    float noise = fract(sin(dot(uv.xy * vec2(10.0, 20.0), vec2(12.9898, 78.233))) * 43758.5453);

    // Mélange les effets pour simuler la ligne d'ouverture.
    float intensity = smoothstep(0.0, 1.0, 1.0 - line_position + curve) * (0.5 + 0.5 * noise);

    // Transition de noir à transparent.
    float alpha = 1.0 - time;  // Le temps contrôle la transparence.

    // Applique la couleur avec l'effet d'intensité et de transparence.
    COLOR.rgb = mix(vec3(0.0), screen_color.rgb, intensity);
    COLOR.a = intensity * alpha; // L'alpha passe de 1.0 (opaque) à 0.0 (transparent)
}
