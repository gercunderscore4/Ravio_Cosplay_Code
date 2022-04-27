/*
 * ATtiny84 analog input
 * Section 11
 */

#ifndef __PWM_H__
#define __PWM_H__

#include <avr/io.h>

#define PWM_PIN 7

void pwmInit  (void);
void pwmWrite (uint8_t pwm);
void pwmOff   (void);

#endif // __PWM_H__
