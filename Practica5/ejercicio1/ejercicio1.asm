processor 16f877
include <p16f877.inc>
valor1 equ h'21'
valor2 equ h'22'
valor3 equ h'23'
cte1 equ h'ff'
cte2 equ 50h
cte3 equ 60h
 	ORG 0
GOTO INICIO
 	ORG 5
INICIO:
	CLRF PORTA
	BSF STATUS,RP0
 	BCF STATUS,RP1
	;Coinfigura los puertos B y C
	;como salidas
 	MOVLW H'00'
 	MOVWF TRISB
	MOVWF TRISC
	;Configura el puerto A como
	;digital
	MOVLW 06H
	MOVWF ADCON1
	;Configura el puerto A como entrada
	MOVLW 3FH
	MOVWF TRISA
 	BCF STATUS,RP0
	;Limpia los puertos B y C
	MOVLW B'00000000'
	MOVWF PORTB
	MOVWF PORTC

loop1:

	; Loop principal. Dependiendo
	; de la posición del switch
	; se digirge el programa al 
	;flujo correcto
	MOVLW h'00'	
	SUBWF PORTA, W
	BTFSC STATUS, Z
	GOTO PARO_PARO

	MOVLW h'01'	
	SUBWF PORTA, W
	BTFSC STATUS, Z
	GOTO PARO_H

	MOVLW h'02'	
	SUBWF PORTA, W
	BTFSC STATUS, Z
	GOTO PARO_AH

	MOVLW h'03'	
	SUBWF PORTA, W
	BTFSC STATUS, Z
	GOTO H_PARO

	MOVLW h'04'	
	SUBWF PORTA, W
	BTFSC STATUS, Z
	GOTO AH_PARO

	MOVLW h'05'	
	SUBWF PORTA, W
	BTFSC STATUS, Z
	GOTO H_H

	MOVLW h'06'	
	SUBWF PORTA, W
	BTFSC STATUS, Z
	GOTO AH_AH

	MOVLW h'07'	
	SUBWF PORTA, W
	BTFSC STATUS, Z
	GOTO H_AH

	MOVLW h'08'	
	SUBWF PORTA, W
	BTFSC STATUS, Z
	GOTO AH_H

goto loop1	

;Para cada sentido de giro 
;de los motores solicitado
;se activa el motor con el 
; portc y con el portb se 
; determina la dirección de 
;giro 

PARO_PARO:
	BCF PORTC, 2
	BCF PORTC, 1
	GOTO loop1

PARO_H:
	BCF PORTC, 2
	BSF PORTC, 1
	BSF PORTB, 0
	BCF PORTB, 1
	GOTO loop1

PARO_AH
	BCF PORTC, 2
	BSF PORTC, 1
	BSF PORTB, 1
	BCF PORTB, 0
	GOTO loop1

H_PARO:
	BCF PORTC, 1
	BSF PORTC, 2
	BSF PORTB, 2
	BCF PORTB, 3
	GOTO loop1

AH_PARO:
	BCF PORTC, 1
	BSF PORTC, 2
	BSF PORTB, 3
	BCF PORTB, 2
	GOTO loop1

H_H:
	BSF PORTC, 1
	BSF PORTC, 2
	BSF PORTB, 2
	BCF PORTB, 3
	BSF PORTB, 0
	BCF PORTB, 1
	GOTO loop1

AH_AH
	BSF PORTC, 1
	BSF PORTC, 2
	BSF PORTB, 3
	BCF PORTB, 2
	BSF PORTB, 1
	BCF PORTB, 0
	GOTO loop1
	
H_AH
	BSF PORTC, 1
	BSF PORTC, 2
	BSF PORTB, 2
	BCF PORTB, 3
	BSF PORTB, 1
	BCF PORTB, 0
	GOTO loop1

AH_H
	BSF PORTC, 1
	BSF PORTC, 2
	BSF PORTB, 3
	BCF PORTB, 2
	BSF PORTB, 0
	BCF PORTB, 1
	GOTO loop1
	