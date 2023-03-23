processor 16f877
include <p16f877.inc>
valor1 equ h'21'
valor2 equ h'22'
valor3 equ h'23'
cte1 equ h'ff'
cte2 equ 50h
cte3 equ 60h
 	ORG 0
GOTO INICIO
 	ORG 5
INICIO:
	; Limpia los bits del puerto A
	CLRF PORTA 
	;Selecciona el banco de memoria 1
	BSF STATUS,RP0
 	BCF STATUS,RP1
	;Programa el puerto B como salida
 	MOVLW H'00'
 	MOVWF TRISB
	;Se indica que que se usaran entradas
	;digitales
	MOVLW 06H
	MOVWF ADCON1
	;Se configura al puerto A como entrada
	MOVLW 3FH
	MOVWF TRISA
	;Se regresa al banco 0
 	BCF STATUS,RP0
	MOVLW B'00000000'
	;Se limpia la memoria del puerto B
	MOVWF PORTB

	
;En este loop se verifica a que caso se quiere 
;entrar
loop1:

	;Verifica si se quiere apagar los leds
	MOVLW h'00'	
	SUBWF PORTA, W
	BTFSC STATUS, Z
	GOTO APAGAR_LEDS
	;Verifica si se quiere prender todos los
	;leds
	MOVLW H'01'
	SUBWF PORTA, W
	BTFSC STATUS, Z
	GOTO PRENDER_LEDS
	;Verifica si se quiere realizar corriento 
	;a la derecha
	MOVLW H'02'
	SUBWF PORTA, W
	BTFSC STATUS, Z
	GOTO RIGHT_SHIFT	
	;Verifica si se quiere realizar corrimiento 
	; al a izquierda
	MOVLW H'03'
	SUBWF PORTA, W
	BTFSC STATUS, Z
	GOTO LEFT_SHIFT
	; Verifica si se quiere realizar zig-zag.
	MOVLW H'04'
	SUBWF PORTA, W
	BTFSC STATUS, Z
	GOTO ZIG_ZAG_1
	;Verifica si se quiere comportamiento 
	;intermitente
	MOVLW H'05'
	SUBWF PORTA, W
	BTFSC STATUS, Z
	GOTO INTERMITENTE

goto loop1	

;Coloca todos los bits del puerto B en 1
PRENDER_LEDS:
	MOVLW B'11111111'
	MOVWF PORTB
	GOTO loop1

;Coloca todos los bits del puerto B en 0
APAGAR_LEDS:
	CLRF PORTB
	GOTO loop1


RIGHT_SHIFT:
	;Se prende el ultimo bit del puerto
	; B
	MOVLW B'10000000'
	MOVWF PORTB
	;Limpia el carry para evitar errores
	BCF STATUS, C
LOOP_RS:
	;Verifica si el contedio del puerto B es cero, 
	; De ser el caso terminó el corrimiento, por lo
	; que debe empezar de nuevo.
	MOVLW H'00'
	SUBWF PORTB
	BTFSC STATUS, Z
	GOTO RIGHT_SHIFT
	; LLama a retardo para hacer visible la accion
	CALL retardo
	;verfica si se quiere acceder a otro modo. Si es 
	;así regresa al loop principal
	MOVLW H'02'
	SUBWF PORTA, W
	BTFSS STATUS, Z
	GOTO loop1
	;limpa el contenido del carry
	BCF STATUS, C
	;Realiza un corrimiento a la derecha
	RRF PORTB
	
	goto LOOP_RS

LEFT_SHIFT:
	;Se prende el primer bit del puerto
	; B
	MOVLW B'00000001'
	MOVWF PORTB
LOOP_LS:
	;Verifica si el contedio del puerto B es cero, 
	; De ser el caso terminó el corrimiento, por lo
	; que debe empezar de nuevo.
	MOVLW H'00'
	SUBWF PORTB
	BTFSC STATUS, Z
	GOTO LEFT_SHIFT
	; LLama a retardo para hacer visible la accion
	CALL retardo
	;verfica si se quiere acceder a otro modo. Si es 
	;así regresa al loop principal
	MOVLW H'03'
	SUBWF PORTA, W
	BTFSS STATUS, Z
	GOTO loop1
	;limpa el contenido del carry
	BCF STATUS, C
	;Realiza un corrimiento a la izquierda
	RLF PORTB
	goto LOOP_LS

; Es casi identico al corrimento a la derecha, pero
; en lugar de ejecutarse a si mismo cuando termina
; el corrimiento, ejecuta a ZIG_ZAG_2 que es casí 
;identico al corrimiento a la izquierda
ZIG_ZAG_1:
	MOVLW B'10000000'
	MOVWF PORTB
	BCF STATUS, C
LOOP_ZZ_1:
	MOVLW H'00'
	SUBWF PORTB
	BTFSC STATUS, Z
	GOTO ZIG_ZAG_2
	CALL retardo
	MOVLW H'04'
	SUBWF PORTA, W
	BTFSS STATUS, Z
	GOTO loop1
	BCF STATUS, C
	RRF PORTB
	goto LOOP_ZZ_1

; Es casi identico al corrimento a la izquierda, pero
; en lugar de ejecutarse a si mismo cuando termina
; el corrimiento, ejecuta a ZIG_ZAG_1 que es casí 
;identico al corrimiento a la derecha
ZIG_ZAG_2:
	MOVLW B'00000001'
	MOVWF PORTB
	;BCF STATUS, C
LOOP_ZZ_2:
	MOVLW H'00'
	SUBWF PORTB
	BTFSC STATUS, Z
	GOTO ZIG_ZAG_1
	CALL retardo
	MOVLW H'04'
	SUBWF PORTA, W
	BTFSS STATUS, Z
	GOTO loop1
	BCF STATUS, C
	RLF PORTB
	goto LOOP_ZZ_2

;Hace parpadear todos los leds de manera intermitente
INTERMITENTE:
	;Verifica si se quiere acceder a otro modo y si es
	; así regresa al loop principal
	MOVLW H'05'
	SUBWF PORTA, W
	BTFSS STATUS, Z
	GOTO loop1
	;Prende todos los leds
	MOVLW H'FF'
	MOVWF PORTB
	CALL retardo
	;Apaga todos los leds
	CLRF PORTB
	CALL retardo
	goto INTERMITENTE	
	

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