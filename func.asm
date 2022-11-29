; AUTHOR: ASHWIN ABRAHAM

; This code defines two functions that, calculate the factorial of an integer (given as input), one iteratively and the other recursively
; These functions can then be called from a C/C++ source file, after linking the file to the object module produced by assembling this file

section .text
    global fact_rec
    global fact_loop

    fact_loop:
        push rbp
        mov rbp, rsp

        mov eax, 1
        cmp edi, 0
        jle .return

        push rcx
        mov ecx, edi
        .0:
            imul eax, ecx
        loop .0
        pop rcx

        .return:
            ;mov rsp, rbp
            pop rbp
            ret


    fact_rec:
        push rbp
        mov rbp, rsp

        mov eax, 1
        cmp edi, 0
        jle .return

        dec edi
        call fact_rec
        inc edi
        imul eax, edi

        .return:
            ;mov rsp, rbp
            pop rbp
            ret