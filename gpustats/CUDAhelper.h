//
//  CUDAhelper.h
//  gpustats
//
//  Created by Ulrik Guenther on 16/04/15.
//  Copyright (c) 2015 ulrik.is. All rights reserved.
//

#ifndef __gpustats__CUDAhelper__
#define __gpustats__CUDAhelper__

#include <stdio.h>

void gs_setDevice(unsigned int dev);
unsigned long long gs_getFreeGlobalMem();
unsigned long long gs_getTotalGlobalMem();

#endif /* defined(__gpustats__CUDAhelper__) */
