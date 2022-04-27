/*
 * ATtiny84 analog input
 * Section 16
 * 
 * ADMUX
 * +-------+-------+------+------+------+------+------+------+
 * | REFS1 | REFS0 | MUX5 | MUX4 | MUX3 | MUX2 | MUX1 | MUX0 |
 * +-------+-------+------+------+------+------+------+------+
 * 
 * REFS1:0, select reference voltage for ADC
 * 0b00 = use VCC
 * 
 * MUX5:0, analog channel and gain selection
 * 0b00000 to 0b00111 represent PA0 to PA7
 * 
 * ADCSRA
 * +------+------+-------+------+------+-------+-------+-------+
 * | ADEN | ADSC | ADATE | ADIF | ADIE | ADPS2 | ADPS1 | ADPS0 |
 * +------+------+-------+------+------+-------+-------+-------+
 * 
 * ADEN, enable ADC
 * 
 * ADSC, start conversion
 * set to one to start read
 * 
 * I don't care about the rest.
 * 
 * ADCSRB
 * +-----+------+-----+-------+-----+-------+-------+-------+
 * | BIN | ACME |  –  | ADLAR |  –  | ADTS2 | ADTS1 | ADTS0 |
 * +-----+------+-----+-------+-----+-------+-------+-------+
 * 
 * (skipping this, don't need these)
 * 
 * DIDR0, Digital Input Disable Register 0
 * +-------+-------+-------+-------+-------+-------+-------+-------+
 * | ADC7D | ADC6D | ADC5D | ADC4D | ADC3D | ADC2D | ADC1D | ADC0D |
 * +-------+-------+-------+-------+-------+-------+-------+-------+
 * ADCxD, Digital Input Disable
 * 
 * Single ended conversion:
 *     ADC = V_IN * 1024 / V_REF
 *     0x000 = GND
 *     0x3FF = V_REF
 */

#include "AnalogInput.h"

void analogInit (void) {
    // input
    DDRA  &= ~(1 << ANALOG_PIN);
    // no pull-up
    PORTA &= ~(1 << ANALOG_PIN);
    // disable digial input
    DIDR0 |=  (1 << ANALOG_PIN); 

    // initialize the ADC
    ADCSRA |= (1 << ADEN);
}

uint16_t analogRead (void) {
    //select the channel and reference
    ADMUX = (0 << REFS0) | (ANALOG_PIN << MUX0); 
    
    // start conversion
    ADCSRA |= (1 << ADSC);
    
    // wait for conversion to complete.
    while(ADCSRA & (1 << ADSC));
    
    uint8_t low = ADCL;
    uint8_t high = ADCH;
    return (high << 8) | low;
}

