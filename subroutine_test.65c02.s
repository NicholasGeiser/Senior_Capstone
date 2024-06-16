;65c22 mapping registers
OIRB = $8000 ;Output data register B
OIRA = $8001
DDRB = $8002
DDRA = $8003

  .org $8048 ; ROM has an offset of 8024

init:
  ;Set data direction registers on 65c22
  lda #%11111111 ; Set all of port B to output
  sta DDRB
  lda #%00000000 ; Set port A to inputs
  sta DDRA
  ;Ensure the outputs begin as off
  sta OIRB
  sta OIRA

main:
  ;Turn the LED on
  lda #%11111111 ; Set pin 1 of port B to high (LED)
  sta OIRB
  ;Sleep
  jsr sleep

  ;turn LED off
  lda #%00000000 ; Set pin 1 of port B to low (LED)
  sta OIRB
  ;Sleep
  jsr sleep

  ;Repeat
  jmp main


sleep:
  pha ; preserve the accumulator
  lda #0 ; reset the lda
sleep_loop:
  nop ; extra pause
  adc #1
  cmp #10 ; Compare the accumulator with 100
  bne sleep_loop
  pla ; pop the accumulator back off
  rts ; return from subroutine

dead_loop:
  jmp dead_loop


  .org $fffc ;65c02 fetches at 0xFFFC, store the address of init there to have the CPU set PC to the start of program
  .word init