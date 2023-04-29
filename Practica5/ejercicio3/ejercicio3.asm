                                                                processor 16f877
include <p16f877.inc>
REGB    equ h'21'
REGA    equ h'22'
; Constantes de retardo 
cteA     equ h'FF'; 
cteB0    equ .6  ;6.49
cteB01	 equ .124 ;123.5
cteB90   equ .10 ;9.74
cteB901  equ .120 ;120.28
cteB180	 equ .13 ;13
cteB1801 equ .117  ;117.03

 	ORG 0
GOTO INICIO
 	ORG 5
INICIO:
	CLRF PORTA
	BSF STATUS,RP0
 	BCF STATUS,RP1
 	;Configura los puertos 
	; B, C y D como salidas
	MOVLW H'00'
 	MOVWF TRISB
	MOVWF TRISC
	MOVWF TRISD
	; El puerto A se configura 
	; como entrada digital 
	MOVLW 06H
	MOVWF ADCON1
	; Configura el puerto A como 
	; entrada
	MOVLW 3FH
	MOVWF TRISA
 	BCF STATUS,RP0
	MOVLW B'00000000'
	MOVWF PORTB
	MOVWF PORTC
	MOVWF PORTD
loop1:

	;Dependiendo de la posicion
	; del switch se ingresa
	; a alguno de los flujos
	; para cada angulo
	MOVLW h'04'		;
	SUBWF PORTA, W	; 
	BTFSC STATUS, Z	;
	GOTO ang0	;

	MOVLW h'02'		;
	SUBWF PORTA, W	; 
	BTFSC STATUS, Z	;
	GOTO ang90		; 

	MOVLW h'01'		;
	SUBWF PORTA, W	; 
	BTFSC STATUS, Z	; 
	GOTO ang180	


goto loop1	



ang0:
	;Verifica que se siga en la 
	; misma opcion para mantener 
	; el angulo 
	MOVLW h'04'		;
	SUBWF PORTA, W	; PORTA = 4 ?
	BTFSS STATUS, Z	;
	GOTO loop1	; VAMOS A PARO

	MOVF PORTA
	MOVWF PORTD	
; Genera la onda con periodo de 20ms
; y tiermpo encendido de 1ms
	BSF PORTC, 0
	CALL RETARDO0
	CLRF PORTC
	CALL RETARDO01
	GOTO ang0 


ang90:                                                      
	MOVLW h'02'		;
	SUBWF PORTA, W	; PORTA = 2 ?
	BTFSS STATUS, Z	;
	GOTO loop1	; VAMOS A PARO
	
	; Genera la onda con periodo de 20ms
	; y tiermpo encendido de 1.5ms
	BSF PORTC, 0
	CALL RETARDO90
	CLRF PORTC
	CALL RETARDO901
	GOTO ang90 

ang180:
	MOVLW h'01'		;
	SUBWF PORTA, W	; PORTA = 1 ?
	BTFSS STATUS, Z	;
	GOTO loop1	; VAMOS A PARO
	

	; Genera la onda con periodo de 20ms
	; y tiermpo encendido de 2ms
	BSF PORTC, 0
	CALL RETARDO180
	CLRF PORTC
	CALL RETARDO1801
	GOTO ang180 


;Rutina de retarado con las constantes 
;conrrespondientes definidas alñ inicio 
; del programa
RETARDO0:		; 
	MOVLW cteB0	;
 	MOVWF REGB	;
LOOPB0: 			;
	MOVLW cteA	;
	MOVWF REGA	;
LOOPA0: 			;
	DECFSZ REGA	;
 	GOTO LOOPA0	;
	DECFSZ REGB	;
	GOTO LOOPB0	;
	RETURN		; CODIGO PARA EL RETARDO


RETARDO01:		; 
	MOVLW cteB01	;
 	MOVWF REGB	;
LOOPB01: 			;
	MOVLW cteA	;
	MOVWF REGA	;
LOOPA01: 			;
	DECFSZ REGA	;
 	GOTO LOOPA01	;
	DECFSZ REGB	;
	GOTO LOOPB01	;
	RETURN		; CODIGO PARA EL RETARDO


RETARDO90:		; 
	MOVLW cteB90	;
 	MOVWF REGB	;
LOOPB90: 			;
	MOVLW cteA	;
	MOVWF REGA	;
LOOPA90: 			;
	DECFSZ REGA	;
 	GOTO LOOPA90	;
	DECFSZ REGB	;
	GOTO LOOPB90	;
	RETURN		; CODIGO PARA EL RETARDO



RETARDO901:		; 
	MOVLW cteB901	;
 	MOVWF REGB	;
LOOPB901: 			;
	MOVLW cteA	;
	MOVWF REGA	;
LOOPA901: 			;
	DECFSZ REGA	;
 	GOTO LOOPA901	;
	DECFSZ REGB	;
	GOTO LOOPB901	;
	RETURN		; CODIGO PARA EL RETARDO


RETARDO180:		; 
	MOVLW cteB180	;
 	MOVWF REGB	;
LOOPB180: 			;
	MOVLW cteA	;
	MOVWF REGA	;
LOOPA180: 			;
	DECFSZ REGA	;
 	GOTO LOOPA180	;
	DECFSZ REGB	;
	GOTO LOOPB180	;
	RETURN		; CODIGO PARA EL RETARDO



RETARDO1801:		; 
	MOVLW cteB1801	;
 	MOVWF REGB	;
LOOPB1801: 			;
	MOVLW cteA	;
	MOVWF REGA	;
LOOPA1801: 			;
	DECFSZ REGA	; 
 	GOTO LOOPA1801	;
	DECFSZ REGB	;
	GOTO LOOPB1801	;
	RETURN		; CODIGO PARA EL RETARDO
	END