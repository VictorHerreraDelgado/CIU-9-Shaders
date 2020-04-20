#ifdef GL_ES
precision mediump float;
#endif
uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

vec2 rotation(vec2 v, float a) {
	float s = sin(a);
	float c = cos(a);
	mat2 m = mat2(c, -s, s, c);
	return m * v;
}

float uzumaki(vec2 posit,float t){
    float r = length(posit);
    float a = atan(posit.y,posit.x);
    float v = sin(100. *(sqrt(r) - 0.02*a- 3*t));
    return clamp(v,0.,1.);
}
void main() {
    vec2 normPix = gl_FragCoord.xy/u_resolution.xy;
    //vec2 normMouse = u_mouse.xy/u_resolution.xy;
    //if ((length(normMouse)==0.)) normMouse = vec2(.9,.5);
    vec2 rotationStart = vec2(0.1,0.1);
    // Escalado
    //vec2 pos = vec2(st*5.0);
    float spiral = uzumaki(normPix - vec2(0.5,0.5) - rotation(rotationStart,u_time),u_time*0.1);
    
    normPix = gl_FragCoord.xy/u_resolution.xy;
    // Función de ruido
    vec3 col = vec3(spiral);
    col[0] -= cos(u_time*0.3);
    col[1] -= sin(u_time*0.2);
    col[2] += cos(u_time*0.3);


    gl_FragColor =  gl_FragColor;
}