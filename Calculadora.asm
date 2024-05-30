.cseg
.org 0x0000

.def aux=r21
.def aux1=r22
.def aux2 = r25

//configuracion de puerto
LDI aux2,0x0F
OUT DDRB,aux2
LDI aux,0xF0
OUT DDRC, aux
LDI aux, 0x0F
LDI aux, 0xF0
LDI aux, 0xFF
OUT DDRD, aux
OUT PORTD,aux

/*LDI R16, 0x00
STS UBRR0H, R16
LDI R16, 0x67
STS UBRR0L, R16 ;Baudaje de 9600 con 16Mhz	
LDI R16, (1<<TXEN0) ;Habilita el transmisor
STS UCSR0B, R16
LDI R16, (1<<UCSZ01) | (1<<UCSZ00);Establece el tamaño de 8 bits modo asincrono
STS UCSR0C, R16*/

Inicio:
	LDI R16, 0x00
	STS UBRR0H, R16
	LDI R16, 0x67
	STS UBRR0L, R16 ;Baudaje de 9600 con 16Mhz	
	LDI R16, (1<<TXEN0) ;Habilita el transmisor
	STS UCSR0B, R16
	LDI R16, (1<<UCSZ01) | (1<<UCSZ00);Establece el tamaño de 8 bits modo asincrono
	STS UCSR0C, R16

	LDI aux, 0b11101111
	LDI aux2, 0b11111110
	OUT PORTB,aux2
	OUT PORTC,aux
	RCALL Fila1

	LDI aux, 0b11011111
	LDI aux2, 0b11111101
	OUT PORTB,aux2
	OUT PORTC,aux
	RCALL Fila2

	LDI aux, 0b10111111
	LDI aux2, 0b11111011
	OUT PORTB,aux2
	OUT PORTC,aux
	RCALL Fila3

	LDI aux, 0b01111111
	LDI aux2, 0b11110111
	OUT PORTB,aux2
	OUT PORTC,aux
	RCALL Fila4
	RJMP inicio

Fila1:
	SBIS pinC,0
	RCALL Uno
	SBIS pinc,1
	RCALL Dos
	SBIS pinc,2
	RCALL Tres
	SBIS pinc,3
	RCALL A
	RET

Fila2:
	SBIS pinc,0
	RCALL Cuatro
	SBIS pinc,1
	RCALL Cinco
	SBIS pinc,2
	RCALL Seis
	SBIS pinc,3
	RCALL B
	RET

Fila3:
	SBIS pinc,0
	RCALL Siete
	SBIS pinc,1
	RCALL Ocho
	SBIS pinc,2
	RCALL Nueve
	SBIS pinc,3
	RCALL C
	RET

Fila4:
	SBIS pinc,0
	RCALL F
	SBIS pinc,1
	RCALL Cero
	SBIS pinc,2
	RCALL E
	SBIS pinc,3
	RCALL D
	RET
//Valor de las teclas
Cero:
	LDI aux1,0
	RCALL display
	RET

Uno:
	LDI aux1,1
	RCALL display
	RET

Dos:
	LDI aux1,2
	RCALL display
	RET

Tres:
	LDI aux1,3
	RCALL display
	RET

Cuatro:
	LDI aux1,4
	RCALL display
	RET

Cinco:
	LDI aux1,5
	RCALL display
	RET

Seis:
	LDI aux1,6
	RCALL display
	RET

Siete:
	LDI aux1,7
	RCALL display
	RET

Ocho:
	LDI aux1,8
	RCALL display
	RET

Nueve:
	LDI aux1,9
	RCALL display
	RET

A:
	LDI aux1,10
	RCALL display
	RET
B:
	LDI aux1,11
	RCALL display
	RET
C:
	LDI aux1,12
	RCALL display
	RET
D:
	LDI aux1,13
	RCALL display
	RET
E:
	LDI aux1,14
	RCALL display
	RET
F:
	LDI aux1,15
	RCALL display
	RET

Display:
	RCALL numero
	MOV R17, R22
	CALL ENVIA
	RCALL DELAY_1s
	RJMP Inicio

numero: 
	LDI zh,high(tabla<<1) 
	LDI zl,low(tabla<<1)
	ADD zl,aux1
	LPM aux1,z
	RET

DELAY_1s:
	LDI R16, 32
L1: LDI R17, 200
L2:	LDI R18, 250
L3:	NOP
	NOP
	DEC R18
	BRNE L3
	DEC R17
	BRNE L2
	DEC R16
	BRNE L1
	RET

ENVIA:
	CALL DELAY_3s
	STS UDR0, aux1
	RET

DELAY_3s:	
	LDI R16,255
	LDI R17,255
	LDI R18,255
REPITE: DEC R18
	BRNE REPITE
	DEC R17
	BRNE REPITE
	DEC R16
	BRNE REPITE
	RET

//tabla para el display
tabla:
	.db '0','1','2','3'
	.db '4','5','6','7'
	.db '8','9','A','B' 
	.db 'C','D','E','F'

//tabla para el display
/*tabla:
	.db 0b00111111,0b00000110    ;0 y 1
	.db 0b01011011,0b01001111    ;2 y 3
	.db 0b01100110,0b01101101    ;4 y 5
	.db 0b01111101,0b00000111    ;6 y 7
	.db 0b01111111,0b01100111    ;8 y 9
	.db 0b01110111,0b01111100    ;A y B
	.db 0b00111001,0b01011110    ;C y D
	.db 0b01111001,0b01110001    ;E y F*/