/*
 * write some Arduino-like functions to make conversion easier
 * 
 * DDRA  - Port A Data Direction Register
 * 0 = INPUT, 1 = OUTPUT
 *
 * PORTA - Port A Data Register
 * INPUT: 1 = PULL-UP
 *
 * PINA  - Port A Input Pins Address
 * 1 = HIGH, 0 = LOW * 
 */

#include "ArduinoLike.h"

void pinMode (uint8_t pin, uint8_t value) {
    if (value) {
        DDRA |=  (1 << pin);
    } else {
        DDRA &= ~(1 << pin);
    }
}

void digitalWrite (uint8_t pin, uint8_t value) {
    if (value) {
        PINA |=  (1 << pin);
    } else {
        PINA &= ~(1 << pin);
    }
}

/*
  Part of the Wiring project - http://wiring.org.co
  Copyright (c) 2004-06 Hernando Barragan
  Modified 13 August 2006, David A. Mellis for Arduino - http://www.arduino.cc/

  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General
  Public License along with this library; if not, write to the
  Free Software Foundation, Inc., 59 Temple Place, Suite 330,
  Boston, MA  02111-1307  USA

  $Id$
*/

// https://lemire.me/blog/2019/07/03/a-fast-16-bit-random-number-generator/
uint32_t hash16(uint32_t input, uint32_t key) {
  uint32_t hash = input * key;
  return ((hash >> 16) ^ hash) & 0xFFFF;
}
uint16_t wyhash16() {
  wyhash16_x += 0xfc15;
  return hash16(wyhash16_x, 0x2ab);
}

uint16_t randomWMax (uint16_t howbig) {
  if (howbig == 0) {
    return 0;
  }
  return random() % howbig;
}

uint16_t randomWMinMax (uint16_t howsmall, uint16_t howbig) {
  if (howsmall >= howbig) {
      return howsmall;
  }
  uint16_t diff = howbig - howsmall;
  return randomWMax(diff) + howsmall;
}

void delay (uint16_t duration_ms) {
    // ignoring cycles needed for loop
    // at 1MHz, should be close enough
    for (uint16_t i = 0; i < duration_ms; i++) {
        _delay_ms(1);
    }
}

uint16_t max (uint16_t a, uint16_t b) {
    return (a > b) ? a : b;
}