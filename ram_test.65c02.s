;65c22 mapping registers
OIRB = $8000 ;Output data register B
OIRA = $8001
DDRB = $8002
DDRA = $8003

; note: stack is from 0x01FF to 0x0100

  .org $8040 ; ROM has an offset of 8024

init:
  ;Set data direction registers on 65c22
  lda #%11111111 ; Set all of port B to output
  sta DDRB
  lda #%00000000 ; Set port A to inputs
  sta DDRA
  ;Ensure the outputs begin as off
  sta OIRB

main:
  ;Turn the LED on
  lda #%11111111 ; Set pin 1 of port B to high (LED)
  sta OIRB
  ;Sleep
  lda #0 ;loops and increases the lda each time to pause
sleep1:
  nop ; extra pause
  adc #1
  pha ; Push onto the stack
  lda #0 ;Make sure it would break if it didn't actually push and pop
  pla ; Pop off the stack back into accumulator
  cmp #3 ; Compare the accumulator with 3
  bne sleep1

  ;turn LED off
  lda #%00000000 ; Set pin 1 of port B to low (LED)
  sta OIRB
  ;Sleep
  lda #0 ;loops and increases the lda each time to pause
sleep2:
  nop ; extra pause
  adc #1
  pha ; Push onto the stack
  lda #0 ;Make sure it would break if it didn't actually push and pop
  pla ; Pop off the stack back into accumulator
  cmp #3 ; Compare the accumulator with 3
  bne sleep2

  ;Repeat
  jmp main


dead_loop:
  jmp dead_loop


  .org $fffc ;65c02 fetches at 0xFFFC, store the address of init there to have the CPU set PC to the start of program
  .word init