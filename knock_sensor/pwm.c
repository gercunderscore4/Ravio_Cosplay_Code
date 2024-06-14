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
 * 0b001 = PWM (top is 0xFF)
 * 0b101 = PWM (top is ORC0A)
 * 0b011 = Fast PWM
 * 
 * CS02 CS01 CS00: Clock select
 * 0x000 = no clock (timer/counter stopped)
 * 0x001 = clk
 * 
 * FOC0A, FOC0B, Force Output Compare for Channel x
 * Performs action from COMnxm
 * 
 * want Fast PWM Mode
 * no scaling (faster)
 * non-inverted
 * OC0B (PA7)
 * 
 * f_OCnxPCPWM = f_clk_IO / ( N x 510)
 * N is prescale factor 1,8,64,256,1024
 *
 * f_PWM = 15625Hz (64us)
 * 8MHz clock
 * N = 1
 *
 * If I can set the pre-scaler to 256, 
 * I can get f_PWM = 61Hz (16ms) which is almost 50Hz
 * Then 16ms / 256 = 64us
 * 500us = 0x0A, 2500us = 0x32
 *
 * CS02 CS01 CS00
 * 0b000 no clock
 * 0b001 N =    1
 * 0b010 N =    8
 * 0b011 N =   64
 * 0b100 N =  256
 * 0b101 N = 1024
 * 0b110 N = external falling edge
 * 0b111 N = external rising edge
 * 
 * Got it working, mostly.
 * It doesn't seem to like 0x32.
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
    TCCR0A = (0 << COM0A1) | (0 << COM0A0) | (1 << COM0B1) | (0 << COM0B0) | (0 << WGM01) | (1 << WGM00);
    TCCR0B = (0 << FOC0A) | (0 << FOC0B) | (0 << WGM02) | (1 << CS02) | (0 << CS01) | (0 << CS00);
}

void pwmOff (void) {
    OCR0B = 0x00;
    TCCR0A = (0 << COM0A1) | (0 << COM0A0) | (0 << COM0B1) | (0 << COM0B0) | (0 << WGM01) | (1 << WGM00);
    TCCR0B = (0 << FOC0A) | (0 << FOC0B) | (0 << WGM02) | (1 << CS02) | (0 << CS01) | (0 << CS00);
    // set pin low
    PINA &= ~(1 << PWM_PIN);
}


