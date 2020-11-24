#include "decoder.h"

void decoder17_c(const int select, svBitVecVal* out) 
{ 
    out[0] = 1 << select;
}
