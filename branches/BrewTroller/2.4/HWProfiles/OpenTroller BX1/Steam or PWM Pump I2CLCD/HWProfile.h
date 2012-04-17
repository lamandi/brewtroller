/*
OpenTroller BX1 Hardware Configuration
  Steam/PWM Pump: Four Heat Outputs + 1 Pump/Valve Outputs + Alarm
  I2CLCD
*/

#ifndef BT_HWPROFILE
#define BT_HWPROFILE
  #include "Config.h"
  
  #define ENCA_PIN 3
  #define ENCB_PIN 2
  #define ENTER_PIN 1
  
  #define ALARM_PIN 15 //OUT6
  
  #define PVOUT_TYPE_GPIO
  #define PVOUT_COUNT 1 //1 Output
  
  #define VALVE1_PIN 18 //OUT5
  
  #define HLTHEAT_PIN 22 //OUT1
  #define MASHHEAT_PIN 21//OUT2
  #define KETTLEHEAT_PIN 20 //OUT3
  #define STEAMHEAT_PIN 19 //OUT4
  #define PWMPUMP_PIN 19 //OUT4
  
  #define HLTVOL_APIN 3
  #define MASHVOL_APIN 2
  #define KETTLEVOL_APIN 1
  #define STEAMPRESS_APIN 0
  
  #define HEARTBEAT
  #define HEARTBEAT_PIN 0
  
  #define UI_LCD_I2C
  #define UI_LCD_I2CADDR 0x01
  #define UI_DISPLAY_SETUP

  
//**********************************************************************************
// OneWire Temperature Sensor Options
//**********************************************************************************
// TS_ONEWIRE: Enables use of OneWire Temperature Sensors (Future logic may
// support alternatives temperature sensor options.)
#define TS_ONEWIRE
#define TS_ONEWIRE_I2C

// TS_ONEWIRE_PPWR: Specifies whether parasite power is used for OneWire temperature
// sensors. Parasite power allows sensors to obtain their power from the data line
// but significantly increases the time required to read the temperature (94-750ms
// based on resolution versus 10ms with dedicated power).
#define TS_ONEWIRE_PPWR 1

// TS_ONEWIRE_RES: OneWire Temperature Sensor Resolution (9-bit - 12-bit). Valid
// options are: 9, 10, 11, 12). Unless parasite power is being used the recommended
// setting is 12-bit (for DS18B20 sensors). DS18S20 sensors can only operate at a max
// of 9 bit. When using parasite power decreasing the resolution reduces the 
// temperature conversion time: 
//   12-bit (0.0625C / 0.1125F) = 750ms 
//   11-bit (0.125C  / 0.225F ) = 375ms 
//   10-bit (0.25C   / 0.45F  ) = 188ms 
//    9-bit (0.5C    / 0.9F   ) =  94ms   
#define TS_ONEWIRE_RES 11

// TS_ONEWIRE_FASTREAD: Enables faster reads of temperatures by reading only the first
// 2 bytes of temperature data and ignoring CRC check.
#define TS_ONEWIRE_FASTREAD

// DS2482_ADDR: I2C Address of DS2482 OneWire Master (used for TS_OneWire_I2C)
// Should be 0x18, 0x19, 0x1A, 0x1B
#define DS2482_ADDR 0x1B
//**********************************************************************************

#define RS485_MASTER
#define RS485_RXTX_PIN 12

#endif