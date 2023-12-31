PROCESSOR 10F200

; PIC10F200 Configuration Bit Settings

; Assembly source line config statements

; CONFIG
  CONFIG  WDTE = OFF            ; Watchdog Timer (WDT disabled)
  CONFIG  CP = OFF              ; Code Protect (Code protection off)
  CONFIG  MCLRE = OFF           ; Master Clear Enable (GP3/MCLR pin fuction is digital I/O, MCLR internally tied to VDD)

; config statements should precede project file includes.
#include <xc.inc>


PSECT resetVect, class=CODE, delta=2
resetVect:
    PAGESEL main
    goto main
    
    
PSECT code, delta=2
main:
    
    movlw 0b00001000 ; first four zeros are irrelevent. 
		     ; last four GP3, GP2, GP1, GP0
		     ; 1 will set to input, 0 will set to output
		     ; GP3 is input only.
		     
		     ;use GP0 for output blinker
		     ;use GP1 for clock
		     ;use GP2 for reading data

    tris 6 ;the 6 sets tris to the value stored in W
    nop
    movlw 0b11011111 ;the zero here will set GP2 to IO rather than external clock
    option ; the contents of the working register is moved to OPTION register 
    nop


mainloop:
    bsf GP2
    bcf GP0
    movlw 60
    call delay
    bcf GP2
    movlw 40
    call delay
    bsf GP2
    movlw 0
    movwf 0x14
    movlw 8
    movwf 0x15
    nop
readdata:    
    bsf GP1
    movlw 12
    call delay
    movlw 31
    nop 
    nop
    nop
    btfsc GP3
    bsf 0x14, 0
    btfss GP3
    bcf 0x14, 0
    nop
    nop
    call delay
    bcf GP1
    movlw 43
    call delay
    rrf 0x14, 1
    decfsz 0x15,1
    goto readdata
    nop
 

    
blinker:
    movf 0x14, 0
    bsf GP0
    call delay
    bcf GP0
    movf 0x14, 0
    call delay
    goto blinker
    
delay: ; this is a three-layer nested loop. wouldn't need 3 but it is what I had 
	; from other programs
    movwf 0x12
out_out_loop:
    movwf 0x11
outer_loop:
    movwf 0x10
delay_loop:
    decfsz 0x10, 1
    goto delay_loop
    decfsz 0x11, 1
    goto outer_loop
    decfsz 0x12, 1
    goto out_out_loop
    retlw 0 ; the return sets the working register to zero. 
    nop
    
END resetVect 

