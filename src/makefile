CC=gcc
CFLAG= -Wall -I. -O0

TARGETS=montecarlo

all: $(TARGETS)

montecarlo: montecarlo.o
	$(CC) -o $@ $^ -lm

montecarlo.o: montecarlo.c montecarlo.h
	$(CC) $(CFLAG) -c $< -lm

clean:
	rm -f *.o *~ core $(TARGETS)
