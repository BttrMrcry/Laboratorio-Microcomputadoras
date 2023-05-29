
/*
#include <16F877.h>
#fuses HS,NOWDT,NOPROTECT
//configuración del reloj
#use delay(clock=20000000)
//COnfiguración para poder usar el protocolo i2c
#use i2c(MASTER, SDA=PIN_C4, SCL=PIN_C3,SLOW, NOFORCE_SW)
#include <i2c_LCD.c>
int8 contador=0; //contador principal
int8 countAux = 0; //contador auxiliar
//Función para mandar el numero por el 
protocolo i2c 
void escribir_i2c(){
   i2c_start();
   i2c_write(0x42); //Direcion del esclavo
   i2c_write(contador); //El dato a escribir
   i2c_stop();
}
void main()
{  //Inicializacion de  la pantalla LCD
   lcd_init(0x4E, 16, 2);
   while(true)
   {
      //Elige la posicion de escritura 
      lcd_gotoxy(0,2);
      //Imprime el contador
      printf(lcd_putc,"Contador = %d", contador);
      //Escribe el numero por i2c
      escribir_i2c();
      //Escribe el numero en el puerto b
      output_d(contador);
      delay_ms(500);
      //Aumenta los contadores
      contador++;
      countAux++;
      //Si se cuenta hasta 10, se aplica un corrimiento 
      //a la suma principal
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
//COnfiguracion del protocolo i2c
#use i2c(MASTER, SDA=PIN_C4, SCL=PIN_C3,SLOW, NOFORCE_SW)
//Bibliteca para el uso de la pantalla LCD
#include <i2c_LCD.c>

//Funcion para obtener la potencia de un numero 

int8 power(int8 base, int8 p){
   int res = 1;
   for(int i = 0; i < p; i++){
      res *= base;
   }
   return res;
}
//Funcion para escribir con el protocolo 12c
//dato: calor a escribir por i2c
void escribir_i2c(int8 dato){
   i2c_start();
   i2c_write(0x42); //Direcion del esclavo
   i2c_write(dato); //El dato a escribir
   i2c_stop();
}
//función que convierte un numero decimal de tal
//manera que se muestre correctamente en un decodificador 
//para numeros hexadecimales
int8 dec2Hex(int8 dato){
   int8 res = 0;
   int8 pos = 0;
   //Mientras el numero aun tenga digitos este se multiplicara
   //por la potencia de 16 correspondiente.
   while(dato > 0){
      int8 digito = dato % 10;
      dato /= 10;
      res += power(16, pos) * digito;
      pos++;
   }
   return res;
   
}
//Funcion que lee un por el protocolo i2c
int8 leer_i2c(){
   int8 dato;
   i2c_start();
   i2c_write(0x45); //Direcion del esclavo
   dato = i2c_read(); //El dato a escribir
   i2c_read(0);//cierre de comunciacion 
   i2c_stop();
   return dato;
}
void main()
{  
   //configuracion de la pantalla lcd
   lcd_init(0x4E, 16, 2);

   while(true)
   {  
      //limpia la pantalla lcd
      printf(lcd_putc,"          ");
      //lee un dato con el protocolo
      //i2c
      int8 dato = leer_i2c();
      //Se mueve a la posicion correcta
      //de la pantalla
      lcd_gotoxy(0,2);
      //Imprime el valor en la pantalla lcd
      printf(lcd_putc,"Dato = %d", dato);
      //Manda al display de 7 segmentos el valor 
      //convertido
      escribir_i2c(dec2Hex(dato));
      //Manda al otro display de 7 segmentos el valor 
      //convertido
      output_d(dec2Hex(dato));
      delay_ms(500);

}
}

