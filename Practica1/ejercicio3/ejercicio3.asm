PROCESSOR 16f877
INCLUDE <p16f877.inc>
J equ H'26' ;Registro para segundo operando
K equ H'27'; Registro para primer operando
R1 equ H'29'; Registro para resultado
C1 equ H'28'; Registro para el carry
STATUS equ H'03' ;Registro STATUS
		ORG 0
		GOTO INICIO
		ORG 5
INICIO: MOVF K,W ;Mover valor de K a W
		ADDWF J,0 ;Sumar W con J y guarda en W
		MOVWF R1; Mover lo que hay en W a R1 (resultado)
		BTFSC STATUS, 0 ;Checar bit 0 de STATUS, (carry)
		GOTO C_1 ;Si es 1, entonces va a C1
		GOTO C_0 ;En caso contrario, entonces va a C0
	C_0: 
		MOVLW H'00' ;Se mueve la literal H'00' a W
		MOVWF C1; Mueve W a C1
		GOTO RESUME; Va a RESUME
	C_1: 
		MOVLW H'01'; Se mueve la literal H'01' a W
		MOVWF C1; Mueve W a C1
		GOTO RESUME; Va a RESUME
RESUME:
		GOTO INICIO ; Repite
		END




	
