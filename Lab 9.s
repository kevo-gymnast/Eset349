				area steppeMotor, code, readonly 
step 			rn r9
switch 			rn r10

Pulses			dcb 0x0C, 0x06, 0x03, 0x09

				export __main
__main			proc
	
				; config
				ldr r7, =Pulses						; r7 points to step values
				ldr r0, =0x40004C21					; port 4
				mov r1, #0x0F						; 7,6,5,4 input | 3,2,1,0 output => 0000 1111
				strb r1, [r0, #0x04]
				mov r1, #0xF0						; REN for input pins => 1111 0000
				strb r1, [r0, #0x06]
				strb r1, [r0, #0x02]				; pull up resistors
				
forever
				ldrb r2, [r0, #0x00]				; read whole port 4
				AND r2, #0x10						; pin 4 => 0001 0000
				cmp r2, #0x10
				bne infCW
				ldrb r2, [r0, #0x00]				; read whole port 4
				AND r2, #0x40						; pin 4 => 0100 0000
				cmp r2, #0x40
				bne infCCW
				
				; depending on when you catch the program, btn 4 will spin CW or CCW
				ldrb r2, [r0, #0x00]				; read whole port 4
				AND r2, #0x80						; pin 4 => 0001 0000
				cmp r2, #0x80
				bne infCW
				ldrb r2, [r0, #0x00]				; read whole port 4
				AND r2, #0x80						; pin 4 => 0001 0000
				cmp r2, #0x80
				bne infCCW
				
				b forever
				
infCW			BL rotCW
				ldrb r2, [r0, #0x00]				; read whole port 4
				AND r2, #0x20						; check for middle button => 0010 0000
				cmp r2, #0x20
				bne forever
				b infCW
				
infCCW			BL rotCCW
				ldrb r2, [r0, #0x00]				; read whole port 4
				AND r2, #0x20						; check for middle button => 0010 0000
				cmp r2, #0x20
				bne forever
				b infCCW


				endp
			
rotCW			function
				ldr r2, =Pulses						; step values to be incremented
				mov r12, #0							; counter
keep_rotCW		ldrb r3, [r2]
				strb r3, [r0, #0x02]				; send pulse to output
				push {LR}
				BL delay
				pop {LR}
				add r12, #1							; inc counter
				add r2, #1							; inc pointer
				cmp r12, #4							; 4 total pulses for one rot
				bne keep_rotCW
				
				BX LR
				endp
					
rotCCW			function
				ldr r2, =Pulses						; step values to be incremented
				add r2, #3							; start at end of list
				mov r12, #0							; counter
keep_rotCCW		ldrb r3, [r2]
				strb r3, [r0, #0x02]				; send pulse to output
				push {LR}
				BL delay
				pop {LR}
				add r12, #1							; inc counter
				sub r2, #1							; inc pointer
				cmp r12, #4							; 4 total pulses for one rot
				bne keep_rotCCW
				
				BX LR
				endp
			
delay			function
				mov r4, #50
outer			mov r5, #255
inner			subs r5, #1
				bne inner
				subs r4, #1
				bne outer
				
				BX LR
				endp
					
				end