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
BSF STATUS,RP0 ;Cambiamos al banco 1
BCF STATUS,RP1
MOVLW H'0'
MOVWF TRISB
BSF TXSTA,BRGH	;Activamos el BRGH
MOVLW D'129'
MOVWF SPBRG		;Configuramos el baud rate a 9600
BCF TXSTA,SYNC	;Configuramos la asincrona
BSF TXSTA,TXEN  ;Activamos el transmisor
BCF STATUS,RP0	;Volvemos al banco 0
BSF RCSTA,SPEN	;Habilitamos la recepcion
BSF RCSTA,CREN	;Habilitamos la recepcion continua
RECIBE:
BTFSS PIR1,RCIF	;Verificamos la bandera recepcion
GOTO RECIBE
MOVF RCREG,W	;Copiamos lo recibido a W
MOVWF Opcion
MOVLW .0
SUBWF Opcion, W
BTFSC STATUS,Z
GOTO CERO
MOVLW .1
SUBWF Opcion, W
BTFSC STATUS,Z
GOTO UNO
GOTO RECIBE

UNO:
MOVLW H'01'
GOTO CONTINUA
CERO:
MOVLW H'00'
GOTO CONTINUA

CONTINUA:
MOVWF TXREG	;Lo transmitimos
CLRF PORTB
MOVWF PORTB
BSF STATUS,RP0	;Vamos al banco 1
TRANSMITE:
BTFSS TXSTA,TRMT	;Comprobamos si ya termino de transmitir
GOTO TRANSMITE	
BCF STATUS,RP0	;Volvemos al banco 0
GOTO RECIBE
END