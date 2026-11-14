; post1d.asm - Pantalla estructurada con encabezado, cuerpo y pie usando INT 10h
; Compilar: nasm -f bin post1d.asm -o post1d.com

ORG 100h

BIOS_SCROLL_UP  equ 06h
BIOS_SET_CURSOR equ 02h
BIOS_WRITE_ATTR equ 09h
DOS_WAIT_KEY    equ 07h
DOS_EXIT        equ 4Ch

ATTR_NORMAL     equ 07h     ; Gris claro sobre negro
ATTR_HEADER     equ 1Eh     ; Amarillo brillante sobre fondo azul
ATTR_SUBTITULO  equ 0Bh     ; Cian brillante sobre negro
ATTR_PIE        equ 0Ah     ; Verde brillante sobre negro

section .data
    txt_header  db "=== ARQUITECTURA DE COMPUTADORES - UNIDAD 7 ===", "$"
    txt_linea1  db "Estudiante: Luis Jesus Perez", "$"
    txt_linea2  db "Practica: Manejo de Pantalla y Teclado (INT 10h / INT 21h)", "$"
    txt_pie     db "Presione cualquier tecla para finalizar la Parte 1...", "$"

section .text
start:
    ; 1. Limpiar pantalla completa
    mov ah, BIOS_SCROLL_UP
    xor al, al
    xor cx, cx
    mov dx, 184Fh
    mov bh, ATTR_NORMAL
    int 10h

    ; 2. Dibujar encabezado (Fila 3, Columna 16)
    mov si, txt_header
    mov dh, 3
    mov dl, 16
    mov bl, ATTR_HEADER
    call imprimir_cadena_color

    ; 3. Dibujar datos del estudiante (Fila 8, Columna 16)
    mov si, txt_linea1
    mov dh, 8
    mov dl, 16
    mov bl, ATTR_NORMAL
    call imprimir_cadena_color

    ; 4. Dibujar descripcion de la practica (Fila 10, Columna 16)
    mov si, txt_linea2
    mov dh, 10
    mov dl, 16
    mov bl, ATTR_SUBTITULO
    call imprimir_cadena_color

    ; 5. Dibujar mensaje de pie de pantalla (Fila 16, Columna 16)
    mov si, txt_pie
    mov dh, 16
    mov dl, 16
    mov bl, ATTR_PIE
    call imprimir_cadena_color

    ; Esperar tecla y salir a DOS
    mov ah, DOS_WAIT_KEY
    int 21h

    mov ah, DOS_EXIT
    xor al, al
    int 21h

; -------------------------------------------------------------------------
; Subrutina: imprimir_cadena_color
; Entrada: SI = puntero a cadena terminada en '$', DH = fila, DL = columna, BL = atributo
; -------------------------------------------------------------------------
imprimir_cadena_color:
.siguiente:
    mov al, [si]
    cmp al, "$"
    je  .fin

    ; Posicionar cursor
    mov ah, BIOS_SET_CURSOR
    xor bh, bh
    int 10h

    ; Escribir caracter con atributo
    mov ah, BIOS_WRITE_ATTR
    xor bh, bh
    mov cx, 1
    int 10h

    inc si
    inc dl
    jmp .siguiente
.fin:
    ret