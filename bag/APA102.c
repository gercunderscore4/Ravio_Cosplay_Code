/****************************************************************
 * APA102 on ATtiny84
 *
 * Designed to handle up to 240 LEDs.
 * Based on APA102 library for Arduino.
 ****************************************************************/

#include "APA102.h"

void APA102Init (void)
{
    DDRA |= (BIT_DO | BIT_CO);
    PORTA &= ~(BIT_DO | BIT_CO);
}

void APA102Transfer (uint8_t b)
{
    PORTA = (b & (1 << 7)) ? (PORTA | BIT_DO) : (PORTA & ~BIT_DO);
    CYCLE_CLOCK();
    PORTA = (b & (1 << 6)) ? (PORTA | BIT_DO) : (PORTA & ~BIT_DO);
    CYCLE_CLOCK();
    PORTA = (b & (1 << 5)) ? (PORTA | BIT_DO) : (PORTA & ~BIT_DO);
    CYCLE_CLOCK();
    PORTA = (b & (1 << 4)) ? (PORTA | BIT_DO) : (PORTA & ~BIT_DO);
    CYCLE_CLOCK();
    PORTA = (b & (1 << 3)) ? (PORTA | BIT_DO) : (PORTA & ~BIT_DO);
    CYCLE_CLOCK();
    PORTA = (b & (1 << 2)) ? (PORTA | BIT_DO) : (PORTA & ~BIT_DO);
    CYCLE_CLOCK();
    PORTA = (b & (1 << 1)) ? (PORTA | BIT_DO) : (PORTA & ~BIT_DO);
    CYCLE_CLOCK();
    PORTA = (b & (1 << 0)) ? (PORTA | BIT_DO) : (PORTA & ~BIT_DO);
    CYCLE_CLOCK();
}

void APA102WriteColors (rgb_color* colors, uint8_t count)
{
    // set DI and CI to zero
    PORTA &= ~(BIT_DO | BIT_CO);

    // start frame
    // 0x00000000
    PORTA &= ~BIT_DO; // send zeros
    for (uint8_t i = 0; i < 32; i++)
    {
        CYCLE_CLOCK();
    }

    // send colors
    for (uint8_t i = 0; i < count; i++)
    {
        APA102Transfer(BRIGHTNESS_BYTE);
        APA102Transfer(colors[i].blue);
        APA102Transfer(colors[i].green);
        APA102Transfer(colors[i].red);
    }

    // end frame
    // needs at least n/2 extra pulse
    PORTA &= ~BIT_DO; // send zeros
    for (uint8_t i = 0; i < count; i+= 16)
    {
        CYCLE_CLOCK();
    }
}

void APA102WriteBlack (uint8_t count)
{
    // set DI and CI to zero
    PORTA &= ~(BIT_DO | BIT_CO);

    // start frame
    // 0x00000000
    PORTA &= ~BIT_DO; // send zeros
    for (uint8_t i = 0; i < 32; i++)
    {
        CYCLE_CLOCK();
    }

    // send colors
    for (uint8_t i = 0; i < count; i++)
    {
        APA102Transfer(BRIGHTNESS_BYTE);
        APA102Transfer(0x00);
        APA102Transfer(0x00);
        APA102Transfer(0x00);
    }

    // end frame
    // needs at least n/2 extra pulse
    PORTA &= ~BIT_DO; // send zeros
    for (uint8_t i = 0; i < count; i+= 16)
    {
        CYCLE_CLOCK();
    }
}
