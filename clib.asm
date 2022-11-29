; AUTHOR: ASHWIN ABRAHAM

; This code prints out the number of command line arguments it recieves and then prints these arguments
; This code demonstrates the ability to call C library functions from an assembly program

section .rodata
format db 'Number of command line arguments', 58, ' %d', 10, 'Command Line Arguments', 58, 10, 0; 58 is ':' and 10 is '\n'

section .text
global main
extern printf
extern puts

main:
    push rbp
    mov rbp, rsp

    push rdi
    push rsi
    mov esi, edi
    mov rdi, format
    call printf WRT ..plt
    pop rsi
    pop rdi

    mov ecx, edi
    mov eax, edi
    .1:
        push rcx
        push rax
        push rsi
        sub eax, ecx
        mov rdi, [rsi+8*rax]
        call puts WRT ..plt
        pop rsi
        pop rax
        pop rcx
    loop .1

    xor eax, eax
    ;mov rsp, rbp
    pop rbp
    ret