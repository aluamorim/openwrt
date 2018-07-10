# build helloworld executable when user executes "make" 
libbaresip-1.0: libbaresip-1.0.o 
	$(CC) $(LDFLAGS) libbaresip-1.0.o -o libbaresip-1.0 

libbaresip-1.0.o: libbaresip-1.0.c 
	$(CC) $(CFLAGS) -c libbaresip-1.0.c 

install:
	echo "Trying to install libbaresip-1.0"

# remove object files and executable when user executes "make clean" 
clean: 
	rm *.o libbaresip-1.0