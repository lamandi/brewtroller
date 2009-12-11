void ftoa(float val, char retStr[], byte precision) {
  char lbuf[11];
  itoa(val, retStr, 10);  
  if(val < 0) val = -val;
  if( precision > 0) {
    strcat(retStr, ".");
    unsigned int mult = 1;
    for(byte i = 0; i< precision; i++) mult *=10;
    unsigned int frac = (val - int(val)) * mult;
    itoa(frac, lbuf, 10);
    for(byte i = 0; i < precision - (int)strlen(lbuf); i++) strcat(retStr, "0");
    strcat(retStr, lbuf);
  }
}

//Truncate a string representation of a float to (length) chars but do not end string with a decimal point
void truncFloat(char string[], byte length) {
  if (strlen(string) > length) {
    if (string[length - 1] == '.') string[length - 1] = '\0';
    else string[length] = '\0';
  }
}

void setValves (unsigned long vlvBitMask) {
  vlvBits = vlvBitMask;

#if MUXBOARDS > 0
//New MUX Valve Code
  //Disable outputs
  digitalWrite(MUX_OE_PIN, HIGH);
  //ground latchPin and hold low for as long as you are transmitting
  digitalWrite(MUX_LATCH_PIN, LOW);
  //clear everything out just in case to prepare shift register for bit shifting
  digitalWrite(MUX_DATA_PIN, LOW);
  digitalWrite(MUX_CLOCK_PIN, LOW);

  //for each bit in the long myDataOut
  for (byte i = 0; i < 32; i++)  {
    digitalWrite(MUX_CLOCK_PIN, LOW);
    //create bitmask to grab the bit associated with our counter i and set data pin accordingly (NOTE: 32 - i causes bits to be sent most significant to least significant)
    if ( vlvBitMask & ((unsigned long)1<<(31 - i)) ) digitalWrite(MUX_DATA_PIN, HIGH); else  digitalWrite(MUX_DATA_PIN, LOW);
    //register shifts bits on upstroke of clock pin  
    digitalWrite(MUX_CLOCK_PIN, HIGH);
    //zero the data pin after shift to prevent bleed through
    digitalWrite(MUX_DATA_PIN, LOW);
  }

  //stop shifting
  digitalWrite(MUX_CLOCK_PIN, LOW);
  digitalWrite(MUX_LATCH_PIN, HIGH);
  //Enable outputs
  digitalWrite(MUX_OE_PIN, LOW);
#endif
#ifdef ONBOARDPV
//Original 11 Valve Code
  if (vlvBitMask & 1) digitalWrite(VALVE1_PIN, HIGH); else digitalWrite(VALVE1_PIN, LOW);
  if (vlvBitMask & 2) digitalWrite(VALVE2_PIN, HIGH); else digitalWrite(VALVE2_PIN, LOW);
  if (vlvBitMask & 4) digitalWrite(VALVE3_PIN, HIGH); else digitalWrite(VALVE3_PIN, LOW);
  if (vlvBitMask & 8) digitalWrite(VALVE4_PIN, HIGH); else digitalWrite(VALVE4_PIN, LOW);
  if (vlvBitMask & 16) digitalWrite(VALVE5_PIN, HIGH); else digitalWrite(VALVE5_PIN, LOW);
  if (vlvBitMask & 32) digitalWrite(VALVE6_PIN, HIGH); else digitalWrite(VALVE6_PIN, LOW);
  if (vlvBitMask & 64) digitalWrite(VALVE7_PIN, HIGH); else digitalWrite(VALVE7_PIN, LOW);
  if (vlvBitMask & 128) digitalWrite(VALVE8_PIN, HIGH); else digitalWrite(VALVE8_PIN, LOW);
  if (vlvBitMask & 256) digitalWrite(VALVE9_PIN, HIGH); else digitalWrite(VALVE9_PIN, LOW);
  if (vlvBitMask & 512) digitalWrite(VALVEA_PIN, HIGH); else digitalWrite(VALVEA_PIN, LOW);
  if (vlvBitMask & 1024) digitalWrite(VALVEB_PIN, HIGH); else digitalWrite(VALVEB_PIN, LOW);
#endif
}
