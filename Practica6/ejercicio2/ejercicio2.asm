include <p16f877.inc>
cteA equ 0x20
voltaje equ h'26'
	ORG 0
GOTO INICIO
	ORG 5
INICIO:
	CLRF PORTA
	BSF STATUS, RP0
	BCF STATUS, RP1
	;Se configuran los puertos de la
	;manera especificada
	CLRF ADCON1
	CLRF PORTD
	BCF STATUS, RP0
	;Selecciona el canal, la frecuencia 
	; y enciende el convertido A/D
	MOVLW B'11101001'
	MOVWF ADCON0

LOOP2:	
	;Inicia el convertidor
	BSF ADCON0, 2
	CALL RETARDO
	;Espera a que termine de
	;realizar la conversión
LOOP:
	BTFSC ADCON0, 2
	GOTO LOOP
	;Mueve al resultado de la 
	;coversión al registro voltaje
	MOVF ADRESH, W
	MOVWF voltaje
	;Comienza con las verificaciones
	;La verificación se divide en dos partes:
	; 1- Se verifica que la resta no sea cero.
	; 2.- se veridica que el carry este apagado.
	;Esto con el objetivo de saber si el voltaje 
	;es menor que el valor de referencia.

	;Se empieza verifciando si es menor 
	;que 42 decimal, o sea, menor a un 
	;volt 
	MOVLW .42
	SUBWF voltaje, 0
	BTFSS STATUS, Z
	GOTO CHECK_C_0
CHECK_V_1:
	 
	;Menor que 84 decimal, o sea, 
	;menor a 2 volts. 
	MOVLW .84
	SUBWF voltaje, 0
	BTFSS STATUS, Z
	GOTO CHECK_C_1
CHECK_V_2:
	;Menor que 124 decimal, o sea, 
	;menor a 3 volts. 
	MOVLW .126
	SUBWF voltaje, 0
	BTFSS STATUS, Z
	GOTO CHECK_C_2
CHECK_V_3:
	;Menor que 168 decimal, o sea, 
	;menor a 4 volts. 
	MOVLW .168
	SUBWF voltaje, 0
	BTFSS STATUS, Z
	GOTO CHECK_C_3
CHECK_V_4:
	;Menor que 210 decimal, o sea, 
	;menor a 5 volts. 
	MOVLW .210
	SUBWF voltaje, 0
	BTFSS STATUS, Z
	GOTO CHECK_C_4
CHECK_V_5:
	;igual o mayor a 5 volts.
	GOTO CHECK_C_5
	GOTO LOOP2


RETARDO:
	MOVLW 0X30
	MOVWF cteA
LOOPR:
	DECFSZ cteA
	GOTO LOOPR
	RETURN

;estas etiquetas simplemente revisan que el
;carry sea 0.
CHECK_C_0:
	BTFSC STATUS, C
		GOTO CHECK_V_1
	MOVLW B'00000000'
	MOVWF PORTD
	GOTO LOOP2

CHECK_C_1:
	BTFSC STATUS, C
		GOTO CHECK_V_2
	MOVLW B'00000001'
	MOVWF PORTD
	GOTO LOOP2

CHECK_C_2:
	BTFSC STATUS, C
		GOTO CHECK_V_3
	MOVLW B'00000010'
	MOVWF PORTD
	GOTO LOOP2

CHECK_C_3:
	BTFSC STATUS, C
		GOTO CHECK_V_4
	MOVLW B'00000011'
	MOVWF PORTD
	GOTO LOOP2


CHECK_C_4:
	BTFSC STATUS, C
		GOTO CHECK_V_5
	MOVLW B'00000100'
	MOVWF PORTD
	GOTO LOOP2

CHECK_C_5:
	MOVLW B'00000101'
	MOVWF PORTD
	GOTO LOOP2

END