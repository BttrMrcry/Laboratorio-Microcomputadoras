processor 16f877
include <p16f877.inc>
; Registros para guardar los contadores auxiliares para el retardo.
valor1 equ h'21'
valor2 equ h'22'
valor3 equ h'23'
; Constantes que definen la duración del retardo.
cte1 equ 20h
cte2 equ 50h
cte3 equ 60h
 	ORG 0
GOTO INICIO
 	ORG 5
INICIO:
    ;Nos posicionamos en el banco 01
	BSF STATUS,RP0
 	BCF STATUS,RP1
    ;Configuramos el TRISB para que sea 'SALIDA'
 	MOVLW H'00'
 	MOVWF TRISB
    ;Direccionamiento directo
 	BCF STATUS,RP0
    ;Ponemos como valor inicial B'10000000' en el PORTB
 	MOVLW B'10000000'
	MOVWF PORTB
loop2
 	CALL retardo
    ;Hacemos el corrimiento a la derecha de PORTB
	RRF PORTB
 	GOTO loop2
retardo ;INICIA EL RETARDO
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
