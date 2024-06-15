/*
 * ATtiny84
 */

#ifndef __SERVO_H__
#define __SERVO_H__

#include <avr/io.h>

#define PWM_PIN 7
#define CCW_MAX 9
#define CW_MAX 2

void servo_init  (void);
void servo_write (uint8_t pwm);
void servo_off   (void);

#endif // __SERVO_H__
