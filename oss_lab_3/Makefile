CC = gcc
CFLAGS = -Wall
TARGETDIR = ~/quiz-3/bins

all: fork_main 

fork_main: fork_main.c
	$(CC) $(CFLAGS) fork_main.c -o fork_main

clean:
	rm -f fork_main 

install:
	mkdir -p $(TARGETDIR)
	cp fork_main $(TARGETDIR)
