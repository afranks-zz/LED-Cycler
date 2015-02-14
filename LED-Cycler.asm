/*
 * Lab04.asm
 *
 *  Created: 2/8/2015 7:10:43 PM
 *   Author: Adam
 */ 

 .cseg
 .org 0x0000 jmp main
.org 0x000E jmp rstcnt
.org 0x0016 jmp rstcnt

 .org 0x0100
 rstcnt:
 push r16
 ldi r16, 0
 sts TCCR1B, r16
 ldi r16, 0x02
 sts TIFR1, r16

 pop r16
 ret

 startcnt:

 push r16
 ldi r16, 0x0d
 sts TCCR1B, r16
 
pop r16
;sleep
infloop:
brbc 7,outloop
rjmp infloop

outloop:
 reti

 main:
 ldi r16, HIGH(ramend)
 out sph, r16
 ldi r16, LOW(ramend)
 out spl, r16

 ldi r16, 0x02
 sts TIMSK1, r16

 ldi r16, 0x0C
 sts OCR1AH, r16
 ldi r16, 0x35
 sts OCR1AL, r17
 

 

 sei
 

 

 ldi r16, 0x00
 out DDRC, r16
 ldi r16, 0b01111111
 out PORTC, r16
 sbi PORTB, 0
 



ldi r16, 0b11111100
out DDRD, r16
jmp rot

brot:

in r16, PINC
com r16
lsl r16
lsl r16

brotl:
out PORTD, r16
rcall startcnt
lsl r16
brcc brotl
sbr r16, 0x04

rjmp brotl

loop:

in r16, PINC
com r16
lsl r16
lsl r16
out PORTD, r16

rjmp loop

ret

rot:
sbis PINB, 0
rjmp lloop

loop2:
ldi r16, 0x04

iloop:

out PORTD, r16
ldi r17, 200
;push r17
;rcall delayxms
rcall startcnt
lsl r16
breq ldone
rjmp iloop

ldone:
ldi r16, 0xFC
out PORTD, r16
ldi r17, 200
;push r17
;rcall delayxms
rcall startcnt

rjmp rot


lloop:
ldi r16, 0x80

liloop:
out PORTD, r16
;ldi r17, 200
;push r17
;rcall delayxms
rcall startcnt
lsr r16

sbrc r16, 1
rjmp lloopdone
rjmp liloop

lloopdone:
ldi r16, 0xFC
out PORTD, r16
;ldi r17, 200
;push r17
;rcall delayxms
rcall startcnt
rjmp rot

; Uses r0,r1,r2
delayxms: ; 4
pop r0
pop r1
pop r2
push r1
push r0
delayxmsnp:
rcall delay1ms_looping ; 16000 per call
dec r2 ; 1
brne delayxmsnp ; 2/1
ret ; 4



delay1ms_looping:
; 4 cycles to call
ldi zl, 0xe7 ; 1 cycle
ldi zh, 0x03 ; 1 cycle
push r0 ; 2
pop r0 ; 2
nop ; 1

delayxus_loop: ; x -> 0x03E7 = ~1 ms

call delay1us_floop
sbiw z, 1 ; 2 cycles
brne delayxus_loop ; 1/2 cycles

ret ; 4 cycles

delay1us_floop:
; 4 cycles to call
push r0 ; 2
pop r0 ; 2

ret ; 4 cycles

delay1us:
; 4 cycles to call
push r0 ; 2
push r1 ; 2
pop r1 ; 2
pop r0 ; 2

ret ; 4 cycles