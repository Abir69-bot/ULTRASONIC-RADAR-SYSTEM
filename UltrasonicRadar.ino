#include <Servo.h>


const int trigPin = 8;    // Connected to D8
const int echoPin = 7;    // Connected to D7
const int servoPin = 6;    // Connected to D6

long duration;
int distance;
Servo myServo; 

void setup() {
  pinMode(trigPin, OUTPUT); 
  pinMode(echoPin, INPUT); 
  Serial.begin(9600);
  myServo.attach(servoPin); 
}

void loop() {
  // Sweeping from 15 to 165 degrees (standard radar sweep sweep)
  for(int i = 15; i <= 165; i++) {  
    myServo.write(i);
    delay(30);
    distance = calculateDistance();
    
    // Output format parsed by Processing
    Serial.print(i);
    Serial.print(",");
    Serial.print(distance);
    Serial.print(".");
  }
  
  // Sweeping back
  for(int i = 165; i > 15; i--) {  
    myServo.write(i);
    delay(30);
    distance = calculateDistance();
    
    Serial.print(i);
    Serial.print(",");
    Serial.print(distance);
    Serial.print(".");
  }
}

int calculateDistance() { 
  digitalWrite(trigPin, LOW); 
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH); 
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  
  duration = pulseIn(echoPin, HIGH);
  // Distance calculation based on speed of sound
  int calculatedDist = duration * 0.034 / 2;
  
  // Report Constraint: HC-SR04 range is 2 to 40 cm
  if (calculatedDist < 2 || calculatedDist > 40) {
    return 40; // Treat as out of range
  }
  return calculatedDist;
}