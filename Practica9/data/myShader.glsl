#ifdef GL_ES
precision mediump float;
#endif
uniform vec2 u_resolution;
uniform vec2 u_position;
uniform float u_time;
uniform float u_speed;
uniform sampler2D texture ;
float circWidth = 0.01;

#define iChannel0 texture

/*vec2 rotation(vec2 fCoord, float angle) {
	float s = sin(angle);
	float c = cos(angle);
	mat2 m = mat2(c, -s, s, c);
	return m * v;
}*/

float uzumaki(vec2 fCoord,float t){
    float r = length(fCoord);
    float a = atan(fCoord.y,fCoord.x);
    float v = sin(100. *(sqrt(r) - 0.02*a- u_speed*t));
    return clamp(v,0.,1.);
}
void mainImage( out vec4 fragColor, in vec2 fragCoord );

void main() {
    vec2 normPix = gl_FragCoord.xy/u_resolution.xy;
    mainImage(gl_FragColor,normPix);
    
}

bool inCircle(vec2 fCoord,vec2 center,float mov){
    float radius = mod(mov*0.5,0.7);
    //Calculamos la distancia desde el centro
    vec2 uv = fCoord - center;
    float distance = sqrt(dot(uv,uv));

    return ((distance < (radius + circWidth))&& (distance > (radius - circWidth)));

    
}

void mainImage( out vec4 fColor, in vec2 fCoord ){
    vec2 rotationStart = vec2(0.1,0.1);
    vec2 headPos = u_position.xy/u_resolution.xy;
    headPos[1] = 1.0 - headPos[1];
    float spiral = uzumaki(fCoord - headPos,u_time);
    // Función de ruido
    vec3 col = vec3(spiral);
    if ((col[0] != 0.0 && col[1] != 0.0 && col[2] != 0.0 )|| (inCircle(fCoord,headPos,u_time))){
        col[0] -= cos(u_time*0.3);
        col[1] -= sin(u_time*0.2);
        col[2] += cos(u_time*0.3);
    }
    
    float red = texture(iChannel0,fCoord).r + col[0];
    float green = texture(iChannel0,fCoord).g + col[1];
    float blue = texture(iChannel0,fCoord).b + col[2];

    
    fColor =  vec4(red,green,blue,0.1);
}

