/****************************************************************
 * Accelerometer interface for ATtiny85
 ****************************************************************/

#ifndef __ACCEL_H__
#define __ACCEL_H__

#include <stdint.h>
#include <stdbool.h>
#include "USI_TWI_Master/USI_TWI_Master.h"

// A4 => SDA
// A5 => SCL
#define ACCEL_ADDR 0xA6

#define DEVID_ADDR 0x00
#define DEVID_VALUE 0xE5

// threshold
#define THRESH_TAP_ADDR 0x1D
#define THRESH_TAP_VALUE 0x40 // 62.5mg (milli-g's), 0x20 => 32 => 2g

// duration
#define DUR_ADDR 0x21
#define DUR_VALUE 0x30 // 625us scale factor, 0x30 = 30ms

#define TAP_AXES_ADDR 0x2A
#define TAP_AXES_VALUE 0x07 // x,y,z for tap

#define ACT_TAP_AXES_ADDR 0x2B
#define ACT_TAP_AXES_VALUE 0x07 // x,y,z for tap

#define BW_RATE_ADDR 0x2C
#define BW_RATE_VALUE 0x18 // 0x10 => low power, 0x08 => 12.5 Hz

#define PWR_CTL_ADDR 0x2D
#define PWR_CTL_VALUE 0x09 // 0x80 => measure don't standby, 0x01 => in sleep mode read at 4Hz

// enable this last
#define INT_ENABLE_ADDR 0x2E
#define INT_ENABLE_VALUE 0x40 // only tap

#define INT_MAP_ADDR 0x2F
#define INT_MAP_VALUE 0x00 // map all to INT1

#define INT_SOURCE_ADDR 0x30

void accel_setup_interrupt (void);
void accel_clear_interrupt (void);

#endif // __ACCEL_H__
