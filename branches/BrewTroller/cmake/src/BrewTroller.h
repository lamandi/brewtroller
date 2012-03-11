/*
 * BrewTroller.h
 *
 *  Created on: Nov 12, 2011
 *      Author: treaves
 */

#ifndef BREWTROLLER_H_
#define BREWTROLLER_H_
#define BUILD 789

#include <avr/pgmspace.h>
#include <PID_Beta6.h>
#include <pin.h>
#include <menu.h>

#include "Config.h"
#include "Enum.h"
#include "HWProfile.h"
#include "PVOut.h"
#include "UI_LCD.h"

void(* softReset) (void) = 0;

const char BT[] PROGMEM = "BrewTroller";
const char BTVER[] PROGMEM = "2.5";

//**********************************************************************************
// Compile Time Logic
//**********************************************************************************

//Enable Mash Avergaing Logic if any Mash_AVG_AUXx options were enabled
#if defined MASH_AVG_AUX1 || defined MASH_AVG_AUX2 || defined MASH_AVG_AUX3
  #define MASH_AVG
#endif

#ifdef USEMETRIC
  #define SETPOINT_MULT 50
  #define SETPOINT_DIV 2
#else
  #define SETPOINT_MULT 100
  #define SETPOINT_DIV 1
#endif

#ifndef STRIKE_TEMP_OFFSET
  #define STRIKE_TEMP_OFFSET 0
#endif

#if COM_SERIAL0 == BTNIC || defined BTNIC_EMBEDDED
  #define BTNIC_PROTOCOL
#endif

#if defined BTPD_SUPPORT || defined UI_LCD_I2C || defined TS_ONEWIRE_I2C || defined BTNIC_EMBEDDED
  #define USE_I2C
#endif

#ifdef BOIL_OFF_GALLONS
  #ifdef USEMETRIC
    #define EvapRateConversion 1000
  #else
    #define EvapRateConversion 100
  #endif
#endif

#ifdef USE_I2C
  #include <Wire.h>
#endif

//**********************************************************************************
// Globals
//**********************************************************************************

//Heat Output Pin Array
pin heatPin[4], alarmPin;

#ifdef DIGITAL_INPUTS
  pin digInPin[6];
#endif

#ifdef HEARTBEAT
  pin hbPin;
#endif

//Volume Sensor Pin Array
#ifdef HLT_AS_KETTLE
  byte vSensor[3] = { HLTVOL_APIN, MASHVOL_APIN, HLTVOL_APIN};
#else
  byte vSensor[3] = { HLTVOL_APIN, MASHVOL_APIN, KETTLEVOL_APIN};
#endif

//8-byte Temperature Sensor Address x9 Sensors
byte tSensor[9][8];
int temp[9];

//Volume in (thousandths of gal/l)
unsigned long tgtVol[3], volAvg[3], calibVols[3][10];
unsigned int calibVals[3][10];
#ifdef SPARGE_IN_PUMP_CONTROL
unsigned long prevSpargeVol[2] = {0,0};
#endif

#ifdef HLT_MIN_REFILL
unsigned long SpargeVol = 0;
#endif

#ifdef FLOWRATE_CALCS
//Flowrate in thousandths of gal/l per minute
long flowRate[3] = {0,0,0};
#endif


//Create the appropriate 'LCD' object for the hardware configuration (4-Bit GPIO, I2C)
#if defined UI_LCD_4BIT
  #include <LiquidCrystalFP.h>

  #ifndef UI_DISPLAY_SETUP
    LCD4Bit LCD(LCD_RS_PIN, LCD_ENABLE_PIN, LCD_DATA4_PIN, LCD_DATA5_PIN, LCD_DATA6_PIN, LCD_DATA7_PIN);
  #else
    LCD4Bit LCD(LCD_RS_PIN, LCD_ENABLE_PIN, LCD_DATA4_PIN, LCD_DATA5_PIN, LCD_DATA6_PIN, LCD_DATA7_PIN, LCD_BRIGHT_PIN, LCD_CONTRAST_PIN);
  #endif

#elif defined UI_LCD_I2C
  LCDI2C LCD(UI_LCD_I2CADDR);
#endif



//Valve Variables
unsigned long vlvConfig[NUM_VLVCFGS], actProfiles;
boolean autoValve[NUM_AV];

