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
#include "wiring_private.h"

#include "Config.h"
#include "Enum.h"

//#ifdef PID_FLOW_CONTROL 
//  #define LAST_HEAT_OUTPUT VS_PUMP // not this is mostly done for code readability as VS_PUMP = VS_STEAM
//  
//  #ifndef PWM_8K_1
//    #ifndef PWM_8k_2
//      #ERROR //fail build, we need at least 1 8k outputs for the pump and it must match the pump output
//    #else
//      #if PWM_8K_2 != VS_PUMP
//        #ERROR //fail build, if only PWM_8k_2 is defined, it MUST equal the pump to pass here
//      #endif
//    #endif
//  #else
//    #ifndef PWM_8K_2
//      #if PWM_8K_1 != VS_PUMP
//        #ERROR //fail build, if only PWM_8k_1 is defined, it MUST equal the pump to pass here
//      #endif
//    #else
//      #if !(PWM_8K_1 != VS_PUMP || PWM_8K_2 != VS_PUMP)
//        #ERROR //fail build, if both are defined one of them must be VS_PUMP
//      #endif
//    #endif
//  #endif
//#else
//#ifdef USESTEAM
//  #define LAST_HEAT_OUTPUT VS_STEAM
//#else
//  #define LAST_HEAT_OUTPUT VS_KETTLE
//#endif
//#endif
//
//#ifdef PWM_8K_1
// #ifndef PWM_BY_TIMER
//  #ERROR // cannot have this defined and not have PWM_BY_TIMER on
// #endif
// #ifdef PWM_8K_2
//  #if PWM_8K_2 == PWM_8K_1
//   #ERROR // fail the build as they cannot equal eachother
//  #endif
// #endif
//#endif
//
//#ifdef PWM_8K_2
// #ifndef PWM_BY_TIMER
//  #ERROR // cannot have this defined and not have PWM_BY_TIMER on
// #endif
//#endif
//
//// set what the PID cycle time should be based on how fast the temp sensors will respond
//#if TS_ONEWIRE_RES == 12
//  #define PID_CYCLE_TIME 750
//#elif TS_ONEWIRE_RES == 11
//  #define PID_CYCLE_TIME 375
//#elif TS_ONEWIRE_RES == 10
//  #define PID_CYCLE_TIME 188
//#elif TS_ONEWIRE_RES == 9
//  #define PID_CYCLE_TIME 94
//#else
//  // should not be this value, fail the compile
//  #ERROR
//#endif
//
//#ifdef PWM_BY_TIMER
//// note there are some assumptions here, we assume that the COM1A1, COM1B1, COM1A0, and COM1B0 
//// bits are all 0 (as they should be on power up)
//void pwmInit( void )
//{
//    // set timer 1 prescale factor to 0
//    sbi(TCCR1B, CS11);
//    cbi(TCCR1B, CS12);
//    cbi(TCCR1B, CS10);
//
//    //clear timer 1 out of 8 bit phase correct PWM mode from sanguino init
//    cbi(TCCR1A, WGM10);
//    //set timer 1 into 16 bit phase and frequency correct PWM mode with ICR1 as TOP
//    sbi(TCCR1A, WGM13);
//    //set TOP as 1000, which makes the overflow on return to bottom for this mode happen ever 
//    // 125uS given a 16mhz input clock, aka 8khz PWM frequency, the overflow ISR will handle 
//    // the PWM outputs that are slower than 8khz, and the OCR1A/B ISR will handle the 8khz PWM outputs
//    ICR1 = 1000; 
//
//    //enable timer 1 overflow interrupt (in this mode overflow happens when the timer counds down to BOTTOM
//    // after counting UP from BOTTOM to TOP. 
//    sbi(TIMSK1, TOIE1);
//
//    #ifdef PWM_8K_1
//    //enable timer 1 output compare A interrupt
//    sbi(TIMSK1, OCIE1A);
//    #endif
//
//    #ifdef PWM_8K_2
//    //enable timer 1 output compare B interrupt
//    sbi(TIMSK1, OCIE1B);
//    #endif
//}
//
////note that the code in any SIGNAL function is an ISR, and the code needs to kept short and fast
//// it is important to avoid divides by non power of 2 numbers, remainder (mod) calculations, wait loops,
//// or calls to functions that have wait loops. It's also not a good idea to write into any global that may be 
//// used else where in the code inside here without interrupt protecting all accesses to that variable in 
//// non ISR code, or making sure that if we do write to it in the ISR, we dont write/read to it in non ISR code
//// (for example, below the heatPin objects are not written to if PIDEnable[i] = 1;
////
//// Also the below ISR is set to nonblock so that interrupts are enabled as we enter the function
//// this is done to make sure that we can run low counts in the compare registers, for example, 
//// a count of 1 could cause an interrupts 1 processor clock cycle after this interrupt is called 
//// sense it's called at bottom, and sense this has a fair amount of code in it, it's good to let the 
//// compare interrupts interrupt this interrupt (same with the UART and timer0 interrupts)
//ISR(TIMER1_OVF_vect, ISR_NOBLOCK )
//{
//    //count the number of times this has been called 
//    timer1_overflow_count++;
//    for(byte i = 0; i < LAST_HEAT_OUTPUT; i++)
//    {
//        // if PID is enabled, and NOT one of the 8khz PWM outputs then we can use this
//        if(PIDEnabled[i] 
//            #ifdef PWM_8K_1
//            && i != PWM_8K_1
//            #endif
//            #ifdef PWM_8K_2
//            && i != PWM_8K_2
//            #endif
//          )
//        {
//            //init the cyclestart counter if needed
//            if(cycleStart[i] == 0 ) cycleStart[i] = timer1_overflow_count; 
//            //if our period just ended, update to when the next period ends
//            if((timer1_overflow_count - cycleStart[i]) > PIDOutputCountEquivalent[i][0]) 
//                cycleStart[i] += PIDOutputCountEquivalent[i][0];
//            //check to see if the pin should be high or low (note when our 16 bit integer wraps we will have 1 period where 
//            // the PWM % if cut short, because from the time of wrap until the next period 
//            if (PIDOutputCountEquivalent[i][1] >= timer1_overflow_count - cycleStart[i] 
//                  && timer1_overflow_count != cycleStart[i]) 
//                heatPin[i].set(HIGH); else heatPin[i].set(LOW);
//        }
//    }
//}
//
//#ifdef PWM_8K_1
//ISR(TIMER1_COMPA_vect, ISR_BLOCK )
//{
//	if(PIDEnabled[PWM_8K_1])
//	{
//		//if the output is 1000, we need to set the pin to low 
//		if(PIDOutputCountEquivalent[PWM_8K_1][1] == 1000) heatPin[PWM_8K_1].set(LOW);
//		//if the output is its maxiumum then we just set the pin high 
//		else if(PIDOutputCountEquivalent[PWM_8K_1][1] == 0) heatPin[PWM_8K_1].set(HIGH);
//		// else we need to toggle the pin from its previous state
//		else
//		{
//			if(heatPin[PWM_8K_1].get()) heatPin[PWM_8K_1].set(LOW);
//			else heatPin[PWM_8K_1].set(HIGH);
//		}
//	}
//}
//#endif
//
//#ifdef PWM_8K_2
//ISR(TIMER1_COMPB_vect, ISR_BLOCK)
//{
//    if(PIDEnabled[PWM_8K_2])
//    {
//        //if the output is 1000, we need to set the pin to low 
//        if(PIDOutputCountEquivalent[PWM_8K_2][1] == 1000) heatPin[PWM_8K_2].set(LOW);
//        //if the output is its maxiumum then we just set the pin high 
//        else if(PIDOutputCountEquivalent[PWM_8K_2][1] == 0) heatPin[PWM_8K_2].set(HIGH);
//        // else we need to toggle the pin from its previous state
//        else
//        {
//            if(heatPin[PWM_8K_2].get()) heatPin[PWM_8K_2].set(LOW);
//            else heatPin[PWM_8K_2].set(HIGH);
//        }
//    }
//}
//#endif
//#endif
//
//
//void pinInit() {
//  alarmPin.setup(ALARM_PIN, OUTPUT);
//
//  #if MUXBOARDS > 0
//    muxLatchPin.setup(MUX_LATCH_PIN, OUTPUT);
//    muxDataPin.setup(MUX_DATA_PIN, OUTPUT);
//    muxClockPin.setup(MUX_CLOCK_PIN, OUTPUT);
//    muxOEPin.setup(MUX_OE_PIN, OUTPUT);
//    muxOEPin.set();
//  #endif
//  #ifdef ONBOARDPV
//    valvePin[0].setup(VALVE1_PIN, OUTPUT);
//    valvePin[1].setup(VALVE2_PIN, OUTPUT);
//    valvePin[2].setup(VALVE3_PIN, OUTPUT);
//    valvePin[3].setup(VALVE4_PIN, OUTPUT);
//    valvePin[4].setup(VALVE5_PIN, OUTPUT);
//    valvePin[5].setup(VALVE6_PIN, OUTPUT);
//    valvePin[6].setup(VALVE7_PIN, OUTPUT);
//    valvePin[7].setup(VALVE8_PIN, OUTPUT);
//    valvePin[8].setup(VALVE9_PIN, OUTPUT);
//    valvePin[9].setup(VALVEA_PIN, OUTPUT);
//    valvePin[10].setup(VALVEB_PIN, OUTPUT);
//  #endif
//  
//  heatPin[VS_HLT].setup(HLTHEAT_PIN, OUTPUT);
//  heatPin[VS_MASH].setup(MASHHEAT_PIN, OUTPUT);
//#ifdef HLT_AS_KETTLE
//  heatPin[VS_KETTLE].setup(HLTHEAT_PIN, OUTPUT);
//#else
//  heatPin[VS_KETTLE].setup(KETTLEHEAT_PIN, OUTPUT);
//#endif
//
//#ifdef USESTEAM
//  heatPin[VS_STEAM].setup(STEAMHEAT_PIN, OUTPUT);
//#endif
//#ifdef PID_FLOW_CONTROL
//  heatPin[VS_PUMP].setup(PWMPUMP_PIN, OUTPUT);
//#endif
//}
//
//void pidInit() {
//  //note that the PIDCycle for the 8khz outputs is set to 10 because the TOP of the counter/timer is set to 1000
//  // this means that after it is multiplied by the PIDLIMIT it will be the proper value to give you the desired % output
//  // it also makes the % calculations work properly in the log, UI, and other area's. 
//  #ifdef PWM_8K_1
//  PIDCycle[PWM_8K_1] = 10;
//  PIDOutputCountEquivalent[PWM_8K_1][1] = 1000; // this sets the output to 0 duty cycle, to make sure we dont pulse the pin high before we do our first PID calculation with a setpoint of 0
//  #endif
//  #ifdef PWM_8K_2
//  PIDCycle[PWM_8K_2] = 10;
//  PIDOutputCountEquivalent[PWM_8K_2][1] = 1000; // this sets the output to 0 duty cycle, to make sure we dont pulse the pin high before we do our first PID calculation with a setpoint of 0
//  #endif
//  
//  pid[VS_HLT].SetInputLimits(0, 25500);
//  pid[VS_HLT].SetOutputLimits(0, PIDCycle[VS_HLT] * PIDLIMIT_HLT);
//  pid[VS_HLT].SetTunings(getPIDp(VS_HLT), getPIDi(VS_HLT), getPIDd(VS_HLT));
//  pid[VS_HLT].SetMode(AUTO);
//  pid[VS_HLT].SetSampleTime(PID_CYCLE_TIME);
//
//  pid[VS_MASH].SetInputLimits(0, 25500);
//  pid[VS_MASH].SetOutputLimits(0, PIDCycle[VS_MASH] * PIDLIMIT_MASH);
//  pid[VS_MASH].SetTunings(getPIDp(VS_MASH), getPIDi(VS_MASH), getPIDd(VS_MASH));
//  pid[VS_MASH].SetMode(AUTO);
//  pid[VS_MASH].SetSampleTime(PID_CYCLE_TIME);
//
//  pid[VS_KETTLE].SetInputLimits(0, 25500);
//  pid[VS_KETTLE].SetOutputLimits(0, PIDCycle[VS_KETTLE] * PIDLIMIT_KETTLE);
//  pid[VS_KETTLE].SetTunings(getPIDp(VS_KETTLE), getPIDi(VS_KETTLE), getPIDd(VS_KETTLE));
//  pid[VS_KETTLE].SetMode(MANUAL);
//  pid[VS_KETTLE].SetSampleTime(PID_CYCLE_TIME);
//
//#ifdef PID_FLOW_CONTROL
//#ifdef USEMETRIC
//  pid[VS_PUMP].SetInputLimits(0, 60000); // equivalent of 60 LPM
//#else
//  pid[VS_PUMP].SetInputLimits(0, 15000); // equivalent of 15 GPM
//#endif
//pid[VS_PUMP].SetOutputLimits(0, PIDCycle[VS_PUMP] * PIDLIMIT_STEAM);
//pid[VS_PUMP].SetTunings(getPIDp(VS_PUMP), getPIDi(VS_PUMP), getPIDd(VS_PUMP));
//pid[VS_PUMP].SetMode(AUTO);
//pid[VS_PUMP].SetSampleTime(FLOWRATE_READ_INTERVAL);
//
//#else
//  #ifdef USEMETRIC
//    pid[VS_STEAM].SetInputLimits(0, 50000000 / steamPSens);
//  #else
//    pid[VS_STEAM].SetInputLimits(0, 7250000 / steamPSens);
//  #endif
//  pid[VS_STEAM].SetOutputLimits(0, PIDCycle[VS_STEAM] * PIDLIMIT_STEAM);
//  pid[VS_STEAM].SetTunings(getPIDp(VS_STEAM), getPIDi(VS_STEAM), getPIDd(VS_STEAM));
//  pid[VS_STEAM].SetMode(AUTO);
//  pid[VS_STEAM].SetSampleTime(PID_CYCLE_TIME);
//#endif
//
//#ifdef DEBUG_PID_GAIN
//  for (byte vessel = VS_HLT; vessel <= VS_STEAM; vessel++) logDebugPIDGain(vessel);
//#endif
//}
//
void resetPitSteps(byte pit) {
  for (byte i = STEP_ONE; i <= STEP_FOUR; i++) stepExit(pit, i); //Go through each step's exit functions to quit clean.
}

