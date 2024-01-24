#include <stdio.h>

int main(int argc, char** argv){ 

unsigned long long int target_sleep = atoi(argv[1]);

while(1) {
    usleep(target_sleep);
}

}