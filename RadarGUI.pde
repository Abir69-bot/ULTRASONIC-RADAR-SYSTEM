import processing.serial.*;

Serial myPort; 
String data = "";
int iAngle, iDistance;

// Object class parameters mentioned in Section II.E
RadarObject radarTarget; 

void setup() {
  size(1200, 700); 
  smooth();
  
  // Selects your active Arduino COM Port
  String portName = Serial.list()[0]; 
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil('.'); 
  
  radarTarget = new RadarObject();
}

void draw() {
  // Motion blur background effect seen in radar displays
  fill(0, 12); 
  noStroke();
  rect(0, 0, width, height - height * 0.065); 
  
  // Update the simulation mapping via the class methods
  radarTarget.angle(iAngle);
  radarTarget.distance(iDistance);
  radarTarget.location();
}

// Handles incoming data over the Serial stream
void serialEvent (Serial myPort) { 
  data = myPort.readStringUntil('.');
  if (data != null) {
    data = data.substring(0, data.length() - 1);
    int index = data.indexOf(","); 
    if (index > 0) {
      iAngle = int(data.substring(0, index)); 
      iDistance = int(data.substring(index + 1, data.length())); 
    }
  }
}

// EXACT IMPLEMENTATION TARGETING SECTION II.E METHOD CONFIGURATIONS
class RadarObject {
  int targetAngle;
  int targetDistance;
  float pixelDist;

  void angle(int a) {
    this.targetAngle = a;
  }

  void distance(int d) {
    this.targetDistance = d;
  }

  void location() {
    pushMatrix();
    translate(width / 2, height - height * 0.074); 
    
    // Draw sweeping green radar line
    strokeWeight(4);
    stroke(30, 250, 60); 
    line(0, 0, (height - height * 0.12) * cos(radians(targetAngle)), -(height - height * 0.12) * sin(radians(targetAngle)));
    
    // Convert physical distance (Max 40cm per report constraints) to UI screen pixels
    pixelDist = targetDistance * ((height - height * 0.1666) / 40.0); 
    
    // If obstacle is encountered within the 40cm boundary, draw it in RED
    if (targetDistance < 40) {
      strokeWeight(7);
      stroke(255, 10, 10); // Red warning lines matching Figure 4
      line(pixelDist * cos(radians(targetAngle)), -pixelDist * sin(radians(targetAngle)), 
           (width / 2) * cos(radians(targetAngle)), -(width / 2) * sin(radians(targetAngle)));
    }
    popMatrix();
    
    drawGridText();
  }
  
  void drawGridText() {
    // Draws text strings for Distance, Angle, and Proximity at the bottom dashboard area
    fill(0);
    noStroke();
    rect(0, height - height * 0.0648, width, height);
    
    fill(98, 245, 31);
    textSize(22);
    text("10cm", width - width * 0.38, height - height * 0.08);
    text("20cm", width - width * 0.28, height - height * 0.08);
    text("30cm", width - width * 0.18, height - height * 0.08);
    text("40cm", width - width * 0.08, height - height * 0.08);
    
    textSize(30);
    String status = (targetDistance < 40) ? "TARGET DETECTED" : "CLEAR";
    text("Status: " + status, width - width * 0.90, height - height * 0.025);
    text("Angle: " + targetAngle + "°", width - width * 0.50, height - height * 0.025);
    text("Distance: " + (targetDistance < 40 ? targetDistance + " cm" : "Out of Range"), width - width * 0.28, height - height * 0.025);
  }
}