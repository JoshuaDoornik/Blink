#include <Python.h>
#include <stdio.h>

extern "C" __global__ void helloFromGPU();

static PyObject *SpamError;

static PyObject * hello_gpu(PyObject *self, PyObject *args)
{
    helloFromGPU <<<1,10>>>();
    cudaDeviceReset();
    return Py_None;
}

__global__ void helloFromGPU(){
    printf("Hello world, from my GPU! \n");
}

static PyMethodDef SpamMethods[] = {
    {"hello_gpu",  hello_gpu, METH_VARARGS,
     "say hello world 10 times parallel from your GPU. because why not?."},
    {NULL, NULL, 0, NULL}        /* Sentinel */
};


PyMODINIT_FUNC inithelloworld(void)
{
    PyObject *m;

    m = Py_InitModule("helloworld", SpamMethods);
    if (m == NULL)
        return;

    SpamError = PyErr_NewException("gpu.error", NULL, NULL);
    Py_INCREF(SpamError);
}