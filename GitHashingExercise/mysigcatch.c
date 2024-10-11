/*
  Author: chatziiola (Lamprinos Chatziioannou)
  Date: 2023-12-23
  Description: Run without doing nothing, but exit gracefully upon receiving SIGINT (C-c)
*/
#include <stdio.h>
#include <signal.h>
#include <unistd.h>

void customHandler(int sigint) {
    printf("SIGINT signal caught!\n");
    _exit(0);  // Terminate the program
}

int main() {
    signal(SIGINT, customHandler);

    while (1) {
		// not necessary to add anything here, the sole
		// purpose of this loop is to keep the program running
    }

    return 0;
}

