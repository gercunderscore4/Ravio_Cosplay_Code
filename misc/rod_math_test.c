// compile with:
// gcc -Wall -Wextra -std=c11 .\rod_math_test.c -o rod_math_test.exe

#include "stdio.h"
#include "stdlib.h"
#include "stdint.h"
#include "time.h"

/*
 * estimate sqrt based on leading digit position
 * need to deal with values up to 3*0x80*80 = 49152 = 0xC000
 * 
 * python code to generate best guess:
 * from math import log2, ceil, sqrt
 * d = [(0,0,0)]
 * d.extend([(i + 1, 1 << i, int(round(sqrt(1.5 * (1 << i))))) for i in range(ceil(log2(3 * 0x80 * 0x80)))])
 * for a,b,c in d:
 *     print('{:2d} {:12d} {:6d}'.format(a,b,c))
 */
const uint16_t SQRT_BY_DIGIT[] = {  0,  //  0, sqrt(     0 * 1.5)
                                    1,  //  1, sqrt(     1 * 1.5)
                                    2,  //  2, sqrt(     2 * 1.5)
                                    2,  //  3, sqrt(     4 * 1.5)
                                    3,  //  4, sqrt(     8 * 1.5)
                                    5,  //  5, sqrt(    16 * 1.5)
                                    7,  //  6, sqrt(    32 * 1.5)
                                   10,  //  7, sqrt(    64 * 1.5)
                                   14,  //  8, sqrt(   128 * 1.5)
                                   20,  //  9, sqrt(   256 * 1.5)
                                   28,  // 10, sqrt(   512 * 1.5)
                                   39,  // 11, sqrt(  1024 * 1.5)
                                   55,  // 12, sqrt(  2048 * 1.5)
                                   78,  // 13, sqrt(  4096 * 1.5)
                                  111,  // 14, sqrt(  8192 * 1.5)
                                  157,  // 15, sqrt( 16384 * 1.5)
                                  222}; // 16, sqrt( 32768 * 1.5)

void processAccelData (int16_t x, int16_t y, int16_t z, uint8_t* r, uint8_t* g, uint8_t* b, uint16_t* f)
{
    // max possibile are 0x7FFF and -0x8000
    // shrink to one byte, take absolute
    x = abs(x / 0x100);
    y = abs(y / 0x100);
    z = abs(z / 0x100);
    
    // max is 3 * 0x80 * 0x80 = 0xC000
    uint32_t t = ((uint16_t) (x * x) + (y * y) + (z * z));
    // get leading digit
    uint8_t d = 0;
    while (t > 0)
    {
        t >>= 1;
        d++;
    }
    // get estimated sqrt by digit
    *f = SQRT_BY_DIGIT[(int)d];

    // normalize so that largest is 255
    // get max
    uint8_t m = (x > y) ? ((x > z) ? x : z) : ((y > z) ? y : z);
    // x * 0xFF / m
    // x * (0x100 - 1) / m
    // ((x << 8) - x) / m
    if (m == 0) {
        *r = 0x00;
        *g = 0x00;
        *b = 0x00;
    } else {
        *r = (uint8_t) (((((uint16_t)x) << 8) - x) / m);
        *g = (uint8_t) (((((uint16_t)y) << 8) - y) / m);
        *b = (uint8_t) (((((uint16_t)z) << 8) - z) / m);
    }
}

int main (void)
{
    uint8_t r = 0; // red
    uint8_t g = 0; // green
    uint8_t b = 0; // blue
    
    uint16_t f = 0; // frequency
    
    int16_t x = 0; // x-axis acceleration
    int16_t y = 0; // y-axis acceleration
    int16_t z = 0; // z-axis acceleration
   
    printf("Hello, brave, new World!\n");
    
    // largest negative
    x = -32768;
    y = -32768;
    z = -32768;
    processAccelData (x, y, z, &r, &g, &b, &f);
    printf("(X,Y,Z) -> (%5hX %5hX %5hX)    RGB: %02X %02X %02X    f: %5d\n", x, y, z, r, g, b, f);

    // largest positive
    x = 0x7FFF;
    y = 0x7FFF;
    z = 0x7FFF;
    processAccelData (x, y, z, &r, &g, &b, &f);
    printf("(X,Y,Z) -> (%5hX %5hX %5hX)    RGB: %02X %02X %02X    f: %5d\n", x, y, z, r, g, b, f);

    // all zero
    x = 0x0;
    y = 0x0;
    z = 0x0;
    processAccelData (x, y, z, &r, &g, &b, &f);
    printf("(X,Y,Z) -> (%5hX %5hX %5hX)    RGB: %02X %02X %02X    f: %5d\n", x, y, z, r, g, b, f);

    // 1,0,0 after reduction
    x = 0x100;
    y = 0x0;
    z = 0x0;
    processAccelData (x, y, z, &r, &g, &b, &f);
    printf("(X,Y,Z) -> (%5hX %5hX %5hX)    RGB: %02X %02X %02X    f: %5d\n", x, y, z, r, g, b, f);

    // eh, should be easy
    x = 0xFF0;
    y = 0x800;
    z = 0x0;
    processAccelData (x, y, z, &r, &g, &b, &f);
    printf("(X,Y,Z) -> (%5hX %5hX %5hX)    RGB: %02X %02X %02X    f: %5d\n", x, y, z, r, g, b, f);

    // negative numbers
    x =  0xFF0;
    y = -0xFF0;
    z = -0xFF0;
    processAccelData (x, y, z, &r, &g, &b, &f);
    printf("(X,Y,Z) -> (%5hX %5hX %5hX)    RGB: %02X %02X %02X    f: %5d\n", x, y, z, r, g, b, f);

    srand(time(NULL));
    for (int i = 0; i < 10; i++)
    {
        // get "data"
        x = rand() % 0xFFFF;
        y = rand() % 0xFFFF;
        z = rand() % 0xFFFF;
        processAccelData (x, y, z, &r, &r, &r, &f);
        printf("(X,Y,Z) -> (%5hX %5hX %5hX)    RGB: %02X %02X %02X    f: %5d\n", x, y, z, r, g, b, f);
    }
    
    printf("Good-bye, cruel World!\n");
    return 0;
}
