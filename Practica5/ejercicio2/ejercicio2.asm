                                                                processor 16f877
include <p16f877.inc>
REGB equ h'21'          ; Registro A
REGA equ h'22'          ; Registro B
COUNT1 equ h'35'        ; Contador 1
COUNT2 equ h'36'        ; Contador 2
cte2 equ h'FF'          ; Variable A para calculo del tiempo
cte1 equ .33; B         ; Variable B para calculo del tiempo
 	ORG 0
GOTO INICIO
 	ORG 5
INICIO:
	CLRF PORTA          ; Limpiar el PortA
	BSF STATUS,RP0      ;
 	BCF STATUS,RP1      ; Cambiar al banco 1
 	MOVLW H'00'         ;
 	MOVWF TRISB         ; Configurar TRISB como salida MOTOR
	MOVWF TRISC         ; Configurar TRISC como salida MOTOR
	MOVWF TRISD         ; Configurar TRISD como salida MOTOR
	MOVLW 06H           ;
	MOVWF ADCON1        ; Configurar entradas digitales
	MOVLW 3FH           ;
	MOVWF TRISA         ; Configurar TRISA como entrada
 	BCF STATUS,RP0      ; Cambiamos de banco
	MOVLW B'00000000'   ;
	MOVWF PORTB         ;
	MOVWF PORTC         ;
	MOVWF PORTD         ; Limpieza de los puertos de salida.
loop1:
	MOVLW h'00'		;
	SUBWF PORTA, W	; PORTA = 0 ?
	BTFSC STATUS, Z	;
	GOTO PARO	; VAMOS A PARO

	MOVLW h'01'		;
	SUBWF PORTA, W	; PORTA = 1 ? 
	BTFSC STATUS, Z	;
	GOTO H			; VAMOS A H = HORARIO

	MOVLW h'02'		;
	SUBWF PORTA, W	; PORTA = 2 ?
	BTFSC STATUS, Z	; 
	GOTO AH			; VAMOS A AH = ANTIHORARIO

	MOVLW h'03'		;
	SUBWF PORTA, W	; PORTA = 3 ?
	BTFSC STATUS, Z	;
	GOTO CINCO_H	; VAMOS A CINCO_H = CINCO HORARIO

	MOVLW h'04'	    ;
	SUBWF PORTA, W  ; PORTA = 4 ?
	BTFSC STATUS, Z ;
	GOTO DIEZ_AH    ; VAMOS A DIEZ_AH = DIEZ ANTI HORARIO

goto loop1	

PARO:
 	CLRF PORTB      ;
	GOTO loop1      ; LIMPIEZA DEL PORTB
H:
	CLRF PORTB      ; Lmpieza del portB
	BSF PORTB, 7    ;
	BSF PORTB, 6    ;
	BCF PORTB, 5    ;
	BCF PORTB, 4    ;PASO 1
	CALL RETARDO
	BCF PORTB, 7    ;
	BSF PORTB, 6    ;
	BSF PORTB, 5    ;
	BCF PORTB, 4    ;PASO 2
	CALL RETARDO
	BCF PORTB, 7    ;
	BCF PORTB, 6    ;
	BSF PORTB, 5    ;
	BSF PORTB, 4    ;PASO 3
	CALL RETARDO
	BSF PORTB, 7    ;
	BCF PORTB, 6    ;
	BCF PORTB, 5    ;
	BSF PORTB, 4    ;PASO 4
	CALL RETARDO
	GOTO loop1
AH:
	CLRF PORTB
	BSF PORTB, 7    ;
	BCF PORTB, 6    ;
	BCF PORTB, 5    ;
	BSF PORTB, 4    ;PASO 4
	CALL RETARDO
	BCF PORTB, 7    ;
	BCF PORTB, 6    ;
	BSF PORTB, 5    ;
	BSF PORTB, 4    ;PASO 3
	CALL RETARDO
	BCF PORTB, 7    ;
	BSF PORTB, 6    ;
	BSF PORTB, 5    ;
	BCF PORTB, 4    ;PASO 2
	CALL RETARDO	
	BSF PORTB, 7    ;
	BSF PORTB, 6    ;
	BCF PORTB, 5    ;
	BCF PORTB, 4    ;PASO 1
	CALL RETARDO
	GOTO loop1
