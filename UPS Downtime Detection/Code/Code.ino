#define BLYNK_TEMPLATE_ID "TMPL3XFq_OzvO"
#define BLYNK_TEMPLATE_NAME "Test"
#define BLYNK_AUTH_TOKEN "Xxh0o8qSBTpMubG_686rCpaMc7fM7K2B"

#include <SPI.h>
#include <WiFiNINA.h>
#include <BlynkSimpleWiFiNINA.h>
#include <EEPROM.h>
#include <string.h>

char auth[] = BLYNK_AUTH_TOKEN;
char ssid[] = "JioFi3_1E61F1";
char pass[] = "h43dyas71e";

#define MAX_CONNECTION_ATTEMPTS 10
#define CONNECTION_RETRY_DELAY 2000
#define NUM_SAMPLES 1000
#define THRESHOLD 1

int inputPin1 = A0;
int outputPin1 = A5;
int flag = 0;
int inputPin2 = A1; 
int outputPin2 = A3;
float inputCurrent1 = 0;
float outputCurrent1 = 0;
float inputCurrent2 = 0;
float outputCurrent2 = 0;
unsigned long lastUpdateTime = 0;
unsigned long lastIncidentTime = 0;
int totalIncidents = 0;
bool currentlyInDowntime = false;
char downtimeReason[100] = "";

void setup() {
  Serial.begin(9600);
  pinMode(inputPin1, INPUT);
  pinMode(outputPin1, INPUT);
  pinMode(inputPin2, INPUT);
  pinMode(outputPin2, INPUT);
  totalIncidents = EEPROM.read(0);
  lastIncidentTime = millis();
}

void loop() {
  Blynk.run(); // This should be called as often as possible to handle communication

  inputCurrent1 = readRMS(inputPin1)/77.8*3.4;
  outputCurrent1 = readRMS(outputPin1)/77.8;
  inputCurrent2 = readRMS(inputPin2)/77.8*57;
  outputCurrent2 = readRMS(outputPin2)/77.8*44.5; 
  
  checkCurrentStatus();

  // Print current readings for debugging
  Serial.print("Input (1) Current RMS: ");
  Serial.println(inputCurrent1);
  Serial.print("Output (1) Current RMS: ");
  Serial.println(outputCurrent1);
  Serial.print("Input (2) Current RMS: ");
  Serial.println(inputCurrent2);
  Serial.print("Output (2) Current RMS: ");
  Serial.println(outputCurrent2);
  Serial.println("Total incidents");
  Serial.println(totalIncidents);

  if (millis() - lastUpdateTime > 10000) {  // try to log to Blynk every 10 seconds

    if (WiFi.status() != WL_CONNECTED) {
    setupWiFi();

  }
    if(currentlyInDowntime)
    {
      if(flag==0)
      {
    // Log event to Blynk Dashboard
    Blynk.logEvent("downtime_detected", String("Time Since Last Downtime: " + String(millis() - lastIncidentTime) + "ms, Reason: " + downtimeReason));
    flag = 1;
    }
    }

    lastUpdateTime = millis();
  }
  
  // Update virtual pins with the latest values
  Blynk.virtualWrite(V1, inputCurrent1);
  Blynk.virtualWrite(V2, outputCurrent1);
  Blynk.virtualWrite(V3, inputCurrent2);
  Blynk.virtualWrite(V4, outputCurrent2);
  Blynk.virtualWrite(V5, totalIncidents);
}

float readRMS(int pin) {
  float sumOfSquares = 0.0;
  for (int i = 0; i < NUM_SAMPLES; i++) {
    float reading = analogRead(pin);
    sumOfSquares += reading * reading;
  }
  return sqrt(sumOfSquares / NUM_SAMPLES);
}

void checkCurrentStatus() {
  bool previousState = currentlyInDowntime;
  if ((inputCurrent1 < THRESHOLD || outputCurrent1 < THRESHOLD) || (inputCurrent2 < THRESHOLD || outputCurrent2 < THRESHOLD)) {
    currentlyInDowntime = true;
    // Serial.println("Outside loop 1");
    if (!previousState) {
      strcpy(downtimeReason,"Power Failure");
      lastIncidentTime = millis();
    }
  } else if ((inputCurrent1 >= THRESHOLD && outputCurrent1 < THRESHOLD) || (inputCurrent2 >= THRESHOLD && outputCurrent2 < THRESHOLD)) {
    currentlyInDowntime = true;
    if (!previousState) {
      strcpy(downtimeReason,"MCB Tripped");
      lastIncidentTime = millis();
    }
  } else {
    if (currentlyInDowntime) {
      currentlyInDowntime = false;
      Serial.println(currentlyInDowntime);
      totalIncidents++;
      flag = 0;
      EEPROM.write(0, totalIncidents);
    }
  }
}

void setupWiFi() {

  WiFi.end();
  delay(1000);

  if (WiFi.status() == WL_NO_MODULE) {
    Serial.println("Communication with WiFi module failed!");
    while (true);
  }
  // WiFi.beginEnterprise(ssid, user, pass);
    WiFi.begin(ssid, pass);

  if (WiFi.status() == WL_CONNECTED) {
    Serial.println("WiFi connected");
    Blynk.begin(auth, ssid, pass);
  } else {
    Serial.println("Connection failed");
  }
}