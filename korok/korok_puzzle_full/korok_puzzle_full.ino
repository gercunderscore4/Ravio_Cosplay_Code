/*
 * Code for the Korok Puzzle blocks I designed.
 * 
 * The "metal" block is detected by arrays of magnets and reed switches.
 * 4 magnets are in diagonally opposite corners of the cube.
 * 4 reed switchs are in each corner of the square detector.
 * When any 2 diagonally opposite reed switches both detect magnets, a block is sensed.
 * The reed switch logic is done through wiring.
 * This is on REED_PIN.
 * 
 * There's a basic motor underneath that spins.
 * It has a reed switch and magnet to detect when it's reset.
 * But that's tricky because the motor can easily overshoot.
 * This is on TACH_PIN (because it's technically a tachometer).
 * 
 * All the music files play to completion while the device stays still.
 * This is both so that the sound is clearer.
 * And also because it give people a moment to react and realize something is happening.
 * 
 * Copying some sleep code from https://www.kevindarrah.com/download/arduino_code/LowPowerVideo.ino
 * 
 * https://www.arduino.cc/reference/cs/language/functions/external-interrupts/attachinterrupt/
 * digitalPinToInterrupt(pin)
 * Need to use digital pin 2 (3 is used for the spinning motor)
 *
 * TODO:
 *     - test power consumption with PIN set to output and ADC off
 *     - move reed wire to pin PD2 (previously ) and test that it still works
 *     - set up sleep on digital pin 2 (interrupt 0)
 *     - test power consumption using sleep
 *     - consider disabling brown-out detection 
 *       probably won't make a difference, I likely have other drains on power
 *     - test whole circuit
 *            __  __
 *      PD6  -| \/ |-  PC5
 *      PD0  -|    |-  PC4
 *      PD1  -|    |-  PC3
 *      PD2  -|    |-  PC2
 * spin PD3  -|    |-  PC1
 * reed PD4  -|    |-  PC0
 *      VCC  -|    |-  GND
 *      GND  -|    |-  AREF
 * xtal PB6  -|    |-  AVCC
 * xtal PB7  -|    |-  PB5  SCK
 * door PD5  -|    |-  PB4  DO
 * pole PD6  -|    |-  PB3  DI
 * tach PD7  -|    |-  PB2
 * CS   PD0  -|____|-  PB1  sound
 */

#include <SD.h>
#include <TMRpcm.h>
#include <Servo.h>
#include <SPI.h>

#define REED_PIN 4

#define SPIN_PIN 3

#define TACH_PIN 7

#define DOOR_PIN 5
#define DOOR_CLOSED 0
#define DOOR_OPEN 90

#define POLE_PIN 6
#define POLE_DOWN 0
#define POLE_UP 95

#define SPEAKER_PIN 9

#define SD_SCHIP_SELECT_PIN 8

Servo poleServo;
Servo doorServo;

int potpin = 0;
int val;

TMRpcm tmrpcm;

void digitalInterrupt(){
  // needed for the digital input interrupt
}

void senseBlock() {
  while (!digitalRead(REED_PIN));
  while (digitalRead(REED_PIN));
  //__asm__  __volatile__("sleep");//in line assembler to go to sleep
}

bool detectSpinner() {
  // detect if we're already back at the start
  if (!digitalRead(TACH_PIN)) {
    // basically just debouncing
    digitalWrite(SPIN_PIN, LOW);
    delay(100);
    if (!digitalRead(TACH_PIN)) {
      return true;
    }
  }
  return false;
}

void tryToResetSpinner(int pwm_level) {
  // seek original position
  if (detectSpinner()) return;
  // give it 300 x 10ms to try to reach the start point 
  analogWrite(SPIN_PIN, pwm_level);
  for (int i = 0; i < 300; i++) {
    if (!digitalRead(TACH_PIN)) {
      break;
    }
    delay(10);
  }
  digitalWrite(SPIN_PIN, LOW);
}

void resetSpinner() {
  tryToResetSpinner(128);
  tryToResetSpinner(96);
  tryToResetSpinner(64);
  tryToResetSpinner(32);
}

void spinBlock() {
  // spin up
  analogWrite(SPIN_PIN, 128);
  delay(250);
  // spin faster
  analogWrite(SPIN_PIN, 192);
  delay(500);
  // spin fastest
  digitalWrite(SPIN_PIN, HIGH);
  delay(2250);
  // slow down, try to seek original position
  tryToResetSpinner(128);
}

void liftBranch() {
  doorServo.attach(DOOR_PIN);
  poleServo.attach(POLE_PIN);

  doorServo.write(DOOR_OPEN);
  delay(1000);
  poleServo.write(POLE_UP);
  delay(1000);
  doorServo.write(DOOR_CLOSED);
  delay(1000);
  
  doorServo.detach();
  poleServo.detach();
}

void lowerBranch() {
  doorServo.attach(DOOR_PIN);
  poleServo.attach(POLE_PIN);

  doorServo.write(DOOR_OPEN);
  delay(1000);
  poleServo.write(POLE_DOWN);
  delay(1000);
  doorServo.write(DOOR_CLOSED);
  delay(1000);

  doorServo.detach();
  poleServo.detach();
}

void play_fanfare() {
  tmrpcm.play("fanfare.wav");
  while(tmrpcm.isPlaying());
}

void play_yahaha() {
  tmrpcm.play("yahaha.wav");
  while(tmrpcm.isPlaying());
}

void play_item() {
  tmrpcm.play("item.wav");
  while(tmrpcm.isPlaying());
}

void setup(){
  Serial.println("setup start");

  // disable ADC, save a few mA
  ADCSRA &= ~(1 << 7);

  // turn all pins to output, skip input pins
  // save a few more mA
  for (int pin = 0; pin < 20; pin++) {
    if (
      pin != REED_PIN && pin != TACH_PIN
    ) pinMode(pin, OUTPUT);
  } 

  pinMode(REED_PIN, INPUT_PULLUP);

  pinMode(TACH_PIN, INPUT_PULLUP);

  pinMode(SPIN_PIN, OUTPUT);
  digitalWrite(SPIN_PIN, LOW);

  doorServo.attach(DOOR_PIN);
  doorServo.write(DOOR_CLOSED);
  delay(500);
  doorServo.detach();

  poleServo.attach(POLE_PIN);
  poleServo.write(POLE_DOWN);
  delay(500);
  poleServo.detach();

  tmrpcm.speakerPin = SPEAKER_PIN;

  Serial.begin(9600);
  Serial.println("Serial started");  
  if (!SD.begin(SD_SCHIP_SELECT_PIN)) {
    Serial.println("SD fail");  
  }

  //attachInterrupt(0, digitalInterrupt, RISING); //interrupt for waking up

  //enable sleep
  //SMCR |= (1 << 2); //power down mode
  //SMCR |= 1;//enable sleep
}

void loop(){  
  senseBlock();
  play_fanfare();
  spinBlock();
  play_yahaha();
  liftBranch();
  delay(3000);
  play_item();
  lowerBranch();
  resetSpinner();
  delay(5000);
}
