/*
 * ATtiny84 analog input
 * Section 11
 * 
 * Useful registers
 * ----------------
 * 
 * TCNT0, OCR0A, OCR0B, TCCR0A, TCCR0B are 8-bit.
 * All should work as expected in C.
 * 
 * Compares OCR0A/B to TCNT0.
 * Output on OCnx
 * 
 * TCCR0A
 * +--------+--------+--------+--------+-------+-------+-------+-------+
 * | COM0A1 | COM0A0 | COM0B1 | COM0B0 |   –   |   –   | WGM01 | WGM00 |
 * +--------+--------+--------+--------+-------+-------+-------+-------+
 * 
 * TCCR0B
 * +-------+-------+-------+-------+-------+------+------+------+
 * | FOC0A | FOC0B |   -   |   -   | WGM02 | CS02 | CS01 | CS00 |
 * +-------+-------+-------+-------+-------+------+------+------+
 * 
 * COM0A1 COM0A0 controls what happens to OC0A
 * 0b00 = disconnected
 * 0b10 = non-inverting mode
 * 0b11 = inverting mode
 * 
 * COM0B1 COM0B0 same as above
 * 
 * WGM02 WGM01 WGM00 control mode
 * 0b000 = normal
 * 0b011 = Fast PWM
 * 
 * CS02 CS01 CS00: Clock select
 * 0x000 = no clock (timer/counter stopped)
 * 0x001 = clk
 * 
 * FOC0A, FOC0B, Force Output Compare for Channel x
 * Performs action from COMnxm
 * 
 * 
 * want Fast PWM Mode
 * no scaling (faster)
 * non-inverted
 * OC0B (PA7)
 * 
 */

#include "pwm.h"

void pwmInit (void) {
    // output
    DDRA  |=  (1 << PWM_PIN);
    // no pull-up
    PORTA &= ~(1 << PWM_PIN);
    // set pin low
    PINA  &= ~(1 << PWM_PIN);
}

void pwmWrite (uint8_t pwm) {
    OCR0B = pwm;
    TCCR0A = (0 << COM0A1) | (0 << COM0A0) | (1 << COM0B1) | (0 << COM0B0) | (1 << WGM01) | (1 << WGM00);
    TCCR0B = (0 << FOC0A) | (0 << FOC0B) | (0 << WGM02) | (0 << CS02) | (0 << CS01) | (1 << CS00);
}

void pwmOff (void) {
    OCR0B = 0x00;
    TCCR0A = (0 << COM0A1) | (0 << COM0A0) | (0 << COM0B1) | (0 << COM0B0) | (0 << WGM01) | (0 << WGM00);
    TCCR0B = (0 << FOC0A) | (0 << FOC0B) | (0 << WGM02) | (0 << CS02) | (0 << CS01) | (0 << CS00);
    // set pin low
    PINA &= ~(1 << PWM_PIN);
}


