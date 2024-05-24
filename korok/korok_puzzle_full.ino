#include <SD.h>
#include <TMRpcm.h>
#include <Servo.h>
#include <SPI.h>

#define REED_PIN 4

#define SPIN_PIN 3

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

void sense() {
  while (!digitalRead(REED_PIN));
  while (digitalRead(REED_PIN));
}

void spin() {
  digitalWrite(SPIN_PIN, HIGH);
  delay(3000);
  digitalWrite(SPIN_PIN, LOW);
  return;
  for (int pulseWidth = 0; pulseWidth < 256; pulseWidth++) {
    analogWrite(SPIN_PIN, pulseWidth);
    delay(8); // 2s / 256 = 2s / 250 = 2 * 4ms
  }
  for (int pulseWidth = 255; pulseWidth >= 0; pulseWidth--) {
    analogWrite(SPIN_PIN, pulseWidth);
    delay(8); // 2s / 256 = 2s / 250 = 2 * 4ms
  }
  digitalWrite(SPIN_PIN, LOW);
}

void lift() {
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

void lower() {
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

  pinMode(REED_PIN, INPUT_PULLUP);
  
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
}

void loop(){  
  sense();
  play_fanfare();
  spin();
  play_yahaha();
  lift();
  delay(3000);
  play_item();
  lower();
  delay(10000);
}
