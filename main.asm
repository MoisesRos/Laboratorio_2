;******************************************************************************
; Universidad del Valle de Guatemala
; Programación de Microcrontroladores
; Proyecto: Laboratorio Timer y botones
; Archivo: Laboratorio_2_Botones_y_Timer0
; Hardware: ATMEGA328p
; Created: 6/02/2024
; Author : Moises Rosales
;******************************************************************************
; Encabezado: consiste en realizar un contador que incremente con el timer
;******************************************************************************

.include "M328PDEF.inc" ;RECONOCER LOS NOMBRES DE LOS REGISTROS
.cseg ;Indica inicio del código
.org 0x00 ; ESTABLECEMOS POSICION 0
;******************************************************************************
; SP
;******************************************************************************
LDI R16, LOW(RAMEND)
OUT SPL, R16 
LDI R17, HIGH(RAMEND)
OUT SPH, R17
;******************************************************************************
; Configuración
;******************************************************************************
Setup:
	LDI R16, (1 << CLKPCE)
	STS CLKPR, R16 ;HABILITAMOS EL PRESCALER

	LDI R16, 0b0000_0100
	STS CLKPR, R16 ; DEFINIMOS UNA FRECUENCIA DE 1MGHz

	LDI R16, 0b0000_0011 ; CONFIGURAMOS LOS PULLUPS en PORTC
	OUT PORTC, R16	; HABILITAMOS EL PULLUPS
	

	LDI R16, 0b0001_1111
	OUT DDRB, R16	;DEFINIMOS SALIDAS DEL PUERTO B
	LDI R16, 0b1111_1111
	OUT DDRD, R16	;DEFINIMOS SALIDAS DEL PUERTO D



	CALL INICIOT0 ;INICIAMOS EL CONTADOR
MAIN:
	LDI ZH, HIGH(SEGMENTOS << 1)
	LDI ZL, LOW(SEGMENTOS << 1)
	LPM R18, Z

	CLR R16
	CLR R17
	CLR R18
	CLR R19
	CLR R22
	CLR R20
	CLR R21

LDI R21, 0x10

Loop:
	
	IN R16, TIFR0 ; LEEMOS EL REGISTRO DE LAS BANDERAS
	SBRS R16, TOV0 ; VERIFICAMOS SI ESA BANDERA (TOV0) SE ENCENDIO

	RJMP Loop

	LDI R16, 98 ; VOLVEMOS A CARGAR EL CONTADOR
	OUT TCNT0, R16
	SBI TIFR0, TOV0 ;APAGAMOS LA BANDERA


MOV R19, R20 ;ESTABLECEMOS COMO UN VALOR ANTERIOR AL BOTON
IN R20, PINC
CP R20, R19 ;COMPARAMOS VALOR INICIAL CON VALOR ACTUAL
BREQ CONTADOR
CALL DELAYB
IN R20, PINC
CP R18, R20
BREQ CONTADOR


;BOTONES
	SBRS R17, PC0	;BOTON 1
	RJMP DISPLAY1
	SBRS R17, PC1	;BOTON 2
	RJMP DISPLAY2


CONTADOR:
	CPI R16, 0x0F ; REINICIO DEL CONTADOR AL LLEGAR A 1111
	BRNE INCREMENTAR
	RJMP  REST

		RJMP Loop
;******************************************************************************
; Subrutinas 
;******************************************************************************

;CONTADOR
INICIOT0:
	OUT TCCR0A, R16  ;CARGAMOS EL VALOR INICIAL DEL CONTADOR
	LDI R16, (1 << CS02) | (1 << CS00) ; HABILITAMOS EL PRESCALER EN 1024
	OUT TCCR0B, R16

	LDI R16, 98 ;VALOR DE DESBORADMIENTO 
	OUT TCNT0, R16 ;CARGAMOS EL VALOR INICIAL DEL CONTADOR
	RET

;INCREMENTADOR CONTADOR

INCREMENTAR:
	CPI R22, 9
	BREQ RES
	INC R22
	RJMP Loop
	;DECREMENTADOR CONTADOR
RES:
	INC R17
	CLR R22
	RJMP LED

REST:
	LDI R17, 0x00
	RJMP LED
;ASIGNAMOS SALIDAS 
LED:
	SBRS R17, 0
	CBI	PORTB, PB0
	SBRC R17, 0
	SBI PORTB, PB0
	SBRS R17, 1
	CBI	PORTB, PB1
	SBRC R17, 1
	SBI PORTB, PB1
	SBRS R17, 2
	CBI	PORTB, PB2
	SBRC R17, 2
	SBI PORTB, PB2
	SBRS R17, 3
	CBI	PORTB, PB3
	SBRC R17, 3
	SBI PORTB, PB3
	RJMP Loop
////////////////////////////////////////////////////////////////////////////
;ANTIRREBOTE
DELAYB:
	LDI R16, 100
delay:
	DEC R16
	BRNE delay ; REGRESA SI NO ES CERO
	RET ; RETORNAMOS

;CONFIGURACIÓN PARA EL DISPLAY

DISPLAY1:
	INC ZL
	INC R22 ;REGISTRO PARA LA ALARMA
	CPI R18, 0xE1
	BREQ RESET_DISPLAY1
	LPM R18, Z
	OUT PORTD, R18
RESET_DISPLAY1:
	LDI ZL, LOW(SEGMENTOS <<1)
	LPM R18, Z
	CLR R23
	OUT PORTD, R18
	


DISPLAY2: 
	DEC ZL
	DEC R22 ;REGISTRO PARA LA ALARMA
	CPI R18, 0x73
	BREQ RESET_DISPLAY2
	LPM R18, Z
	OUT PORTD, R18

RESET_DISPLAY2:
	ADD ZL, R21
	LPM R18, Z
	LDI R22, 0x0F
	OUT PORTD, R18

;******************************************************************************
;TABLA DE VALORES
;******************************************************************************
SEGMENTOS: .DB 0x73, 0x34, 0xB3, 0xB6, 0xD4, 0xE6, 0xE7, 0xB4, 0xF7, 0xF6, 0XF5, 0xF7, 0x63, 0x77, 0xE3, 0xE1
;GUARDAMOS LOS VALORES DE NUESTRA TABLA DE VERDAD
;*****************************************************************************


