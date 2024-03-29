/*
    Copyright (C) 2011 Matt Reba (mattreba at oscsys dot com)
    Copyright (C) 2011 Timothy Reaves (treaves at silverfieldstech dot com)

    This file is part of OpenTroller.

    OpenTroller is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    OpenTroller is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with OpenTroller.  If not, see <http://www.gnu.org/licenses/>.


*/
#include "OTOutputAVRIO.h"
#include "OTOutputBankAVRIO.h"

#if defined OUTPUTBANK_AVRIO
using namespace OpenTroller;

OutputAVRIO::OutputAVRIO(void) {
    bank = NULL;
}

void OutputAVRIO::setup(OutputBankAVRIO* outputBank, uint8_t anIndex, uint8_t digitalPinNum) {
    bank = outputBank;
    index = anIndex;
    outputPin.setup(digitalPinNum, OUTPUT);
    outputPin.clear();
    err = 0;
}

void OutputAVRIO::setState(State newState) {
    if(state != newState) {
        state = newState;
        outputPin.set(state);
    }
}

State OutputAVRIO::getState(void) {
    return outputPin.get() ? State_LOW : State_HIGH;
}

#endif // #if defined OUTPUTBANK_AVRIO
