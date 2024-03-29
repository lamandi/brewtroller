#define BUILD 625 
/*  
  Copyright (C) 2009, 2010 Matt Reba, Jermeiah Dillingham

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

/*
Compiled on Arduino-0019 (http://arduino.cc/en/Main/Software)
  With Sanguino Software "Sanguino-0018r2_1_4.zip" (http://code.google.com/p/sanguino/downloads/list)

  Using the following libraries:
    PID  v0.6 (Beta 6) (http://www.arduino.cc/playground/Code/PIDLibrary)
    OneWire 2.0 (http://www.pjrc.com/teensy/arduino_libraries/OneWire.zip)
    Encoder by CodeRage ()
    FastPin and modified LiquidCrystal with FastPin by CodeRage (http://www.brewtroller.com/forum/showthread.php?t=626)
*/

#include "Config.h"
#include "Enum.h"

//*****************************************************************************************************************************
// BEGIN CODE
//*****************************************************************************************************************************
#include <avr/pgmspace.h>
#include <PID_Beta6.h>
#include <pin.h>

void(* softReset) (void) = 0;

//**********************************************************************************
// Compile Time Logic
//**********************************************************************************

// Disable On board pump/valve outputs for BT Board 3.0 and older boards using steam
// Set MUXBOARDS 0 for boards without on board or MUX Pump/valve outputs
#if defined BTBOARD_3 && !defined MUXBOARDS
  #define MUXBOARDS 2
#endif

#if !defined BTBOARD_3 && !defined MUXBOARDS
  #define ONBOARDPV
#else
  #if !defined MUXBOARDS
    #define MUXBOARDS 0
  #endif
#endif

//Enable Serial on BTBOARD_22+ boards or if DEBUG is set
#if !defined BTBOARD_1
  #define USESERIAL
#endif

//Enable Mash Avergaing Logic if any Mash_AVG_AUXx options were enabled
#if defined MASH_AVG_AUX1 || defined MASH_AVG_AUX2 || defined MASH_AVG_AUX3
  #define MASH_AVG
#endif


//**********************************************************************************
// Globals
//**********************************************************************************

//Heat Output Pin Array
pin heatPin[3], alarmPin;

#ifdef ONBOARDPV
  pin valvePin[11];
#endif

#if MUXBOARDS > 0
  pin muxLatchPin, muxDataPin, muxClockPin, muxOEPin;
#endif

//8-byte Temperature Sensor Address x9 Sensors
byte tSensor[9][8];
int temp[9];

////Valve Variables
//unsigned long vlvConfig[NUM_VLVCFGS], vlvBits;
//boolean autoValve[NUM_AV];

//Shared buffers
char menuopts[21][20], buf[20];

//Pit Names
char pitName[3][11];

//Output Globals
double PIDInput[3], PIDOutput[3], pitSetPoint[3], foodSetPoint[3];
byte PIDCycle[3], hysteresis[3];
unsigned long cycleStart[3] = {0,0,0};
boolean heatStatus[3], PIDEnabled[3];

PID pid[3] = {
  PID(&PIDInput[PIT_1], &PIDOutput[PIT_1], &pitSetPoint[PIT_1], 3, 4, 1),  
  PID(&PIDInput[PIT_2], &PIDOutput[PIT_2], &pitSetPoint[PIT_2], 3, 4, 1),  
  PID(&PIDInput[PIT_3], &PIDOutput[PIT_3], &pitSetPoint[PIT_3], 3, 4, 1) 
};

//Timer Globals
unsigned long timerValue[3], lastTime[3];
boolean timerStatus[3], alarmStatus;

//Log Globals
boolean logData = LOG_INITSTATUS;

//Brew Step Logic Globals
//Active program for each brew step
#define PROGRAM_IDLE 255
//byte stepProgram[NUM_BREW_STEPS];
//boolean preheated[3], doAutoBoil;

//Bit 1 = Boil; Bit 2-11 (See Below); Bit 12 = End of Boil; Bit 13-15 (Open); Bit 16 = Preboil (If Compile Option Enabled)
unsigned int hoptimes[10] = { 105, 90, 75, 60, 45, 30, 20, 15, 10, 5 };

const char BT[] PROGMEM = "SmokeTroller";
const char BTVER[] PROGMEM = "1.0";

//Log Strings
const char LOGCMD[] PROGMEM = "CMD";
const char LOGDEBUG[] PROGMEM = "DEBUG";
const char LOGSYS[] PROGMEM = "SYS";
const char LOGCFG[] PROGMEM = "CFG";
const char LOGDATA[] PROGMEM = "DATA";

//**********************************************************************************
// Setup
//**********************************************************************************

void setup() {    

  //Initialize Brew Steps to 'Idle'
  //for(byte brewStep = 0; brewStep < NUM_BREW_STEPS; brewStep++) stepProgram[brewStep] = PROGRAM_IDLE;
  
  //Log initialization (Log.pde)
  logInit();

  //Pin initialization (Outputs.pde)
  //pinInit();
  
  //tempInit();
  
  //User Interface Initialization (UI.pde)
  #ifndef NOUI
    uiInit();
  #endif

  //#ifdef BTPD_SUPPORT
  //  btpdInit();
  //#endif

  //Check for cfgVersion variable and update EEPROM if necessary (EEPROM.pde)
  checkConfig();

  //Load global variable values stored in EEPROM (EEPROM.pde)
  loadSetup();

  //PID Initialization (Outputs.pde)
  //pidInit();

}


//**********************************************************************************
// Loop
//**********************************************************************************

void loop() {
  //User Interface Processing (UI.pde)
  #ifndef NOUI
    uiCore();
  #endif
  
  //Core BrewTroller process code (SmokeCore.pde)
  smokeCore();
}

