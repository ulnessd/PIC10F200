; program to practice writing to a SIPO shift register: 74HC595
    
    
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
		     
		     ;use GP0 for data
		     ;use GP1 for clock
		     ;use GP2 for displaying

    tris 6 ;the 6 sets tris to the value stored in W
    nop
    movlw 0b11011111 ;the zero here will set GP2 to IO rather than external clock
    option ; the contents of the working register is moved to OPTION register 
    nop

    bsf GP2
mainloop:
    movlw 8 ; sets number bits to write 
    movwf 0x13 ; stores number of bits to write in memory address 0x13
    movlw 0b11010110; data to write to shift register
    movwf 0x14; stores data to write in memory address 0x14
    movlw 0 ; read bit index
    movwf 0x15 ; stores read bit index memory address 0x15
    nop

    
readdata:    
    bcf GP1; sets clock output to low. will not clock in data
    bcf GP0 ; sets data the output to low 
    btfss GP3 ; Polls GP3 until a high signal is received
    goto readdata
    bsf GP2
readbit:    
    movlw  22  ;This should delay about 0.07 s --22^3/153600 s--
    bcf GP0
    btfsc 0x14, 0 ; reads bit 0 of 0x14
    bsf GP0; sets data output to high
    nop
    call delay
    movlw  22  ;This should delay about 0.07 s --22^3/153600 s--
    call delay ; this turns the data on half a second before clock
    bsf GP1 ;
    movlw  22  ;This should delay about 0.07 s --22^3/153600  s--
    call delay ; this turns the clock on for half a second
    bcf GP1 ; this sets the clock to low
    rrf 0x14, 1; rotates the bits in 0x14
    decfsz 0x13, 1 
    goto readbit
    bcf GP2
    goto mainloop
    nop

    
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
