#ifdef DIGITAL_INPUTS
  void trigInit() {
    for (byte i = 0; i < DIGITALIN_COUNT; i++) { triggers[i] = 0; }
    #if DIGIN_COUNT > 0
      digitalInPin[0].attachPCInt(RISING, trig0ISR);
    #endif
    #if DIGIN_COUNT > 1
      digitalInPin[1].attachPCInt(RISING, trig1ISR);
    #endif
    #if DIGIN_COUNT > 2
      digitalInPin[2].attachPCInt(RISING, trig2ISR);
    #endif
    #if DIGIN_COUNT > 3
      digitalInPin[3].attachPCInt(RISING, trig3ISR);
    #endif
    #if DIGIN_COUNT > 4
      digitalInPin[4].attachPCInt(RISING, trig4ISR);
    #endif
  }
  
  #if DIGIN_COUNT > 0
    void trig0ISR() { triggers[0] = 1; trigReset = millis(); }
  #endif
  #if DIGIN_COUNT > 1
    void trig1ISR() { triggers[1] = 1; trigReset = millis(); }
  #endif
  #if DIGIN_COUNT > 2
    void trig2ISR() { triggers[2] = 1; trigReset = millis(); }
  #endif
  #if DIGIN_COUNT > 3
    void trig3ISR() { triggers[3] = 1; trigReset = millis(); }
  #endif
  #if DIGIN_COUNT > 4
    void trig4ISR() { triggers[4] = 1; trigReset = millis(); }
  #endif
#endif
