#include <python.h>

//python boiler plate. define methods with extern "C" so the compiler doesnt prank us.
extern "C" static PyObject *access_map(int (*fp)(int), int[] arg. int size));
__global__ void map(int[] arg, int (*fp)(int)){
    int i = blockIdx.x*blockDim.x + threadIdx.x;
    arg[i] = fp(arg[i]);

}

//access means that the python part should be accessing this part of the code and no other functions
PyObject *access_map(int (*fp)(int), int[] arr, int size)){
    int threads = (size >= 256) ? 256 : size; 
    int blocks = size/256 + 1;
    int * d_arr;
    //allocating and copying. this takes about 600 clock cycles, but theres no alternative.
    cudaMalloc(&d_arr, size*sizeof(int)); 
    cudaMemcpy(d_arr, arr, size*sizeof(int),cudaMemcpyHostToDevice);
    map<<<blocks,threads>>>(d_x,d_arr);
    cudaMemcpy(arr,d_arr, size*sizeof(int), cudaMemcpyDeviceToHost); 
    cudaFree(d_arr);
}