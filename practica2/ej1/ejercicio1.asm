PROCESSOR 16f877
INCLUDE <p16f877.inc> 
	ORG 0
 	GOTO INICIO 
 	ORG 5
INICIO: 
	BCF STATUS,RP1
	BSF STATUS,RP0; pone el banco en 01
	MOVLW 0X20
	MOVWF FSR
LOOP: 
	MOVLW 0X5F
	MOVWF INDF ; Coloca 0x5F en el apuntador FSR
	INCF FSR; Incrementa el apuntador FSR
	BTFSS FSR,6 ;Mientras FSR no tenga el bit 6 encendido, haremos el loop
	GOTO LOOP
	GOTO $
	END