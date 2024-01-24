#include <unistd.h> 

int main(int argc, char** argv){ 

    int target_duration = atoi(argv[1]);
    int numth = atoi(argv[2]);
    #pragma omp parallel num_threads(numth)
    { 
        #pragma omp barrier 
        while(1) { 
            for(int i=0;i<8;i++) { 
                //#pragma omp barrier 
                usleep(target_duration); 
            } 
            usleep(10); 
        } 
    } 
}