CINCO_H:
		CLRF COUNT1         ;
		CLRF COUNT2         ; Limpieza de los contadores
	loop_h_1:
		MOVLW H'0A'         ; 10 Medias vueltas
		SUBWF COUNT1, W     ;
		BTFSC STATUS, Z     ;
		GOTO end_loop_h_1   ;
	loop_h_2:
		MOVLW H'FF'         ; 255 pasos
		SUBWF COUNT2, W     ;
		BTFSC STATUS, Z     ;
		GOTO end_loop_h_2   ;
		CLRF PORTB          ; Limpieza portB
		BSF PORTB, 7        ;
		BSF PORTB, 6        ;
		BCF PORTB, 5        ;
		BCF PORTB, 4        ;PASO 1
		CALL RETARDO
		BCF PORTB, 7        ;
		BSF PORTB, 6        ;
		BSF PORTB, 5        ;
		BCF PORTB, 4        ;PASO 2
		CALL RETARDO
		BCF PORTB, 7        ;
		BCF PORTB, 6        ;
		BSF PORTB, 5        ;
		BSF PORTB, 4        ;PASO 3
		CALL RETARDO
		BSF PORTB, 7        ;
		BCF PORTB, 6        ;
		BCF PORTB, 5        ;
		BSF PORTB, 4        ;PASO 4
		CALL RETARDO
		INCF COUNT2, 1
		GOTO loop_h_2
end_loop_h_1:
		MOVLW h'03'         ;
		SUBWF PORTA, W	    ;
		BTFSC STATUS, Z	    ;
		GOTO end_loop_h_1   ;
		GOTO loop1
end_loop_h_2:
		MOVFW COUNT2
		MOVWF PORTD
		INCF COUNT1, 1
		CLRF COUNT2
		GOTO loop_h_1
DIEZ_AH:
		CLRF COUNT1
		CLRF COUNT2
	loop_ah_1:
		MOVLW H'14'         ; 20 Medias vueltas
		SUBWF COUNT1, W     ;
		BTFSC STATUS, Z     ;
		GOTO end_loop_ah_1  ;
	loop_ah_2:
		MOVLW H'FF'         ; 255 pasos
		SUBWF COUNT2, W     ;
		BTFSC STATUS, Z     ;
		GOTO end_loop_ah_2  ;
		CLRF PORTB          ; Limpieza portB
		BSF PORTB, 7        ;
		BCF PORTB, 6        ;
		BCF PORTB, 5        ;
		BSF PORTB, 4        ;PASO 4
		CALL RETARDO
		BCF PORTB, 7        ;
		BCF PORTB, 6        ;
		BSF PORTB, 5        ;
		BSF PORTB, 4        ;PASO 3
		CALL RETARDO
		BCF PORTB, 7        ;
		BSF PORTB, 6        ;
		BSF PORTB, 5        ;
		BCF PORTB, 4        ;PASO 2
		CALL RETARDO	
		BSF PORTB, 7        ;
		BSF PORTB, 6        ;
		BCF PORTB, 5        ;
		BCF PORTB, 4        ;PASO 1
		CALL RETARDO
		INCF COUNT2, 1
		GOTO loop_ah_2
end_loop_ah_1:
		MOVLW h'04'		    ;
		SUBWF PORTA, W	    ;
		BTFSC STATUS, Z	    ;
		GOTO end_loop_ah_1  ;
		GOTO loop1

end_loop_ah_2:
		MOVFW COUNT2
		MOVWF PORTD
		INCF COUNT1, 1
		CLRF COUNT2
		GOTO loop_ah_1
	
RETARDO:		; 
	MOVLW cte1	;
 	MOVWF REGB	;
LOOPB: 			;
	MOVLW cte2	;
	MOVWF REGA	;
LOOPA: 			;
	DECFSZ REGA	;
 	GOTO LOOPA	;
	DECFSZ REGB	;
	GOTO LOOPB	;
	RETURN		; CODIGO PARA EL RETARDO
	END
