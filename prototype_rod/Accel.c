/****************************************************************
 * Accelerometer interface for ATtiny85
 ****************************************************************/

#include "stdlib.h"
#include "Accel.h"

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

void accelProcessData (int16_t x, int16_t y, int16_t z, uint8_t* r, uint8_t* g, uint8_t* b, uint16_t* f) {
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
    *f = (uint16_t) SQRT_BY_DIGIT[d];

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

void accelInit (void) {
    uint8_t data[] = {0x30, 0xA0, 0x7F, 0x00, 0x00, 0x30, 0x00, 0x00};
    USI_TWI_Master_Initialise();
    //USI_TWI_Start_Transceiver_With_Data_Stop(data, sizeof(data), true);
}

void accelRead (int16_t* x, int16_t* y, int16_t* z) {
    uint8_t data1[] = {0x30, 0xA8};
    uint8_t data2[] = {0x31, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
    // 0x31 read from accelerometer (SA0 = 0)
    // 0xA8 read register 0xA8

    /*
     * Transer when master is receiving multiple bytes of data from slave
     *
     * Master|ST|SAD+W|   |SUB|   |SR|SAD+R|   |    |MAK|    |MAK|    |NMAK|SP
     * ------+--+-----+---+---+---+--+-----+---+----+---+----+---+----+----+--
     * Slave |  |     |SAK|   |SAK|  |     |SAK|DATA|   |DATA|   |DATA|    |
     *
     * all bit signals MSB first
     *
     * ST    : start condition, SDA high->low while SCL high
     * SAD+W : slave address (7-bits), write
     * SAK   : slave ack
     * SUB   : sub-address (MSB is auto-incrememt, 6 bit address, read/not-write)
     * SAK   : slave ack
     * SR    : repeated start condition, SDA high->low while SCL high
     * SAD+R : slave address, read
     * SAK   : slave ack
     * DATA  : one byte, MSB first
     * MAK   : master ack
     * DATA  : one byte, MSB first
     * MAK   : master ack
     * DATA  : one byte, MSB first
     * NMAK  : no master ack
     * SP    : stop condition, SDA low->high while SCL high
     *
     * Well, this just got more complex.
     * I'm tempted to just write more bit-banging.
     *
     *           A  A  A  A  A  A  A  R  K       S  S  S  S  S  S  S  R  K    A  A  A  A  A  A  A  R  K  
     *     _           ____              _  __   _     _     _           _          ____           ____  
     * SDA  \_________/    \____________/ \/  \_/ \___/ \___/ \_________/ \________/    \_________/    \_
     *     ___                                                                                           
     * SCL    \__|__|__|__|__|__|__|__|__|_______|__|__|__|__|__|__|__|__|____|__|__|__|__|__|__|__|__|__
     *
     */
    
    //USI_TWI_Start_Transceiver_With_Data_Stop(data1, sizeof(data1), false);
    //USI_TWI_Start_Transceiver_With_Data_Stop(data2, sizeof(data2), true);

    // read WHO_AM_I register
    USI_TWI_Master_Initialise();
    data1[0] = 0x30;
    data1[1] = 0x8F;
    data2[0] = 0x31;
    data2[1] = 0x00;
    USI_TWI_Start_Transceiver_With_Data_Stop(data1, sizeof(data1), false);
    USI_TWI_Start_Transceiver_With_Data_Stop(data2, 2, true);
    
    //if (true == i2c_read(LIS2DH12_ADDR, LIS2DH12_OUT_X_L, data, 6)) {

    //data[0] = 0x30;
    //if (USI_TWI_Start_Transceiver_With_Data_Stop(&(data[0]), 1, false)) {
    //    if (USI_TWI_Start_Transceiver_With_Data_Stop(&(data[1]), 1, false)) {
    //        data[0] = 0x31;
    //        if (USI_TWI_Start_Transceiver_With_Data_Stop(&(data[0]), 1, false)) {
    //            if (USI_TWI_Start_Transceiver_With_Data_Stop(data, sizeof(data), true)) {
    //                *x = (data[1]<<8) | data[0];
    //                *y = (data[3]<<8) | data[2];
    //                *z = (data[5]<<8) | data[4];
    //            }
    //        }
    //    }
    //}
}

void accelUpdate (int16_t* x, int16_t* y, int16_t* z, uint8_t* r, uint8_t* g, uint8_t* b, uint16_t* f) {
    accelRead(x,y,z);
    accelProcessData(*x,*y,*z,r,g,b,f);
}
