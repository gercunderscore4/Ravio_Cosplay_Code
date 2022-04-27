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
 * PA0 : trigger, voltage divider
 * PA1 : fuse 1, LED
 * PA2 : fuse 2, LED
 * PA3 : fuse 3, LED
 * PA5 : motor, MOSFET, motor
 * PA6 : sound, MOSFET, speaker
 * PA7 : flash, MOSFET, LED array
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
#include "InterruptAudio.h"
#include "AnalogInput.h"
#include "ArduinoLike.h"
#include "pwm.h"

/****************************************************************
 * MAIN
 ****************************************************************/

/*
int main (void) {
    init_audio();

    toneOn(0);

    uint16_t timeBlock = 0;
    uint16_t f = 0;
    uint16_t t = 0;
    while (1) {
        // these are manually picked through testing
        f = randomWMinMax(6000, 7000);
        t = randomWMinMax(2, 4);
        timeBlock += t;
        changeTone(f);
        delay(t);
    }
    while(1) {
        for (f = 1000; f <= 20000; f += 1000) {
            changeTone(f);
            delay(1000);
        }
    }

    noTone();

    return 1;
}
*/

//      ANALOG_PIN   // PA0
#define FUSE_1_PIN 1 // PA1
#define FUSE_2_PIN 2 // PA2
#define FUSE_3_PIN 3 // PA3
#define MOTOR_PIN  5 // PA5
//      AUDIO_PIN    // PA6
//      FLASH_PIN    // PA7

#define TRIGGER_THRESH ((uint16_t) (0.5 * ANALOG_MAX)) // range 0 ~ 1023

uint8_t debounceTrigger (void) {
    if (analogRead() > TRIGGER_THRESH) {
        delay(50);
        if (analogRead() > TRIGGER_THRESH) {
            return 1;
        }
    }
    return 0;
}

void waitForTrigger (void) {
    while (!debounceTrigger());
}

void soundFuse (int time_ms) {
    int timeBlock = 0;
    int f = 0;
    int t = 0;
    while (timeBlock < time_ms) {
        // these are manually picked through testing
        f = randomWMinMax(6000, 9000);
        t = randomWMinMax(   2,    4);
        timeBlock += t;
        changeTone(f);
        delay(t);
    }
}

void sparkleFuse (int pin) {
    //toneOn(0);
    for (int i = 0; i < 10; i++) {
        digitalWrite(pin, HIGH);
        soundFuse(50);
        digitalWrite(pin, LOW);
        soundFuse(50);
    }
    //noTone();
}

void setup (void) {
    analogInit();
    init_audio();
    pwmInit();

    // set outputs
    pinMode(FUSE_1_PIN, OUTPUT);
    pinMode(FUSE_2_PIN, OUTPUT);
    pinMode(FUSE_3_PIN, OUTPUT);
    pinMode(MOTOR_PIN,  OUTPUT);
    
    // set all low
    digitalWrite(FUSE_1_PIN, LOW);
    digitalWrite(FUSE_2_PIN, LOW);
    digitalWrite(FUSE_3_PIN, LOW);
    digitalWrite(MOTOR_PIN,  LOW);
}

void loop (void) {
    // wait for trigger to start
    waitForTrigger();
    
    // fuse
    toneOn(0);
    sparkleFuse(FUSE_1_PIN);
    sparkleFuse(FUSE_2_PIN);
    sparkleFuse(FUSE_3_PIN);
    noTone();

    // if user is still holding the fuse, don't explode
    if (debounceTrigger()) {
        delay(3000);
        return;
    }
    
    // start motor
    digitalWrite(MOTOR_PIN, HIGH);

    int fMax = 0;
    int timeBlock = 0;
    int time_ms = 0;
    int f = 0;
    int t = 0;
    // decrease f and brightness to reach zero together
    fMax = 1600;
    time_ms = 5;
    uint8_t brightness = 0xFF;
    while (fMax) {
        // set brightness, then divide by 2
        pwmWrite(brightness);
        brightness >>= 1;

        // play 100ms of sound
        // and decrease f
        timeBlock = 0;
        while (timeBlock < time_ms) {
            f = randomWMinMax(0, fMax);
            t = randomWMinMax(0,    3);
            timeBlock += t;
            toneOn(f);
            delay(t);
        }
        fMax -= 100;
        fMax = max(0, fMax);
        time_ms += 5;
    }
    noTone();
    pwmOff();

    // stop motor
    digitalWrite(MOTOR_PIN, LOW);
    digitalWrite(MOTOR_PIN, HIGH);
    digitalWrite(MOTOR_PIN, LOW);

    return;
}

int main (void) {
    setup();

    while (1) {
        loop();
    }
}
