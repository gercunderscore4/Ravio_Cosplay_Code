/****************************************************************
 * APA102 on ATtiny85
 *
 * Designed to handle up to 240 LEDs.
 * Based on APA102 library for Arduino.
 ****************************************************************/

#include "APA102.h"

void APA102Init (rgb_color* colors, uint8_t count)
{
    DDRB |= BIT_DO | BIT_CO;

    for (int i = 0; i < count; i++)
    {
        colors[i].blue  = 0x00;
        colors[i].green = 0x00;
        colors[i].red   = 0x00;
    }
}

void APA102Transfer (uint8_t b)
{
    PORTB = (b & (1 << 7)) ? (PORTB | BIT_DO) : (PORTB & ~BIT_DO);
    CYCLE_CLOCK();
    PORTB = (b & (1 << 6)) ? (PORTB | BIT_DO) : (PORTB & ~BIT_DO);
    CYCLE_CLOCK();
    PORTB = (b & (1 << 5)) ? (PORTB | BIT_DO) : (PORTB & ~BIT_DO);
    CYCLE_CLOCK();
    PORTB = (b & (1 << 4)) ? (PORTB | BIT_DO) : (PORTB & ~BIT_DO);
    CYCLE_CLOCK();
    PORTB = (b & (1 << 3)) ? (PORTB | BIT_DO) : (PORTB & ~BIT_DO);
    CYCLE_CLOCK();
    PORTB = (b & (1 << 2)) ? (PORTB | BIT_DO) : (PORTB & ~BIT_DO);
    CYCLE_CLOCK();
    PORTB = (b & (1 << 1)) ? (PORTB | BIT_DO) : (PORTB & ~BIT_DO);
    CYCLE_CLOCK();
    PORTB = (b & (1 << 0)) ? (PORTB | BIT_DO) : (PORTB & ~BIT_DO);
    CYCLE_CLOCK();
}

void APA102WriteColors (rgb_color* colors, uint8_t count)
{
    // set DI and CI to zero
    PORTB &= ~(BIT_DO | BIT_CO);

    // start frame
    // 0x00000000
    PORTB &= ~BIT_DO; // send zeros
    for (uint8_t i = 0; i < 32; i++)
    {
        CYCLE_CLOCK();
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
    PORTB &= ~BIT_DO; // send zeros
    for (uint8_t i = 0; i < count; i+= 16)
    {
        CYCLE_CLOCK();
    }
}
