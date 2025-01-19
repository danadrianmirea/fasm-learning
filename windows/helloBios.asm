; This is a simple real-mode program that outputs text to the screen using BIOS interrupt 10h
org 0x7C00   ; Boot sector starting address

; BIOS video interrupt 10h service 0x0E for text output

start:
    ; Set the video mode (text mode 80x25, color)
    mov ah, 0x00         ; BIOS video service: set video mode
    mov al, 0x03         ; 0x03 = 80x25 text mode, color
    int 0x10             ; Call BIOS interrupt

    ; Display message: "Hello, BIOS!"
    mov ah, 0x0E         ; BIOS function: Teletype output (display character)
    mov al, 'H'          ; Character to display
    int 0x10             ; Call BIOS interrupt
    mov al, 'e'
    int 0x10
    mov al, 'l'
    int 0x10
    mov al, 'l'
    int 0x10
    mov al, 'o'
    int 0x10
    mov al, ','
    int 0x10
    mov al, ' '
    int 0x10
    mov al, 'B'
    int 0x10
    mov al, 'I'
    int 0x10
    mov al, 'O'
    int 0x10
    mov al, 'S'
    int 0x10
    mov al, '!'
    int 0x10

    ; Infinite loop to keep the program running
hang:
    jmp hang

times 510 - ($ - $$) db 0   ; Fill the rest of the boot sector with 0
dw 0xAA55                   ; Boot sector signature