// gcc out.c -D_REENTRANT -I/usr/include/SDL2 -lSDL2
#include "SDL.h"
#include <stdio.h>
#include <unistd.h>
#include <stdbool.h>
#include <sys/inotify.h>
#include <fcntl.h>
#include <errno.h>
# define BUF_LEN 1024

void load(char *file,SDL_Window *gWindow){
    SDL_Surface* gXOut;
    SDL_Surface* optimizedSurface;
    SDL_Surface* gScreenSurface;
    gScreenSurface = SDL_GetWindowSurface( gWindow );
	gXOut = SDL_LoadBMP(file);

    optimizedSurface = SDL_ConvertSurface( gXOut, gScreenSurface->format, 0 );
    SDL_FreeSurface( gXOut );

    int x,y;
    SDL_GetWindowSize(gWindow,&x,&y);
    SDL_Rect stretchRect;
	stretchRect.x = 0;
	stretchRect.y = 0;
	stretchRect.w = x;
	stretchRect.h = y;

	SDL_BlitScaled( optimizedSurface, NULL, gScreenSurface, &stretchRect );
	SDL_UpdateWindowSurface( gWindow );
}

int main(int argc, char* argv[]) {
    SDL_Surface* gXOut;
    SDL_Surface* gScreenSurface;
    SDL_Surface* optimizedSurface;
    int fd, wd, length;
    char buffer[BUF_LEN];
    fd = inotify_init1(IN_NONBLOCK);
    if ( fd < 0 ) {
        perror( "Couldn't initialize inotify");
    }
    int flags = fcntl(fd, F_GETFL, 0);
    fcntl(fd, F_SETFL, flags | O_NONBLOCK);
    wd = inotify_add_watch(fd, argv[1], IN_CREATE | IN_MODIFY | IN_DELETE);

    SDL_Window *gWindow;                    // Declare a pointer
    SDL_Init(SDL_INIT_VIDEO);              // Initialize SDL2

    // Create an application window with the following settings:
    gWindow = SDL_CreateWindow(
        "An SDL2 window",                  // window title
        SDL_WINDOWPOS_UNDEFINED,           // initial x position
        SDL_WINDOWPOS_UNDEFINED,           // initial y position
        350,                               // width, in pixels
        350,                               // height, in pixels
        SDL_WINDOW_OPENGL                  // flags - see below
 		| SDL_WINDOW_RESIZABLE
    );

    // Check that the window was successfully created
    if (gWindow == NULL) {
        // In the case that the window could not be made...
        printf("Could not create window: %s\n", SDL_GetError());
        return 1;
    }
    gScreenSurface = SDL_GetWindowSurface( gWindow );

	bool quit = false;

	SDL_Event e;

    load(argv[1],gWindow);

	while( !quit )
	{
		if( SDL_PollEvent( &e ) != 0 ) {
			if( e.type == SDL_QUIT ) quit = true;

			if(e.type == SDL_WINDOWEVENT && e.window.event == SDL_WINDOWEVENT_RESIZED)
				load(argv[1],gWindow);

			continue;
		}
        SDL_Delay(10);

		length = read( fd, buffer, BUF_LEN );
		if (length == -1 && errno != EAGAIN) {
			perror("read");
			exit(EXIT_FAILURE);
		 }
		if (length <= 0) continue;

		load(argv[1],gWindow);
	}

    // Clean up
    inotify_rm_watch( fd, wd );
    close( fd );
    SDL_Quit();
    return 0;
}
