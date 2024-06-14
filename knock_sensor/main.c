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
 * PA5 :
 * PA6 :
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
#include "pwm.h"
#include "ArduinoLike.h"

/****************************************************************
 * MAIN
 ****************************************************************/

void setup (void) {
    pwmInit();
}

void loop (void) {
    pwmWrite(0x0A);
    delay(3000);
    pwmWrite(0x1E);
    delay(3000);
    pwmWrite(0x32);
    delay(3000);
    pwmOff();
}

int main (void) {
    setup();

    while (1) {
        loop();
    }
}
