CC=gcc
CCMPI=mpicc
CFLAG= -Wall -I. -O0
CFLAG_OPT= -Wall -I. -O3

TARGETS=montecarlo montecarlo_opt1 montecarlo_opt2 montecarlo_opt3

all: $(TARGETS)

montecarlo: montecarlo.o
	$(CC) -o $@ $^ -lm

montecarlo.o: montecarlo.c montecarlo.h
	$(CC) $(CFLAG) -c $< -lm

montecarlo_opt1: montecarlo_opt1.o
	$(CCMPI) -o $@ $^ -lm

montecarlo_opt1.o: montecarlo_opt1.c montecarlo.h
	$(CCMPI) $(CFLAG_OPT) -c $< -lm

montecarlo_opt2: montecarlo_opt2.o
	$(CCMPI) -o $@ $^ -lm

montecarlo_opt2.o: montecarlo_opt2.c montecarlo.h
	$(CCMPI) $(CFLAG_OPT) -c $< -lm
	
montecarlo_opt3: montecarlo_opt3.o
	$(CCMPI) -o $@ $^ -lm

montecarlo_opt3.o: montecarlo_opt3.c montecarlo.h
	$(CCMPI) $(CFLAG_OPT) -c $< -lm
clean:
	rm -f *.o *~ core $(TARGETS)
