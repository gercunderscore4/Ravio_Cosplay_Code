// compile with:
// gcc -Wall -Wextra -std=c11 .\rod_math_test.c -o rod_math_test.exe

#include "stdio.h"
#include "stdlib.h"
#include "stdint.h"
#include "time.h"

#define LED_COUNT   1
#define BRIGHTNESS 31

/*
 * estimate sqrt based on leading digit position
 * need to deal with values up to 3*0xFF*FF = 195075 = 0x2FA03
 * 
 * python code to generate best guess:
 * from math import log2, ceil, sqrt
 * d = [(0,0,0)]
 * d.extend([(i + 1, 1 << i, int(round(sqrt(1.5 * (1 << i))))) for i in range(ceil(log2(3 * 0xFF * 0xFF)) + 1)])
 * for a,b,c in d:
 *     print('{:2d} {:12d} {:6d}'.format(a,b,c))
 */
const uint16_t SQRT_BY_DIGIT[] = {  0,  //  0, sqrt(     0 * 1.5) // value in the middle of the range
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
                                  222,  // 16, sqrt( 32768 * 1.5)
                                  314,  // 17, sqrt( 65536 * 1.5)
                                  443,  // 18, sqrt(131072 * 1.5)
                                  627}; // 19, sqrt(262144 * 1.5)

int16_t maxOfThree(int16_t a, int16_t b, int16_t c)
{
    if (a > b)
    {
        if (a > c)
        {
            return a;
        }
        else 
        {
            return c;
        }
    }
    else
    {
        if (b > c)
        {
            return b;
        }
    }
    return c;
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
    
    int16_t tx = 0; // temp
    int16_t ty = 0; 
    int16_t tz = 0; 
    
    uint16_t m = 0; // max of new x,y,z
    uint32_t t = 0;
    uint8_t d = 0;
    
    srand(time(NULL));

    for (int i = 0; i < 10; i++)
    {
        // get "data"
        x = rand() % 0xFFFF; // RAND_MAX is guaranteed to be at least 32767
        y = rand() % 0xFFFF;
        z = rand() % 0xFFFF;
        
        // shrink to one byte, abs, ensure smaller than 256 (negative max)
        tx = abs(x / 0x100);
        ty = abs(y / 0x100);
        tz = abs(z / 0x100);
        tx = (tx >= 0x100) ? 0xFF : tx;
        ty = (ty >= 0x100) ? 0xFF : ty;
        tz = (tz >= 0x100) ? 0xFF : tz;
        
        // normalize so that largest is 255
        m = (int16_t) maxOfThree(tx, ty, tz);
        r = (uint8_t) (((uint16_t) tx) * 0xFF / m);
        g = (uint8_t) (((uint16_t) ty) * 0xFF / m);
        b = (uint8_t) (((uint16_t) tz) * 0xFF / m);
        
        t = ((uint32_t) (tx*tx) + (ty*ty) + (tz*tz));
        d = 0;
        while (t > 0)
        {
            t >>= 1;
            d++;
        }
        t = ((uint32_t) (tx*tx) + (ty*ty) + (tz*tz));
        f = SQRT_BY_DIGIT[(int)d];

        printf("RGB: %02X %02X %02X    f: %5d    (X,Y,Z) -> (%5X %5X %5X)    d = %2d    t = %6d\n", r, g, b, f, x, y, z, d, t);
    }
    
    return 0;
}