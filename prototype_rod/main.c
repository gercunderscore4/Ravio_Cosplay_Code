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
/* APA102 
 * Based on APA102 library for Arduino.
 ****************************************************************/

#define BRIGHTNESS 31
#define BRIGHTNESS_BYTE (BRIGHTNESS << 5)

typedef struct rgb_color
{
    uint8_t red, green, blue;
    rgb_color() {};
    rgb_color(uint8_t r, uint8_t g, uint8_t b) : red(r), green(g), blue(b) {};
} rgb_color;

void init (void)
{
    digitalWrite(dataPin, LOW);
    digitalWrite(clockPin, LOW);
}

void transfer (uint8_t b)
{
    digitalWrite(dataPin, (b >> 7) & 1);
    digitalWrite(clockPin, HIGH);
    digitalWrite(clockPin, LOW);
    digitalWrite(dataPin, (b >> 6) & 1);
    digitalWrite(clockPin, HIGH);
    digitalWrite(clockPin, LOW);
    digitalWrite(dataPin, (b >> 5) & 1);
    digitalWrite(clockPin, HIGH);
    digitalWrite(clockPin, LOW);
    digitalWrite(dataPin, (b >> 4) & 1);
    digitalWrite(clockPin, HIGH);
    digitalWrite(clockPin, LOW);
    digitalWrite(dataPin, (b >> 3) & 1);
    digitalWrite(clockPin, HIGH);
    digitalWrite(clockPin, LOW);
    digitalWrite(dataPin, (b >> 2) & 1);
    digitalWrite(clockPin, HIGH);
    digitalWrite(clockPin, LOW);
    digitalWrite(dataPin, (b >> 1) & 1);
    digitalWrite(clockPin, HIGH);
    digitalWrite(clockPin, LOW);
    digitalWrite(dataPin, (b >> 0) & 1);
    digitalWrite(clockPin, HIGH);
    digitalWrite(clockPin, LOW);
}

void writeColors (rgb_color * colors, uint16_t count)
{
    // set DI and CI to zero
    init();
    // 0x00000000
    transfer(0);
    transfer(0);
    transfer(0);
    transfer(0);

    for (int i = 0; i < count; i++)
    {
        transfer(BRIGHTNESS_BYTE);
        transfer(color[i].blue);
        transfer(color[i].green);
        transfer(color[i].red);
    }

    if (count < 2)
    {
        // call init() here to make sure we leave the data line driving low
        init();
    }
    else
    {
        for (uint16_t i = 0; i < (count + 14)/16; i++)
        {
            transfer(0);
        }
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
