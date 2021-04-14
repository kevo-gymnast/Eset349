                      area finalProject, code, readonly
                      export __main

Pattern               dcb 0x00              ; prob make pattern array here

__main                proc


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
