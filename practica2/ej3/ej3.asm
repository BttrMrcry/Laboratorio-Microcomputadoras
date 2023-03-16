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
;Selcciona el bando de moemoria 0
	BCF STATUS,RP1
	BCF STATUS,RP0; BANCO 0
	MOVLW 0X21
	MOVWF FSR ; Inicia en la direccion de memoria 21
	; Carga la cantidad de numeros a ordenar
	MOVLW H'0f' 
	MOVWF N
	; Carga el nuero de pasadas realizadas 
	MOVLW H'00'
	MOVWF CNT
LOOP0:
	;Verifica si se llego al limite de pasadas
	MOVF CNT, W
	SUBWF N, W
	BTFSC STATUS, Z
	GOTO END_LOOP0

LOOP1:
	;Verifica si no se ha llegado al final del arreglo
	MOVLW H'30'
	SUBWF FSR, W
	BTFSC STATUS, Z
	GOTO END_LOOP1
	;Carga los valores de INDF e INDF - 1  a los registros 
	; I y J para compararlos
	MOVF INDF, W
	MOVWF I
	DECF FSR
	MOVF INDF, W
	MOVWF J
	INCF FSR
	; Compara INDF e INDF - 1
	MOVF I, W
	SUBWF J, W  ; J - I
	BTFSC STATUS, C
	GOTO CHECK_Z
	; Si llega el flujo a aquí, el resultado 
	; de la resta es negativo
CONTINUE:
	;Se pasa a la siguiete localidad de memoria
	INCF FSR
	GOTO LOOP1

END_LOOP1:
	;Se regresa el apuntador al inicio del arreglo 
	MOVLW H'21'
	MOVWF FSR
	INCF CNT
	GOTO LOOP0

END_LOOP0:
	GOTO $

CHECK_Z:
	BTFSC STATUS, Z
	GOTO CONTINUE ;El resultado de la resta es cero

	;El resultado de la resta es positivo 
	;por lo que los elementos se deben intercambiar
	MOVF J, W
	MOVWF INDF
	DECF FSR
	MOVF I, W
	MOVWF INDF
	GOTO CONTINUE
	END