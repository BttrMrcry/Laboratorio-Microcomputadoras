        PROCESSOR 161877
        INCLUDE <p16f877.inc>
K equ H'26'; Registro para operando
L equ H'27'; Registro para resultado
        ORG 0
        GOTO INICIO
        ORG 5
INICIO: MOVLW H'O5'; Moviendo un 5h a W
        ADDWF K,0; Suma W con K y guarda en W
        MOVWF L ;Mover W a L
        GOTO INICIO ; Repetir
        END
