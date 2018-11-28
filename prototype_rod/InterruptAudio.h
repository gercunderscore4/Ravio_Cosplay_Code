/****************************************************************
 * Interrupt-Based Audio on ATtiny85
 ****************************************************************/

#ifndef __INTERRUPTAUDIO_H__
#define __INTERRUPTAUDIO_H__

/* SET THESE VALUES */

#define AUDIO_PORT 3

/* LEAVE THE REST ALONE */

#include <avr/io.h>

#define BIT_AO (1 << AUDIO_PORT)

void enableSound (void);
void disableSound (void);

void setFrequency (uint16_t freq);
void setWavData (uint8_t* data, uint16_t count);

#endif // __INTERRUPTAUDIO_H__
