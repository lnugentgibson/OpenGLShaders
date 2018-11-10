// Include standard headers
#include <stdio.h>
#include <stdlib.h>
#include <vector>
#include <unistd.h>

// Include GLEW
#include <GL/glew.h>

// Include GLFW
#include <GLFW/glfw3.h>
GLFWwindow* window;

// Include GLM
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
using namespace glm;

#include <common/shader.hpp>
#include <common/texture.hpp>
#include <common/controls.hpp>
#include <common/objloader.hpp>
#include <common/vboindexer.hpp>

#include <string.h>
#include <stdlib.h>
#include <stdio.h>

int main( int argc, char *argv[] )
{
  int targetSize = 1024;
  int maxIterations = -1;
  int grain = 16;
  int fps = 1;
  float threshold = 0.1;
  float weight = 0.5;
  fprintf(stdout, "%d arguments\n", argc);
  for(int argi = 1; argi < argc - 1; argi += 2) {
    if(!strcmp(argv[argi], "-s") || !strcmp(argv[argi], "--size"))
      targetSize = atoi(argv[argi + 1]);
    else if(!strcmp(argv[argi], "-x") || !strcmp(argv[argi], "--max-iterations"))
      maxIterations = atoi(argv[argi + 1]);
    else if(!strcmp(argv[argi], "-g") || !strcmp(argv[argi], "--grain"))
      grain = atoi(argv[argi + 1]);
    else if(!strcmp(argv[argi], "-f") || !strcmp(argv[argi], "--fps"))
      fps = atoi(argv[argi + 1]);
    else if(!strcmp(argv[argi], "-t") || !strcmp(argv[argi], "--threshold"))
      threshold = atoi(argv[argi + 1]) * 0.001;
    else if(!strcmp(argv[argi], "-w") || !strcmp(argv[argi], "--weight"))
      weight = atoi(argv[argi + 1]) * 0.001;
  }
  fprintf(stdout, "targetSize: %d\nmaxIterations: %d\ngrain: %d\nfps: %d\nthreshold: %f\nweight: %f\n", targetSize, maxIterations, grain, fps, threshold, weight);
  
	// Initialise GLFW
	if( !glfwInit() )
	{
		fprintf( stderr, "Failed to initialize GLFW\n" );
		getchar();
		return -1;
	}

	glfwWindowHint(GLFW_SAMPLES, 1);
	glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
	glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
	glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE); // To make MacOS happy; should not be needed
	glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
	
    int *size = (int *) malloc(2 * sizeof(int));
    size[0] = size[1] = targetSize;

	// Open a window and create its OpenGL context
	window = glfwCreateWindow( size[0], size[1], "Cellular Automata", NULL, NULL);
	if( window == NULL ){
		fprintf( stderr, "Failed to open GLFW window. If you have an Intel GPU, they are not 3.3 compatible. Try the 2.1 version of the tutorials.\n" );
		getchar();
		glfwTerminate();
		return -1;
	}
	glfwMakeContextCurrent(window);
    
    // We would expect width and height to be 1024 and 768
    // But on MacOS X with a retina screen it'll be 1024*2 and 1024*2, so we get the actual framebuffer size:
    glfwGetFramebufferSize(window, size, size + 1);

	// Initialize GLEW
	glewExperimental = true; // Needed for core profile
	if (glewInit() != GLEW_OK) {
		fprintf(stderr, "Failed to initialize GLEW\n");
		getchar();
		glfwTerminate();
		return -1;
	}

	// Ensure we can capture the escape key being pressed below
	glfwSetInputMode(window, GLFW_STICKY_KEYS, GL_TRUE);
    // Hide the mouse and enable unlimited mouvement
    glfwSetInputMode(window, GLFW_CURSOR, GLFW_CURSOR_DISABLED);
    
    // Set the mouse at the center of the screen
    glfwPollEvents();
    glfwSetCursorPos(window, size[0]/2, size[1]/2);

	// Dark blue background
	glClearColor(0.0f, 0.0f, 0.4f, 0.0f);

	// Cull triangles which normal is not towards the camera
	glEnable(GL_CULL_FACE);

	GLuint VertexArrayID;
	glGenVertexArrays(1, &VertexArrayID);
	glBindVertexArray(VertexArrayID);

	// Create and compile our GLSL program from the shaders
	GLuint programID = LoadShaders( "vertex-passthrough.glsl", "fragment-cellularautomata.glsl" );
	GLuint viewProgramID = LoadShaders( "vertex-passthrough.glsl", "fragment-passthrough.glsl" );

	GLuint Res = glGetUniformLocation(programID, "res");
	GLuint vRes = glGetUniformLocation(viewProgramID, "res");
	GLuint QSeed1 = glGetUniformLocation(programID, "QS1");
	GLuint LSeed1 = glGetUniformLocation(programID, "LS1");
	GLuint RSeed1 = glGetUniformLocation(programID, "RS1");
	GLuint QSeed2 = glGetUniformLocation(programID, "QS2");
	GLuint LSeed2 = glGetUniformLocation(programID, "LS2");
	GLuint RSeed2 = glGetUniformLocation(programID, "RS2");
	GLuint QSeed3 = glGetUniformLocation(programID, "QS3");
	GLuint LSeed3 = glGetUniformLocation(programID, "LS3");
	GLuint RSeed3 = glGetUniformLocation(programID, "RS3");
	GLuint Grain = glGetUniformLocation(programID, "Grain");
	GLuint Threshold = glGetUniformLocation(programID, "Threshold");
	GLuint Iteration = glGetUniformLocation(programID, "iteration");
	GLuint vIteration = glGetUniformLocation(viewProgramID, "iteration");
	GLuint Weight = glGetUniformLocation(viewProgramID, "weight");
	
	GLuint TextureID = glGetUniformLocation(programID, "previous");
	GLuint vTextureIDp = glGetUniformLocation(viewProgramID, "previous");
	GLuint vTextureIDc = glGetUniformLocation(viewProgramID, "current");

	// The fullscreen quad's FBO
	static const GLfloat g_quad_vertex_buffer_data[] = { 
		-1.0f, -1.0f, 0.0f,
		 1.0f, -1.0f, 0.0f,
		-1.0f,  1.0f, 0.0f,
		-1.0f,  1.0f, 0.0f,
		 1.0f, -1.0f, 0.0f,
		 1.0f,  1.0f, 0.0f,
	};

	GLuint quad_vertexbuffer;
	glGenBuffers(1, &quad_vertexbuffer);
	glBindBuffer(GL_ARRAY_BUFFER, quad_vertexbuffer);
	glBufferData(GL_ARRAY_BUFFER, sizeof(g_quad_vertex_buffer_data), g_quad_vertex_buffer_data, GL_STATIC_DRAW);

	// Get a handle for our "LightPosition" uniform
	glUseProgram(programID);
	int i;
	srand(2);
	float *qseed = (float *) malloc(4 * sizeof(float));
	float *lseed = (float *) malloc(2 * sizeof(float));
	float *rseed = (float *) malloc(4 * sizeof(float));
	
	for(i = 0; i < 4; i++)
	  qseed[i] = (float)rand()/(float)(RAND_MAX/0.5) + 0.85;
	fprintf(stdout, "qseed = [%f, %f; %f, %f]", qseed[0], qseed[1], qseed[2], qseed[3]);
	for(i = 0; i < 2; i++)
	  lseed[i] = (float)rand()/(float)(RAND_MAX/0.55) + 0.95;
	fprintf(stdout, "lseed = [%f, %f]", lseed[0], lseed[1]);
	rseed[0] = (float)rand()/(float)(RAND_MAX/400) + 1200;
	rseed[1] = (float)rand()/(float)(RAND_MAX/20) + 20;
	rseed[2] = (float)rand()/(float)(RAND_MAX/80) + 120;
	rseed[3] = (float)rand()/(float)(RAND_MAX/100) + 300;
	fprintf(stdout, "rseed = [%f, %f, %f, %f]", rseed[0], rseed[1], rseed[2], rseed[3]);
	glUniformMatrix2fv(QSeed1, 1, GL_FALSE, qseed);
	glUniform2fv(LSeed1, 1, lseed);
	glUniform4fv(RSeed1, 1, rseed);
	
	for(i = 0; i < 4; i++)
	  qseed[i] = (float)rand()/(float)(RAND_MAX/0.5) + 0.85;
	fprintf(stdout, "qseed = [%f, %f; %f, %f]", qseed[0], qseed[1], qseed[2], qseed[3]);
	for(i = 0; i < 2; i++)
	  lseed[i] = (float)rand()/(float)(RAND_MAX/0.55) + 0.95;
	fprintf(stdout, "lseed = [%f, %f]", lseed[0], lseed[1]);
	rseed[0] = (float)rand()/(float)(RAND_MAX/400) + 1200;
	rseed[1] = (float)rand()/(float)(RAND_MAX/20) + 20;
	rseed[2] = (float)rand()/(float)(RAND_MAX/80) + 120;
	rseed[3] = (float)rand()/(float)(RAND_MAX/100) + 300;
	fprintf(stdout, "rseed = [%f, %f, %f, %f]", rseed[0], rseed[1], rseed[2], rseed[3]);
	glUniformMatrix2fv(QSeed2, 1, GL_FALSE, qseed);
	glUniform2fv(LSeed2, 1, lseed);
	glUniform4fv(RSeed2, 1, rseed);
	
	for(i = 0; i < 4; i++)
	  qseed[i] = (float)rand()/(float)(RAND_MAX/0.5) + 0.85;
	fprintf(stdout, "qseed = [%f, %f; %f, %f]", qseed[0], qseed[1], qseed[2], qseed[3]);
	for(i = 0; i < 2; i++)
	  lseed[i] = (float)rand()/(float)(RAND_MAX/0.55) + 0.95;
	fprintf(stdout, "lseed = [%f, %f]", lseed[0], lseed[1]);
	rseed[0] = (float)rand()/(float)(RAND_MAX/400) + 1200;
	rseed[1] = (float)rand()/(float)(RAND_MAX/20) + 20;
	rseed[2] = (float)rand()/(float)(RAND_MAX/80) + 120;
	rseed[3] = (float)rand()/(float)(RAND_MAX/100) + 300;
	fprintf(stdout, "rseed = [%f, %f, %f, %f]", rseed[0], rseed[1], rseed[2], rseed[3]);
	glUniformMatrix2fv(QSeed3, 1, GL_FALSE, qseed);
	glUniform2fv(LSeed3, 1, lseed);
	glUniform4fv(RSeed3, 1, rseed);
	
	glUniform1f(Grain, grain);
	glUniform1f(Threshold, threshold);


	// ---------------------------------------------
	// Render to Texture - specific code begins here
	// ---------------------------------------------

	// The framebuffer, which regroups 0, 1, or more textures, and 0 or 1 depth buffer.
	GLuint *FBuffers = (GLuint *) malloc(2 * sizeof(GLuint));
	glGenFramebuffers(2, FBuffers);
	glBindFramebuffer(GL_FRAMEBUFFER, FBuffers[0]);

	// The texture we're going to render to
	GLuint *renderedTextures = (GLuint *) malloc(2 * sizeof(GLuint));
	glGenTextures(2, renderedTextures);
	
	int texI = 0;
	for(texI = 0; texI < 2; texI++) {
	// "Bind" the newly created texture : all future texture functions will modify this texture
	glBindTexture(GL_TEXTURE_2D, renderedTextures[texI]);

	// Give an empty image to OpenGL ( the last "0" means "empty" )
	glTexImage2D(GL_TEXTURE_2D, 0,GL_RGB, size[0], size[1], 0,GL_RGB, GL_UNSIGNED_BYTE, 0);

	// Poor filtering
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST); 
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

	// Set "renderedTexture" as our colour attachement #0
	glFramebufferTexture(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, renderedTextures[texI], 0);
	}
	
	texI = 0;
	int iteration = 0;
	do{
	  glUseProgram(programID);
	  glUniform2iv(Res, 1, size);
		glBindFramebuffer(GL_FRAMEBUFFER, FBuffers[(texI + 1) % 2]);
		glFramebufferTexture(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, renderedTextures[(texI + 1) % 2], 0);
		glViewport(0,0,size[0],size[1]);
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
		glUniform1i(Iteration, iteration);
		glActiveTexture(GL_TEXTURE0);
		glBindTexture(GL_TEXTURE_2D, renderedTextures[texI]);
		glUniform1i(TextureID, 0);

		glEnableVertexAttribArray(0);
		glBindBuffer(GL_ARRAY_BUFFER, quad_vertexbuffer);
		glVertexAttribPointer(
			0,                  // attribute 0. No particular reason for 0, but must match the layout in the shader.
			3,                  // size
			GL_FLOAT,           // type
			GL_FALSE,           // normalized?
			0,                  // stride
			(void*)0            // array buffer offset
		);

		// Draw the triangles !
		glDrawArrays(GL_TRIANGLES, 0, 6); // 2*3 indices starting at 0 -> 2 triangles
		glDisableVertexAttribArray(0);
		
    texI = (texI + 1) % 2;

	  glUseProgram(viewProgramID);
	  glUniform2iv(vRes, 1, size);
	  glUniform1f(Weight, weight);
		glBindFramebuffer(GL_FRAMEBUFFER, 0);
		glViewport(0,0,size[0],size[1]);
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
		glUniform1i(vIteration, iteration);
		glActiveTexture(GL_TEXTURE0);
		glBindTexture(GL_TEXTURE_2D, renderedTextures[texI]);
		glUniform1i(vTextureIDc, 0);
		glActiveTexture(GL_TEXTURE1);
		glBindTexture(GL_TEXTURE_2D, renderedTextures[(texI + 1) % 2]);
		glUniform1i(vTextureIDp, 1);

		glEnableVertexAttribArray(0);
		glBindBuffer(GL_ARRAY_BUFFER, quad_vertexbuffer);
		glVertexAttribPointer(
			0,                  // attribute 0. No particular reason for 0, but must match the layout in the shader.
			3,                  // size
			GL_FLOAT,           // type
			GL_FALSE,           // normalized?
			0,                  // stride
			(void*)0            // array buffer offset
		);

		// Draw the triangles !
		glDrawArrays(GL_TRIANGLES, 0, 6); // 2*3 indices starting at 0 -> 2 triangles
		glDisableVertexAttribArray(0);

		// Swap buffers
		glfwSwapBuffers(window);
		glfwPollEvents();

    iteration++;
    usleep(1000000 / fps);
	} // Check if the ESC key was pressed or the window was closed
	while( (maxIterations < 1 || iteration < maxIterations) && glfwGetKey(window, GLFW_KEY_ESCAPE ) != GLFW_PRESS &&
		   glfwWindowShouldClose(window) == 0 );

	// Cleanup VBO and shader
	glDeleteProgram(programID);

	glDeleteFramebuffers(2, FBuffers);
	glDeleteTextures(2, renderedTextures);
	glDeleteBuffers(1, &quad_vertexbuffer);
	glDeleteVertexArrays(1, &VertexArrayID);


	// Close OpenGL window and terminate GLFW
	glfwTerminate();

	return 0;
}

