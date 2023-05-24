/*
#include <16f877.h>
#fuses HS,NOPROTECT,
#use delay(clock=20M)
#org 0x1F00, 0x1FFF void loader16F877(void) {}

void main(){
    while(1){
      int a = input_a();
      //output_b(0xFF);
      //delay_ms(5000);
      //output_b(0x00);
      //delay_ms(5000);
      
      // Ej3
      output_b(a);
   } //while
}//main

*/

/*
#include <16f877.h>
#fuses HS,NOPROTECT,
#use delay(clock=20000000)
#use rs232(baud=9600, xmit=PIN_C6, rcv=PIN_C7)
#org 0x1F00, 0x1FFF void loader16F877(void) {}
void main(){
   while(1){
      output_b(0xff); //
      printf(" Todos los bits encendidos \n\r");
      delay_ms(1000);
      output_b(0x00);
      printf(" Todos los leds apagados \n\r");
      delay_ms(1000);
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
/*
#include <16F877.h>
#include <stdlib.h>
#fuses HS,NOWDT,NOPROTECT,NOLVP
#use delay(clock=20000000)
#use rs232(baud=9600, xmit=PIN_C6, rcv=PIN_C7)
#org 0x1F00, 0x1FFF void loader16F877(void) {}

void left_shift();
void right_shift();

void main() {
   int8 flag = FALSE; 
   while( TRUE ) {
      char input = getc();
      int8 option = input - 48;
      printf("%d", option);
      switch(option) {
         case 0:
            output_b(0x00);
            break;
         case 1:
            output_b(0xFF);
            break;
         case 2:
            left_shift();
            break;
         case 3:
            right_shift();
            break;
          case 4:
            left_shift();
            right_shift();
            break;
          case 5:
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
   int8 x = 128;
   while(x > 1) {
      x >>= 1;
      output_b(x);
      delay_ms(1000);
   }
}

void left_shift() {
   int8 x = 1;
   while(x < 128) {
      x <<= 1;
      output_b(x);
      delay_ms(1000);
      
   }
}
*/

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
