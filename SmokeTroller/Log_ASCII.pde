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
 
 Update 9/22/2010 to support enhanced functions and mutiple schemas.
 
*/

#if COMTYPE == 0

  #include "Config.h"
  #include "Enum.h"
  
  //**********************************************************************************
  //Code for Schemas 0 & 1
  //**********************************************************************************
  unsigned long lastLog;
  boolean msgQueued;
  byte logCount, msgField;
  char msg[CMD_MSG_FIELDS][CMD_FIELD_CHARS];
  
  void logStart_P (const char *sType) {
    #if defined USESERIAL
      Serial.print(millis(),DEC);
      Serial.print("\t");
      while (pgm_read_byte(sType) != 0) Serial.print(pgm_read_byte(sType++)); 
      Serial.print("\t");
    #endif
  }

  void logEnd () {
    #if defined USESERIAL
      Serial.println();
    #endif
  }

  void logField (char sText[]) {
    #if defined USESERIAL
      Serial.print(sText);
      Serial.print("\t");
    #endif
  }

  void logFieldI (unsigned long value) {
    #if defined USESERIAL
      Serial.print(value, DEC);
      Serial.print("\t");
    #endif
  }
  
  void logFieldL (long value) {
    #if defined USESERIAL
      Serial.print(value, DEC);
      Serial.print("\t");
    #endif
  }
  
   void logFieldUL (unsigned long value) {
    #if defined USESERIAL
      Serial.print(value, DEC);
      Serial.print("\t");
    #endif
  }

  void logField_P (const char *sText) {
    #if defined USESERIAL
      while (pgm_read_byte(sText) != 0) Serial.print(pgm_read_byte(sText++));
      Serial.print("\t");
    #endif
  }

  //This is (and should only) be used internally in COMSCHEMA 0/1
  void logString_P (const char *sType, const char *sText) {
    logStart_P(sType);
    logField_P(sText);
    logEnd();
  }

  boolean chkMsg() {
    #if defined USESERIAL
      if (!msgQueued) {
        while (Serial.available()) {
          byte byteIn = Serial.read();
          if (byteIn == '\r') { 
            msgQueued = 1;
            //Configuration Class (CFG) Commands            
//            if(strcasecmp(msg[0], "GET_OSET") == 0) {
//              byte val = atoi(msg[1]);
//              if (msgField == 1 && val >= PIT_1 && val <= PIT_3) {
//                logOSet(val);
//                clearMsg();
//              } 
//              else rejectParam();
//            } 
//            else if(strcasecmp(msg[0], "GET_PROG") == 0) {
//              byte program = atoi(msg[1]);
//              if (msgField == 1 && program >= 0 && program < 20) {
//                logProgram(program);
//                clearMsg();
//              } 
//              else rejectParam();
//            } 
//            else if (strcasecmp(msg[0], "GET_TS") == 0) {
//              byte val = atoi(msg[1]);
//              if (msgField == 1 && val >= TS_PIT_1 && val <= TS_AUX3) {
//                logTSensor(val);
//                clearMsg();
//              } 
//              else rejectParam();
//            } 
//            else if(strcasecmp(msg[0], "GET_VLVCFG") == 0) {
//              byte profile = atoi(msg[1]);
//              if (msgField == 1 && profile >= VLV_FILLHLT && profile <= VLV_HLTHEAT) {
//                logVlvConfig(profile);
//                clearMsg();
//              } 
//              else rejectParam();
//            }           
//            else if(strcasecmp(msg[0], "INIT_EEPROM") == 0) {
//              clearMsg();
//              initEEPROM();
//              #if COMSCHEMA == 1
//                logStart_P(LOGCFG);
//                logField_P(PSTR("EEPROM Initialized"));                  
//                logEnd();
//              #endif
//            } 
//            else if(strcasecmp(msg[0], "SCAN_TS") == 0) {
//              clearMsg();
//              byte tsAddr[8];
//              getDSAddr(tsAddr);
//              logStart_P(LOGCFG);
//              logField_P(PSTR("TS_SCAN")); 
//              for (byte i=0; i<8; i++) logFieldI(tsAddr[i]);
//              logEnd();
//            }             
//            else if(strcasecmp(msg[0], "SET_OSET") == 0) {
//              byte val = atoi(msg[1]);
//              #if COMSCHEMA == 0
//                if (msgField == 7 && val >= PIT_1 && val <= PIT_3) {
//                  setPIDEnabled(val, (byte)atoi(msg[2]));
//                  setPIDCycle(val, (byte)atoi(msg[3]));
//                  setPIDp(val, (byte)atoi(msg[4]));
//                  setPIDi(val, (byte)atoi(msg[5]));
//                  setPIDd(val, (byte)atoi(msg[6]));
//                  setHysteresis(val, (byte)atoi(msg[7]));
//                  clearMsg();
//                  logOSet(val);
//                } 
//                else rejectParam();
//              #else
//                if (msgField == 9 && val >= PIT_1 && val <= PIT_3) {
//                  setPIDEnabled(val, (byte)atoi(msg[2]));
//                  setPIDCycle(val, (byte)atoi(msg[3]));
//                  setPIDp(val, (byte)atoi(msg[4]));
//                  setPIDi(val, (byte)atoi(msg[5]));
//                  setPIDd(val, (byte)atoi(msg[6]));                  
//                  setHysteresis(val, (byte)atoi(msg[7]));                  
//                  clearMsg();
//                  logOSet(val);
//                } 
//                else rejectParam();
//              #endif
//            } 
//            else if(strcasecmp(msg[0], "SET_PROG") == 0) {          
//              byte program = atoi(msg[1]);
//              if (msgField == ((COMSCHEMA == 0) ? 22 : 23) && program >= 0 && program < 20) {
//                char pName[20];
//                strncpy(pName,msg[2],19); // Trunc the Program Name to 19 chars
//                pName[19] = '\0';
//                setProgName(program, pName);
//                for (byte i = MASH_DOUGHIN; i <= MASH_MASHOUT; i++) {
//                  setProgMashTemp(program, i, atoi(msg[i * 2 + 3]));
//                  setProgMashMins(program, i, atoi(msg[i * 2 + 4]));
//                }               
//                clearMsg();
//                logProgram(program);
//              } 
//              else rejectParam();
//            } 
//            else if(strcasecmp(msg[0], "SET_TS") == 0) {
//              byte val = atoi(msg[1]);
//              if (msgField == 9 && val >= TS_PIT_1 && val <= TS_AUX3) {
//                byte addr[8];
//                for (byte i=0; i<8; i++) addr[i] = (byte)atoi(msg[i+2]);
//                setTSAddr(val, addr);
//                clearMsg();
//                logTSensor(val);
//              } 
//              else rejectParam();
//            } 
//            else if(strcasecmp(msg[0], "SET_VLVCFG") == 0) {
//              byte profile = atoi(msg[1]);
//              if (msgField == 2 && profile >= VLV_FILLHLT && profile <= VLV_HLTHEAT) {
//                setValveCfg(profile, strtoul(msg[2], NULL, 10));
//                clearMsg();
//                logVlvConfig(profile);
//              } 
//              else rejectParam();
//            } 
//                       
//            //Data Class (DATA) Commands
//            else if(strcasecmp(msg[0], "SET_ALARM") == 0) {
//              if (msgField == 1) {
//                setAlarm((boolean)atoi(msg[1]));
//                sendOK();
//              } 
//              else rejectParam();
//            } 
//            else if(strcasecmp(msg[0], "SET_AUTOVLV") == 0) {
//              byte avSet = atoi(msg[1]);
//              if (msgField == 1) {
//                byte actModes = atoi(msg[1]);
//                for (byte i = AV_FILL; i <= AV_CHILL; i++) 
//                  autoValve[i] = (actModes & (1<<i));
//                sendOK();
//              } 
//              else rejectParam();
//            } 
//            else if(strcasecmp(msg[0], "SET_SETPOINT") == 0) {
//              byte smokerPit = atoi(msg[1]);
//              if (msgField == 2 && smokerPit <= PIT_3) {
//                setSetpoint(smokerPit, (byte)atoi(msg[2]));
//                sendOK();
//              } 
//              else rejectParam();
//            } 
//            else if(strcasecmp(msg[0], "SET_TIMERSTATUS") == 0) {
//              byte timer = atoi(msg[1]);
//              if (msgField == 2 && timer >= TIMER_S1 && timer <= TIMER_S2) {
//                setTimerStatus(timer, (boolean)atoi(msg[2]));
//                sendOK();
//              } 
//              else rejectParam();
//            } 
//            else if(strcasecmp(msg[0], "SET_TIMERVALUE") == 0) {
//              byte timer = atoi(msg[1]);
//              if (msgField == 2 && timer >= TIMER_S1 && timer <= TIMER_S2) {
//                timerValue[timer] = strtoul(msg[2], NULL, 10);
//                lastTime[timer] = millis();
//                sendOK();
//              } 
//              else rejectParam();
//            } 
//            else if(strcasecmp(msg[0], "SET_VLV") == 0) {
//              if (msgField == 2) {
//                setValves(strtoul(msg[1], NULL, 10), atoi(msg[2]));
//                sendOK();
//              } 
//              else rejectParam();
//            } 
//            else if(strcasecmp(msg[0], "SET_VLVPRF") == 0) {
//              if (msgField == 2) {
//                setValves(VLV_ALL, 0);
//                unsigned long actProfiles = strtoul(msg[1], NULL, 10);
//                for (byte i = VLV_FILLHLT; i <= VLV_HLTHEAT; i++) 
//                  if ((actProfiles & (1<<i))) setValves(vlvConfig[i], atoi(msg[2]));
//                sendOK();
//              } 
//              else rejectParam();
//            } 
//  
//           //System Class (SYS) Commands
//            else if(strcasecmp(msg[0], "RESET") == 0) {
//              byte level = atoi(msg[1]);
//              if (msgField == 1 && level >= 0 && level <= 1) {
//                clearMsg();
//                if (level == 0) {
//                  resetOutputs();
//                  clearTimer(TIMER_S1);
//                  clearTimer(TIMER_S2);
//                } 
//               else if (level == 1) {
//                  logStart_P(LOGSYS);
//                  logField_P(PSTR("SOFT_RESET"));
//                  logEnd();
//                  //softReset();
//                }
//              } 
//              else rejectParam();
//            } 
//            else if(strcasecmp(msg[0], "SET_LOGSTATUS") == 0) {
//              if (msgField == 1) {
//                logData = (boolean)atoi(msg[1]);
//                sendOK();
//              } 
//              else rejectParam();
//            } 
//            else if(strcasecmp(msg[0], "GET_VER") == 0) {
//              logVersion();
//              clearMsg();        
//            } 
//            
//            // Schema 1 Functions
//            #if COMSCHEMA > 0
//              else if(strcasecmp(msg[0], "GET_LOG") == 0) {
//                if (msgField == 1) {
//                  logCount = atoi(msg[1]);
//                  getLog();
//                  clearMsg();
//                } 
//                else rejectParam();
//              } 
//              else if(strcasecmp(msg[0], "GET_ALARM") == 0) {
//                logAlarm();
//                clearMsg();        
//              }               
//              else if(strcasecmp(msg[0], "GET_LOGSTATUS") == 0) {
//                logLogStatus();
//                clearMsg();
//              } 
//              else if(strcasecmp(msg[0], "GET_EEPROM") == 0) {
//                if (msgField == 2) {
//                  int address = atoi(msg[1]);
//                  int length = atoi(msg[2]);
//                  if (address >= 0 && address < 2048 &&
//                    length > 0 && length <= 64)
//                  {
//                    getEEPROM(address, length);
//                    clearMsg();
//                  }
//                } 
//                else rejectParam();
//              } 
//              else if(strcasecmp(msg[0], "SET_EEPROM") == 0) {
//                setEEPROM();
//                clearMsg();
//              }
//            #endif
  
            //End of Commands        
            break;  
          } 
          else if (byteIn == '\t') {
            if (msgField < CMD_MSG_FIELDS) {
              msgField++;
            } 
            else {
              logString_P(LOGCMD, PSTR("MSG_OVERFLOW"));
              clearMsg();
            }
          } 
          else {
            byte charCount = strlen(msg[msgField]);
            if (charCount < CMD_FIELD_CHARS - 1) { 
              msg[msgField][charCount] = byteIn; 
              msg[msgField][charCount + 1] = '\0';
            } 
            else {
              logString_P(LOGCMD, PSTR("FIELD_OVERFLOW"));
              clearMsg();
            }
          }
        }
      }
      if (msgQueued) return 1; 
      else return 0;
    #endif
  }

  void sendOK() {
    #if COMSCHEMA > 0
      logStart_P(LOGCMD);
      logField_P(PSTR("OK"));
      logEnd();
    #endif
    clearMsg();
  }

  void clearMsg() {
    msgQueued = 0;
    msgField = 0;
    for (byte i = 0; i < CMD_MSG_FIELDS; i++) msg[i][0] = '\0';
  }
  
  void rejectMsg() {
    logStart_P(LOGCMD);
    logField_P(PSTR("UNKNOWN_CMD"));
    for (byte i = 0; i < msgField; i++) logField(msg[i]);
    logEnd();
    clearMsg();
  }
  
  void rejectParam() {
    logStart_P(LOGCMD);
    logField_P(PSTR("BAD_PARAM"));
    for (byte i = 0; i <= msgField; i++) logField(msg[i]);
    logEnd();
    clearMsg();
  }
  
  void logVersion() { 
    logASCIIVersion(); 
  }
  
  void updateLog() {
    // All data is logged every 2s. A total of 28 records are sent. The 
    //  records are sent on consecutive scans.
    if (logData) {
      if (millis() - lastLog > LOG_INTERVAL) {
        getLog();
        if (logCount == 24) 
        {
          //Logic below times start of log to start of log. Interval is reset if exceeds two intervals.
          if (millis() - lastLog > LOG_INTERVAL * 2) 
            lastLog = millis(); 
          else 
            lastLog += LOG_INTERVAL;
        }
        logCount++;
        if (logCount > 24)
          logCount = 0;  
      }    
  
    }
    // if logData is false && chkMsg() is false - should we pass the LOGCFG constant into rejectMsg?
    if (chkMsg()) rejectMsg();   // old value: LOGGLB
  }
  
  void getLog() {
//    if (logCount == 0) {
//      logStart_P(LOGDATA);
//      logField_P(PSTR("STEPPRG"));
//      for (byte i = 0; i < NUM_BREW_STEPS; i++)
//        logFieldI(stepProgram[i]);
//      logEnd();
//    } 
//    else if (logCount == 1) {
//      for (byte timer = TIMER_S1; timer <= TIMER_S2; timer++) {
//        logStart_P(LOGDATA);
//        logField_P(PSTR("TIMER"));
//        logFieldI(timer);
//        logFieldI(timerValue[timer]);
//        logFieldI(timerStatus[timer]);
//        logEnd();
//      }
//      logStart_P(LOGDATA);
//      logField_P(PSTR("ALARM"));
//      logFieldI(alarmStatus);
//      logEnd();
//    } 
//    else if (logCount >= 2 && logCount <= 4) {
//      byte i = logCount - 2;
//      logStart_P(LOGDATA);
//      logField_P(PSTR("VOL"));
//      logFieldI(i);
//      logFieldI(volAvg[i]);
//      #ifdef FLOWRATE_CALCS
//        logFieldI(flowRate[i]);
//      #else
//        logFieldI(0);
//      #endif
//      #if COMSCHEMA == 0
//        #ifdef USEMETRIC
//            logFieldI(0);
//        #else
//            logFieldI(1);
//        #endif
//      #endif
//      logEnd();
//    } 
//    else if (logCount >= 5 && logCount <= 13) {
//      byte i = logCount - 5;
//      logStart_P(LOGDATA);
//      logField_P(PSTR("TEMP"));
//      logFieldI(i);
//      logFieldI(temp[i]);
//      #if COMSCHEMA == 0
//        #ifdef USEMETRIC
//          logFieldI(0);
//        #else
//          logFieldI(1);
//        #endif
//      #endif
//      logEnd();
//    } 
//    else if (logCount == 14) {
//     
//    } 
//    else if (logCount >= 15 && logCount <= 18) {
//      byte pct;
//      byte i = logCount - 15;
//      if (PIDEnabled[i]) pct = PIDOutput[i] / PIDCycle[i];
//      else if (heatStatus[i]) pct = 100;
//      else pct = 0;
//      logStart_P(LOGDATA);
//      logField_P(PSTR("HEATPWR"));
//      logFieldI(i);
//      logFieldI(pct);
//      logEnd();
//    } 
//    else if (logCount >= 19 && logCount <= 22) {
//      byte i = logCount - 19;
//      logStart_P(LOGDATA);
//      logField_P(PSTR("SETPOINT"));
//      logFieldI(i);
//      logFieldI(setpoint[i] / 100);
//      #if COMSCHEMA == 0
//        #ifdef USEMETRIC
//          logFieldI(0);
//        #else
//          logFieldI(1);
//        #endif
//      #endif
//      logEnd();
//    } 
//    else if (logCount == 23) {
//      logStart_P(LOGDATA);
//      logField_P(PSTR("AUTOVLV"));
//      byte modeMask = 0;
//      for (byte i = AV_FILL; i <= AV_HLT; i++)
//        if (autoValve[i]) modeMask |= 1<<i;
//      logFieldI(modeMask);
//      logEnd();
//      logStart_P(LOGDATA);
//      logField_P(PSTR("VLVBITS"));
//      logFieldI(vlvBits);
//      logEnd();
//    } 
//    else if (logCount == 24) {
//      logStart_P(LOGDATA);
//      logField_P(PSTR("VLVPRF"));
//      unsigned int profileMask = 0;
//      for (byte i = VLV_FILLHLT; i <= VLV_HLTHEAT; i++) 
//        if (vlvConfig[i] != 0 && (vlvBits & vlvConfig[i]) == vlvConfig[i]) profileMask |= 1<<i;
//      logFieldI(profileMask);
//      logEnd();
//    }
  }

  #if defined USESERIAL
    void logTSensor(byte sensor) {
      logStart_P(LOGCFG);
      logField_P(PSTR("TS_ADDR"));
      logFieldI(sensor);
      for (byte i=0; i<8; i++) logFieldI(tSensor[sensor][i]);
      logEnd();
    }

    void logOSet(byte smokerPit) {
//      logStart_P(LOGCFG);
//      logField_P(PSTR("OUTPUT_SET"));
//      logFieldI(smokerPit);
//      logFieldI(PIDEnabled[smokerPit]);
//      logFieldI(PIDCycle[smokerPit]);
//      logFieldI(getPIDp(smokerPit));
//      logFieldI(getPIDi(smokerPit));
//      logFieldI(getPIDd(smokerPit));
//      #if COMSCHEMA == 0
//        logFieldI(hysteresis[smokerPit]);
//      #else        
//        logFieldI(hysteresis[smokerPit]);
//        logFieldI(0);
//        logFieldI(0);       
//      #endif
//      logEnd();
    }   
  
    void logAlarm() {
      logStart_P(LOGDATA);
      logField_P(PSTR("ALARM"));
      logFieldI(alarmStatus);
      logEnd();
    }
  
