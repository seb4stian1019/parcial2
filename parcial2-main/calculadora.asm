section .data
    msg1        db      10, '-Calculadora-', 10, 0
    lmsg1       equ     $ - msg1

    msg2        db      10, 'Numero 1: ', 0
    lmsg2       equ     $ - msg2

    msg3        db      'Numero 2: ', 0
    lmsg3       equ     $ - msg3

    msg4        db      '1. Sumar', 10, 0
    lmsg4       equ     $ - msg4

    msg5        db      '2. Restar', 10, 0
    lmsg5       equ     $ - msg5

    msg6        db      '3. Multiplicar', 10, 0
    lmsg6       equ     $ - msg6

    msg7        db      '4. Dividir', 10, 0
    lmsg7       equ     $ - msg7

    msg8        db      'Operacion: ', 0
    lmsg8       equ     $ - msg8

    msg9        db      10, 'Resultado: ', 0
    lmsg9       equ     $ - msg9

    msg10       db      10, 'Opcion Invalida', 10, 0
    lmsg10      equ     $ - msg10

    msg_exit    db      10, 'Escriba "e" para salir', 10, 0
    lmsg_exit   equ     $ - msg_exit

    msg_prompt_exit db  10, '¡Gracias por usar la calculadora!', 10, 0
    lmsg_prompt_exit equ $ - msg_prompt_exit

    nlinea      db      10, 10, 0
    lnlinea     equ     $ - nlinea

section .bss
    opcion:     resb    2
    num1:       resb    3
    num2:       resb    3
    resultado:  resb    5
    buffer:     resb    2

section .text
    global _start

_start:
main_loop:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg1
    mov edx, lmsg1
    int 80h

    mov eax, 4
    mov ebx, 1
    mov ecx, msg_exit
    mov edx, lmsg_exit
    int 80h

    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, lmsg2
    int 80h

    mov eax, 3
    mov ebx, 0
    mov ecx, num1
    mov edx, 3
    int 80h

    cmp byte [num1], 'e'
    je salir

    mov eax, 4
    mov ebx, 1
    mov ecx, msg3
    mov edx, lmsg3
    int 80h

    mov eax, 3
    mov ebx, 0
    mov ecx, num2
    mov edx, 3
    int 80h

    mov eax, 4
    mov ebx, 1
    mov ecx, msg4
    mov edx, lmsg4
    int 80h

    mov eax, 4
    mov ebx, 1
    mov ecx, msg5
    mov edx, lmsg5
    int 80h

    mov eax, 4
    mov ebx, 1
    mov ecx, msg6
    mov edx, lmsg6
    int 80h

    mov eax, 4
    mov ebx, 1
    mov ecx, msg7
    mov edx, lmsg7
    int 80h

    mov eax, 4
    mov ebx, 1
    mov ecx, msg8
    mov edx, lmsg8
    int 80h

    mov eax, 3
    mov ebx, 0
    mov ecx, opcion
    mov edx, 2
    int 80h

    mov al, [opcion]
    sub al, '0'

    cmp al, 1
    je sumar

    cmp al, 2
    je restar

    cmp al, 3
    je multiplicar

    cmp al, 4
    je dividir

    mov eax, 4
    mov ebx, 1
    mov ecx, msg10
    mov edx, lmsg10
    int 80h
    jmp main_loop

sumar:
    mov al, [num1]
    mov bl, [num2]

    cmp al, '-'
    jne num1_positivo
    mov al, [num1+1]
    sub al, '0'
    neg al
    jmp num2_check

num1_positivo:
    sub al, '0'

num2_check:
    cmp bl, '-'
    jne num2_positivo
    mov bl, [num2+1]
    sub bl, '0'
    neg bl
    jmp realizar_suma

num2_positivo:
    sub bl, '0'

realizar_suma:
    add al, bl
    js resultado_negativo

