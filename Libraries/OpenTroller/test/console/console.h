/*
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
#ifndef OT_CONSOLE_H
#define OT_CONSOLE_H

#include <stdint.h>

#ifdef __cplusplus
extern "C"{
#endif

//void init();
void setup();
void loop();

#ifdef __cplusplus
} // extern "C"
#endif

namespace OpenTroller {

    class console {
      protected:

      public:

        void init();

        void update();
    };

    /**
      * The singleton instance of the console.
      */
    extern OpenTroller::console Console;
}
#endif // OT_CONSOLE_H
