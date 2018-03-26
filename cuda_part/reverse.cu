#include <stdio.h>
#include <python.h>

//python boiler plate. define methods with extern "C" so the compiler doesnt prank us.
extern "C" static PyObject *access_swap(PyObject *self, PyObject *args);
extern "C" void init_CU_AddVector() ;

/*link method with needed info. <function-name in python module>, <actual-function>,
  <type-of-args the function expects>, <docstring associated with the function>
  */
static PyMethodDef addList_funcs[] = {
    {"cuda_reverse_array", (PyCFunction)access_swap, METH_VARARGS, reverseList_docs},
    {NULL, NULL, 0, NULL}
};
//doc string, to add documentation to our method
static char reverseList_docs[] =
        "reverse the list\n";

PyMODINIT_FUNC initaddList(void){
    Py_InitModule3("cuda_adder", addList_funcs,
                   "Add all ze lists");
}

__global__
void swap(int *a,int size){
    int i = blockIdx.x*blockDim.x + threadIdx.x;
    int temp = a[i];
    a[i] = a[size-i];
    a[size-i] = temp;
}

PyObject * access_swap(PyObject *self, PyObject *args){
    PyListObject *to_swap;
    if (!PyArg_ParseTuple(args, "O!", &PyListObject, &to_swap)){  
        return NULL;
    }   
    
    int size = PyList_Size(&to_swap);
    int blocks = size/256 + 1;
    int threads= (size >= 256) ? 256 : size; 

    cudaMemcpy(d_x, x, size*sizeof(int),cudaMemcpyHostToDevice);
    swap<<<blocks,threads>>>(d_x,size-1);
    cudaMemcpy(x,d_x, size*sizeof(int), cudaMemcpyDeviceToHost); 
    cudaFree(d_x);
    free(x);
}

