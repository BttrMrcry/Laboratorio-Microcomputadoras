                                                           PROCESSOR 16f877
INCLUDE <p16f877.inc> 
I equ H'30'; valor adelante
J equ H'31'; valor atras
N equ H'32'; Numero de elementos a ordenar
CNT equ H'38'; Numero de iteraciones completadas  
	ORG 0
 	GOTO INICIO 
 	ORG 5
INICIO: 
	BCF STATUS,RP1
	BCF STATUS,RP0; BANCO 0
	MOVLW 0X21
	MOVWF FSR
	MOVLW H'f'
	MOVWF N
	MOVLW H'00'
	MOVWF CNT
LOOP0:
	MOVLW CNT
	SUBWF N, W
	BTFSC STATUS, Z
	GOTO END_LOOP0

LOOP1:
	MOVLW H'30'
	SUBWF FSR, W
	BTFSC STATUS, Z
	GOTO END_LOOP1
	;Logica de ordenamiento
	MOVF INDF, W
	MOVWF I
	DECF FSR
	MOVF INDF, W
	MOVWF J
	INCF FSR
	MOVF I, W
	SUBWF J, W  ; J - I
	BTFSC STATUS, C
	GOTO CHECK_Z
	;Es negativo
CONTINUE:
	;Fin de logica de ordenamiento
	INCF FSR
	GOTO LOOP1

END_LOOP1:
	MOVLW H'21'
	MOVWF FSR
	INCF CNT
	GOTO LOOP0

END_LOOP0:
	GOTO $

CHECK_Z:
	BTFSC STATUS, Z
	GOTO CONTINUE ;Es cero

	;Es positivo
	MOVF J, W
	MOVWF INDF
	DECF FSR
	MOVF I, W
	MOVWF INDF
	GOTO CONTINUE
	END