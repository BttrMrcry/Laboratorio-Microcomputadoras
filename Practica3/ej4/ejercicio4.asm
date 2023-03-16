processor 16f877
include <p16f877.inc>
valor1 equ h'21'
valor2 equ h'22'
valor3 equ h'23'
cte1 equ 20h
cte2 equ 50h
cte3 equ 60h
 
    ORG 0
    GOTO INICIO
    ORG 5
INICIO:
    ;Selecciona el banco de memoria 1
    BSF STATUS,RP0
    BCF STATUS,RP1
    ;Configura todos los bits de puerto como salida
    MOVLW H'0'
    MOVWF TRISB
    ; Regresa al banco de memoria 0
    BCF STATUS,RP0
    ;Limpia todos los bits del puerto
    CLRF PORTB 
loop2 
    ;Enciende el led 0 encendiendo el bit 0 del 
    ;puerto B 
    BSF PORTB,0
    CALL retardo ;Rutina de retardo programable
    ;Apaga el led 0 apagando el bit 0 del 
    ;puerto B
    BCF PORTB,0
    CALL retardo
    GOTO loop2
 
;Rutina de retardo con varios ciclos anidados
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