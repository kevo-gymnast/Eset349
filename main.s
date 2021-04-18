                      area finalProject, code, readonly
                      export __main

Pattern               dcb 0x01, 0x03, 0x02, 0x03, 0x01, 0x01, 0x02, 0x03, 0x01. 0x02; unsure what registers are being used for each color
                      numElements equ 10              
__main                proc
                      ldr r0, =0x20002000
		                  ldr r1, =sequence_data

                      endp

delay			            function
              				mov r4, #50
outer            			mov r5, #255
inner			            subs r5, #1
              				bne inner
              				subs r4, #1
              				bne outer

              				BX LR
              				endp

              				end
