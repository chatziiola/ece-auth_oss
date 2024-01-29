/*
  Author: chatziiola (Lamprinos Chatziioannou)
  Date: 2023-12-08
  Description: Simple file
*/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <string.h>

void spawn_processes(int* pipe_fd, int* pid)
{
    for (int i = 0; i < 4; ++i) {
        pid[i] = fork();

        if (pid[i] == -1) {
            perror("fork");
            exit(EXIT_FAILURE);
        }

        if (pid[i] == 0) { // Child process
            close(pipe_fd[0]); // Close unused read end of the pipe
	    pid[i] = getpid();

	    // character holds 2 values at the same time to avoid
	    // using more complex data structure, at index 0
	    // (character[0]), the index is found, while at
	    // (character[1]) the received character
            char character[2];
	    sprintf(character, "%d", i);
	    // Removed to beautify
            /* printf("Enter a character for process %d: \n", i + 1); */
            scanf("%c", &character[1]);

	    // Write the character to the pipe
	    /* printf("\t[In SUB]: Child process %d with PID: %d and char %c\n", i, pid[i], character[1]); */
            write(pipe_fd[1], character, 2); 
            close(pipe_fd[1]); // Close the write end of the pipe
            exit(EXIT_SUCCESS);
        }
    }
}
