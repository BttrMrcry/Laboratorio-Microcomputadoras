processor 16f877
include<p16f877.inc>
valor1 equ h'31'
valor2 equ h'32'
valor3 equ h'33'
cte1 equ 20h
cte2 equ 50h
cte3 equ 60h
Opcion equ H'34'
ORG 0
GOTO INICIO

ORG 5
INICIO
;Cambiamos al banco 1
BSF STATUS,RP0 
BCF STATUS,RP1
MOVLW H'0'
MOVWF TRISB
;Activamos el BRGH
BSF TXSTA,BRGH	
MOVLW D'129'
;Configuramos el baud rate a 9600
MOVWF SPBRG	
;Configuramos la asincrona	
BCF TXSTA,SYNC	
;Activamos el transmisor
BSF TXSTA,TXEN  
;Volvemos al banco 0
BCF STATUS,RP0
;Habilitamos la recepcion	
BSF RCSTA,SPEN	
;Habilitamos la recepcion continua
BSF RCSTA,CREN	
RECIBE:
;Verificamos la bandera recepcion
BTFSS PIR1,RCIF	
GOTO RECIBE
;Copiamos lo recibido a W
MOVF RCREG,W	
MOVWF Opcion
;Comparamos con 0
MOVLW .0
SUBWF Opcion, W
BTFSC STATUS,Z
GOTO CERO
;Comparamos con 1
MOVLW .1
SUBWF Opcion, W
BTFSC STATUS,Z
GOTO UNO
GOTO RECIBE

;Dependiendo de si se 
; recibio 0 o 1 se carga ese valor
; en el registro W
UNO:
MOVLW H'01'
GOTO CONTINUA
CERO:
MOVLW H'00'
GOTO CONTINUA

CONTINUA:
;Lo transmitimos
MOVWF TXREG	
CLRF PORTB
MOVWF PORTB
;Vamos al banco 1
BSF STATUS,RP0	
TRANSMITE:
;Comprobamos si ya termino de transmitir
BTFSS TXSTA,TRMT	
GOTO TRANSMITE
;Volvemos al banco 0	
BCF STATUS,RP0	
GOTO RECIBE
END