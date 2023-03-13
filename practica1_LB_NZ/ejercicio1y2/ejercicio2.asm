    PROCESSOR 16f877
    INCLUDE <p16f877.inc>
K equ H'26'; Registro para primer operando
L equ H'27'; Registro para segundo operando
M equ H'28'; Registro de resultado
        ORG 0
        GOTO INICIO
        ORG 5
INICIO: MOVF K.W ; Movemos el valor del registro K a W
        ADDWF L,0; Operamos adición de L y W, guardando en W
        MOVWF M; Movemos lo que hay en W a M
        GOTO INICIO; Repetimos
        END
