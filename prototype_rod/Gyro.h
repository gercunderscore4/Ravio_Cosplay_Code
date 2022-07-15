/****************************************************************
 * Accelerometer interface for ATtiny85
 ****************************************************************/

#ifndef __GYRO_H__
#define __GYRO_H__

#include <stdint.h>
#include <stdbool.h>
#include "USI_TWI_Master/USI_TWI_Master.h"

void gyroInit (void);
void gyroProcessData (int16_t x, int16_t y, int16_t z, uint8_t* r, uint8_t* g, uint8_t* b, uint8_t* d, uint16_t* f);
void gyroRead (int16_t* x, int16_t* y, int16_t* z);
void gyroUpdate (int16_t* x, int16_t* y, int16_t* z, uint8_t* r, uint8_t* g, uint8_t* b, uint8_t* d, uint16_t* f);

#endif // __GYRO_H__
