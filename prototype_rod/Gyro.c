/****************************************************************
 * Gyrometer interface for ATtiny85
 ****************************************************************/

#include "stdlib.h"
#include "Gyro.h"

#define I2C_SLAVE_WRITE(x) (x & 0xfe)
#define I2C_SLAVE_READ(x) (x | 0x01)

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
const uint8_t SQRT_BY_DIGIT[] = {  0,  //  0, sqrt(     0 * 1.5),
                                   1,  //  1, sqrt(     1 * 1.5),
                                   2,  //  2, sqrt(     2 * 1.5),
                                   2,  //  3, sqrt(     4 * 1.5),
                                   3,  //  4, sqrt(     8 * 1.5),
                                   5,  //  5, sqrt(    16 * 1.5),
                                   7,  //  6, sqrt(    32 * 1.5),
                                  10,  //  7, sqrt(    64 * 1.5),
                                  14,  //  8, sqrt(   128 * 1.5),
                                  20,  //  9, sqrt(   256 * 1.5),
                                  28,  // 10, sqrt(   512 * 1.5),
                                  39,  // 11, sqrt(  1024 * 1.5),
                                  55,  // 12, sqrt(  2048 * 1.5),
                                  78,  // 13, sqrt(  4096 * 1.5),
                                 111,  // 14, sqrt(  8192 * 1.5),
                                 157,  // 15, sqrt( 16384 * 1.5),
                                 222}; // 16, sqrt( 32768 * 1.5),

void gyroProcessData (int16_t x, int16_t y, int16_t z, uint8_t* r, uint8_t* g, uint8_t* b, uint8_t* d, uint16_t* f) {
    // max possibile are 0x7FFF and -0x8000
    // shrink to one byte, take absolute
    x = abs(x / 0x100);
    y = abs(y / 0x100);
    z = abs(z / 0x100);

    // max is 3 * 0x80 * 0x80 = 0xC000
    uint32_t t = ((uint16_t) (x * x) + (y * y) + (z * z));
    // get leading digit
    *d = 0;
    while (t > 0)
    {
        t >>= 1;
        (*d)++;
    }
    // get estimated sqrt by digit
    *f = (uint16_t) SQRT_BY_DIGIT[*d];

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
        // use a filter to blend colors
        uint8_t tr = (uint8_t) (((((uint16_t)x) << 8) - x) / m);
        uint8_t tg = (uint8_t) (((((uint16_t)y) << 8) - y) / m);
        uint8_t tb = (uint8_t) (((((uint16_t)z) << 8) - z) / m);
        *r = (*r - (*r>>4)) + (tr>>4);
        *g = (*g - (*g>>4)) + (tg>>4);
        *b = (*b - (*b>>4)) + (tb>>4);
    }
}

void gyroInit (void) {
    uint8_t data1[] = {0xD6, 0xA3, 0x00};
    // 0xD4 write to gyrometer (SDO = 0)
    // 0x23 write register 0x23
    // 0x30 write CTRL_REG4, continuous update, LSb, Scale: b00: 250dps
    uint8_t data2[] = {0xD6, 0xA0, 0x6F};
    // 0xD4 write to gyrometer (SDO = 0)
    // 0x24 write register 0x20
    // 0x30 write CTRL_REG1, Normal Mode PD=1, Xen=Yen=Zen=1

    USI_TWI_Master_Initialise();
    USI_TWI_Start_Transceiver_With_Data_Stop(data1, sizeof(data1), false);
    USI_TWI_Start_Transceiver_With_Data_Stop(data2, sizeof(data2), false);
}

void gyroRead (int16_t* x, int16_t* y, int16_t* z) {
    uint8_t data1[] = {0xD6, 0xA8};
    uint8_t data2[] = {0xD7, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
    // 0xD6 write to gyrometer (SA0 = 0)
    // 0xA8 read register 0x28
    // 0xD7 read from gyrometer (SA0 = 0)
    // read OUT_X_L
    // read OUT_X_H
    // read OUT_Y_L
    // read OUT_Y_H
    // read OUT_Z_L
    // read OUT_Z_H

    USI_TWI_Start_Transceiver_With_Data_Stop(data1, sizeof(data1), false);
    USI_TWI_Start_Transceiver_With_Data_Stop(data2, sizeof(data2), false);

    *x = (data2[2]<<8) | data2[1];
    *y = (data2[4]<<8) | data2[3];
    *z = (data2[6]<<8) | data2[5];
}

void gyroUpdate (int16_t* x, int16_t* y, int16_t* z, uint8_t* r, uint8_t* g, uint8_t* b, uint8_t* d, uint16_t* f) {
    gyroRead(x,y,z);
    gyroProcessData(*x,*y,*z,r,g,b,d,f);
}

bool gyroValid () {
    uint8_t data1[] = {0xD6, 0x8F};
    uint8_t data2[] = {0xD7, 0x00};
    // 0xD6 write to gyrometer (SA0 = 0)
    // 0x0F read register 0x0F
    // 0xD7 read from gyrometer (SA0 = 0)
    // read WHO_AM_I

    USI_TWI_Start_Transceiver_With_Data_Stop(data1, sizeof(data1), false);
    USI_TWI_Start_Transceiver_With_Data_Stop(data2, sizeof(data2), false);

    return data2[1] == 0xD4;
}
