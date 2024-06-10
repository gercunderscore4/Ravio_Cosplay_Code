/*
 * File: main.c
 * Purpose: LoZ treasure chest using ATtiny85
 * Notes:
 *     - uc: ATtiny85
 * Todo:
 *
 *     ATtiny85
 * PB5 -+----+- VCC
 * PB3 -+O   +- PB2/SCL
 * PB4 -+    +- PB1/OC0B/OC1A
 * GND -+----+- PB0/SDA
 *
 * PB0 : SDA (accel)
 * PB1 : PWM (servo)
 * PB2 : SCL (accel)
 * PB3 : NC
 * PB4 : NC
 * PB5 : button (reset with 10k pull-up)
 *
 * BTN -+----+- VCC
 * NC  -+O   +- SW3
 * NC  -+    +- PWM
 * GND -+----+- SW2
 */

#include <avr/io.h>
#include <util/delay.h>


////////////////////////////////////////////////////////////////
// SWITCHES
////////////////////////////////////////////////////////////////

void init_switches (void) {
    DDRB  &=  ~( (1 << DDB0) | (1 << DDB2) ); // inputs
    PORTB |=  (1 << PORTB0) | (1 << PORTB2); // pull-up
}

uint8_t get_sw2 (void) {
    return !(PINB & ( 1 << PINB0));
}

uint8_t get_sw3 (void) {
    return !(PINB & (1 << PINB2));
}

////////////////////////////////////////////////////////////////
// MAIN
////////////////////////////////////////////////////////////////

int main (void)
{
    init_switches();
    init_sparkle();
    init_audio();

    uint8_t divindex = 4;
    uint8_t octave   = 4;
    play_section_0(&divindex, &octave);

    uint8_t played_1 = 0;
    uint8_t played_2 = 0;
    uint8_t played_4 = 0;
    while (!played_4) {
        if (get_sw3()) {
            if (played_2 || played_1) {
                play_section_3(&divindex, &octave);
                play_section_4(&divindex, &octave);
            } else {
                play_section_5(&divindex, &octave);
            }
            played_4 = 1;
        } else if (get_sw2() || played_2){
            play_section_2(&divindex, &octave);
            played_2 = 1;
        } else {
            play_section_1(&divindex, &octave);
            played_1 = 1;
        }
    }
    while (1);

    return 1;
}
