/****************************************************************
 * I2C on ATtiny85
 *
 * Based on:
 *     http://codinglab.blogspot.com/2008/10/i2c-on-avr-using-bit-banging.html
 ****************************************************************/

#ifndef __I2C_H__
#define __I2C_H__

#include <avr/io.h>

// Port for the I2C
#define I2C_DDR DDRB
#define I2C_PIN PINB
#define I2C_PORT PORTB

// Pins to be used in the bit banging
#define I2C_CLK 2
#define I2C_DAT 0

#define I2C_DATA_HI()\
I2C_DDR &= ~ (1 << I2C_DAT);\
I2C_PORT |= (1 << I2C_DAT);
#define I2C_DATA_LO()\
I2C_DDR |= (1 << I2C_DAT);\
I2C_PORT &= ~ (1 << I2C_DAT);

#define I2C_CLOCK_HI()\
I2C_DDR &= ~ (1 << I2C_CLK);\
I2C_PORT |= (1 << I2C_CLK);
#define I2C_CLOCK_LO()\
I2C_DDR |= (1 << I2C_CLK);\
I2C_PORT &= ~ (1 << I2C_CLK);

void I2C_WriteBit (uint8_t c);
uint8_t I2C_ReadBit (void);
void I2C_Init (void);
void I2C_Start (void);
void I2C_Stop (void);
uint8_t I2C_Write (uint8_t c);
uint8_t I2C_Read (uint8_t ack);

#endif // __I2C_H__
