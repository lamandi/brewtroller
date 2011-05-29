#define BUILD 626
/*  
  Copyright (C) 2010 Jason von Nieda

    This file is part of BrewTroller.

    BrewTroller is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    BrewTroller is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with BrewTroller.  If not, see <http://www.gnu.org/licenses/>.


BrewTroller - Open Source Brewing Computer
Software Lead: Matt Reba (matt_AT_brewtroller_DOT_com)
Hardware Lead: Jeremiah Dillingham (jeremiah_AT_brewtroller_DOT_com)

Documentation, Forums and more information available at http://www.brewtroller.com
*/

#include <LiquidCrystal.h>
#include <Wire.h>
#include <EEPROM.h>
#include "ByteBuffer.h"
#include <util/atomic.h>

#define LCDRS_PIN 3
#define LCDENABLE_PIN 4
#define LCDDATA1_PIN 5
#define LCDDATA2_PIN 6
#define LCDDATA3_PIN 7
#define LCDDATA4_PIN 8
#define LCDDATA5_PIN 9
#define LCDDATA6_PIN 14
#define LCDDATA7_PIN 15
#define LCDDATA8_PIN 16
#define LCDBRIGHT_PIN 10
#define LCDCONTRAST_PIN 11

#define REQ_BRIGHT 0
#define REQ_CONTRAST 1
#define NUM_REQ 2

LiquidCrystal lcd(LCDRS_PIN, LCDENABLE_PIN, LCDDATA1_PIN, LCDDATA2_PIN, LCDDATA3_PIN, LCDDATA4_PIN, LCDDATA5_PIN, LCDDATA6_PIN, LCDDATA7_PIN, LCDDATA8_PIN);

byte i2cAddr = 0x01;
byte brightness = 0;
byte contrast = 255;
byte reqField = REQ_BRIGHT;
ByteBuffer i2cBuffer;

void setup() {
  loadEEPROM();
  pinMode(LCDBRIGHT_PIN, OUTPUT);
  pinMode(LCDCONTRAST_PIN, OUTPUT);
  
  Serial.begin(115200);
  
  i2cBuffer.init(128);

  lcd.begin(20, 4);
  lcd.setCursor(0, 0);
  lcd.print("I2CLCD");
  lcd.setCursor(0, 1);
  lcd.print("Build ");
  lcd.print(BUILD, DEC);
  lcd.setCursor(0, 2);
  lcd.print("Address: 0x");
  lcd.print(i2cAddr, HEX);
  
  Wire.onReceive(onReceive);
  Wire.onRequest(onRequest);
  Wire.begin(i2cAddr);
}

void loop() {
  /**
  * Each time through the loop we make an atomic copy of the I2C buffer
  * and then process any commands that are in it. This allows I2C receive
  * happen quickly to avoid overflows and allows us to process commands
  * in the "background". 
  */
  
  byte buffer[128];
  byte length;
  byte *p = buffer;
  
  memset(buffer, 0, 128);
  
  ATOMIC_BLOCK(ATOMIC_FORCEON) {
    length = (byte) i2cBuffer.getSize();
  }
  
  for (byte i = 0; i < length; i++) {
    buffer[i] = i2cBuffer.get();
  }

  while ((p - buffer) < length) {
    /*
    Serial.print("Got ");
    Serial.print(*p, DEC);
    Serial.print(" ");
    Serial.print(length, DEC);
    Serial.print(" ");
    Serial.println((p - buffer), DEC);
    */
  
    switch (p[0]) {
      case 0x01: // begin(cols, rows)
        p += 2;
        break;
      case 0x02: // clear
        lcd.clear();
        break;
      case 0x03: // setCursor(col, row)
        lcd.setCursor(p[1], p[2]);
        p += 2;
        break;
      case 0x04: // print(col, row, char* s)
        lcd.setCursor(p[1], p[2]);
        lcd.print((char *) &p[3]);
        p += 2 + strlen((char *) &p[3]) + 1;
        break;
      case 0x05: // setCustChar(slot, unsigned char data[8])
        lcd.createChar(p[1], &p[2]);
        p += 1 + 8;
        break;
      case 0x06: // writeCustChar(col, row, slot)
        Serial.print("writeCustChar ");
        Serial.print(p[1], DEC);
        Serial.print(" ");
        Serial.print(p[2], DEC);
        Serial.print(" ");
        Serial.println(p[3], DEC);
        lcd.setCursor(p[1], p[2]);
        lcd.write(p[3]);
        p += 3;
        break;
      case 0x07: // setBright(value)
        p++;
        setBright(*p);
        EEPROM.write(2, *p++); //Save to EEPROM
        delay(10);
        break;
      case 0x08: // setContrast(value)
        p++;
        setContrast(*p++);
        EEPROM.write(2, *p++); //Save to EEPROM
        delay(10);
        break;
      case 0x09: // getBright(value)
        reqField = REQ_BRIGHT;
        delay(10);
        break;
      case 0x0A: // getContrast(value)
        reqField = REQ_CONTRAST;
        delay(10);
        break;
    }
    
    // increment for the command byte that was read
    p++;
    
  }
}

void onReceive(int numBytes) {
  for (byte i = 0; i < numBytes; i++) {
    i2cBuffer.put(Wire.receive());
  }
}

void onRequest() {
  if (reqField == REQ_BRIGHT) Wire.send(brightness);
  else if (reqField == REQ_CONTRAST) Wire.send(contrast);
  else Wire.send(1);
  reqField++;
  if (reqField >= NUM_REQ) reqField = 0;
}

void panAnalog(byte pin, byte startValue, byte endValue, int delayValue) {
  if (startValue < endValue) for (int i = startValue; i <= endValue; i++) { analogWrite(pin, i); delay(delayValue); }
  else if (startValue > endValue) for (int i = startValue; i >= endValue; i--) { analogWrite(pin, i); delay(delayValue); }
  else analogWrite(pin, startValue);
}

void setBright(byte value) {
  panAnalog(LCDBRIGHT_PIN, brightness, value, 2);
  brightness = value;
}

void setContrast(byte value) {
  panAnalog(LCDCONTRAST_PIN, contrast, value, 2);
  contrast = value;
}

void loadEEPROM() {
  //Look for I2CLCD "fingerprint"
  if (EEPROM.read(0) == 123 && EEPROM.read(1) == 45)  {
    setBright(EEPROM.read(2));
    setContrast(EEPROM.read(3));
  }
  else {
    //Set initial EEPROM values
    EEPROM.write(0, 123);
    EEPROM.write(0, 45);
    EEPROM.write(0, 255); //Max
    setBright(255);
    EEPROM.write(0, 0); //Max
    setContrast(0);
  }
}