//    void logVlvConfig (byte profile) {
//      logStart_P(LOGCFG);
//      logField_P(PSTR("VLV_CONFIG"));
//      logFieldI(profile);
//      logFieldI(vlvConfig[profile]);  
//      logEnd();
//    }
//  
    void logProgram(byte program) {
//      logStart_P(LOGCFG);
//      logField_P(PSTR("PROG_SET"));
//      logFieldI(program);
//      getProgName(program, buf);
//      logField(buf);
//    
//      for (byte i = MASH_DOUGHIN; i <= MASH_MASHOUT; i++) {
//        logFieldI(getProgMashTemp(program, i));
//        logFieldI(getProgMashMins(program, i));
//      }    
//      
//      logEnd();
    }
  
    void logLogStatus() {
//      logStart_P(LOGSYS);
//      logField_P(PSTR("LOG_STATUS"));
//      logFieldI(logData);
//      logEnd();
    }

    // Schema 1 Functions
    #if COMSCHEMA > 0
  
      // read values from EEPROM
      void getEEPROM(int address, int dataLen) 
      {
//        byte checksum = 0;
//  
//        logStart_P(LOGCFG);
//        logField_P(PSTR("EEPROM"));
//      
//        // address & data length
//        checksum += printHex8(byte(address>>8));
//        checksum += printHex8(byte(address));
//        Serial.print('\t');
//        checksum += printHex8(dataLen);
//  
//        // EEPROM data
//        for (int i=0; i < dataLen; i++)
//        {
//          if (i % 8 == 0) 
//            Serial.print('\t');
//          checksum += printHex8(EEPROM.read(address++));
//        }
//  
//        // checksum
//        Serial.print('\t');
//        checksum = (~checksum) + 1;
//        printHex8(checksum);
//  
//        Serial.print('\t');
//        logEnd();
      }
  
      //  write values to EEPROM
      bool setEEPROM() {
//        byte* btBuf = (byte*)&msg;  // msg buffer will be used to store data to write in EEPROM
//        byte msgIndex = 2;          // msg[3] is first chunk of data
//        byte checksum = 0;
//    
//        // get address and data length
//        int address = hex2Int(msg[1], 0, 4);
//        checksum += byte(address>>8);
//        checksum += byte(address);
//        byte dataLen = hex2Int(msg[2], 0, 2);
//        checksum += dataLen;
//
//        // data loop
//        byte i;
//        for (i=0; i < dataLen; i++)
//        {
//          byte chIndex = 2 * (i & 0x07); // character index (i % 8)
//          // check for start of next msg[]
//          if (chIndex == 0) {
//            msgIndex++;
//          }
//          // get data and put in buffer
//          btBuf[i] = (byte)hex2Int(msg[msgIndex], chIndex, 2);
//          checksum += btBuf[i]; 
//        }
//
//        // get checksum
//        msgIndex++;
//        btBuf[i] = (byte)hex2Int(msg[msgIndex], 0, 2);
//        checksum += btBuf[i];
//  
//        // checksum check (should be 0 if valid)
//        if (checksum != 0)
//        {
//          returnChecksumError();
//          return false;
//        }
//
//        // write values to EEPROM
//        for (byte i=0; i < dataLen; i++)
//        {
//          EEPROM.write(address+i, btBuf[i]);
//        }
//      
//        getEEPROM(address, dataLen);
//        //testSetEEPROM(address, dataLen);
//      
//        return true;
      }

      void returnChecksumError() {
        logStart_P(LOGCMD);
        logField_P(PSTR("CHECKSUM_ERROR"));
        logEnd();
        clearMsg();
      }

      int hex2Int(char chBuf[], byte offset, byte length) {
      
        int iVal=0;
        for (byte i=0; i<length; i++) 
        {
          iVal <<= 4;
          char hexChar = chBuf[offset+i];
      
          // make upper case
          if (hexChar >= 0x60) 
            hexChar -= 0x20;  
      
          // convert to value
          if (hexChar >= '0' && hexChar <= '9')
            iVal += hexChar - '0';
          else if (hexChar >= 'A' && hexChar <= 'F')
            iVal += hexChar - 0x41 + 10;
          else
            return -1;
        }
        return iVal;
      }

      byte printHex8(byte btVal) // prints 8-bit data in hex with leading zeroes
      {
        if (btVal<0x10) 
          Serial.print("0");
        Serial.print(btVal,HEX);
        return btVal;
      }
    
    #endif

    #ifdef DEBUG_PID_GAIN
      void logDebugPIDGain(byte smokerPit) {
        logStart_P(LOGDEBUG);
        logField_P(PSTR("PID_GAIN"));
        logFieldI(smokerPit);
        logFieldI(pid[smokerPit].GetP_Param());
        logFieldI(pid[smokerPit].GetI_Param());
        logFieldI(pid[smokerPit].GetD_Param());
        logEnd();
      }
    #endif
    
  #endif

#endif

