/****************************************************************
 * Accelerometer interface for ATtiny85
 ****************************************************************/

#ifndef __ACCEL_H__
#define __ACCEL_H__

#include "USI_TWI_Master.h"

#define LIS2DH12_RANGE_2GA  0x00
#define LIS2DH12_RANGE_4GA  0x10
#define LIS2DH12_RANGE_8GA  0x20
#define LIS2DH12_RANGE_16GA 0x40

void accelInit (void);
void accelProcessData (int16_t x, int16_t y, int16_t z, uint8_t* r, uint8_t* g, uint8_t* b, uint16_t* f);
void accelRead (int16_t* x, int16_t* y, int16_t* z);
void accelUpdate (int16_t* x, int16_t* y, int16_t* z, uint8_t* r, uint8_t* g, uint8_t* b, uint16_t* f);

#endif // __ACCEL_H__
