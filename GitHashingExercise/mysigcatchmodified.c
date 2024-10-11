/*
  Author: chatziiola (Lamprinos Chatziioannou)
  Date: 2023-12-23
  Description: Run indefinitely, catch SIGINTs, and if two are caught, restore default behaviour
  - (meaning that the application no longer uses our "specialized" handler for SIGINT handling )
*/
#include <stdio.h>
#include <signal.h>
#include <unistd.h>

// Almost necessary to be initialized here, could not make it work
// properly with private vars
int sigint_count = 0;

void customHandler(int sigint) {
    printf("SIGINT signal (number %d) caught!\n", ++sigint_count);

    if (sigint_count == 2) {
    // Restore default behavior
    // SIGINT no longer causes this function to execute
	printf("Two SIGINT signals have been received, application was restored to default SIGINT handling.\n");
        signal(SIGINT, SIG_DFL);
    }
}

int main() {
    signal(SIGINT, customHandler);

    while (1) {
		// Identical to ~mysigcatch.c~
		// not necessary to add anything here, the sole
		// purpose of this loop is to keep the program running
    }

    return 0;
}
