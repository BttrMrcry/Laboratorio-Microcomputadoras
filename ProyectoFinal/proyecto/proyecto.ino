/*
  LiquidCrystal Library - Hello World

 Demonstrates the use a 16x2 LCD display.  The LiquidCrystal
 library works with all LCD displays that are compatible with the
 Hitachi HD44780 driver. There are many of them out there, and you
 can usually tell them by the 16-pin interface.

 This sketch prints "Hello World!" to the LCD
 and shows the time.

  The circuit:
 * LCD RS pin to digital pin 12
 * LCD Enable pin to digital pin 11
 * LCD D4 pin to digital pin 5
 * LCD D5 pin to digital pin 4
 * LCD D6 pin to digital pin 3
 * LCD D7 pin to digital pin 2
 * LCD R/W pin to ground
 * LCD VSS pin to ground
 * LCD VCC pin to 5V
 * 10K resistor:
 * ends to +5V and ground
 * wiper to LCD VO pin (pin 3)

 Library originally added 18 Apr 2008
 by David A. Mellis
 library modified 5 Jul 2009
 by Limor Fried (http://www.ladyada.net)
 example added 9 Jul 2009
 by Tom Igoe
 modified 22 Nov 2010
 by Tom Igoe
 modified 7 Nov 2016
 by Arturo Guadalupi

 This example code is in the public domain.

 https://docs.arduino.cc/learn/electronics/lcd-displays

*/

// include the library code:
#include <LiquidCrystal.h>
#include <Ds1302.h>
// initialize the library by associating any needed LCD interface pin
// with the arduino pin number it is connected to
const int rs = 12, en = 11, d4 = 5, d5 = 4, d6 = 3, d7 = 2;
const int RST = 6, DAT = 7, clk = 8; 
const int led = 10;
const int buzzer = 9;
bool alarmTriggered = false;
int alarmHour = 1000;
int alarmMinute = 1000;

LiquidCrystal lcd(rs, en, d4, d5, d6, d7);
Ds1302 rtc(RST, clk, DAT);

void setOrReset();
void alarmTrigger();

const static char* WeekDays[] =
{
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
};


void setup() {

  pinMode(led, OUTPUT);
  pinMode(buzzer, OUTPUT);
  // set up the LCD's number of columns and rows:
  lcd.begin(16, 2);
  // Print a message to the LCD.
  lcd.print("hello, world!");
  Serial.begin(9600);
  rtc.init();
    // test if clock is halted and set a date-time (see example 2) to start it
    if (rtc.isHalted())
    {
        Serial.println("RTC is halted. Setting time...");
        Ds1302::DateTime dt = {
            .year = 23,
            .month = Ds1302::MONTH_MAY,
            .day = 31,
            .hour = 19,
            .minute = 49,
            .second = 0,
            .dow = Ds1302::DOW_TUE
        };
        rtc.setDateTime(&dt);
    }
    


}

void loop() {

    // get the current time
    Ds1302::DateTime now;
    rtc.getDateTime(&now);
    setOrReset();
    alarmTrigger(now);
    static uint8_t last_minute = 0;
    if (last_minute != now.minute)
    {
        alarmTriggered = false;
        Serial.println("Puedes configurar la alarma presionando la letra 'C' seguido de enter");
        last_minute = now.minute;

        Serial.print("20");
        Serial.print(now.year);    // 00-99
        Serial.print('-');
        if (now.month < 10) Serial.print('0');
        Serial.print(now.month);   // 01-12
        Serial.print('-');
        if (now.day < 10) Serial.print('0');
        Serial.print(now.day);     // 01-31
        Serial.print(' ');
        Serial.print(WeekDays[now.dow - 1]); // 1-7
        Serial.print(' ');
        if (now.hour < 10) Serial.print('0');
        Serial.print(now.hour);    // 00-23
        Serial.print(':');
        if (now.minute < 10) Serial.print('0');
        Serial.print(now.minute);  // 00-59
        Serial.print(':');
        if (now.second < 10) Serial.print('0');
        Serial.print(now.second);  // 00-59
        Serial.println();
    }

    delay(100);
}

void alarmTrigger(const Ds1302::DateTime &now) {
  if(now.hour == alarmHour && now.minute == alarmMinute && !alarmTriggered) {
      // Activar buzzer
      // Prender led
      alarmTriggered = true;
      Serial.println("Alarma activada");
      tone(buzzer, 50);
      delay(50);
      for(int i = 0; i < 256; i++){
        analogWrite(led, i);
        delay(10);
      }
  }else{
    return;
  }

  
}



void setOrReset(){
    
    String option;
    if(Serial.available() > 0){
      option = Serial.readString();
      option.trim();
    }else{
      return;
    }
    if(option.equals("C") || option.equals("c")){
      Serial.println("Escribe la hora de la alarma en el formato hh:mm");
      while(Serial.available() == 0);
      String userInput = Serial.readString();
      userInput.trim();
      int indexColon = userInput.indexOf(':');
      String hourString = userInput.substring(0, indexColon);
      String minuteString = userInput.substring(indexColon + 1, userInput.length());
      int hourInt = hourString.toInt();
      int minuteInt = minuteString.toInt();
      alarmHour = hourInt;
      alarmMinute = minuteInt;

      
      Serial.println(String("Alarma configurada a las ") + String(alarmHour) +String(":")+String(alarmMinute) + String(" exitosamente."));
    }
    if(option.equals("X") || option.equals("x")){
      analogWrite(led, 0);
      noTone(buzzer);
    }
}
