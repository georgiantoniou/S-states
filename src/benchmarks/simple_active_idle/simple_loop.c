#include <stdio.h>
#include <time.h>
#include <unistd.h>
#include <stdlib.h>

int main(int argc, char** argv){
	
	int i,j;
	unsigned long cur;
	
	//loop counter
	i=0;
	
	//start of experiment duration
	int target_duration = atoi(argv[1]);
	int active_iterations = atoi(argv[2]);	
	unsigned long start = (unsigned long)time(NULL);
	
	do {
	
	//active part
	//active_iterations default 50000
	j=0;
	for(j=0;j<active_iterations;j++);
	
	//active part iteration counter
	i++;
	
	//sleep for 1 ms idle part
	usleep(1000);
	cur = (unsigned long)time(NULL);
	
	} while (cur < start + target_duration);
	
	printf("counter: %d\n",i);
	return 0;
	
}
