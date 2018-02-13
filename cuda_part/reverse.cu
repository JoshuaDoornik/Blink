#include <stdio.h>
#include <cuda.h>

__global__
void swap(int *a,int size){
    int i = blockIdx.x*blockDim.x + threadIdx.x;
    int temp = a[i];
    a[i] = a[size-i];
    a[size-i] = temp;
}

int main(void){
    int size = 100;
    int blocks = size/256 + 1;
    int threads= (size >= 256) ? 256 : size; 
    int *x, *d_x;
    x = (int *)malloc(size*sizeof(int));
    cudaMalloc(&d_x, size*sizeof(int));
    
    for(int i = 0; i < size; i++){
        x[i] = i;
   }
    printf("%d \n",blocks);    
    cudaMemcpy(d_x, x, size*sizeof(int),cudaMemcpyHostToDevice);
    swap<<<blocks,threads>>>(d_x,size-1);
    cudaMemcpy(x,d_x, size*sizeof(int), cudaMemcpyDeviceToHost); 
    for(int i = 0; i < size; i++){
        printf(" element %d = %d\n", i, x[i]);
    }
    cudaFree(d_x);
    free(x);
}

