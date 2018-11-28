/****************************************************************
 * I2C on ATtiny85
 *
 * Based on:
 *     http://codinglab.blogspot.com/2008/10/i2c-on-avr-using-bit-banging.html
 ****************************************************************/

#include "I2C.h"

void I2C_WriteBit (uint8_t c)
{
    if (c)
    {
        I2C_DATA_HI();
    }
    else
    {
        I2C_DATA_LO();
    }

    I2C_CLOCK_HI();
    delay(1);

    I2C_CLOCK_LO();
    delay(1);

    if (c)
    {
        I2C_DATA_LO();
    }

    delay(1);
}

uint8_t I2C_ReadBit (void)
{
    I2C_DATA_HI();

    I2C_CLOCK_HI();
    delay(1);

    uint8_t c = I2C_PIN;

    I2C_CLOCK_LO();
    delay(1);

    return (c >> I2C_DAT) & 1;
}

// Inits bitbanging port, must be called before using the functions below
//
void I2C_Init (void)
{
    I2C_PORT &= ~ ((1 << I2C_DAT) | (1 << I2C_CLK));

    I2C_CLOCK_HI();
    I2C_DATA_HI();

    delay(1);
}

// Send a START Condition
//
void I2C_Start (void)
{
    // set both to high at the same time
    I2C_DDR &= ~ ((1 << I2C_DAT) | (1 << I2C_CLK));
    delay(1);

    I2C_DATA_LO();
    delay(1);

    I2C_CLOCK_LO();
    delay(1);
}

// Send a STOP Condition
//
void I2C_Stop (void)
{
    I2C_CLOCK_HI();
    delay(1);

    I2C_DATA_HI();
    delay(1);
}

// write a byte to the I2C slave device
//
uint8_t I2C_Write (uint8_t c)
{
    for (uint8_t i = 0; i < 8; i++)
    {
        I2C_WriteBit(c & 0x80);

        c <<= 1;
    }

    //return I2C_ReadBit();
    return 0;
}


// read a byte from the I2C slave device
//
uint8_t I2C_Read (uint8_t ack)
{
    uint8_t res = 0;

    for (uint8_t i = 0; i < 8; i++)
    {
        res <<= 1;
        res |= I2C_ReadBit();
    }

    if (ack)
    {
        I2C_WriteBit(0);
    }
    else
    {
        I2C_WriteBit(1);
    }

    delay(1);

    return res;
}
