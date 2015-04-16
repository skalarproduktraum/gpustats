//
//  CUDAhelper.c
//  gpustats
//
//  Created by Ulrik Guenther on 16/04/15.
//  Copyright (c) 2015 ulrik.is. All rights reserved.
//

#include "CUDAhelper.h"
#include <cuda.h>
#include <cuda_runtime.h>

void gs_setDevice(unsigned int dev) {
    cudaSetDevice(0);
}

unsigned long long gs_getTotalGlobalMem() {
    size_t free = 0;
    size_t total = 0;
    
    cudaMemGetInfo(&free, &total);
    
    return total;
}

unsigned long long gs_getFreeGlobalMem() {
    size_t free = 0;
    size_t total = 0;
    
    cudaMemGetInfo(&free, &total);
    
    return free;
}