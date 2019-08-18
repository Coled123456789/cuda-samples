#include <stdio.h>

__device__ int dev1(){
    return 1;
}

__device__ int dev2(){
    return 2;
}

/*
* __global__ prefix says a function is kernel,
*   Will be executed by GPU
*   runs multiple times specified by block and thread number
*   must return void
*/
__global__ void myKernel(){
    dev1();
    dev2();
}


/**
*  __host__ prefix specifies
*   - runs once per call on CPU
*   - only callable from CPU
* Function without prefix are host functions
*/

int main(){
    //specifies number of blocks and threads per blocks (2 blocks, 4 threads per block)
    myKernel<<<2,4>>>();
    printf("Hello, World!\n");
    return 0;
}

/*
*  __device prefix
*/
