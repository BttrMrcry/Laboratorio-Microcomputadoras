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
	BSF STATUS,RP0
 	BCF STATUS,RP1
 	MOVLW H'00'
 	MOVWF TRISB
 	BCF STATUS,RP0
 	MOVLW B'00000000'
	MOVWF PORTB
loop2
	; ESTADO 1
	CLRF PORTB
	BSF PORTB, 6
	BSF PORTB, 0
	CALL retardo
	; ESTADO 2
	CLRF PORTB
	BSF PORTB, 5
	BSF PORTB, 0
	CALL retardo
	; ESTADO 3
	CLRF PORTB
	BSF PORTB, 4
	BSF PORTB, 2
	CALL retardo
	; ESTADO 4
	CLRF PORTB
	BSF PORTB, 4
	BSF PORTB, 1
 	CALL retardo

 	GOTO loop2
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