UART_DATA = $8020
UART_STAT = $8021
UART_CMD  = $8022
UART_CTRL = $8023

.org $8040 ; ROM has an offset of 8024

init:
    lda #0
    sta UART_STAT ; Reset status register

    lda #%00011111 ;  Set Baud rate to 19200
    sta UART_CTRL

    lda #%00001011 ; Interupts active low, no parity, no echo
    sta UART_CMD
    
    jsr new_line



main:
    ;receive
read_char:
    lda UART_STAT
    and #$08 ;check rx buffer flag
    beq read_char ;if empty, try again
    lda UART_DATA
    cmp #13
    bne send
    sta UART_DATA
    jsr sleep
    lda #$a ;newline
    sta UART_DATA
    jsr sleep
    jsr new_line
    jmp main
send:
    ;send
    sta UART_DATA
    jsr sleep
    jmp main

;print the new line sequence
new_line:
    pha
    ldx #0
new_line_loop:
    lda new_cmd_line,x ;Load a with x in string
    cmp #0 ;If null (end of string)
    beq new_line_end ;If done with string exit 
    sta UART_DATA
    jsr sleep ;Send char over UART_CMD
    inx
    jmp new_line_loop
new_line_end:
    pla
    rts



sleep:
  pha ; preserve the accumulator
  lda #0 ; reset the lda
sleep_loop:
  adc #1
  cmp #100 ; Compare the accumulator with 100
  bne sleep_loop
  pla ; pop the accumulator back off
  rts ; return from subroutine


dead_loop:
  jmp dead_loop


new_cmd_line: .asciiz "User: "

  .org $fffc ;65c02 fetches at 0xFFFC, store the address of init there to have the CPU set PC to the start of program
  .word init