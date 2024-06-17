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
 * PA0 : trigger
 * PA1 :
 * PA2 :
 * PA3 :
 * PA4 : SCL
 * PA5 :
 * PA6 : SDA
 * PA7 : PWM servo
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
#include <util/delay.h>
#include "stdlib.h"
#include "servo.h"
#include "accel.h"
#include "ArduinoLike.h"

/****************************************************************
 * POWER
 ****************************************************************/

void shutdown(void) {
    // enable interrupts
    // this interrupt requires ISC01,ISC00=0,1 
    
    SREG |= (1 << 7)

    // power reduction
    PRR = (1 << PRTIM1) | (1 << PRTIM0) | (1 << PRUSI)  | (1 << PRADC);
    // BODS sequence
    MCUCR = (1 << BODS) | (0 << PUD) | (0 << SE) | (0 << SM1) | (0 << SM0) | (1 << BODSE) | (0 << ISC01) | (1 << ISC00);
    MCUCR = (1 << BODS) | (0 << PUD) | (0 << SE) | (0 << SM1) | (0 << SM0) | (0 << BODSE) | (0 << ISC01) | (1 << ISC00);
    // power down
    MCUCR = (1 << BODS) | (1 << PUD) | (1 << SE) | (1 << SM1) | (0 << SM0) | (0 << BODSE) | (0 << ISC01) | (1 << ISC00);
}

void power_up(void) {
    // disable sleep
    MCUCR = (0 << BODS) | (0 << PUD) | (0 << SE) | (0 << SM1) | (0 << SM0) | (0 << BODSE);
    // undo power reduction
    PRR = (0 << PRTIM1) | (0 << PRTIM0) | (0 << PRUSI)  | (0 << PRADC);
}

/****************************************************************
 * MAIN
 ****************************************************************/
void setup (void) {
    power_up();

    accel_setup_interrupt();
    accel_clear_interrupt();

    servo_init();
    servo_write(CW_MAX);
    delay(3000);
    servo_write(CCW_MAX);
    delay(3000);
    servo_off();

    //shutdown();
}

void loop (void) {
}

int main (void) {
    setup();

    while (1) {
        loop();
    }
}
