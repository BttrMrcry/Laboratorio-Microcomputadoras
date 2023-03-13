PROCESSOR 16f877
INCLUDE <p16f877.inc>
R1 equ H'26'; CONTADOR
CONST equ H'27'; REGISTRO PARA CONSTANTE
STATUS equ H'03'; REGISTRO STATUS
ORG 0
 GOTO INICIO 
 ORG 5
INICIO: MOVLW  H'00' ;MOVEMOS LITERAL H'00' A W
		MOVWF R1 ;MOVEMOS W A R1
		MOVLW  H'07'; MOVEMOS LITERAL H'07' A W
		MOVWF CONST; MOVEMOS W A CONST
LOOP: 
		MOVF R1, w
        ; Condicional para checar si el contador es H'09'
        ; En caso verdadero se le suma la constante
        ; En caso falso continuamos
		SUBLW H'09'
		BTFSC STATUS, 2
		GOTO SUMA_CONST
		MOVF R1, w
        ; Condicional para checar si el contador es H'19'
        ; En caso verdadero se le suma la constante
        ; En caso falso continuamos
		SUBLW H'19'
		BTFSC STATUS, 2
		GOTO SUMA_CONST
		MOVF R1, w
        ; Condicional para checar si el contador es H'20'
        ; En caso verdadero vamos a SET_ZERO
        ; En caso falso incrementamos el contador y repetimos el loop.
		SUBLW H'20'
		BTFSC STATUS, 2
		GOTO SET_ZERO
		INCF R1
 		GOTO LOOP
SUMA_CONST:
		MOVF CONST, w ;Movemos constante a W
		ADDWF R1; Sumamos W con R1
		GOTO LOOP; Regresamos al LOOP
SET_ZERO:
		MOVLW H'00' ;Movemos constante H'00' a W
		MOVWF R1; Movemos W a R1
		GOTO LOOP ; Continuamos LOOP
 END
