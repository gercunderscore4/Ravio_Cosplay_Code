// I2C Digital Potentiometer
// by Nicholas Zambetti <http://www.zambetti.com>
// and Shawn Bonkowski <http://people.interaction-ivrea.it/s.bonkowski/>

// Demonstrates use of the Wire library
// Controls AD5171 digital potentiometer via I2C/TWI

// Created 31 March 2006

// This example code is in the public domain.


#include <Wire.h>

// A4 => SDA
// A5 => SCL
#define INPUT_PIN 12
#define OUTPUT_PIN 13

#define ACCEL_ADDR 0x53

#define DEVID_ADDR 0x00
#define DEVID_VALUE 0xE5

// threshold
#define THRESH_TAP_ADDR 0x1D
#define THRESH_TAP_VALUE 0x40 // 62.5mg (milli-g's), 0x20 => 32 => 2g

// duration
#define DUR_ADDR 0x21
#define DUR_VALUE 0x30 // 625us scale factor, 0x30 = 30ms

#define TAP_AXES_ADDR 0x2A
#define TAP_AXES_VALUE 0x07 // x,y,z for tap

#define ACT_TAP_AXES_ADDR 0x2B
#define ACT_TAP_AXES_VALUE 0x07 // x,y,z for tap

#define BW_RATE_ADDR 0x2C
#define BW_RATE_VALUE 0x18 // 0x10 => low power, 0x08 => 12.5 Hz

#define PWR_CTL_ADDR 0x2D
#define PWR_CTL_VALUE 0x09 // 0x80 => measure don't standby, 0x01 => in sleep mode read at 4Hz

// enable this last
#define INT_ENABLE_ADDR 0x2E
#define INT_ENABLE_VALUE 0x40 // only tap

#define INT_MAP_ADDR 0x2F
#define INT_MAP_VALUE 0x00 // map all to INT1

#define INT_SOURCE_ADDR 0x30

void writeByte(byte device_address, byte register_address, byte input_byte)
{
  Wire.beginTransmission(device_address);
  Wire.write(register_address);
  Wire.write(input_byte);
  Wire.endTransmission();
}

void readByte(int device_address, int register_address, byte *output_byte)
{
  Wire.beginTransmission(device_address);
  Wire.write(register_address);
  Wire.endTransmission();
  Wire.requestFrom(device_address, 1);
  *output_byte = Wire.read();
}

void writeByteAndVerify(byte device_address, byte register_address, byte input_byte)
{
  Serial.println("================================================================");
  
  Serial.print("Device addr: ");
  Serial.print(device_address, HEX);
  Serial.println();
  
  Serial.print("Register addr: ");
  Serial.print(register_address, HEX);
  Serial.println();
  
  Serial.print("Input: ");
  Serial.print(input_byte, HEX);
  Serial.println();
  
  writeByte(device_address, register_address, input_byte);
  byte output_byte;
  readByte(device_address, register_address, &output_byte);

  Serial.print("Output: ");
  Serial.print(output_byte, HEX);
  Serial.println();
}

void setup() {
  Serial.begin(9600);
  Serial.println("Hello.");

  Wire.begin(); // join I2C bus (address optional for master)

  pinMode(INPUT_PIN, INPUT);
  pinMode(OUTPUT_PIN, OUTPUT);
  digitalWrite(OUTPUT_PIN, HIGH);
  delay(500);
  digitalWrite(OUTPUT_PIN, LOW);

  writeByteAndVerify(ACCEL_ADDR, THRESH_TAP_ADDR, THRESH_TAP_VALUE);
  writeByteAndVerify(ACCEL_ADDR, DUR_ADDR, DUR_VALUE);
  writeByteAndVerify(ACCEL_ADDR, TAP_AXES_ADDR, TAP_AXES_VALUE);
  writeByteAndVerify(ACCEL_ADDR, ACT_TAP_AXES_ADDR, ACT_TAP_AXES_VALUE);
  writeByteAndVerify(ACCEL_ADDR, PWR_CTL_ADDR, PWR_CTL_VALUE);
  writeByteAndVerify(ACCEL_ADDR, INT_MAP_ADDR, INT_MAP_VALUE);
  writeByteAndVerify(ACCEL_ADDR, INT_ENABLE_ADDR, INT_ENABLE_VALUE);

}

void loop() {
  byte output_byte;
  readByte(ACCEL_ADDR, INT_SOURCE_ADDR, &output_byte);

  while (!digitalRead(INPUT_PIN));

  digitalWrite(OUTPUT_PIN, HIGH);
  delay(500);
  digitalWrite(OUTPUT_PIN, LOW);
}
