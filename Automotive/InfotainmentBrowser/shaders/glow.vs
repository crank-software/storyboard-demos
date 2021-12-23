attribute vec4 myVertex;
attribute vec4 myUV;

varying vec2 myTexCoord;

uniform mat4 projMatrix;
uniform mat4 mvMatrix;

void main(void)
{
    gl_Position = projMatrix * mvMatrix * myVertex;
    myTexCoord = myUV.st;
}

