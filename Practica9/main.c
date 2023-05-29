
/*
#include <16F877.h>
#fuses HS,NOWDT,NOPROTECT
#use delay(clock=20000000)
#use i2c(MASTER, SDA=PIN_C4, SCL=PIN_C3,SLOW, NOFORCE_SW)
#include <i2c_LCD.c>
int8 contador=0;
int8 countAux = 0;
void escribir_i2c(){

   i2c_start();
   i2c_write(0x42); //Direcion del esclavo
   i2c_write(contador); //El dato a escribir
   i2c_stop();
}
void main()
{  
   lcd_init(0x4E, 16, 2);
   while(true)
   {
      lcd_gotoxy(0,2);
      printf(lcd_putc,"Contador = %d", contador);
      escribir_i2c();
      output_d(contador);
      delay_ms(500);
      contador++;
      countAux++;
      if(countAux == 10){
      countAux = 0;
      contador += 6 ;
      }

}
}

*/

#include <16F877.h>
#fuses HS,NOWDT,NOPROTECT
#use delay(clock=20000000)
#use i2c(MASTER, SDA=PIN_C4, SCL=PIN_C3,SLOW, NOFORCE_SW)
#include <i2c_LCD.c>
int8 power(int8 base, int8 p){
   int res = 1;
   for(int i = 0; i < p; i++){
      res *= base;
   }
   return res;
}

void escribir_i2c(int8 dato){

   i2c_start();
   i2c_write(0x42); //Direcion del esclavo
   i2c_write(dato); //El dato a escribir
   i2c_stop();
}
int8 dec2Hex(int8 dato){
   int8 res = 0;
   int8 pos = 0;
   while(dato > 0){
      int8 digito = dato % 10;
      dato /= 10;
      res += power(16, pos) * digito;
      pos++;
   }
   return res;
   
}
int8 leer_i2c(){
   int8 dato;
   i2c_start();
   i2c_write(0x45); //Direcion del esclavo
   dato = i2c_read(); //El dato a escribir
   i2c_read(0);
   i2c_stop();
   return dato;
}
void main()
{  
   lcd_init(0x4E, 16, 2);
   while(true)
   {  
      printf(lcd_putc,"          ");
      int8 dato = leer_i2c();
      lcd_gotoxy(0,2);
      printf(lcd_putc,"Dato = %d", dato);
      escribir_i2c(dec2Hex(dato));
      output_d(dec2Hex(dato));
      delay_ms(500);

}
}

