/* Audio Sample Player v2

   David Johnson-Davies - www.technoblogy.com - 23rd October 2017
   ATtiny85 @ 8 MHz (internal oscillator; BOD disabled)
      
   CC BY 4.0
   Licensed under a Creative Commons Attribution 4.0 International license: 
   http://creativecommons.org/licenses/by/4.0/
*/

/*
 *         _____
 *    RES-|o    |-VCC
 *    PB3-| T85 |-PB2
 *    PB4-|     |-PB1
 *    GND-|_____|-PB0
 *         _____
 *       -|o    |-VCC
 *       -| T85 |-
 * AUDIO2-|     |-AUDIO1
 *    GND-|_____|-
 * 
 */

/* Direct-coupled capacitorless output */

#include "sound.h"
#include <avr/sleep.h>

#define adc_disable() (ADCSRA &= ~(1<<ADEN))

/*
 * if (mode == INPUT) { 
 *     DDRB &= ~bit;
 *     PORTB &= ~bit;
 * } else if (mode == INPUT_PULLUP) {
 *     DDRB &= ~bit;
 *     PORTB |= bit;
 * } else if (mode == OUTPUT) {
 *     DDRB |= bit;
 * }
 */

int main (void) {
    // Enable 64 MHz PLL and use as source for Timer1
    PLLCSR = 1<<PCKE | 1<<PLLE;     
    
    // Set up Timer/Counter1 for PWM output
    TIMSK = 0;                              // Timer interrupts OFF
    TCCR1 = 1<<PWM1A | 2<<COM1A0 | 1<<CS10; // PWM A, clear on match, 1:1 prescale
    GTCCR = 1<<PWM1B | 2<<COM1B0;           // PWM B, clear on match
    OCR1A = 128; OCR1B = 128;               // 50% duty at start
    
    // Set up Timer/Counter0 for 8kHz interrupt to output samples.
    TCCR0A = 3<<WGM00;                      // Fast PWM
    TCCR0B = 1<<WGM02 | 2<<CS00;            // 1/8 prescale
    TIMSK = 1<<OCIE0A;                      // Enable compare match
    OCR0A = 124;                            // Divide by 1000
    
    set_sleep_mode(SLEEP_MODE_PWR_DOWN);
    DDRB = 1<<1 | 1<<4;
    
    while(1);
    
    return 1;
}

// Sample interrupt
ISR (TIMER0_COMPA_vect) {
    char sample = pgm_read_byte(&quack_wav[p++]);
    OCR1A = sample; OCR1B = sample ^ 255;
    // End of data? Go to sleep
    if (p == quack_wav_len) {
        TIMSK = 0;
        adc_disable();
        sleep_enable();
        sleep_cpu();  // 1uA
    }
}
