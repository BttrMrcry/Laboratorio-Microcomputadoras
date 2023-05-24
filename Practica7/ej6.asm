processor 16f877
include<p16f877.inc>
valor1 equ h'31'
valor2 equ h'32'
valor3 equ h'33'
cte1 equ H'FF'
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

loop1:
call RECIBE
CLRF PORTC
CLRF PORTB
MOVLW H'41'
SUBWF Opcion, W
BTFSC STATUS,Z
GOTO H_H

MOVLW H'44'
SUBWF Opcion, W
BTFSC STATUS,Z
GOTO H_AH

MOVLW H'49'
SUBWF Opcion, W
BTFSC STATUS,Z
GOTO AH_H

MOVLW H'54'
SUBWF Opcion, W
BTFSC STATUS,Z
GOTO AH_AH

MOVLW H'53'
SUBWF Opcion, W
BTFSC STATUS,Z
GOTO PARO_PARO


PARO_PARO:
	BCF PORTC, 2
	BCF PORTC, 1
	GOTO loop1

PARO_H:
	BSF PORTC, 2
	BSF PORTC, 1
	BSF PORTB, 0
	BCF PORTB, 1
	GOTO loop1

H_PARO:
	BCF PORTC, 1
	BSF PORTC, 2
	BSF PORTB, 2
	BCF PORTB, 3
	GOTO loop1

AH_AH
	BSF PORTC, 1
	BSF PORTC, 2
	BSF PORTB, 3
	BCF PORTB, 2
	BSF PORTB, 0
	BCF PORTB, 1
	GOTO loop1

H_H:
	BSF PORTC, 1
	BSF PORTC, 2
	BSF PORTB, 2
	BCF PORTB, 3
	BSF PORTB, 1
	BCF PORTB, 0
	GOTO loop1


H_AH
	BSF PORTC, 1
	BSF PORTC, 2
	BSF PORTB, 3
	BCF PORTB, 2
	BSF PORTB, 1
	BCF PORTB, 0
	GOTO loop1

AH_H
	BSF PORTC, 1
	BSF PORTC, 2
	BSF PORTB, 2
	BCF PORTB, 3
	BSF PORTB, 0
	BCF PORTB, 1
	GOTO loop1

RECIBE
BTFSS PIR1,RCIF	;Verificamos la bandera recepcion
GOTO RECIBE
MOVF RCREG,W	;Copiamos lo recibido a W
MOVWF Opcion
return


retardo 
	MOVLW cte1
 	MOVWF valor1
tres 
	MOVLW cte2
	MOVWF valor2
dos 
	MOVLW cte3
	MOVWF valor3
uno 
	DECFSZ valor3
 	GOTO uno
	DECFSZ valor2
	GOTO dos
	DECFSZ valor1
	GOTO tres
	RETURN
END