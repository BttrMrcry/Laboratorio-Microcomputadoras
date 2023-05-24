processor 16f877
include<p16f877.inc>
valor1 equ h'31'
valor2 equ h'32'
valor3 equ h'33'
cte1 equ H'FF'
cte2 equ 50h
cte3 equ 60h
Opcion equ H'34'
ORG 0
GOTO INICIO

ORG 5
INICIO
BSF STATUS,RP0 ;Cambiamos al banco 1
BCF STATUS,RP1
CLRF ADCON1

CLRF TRISB
BSF TXSTA,BRGH	;Activamos el BRGH
MOVLW D'129'
MOVWF SPBRG		;Configuramos el baud rate a 9600
BCF TXSTA,SYNC	;Configuramos la asincrona
BSF TXSTA,TXEN  ;Activamos el transmisor
BCF STATUS,RP0	;Volvemos al banco 0
MOVLW B'11101001'
MOVWF ADCON0
BSF RCSTA,SPEN	;Habilitamos la recepcion
BSF RCSTA,CREN	;Habilitamos la recepcion continua
loop1:
	BSF ADCON0, 2
	CALL retardo
LOOP:
	BTFSC ADCON0, 2
	GOTO LOOP 
	MOVF ADRESH, W
	ADDWF W, 0
	MOVLW B'11110000'
	ANDWF 


	ADDLW H'30'
	MOVWF TXREG
	CALL TRANSMITE
	GOTO loop1
RECIBE
	BTFSS PIR1,RCIF	;Verificamos la bandera recepcion
	GOTO RECIBE
	MOVF RCREG,W	;Copiamos lo recibido a W
	MOVWF Opcion
	RETURN

TRANSMITE
	BSF STATUS,RP0	;Vamos al banco 1
	BTFSS TXSTA,TRMT	;Comprobamos si ya termino de transmitir
	GOTO TRANSMITE	
	BCF STATUS,RP0	;Volvemos al banco 0
	RETURN
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