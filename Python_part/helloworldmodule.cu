#include <Python.h>
#include <stdio.h>

extern "C" __global__ void helloFromGPU();
extern "C" __global__ void mapFromGPU();
static PyObject *SpamError;

static PyObject * hello_gpu(PyObject *self, PyObject *args)
{
    helloFromGPU <<<1,10>>>();
    cudaDeviceReset();
    return Py_RETURN_NONE;
}



static PyObject * map(PyObject *self, PyObject *args)
{
    PyObject * listObj;
    PyObject *temp;
    //The input arguments come as a tuple, we parse the args to get the various variables
    //In this case it's only one list variable, which will now be referenced by listObj
    if (! PyArg_ParseTuple( args, "OO:blink_map", &listObj, &temp)){
        return NULL;
    }
    if (!PyCallable_Check(temp)) {
        PyErr_SetString(PyExc_TypeError, "parameter must be callable");
        return NULL;
    }
    helloFromGPU <<<1,10>>>();
    cudaDeviceReset();
    return Py_RETURN_NONE;
}

static PyMethodDef SpamMethods[] = {
    {"hello_gpu",  hello_gpu, METH_VARARGS,
     "say hello world 10 times parallel from your GPU. because why not?."},
     {"map",  map, METH_VARARGS,
     "map a function to a datastructure (for now a list) using your GPU for more parallel execution."},
    {NULL, NULL, 0, NULL}        /* Sentinel */
};

__global__ void helloFromGPU(){
    printf("Hello world, from my GPU! \n");
}

__global__ void mapFromGPU(PyObject* Pylist, PyObject* callable){
    printf("Hello world, from my GPU! \n");
}

PyMODINIT_FUNC inithelloworld(void)
{
    PyObject *m;

    m = Py_InitModule("helloworld", SpamMethods);
    if (m == NULL)
        return;


    // figure out what you're using for future grid sizes
    int deviceCount = 0;
    cudaGetDeviceCount(&deviceCount);
    cudaDeviceProp deviceProp;
    for(int i = 0; i < deviceCount;i++){
        cudaGetDeviceProperties(&deviceProp, i);
        printf("[+] located Device %d: %s\n", i, deviceProp.name);
        printf("[+] set warpsize to %d\n",deviceProp.warpSize);
    }
    printf("\n");
    SpamError = PyErr_NewException("gpu.error", NULL, NULL);
    Py_INCREF(SpamError);
}