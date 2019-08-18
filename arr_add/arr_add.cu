#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include <cuda_runtime.h>

#define BLOCKS 4
#define THREADS 4

#define LEN 10
#define MAX 10000

__global__ void rand_init(int* x) {
    int block_id = blockIdx.x;
    x[block_id] = rand() % MAX;
} 

__global__ void add_vector(int *x, int *y, int *result) {
    int block_id = blockIdx.x;
    if(block_id < LEN)
        result[block_id] = x[block_id] + y[block_id];
};

void print_arr(int arr[], int len) {
    printf("[");
    for(int i = 0; i < len-1; i++)
        printf("%d, ", arr[i]);
    printf("%d]\n", arr[len-1]);
};

int main(int argc, char *argv[]) {
    int i, x[LEN], y[LEN], sum[LEN];
    int *x_d, *y_d, *sum_d;

    cudaMalloc((void**) &x_d, LEN * sizeof(int));
    cudaMalloc((void**) &y_d, LEN * sizeof(int));
    cudaMalloc((void**) &sum_d, LEN * sizeof(int));
    
    for(i = 0; i < LEN; i++)
    {
        x[i] = rand() % 1000;
        y[i] = rand() % 1000;
    }

    print_arr(x, LEN);
    print_arr(y, LEN);

    cudaMemcpy(y_d, &y, LEN * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(x_d, &x, LEN * sizeof(int), cudaMemcpyHostToDevice);

    add_vector<<<LEN,1>>>(x_d, y_d, sum_d);


    cudaMemcpy(&sum, sum_d, LEN * sizeof(int), cudaMemcpyDeviceToHost);

    print_arr(sum, LEN);
    
    cudaFree(x_d);
    cudaFree(y_d);
    cudaFree(sum_d);
};
