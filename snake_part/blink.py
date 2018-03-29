import ctypes

def own_map(org_datastruct,py_funct):
    org_length = len(org_datastruct)
    #making a C array from this python list, and morphing the python function to a C function pointer.
    arr = (ctypes.c_int * org_length)(*org_datastruct)
    cmp_func = CMPFUNC(py_funct)
    #arr = cuda.map(arr,py_funct)
    return [arr[i] for i in xrange(org_length)]
