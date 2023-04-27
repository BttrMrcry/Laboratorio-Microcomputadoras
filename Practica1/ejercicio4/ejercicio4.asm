PROCESSOR 16f877
INCLUDE <p16f877.inc>
J equ H'26' ;Registro para guardar el resultado.
STATUS equ H'03' ;Registro STATUS
		ORG 0
		GOTO INICIO
		ORG 5
INICIO: MOVLW H'01'; Movemos la literal H'01' a W
		MOVWF J; Movemos W a J
		BCF STATUS, 0 ;Limpiamos a STATUS
LOOP:	RLF J ; Left Shift (Corrimiento a la izquierda de J)
		BTFSC J, 7; Checamos si hemos llegado a 80
		GOTO INICIO; Si es verdadero, regresamos a inicio
        GOTO LOOP; Caso contrario, seguimos iterando.
		END