void resetPit(byte pit) {
  setPitSetPoint(pit, 0);
  setFoodSetPoint(pit, 0); // should this be here? 
  PIDOutput[pit] = 0;   
  heatPin[pit].set(LOW); 
}  

////Sets the specified valves On or Off
//void setValves (unsigned long vlvBitMask, boolean value) {
//  
//  //Nothing to do with an empty valve profile
//  if(!vlvBitMask) return;
//  
//  if (value) vlvBits |= vlvBitMask;
//  else vlvBits = vlvBits ^ (vlvBits & vlvBitMask);
//  
//  #if MUXBOARDS > 0
//  //MUX Valve Code
//    //Disable outputs
//    //muxOEPin.set();
//    //ground latchPin and hold low for as long as you are transmitting
//    muxLatchPin.clear();
//    //clear everything out just in case to prepare shift register for bit shifting
//    muxDataPin.clear();
//    muxClockPin.clear();
//  
//    //for each bit in the long myDataOut
//    for (byte i = 0; i < 32; i++)  {
//      muxClockPin.clear();
//      //create bitmask to grab the bit associated with our counter i and set data pin accordingly (NOTE: 32 - i causes bits to be sent most significant to least significant)
//      if ( vlvBits & ((unsigned long)1<<(31 - i)) ) muxDataPin.set(); else muxDataPin.clear();
//      //register shifts bits on upstroke of clock pin  
//      muxClockPin.set();
//      //zero the data pin after shift to prevent bleed through
//      muxDataPin.clear();
//    }
//  
//    //stop shifting
//    muxClockPin.clear();
//    muxLatchPin.set();
//    //Enable outputs
//    muxOEPin.clear();
//  #endif
//  #ifdef ONBOARDPV
//  //Original 11 Valve Code
//  for (byte i = 0; i < 11; i++) { if (vlvBits & (1<<i)) valvePin[i].set(); else valvePin[i].clear(); }
//  #endif
//}
//
//void processHeatOutputs() {
//  //Process Heat Outputs
//  unsigned long millistemp;
//  #ifdef PWM_BY_TIMER
//  uint8_t oldSREG;
//  #endif
//  
//  for (byte i = VS_HLT; i <= LAST_HEAT_OUTPUT; i++) {
//    #ifdef HLT_AS_KETTLE
//      if (i == VS_KETTLE && setpoint[VS_HLT]) continue;
//    #endif
//    if (PIDEnabled[i]) {
//      if (i != VS_STEAM && i != VS_KETTLE && temp[i] <= 0) {
//        PIDOutput[i] = 0;
//      } else {
//        if (pid[i].GetMode() == AUTO) {
//      #ifdef PID_FLOW_CONTROL
//        if(i == VS_PUMP) PIDInput[i] = flowRate[VS_KETTLE];
//      #else
//        if (i == VS_STEAM) PIDInput[i] = steamPressure; 
//      #endif
//          else { 
//            PIDInput[i] = temp[i];
//  #ifdef PID_FEED_FORWARD
//            if(i == VS_MASH && setpoint[i] != 0) FFBias = temp[FEED_FORWARD_SENSOR];
//            else FFBias = 0; // found a bug where the mash output could be turned on if setpoint was 0 but FFBias was not 0. 
//  #endif
//          }
//          pid[i].Compute();
//        }
//      }
//      #ifndef PWM_BY_TIMER
//      //only 1 call to millis needed here, and if we get hit with an interrupt we still want to calculate based on the first read value of it
//      millistemp = millis();
//      if (cycleStart[i] == 0) cycleStart[i] = millistemp;
//      if (millistemp - cycleStart[i] > PIDCycle[i] * 100) cycleStart[i] += PIDCycle[i] * 100;
//      if (PIDOutput[i] >= millistemp - cycleStart[i] && millistemp != cycleStart[i]) heatPin[i].set(HIGH); else heatPin[i].set(LOW);
//      #else
//      //here we do as much math as we can OUT SIDE the ISR, we calculate the PWM cycle time in counter/timer counts
//      // and place it in the [i][0] value, then calculate the timer counts to get the desired PWM % and place it in [i][1]
//      if( 1
//      #ifdef PWM_8K_1
//          && i != PWM_8K_1
//      #endif
//      #ifdef PWM_8K_2
//          && i != PWM_8K_2
//      #endif
//        )
//      {
//         // need to disable interrupts so a write into here can finish before an interrupt can come in and read it
//         oldSREG = SREG;
//         cli();
//         PIDOutputCountEquivalent[i][0] = PIDCycle[i] * 800;
//         PIDOutputCountEquivalent[i][1] = PIDOutput[i] * 800;
//         SREG = oldSREG; // restore interrupts
//      }
//      else
//      {
//         //note that the subtract from 1000 part is here because the way the counter timer works by toggeling the output bit
//         // and the fact that the starting state of said bit is always 0 causes us to have to invert the logic. If we didnt subtract
//         // the value from 1000 the bit would be set high at say PIDOutput = 20 and left high until we counted up to 1000, then down 
//         // from 1000 to 20 then get set low again, thus 20 is your 20/2000 = 1% time low, not time on as is expected. 
//      #ifdef PWM_8K_1
//         if(i == PWM_8K_1)
//         {
//            // need to disable interrupts so a write into here can finish before an interrupt can come in and read it
//            oldSREG = SREG;
//            cli();
//            OCR1A = 1000 - (unsigned int)PIDOutput[i];
//            PIDOutputCountEquivalent[i][1] = 1000 - (unsigned int)PIDOutput[i];
//            SREG = oldSREG;
//         }
//      #endif
//      #ifdef PWM_8K_2 
//         if(i == PWM_8K_2)
//         {
//            // need to disable interrupts so a write into here can finish before an interrupt can come in and read it
//            oldSREG = SREG;
//            cli();
//            OCR1B = 1000 - (unsigned int)PIDOutput[i];
//            PIDOutputCountEquivalent[i][1] = 1000 - (unsigned int)PIDOutput[i];
//            SREG = oldSREG;
//         }
//      #endif
//      }
//      #endif
//      if (PIDOutput[i] == 0)  heatStatus[i] = 0; else heatStatus[i] = 1;
//    } else {
//      if (heatStatus[i]) {
//        if (
//          (i != VS_STEAM && (temp[i] <= 0 || temp[i] >= setpoint[i]))  
//            || (i == VS_STEAM && steamPressure >= setpoint[i])
//        ) {
//          heatPin[i].set(LOW);
//          heatStatus[i] = 0;
//        } else {
//          heatPin[i].set(HIGH);
//        }
//      } else {
//        if ((i != VS_STEAM && temp[i] > 0 && (setpoint[i] - temp[i]) >= hysteresis[i] * 10) 
//        || (i == VS_STEAM && (setpoint[i] - steamPressure) >= hysteresis[i] * 100)) {
//          heatPin[i].set(HIGH);
//          heatStatus[i] = 1;
//        } else {
//          heatPin[i].set(LOW);
//        }
//      }
//    }    
//  }
//}
//
//boolean vlvConfigIsActive(byte profile) {
//  //An empty valve profile cannot be active
//  if (!vlvConfig[profile]) return 0;
//  if ((vlvBits & vlvConfig[profile]) == vlvConfig[profile]) return 1; else return 0;
//}
//
//void processAutoValve() {
//  //Do Valves
//  if (autoValve[AV_FILL]) {
//    if (volAvg[VS_HLT] < tgtVol[VS_HLT]) setValves(vlvConfig[VLV_FILLHLT], 1);
//      else setValves(vlvConfig[VLV_FILLHLT], 0);
//      
//    if (volAvg[VS_MASH] < tgtVol[VS_MASH]) setValves(vlvConfig[VLV_FILLMASH], 1);
//      else setValves(vlvConfig[VLV_FILLMASH], 0);
//  } 
//  if (autoValve[AV_HLT]) {
//    if (heatStatus[VS_HLT]) {
//      if (!vlvConfigIsActive(VLV_HLTHEAT)) setValves(vlvConfig[VLV_HLTHEAT], 1);
//    } else {
//      if (vlvConfigIsActive(VLV_HLTHEAT)) setValves(vlvConfig[VLV_HLTHEAT], 0);
//    }
//  }
//  if (autoValve[AV_MASH]) {
//    if (heatStatus[VS_MASH]) {
//      if (vlvConfigIsActive(VLV_MASHIDLE)) setValves(vlvConfig[VLV_MASHIDLE], 0);
//      if (!vlvConfigIsActive(VLV_MASHHEAT)) setValves(vlvConfig[VLV_MASHHEAT], 1);
//    } else {
//      if (vlvConfigIsActive(VLV_MASHHEAT)) setValves(vlvConfig[VLV_MASHHEAT], 0);
//      if (!vlvConfigIsActive(VLV_MASHIDLE)) setValves(vlvConfig[VLV_MASHIDLE], 1); 
//    }
//  } 
//  if (autoValve[AV_SPARGEIN]) {
//    if (volAvg[VS_HLT] > tgtVol[VS_HLT]) setValves(vlvConfig[VLV_SPARGEIN], 1);
//      else setValves(vlvConfig[VLV_SPARGEIN], 0);
//  }
//  if (autoValve[AV_SPARGEOUT]) {
//    if (volAvg[VS_KETTLE] < tgtVol[VS_KETTLE]) setValves(vlvConfig[VLV_SPARGEOUT], 1);
//    else setValves(vlvConfig[VLV_SPARGEOUT], 0);
//  }
//  if (autoValve[AV_FLYSPARGE]) {
//    if (volAvg[VS_KETTLE] < tgtVol[VS_KETTLE]) {
//      #ifdef SPARGE_IN_PUMP_CONTROL
//      if(volAvg[VS_KETTLE] - prevSpargeVol[0] >= SPARGE_IN_HYSTERESIS)
//      {
//         setValves(vlvConfig[VLV_SPARGEIN], 1);
//         prevSpargeVol[0] = volAvg[VS_KETTLE];
//         prevSpargeVol[1] = volAvg[VS_HLT];
//      }
//      else if(prevSpargeVol[1] - volAvg[VS_HLT] >= SPARGE_IN_HYSTERESIS)
//      {
//         setValves(vlvConfig[VLV_SPARGEIN], 0);
//         prevSpargeVol[1] = volAvg[VS_HLT];
//      }
//      
//      #else
//      setValves(vlvConfig[VLV_SPARGEIN], 1);
//      #endif
//      setValves(vlvConfig[VLV_SPARGEOUT], 1);
//    } else {
//      setValves(vlvConfig[VLV_SPARGEIN], 0);
//      setValves(vlvConfig[VLV_SPARGEOUT], 0);
//    }
//  }
//  if (autoValve[AV_CHILL]) {
//    //Needs work
//    /*
//    //If Pumping beer
//    if (vlvConfigIsActive(VLV_CHILLBEER)) {
//      //Cut beer if exceeds pitch + 1
//      if (temp[TS_BEEROUT] > pitchTemp + 1.0) setValves(vlvConfig[VLV_CHILLBEER], 0);
//    } else {
//      //Enable beer if chiller H2O output is below pitch
//      //ADD MIN DELAY!
//      if (temp[TS_H2OOUT] < pitchTemp - 1.0) setValves(vlvConfig[VLV_CHILLBEER], 1);
//    }
//    
//    //If chiller water is running
//    if (vlvConfigIsActive(VLV_CHILLH2O)) {
//      //Cut H2O if beer below pitch - 1
//      if (temp[TS_BEEROUT] < pitchTemp - 1.0) setValves(vlvConfig[VLV_CHILLH2O], 0);
//    } else {
//      //Enable H2O if chiller H2O output is at pitch
//      //ADD MIN DELAY!
//      if (temp[TS_H2OOUT] >= pitchTemp) setValves(vlvConfig[VLV_CHILLH2O], 1);
//    }
//    */
//  }
//}
