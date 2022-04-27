/****************************************************************
 * Interrupt-Based Audio on ATtiny85
 * Based on: http://www.technoblogy.com/show?KVO
 ****************************************************************/

#ifndef __INTERRUPTAUDIO_H__
#define __INTERRUPTAUDIO_H__

#include <avr/io.h>
#include <util/delay.h>

#define AUDIO_PIN 6

void init_audio (void);
void rest (uint16_t duration_ms);
void tone (uint16_t freq, uint16_t duration_ms);
void changeTone (uint16_t freq);
void toneOn (uint16_t freq);
void noTone (void);
void wait (uint16_t duration_ms);

#endif // __INTERRUPTAUDIO_H__
