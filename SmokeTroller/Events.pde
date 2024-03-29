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

void eventHandler(byte eventID, int eventParam) {
//  //Global Event handler
//  if (eventID == EVENT_STEPINIT) {
//    //Nothing to do here (Pass to UI handler below)
//  }
//  else if (eventID == EVENT_SETPOINT) {
//    //Setpoint Change (Update AutoValve Logic)
//    if (eventParam == PIT_1) { 
//      if (setpoint[PIT_1]) autoValve[AV_HLT] = 1; 
//      else { 
//        autoValve[AV_HLT] = 0; 
//        if (vlvConfigIsActive(VLV_HLTHEAT)) setValves(vlvConfig[VLV_HLTHEAT], 0); 
//      } 
//    }
//    else if (eventParam == PIT_2) { 
//      if (setpoint[PIT_2]) autoValve[AV_MASH] = 1; 
//      else { 
//        autoValve[AV_MASH] = 0; 
//        if (vlvConfigIsActive(VLV_MASHIDLE)) setValves(vlvConfig[VLV_MASHIDLE], 0); 
//        if (vlvConfigIsActive(VLV_MASHHEAT)) setValves(vlvConfig[VLV_MASHHEAT], 0); 
//      } 
//    }
//  }
//
//  
//  #ifndef NOUI
//  //Pass Event Info to UI Even Handler
//  uiEvent(eventID, eventParam);
//  #endif
}
