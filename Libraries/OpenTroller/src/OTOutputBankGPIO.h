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
#ifndef OT_OUTPUTBANK_GPIO_H
#define OT_OUTPUTBANK_GPIO_H

#include "OT_HWProfile.h"
#if (defined OPENTROLLER_OUTPUTS && defined OUTPUTBANK_GPIO)

#include <stdint.h>
#include "OTOutputBank.h"

namespace OpenTroller{

class Output;
class OutputGPIO;

/**
  * This class represents an output bank tied to GPIO (general purpose input output) pins.
  */
class OutputBankGPIO: public OutputBank {
    private:
        OutputGPIO* outputs;

    public:
        OutputBankGPIO(uint8_t pinCount);
        virtual ~OutputBankGPIO(void);
        virtual Output* getOutput(uint8_t index);
        void setup(uint8_t index, uint8_t digPinNum);
        virtual char* getName(void);
        virtual OutputBankType getType(void);
        virtual void update(void) { }
        friend class OutputGPIO;
};

} //namespace OpenTroller
#endif // #if (defined OPENTROLLER_OUTPUTS && defined OUTPUTBANK_GPIO)
#endif //ifndef OT_OUTPUTBANK_GPIO_H