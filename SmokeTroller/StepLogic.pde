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

#include "Config.h"
#include "Enum.h"

//unsigned long lastHop, grainInStart;
//unsigned int boilAdds, triggered;
//
//boolean stepIsActive(byte brewStep) {
//  if (stepProgram[brewStep] != PROGRAM_IDLE) return true; else return false;
//}
//
//boolean zoneIsActive(byte brewZone) {
//  if (brewZone == ZONE_MASH) {
//    if (stepIsActive(STEP_FILL) 
//      || stepIsActive(STEP_DELAY) 
//      || stepIsActive(STEP_PREHEAT)
//      || stepIsActive(STEP_ADDGRAIN) 
//      || stepIsActive(STEP_REFILL)
//      || stepIsActive(STEP_DOUGHIN) 
//      || stepIsActive(STEP_ACID)
//      || stepIsActive(STEP_PROTEIN) 
//      || stepIsActive(STEP_SACCH)
//      || stepIsActive(STEP_SACCH2) 
//      || stepIsActive(STEP_MASHOUT)
//      || stepIsActive(STEP_MASHHOLD) 
//      || stepIsActive(STEP_SPARGE)
//    ) return 1; else return 0;
//  } else if (brewZone == ZONE_BOIL) {
//    if (stepIsActive(STEP_BOIL) 
//      || stepIsActive(STEP_CHILL) 
//    ) return 1; else return 0;
//  }
//}
//
////Returns 0 if start was successful or 1 if unable to start due to conflict with other step
////Performs any logic required at start of step
////TO DO: Power Loss Recovery Handling
//boolean stepInit(byte pgm, byte brewStep) {
//
//  //Nothing more to do if starting 'Idle' program
//  if(pgm == PROGRAM_IDLE) return 1;
//  
//  //Abort Fill/Mash step init if mash Zone is not free
//  if (brewStep >= STEP_FILL && brewStep <= STEP_MASHHOLD && zoneIsActive(ZONE_MASH)) return 1;  
//  //Abort sparge init if either zone is currently active
//  else if (brewStep == STEP_SPARGE && (zoneIsActive(ZONE_MASH) || zoneIsActive(ZONE_BOIL))) return 1;  
//  //Allow Boil step init while sparge is still going
//
//  //If we made it without an abort, save the program number for stepCore
//  setProgramStep(brewStep, pgm);
//
//  if (brewStep == STEP_FILL) {
//  //Step Init: Fill
//    //Set Target Volumes
//    tgtVol[VS_HLT] = calcSpargeVol(pgm);
//    tgtVol[VS_MASH] = calcStrikeVol(pgm);
//    if (getProgMLHeatSrc(pgm) == VS_HLT) {
//      tgtVol[VS_HLT] = min(tgtVol[VS_HLT] + tgtVol[VS_MASH], getCapacity(VS_HLT));
//      tgtVol[VS_MASH] = 0;
//    }
//    #ifdef AUTO_FILL_START
//    autoValve[AV_FILL] = 1;
//    #endif
//
//    #ifdef SPARGE_IN_PUMP_CONTROL
//    prevSpargeVol[1] = 0xFFFFFFFF; // need to set to 0 when starting a new program so that the logic works properly
//    #endif
//
//  } else if (brewStep == STEP_DELAY) {
//  //Step Init: Delay
//    //Load delay minutes from EEPROM if timer is not already populated via Power Loss Recovery
//    if (!timerValue[TIMER_MASH]) setTimer(TIMER_MASH, getDelayMins());
//
//  } else if (brewStep == STEP_PREHEAT) {
//  //Step Init: Preheat
//    if (getProgMLHeatSrc(pgm) == VS_HLT) {
//      setSetpoint(TS_HLT, calcStrikeTemp(pgm));
//      #ifdef STRIKE_TEMP_OFFSET
//        setSetpoint(TS_HLT, setpoint[TS_HLT] + STRIKE_TEMP_OFFSET);
//      #endif
//      setSetpoint(TS_MASH, 0);
//      #ifdef MASH_PREHEAT_STRIKE
//        setSetpoint(TS_MASH, calcStrikeTemp(pgm));
//      #endif
//      #ifdef MASH_PREHEAT_STEP1
//        setSetpoint(TS_MASH, getFirstStepTemp(pgm));
//      #endif        
//    } else {
//      setSetpoint(TS_HLT, getProgHLT(pgm));
//      setSetpoint(TS_MASH, calcStrikeTemp(pgm));
//    }
//    #ifndef PID_FLOW_CONTROL
//    setSetpoint(VS_STEAM, getSteamTgt());
//    #endif
//    preheated[VS_HLT] = 0;
//    preheated[VS_MASH] = 0;
//    //No timer used for preheat
//    clearTimer(TIMER_MASH);
//    #ifdef MASH_PREHEAT_SENSOR
//    //Overwrite mash temp sensor address from EEPROM using the memory location of the specified sensor (sensor element number * 8 bytes)
//      PROMreadBytes(MASH_PREHEAT_SENSOR * 8, tSensor[TS_MASH], 8);
//    #endif
//  } else if (brewStep == STEP_ADDGRAIN) {
//  //Step Init: Add Grain
//    //Disable HLT and Mash heat output during 'Add Grain' to avoid dry running heat elements and burns from HERMS recirc
//    resetHeatOutput(VS_HLT);
//    resetHeatOutput(VS_MASH);
//    #ifndef PID_FLOW_CONTROL
//    setSetpoint(VS_STEAM, getSteamTgt());
//    #endif
//    setValves(vlvConfig[VLV_ADDGRAIN], 1);
//    if(getProgMLHeatSrc(pgm) == VS_HLT) {
//      unsigned long spargeVol = calcSpargeVol(pgm);
//      unsigned long mashVol = calcStrikeVol(pgm);
//      tgtVol[VS_HLT] = (min(spargeVol, getCapacity(VS_HLT)));
//      #ifdef VOLUME_MANUAL
//        // In manual volume mode show the target mash volume as a guide to the user
//        tgtVol[VS_MASH] = mashVol;
//      #endif
//      #ifdef AUTO_ML_XFER
//         autoValve[AV_SPARGEIN] = 1;
//      #endif
//    }
//  } else if (brewStep == STEP_REFILL) {
//  //Step Init: Refill
//    if (getProgMLHeatSrc(pgm) == VS_HLT) {
//      tgtVol[VS_HLT] = calcSpargeVol(pgm);
//      tgtVol[VS_MASH] = 0;
//    }
//
//  } else if (brewStep == STEP_DOUGHIN) {
//  //Step Init: Dough In
//    setSetpoint(TS_HLT, getProgHLT(pgm));
//    setSetpoint(TS_MASH, getProgMashTemp(pgm, MASH_DOUGHIN));
//    #ifndef PID_FLOW_CONTROL
//    setSetpoint(VS_STEAM, getSteamTgt());
//    #endif
//    preheated[VS_MASH] = 0;
//    //Set timer only if empty (for purposed of power loss recovery)
//    if (!timerValue[TIMER_MASH]) setTimer(TIMER_MASH, getProgMashMins(pgm, MASH_DOUGHIN)); 
//    //Leave timer paused until preheated
//    timerStatus[TIMER_MASH] = 0;
//    
//  } else if (brewStep == STEP_ACID) {
//  //Step Init: Acid Rest
//    setSetpoint(TS_HLT, getProgHLT(pgm));
//    setSetpoint(TS_MASH, getProgMashTemp(pgm, MASH_ACID));
//    #ifndef PID_FLOW_CONTROL
//    setSetpoint(VS_STEAM, getSteamTgt());
//    #endif
//    preheated[VS_MASH] = 0;
//    //Set timer only if empty (for purposed of power loss recovery)
//    if (!timerValue[TIMER_MASH]) setTimer(TIMER_MASH, getProgMashMins(pgm, MASH_ACID)); 
//    //Leave timer paused until preheated
//    timerStatus[TIMER_MASH] = 0;
//    
//  } else if (brewStep == STEP_PROTEIN) {
//  //Step Init: Protein
//    setSetpoint(TS_HLT, getProgHLT(pgm));
//    setSetpoint(TS_MASH, getProgMashTemp(pgm, MASH_PROTEIN));
//    #ifndef PID_FLOW_CONTROL
//    setSetpoint(VS_STEAM, getSteamTgt());
//    #endif
//    preheated[VS_MASH] = 0;
//    //Set timer only if empty (for purposed of power loss recovery)
//    if (!timerValue[TIMER_MASH]) setTimer(TIMER_MASH, getProgMashMins(pgm, MASH_PROTEIN)); 
//    //Leave timer paused until preheated
//    timerStatus[TIMER_MASH] = 0;
//    
//  } else if (brewStep == STEP_SACCH) {
//  //Step Init: Sacch
//    setSetpoint(TS_HLT, getProgHLT(pgm));
//    setSetpoint(TS_MASH, getProgMashTemp(pgm, MASH_SACCH));
//    #ifndef PID_FLOW_CONTROL
//    setSetpoint(VS_STEAM, getSteamTgt());
//    #endif
//    preheated[VS_MASH] = 0;
//    //Set timer only if empty (for purposed of power loss recovery)
//    if (!timerValue[TIMER_MASH]) setTimer(TIMER_MASH, getProgMashMins(pgm, MASH_SACCH)); 
//    //Leave timer paused until preheated
//    timerStatus[TIMER_MASH] = 0;
//    
//  } else if (brewStep == STEP_SACCH2) {
//  //Step Init: Sacch2
//    setSetpoint(TS_HLT, getProgHLT(pgm));
//    setSetpoint(TS_MASH, getProgMashTemp(pgm, MASH_SACCH2));
//    #ifndef PID_FLOW_CONTROL
//    setSetpoint(VS_STEAM, getSteamTgt());
//    #endif
//    preheated[VS_MASH] = 0;
//    //Set timer only if empty (for purposed of power loss recovery)
//    if (!timerValue[TIMER_MASH]) setTimer(TIMER_MASH, getProgMashMins(pgm, MASH_SACCH2)); 
//    //Leave timer paused until preheated
//    timerStatus[TIMER_MASH] = 0;
//    
//  } else if (brewStep == STEP_MASHOUT) {
//  //Step Init: Mash Out
//    setSetpoint(TS_HLT, getProgHLT(pgm));
//    setSetpoint(TS_MASH, getProgMashTemp(pgm, MASH_MASHOUT));
//    #ifndef PID_FLOW_CONTROL
//    setSetpoint(VS_STEAM, getSteamTgt());
//    #endif
//    preheated[VS_MASH] = 0;
//    //Set timer only if empty (for purposed of power loss recovery)
//    if (!timerValue[TIMER_MASH]) setTimer(TIMER_MASH, getProgMashMins(pgm, MASH_MASHOUT)); 
//    //Leave timer paused until preheated
//    timerStatus[TIMER_MASH] = 0;
//    
//  } else if (brewStep == STEP_MASHHOLD) {
//    //Set HLT to Sparge Temp
//    setSetpoint(TS_HLT, getProgSparge(pgm));
//    //Cycle through steps and use last non-zero step for mash setpoint
//    if (!setpoint[TS_MASH]) {
//      byte i = MASH_MASHOUT;
//      while (setpoint[TS_MASH] == 0 && i >= MASH_DOUGHIN && i <= MASH_MASHOUT) setSetpoint(TS_MASH, getProgMashTemp(pgm, i--));
//    }
//    #ifndef PID_FLOW_CONTROL
//    setSetpoint(VS_STEAM, getSteamTgt());
//    #endif
//
//  } else if (brewStep == STEP_SPARGE) {
//  //Step Init: Sparge
//    #ifdef BATCH_SPARGE
//    
//    #else
//      tgtVol[VS_KETTLE] = calcPreboilVol(pgm);
//      #ifdef AUTO_SPARGE_START
//        autoValve[AV_FLYSPARGE] = 1;
//      #endif
//      #ifdef PID_FLOW_CONTROL
//      #ifdef USEMETRIC
//      // value is given in 10ths of a liter per min, so 1 liter/min would be 10, and 10 * 100 = 1000 which is 1 liter/min in flow rate calcs
//      setSetpoint(VS_PUMP, (getSteamTgt() * 100));
//      #else
//      //value is given in 10ths of a quart per min, so 1 quart/min would be 10, and 10 *25 = 250 which is 1 quart/min in flow rate calcs (1000ths of a gallon/min)
//      setSetpoint(VS_PUMP, getSteamTgt()*25);
//      #endif
//      #endif
//    #endif
//
//  } else if (brewStep == STEP_BOIL) {
//  //Step Init: Boil
//    #ifdef PID_FLOW_CONTROL
//    resetHeatOutput(VS_PUMP); // turn off the pump if we are moving to boil. 
//    #endif
//    setSetpoint(VS_KETTLE, getBoilTemp());
//    preheated[VS_KETTLE] = 0;
//    boilAdds = getProgAdds(pgm);
//    
//    //Set timer only if empty (for purposes of power loss recovery)
//    if (!timerValue[TIMER_BOIL]) {
//      //Clean start of Boil
//      setTimer(TIMER_BOIL, getProgBoil(pgm));
//      triggered = 0;
//      setBoilAddsTrig(triggered);
//    } else {
//      //Assuming power loss recovery
//      triggered = getBoilAddsTrig();
//    }
//    //Leave timer paused until preheated
//    timerStatus[TIMER_BOIL] = 0;
//    lastHop = 0;
//    doAutoBoil = 1;
//    
//  } else if (brewStep == STEP_CHILL) {
//  //Step Init: Chill
//    pitchTemp = getProgPitch(pgm);
//  }
//
//  //Call event handler
//  eventHandler(EVENT_STEPINIT, brewStep);  
//  return 0;
//}
//
//void stepCore() {
//  if (stepIsActive(STEP_FILL)) stepFill(STEP_FILL);
//
//  if (stepIsActive(STEP_PREHEAT)) {
//    if ((setpoint[VS_MASH] && temp[VS_MASH] >= setpoint[VS_MASH])
//      || (!setpoint[VS_MASH] && temp[VS_HLT] >= setpoint[VS_HLT])
//    ) stepAdvance(STEP_PREHEAT);
//  }
//
//  if (stepIsActive(STEP_DELAY)) if (timerValue[TIMER_MASH] == 0) stepAdvance(STEP_DELAY);
//
//  if (stepIsActive(STEP_ADDGRAIN)) {
//    #ifdef AUTO_GRAININ_EXIT
//      if(!autoValve[AV_SPARGEIN]) {
//        if (!grainInStart) grainInStart = millis();
//        else if ((millis() - grainInStart) / 1000 > AUTO_GRAININ_EXIT) stepAdvance(STEP_ADDGRAIN);
//      } 
//    #endif
//    //Turn off Sparge In AutoValve if tgtVol has been reached
//    if (autoValve[AV_SPARGEIN] && volAvg[VS_HLT] <= tgtVol[VS_HLT]) autoValve[AV_SPARGEIN] = 0;
//  }
//
//  if (stepIsActive(STEP_REFILL)) stepFill(STEP_REFILL);
//
//  for (byte brewStep = STEP_DOUGHIN; brewStep <= STEP_MASHOUT; brewStep++) if (stepIsActive(brewStep)) stepMash(brewStep);
//  
//  if (stepIsActive(STEP_MASHHOLD)) {
//    #ifdef SMART_HERMS_HLT
//      smartHERMSHLT();
//    #endif
//    #ifdef AUTO_MASH_HOLD_EXIT
//      if (!zoneIsActive(ZONE_BOIL)) stepAdvance(STEP_MASHHOLD);
//    #endif
//  }
//  
//  if (stepIsActive(STEP_SPARGE)) { 
//    #ifdef BATCH_SPARGE
//    
//    #else
//      #ifdef AUTO_SPARGE_EXIT
//         if (volAvg[VS_KETTLE] >= tgtVol[VS_KETTLE]) stepAdvance(STEP_SPARGE);
//      #endif
//    #endif
//  }
//  
//  if (stepIsActive(STEP_BOIL)) {
//    if (doAutoBoil) {
//      if(temp[TS_KETTLE] < setpoint[TS_KETTLE]) PIDOutput[VS_KETTLE] = PIDCycle[VS_KETTLE] * PIDLIMIT_KETTLE;
//      else PIDOutput[VS_KETTLE] = PIDCycle[VS_KETTLE] * min(boilPwr, PIDLIMIT_KETTLE);
//    }
//    #ifdef PREBOIL_ALARM
//      if (!(triggered & 32768) && temp[TS_KETTLE] >= PREBOIL_ALARM) {
//        setAlarm(1);
//        triggered |= 32768; 
//        setBoilAddsTrig(triggered);
//      }
//    #endif
//    if (!preheated[VS_KETTLE] && temp[TS_KETTLE] >= setpoint[VS_KETTLE] && setpoint[VS_KETTLE] > 0) {
//      preheated[VS_KETTLE] = 1;
//      //Unpause Timer
//      if (!timerStatus[TIMER_BOIL]) pauseTimer(TIMER_BOIL);
//    }
//    //Turn off hop valve profile after 5s
//    if ((vlvConfigIsActive(VLV_HOPADD)) && lastHop > 0 && millis() - lastHop > HOPADD_DELAY) {
//      setValves(vlvConfig[VLV_HOPADD], 0);
//      lastHop = 0;
//    }
//    if (preheated[VS_KETTLE]) {
//      //Boil Addition
//      if ((boilAdds ^ triggered) & 1) {
//        setValves(vlvConfig[VLV_HOPADD], 1);
//        lastHop = millis();
//        setAlarm(1); 
//        triggered |= 1; 
//        setBoilAddsTrig(triggered); 
//      }
//      //Timed additions (See hoptimes[] array at top of AutoBrew.pde)
//      for (byte i = 0; i < 10; i++) {
//        if (((boilAdds ^ triggered) & (1<<(i + 1))) && timerValue[TIMER_BOIL] <= hoptimes[i] * 60000) { 
//          setValves(vlvConfig[VLV_HOPADD], 1);
//          lastHop = millis();
//          setAlarm(1); 
//          triggered |= (1<<(i + 1)); 
//          setBoilAddsTrig(triggered);
//        }
//      }
//      #ifdef AUTO_BOIL_RECIRC
//      if (timerValue[TIMER_BOIL] <= AUTO_BOIL_RECIRC * 60000) setValves(vlvConfig[VLV_BOILRECIRC], 1);
//      #endif
//    }
//    //Exit Condition  
//    if(preheated[VS_KETTLE] && timerValue[TIMER_BOIL] == 0) stepAdvance(STEP_BOIL);
//  }
//  
//  if (stepIsActive(STEP_CHILL)) {
//    if (temp[TS_KETTLE] != -1 && temp[TS_KETTLE] <= KETTLELID_THRESH) {
//      if (!vlvConfigIsActive(VLV_KETTLELID)) setValves(vlvConfig[VLV_KETTLELID], 1);
//    } else {
//      if (vlvConfigIsActive(VLV_KETTLELID)) setValves(vlvConfig[VLV_KETTLELID], 0);
//    }
//  }
//}
//
////stepCore logic for Fill and Refill
//void stepFill(byte brewStep) {
//  //Skip unnecessary refills
//  if (brewStep == STEP_REFILL) {
//    byte pgm = stepProgram[brewStep];
//    unsigned long HLTFillVol = calcSpargeVol(pgm);
//    if (getProgMLHeatSrc(pgm) == VS_HLT) HLTFillVol += calcStrikeVol(pgm);
//    if (HLTFillVol <= getCapacity(VS_HLT)) stepAdvance(brewStep);
//  }
//
//  #ifdef AUTO_FILL_EXIT
//    if (volAvg[VS_HLT] >= tgtVol[VS_HLT] && volAvg[VS_MASH] >= tgtVol[VS_MASH]) stepAdvance(brewStep);
//  #endif
//}
//
////stepCore Logic for all mash steps
//void stepMash(byte brewStep) {
//  #ifdef SMART_HERMS_HLT
//    smartHERMSHLT();
//  #endif
//  if (!preheated[VS_MASH] && temp[TS_MASH] >= setpoint[VS_MASH]) {
//    preheated[VS_MASH] = 1;
//    //Unpause Timer
//    if (!timerStatus[TIMER_MASH]) pauseTimer(TIMER_MASH);
//  }
//  //Exit Condition (and skip unused mash steps)
//  if (setpoint[VS_MASH] == 0 || (preheated[VS_MASH] && timerValue[TIMER_MASH] == 0)) stepAdvance(brewStep);
//}
//
////Advances program to next brew step
////Returns 0 if successful or 1 if unable to advance due to conflict with another step
//boolean stepAdvance(byte brewStep) {
//  //Save program for next step/rollback
//  byte program = stepProgram[brewStep];
//  stepExit(brewStep);
//  //Advance step (if applicable)
//  if (brewStep + 1 < NUM_BREW_STEPS) {
//    if (stepInit(program, brewStep + 1)) {
//      //Init Failed: Rollback
//      stepExit(brewStep + 1); //Just to make sure we clean up a partial start
//      setProgramStep(program, brewStep); //Show the step we started with as active
//      return 1;
//    }
//    //Init Successful
//    return 0;
//  }
//}

//Performs exit logic specific to each step
//Note: If called directly (as opposed through stepAdvance) acts as a program abort
void stepExit(byte pit, byte brewStep) {
  //Mark step idle
  //setProgramStep(brewStep, PROGRAM_IDLE);
  
  //Perform step closeout functions  
  clearTimer(pit); 
  resetPit(pit);
}

unsigned int getFirstStepTemp(byte pgm) {
  // TODO : This is not returning the first temp of the program
  unsigned int firstStep = 0;
  byte i = STEP_ONE;
  while (firstStep == 0 && i <= STEP_FOUR) {
    firstStep = getProgStepTemp(pgm, i);
    #ifdef DEBUG_UI
      logStart_P(LOGDEBUG);
      logField("Checking Step Temp - Step ");
      logFieldI(i);
      logField("Value: ");
      logFieldI(firstStep);
      logEnd();
    #endif
    i++;
  }
  return firstStep;
}