//Create the appropriate 'Valves' object for the hardware configuration (GPIO, MUX, MODBUS)
#if defined PVOUT_TYPE_GPIO
  #define PVOUT
  PVOutGPIO Valves(PVOUT_COUNT);

#elif defined PVOUT_TYPE_MUX
  #define PVOUT
  PVOutMUX Valves(
    MUX_LATCH_PIN,
    MUX_DATA_PIN,
    MUX_CLOCK_PIN,
    MUX_ENABLE_PIN,
    MUX_ENABLE_LOGIC
  );

#elif defined PVOUT_TYPE_MODBUS
  #define PVOUT
  PVOutMODBUS Valves();

#endif

//Shared buffers
char buf[20];

//Output Globals
double PIDInput[4], PIDOutput[4], setpoint[4];
#ifdef PID_FEED_FORWARD
double FFBias;
#endif
byte PIDCycle[4], hysteresis[4];
#ifdef PWM_BY_TIMER
unsigned int cycleStart[4] = {0,0,0,0};
#else
unsigned long cycleStart[4] = {0,0,0,0};
#endif
boolean heatStatus[4], PIDEnabled[4];
unsigned int steamPSens, steamZero;

byte pidLimits[4] = { PIDLIMIT_HLT, PIDLIMIT_MASH, PIDLIMIT_KETTLE, PIDLIMIT_STEAM };

//Steam Pressure in thousandths
unsigned long steamPressure;
byte boilPwr;

PID pid[4] = {
  PID(&PIDInput[VS_HLT], &PIDOutput[VS_HLT], &setpoint[VS_HLT], 3, 4, 1),

  #ifdef PID_FEED_FORWARD
    PID(&PIDInput[VS_MASH], &PIDOutput[VS_MASH], &setpoint[VS_MASH], &FFBias, 3, 4, 1),
  #else
    PID(&PIDInput[VS_MASH], &PIDOutput[VS_MASH], &setpoint[VS_MASH], 3, 4, 1),
  #endif

  PID(&PIDInput[VS_KETTLE], &PIDOutput[VS_KETTLE], &setpoint[VS_KETTLE], 3, 4, 1),

  #ifdef PID_FLOW_CONTROL
    PID(&PIDInput[VS_PUMP], &PIDOutput[VS_PUMP], &setpoint[VS_PUMP], 3, 4, 1)
  #else
    PID(&PIDInput[VS_STEAM], &PIDOutput[VS_STEAM], &setpoint[VS_STEAM], 3, 4, 1)
  #endif
};
#if defined PID_FLOW_CONTROL && defined PID_CONTROL_MANUAL
  unsigned long nextcompute;
  byte additioncount[2];
#endif

#ifdef RIMS_MLT_SETPOINT_DELAY
  byte steptoset = 0;
  byte RIMStimeExpired = 0;
  unsigned long starttime = 0;
  unsigned long timetoset = 0;
#endif

//Timer Globals
unsigned long timerValue[2], lastTime[2];
boolean timerStatus[2], alarmStatus;

//Log Globals
boolean logData = LOG_INITSTATUS;

//Brew Step Logic Globals
//Active program for each brew step
#define PROGRAM_IDLE 255
byte stepProgram[NUM_BREW_STEPS];
boolean preheated[4], doAutoBoil;

//Bit 1 = Boil; Bit 2-11 (See Below); Bit 12 = End of Boil; Bit 13-15 (Open); Bit 16 = Preboil (If Compile Option Enabled)
unsigned int hoptimes[10] = { 105, 90, 75, 60, 45, 30, 20, 15, 10, 5 };
byte pitchTemp;

//Log Strings
const char LOGCMD[] PROGMEM = "CMD";
const char LOGDEBUG[] PROGMEM = "DEBUG";
const char LOGSYS[] PROGMEM = "SYS";
const char LOGCFG[] PROGMEM = "CFG";
const char LOGDATA[] PROGMEM = "DATA";

//PWM by timer globals
#ifdef PWM_BY_TIMER
unsigned int timer1_overflow_count = 0;
unsigned int PIDOutputCountEquivalent[4][2] = {{0,0},{0,0},{0,0},{0,0}};
#endif


#endif /* BREWTROLLER_H_ */