resultado_positivo:
    mov ah, 0
    mov bx, 10
    div bl
    add al, '0'
    mov [resultado], al

    add ah, '0'
    mov [resultado + 1], ah
    mov byte [resultado + 2], 0

    mov eax, 4
    mov ebx, 1
    mov ecx, msg9
    mov edx, lmsg9
    int 80h

    mov eax, 4
    mov ebx, 1
    mov ecx, resultado
    mov edx, 3
    int 80h

    jmp main_loop

resultado_negativo:
    neg al
    mov ah, 0
    mov bx, 10
    div bl
    add al, '0'
    mov [resultado+1], al

    add ah, '0'
    mov [resultado+2], ah
    mov byte [resultado], '-'
    mov byte [resultado+3], 0

    mov eax, 4
    mov ebx, 1
    mov ecx, msg9
    mov edx, lmsg9
    int 80h

    mov eax, 4
    mov ebx, 1
    mov ecx, resultado
    mov edx, 4
    int 80h

    jmp main_loop

restar:
    mov al, [num1]
    mov bl, [num2]

    cmp al, '-'
    jne num1_resta_positivo
    mov al, [num1+1]
    sub al, '0'
    neg al
    jmp num2_resta_check

num1_resta_positivo:
    sub al, '0'

num2_resta_check:
    cmp bl, '-'
    jne num2_resta_positivo
    mov bl, [num2+1]
    sub bl, '0'
    neg bl
    jmp realizar_resta

num2_resta_positivo:
    sub bl, '0'

realizar_resta:
    sub al, bl
    js resultado_resta_negativo

resultado_resta_positivo:
    mov ah, 0
    mov bx, 10
    div bl
    add al, '0'
    mov [resultado], al

    add ah, '0'
    mov [resultado + 1], ah
    mov byte [resultado + 2], 0

    mov eax, 4
    mov ebx, 1
    mov ecx, msg9
    mov edx, lmsg9
    int 80h

    mov eax, 4
    mov ebx, 1
    mov ecx, resultado
    mov edx, 3
    int 80h

    jmp main_loop

resultado_resta_negativo:
    neg al
    mov ah, 0
    mov bx, 10
    div bl
    add al, '0'
    mov [resultado+1], al

    add ah, '0'
    mov [resultado+2], ah
    mov byte [resultado], '-'
    mov byte [resultado+3], 0

    mov eax, 4
    mov ebx, 1
    mov ecx, msg9
    mov edx, lmsg9
    int 80h

    mov eax, 4
    mov ebx, 1
    mov ecx, resultado
    mov edx, 4
    int 80h

    jmp main_loop

multiplicar:
    mov al, [num1]
    mov bl, [num2]
    sub al, '0'
    sub bl, '0'
    mul bl

    mov bx, 10
    xor dx, dx

    div bl
    add al, '0'
    mov [resultado], al

    add ah, '0'
    mov [resultado + 1], ah
    mov byte [resultado + 2], 0

    mov eax, 4
    mov ebx, 1
    mov ecx, msg9
    mov edx, lmsg9
    int 80h

    mov eax, 4
    mov ebx, 1
    mov ecx, resultado
    mov edx, 3
    int 80h

    jmp main_loop

dividir:
    mov al, [num1]          
    mov bl, [num2]          
    sub al, '0'            
    sub bl, '0'            


    cmp bl, 0
    je div_error           


    mov ah, 0            
    div bl                 


    add al, '0'
    mov [resultado], al
    add ah, '0'
    mov [resultado + 1], ah
    mov byte [resultado + 2], 0


    mov eax, 4
    mov ebx, 1
    mov ecx, msg9
    mov edx, lmsg9
    int 80h

    mov eax, 4
    mov ebx, 1
    mov ecx, resultado
    mov edx, 3
    int 80h
    jmp main_loop

div_error:

    mov eax, 4
    mov ebx, 1
    mov ecx, msg10        
    mov edx, lmsg10
    int 80h
    jmp main_loop


salir:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_prompt_exit
    mov edx, lmsg_prompt_exit
    int 80h

    mov eax, 1
    mov ebx, 0
    int 80h