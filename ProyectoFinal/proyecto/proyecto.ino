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
#include <Wire.h>    // Incluimos la librería Wire.h que establece la comunicación con el protocolo I2C.            
#include <LiquidCrystal_I2C.h>    // Incluimos la librería para usar la pantalla LCD con el módulo I2C.
#include <Ds1302.h> // Incluimos la librería para usar el reloj DS1302.

const int rs = 12, en = 11, d4 = 5, d5 = 4, d6 = 3, d7 = 2; // Pines del LCD
const int RST = 6, DAT = 7, clk = 8;  // Pines del RTC

const int led = 10; // Pin del LED
const int buzzer = 9; // Pin del buzzer
bool alarmTriggered = false;  // Variable para saber si la alarma está activada
int alarmHour = 1000; // Variable para almacenar la hora de la alarma
int alarmMinute = 1000; // Variable para almacenar el minuto de la alarma

/* Variables para el LCD I2C y el reloj */
LiquidCrystal_I2C lcd(0x27, 12, 2); 
Ds1302 rtc(RST, clk, DAT);

/* Prototipos de funciones */
void setOrReset();
void alarmTrigger();

/* Arreglo de días de la semana */
const static char* WeekDays[] =
{
    "Lunes",
    "Martes",
    "Miercoles",
    "Jueves",
    "Viernes",
    "Sabado",
    "Domingo"
};

/* Función que se ejecuta para la configuración inicial de la alarma */
void setup() {
  lcd.init(); // Inicializar LCD
  lcd.backlight(); // Encender luz de fondo
  lcd.clear(); // Limpiar LCD
  pinMode(led, OUTPUT); // Configurar pin del LED como salida
  pinMode(buzzer, OUTPUT);  // Configurar pin del buzzer como salida
  // Configura el tamaño de la pantalla LCD (12x2)
  lcd.begin(12,2);
  // Inicia la comunicación serial a 9600 baudios
  Serial.begin(9600);
  // Inicializa el reloj
  rtc.init();
    /* Testea si el reloj está detenido y configura una fecha y hora para iniciarlo. */
    if (rtc.isHalted()) {
        Serial.println("RTC dentenido. Configura el tiempo...");
        /* Configura la fecha y hora para iniciar el reloj. */
        Ds1302::DateTime dt = {
            .year = 23,
            .month = Ds1302::MONTH_JUN,
            .day = 1,
            .hour = 11,
            .minute = 36,
            .second = 0,
            .dow = Ds1302::DOW_TUE
        };
        rtc.setDateTime(&dt); // Configura la fecha y hora en el RTC
    }
}
/* Variable auxiliar para almacenar el último minuto impreso en el LCD. */
int last_minute = 0;
void loop() {
    lcd.setCursor(0,0);    // Posiciona la primera letra en el segmento 0 de línea 1 (Se empieza a contar desde 0).            
    // get the current time
    Ds1302::DateTime now; // Obtén hora actual
    rtc.getDateTime(&now);  // Configura la hora actual en el RTC
    if (last_minute != now.minute) {
        lcd.clear(); // Limpiar LCD
        alarmTriggered = false; // Reiniciar alarma
        Serial.println("Puedes configurar la alarma presionando la letra 'C' seguido de enter"); // Mensaje en consola
        last_minute = now.minute; // Actualizar minuto
        Serial.print("20"); // Imprimir año
        Serial.print(now.year);   // 00-99
        Serial.print('-');
        if (now.month < 10) Serial.print('0');  // Imprimir mes
        Serial.print(now.month);   // 01-12
        Serial.print('-');  
        if (now.day < 10) Serial.print('0');  // Imprimir día
        Serial.print(now.day);     // 01-31
        Serial.print(' ');
        Serial.print(WeekDays[now.dow - 1]); // 1-7
        Serial.print(' ');
        if (now.hour < 10) Serial.print('0'); // Imprimir hora
        Serial.print(now.hour);    // 00-23
        Serial.print(':');
        if (now.minute < 10) Serial.print('0'); // Imprimir minuto
        Serial.print(now.minute);  // 00-59
        Serial.print(':');
        if (now.second < 10) Serial.print('0'); // Imprimir segundo
        Serial.print(now.second);  // 00-59
        Serial.println();
    }
    
    /* Si el minuto se encuentra entre 0 y 9, imprime un cero al principio. */
    String minuteToPrint;
    if(now.minute < 10){
      minuteToPrint = String("0")+String(now.minute);
    }else{
      minuteToPrint = String(now.minute);
    }

    /* Si la hora se encuentra entre 0 y 9, imprime un cero al principio. */
    String hourToPrint;
    if(now.hour < 10){
      hourToPrint = String("0")+String(now.hour);
    }else{
      hourToPrint = String(now.hour);
    }
    /* Imprime la hora en el LCD */
    String toPrint = hourToPrint + String(':')+ minuteToPrint;
    lcd.setCursor(0, 0);
    lcd.print(toPrint);

    /* Imprime el dia de la semana en el LCD */
    lcd.setCursor(0, 1);
    lcd.print(WeekDays[now.dow - 1]);

    /* Chequeo constante de reseteo de alarma o de la hora*/
    setOrReset();
    alarmTrigger(now);
    /* Delay de 100 milisegundos*/
    delay(100);
}

/* Función que activa la alarma */
void alarmTrigger(const Ds1302::DateTime &now) {
  /* Si la alarma no ha sido activada y la hora y minuto coinciden con la alarma, activar alarma */
  if(now.hour == alarmHour && now.minute == alarmMinute && !alarmTriggered) {
      alarmTriggered = true;
      /* Activar buzzer*/
      tone(buzzer, 70);      
      /* Ciclo PWM Encender Led*/
      Serial.println("Alarma activada");
      for(int i = 0; i < 256; i++){
        analogWrite(led, i);
        delay(10);
      }
  }else{
    return;
  }
}

/*
  Función que chequea si se quiere 
  configurar la alarma o resetearla.
*/
void setOrReset(){
    /* Variable que almacena la opción ingresada por el usuario */
    String option;
    if(Serial.available() > 0){
      option = Serial.readString();
      option.trim();
    }else{
      return;
    }
    /* La tecla 'C' configura la alarma */
    if(option.equals("C") || option.equals("c")){
      
      Serial.println("Escribe la hora de la alarma en el formato hh:mm");
      while(Serial.available() == 0); // Esperar a que se ingrese la hora
      
      /* Formateo de la función para imprimir en la terminal serial */
      String userInput = Serial.readString();
      userInput.trim();
      int indexColon = userInput.indexOf(':');
      String hourString = userInput.substring(0, indexColon);
      String minuteString = userInput.substring(indexColon + 1, userInput.length());

      /* Conversión de string a int (FORMATEO) */
      int hourInt = hourString.toInt();
      int minuteInt = minuteString.toInt();
      alarmHour = hourInt;
      alarmMinute = minuteInt;

      /* Imprimir en la terminal serial la hora de la alarma */
      Serial.println(String("Alarma configurada a las ") + String(alarmHour) +String(":")+String(alarmMinute) + String(" exitosamente."));
    }

    /* La tecla 'X' resetea la alarma */
    if(option.equals("X") || option.equals("x")){
      analogWrite(led, 0); // Apagar led
      noTone(buzzer); // Apagar buzzer
    }
}
