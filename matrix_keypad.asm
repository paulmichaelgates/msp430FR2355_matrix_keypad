;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file

			.global		get_input
			.sect 		".text"

            .global		init_pins
            .sect 		".text"

            .global		check_for_input
            .sect		".text"
            
            .global 	signal_input
            .sect 		".text"

			.global 	input_detect
			.sect 		.data

			.global 	col
			.sect		.data

			.global 	row
			.sect		.data

			.data

input_detect: 	  	.short 	  	0

col:		.short		0

row:		.short 		0

;-------------------------------------------------------------------------------
; Init Pins
;-------------------------------------------------------------------------------



; checks to see if any button on the num pad has been pressed
init_pins:


			; rows outputs
			bis.b	#BIT0, &P5DIR
			bis.b	#BIT1, &P5DIR
			bis.b	#BIT2, &P5DIR
			bis.b	#BIT3, &P5DIR

			; clear all outputs
			bic.b	#BIT0, &P5OUT
			bic.b	#BIT1, &P5OUT
			bic.b	#BIT2, &P5OUT
			bic.b	#BIT3, &P5OUT

			; cols inputs
			bic.b	#BIT2, &P1DIR
			bic.b	#BIT3, &P1DIR
			bic.b	#BIT4, &P1DIR
			bic.b	#BIT5, &P1DIR


			; enable each pull resistor
			bis.b	#BIT2, &P1REN
			bis.b 	#BIT3, &P1REN
			bis.b	#BIT4, &P1REN
			bis.b	#BIT5, &P1REN

			bis.b	#BIT2, &P1OUT
			bis.b 	#BIT3, &P1OUT
			bis.b	#BIT4, &P1OUT
			bis.b	#BIT5, &P1OUT

			; set high to low configuration
			bis.b	#BIT2, &P1IES
			bis.b	#BIT3, &P1IES
			bis.b	#BIT4, &P1IES
			bis.b	#BIT5, &P1IES

			; turn on digital i/o
			bic.b	#LOCKLPM5, &PM5CTL0

			; clear all interrupt flags
			bic.b	#BIT2, &P1IFG
			bic.b	#BIT3, &P1IFG
			bic.b	#BIT4, &P1IFG
			bic.b	#BIT5, &P1IFG

			; enable local interrupt
			bis.b	#BIT2, &P1IE
			bis.b	#BIT3, &P1IE
			bis.b	#BIT4, &P1IE
			bis.b	#BIT5, &P1IE

			; enable global interrupt
			eint

			ret
;-------------------------------------------------------------------------------
; Interrupt Service Routines
;-------------------------------------------------------------------------------

get_input:

			; reset all flags
			bic.b	#BIT2, &P1IFG
			bic.b	#BIT3, &P1IFG
			bic.b	#BIT4, &P1IFG
			bic.b	#BIT5, &P1IFG

			; disable local interrupt
			bic.b	#BIT2, &P1IE
			bic.b	#BIT3, &P1IE
			bic.b	#BIT4, &P1IE
			bic.b	#BIT5, &P1IE

			mov.w		#0, row
			mov.w		#0, col

			; movecol into r9 and shift right 2x
			mov.w		&P1IN, R10
			rra			R10
			rra			R10

			; cols outputs
			bis.b	#BIT2, &P1DIR
			bis.b	#BIT3, &P1DIR
			bis.b	#BIT4, &P1DIR
			bis.b	#BIT5, &P1DIR

			; disable  each pull resistor in P1
			bic.b	#BIT2, &P1REN
			bic.b 	#BIT3, &P1REN
			bic.b	#BIT4, &P1REN
			bic.b	#BIT5, &P1REN

			; set output pins all to low
			bic.b	#BIT2, &P1OUT
			bic.b	#BIT3, &P1OUT
			bic.b	#BIT4, &P1OUT
			bic.b	#BIT5, &P1OUT

			; rows inputs
			bic.b	#BIT0, &P5DIR
			bic.b	#BIT1, &P5DIR
			bic.b	#BIT2, &P5DIR
			bic.b	#BIT3, &P5DIR

			; enable pull up on all P5 inputs
			bis.b	#BIT0, &P5REN
			bis.b 	#BIT1, &P5REN
			bis.b	#BIT2, &P5REN
			bis.b	#BIT3, &P5REN

			bis.b	#BIT0, &P5OUT
			bis.b 	#BIT1, &P5OUT
			bis.b	#BIT2, &P5OUT
			bis.b	#BIT3, &P5OUT

			; move row into R9
			mov.b	&P5IN, R9

			; disable each pull resistor in P5
			bic.b	#BIT0, &P5REN
			bic.b 	#BIT1, &P5REN
			bic.b	#BIT2, &P5REN
			bic.b	#BIT3, &P5REN

			mov.b 	#0001b, R8

loop_row:

			bit.w 	R8, R9

			jz 		end_row_check

			inc.w	row
			rla		R8

			jmp 	loop_row

end_row_check:

			mov.b 	#0001b, R8

loop_col:

			bit.w	R8, R10

			jz 	    end_col_check

			inc.w 	col
			rla 	R8

			jmp 	loop_col

end_col_check:

			mov.w 	#1, input_detect
			reti

;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
			.sect ".int25"
			.short get_input

			.data
