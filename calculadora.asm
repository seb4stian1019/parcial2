section .data
    prompt_num1 db "Ingrese el primer numero (o 'exit' para salir): ", 0
    prompt_num2 db "Ingrese el segundo numero: ", 0
    prompt_op db "Ingrese la operacion (+, -, *, /, %): ", 0
    result_msg db "Resultado: ", 0
    error_div0_msg db "Error: Division por cero.", 0
    exit_msg db "Saliendo del programa...", 0
    newline db 0xA, 0
    input_buffer db 20 dup(0)

section .bss
    num1 resd 1
    num2 resd 1
    result resd 1

section .text
    global _start

_start:
    bucle_principal:
        ; Solicitar el primer número
        call solicitar_numero
        cmp eax, -1          ; Verificar si el usuario ingresó "exit"
        je salir_programa
        mov [num1], eax      ; Almacenar el primer número

        ; Solicitar el segundo número
        call solicitar_numero
        cmp eax, -1          ; Verificar si el usuario ingresó "exit"
        je salir_programa
        mov [num2], eax      ; Almacenar el segundo número

        ; Solicitar la operación
        call solicitar_operacion
        cmp al, '+'          ; Verificar la operación
        je hacer_suma
        cmp al, '-'          
        je hacer_resta
        cmp al, '*'
        je hacer_multiplicacion
        cmp al, '/'
        je hacer_division
        cmp al, '%'
        je hacer_modulo
        jmp fin              ; Si no es un operador válido, terminar

hacer_suma:
    mov eax, [num1]
    add eax, [num2]
    mov [result], eax
    jmp mostrar_resultado

hacer_resta:
    mov eax, [num1]
    sub eax, [num2]
    mov [result], eax
    jmp mostrar_resultado

hacer_multiplicacion:
    mov eax, [num1]
    imul eax, [num2]
    mov [result], eax
    jmp mostrar_resultado

hacer_division:
    mov eax, [num2]
    cmp eax, 0
    je error_division_por_cero
    mov eax, [num1]
    xor edx, edx        ; Limpiar edx antes de la división
    idiv dword [num2]
    mov [result], eax
    jmp mostrar_resultado

hacer_modulo:
    mov eax, [num2]
    cmp eax, 0
    je error_division_por_cero
    mov eax, [num1]
    xor edx, edx        ; Limpiar edx antes de la división
    idiv dword [num2]
    mov eax, edx        ; Almacenar el residuo en eax
    mov [result], eax
    jmp mostrar_resultado

error_division_por_cero:
    mov eax, 4
    mov ebx, 1
    mov ecx, error_div0_msg
    mov edx, 22
    int 0x80
    jmp fin

mostrar_resultado:
    mov eax, 4
    mov ebx, 1
    mov ecx, result_msg
    mov edx, 10
    int 0x80

    ; Mostrar el resultado
    mov eax, [result]
    call imprimir_resultado
    jmp bucle_principal

fin:
    jmp bucle_principal  ; Volver al inicio del bucle

salir_programa:
    ; Mensaje de salida
    mov eax, 4
    mov ebx, 1
    mov ecx, exit_msg
    mov edx, 26
    int 0x80

    ; Terminar el programa
    mov eax, 1
    xor ebx, ebx
    int 0x80

; Solicitar un número al usuario
solicitar_numero:
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_num1
    mov edx, 50
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, input_buffer
    mov edx, 20
    int 0x80

    ; Comprobar si el usuario quiere salir
    cmp byte [input_buffer], 'e'
    je .exit_check
    cmp byte [input_buffer + 1], 'x'
    je .exit_check
    cmp byte [input_buffer + 2], 'i'
    je .exit_check
    cmp byte [input_buffer + 3], 't'
    je .exit_check
    jmp .convert_to_number

.exit_check:
    mov eax, -1  ; Marcar que se quiere salir
    ret

.convert_to_number:
    xor eax, eax          ; Limpiar eax
    xor ecx, ecx          ; Limpiar ecx (contar dígitos)

    .convert_loop:
        cmp byte [input_buffer + ecx], 10  ; Comprobar el carácter de nueva línea
        je .done_conversion
        sub byte [input_buffer + ecx], '0'  ; Convertir de ASCII a número
        movzx ebx, byte [input_buffer + ecx]  ; Cargar el dígito en ebx
        add eax, ebx         ; Sumar el dígito actual
        inc ecx              ; Ir al siguiente carácter
        jmp .convert_loop
    .done_conversion:
    ret

; Solicitar la operación al usuario
solicitar_operacion:
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_op
    mov edx, 40
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, input_buffer
    mov edx, 2
    int 0x80

    movzx eax, byte [input_buffer]  ; Obtener la operación
    ret

; Imprimir resultado (asume que el resultado está en eax)
imprimir_resultado:
    ; Convertir el número a ASCII para mostrarlo
    push eax
    mov ecx, input_buffer           ; Buffer para el resultado
    mov ebx, 10                     ; Divisor
    xor edx, edx                    ; Limpiar edx (para la división)
    .itoa_loop:
        xor edx, edx                ; Limpiar edx
        div ebx                     ; Dividir eax entre 10
        add dl, '0'                ; Convertir el residuo a carácter ASCII
        dec ecx                     ; Mover hacia atrás en el buffer
        mov [ecx], dl              ; Almacenar el carácter en el buffer
        test eax, eax               ; Comprobar si el cociente es 0
        jnz .itoa_loop              ; Repetir si no es 0

    ; Mostrar el número convertido
    mov eax, 4
    mov ebx, 1
    mov edx, 20                    ; Longitud máxima
    sub edx, ecx                   ; Ajustar longitud
    int 0x80

    ; Mostrar nueva línea
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    pop eax
    ret