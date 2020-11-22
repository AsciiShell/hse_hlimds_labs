#include "fibonacci.h"

unsigned int fibonacci(unsigned int N)
{
    if (N < 3){
        return 1;
    }
    return fibonacci(N - 1) + fibonacci(N - 2);
}
