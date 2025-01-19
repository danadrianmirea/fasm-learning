format pe64 console
entry start

include 'c:\fasm\include\win64a.inc' ; Include macros for Windows API calls

section '.data' data readable writeable
    buffer db 'Value of RAX: ', 0 ; String prefix
    num_buffer db '0000000000000000h', 0 ; Hex representation of RAX

section '.code' code readable executable
start:
    mov rax, 15             ; Set RAX to 15
    mov rcx, rax            ; Copy RAX to RCX for conversion
    call print_hex          ; Convert RCX to hex string in num_buffer

    ; Print the string
    mov rdx, buffer         ; Address of the prefix string
    call print_string       ; Print the prefix
    mov rdx, num_buffer     ; Address of the hex string
    call print_string       ; Print the hex string

    ; Exit the program
    xor rcx, rcx            ; Exit code 0
    call [ExitProcess]

print_hex:
    ; Convert RCX to a hex string in num_buffer
    mov rdi, num_buffer + 16 ; Start filling from the end
    mov rbx, 16             ; Base (hex)
.hex_loop:
    dec rdi                 ; Move backward in the buffer
    xor rax, rax            ; Clear RAX
    div rbx                 ; Divide RCX by 16
    add dl, '0'             ; Convert remainder to ASCII
    cmp dl, '9'
    jbe .digit_ok
    add dl, 'A' - '9' - 1   ; Convert to letter if above '9'
.digit_ok:
    mov [rdi], dl           ; Store the character
    test rcx, rcx           ; Check if RCX is 0
    jnz .hex_loop           ; Continue if not 0
    ret

print_string:
    ; Print a null-terminated string using WriteConsoleA
    sub rsp, 40             ; Allocate shadow space
    mov rcx, [ConsoleHandle] ; Handle to stdout
    lea r8, [rsp+8]         ; Placeholder for bytes written
    xor r9, r9              ; Reserved
    call [WriteConsoleA]
    add rsp, 40             ; Clean up shadow space
    ret

section '.bss' readable writeable
    ConsoleHandle dq ?      ; Handle to the console

section '.idata' import data readable
    library kernel32, 'kernel32.dll'
    import kernel32, WriteConsoleA, 'WriteConsoleA', GetStdHandle, 'GetStdHandle', ExitProcess, 'ExitProcess'

section '.text' code readable executable
    ; Get a handle to stdout at program startup
    call [GetStdHandle]
    mov [ConsoleHandle], rax
