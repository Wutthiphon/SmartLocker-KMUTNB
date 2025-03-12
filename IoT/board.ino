#include <Wire.h>
#include <ESP8266WiFi.h>
#include <ArduinoJson.h>
#include <PubSubClient.h>
#include <WiFiClientSecure.h>
#include <LiquidCrystal_I2C.h>
#include <ESP8266HTTPClient.h>

#define PCF8574_KEYPAD  0x20
#define PCF8574_LCD     0x27

LiquidCrystal_I2C lcd(PCF8574_LCD, 16, 2);

const char keys[4][3] = {
  {'1', '2', '3'},
  {'4', '5', '6'},
  {'7', '8', '9'},
  {'*', '0', '#'}
};

const char* ssid = "";
const char* pass = "";

const char *mqtt_broker = "mqtt.netpie.io";
const char *mqtt_client = "32a25e63-9a98-42fb-97cd-71b44deb425b";
const char *mqtt_username = "mkQoo85MdVoFQzqZtFY4L81cFdQv2EWB";
const char *mqtt_password = "EaiywoVTMx36v5oy1LTLak1CXFjrukzm";
const int mqtt_port = 1884;

WiFiClientSecure espClient;
HTTPClient http;
PubSubClient client(espClient);

struct Locker {
  String id;
  int door;
  int light;
  int reed;
};

String enteredID = "";
String enteredPass = "";
bool enteringID = true;
bool resetFlag = false;
String passMask = "";

Locker lockers[11];


void setup() {
  Serial.begin(9600);
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, pass);
  reconnectWiFi();

  espClient.setInsecure();
  
  client.setServer(mqtt_broker, mqtt_port);
  client.setCallback(callback);
  reconnectMQTT();

  for(int i = 0; i < 11; i++){
    if (i < 10) {
      lockers[i].id = "0" + String(i);
    } else {
      lockers[i].id = String(i);
    }
  }

  lockers[1].id = "01";
  lockers[1].door = 13;
  lockers[1].reed = 14;
  lockers[1].light = 16;
  
  lockers[4].id = "04";
  lockers[4].door = 15;
  lockers[4].reed = 12;
  lockers[4].light = 2;

  pinMode(lockers[1].reed, INPUT_PULLUP);
  pinMode(lockers[1].light, OUTPUT);
  pinMode(lockers[1].door, OUTPUT);
  
  pinMode(lockers[4].reed, INPUT_PULLUP);
  pinMode(lockers[4].light, OUTPUT);
  pinMode(lockers[4].door, OUTPUT);

  digitalWrite(lockers[1].door, HIGH);
  digitalWrite(lockers[4].door, HIGH);
  
  lcd.init();
  lcd.backlight();
  lcd.setCursor(0, 0);
  lcd.print("Locker ");
  
  Wire.beginTransmission(PCF8574_KEYPAD);
  Wire.write(0xFF);
  Wire.endTransmission();
}

void loop() {
  if (WiFi.status() != WL_CONNECTED) {
        reconnectWiFi();
    }
  
  if (!client.connected()) {
      reconnectMQTT();
  }

   client.loop();

   char key = scanKeypad();

  if(digitalRead(lockers[1].reed) == HIGH) {
    digitalWrite(lockers[1].light, HIGH);
  } else {
    digitalWrite(lockers[1].light, LOW);
  }

  if(digitalRead(lockers[4].reed) == HIGH) {
    digitalWrite(lockers[4].light, HIGH);
  } else {
    digitalWrite(lockers[4].light, LOW);
  }

  if (key == '#') {
    if (!resetFlag) {
      resetInput();
      resetFlag = true;
    }
  }

  if (key && key != '#') {
    resetFlag = false;
    if (enteringID) {
      enteredID += key;
      if (enteredID.length() == 2) {
        enteringID = false;
        lcd.setCursor(7, 0);
        lcd.print(enteredID);
        lcd.setCursor(0, 1);
        lcd.print("Password ");
      }
    } else {
      enteredPass += key;
      passMask += "*";
      if (enteredPass.length() == 6) {
        checkPassword();
      }
    }

    if (enteringID) {
      lcd.setCursor(7, 0);
      lcd.print(enteredID);
    } else {
      lcd.setCursor(9, 1);
      lcd.print(passMask);
    }
  }
   
  delay(500);
}

