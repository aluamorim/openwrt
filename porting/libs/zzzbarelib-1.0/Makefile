# build helloworld executable when user executes "make" 
zzzbarelib-1.0: zzzbarelib-1.0.o 
	$(CC) $(LDFLAGS) zzzbarelib-1.0.o -o zzzbarelib-1.0 

zzzbarelib-1.0.o: zzzbarelib-1.0.c 
	$(CC) $(CFLAGS) -c zzzbarelib-1.0.c 

install:
	echo "Trying to install zzzbarelib-1.0"

# remove object files and executable when user executes "make clean" 
clean: 
	rm *.o zzzbarelib-1.0