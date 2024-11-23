/*
 * ATtiny84
 */

#ifndef __SERVO_H__
#define __SERVO_H__

#include <avr/io.h>
#include <util/delay.h>

#define PWM_PIN 7
#define CCW_MAX 9
#define CW_MAX 2
#define MID_POINT 5

void servo_init  (void);
void servo_write (uint8_t pwm);
void servo_off   (void);
void open_chest (void);

#endif // __SERVO_H__
