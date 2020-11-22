#include "decoder.h"

void decoder17(const int select, svBitVecVal* out) 
{ 
    out[0] = 1 << select;
}
