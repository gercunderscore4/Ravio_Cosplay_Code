/*
 * File: main.c
 *
 *      ATtiny84
 *  VCC -+-\/-+- GND
 *  PB0 -+    +- PA0
 *  PB1 -+    +- PA1
 *  PB3 -+    +- PA2
 *  PB2 -+    +- PA3
 *  PA7 -+    +- PA4
 *  PA6 -+----+- PA5
 *
 */

#include <avr/io.h>
#include <util/delay.h>
#include "APA102.h"

////////////////////////////////////////////////////////////////
// LIGHTS
////////////////////////////////////////////////////////////////

#define LED_COUNT 58
#define SHINE_COUNT 5
#define RANDER 1
#define LED_ON  0x20
#define LED_OFF 0x00

rgb_color get_white (void) {
    rgb_color c;
    c.red   = LED_ON;
    c.green = LED_ON;
    c.blue  = LED_ON;
    return c;
}

uint8_t rand_color = 0;

rgb_color get_color (void) {
    rgb_color c;
    if (rand_color == 0) {
        c.red   = LED_ON;
        c.green = LED_OFF;
        c.blue  = LED_OFF;
    } else if (rand_color == 5) {
        c.red   = LED_OFF;
        c.green = LED_ON;
        c.blue  = LED_OFF;
    } else if (rand_color == 9) {
        c.red   = LED_OFF;
        c.green = LED_OFF;
        c.blue  = LED_ON;
    } else {//if (rand_color == 9) {
        c.red   = LED_ON;
        c.green = LED_ON;
        c.blue  = LED_ON;
    }
    rand_color += 1;
    rand_color %= 13;
    return c;
}

uint8_t rand_ind = 0;

////////////////////////////////////////////////////////////////
// MAIN
////////////////////////////////////////////////////////////////

int main (void)
{
    //random_init(0xabcd); // initialize 16 bit seed
    APA102Init();
    
    rgb_color leds[LED_COUNT];
    for (uint8_t i = 0; i < LED_COUNT; i++) {
        leds[i] = get_white();
    }
    
    uint8_t indices[SHINE_COUNT];
    for (uint8_t i = 0; i < SHINE_COUNT; i++) {
        indices[i] = 0;
    }
    
    while (1) {
        for (uint8_t i = 0; i < LED_COUNT; i++) {
            //leds[i] = get_color();
            //APA102WriteColors(leds, LED_COUNT);
            //_delay_ms(300);
            
            //rand_ind += RANDER;
            //rand_ind %= LED_COUNT;
            //indices[i] = rand_ind;
            
            leds[i] = get_color();
        }
        APA102WriteColors(leds, LED_COUNT);
        _delay_ms(300);
    }
    
    return 1;
}
