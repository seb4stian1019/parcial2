section .data
    ; Mensajes
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
    num1:       resb    3    ; Espacio para 2 dígitos + terminador
    num2:       resb    3    ; Espacio para 2 dígitos + terminador
    resultado:  resb    5    ; Espacio para resultado de hasta 4 caracteres + terminador
    buffer:     resb    2    ; Buffer para leer una letra (como "e" para salir)

section .text
    global _start

_start:
    ; Bucle principal
main_loop:
    ; Mostrar el mensaje de la calculadora
    mov eax, 4
    mov ebx, 1
    mov ecx, msg1
    mov edx, lmsg1
    int 80h

    ; Mostrar opción para salir
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_exit
    mov edx, lmsg_exit
    int 80h

    ; Mostrar mensaje para pedir el primer número
    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, lmsg2
    int 80h

    ; Leer el primer número o comando
    mov eax, 3
    mov ebx, 0
    mov ecx, num1
    mov edx, 3    ; Leer hasta 3 caracteres (2 dígitos + terminador)
    int 80h

    ; Comparar con el comando de salida "e"
    cmp byte [num1], 'e'
    je salir  ; Si el usuario ingresa 'e', salimos

    ; Mostrar mensaje para pedir el segundo número
    mov eax, 4
    mov ebx, 1
    mov ecx, msg3
    mov edx, lmsg3
    int 80h

    ; Leer el segundo número
    mov eax, 3
    mov ebx, 0
    mov ecx, num2
    mov edx, 3    ; Leer hasta 3 caracteres
    int 80h

    ; Mostrar opciones de operación
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

    ; Solicitar la operación
    mov eax, 4
    mov ebx, 1
    mov ecx, msg8
    mov edx, lmsg8
    int 80h

    ; Leer la opción seleccionada
    mov eax, 3
    mov ebx, 0
    mov ecx, opcion
    mov edx, 2
    int 80h

    ; Convertir la opción de ASCII a decimal
    mov al, [opcion]
    sub al, '0'

    ; Evaluar la opción seleccionada
    cmp al, 1
    je sumar

    cmp al, 2
    je restar

    cmp al, 3
    je multiplicar

    cmp al, 4
    je dividir

    ; Si la opción no es válida, mostrar error
    mov eax, 4
    mov ebx, 1
    mov ecx, msg10
    mov edx, lmsg10
    int 80h
    jmp main_loop

sumar:
    ; Lógica de suma
    ; Convertir los números de ASCII a valores numéricos con signo
    mov al, [num1]
    mov bl, [num2]
    
    ; Comprobar si num1 es negativo
    cmp al, '-'
    jne num1_positivo
    mov al, [num1+1]   ; Ignoramos el signo '-' para la operación
    sub al, '0'        ; Convertimos de ASCII a decimal
    neg al             ; Hacemos que num1 sea negativo
    jmp num2_check

num1_positivo:
    sub al, '0'        ; Convertimos de ASCII a decimal

num2_check:
    ; Comprobar si num2 es negativo
    cmp bl, '-'
    jne num2_positivo
    mov bl, [num2+1]   ; Ignoramos el signo '-' para la operación
    sub bl, '0'        ; Convertimos de ASCII a decimal
    neg bl             ; Hacemos que num2 sea negativo
    jmp realizar_suma

num2_positivo:
    sub bl, '0'        ; Convertimos de ASCII a decimal

realizar_suma:
    ; Sumar los números
    add al, bl
    ; Verificar si el resultado es negativo
    js resultado_negativo

resultado_positivo:
    ; Convertir el resultado a ASCII (cuando el resultado es positivo)
    mov ah, 0
    mov bx, 10         ; Dividir por 10 para manejar múltiples dígitos
    div bl             ; AX / BX -> AL = cociente, AH = resto
    add al, '0'        ; Convertimos el cociente a ASCII
    mov [resultado], al

    ; Almacenar el resto (si existe, cuando es mayor a 9)
    add ah, '0'
    mov [resultado + 1], ah
    mov byte [resultado + 2], 0  ; Añadimos un terminador de cadena

    ; Mostrar el resultado
    mov eax, 4
    mov ebx, 1
    mov ecx, msg9
    mov edx, lmsg9
    int 80h

    mov eax, 4
    mov ebx, 1
    mov ecx, resultado
    mov edx, 3    ; Mostrar 2 caracteres
    int 80h

    jmp main_loop

