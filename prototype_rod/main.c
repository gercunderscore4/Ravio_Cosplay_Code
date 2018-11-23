/*
 * File: main.c
 * Purpose: test code for making a magical wand (rod) look and sound cool
 * Notes:
 *     - uc: ATtiny85
 *     - LEDs: APA102
 *     - accelerometer: LIS2DH
 *     - audio amplifier: TPA2005D1
 *     - code is currently incomplete, DO NOT COMPILE OR FLASH
 */

#include <avr/io.h>
#include <util/delay.h>

ISR (TIMER0_COMPA_vect)
{
    // for now, just invert
    // assume it starts with 0xFF or 0x00
    // or set it before starting
    OCR1A ^= OCR1A;
}

void setup (void)
{
    // enable 64MHZ PLL and use as source for Timer1
    PLLCSR = 1<<PCKE | 1<<PLLE;

    // setup Timer1/Counter1 for PWM output
    TIMSK = 0; // timer interrupts OFF
    TCCR1 = 1<<PWM1A | 2<<COM1A0 | 1<<CS10; // PWM OCR1A, clear on match, 1:1 prescale
    OCR1A = 0; // initialize output to zero
    
}

int main (void)
{
    
    // wait forever, let the interrupt do its thing
    while (1);

    // if the loop ever stops, something has gone wrong
    return 1;
}
