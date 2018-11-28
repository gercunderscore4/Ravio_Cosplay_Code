/*
 * File: main.cpp
 * Purpose: test code for making a magical wand (rod) look and sound cool
 * Notes:
 *     - uc: ATtiny85
 *     - LEDs: APA102
 *     - accelerometer: LIS2DH
 *     - audio amplifier: TPA2005D1
 *     - code is currently incomplete, DO NOT COMPILE OR FLASH
 *     - INCOMPLETE
 */

#include <avr/io.h>
#include <util/delay.h>


/****************************************************************
 * APA102 
 * Based on APA102 library for Arduino.
 ****************************************************************/

// cannot deal with 0 or >240 LEDs

#define BRIGHTNESS 31
#define LED_DATA_PORT  5
#define LED_CLOCK_PORT 4

// brightness can be controlled by lowering the rgb values
// therefore, optimize it out
#define BRIGHTNESS_BYTE (0xE0 | BRIGHTNESS)

#define BIT_DI (1 << LED_DATA_PORT)
#define BIT_CI (1 << LED_CLOCK_PORT)

typedef struct rgb_color
{
    uint8_t red, green, blue;
    rgb_color() {};
    rgb_color(uint8_t r, uint8_t g, uint8_t b) : red(r), green(g), blue(b) {};
} rgb_color;

void init (void)
{
    DDRB |= BIT_DI | BIT_CI;
}

void zero (void)
{
}

void transfer (uint8_t b)
{
    PORTB = ((b >> 7) & 1) ? (PORTB | BIT_DI) : (PORTB & ~BIT_DI);
    PORTB |=  BIT_CI;
    PORTB &= ~BIT_CI;
    PORTB = ((b >> 6) & 1) ? (PORTB | BIT_DI) : (PORTB & ~BIT_DI);
    PORTB |=  BIT_CI;
    PORTB &= ~BIT_CI;
    PORTB = ((b >> 5) & 1) ? (PORTB | BIT_DI) : (PORTB & ~BIT_DI);
    PORTB |=  BIT_CI;
    PORTB &= ~BIT_CI;
    PORTB = ((b >> 4) & 1) ? (PORTB | BIT_DI) : (PORTB & ~BIT_DI);
    PORTB |=  BIT_CI;
    PORTB &= ~BIT_CI;
    PORTB = ((b >> 3) & 1) ? (PORTB | BIT_DI) : (PORTB & ~BIT_DI);
    PORTB |=  BIT_CI;
    PORTB &= ~BIT_CI;
    PORTB = ((b >> 2) & 1) ? (PORTB | BIT_DI) : (PORTB & ~BIT_DI);
    PORTB |=  BIT_CI;
    PORTB &= ~BIT_CI;
    PORTB = ((b >> 1) & 1) ? (PORTB | BIT_DI) : (PORTB & ~BIT_DI);
    PORTB |=  BIT_CI;
    PORTB &= ~BIT_CI;
    PORTB = ((b >> 0) & 1) ? (PORTB | BIT_DI) : (PORTB & ~BIT_DI);
    PORTB |=  BIT_CI;
    PORTB &= ~BIT_CI;
}

void writeColors (rgb_color * colors, uint8_t count)
{
    // set DI and CI to zero
    PORTB &= ~(BIT_DI | BIT_CI);

    // start frame
    // 0x00000000
    transfer(0x00);
    transfer(0x00);
    transfer(0x00);
    transfer(0x00);

    // send colors
    for (int i = 0; i < count; i++)
    {
        transfer(BRIGHTNESS_BYTE);
        transfer(colors[i].blue);
        transfer(colors[i].green);
        transfer(colors[i].red);
    }

    // end frame
    // needs at least n/2 extra pulse
    PORTB &= ~BIT_DI; // send zeros
    for (uint8_t i = 0; i < count; i+= 16)
    {
        PORTB |=  BIT_CI;
        PORTB &= ~BIT_CI;
    }
}

/****************************************************************
 * MAIN
 ****************************************************************/

int main (void)
{
    // set PB3 to be output
    DDRB = 0b00001000;
    while (1) {
        // set PB3 high
        PORTB = 0b00001000;
        _delay_ms(250);
        // set PB3 low
        PORTB = 0b00000000;
        _delay_ms(250);
    }
    return 1;
}
