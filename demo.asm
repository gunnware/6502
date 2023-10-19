    processor 6502
    seg Code    ; Code segment
    org $F000   ; Start this code at F000h

Start:
    cld
    ldx #$80    ; Load X with 80h
    lda #0      ; Load Y with 0
Clear:
    sta 0,X     ; Store the accumulator at 0 offset by +X
    inx         ; Increment X
    bne Clear   ; Has X rolled over to 0?  If not go back to Clear.

FibSeed:
    ldx #1      ; Load X with 1.
    stx $80     ; Store X into $80.
    ldx #2      ; Load X with 2.
    stx $81     ; Store X into $81.
FibPrep:
    ldy #0      ; Load 0 into Y
FibLoop:
    lda $80,Y   ; Load A from 80 offset by Y (first number)
    iny         ; Increment Y
    clc         ; Clear carry
    adc $80,Y   ; Add 80 offset by Y (second number)
    iny         ; Increment Y
    sta $80,Y   ; Store A in 80 offset by Y
    cmp #233    ; Are we nearing the end of what's possible with 8 bits?
    beq Done    ; If so, jump to Done
    dey         ; Decrement Y (go back to our second number) for the next round
    jmp FibLoop ; Do another round
    
Done:
    jmp Done

    org $FFFC   ; End the ROM by adding required values to memory position $FFFC
    .word Start ; Put 2 bytes with the reset address at memory position $FFFC
    .word Start ; Put 2 bytes with the break address at memory position $FFFE
