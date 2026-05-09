#include <ESP8266WiFi.h>
#include <Firebase_ESP_Client.h>
#include <DHT.h>
#include <PubSubClient.h>

// ===== WiFi =====
#define WIFI_SSID "Men3em Ibn 3del"
#define WIFI_PASSWORD "#12345678"

// ===== Firebase =====
#define DATABASE_URL "iot-1e0ae-default-rtdb.europe-west1.firebasedatabase.app"
#define DATABASE_SECRET "6eNCulmfVgGWEFjXyaeXIqnVn3pJt0ajqlLBrqtF"

// ===== MQTT =====
const char* mqtt_server = "192.168.43.210";

// ===== DHT =====
#define DHTPIN D2
#define DHTTYPE DHT11
DHT dht(DHTPIN, DHTTYPE);

// ===== PINS =====
#define IR_A D5
#define IR_B D6
#define LED_PIN D1

// ===== Firebase =====
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

// ===== MQTT =====
WiFiClient espClient;
PubSubClient client(espClient);

// ===== VARIABLES =====
int students = 0;
int lastStudents = -1;

int state = 0;
unsigned long stateTime = 0;

// ===== MODES =====
bool autoMode = true;
bool manualLightState = false;

/* =========================
        LOG SYSTEM
   ========================= */
void logInfo(String msg) {
  Serial.println("ℹ️ " + msg);
}

void logSuccess(String msg) {
  Serial.println("✅ " + msg);
}

void logError(String msg) {
  Serial.println("❌ " + msg);
}

void logEvent(String msg) {
  Serial.println("➡️ " + msg);
}

void logMQTT(String msg) {
  Serial.println("📩 " + msg);
}

/* =========================
        WIFI
   ========================= */
void connectWiFi() {

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);

  Serial.print("Connecting WiFi");

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  logSuccess("WiFi Connected");
  logInfo("IP: " + WiFi.localIP().toString());
}

/* =========================
        FIREBASE
   ========================= */
void initFirebase() {

  config.database_url = DATABASE_URL;
  config.signer.tokens.legacy_token = DATABASE_SECRET;

  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);

  logSuccess("Firebase Ready");
}

/* =========================
        MQTT CALLBACK
   ========================= */
void callback(char* topic, byte* payload, unsigned int length) {

  String message = "";

  for (int i = 0; i < length; i++) {
    message += (char)payload[i];
  }

  logMQTT(String(topic) + " | " + message);

  // ===== MODE =====
  if (String(topic) == "smartclassroom/mode") {

    if (message == "AUTO") {
      autoMode = true;
      logEvent("AUTO MODE ENABLED");
    }

    else if (message == "MANUAL") {
      autoMode = false;
      logEvent("MANUAL MODE ENABLED");
    }
  }

  // ===== LIGHT CONTROL =====
  if (String(topic) == "smartclassroom/light") {

    if (!autoMode) {

      if (message == "ON") {
        manualLightState = true;
        logEvent("MANUAL LED ON");
      }

      else if (message == "OFF") {
        manualLightState = false;
        logEvent("MANUAL LED OFF");
      }
    }
  }
}

/* =========================
        MQTT CONNECT
   ========================= */
void reconnectMQTT() {

  while (!client.connected()) {

    Serial.print("Connecting MQTT...");

    String clientId = "ESP8266Client-";
    clientId += String(random(0xffff), HEX);

    if (client.connect(clientId.c_str())) {

      logSuccess("MQTT Connected");

      client.subscribe("smartclassroom/light");
      client.subscribe("smartclassroom/mode");

    } else {

      logError("MQTT Failed rc=" + String(client.state()));
      delay(2000);
    }
  }
}

/* =========================
            SETUP
   ========================= */
void setup() {

  Serial.begin(115200);

  pinMode(IR_A, INPUT);
  pinMode(IR_B, INPUT);
  pinMode(LED_PIN, OUTPUT);

  digitalWrite(LED_PIN, LOW);

  dht.begin();

  connectWiFi();
  initFirebase();

  client.setServer(mqtt_server, 1883);
  client.setCallback(callback);

  logInfo("System Boot Completed 🚀");
}

/* =========================
            LOOP
   ========================= */
void loop() {

  if (!client.connected()) reconnectMQTT();
  client.loop();

  int A = digitalRead(IR_A);
  int B = digitalRead(IR_B);

  unsigned long now = millis();

  logInfo("A: " + String(A) + " | B: " + String(B));

  /* ===== ENTRY ===== */
  if (A == LOW && state == 0) {
    state = 1;
    stateTime = now;
  }

  if (state == 1 && B == LOW) {
    students++;
    logEvent("ENTRY detected → Students: " + String(students));
    state = 0;
    delay(300);
  }

  /* ===== EXIT ===== */
  if (B == LOW && state == 0) {
    state = 2;
    stateTime = now;
  }

  if (state == 2 && A == LOW) {
    if (students > 0) students--;
    logEvent("EXIT detected → Students: " + String(students));
    state = 0;
    delay(300);
  }

  /* ===== TIMEOUT ===== */
  if (state != 0 && (now - stateTime > 1500)) {
    state = 0;
    logInfo("State timeout reset");
  }

  /* ===== DHT ===== */
  float temp = dht.readTemperature();
  float hum  = dht.readHumidity();

  if (isnan(temp) || isnan(hum)) {
    logError("DHT read failed");
  } else {
    logInfo("Temp: " + String(temp) + " | Hum: " + String(hum));
  }

  /* ===== LIGHT LOGIC ===== */
  bool finalLightState;

  if (autoMode) {
    finalLightState = (students > 0);
  } else {
    finalLightState = manualLightState;
  }

  digitalWrite(LED_PIN, finalLightState);

  logInfo("Light: " + String(finalLightState ? "ON" : "OFF"));

  /* ===== FIREBASE ===== */
  if (students != lastStudents) {

    if (Firebase.RTDB.setInt(&fbdo, "/classroom/students", students))
      logSuccess("Students updated");
    else
      logError(fbdo.errorReason());

    lastStudents = students;
  }

  Firebase.RTDB.setFloat(&fbdo, "/classroom/temp", temp);
  Firebase.RTDB.setFloat(&fbdo, "/classroom/humidity", hum);
  Firebase.RTDB.setBool(&fbdo, "/classroom/light", finalLightState);
  Firebase.RTDB.setString(&fbdo, "/classroom/mode", autoMode ? "AUTO" : "MANUAL");

  /* ===== MQTT PUBLISH ===== */
  client.publish("smartclassroom/students", String(students).c_str());
  client.publish("smartclassroom/temp", String(temp).c_str());
  client.publish("smartclassroom/humidity", String(hum).c_str());
  client.publish("smartclassroom/light_status", finalLightState ? "ON" : "OFF");
  client.publish("smartclassroom/current_mode", autoMode ? "AUTO" : "MANUAL");

  /* ===== SUMMARY ===== */
  Serial.println("--------------");
  logInfo("Students: " + String(students));
  logInfo("Mode: " + String(autoMode ? "AUTO" : "MANUAL"));
  Serial.println("--------------");

  delay(1000);
}