resultado_negativo:
    ; Si el resultado es negativo, invertimos el valor y agregamos el signo '-'
    neg al
    mov ah, 0
    mov bx, 10
    div bl
    add al, '0'
    mov [resultado+1], al       ; Almacena la parte decimal en la segunda posición

    add ah, '0'
    mov [resultado+2], ah       ; Almacena el segundo dígito
    mov byte [resultado], '-'   ; Almacena el signo negativo
    mov byte [resultado+3], 0   ; Terminador de cadena

    ; Mostrar el resultado
    mov eax, 4
    mov ebx, 1
    mov ecx, msg9
    mov edx, lmsg9
    int 80h

    mov eax, 4
    mov ebx, 1
    mov ecx, resultado
    mov edx, 4    ; Mostrar 3 caracteres
    int 80h

    jmp main_loop

restar:
    ; Lógica de resta
    mov al, [num1]
    mov bl, [num2]
    sub al, '0'     ; Convertir de ASCII a decimal
    sub bl, '0'     ; Convertir de ASCII a decimal
    sub al, bl

    ; Verificamos si el resultado es negativo
    js negativo     ; Si el resultado es negativo, saltamos a la etiqueta "negativo"

    ; Si no es negativo, convertimos el resultado a ASCII
    add al, '0'
    mov [resultado], al
    mov byte [resultado+1], 0  ; Añadimos un terminador de cadena

    ; Mostramos el resultado
    mov eax, 4
    mov ebx, 1
    mov ecx, msg9
    mov edx, lmsg9
    int 80h

    mov eax, 4
    mov ebx, 1
    mov ecx, resultado
    mov edx, 2    ; Mostrar 1 carácter
    int 80h

    jmp main_loop

negativo:
    ; Si el resultado es negativo, invertimos el valor
    neg al
    add al, '0'
    ; Almacenamos el signo menos '-' en la primera posición de resultado
    mov byte [resultado], '-'
    mov byte [resultado+1], al
    mov byte [resultado+2], 0  ; Añadimos un terminador de cadena

    ; Mostramos el resultado
    mov eax, 4
    mov ebx, 1
    mov ecx, msg9
    mov edx, lmsg9
    int 80h

    mov eax, 4
    mov ebx, 1
    mov ecx, resultado
    mov edx, 3  ; Mostrar signo y número
    int 80h

    jmp main_loop

multiplicar:
    ; Lógica de multiplicación
    mov al, [num1]
    mov bl, [num2]
    sub al, '0'      ; Convertir de ASCII a decimal
    sub bl, '0'      ; Convertir de ASCII a decimal
    mul bl           ; AL * BL -> Resultado en AX (16 bits)

    ; Convertir el resultado a ASCII
    ; Si el resultado es mayor a 9, mostramos ambos dígitos
    mov bx, 10       ; Dividir por 10
    xor dx, dx       ; Limpiamos DX para la división

    div bl           ; AX / BX -> AL = cociente, AH = resto
    add al, '0'      ; Convertimos el cociente a ASCII
    mov [resultado], al

    ; Guardamos el resto (uno de los dígitos)
    add ah, '0'      ; Convertimos el resto a ASCII
    mov [resultado + 1], ah
    mov byte [resultado + 2], 0  ; Añadimos un terminador de cadena

    ; Mostramos el resultado
    mov eax, 4
    mov ebx, 1
    mov ecx, msg9
    mov edx, lmsg9
    int 80h

    mov eax, 4
    mov ebx, 1
    mov ecx, resultado
    mov edx, 3  ; Mostrar 2 caracteres
    int 80h

    jmp main_loop

dividir:
    ; Lógica de división
    mov al, [num1]
    mov bl, [num2]
    sub al, '0'      ; Convertir de ASCII a decimal
    sub bl, '0'      ; Convertir de ASCII a decimal

    cmp bl, 0        ; Verificamos si se intenta dividir entre 0
    je dividir_por_cero

    xor dx, dx       ; Limpiamos DX para la división
    div bl           ; AL / BL -> AL = cociente, AH = resto

    ; Convertimos el cociente a ASCII
    add al, '0'      ; Convertimos el cociente a ASCII
    mov [resultado], al
    mov byte [resultado + 1], 0  ; Añadimos un terminador de cadena

    ; Mostramos el resultado
    mov eax, 4
    mov ebx, 1
    mov ecx, msg9
    mov edx, lmsg9
    int 80h

    mov eax, 4
    mov ebx, 1
    mov ecx, resultado
    mov edx, 2  ; Mostrar 1 carácter
    int 80h

    jmp main_loop

dividir_por_cero:
    ; Mensaje de error
    mov eax, 4
    mov ebx, 1
    mov ecx, msg10
    mov edx, lmsg10
    int 80h
    jmp main_loop

salir:
    ; Mostrar mensaje de salida y finalizar el programa
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_prompt_exit
    mov edx, lmsg_prompt_exit
    int 80h

    mov eax, 1
    xor ebx, ebx
    int 80h