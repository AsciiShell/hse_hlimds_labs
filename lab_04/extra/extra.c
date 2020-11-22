#include "extra.h"

void extra_c_it(svBitVecVal* vec) 
{ 
    if (*vec % 2 == 0){
        *vec = 1;
    }
}

void extra_c(svOpenArrayHandle arr) 
{ 
    int dim = 1;
    svBitVecVal s;
    int i = svLeft(arr, dim); 
    int incr_i;
    int incr_j;
    if (i == svLow(arr, dim)) {
        incr_i = 1;
    } else {
        incr_i = 0;
    }
    while (1) { 
        svGetBitArrElem1VecVal(&s, arr, i);
        extra_c_it(&s);
        svPutBitArrElem1VecVal(arr, &s, i);
        if (i == svRight(arr, dim)) {
            break;
        }
        i = incr_i ? i + 1 : i - 1;
    }
}