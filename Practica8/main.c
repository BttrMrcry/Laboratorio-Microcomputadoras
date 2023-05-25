/*

uage 
*/

/*
#include <16f877.h>
#fuses HS,NOPROTECT,
#use delay(clock=20000000)
//Configura el puerto serial
#use rs232(baud=9600, xmit=PIN_C6, rcv=PIN_C7)
#org 0x1F00, 0x1FFF void loader16F877(void) {}
void main(){
   //ciclo  infinito
   while(1){
      output_b(0xff); //Enciende todos los leds
      //Escribe en el puerto serial
      printf(" Todos los bits encendidos \n\r");
      delay_ms(1000); //retardo de 1s
      output_b(0x00); //apaga los leds
      //escribe en el puerto serial
      printf("Todos los leds apagados \n\r");
      delay_ms(1000); // retardo de 1s
   }//while
}//main

*/

/*
#include <16F877.h>
#fuses HS,NOWDT,NOPROTECT,NOLVP
#use delay(clock=20000000)
#include <lcd.c>


void main() {
   lcd_init();
   while( TRUE ) {
      lcd_gotoxy(1,1);
      printf(lcd_putc," UNAM \n ");
      lcd_gotoxy(1,2);
      printf(lcd_putc," FI \n ");
      delay_ms(300);
    }
}
*/

#include <16F877.h>
#include <stdlib.h>
#fuses HS,NOWDT,NOPROTECT,NOLVP
#use delay(clock=20000000)
#use rs232(baud=9600, xmit=PIN_C6, rcv=PIN_C7)
#org 0x1F00, 0x1FFF void loader16F877(void) {}

//Prototipos de funciones
void left_shift();
void right_shift();

void main() {
   int8 flag = FALSE; 
   while( TRUE ) {
      //Le un caracter del puerto serie
      char input = getc();
      //Convierte el caracter a decimal
      int8 option = input - 48;
      printf("%d", option);
      //Elige el flujo correcto segun la 
      //opcion
      switch(option) {
         case 0:
            //apaga todos los leds
            output_b(0x00);
            break;
         case 1:
            //prende todos los leds 
            output_b(0xFF);
            break;
         case 2:
            //hace corrimiento a la izquierda
            left_shift();
            break;
         case 3:
            //hace corrimiento a la derecha
            right_shift();
            break;
          case 4:
            //hace zigzag
            left_shift();
            right_shift();
            break;
          case 5:
            //intercambia entre encendido y apagado
            if(flag){
               output_b(0x00);
            }else{
               output_b(0xFF);  
            }
            flag = !flag;
            break;
         default:
            break;
      }
   }
}

void right_shift() {
   //mascara
   int8 x = 128;
   //mientras aun haya al menos
   //un bit se hace el corrimiento
   while(x > 1) {
      x >>= 1; //hace el corrimiento
      output_b(x) //imprime la mascara;
      delay_ms(1000);
   }
}

void left_shift() {
   //mascara
   int8 x = 1;
   //Mientras aun no se desborde el 
   //numero se hace el corrimiento
   while(x < 128) {
      x <<= 1; //hace el corrimiento
      output_b(x); //imprime la máscara
      delay_ms(1000);
      
   }
}

/*
#include <16F877.h>
#fuses HS,NOWDT,NOPROTECT,NOLVP
#use delay(clock=20000000)
#include <lcd.c>


void main() {
   lcd_init();
   int8 count = 0;
   int8 last = 0;
   while( TRUE ) {
      int8 input = input_a();
      input &= 32;
      if(last == 0 && input){
         count++;
         last = 1;
      }
      if(input == 0){
         last = 0;
      }
   
      lcd_gotoxy(5,1);
      printf(lcd_putc," %d \n ", count);
      lcd_gotoxy(5,2);
      printf(lcd_putc," %x \n ", count);
    }
}
*/