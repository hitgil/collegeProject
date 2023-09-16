#include "DHT.h"

#define DHTPIN 2
#define DHTTYPE DHT11
DHT dht(DHTPIN, DHTTYPE);

const int D0 = 8;
const int D1 = 9;
const int D2 = 10;
const int D3 = 11;
const int D4 = 14;
const int D5 = 15;
const int D6 = 16;
const int D00 = 6;

const int spray = 7;

const int Soil = 4;
const int Rain = 3;

void setup()
{
    Serial.begin(9600);
    dht.begin();

    pinMode(D00, OUTPUT);
    pinMode(D0, OUTPUT);
    pinMode(D1, OUTPUT);
    pinMode(D2, OUTPUT);
    pinMode(D3, OUTPUT);

    pinMode(D4, OUTPUT);
    pinMode(D5, OUTPUT);
    pinMode(D6, OUTPUT);

    pinMode(spray, OUTPUT);

    pinMode(Soil, INPUT);
    pinMode(Rain, INPUT);
}

void loop()
{
    if (Serial.available() > 0)
    {
        char rx_data = Serial.read();
        processCommand(rx_data);
    }

    float h = dht.readHumidity();
    float t = dht.readTemperature();
    Serial.print("H:");
    Serial.print(h);
    Serial.print(",T:");
    Serial.println(t);

    delay(1500);
}

void processCommand(char command)
{
    switch (command)
    {
    case 'S':
        Serial.println("Water Spray on");
        digitalWrite(spray, HIGH);
        break;
    case 's':
        Serial.println("Water Spray off");
        digitalWrite(spray, LOW);
        break;
    // Add more cases for other commands as needed...
    default:
        Serial.println("Unknown command");
        break;
    }
}
