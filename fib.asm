; AUTHOR: ASHWIN ABRAHAM

; This code calculates the nth Fibonacci number, for a given n, using 5 different algorithms

section .rodata
    format_printf_loop db 'Loop Fibonacci', 58, ' %d', 10, 0
    format_printf_rec db 'Recursive Fibonacci', 58, ' %d', 10, 0
    format_printf_TR_no db 'Unoptimized Tail Recursive Fibonacci', 58, ' %d', 10, 0
    format_printf_TR_o db 'Optimized Tail Recursive Fibonacci', 58, ' %d', 10, 0
    format_printf_memo db 'Memoized Fibonacci', 58, ' %d', 10, 0
    format_scanf db '%d', 0

section .bss
    alloc_size resd 1
    buff resq 1
    calc_size resd 1

section .text
global main
extern printf
extern scanf
extern malloc
extern free

get_el:
    push rbp
    mov rbp, rsp

    cmp edi, DWORD [alloc_size]
    jl ret_get_el

    ; growing the buffer (size -> 2*i + 1)
    push rdi
    shl rdi,1
    inc edi
    push rdi
    shl rdi, 2
    call malloc WRT ..plt
    xor rdi, rdi

    mov edx, DWORD [alloc_size]
    shl rdx, 2
    start_loop:
        cmp edi, edx
        jge end_loop
        mov rcx, QWORD [buff]
        mov ecx, DWORD [rcx+rdi]
        mov DWORD [rax+rdi], ecx
        add edi, 4
        jmp start_loop
    end_loop:

    mov rdi, QWORD [buff]
    mov QWORD [buff], rax
    call free WRT ..plt
    pop rax
    mov DWORD [alloc_size], eax
    pop rdi


    ret_get_el:
        mov rax, QWORD [buff]
        push rdi
        shl rdi, 2
        add rax, rdi
        pop rdi

        pop rbp
        ret

loop_fib:
    push rbp
    mov rbp, rsp

    mov eax, 0
    cmp edi, 0
    jle ret_loop_fib

    push rbx
    mov ebx, 1
    mov ecx, edi
    head:
        mov edx, eax
        mov eax, ebx
        add ebx, edx
    loop head

    pop rbx


    ret_loop_fib:
        pop rbp
        ret

rec_fib:
    push rbp
    mov rbp, rsp

    mov eax, 0
    cmp edi, 0
    jle ret_rec_fib

    mov eax, 1
    cmp edi, 1
    je ret_rec_fib

    push rcx

    dec edi
    call rec_fib
    mov ecx, eax

    dec edi
    call rec_fib
    add eax, ecx

    pop rcx

    add edi, 2

    ret_rec_fib:
        pop rbp
        ret

memo_fib:
    push rbp
    mov rbp, rsp

    mov eax, 0
    cmp edi, 0
    jl ret_memo_fib

    cmp edi, DWORD [calc_size]
    jl calculated

    dec edi
    call memo_fib
    push rax
    dec edi
    call memo_fib
    pop rcx
    add eax, ecx
    push rax
    add edi, 2
    call get_el
    pop rcx
    mov DWORD [rax], ecx
    mov eax, ecx
    inc edi
    mov DWORD [calc_size], edi
    dec edi
    jmp ret_memo_fib

    calculated:
        call get_el
        mov eax, DWORD [rax]

    ret_memo_fib:
        pop rbp
        ret

TR_rec_fib:
    push rbp
    mov rbp, rsp

    mov eax, esi
    cmp edi, 0
    jle ret_TR_rec_fib

    push rsi
    push rdx

    mov ecx, edx
    add edx, esi
    mov esi, ecx

    dec edi

    call TR_rec_fib

    pop rdx
    pop rsi
    inc edi

    ret_TR_rec_fib:
        pop rbp
        ret

TR_fib:
    push rbp
    mov rbp, rsp

    top_TR_fib:
        mov eax, esi
        cmp edi, 0
        jle ret_TR_fib

        mov ecx, edx
        add edx, esi
        mov esi, ecx

        dec edi
    jmp top_TR_fib

    ret_TR_fib:
        pop rbp
        ret

main:
    push rbp
    mov rbp, rsp

    mov edi, 1
    call get_el
    mov DWORD [rax], 1
    sub rax, 4
    mov DWORD [rax], 0
    mov DWORD [calc_size], 2

    sub rsp, 16

    inf:
        mov rdi, format_scanf
        lea rsi, [rbp-4]
        call scanf WRT ..plt

        mov edi, DWORD [rbp-4]
        call loop_fib
        mov esi, eax
        mov rdi, format_printf_loop
        call printf WRT ..plt

        mov edi, DWORD [rbp-4]
        call memo_fib
        mov esi, eax
        mov rdi, format_printf_memo
        call printf WRT ..plt

        mov edi, DWORD [rbp-4]
        mov esi, 0
        mov edx, 1
        call TR_fib
        mov esi, eax
        mov rdi, format_printf_TR_o
        call printf WRT ..plt

        mov edi, DWORD [rbp-4]
        mov esi, 0
        mov edx, 1
        call TR_rec_fib
        mov esi, eax
        mov rdi, format_printf_TR_no
        call printf WRT ..plt

        mov edi, DWORD [rbp-4]
        call rec_fib
        mov esi, eax
        mov rdi, format_printf_rec
        call printf WRT ..plt

    jmp inf

    xor eax, eax
    mov rsp, rbp
    pop rbp
    ret