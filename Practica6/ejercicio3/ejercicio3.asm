include <p16f877.inc>
cteA equ 0x20
v1 equ h'26'
v2 equ h'27'
v3 equ h'28'

	ORG 0
GOTO INICIO
	ORG 5
INICIO:
	CLRF PORTA
	BSF STATUS, RP0
	BCF STATUS, RP1
	;COnfiguración del convertidor
	CLRF ADCON1
	CLRF PORTD
	BCF STATUS, RP0
LOOP_PRINCIPAL
	;Para cada potenciometro se realiza 
	;una muestra. Para hacerlo, se debe
	;cambiar el canar del convertidor 
	;para cada uno de los casos.
	MOVLW B'11101001'
	MOVWF ADCON0	
	;Se inicia la conversión
	BSF ADCON0, 2
	CALL RETARDO
	;Se espera al resultado
LOOP_V1:
	BTFSC ADCON0, 2
	GOTO LOOP_V1
	;Se guarda el resultado en el registro 
	;asignado a cada uno de los potenciómetros
	MOVF ADRESH, W
	MOVWF v1

	;Se seleciona el canal correspondiente para 
	; el potenciómetro 2
	MOVLW B'11110001'
	MOVWF ADCON0	
	BSF ADCON0, 2
	CALL RETARDO
LOOP_V2:
	BTFSC ADCON0, 2
	GOTO LOOP_V2
	MOVF ADRESH, W
	MOVWF v2


		;Se seleciona el canal correspondiente para 
	; el potenciómetro 3
	MOVLW B'11111001'
	MOVWF ADCON0	
	BSF ADCON0, 2
	CALL RETARDO
LOOP_V3:
	BTFSC ADCON0, 2
	GOTO LOOP_V3
	MOVF ADRESH, W
	MOVWF v3

; En estas comparaciones revisa que 
; voltaje es menor a otro para mostrar
; el número correcto de leds. Para esto
; se realizan a lo más cuatro comparaciones.
; Para el primer caso se realizan 2.
;para el segundo 2 más y para el último nimguna,
; ya que si el flujo del programa llegó a ese punto 
;significa que no fue el primero ni el segundo caso, 
; por lo que obligatoriamente debe ser el tercero.
PRIMER_COMP
	; Primera comp
	MOVFW v2
	SUBWF v1, 0
	BTFSC STATUS, C
	GOTO CHECK_V3_1RA
SEGUNDA_COMP
	; Segunda comp
	MOVFW v1
	SUBWF v2, 0
	BTFSC STATUS, C
	GOTO CHECK_V3_2DA
DEFAULT
	; Caso default
	MOVLW B'00000111'
	MOVWF PORTD	
	GOTO LOOP_PRINCIPAL

CHECK_V3_1RA
	MOVFW v3
	SUBWF v1, 0
	BTFSS STATUS, C
	GOTO SEGUNDA_COMP
	MOVLW B'00000001'
	MOVWF PORTD
	GOTO LOOP_PRINCIPAL
	
CHECK_V3_2DA
	MOVFW v3
	SUBWF v2, 0
	BTFSS STATUS, C
	GOTO DEFAULT
	MOVLW B'00000011'
	MOVWF PORTD
	GOTO LOOP_PRINCIPAL



RETARDO:
	MOVLW 0X30
	MOVWF cteA
LOOPR:
	DECFSZ cteA
	GOTO LOOPR
	RETURN

END