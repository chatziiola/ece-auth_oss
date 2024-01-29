/*
  Author: chatziiola (Lamprinos Chatziioannou)
  Date: 2023-12-08
  Description: Simple Script utilizing pipes and subprocesses in C. Split into two files.
*/

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

#include "fork_child.h"

/* Algorithm Description:
   1. The "parent" process:
      - Create 4 subprocesses
      - Read the contents of pipe
      - Print in stdout
   2. The "child" process: (further analyzed in fork_child.c)
      - Prompt for character submission
      - Save character
      - Add "tuple" to pipe
   3. The tuple part: (further analyzed in tuple.c)
      - In short this is a bad implementation of a dictionary,
      using arrays as the underlying data structure.
      However, it allows for a highly readable and scalable
      (since time complexity is not an issue) implementation
      of the task at hand.
*/
int main() {
    int pipe_fd[2];
    if (pipe(pipe_fd) == -1) {
        perror("pipe");
        exit(EXIT_FAILURE);
    }

    pid_t pid[4];

    spawn_processes(pipe_fd, pid);

    close(pipe_fd[1]); // Close write end of the pipe in the parent

    for (int i = 0; i < 4; ++i) {
        waitpid(pid[i], NULL, 0); // Wait for all child processes to complete
    }

    // Read characters from the pipe and print the summary
    char character;
    int index;
    char characters[4];
    printf("Parent Process received the following:\n");
    for (int subp = 0; subp < 4; subp++)
      {
        read(pipe_fd[0], &character, sizeof(char));
	index = character - '0';
        read(pipe_fd[0], &character, sizeof(char));
	characters[index] = character;
      }

    for (int ind = 0; ind < 4; ind++)
        printf("Child process %d (with global PID %d) and my character was %c.\n",
	       ind, pid[ind], characters[ind]);

    close(pipe_fd[0]); // Close read end of the pipe in the parent

    return 0;
}
