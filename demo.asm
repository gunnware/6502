    processor 6502
    seg Code        ; Code segment
    org $F000       ; Start this code at F000h
FibSeq = $80        ; Sequence starts here
FibMax = 233        ; Max fibonacci number we need

Start:  
    cld             ; Make sure we are not in BCD mode
    ldy #0          ; Reset Y
    ldx #FibSeq     ; Load X with starting location
    lda #0          ; Load accumulator with 0
Clear:  
    sta 0,X         ; Store the accumulator at 0 offset by +X
    inx             ; Increment X
    bne Clear       ; Has X rolled over to 0?  If not go back to Clear
    nop             ; Do nothing
    nop             ; Do nothing

Seed:   
    ldx #0          ; Load X with 0
    stx FibSeq,Y    ; Store X into offset
    iny             ; Increment Y
    ldx #1          ; Load X with 1
    stx FibSeq,Y    ; Store X into offset
    dey             ; Decrement Y to point to the first number
Loop:   
    lda FibSeq,Y    ; Load A from the offset (first number)
    iny             ; Increment Y
    clc             ; Clear carry
    adc FibSeq,Y    ; Add the offset contents to A (second number)
    iny             ; Increment Y
    sta FibSeq,Y    ; Store A in offset
    dey             ; Decrement Y (go back to our second number) for the next round
    cmp #FibMax     ; Are we at the end of what's possible with 8 bits?
    beq Done        ; If so, jump to Done
    jmp Loop        ; Otherwise, do another round

Done:   
    jmp Done        ; Wait in a loop forever

    org $FFFC       ; End the ROM by adding required values to memory position $FFFC
    .word Start     ; Put 2 bytes with the reset address at memory position $FFFC
    .word Start     ; Put 2 bytes with the break address at memory position $FFFE
