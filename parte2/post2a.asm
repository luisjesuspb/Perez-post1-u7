; post2a.asm - Lectura de teclado con BIOS INT 16h (ASCII y Scan Code)
; Compilar: nasm -f bin post2a.asm -o post2a.com

ORG 100h

BIOS_SCROLL_UP  equ 06h
BIOS_READ_KEY   equ 00h
DOS_PRINT_STR   equ 09h
DOS_PRINT_CHAR  equ 02h
DOS_EXIT        equ 4Ch

ATTR_NORMAL     equ 07h
KEY_ESC         equ 1Bh

section .data
    msg_titulo  db "=== PARTE 2: LECTURA DE TECLADO (BIOS INT 16h) ===", 0Dh, 0Ah
                db "Presione teclas para ver su caracter y codigo hexadecimal.", 0Dh, 0Ah
                db "Presione ESC para salir.", 0Dh, 0Ah, 0Dh, 0Ah, "$"
    msg_tecla   db "Caracter: [", "$"
    msg_ascii   db "]  |  ASCII: ", "$"
    msg_scan    db "h  |  Scan Code: ", "$"
    msg_fin_ln  db "h", 0Dh, 0Ah, "$"
    msg_esp     db "ESP", "$"

section .text
start:
    ; Limpiar pantalla
    mov ah, BIOS_SCROLL_UP
    xor al, al
    xor cx, cx
    mov dx, 184Fh
    mov bh, ATTR_NORMAL
    int 10h

    ; Mostrar instrucciones
    mov ah, DOS_PRINT_STR
    mov dx, msg_titulo
    int 21h

bucle_teclado:
    ; Esperar tecla con BIOS INT 16h (AH=00h -> AL=ASCII, AH=Scan Code)
    mov ah, BIOS_READ_KEY
    int 16h

    ; Guardar AX (AH=Scan, AL=ASCII) en la pila
    push ax

    ; Imprimir etiqueta "Caracter: ["
    mov ah, DOS_PRINT_STR
    mov dx, msg_tecla
    int 21h

    ; Recuperar tecla en BX para inspeccionarla
    pop bx
    push bx

    ; Verificar si es tecla especial (ASCII == 0) o no imprimible (< 20h)
    cmp bl, 20h
    jb  .no_imprimible

    ; Imprimir caracter imprimible
    mov ah, DOS_PRINT_CHAR
    mov dl, bl
    int 21h
    jmp .mostrar_codigos

.no_imprimible:
    mov ah, DOS_PRINT_STR
    mov dx, msg_esp
    int 21h

.mostrar_codigos:
    ; Imprimir "]  |  ASCII: "
    mov ah, DOS_PRINT_STR
    mov dx, msg_ascii
    int 21h

    ; Imprimir byte ASCII (BL) en hexadecimal
    pop bx
    push bx
    mov al, bl
    call imprimir_hex_byte

    ; Imprimir "h  |  Scan Code: "
    mov ah, DOS_PRINT_STR
    mov dx, msg_scan
    int 21h

    ; Imprimir byte Scan Code (BH) en hexadecimal
    pop bx
    push bx
    mov al, bh
    call imprimir_hex_byte

    ; Salto de linea
    mov ah, DOS_PRINT_STR
    mov dx, msg_fin_ln
    int 21h

    ; Verificar si la tecla fue ESC (1Bh)
    pop bx
    cmp bl, KEY_ESC
    jne bucle_teclado

    ; Salir a DOS
    mov ah, DOS_EXIT
    xor al, al
    int 21h

; -------------------------------------------------------------------------
; Subrutina: imprimir_hex_byte
; Entrada: AL = valor de 8 bits a imprimir en 2 digitos hexadecimales
; -------------------------------------------------------------------------
imprimir_hex_byte:
    push ax
    mov cl, 4
    shr al, cl              ; Nibble alto
    call .imprimir_nibble
    pop ax
    and al, 0Fh             ; Nibble bajo
    call .imprimir_nibble
    ret

.imprimir_nibble:
    cmp al, 9
    jbe .es_digito
    add al, 7               ; Ajuste para A-F
.es_digito:
    add al, '0'
    mov ah, DOS_PRINT_CHAR
    mov dl, al
    int 21h
    ret