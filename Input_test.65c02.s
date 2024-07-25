;65c22 mapping registers
OIRB = $8000 ;Output data register B
OIRA = $8001
DDRB = $8002
DDRA = $8003

  .org $8040 ; ROM has an offset of 8040

; note: stack is from 0x01FF to 0x0100

init:
  ;Set data direction registers on 65c22
  lda #%11111111 ; Set all of port B to output
  sta DDRB
  lda #%00000000 ; Set port A to inputs
  sta DDRA
  ;Ensure the outputs begin as off
  sta OIRB
  lda #0

main:
  lda OIRA ; read the inputs into the accumulator
  ;Turn the IO on
  sta OIRB ;present them on the output
  ;Sleep
  jsr sleep

  ;Repeat
  jmp main


sleep:
  pha ; preserve the accumulator
  lda #0 ; reset the lda
sleep_loop:
  ;nop ; extra pause
  adc #1
  cmp #2 ; Compare the accumulator with 2
  bne sleep_loop
  pla ; pop the accumulator back off
  rts ; return from subroutine

dead_loop:
  jmp dead_loop


  .org $fffc ;65c02 fetches at 0xFFFC, store the address of init there to have the CPU set PC to the start of program
  .word init