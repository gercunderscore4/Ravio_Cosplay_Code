/****************************************************************
 * APA102 on ATtiny85
 * 
 * Designed to handle up to 240 LEDs.
 * Based on APA102 library for Arduino.
 ****************************************************************/

#include "APA102.h"

void APA102transfer (uint8_t b)
{
    PORTB = (b & (1 << 7)) ? (PORTB | BIT_DI) : (PORTB & ~BIT_DI);
    CYCLE_CLOCK;
    PORTB = (b & (1 << 6)) ? (PORTB | BIT_DI) : (PORTB & ~BIT_DI);
    CYCLE_CLOCK;
    PORTB = (b & (1 << 5)) ? (PORTB | BIT_DI) : (PORTB & ~BIT_DI);
    CYCLE_CLOCK;
    PORTB = (b & (1 << 4)) ? (PORTB | BIT_DI) : (PORTB & ~BIT_DI);
    CYCLE_CLOCK;
    PORTB = (b & (1 << 3)) ? (PORTB | BIT_DI) : (PORTB & ~BIT_DI);
    CYCLE_CLOCK;
    PORTB = (b & (1 << 2)) ? (PORTB | BIT_DI) : (PORTB & ~BIT_DI);
    CYCLE_CLOCK;
    PORTB = (b & (1 << 1)) ? (PORTB | BIT_DI) : (PORTB & ~BIT_DI);
    CYCLE_CLOCK;
    PORTB = (b & (1 << 0)) ? (PORTB | BIT_DI) : (PORTB & ~BIT_DI);
    CYCLE_CLOCK;
}

void APA102WriteColors (rgb_color * colors, uint8_t count)
{
    // redundant after the first time, but should be quick
    // and I don't need to optimize THAT much
    DDRB |= BIT_DI | BIT_CI;

    // set DI and CI to zero
    PORTB &= ~(BIT_DI | BIT_CI);

    // start frame
    // 0x00000000
    PORTB &= ~BIT_DI; // send zeros
    for (uint8_t i = 0; i < 32; i++)
    {
        CYCLE_CLOCK;
    }

    // send colors
    for (int i = 0; i < count; i++)
    {
        APA102Transfer(BRIGHTNESS_BYTE);
        APA102Transfer(colors[i].blue);
        APA102Transfer(colors[i].green);
        APA102Transfer(colors[i].red);
    }

    // end frame
    // needs at least n/2 extra pulse
    PORTB &= ~BIT_DI; // send zeros
    for (uint8_t i = 0; i < count; i+= 16)
    {
        CYCLE_CLOCK;
    }
}
