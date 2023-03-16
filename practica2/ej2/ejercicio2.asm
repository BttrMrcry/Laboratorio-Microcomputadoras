PROCESSOR 16f877
INCLUDE <p16f877.inc> 

MIN equ H'40'
	ORG 0
 	GOTO INICIO 
 	ORG 5
INICIO:
	MOVLW H'FF'
	MOVWF MIN 
	; pone el banco en 00
	BCF STATUS,RP1
	BCF STATUS,RP0

	;Coloca el inicio del recorrido una dirección de 
	;memoria antes de la primera que realmente se quiere 
	;tomar en cuenta.
	MOVLW 0X1F 
	MOVWF FSR
LOOP: 
	; Incrementa el apuntador FSR
	INCF FSR
	;Carga el contenido del registro MIN en W y lo resta 
	;al contenido del registro actualmente apuntado por 
	;FSR
	MOVF MIN,W 
	SUBWF INDF,0; F - W
	;Si no hay acarreo, el número puede ser negativo
	BTFSS STATUS, C
	GOTO CHECK_Z
CONTINUE:
	;Mientras FSR no tenga el bit 6 encendido, haremos 
	;el loop
	BTFSS FSR,6 
	GOTO LOOP
	GOTO $
CHECK_Z:
	; Si z esta en 0, significa que el numero es 
	;negativo; si es 1, es cero, por lo que no se hace 
	;nada
	BTFSC STATUS, Z
	GOTO CONTINUE
	;Como el resultado de la resta fue negativo, el 
	;valor del registo actual es menor que el minimo 
	;actual, por lo que se actualiza el valor minimo
	MOVFW INDF
	MOVWF MIN
	GOTO CONTINUE
	END