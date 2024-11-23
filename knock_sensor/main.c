/*
 *     ATtiny84
 * VCC -+-\/-+- GND
 * PB0 -+    +- PA0
 * PB1 -+    +- PA1
 * PB3 -+    +- PA2
 * PB2 -+    +- PA3
 * PA7 -+    +- PA4
 * PA6 -+----+- PA5
 *
 * PA3 : blink
 * PA4 : SCL
 * PA6 : SDA
 * PA7 : PWM servo
 * PB2 : trigger
 *
 * Useful registers
 * ----------------
 *
 * DDRB  - Port B Data Direction Register
 * 0 = INPUT, 1 = OUTPUT
 *
 * PORTB - Port B Data Register
 * INPUT: 1 = PULL-UP
 *
 * PINB  - Port B Input Pins Address
 * 1 = HIGH, 0 = LOW
 */

#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/power.h>
#include <avr/sleep.h>
#include <util/delay.h>
#include "stdlib.h"
#include "servo.h"
#include "accel.h"

#define INT0_PIN 2

#define BLINK_PIN 3
#define BLINK_DELAY 300

/****************************************************************
 * HELPERS
 ****************************************************************/

void blink_twice (uint8_t pin) {
    DDRA |= _BV(pin);

    PORTA |= _BV(pin);
    _delay_ms(BLINK_DELAY);
    PORTA &= ~_BV(pin);
    _delay_ms(BLINK_DELAY);

    PORTA |= _BV(pin);
    _delay_ms(BLINK_DELAY);
    PORTA &= ~_BV(pin);
    _delay_ms(BLINK_DELAY);
}

void toggle (void) {
    DDRA |= _BV(BLINK_PIN);
    PORTA ^= _BV(BLINK_PIN);
}

ISR (INT0_vect) {
}

void sleep_until_int0_low (void) {
    // low power
    power_timer0_disable();
    power_timer1_disable();
    power_usi_disable();

    // setup interrupt
    GIMSK |= _BV(INT0);
    MCUCR &= (~_BV(ISC01)) & (~_BV(ISC00));

    sei();
    sleep_enable();
    sleep_bod_disable();
    sleep_cpu();

    // asleep

    sleep_disable();
    cli();

    // undo low power
    power_timer0_enable();
    power_timer1_enable();
    power_usi_enable();
}

/****************************************************************
 * MAIN
 ****************************************************************/

void setup (void) {
    //blink_twice(0);
    // we're not using the ADCs
    power_adc_disable();

    // standby mode, uses the least power
    set_sleep_mode(SLEEP_MODE_STANDBY);

    DDRB &= ~_BV(INT0_PIN);
    PORTB |= _BV(INT0_PIN);

    servo_init();

    accel_setup_interrupt();
    //blink_twice(1);
}

void loop (void) {
    // clear accelerometer
    while (!(PINB & _BV(INT0_PIN))) {
        //blink_twice(2);
        accel_setup_interrupt();
        accel_clear_interrupt();
    }
    // sleep
    sleep_until_int0_low();
    // do the thing
    //blink_twice(3);
    open_chest();
    _delay_ms(10000);
}

int main (void) {
    setup();
    while (1) {
        loop();
    }
    return 0;
}
