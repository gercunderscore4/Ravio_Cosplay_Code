/****************************************************************
 * Interrupt-Based Audio on ATtiny85
 ****************************************************************/

#ifndef __INTERRUPTAUDIO_H__
#define __INTERRUPTAUDIO_H__

/* SET THESE VALUES */

#define AUDIO_PORT 1

/* LEAVE THE REST ALONE */

#include <avr/io.h>
#include <util/delay.h>

#define BIT_AO (1 << AUDIO_PORT)
#define DIVISORS_SIZE 12
#define TCCR1_BITS (1 << CTC1) | (1 << COM1A0)

const uint8_t DIVISORS[] = {239,  // C
                            225,  // C#
                            213,  // D
                            201,  // D#
                            190,  // E
                            179,  // F
                            169,  // F#
                            159,  // G
                            150,  // G#
                            142,  // A
                            134,  // A#
                            127}; // B

void init_audio (void);
void tone (uint8_t divindex, uint8_t octave, uint8_t duration);
void begin_tone (uint8_t divindex, uint8_t octave);
void end_tone(void);
void inc_whole (uint8_t* divindex, uint8_t* octave);
void inc_half (uint8_t* divindex, uint8_t* octave);
void play_quad (uint8_t divindex, uint8_t octave);
void item_song (void);

#endif // __INTERRUPTAUDIO_H__
