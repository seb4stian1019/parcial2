section .data
    prompt_num1 db "Ingrese el primer numero:  ", 0
    prompt_num2 db "Ingrese el segundo numero:  ", 0
    prompt_op   db "Ingrese la operacion (+, -, *, /):   ", 0
    result_msg db "El resultado es:   ", 0
    newline    db 10, 0
    div_error  db "Error: Division por cero!", 0

section .bss
    num1 resb 10
    num2 resb 10
    op resb 1
    result resb 10

section .text
    global _start

_start:
    ; Solicitar primer número
    mov eax, 4            ; sys_write
    mov ebx, 1            ; stdout
    mov ecx, prompt_num1  ; mensaje
    mov edx, 23           ; longitud
    int 0x80              ; llamada al sistema

    ; Leer primer número
    mov eax, 3            ; sys_read
    mov ebx, 0            ; stdin
    mov ecx, num1         ; buffer para almacenar
    mov edx, 10           ; longitud máxima de entrada
    int 0x80              ; llamada al sistema

    ; Convertir el primer número a entero
    call str_to_int
    mov ebx, eax          ; almacenar num1 en ebx

    ; Solicitar segundo número
    mov eax, 4            ; sys_write
    mov ebx, 1            ; stdout
    mov ecx, prompt_num2  ; mensaje
    mov edx, 23           ; longitud
    int 0x80              ; llamada al sistema

    ; Leer segundo número
    mov eax, 3            ; sys_read
    mov ebx, 0            ; stdin
    mov ecx, num2         ; buffer para almacenar
    mov edx, 10           ; longitud máxima de entrada
    int 0x80              ; llamada al sistema

    ; Convertir el segundo número a entero
    call str_to_int
    mov ecx, eax          ; almacenar num2 en ecx

    ; Solicitar operación
    mov eax, 4            ; sys_write
    mov ebx, 1            ; stdout
    mov ecx, prompt_op    ; mensaje
    mov edx, 31           ; longitud
    int 0x80              ; llamada al sistema

    ; Leer operación
    mov eax, 3            ; sys_read
    mov ebx, 0            ; stdin
    mov ecx, op           ; buffer para operación
    mov edx, 1            ; longitud máxima de entrada
    int 0x80              ; llamada al sistema

    ; Realizar la operación
    mov al, [op]          ; obtener la operación
    cmp al, '+'           ; si es suma
    je suma
    cmp al, '-'           ; si es resta
    je resta
    cmp al, '*'           ; si es multiplicación
    je multiplicacion
    cmp al, '/'           ; si es división
    je division

    ; Fin del programa
    jmp _exit

suma:
    add ebx, ecx          ; suma num1 + num2
    jmp mostrar_resultado

resta:
    sub ebx, ecx          ; resta num1 - num2
    jmp mostrar_resultado

multiplicacion:
    imul ebx, ecx         ; multiplicación num1 * num2
    jmp mostrar_resultado

division:
    cmp ecx, 0            ; verificar si num2 es 0
    je division_error
    idiv ecx              ; división num1 / num2
    jmp mostrar_resultado

division_error:
    mov eax, 4            ; sys_write
    mov ebx, 1            ; stdout
    mov ecx, div_error    ; mensaje de error
    mov edx, 24           ; longitud del mensaje
    int 0x80              ; llamada al sistema
    jmp _exit

mostrar_resultado:
    ; Mostrar mensaje de resultado
    mov eax, 4            ; sys_write
    mov ebx, 1            ; stdout
    mov ecx, result_msg   ; mensaje
    mov edx, 16           ; longitud
    int 0x80              ; llamada al sistema

    ; Convertir el resultado en cadena de caracteres
    mov eax, ebx          ; resultado
    call int_to_str

    ; Imprimir el resultado
    mov eax, 4            ; sys_write
    mov ebx, 1            ; stdout
    mov ecx, result       ; resultado como string
    mov edx, 10           ; longitud
    int 0x80              ; llamada al sistema
    jmp _exit

_exit:
    ; Salir del programa
    mov eax, 1            ; sys_exit
    xor ebx, ebx          ; código de salida
    int 0x80              ; llamada al sistema

str_to_int:
    ; Convierte el valor en el buffer num a entero (guardado en eax)
    mov eax, 0            ; inicializar eax (acumulador)
    mov esi, num1         ; apuntar a la cadena
conv_loop:
    movzx ebx, byte [esi]  ; cargar byte de cadena
    cmp bl, 10            ; verificar si es fin de línea
    je done_conv
    sub bl, '0'           ; convertir carácter ASCII a número
    imul eax, eax, 10     ; multiplicar el acumulador por 10
    add eax, ebx          ; sumar el dígito
    inc esi               ; siguiente carácter
    jmp conv_loop
done_conv:
    ret

int_to_str:
    ; Convierte el valor en eax a una cadena (guardada en result)
    mov esi, result       ; apuntar a la cadena
    mov ebx, 10           ; divisor para obtener los dígitos
    add esi, 9            ; empezar desde el final del buffer
    mov byte [esi], 0     ; terminar la cadena con NULL

convert_loop:
    xor edx, edx          ; limpiar edx
    div ebx               ; dividir eax entre 10, cociente en eax, resto en edx
    add dl, '0'           ; convertir dígito a ASCII
    dec esi               ; retroceder un espacio en la cadena
    mov [esi], dl         ; almacenar el carácter
    test eax, eax         ; verificar si queda algo
    jnz convert_loop      ; si es distinto de cero, seguir
    ret
    hbcdcj