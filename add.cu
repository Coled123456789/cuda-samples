#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include <cuda_runtime.h>

#define BLOCKS 4
#define THREADS 4


__global__ void add(int *x, int *y, int *result) {
    *result = *x + *y;
};

int main(int argc, char *argv[]) {
    if(argc < 2)
    {
        printf("need two parameters retard\n");
        return 0;
    }
    int x = atoi(argv[1]);
    int y = atoi(argv[2]);

    int *x_d, *y_d, *sum_d;

    cudaMalloc((void**) &x_d, sizeof(int));
    cudaMemcpy(x_d, &x, sizeof(int), cudaMemcpyHostToDevice);
    cudaMalloc((void**) &y_d, sizeof(int));
    cudaMemcpy(y_d, &y, sizeof(int), cudaMemcpyHostToDevice);
    cudaMalloc((void**) &sum_d, sizeof(int));

    add<<<BLOCKS,THREADS>>>(x_d, y_d, sum_d);

    int sum;
    cudaMemcpy(&sum, sum_d, sizeof(int), cudaMemcpyDeviceToHost);
    printf("%d\n", sum);
    
    cudaFree(x_d);
    cudaFree(y_d);
    cudaFree(sum_d);
};