void reconnectWiFi() {
    Serial.print("Connecting to WiFi");
    while (WiFi.status() != WL_CONNECTED) {
        delay(500);
        Serial.print(".");
    }
    Serial.println("Connected successful");
}

void callback(char* topic, byte* payload, unsigned int length) {
    Serial.print("Message received on topic: ");
    Serial.println(topic);
    StaticJsonDocument<256> doc;
  
    DeserializationError error = deserializeJson(doc, payload, length);
  
    if (error) {
      Serial.print("JSON parsing failed: ");
      Serial.println(error.c_str());
      return;
    }
  
    int index = doc["index"];
    int unlock = doc["unlock"];

    openDoor(index, unlock);
}

void reconnectMQTT() {
    Serial.print("Connecting to MQTT");
    while (!client.connected()) {
        if (client.connect(mqtt_client, mqtt_username, mqtt_password)) {
            Serial.println("Connected to the MQTT");
            if (client.subscribe("@msg/locker/unlock")) {
                Serial.println("Successfully subscribed to @msg/locker/unlock topic.");
            } else {
                Serial.println("Failed to subscribe to @msg/locker/unlock topic.");
            }
        } else {
            Serial.print(".");
            delay(5000);
        }
    }
}

void openDoor(int index, int state) {
  if(state) {
    digitalWrite(lockers[index].door, LOW);
    digitalWrite(lockers[index].light, HIGH);
    delay(5000);
    digitalWrite(lockers[index].door, HIGH);
    digitalWrite(lockers[index].light, LOW);
  }

}

void checkPassword() {
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("loading..");

  bool found = false;

  for (int i = 0; i < sizeof(lockers) / sizeof(lockers[0]); i++) {
    if (lockers[i].id == enteredID && !found) {
      found = true;
      
      String baseUrl = "https://demos.wutthiphon.space/lab/ubuntu/serv/101/api/locker/unlock-locker-board/";
      String url = baseUrl + "*" + String(i) + "*" + enteredPass;
      espClient.stop();
      
      http.begin(espClient, url);
      http.setTimeout(3000);
      int httpCode = http.GET();
      
      if (httpCode > 0) {
        String response = http.getString();
        StaticJsonDocument<200> doc;
        DeserializationError error = deserializeJson(doc, response);

        if (error) {
          Serial.print("JSON parsing failed: ");
          Serial.println(error.c_str());
          return;
        }

        String message = doc["message"];

        if (message == "password are wrong") {
          lcd.clear();
          lcd.setCursor(0, 0);
          lcd.print("Locker " + lockers[i].id);
          lcd.setCursor(0, 1);
          lcd.print("Incorrect");
          delay(5000);
        }

        if (message == "unlock complete") {
          lcd.clear();
          lcd.setCursor(0, 0);
          lcd.print("Locker " + lockers[i].id);
          lcd.setCursor(0, 1);
          lcd.print("Opened");
          openDoor(i, true);
        }

        String notReserve = "locker number " + String(i) + " not reserve";
        if (message == notReserve) {
          lcd.clear();
          lcd.setCursor(0, 0);
          lcd.print("Locker " + lockers[i].id);
          lcd.setCursor(0, 1);
          lcd.print("Not reserved");
          delay(5000);
        }
        
      } else {
          Serial.println("Request failed: " + String(httpCode) + " -> " + http.errorToString(httpCode).c_str());
      }
  
      http.end();
      resetInput();
      return;
    }
  }

  if (!found) {
    lcd.print("Locker Not Found");
    Serial.println("Locker Not Found");
    delay(5000);
  }

  resetInput();  
}


char scanKeypad() {
  for (int row = 0; row < 4; row++) {
    byte rowMask = ~(1 << row);
    Wire.beginTransmission(PCF8574_KEYPAD);
    Wire.write(rowMask | 0xF0);
    Wire.endTransmission();

    delayMicroseconds(500);
    Wire.requestFrom(PCF8574_KEYPAD, 1);

    if (Wire.available()) {
      byte colData = Wire.read() & 0x70;

      if (colData != 0x70) {
        for (int col = 0; col < 3; col++) {
          if (!(colData & (1 << (col + 4)))) {
            return keys[row][col];
          }
        }
      }
    }
  }
  return '\0';
}

void resetInput() {
  enteredID = "";
  enteredPass = "";
  passMask = "";
  enteringID = true;
  lcd.clear();
  delay(500);
  lcd.setCursor(0, 0);
  lcd.print("Locker ");
}
