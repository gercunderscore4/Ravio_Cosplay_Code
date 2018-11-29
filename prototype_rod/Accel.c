/****************************************************************
 * Accelerometer interface for ATtiny85
 ****************************************************************/

#include "Accel.h"

/*
 * Estimate sqrt based on leading digit position.
 * Need to deal with values up to 3*0xFF*FF = 195075 = 0x02FA03.
 * Assume true value is in middle of range, e.g.:
 * leading 0x100 -> 0x180 (50/50 chance of being above/below this value)
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

void processAccelData (int16_t x, int16_t y, int16_t z)
{
    uint8_t r = 0; // red
    uint8_t g = 0; // green
    uint8_t b = 0; // blue
    
    uint16_t f = 0; // frequency
    
    uint16_t m = 0; // max of new x,y,z
    uint32_t t = 0; // intermediate for math
    uint8_t  d = 0; // digits
    
    for (int i = 0; i < 10; i++)
    {
        // get "data"
        x = rand() % 0xFFFF; // RAND_MAX is guaranteed to be at least 32767
        y = rand() % 0xFFFF;
        z = rand() % 0xFFFF;
        
        // shrink to one byte, abs
        x = abs(x / 0x100);
        y = abs(y / 0x100);
        z = abs(z / 0x100);
        // ensure smaller than 256 (negative max)
        x = (x >= 0x100) ? 0xFF : x;
        y = (y >= 0x100) ? 0xFF : y;
        z = (z >= 0x100) ? 0xFF : z;
        
        // normalize so that largest is 255
        // get max
        m = (x > y) ? ((x > z) ? x : z) : ((y > z) ? y : z);
        // x * 0xFF / m
        // x * (0x100 - 1) / m
        // ((x << 8) - x) / m
        r = (uint8_t) (((x << 8) - x) / m);
        g = (uint8_t) (((y << 8) - y) / m);
        b = (uint8_t) (((z << 8) - z) / m);
        
        t = ((uint32_t) (x*x) + (y*y) + (z*z));
        d = 0;
        while (t > 0)
        {
            t >>= 1;
            d++;
        }
        t = ((uint32_t) (x*x) + (y*y) + (z*z));
        f = SQRT_BY_DIGIT[d];
    }
}
