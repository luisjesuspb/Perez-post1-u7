; post1b.asm - INT 10h: control de cursor y atributos de color
; Compilar: nasm -f bin post1b.asm -o post1b.com

ORG 100h

BIOS_SCROLL_UP  equ 06h
BIOS_SET_CURSOR equ 02h
BIOS_WRITE_ATTR equ 09h
DOS_WAIT_KEY    equ 07h
DOS_EXIT        equ 4Ch

ATTR_NORMAL     equ 07h     ; Blanco gris sobre negro
ATTR_AMAR_AZUL  equ 1Eh     ; Amarillo (Eh) sobre fondo azul (1h)
ATTR_ROJO_NEGRO equ 0Ch     ; Rojo claro (Ch) sobre fondo negro (0h)

section .text
start:
    ; Limpiar pantalla completa mediante scroll hacia arriba
    mov ah, BIOS_SCROLL_UP
    xor al, al
    xor cx, cx              ; Fila 0, columna 0
    mov dx, 184Fh           ; Fila 24, columna 79
    mov bh, ATTR_NORMAL
    int 10h

    ; Posicionar cursor en fila 2, columna 10
    mov ah, BIOS_SET_CURSOR
    xor bh, bh
    mov dh, 02h
    mov dl, 0Ah
    int 10h

    ; Escribir 'A' con fondo azul y texto amarillo
    mov ah, BIOS_WRITE_ATTR
    mov al, "A"
    xor bh, bh
    mov bl, ATTR_AMAR_AZUL
    mov cx, 1
    int 10h

    ; Posicionar cursor en fila 3, columna 10
    mov ah, BIOS_SET_CURSOR
    xor bh, bh
    mov dh, 03h
    mov dl, 0Ah
    int 10h

    ; Escribir 'U' en rojo claro sobre negro
    mov ah, BIOS_WRITE_ATTR
    mov al, "U"
    xor bh, bh
    mov bl, ATTR_ROJO_NEGRO
    mov cx, 1
    int 10h

    ; Avanzar cursor manualmente a fila 3, columna 11
    mov ah, BIOS_SET_CURSOR
    xor bh, bh
    mov dh, 03h
    mov dl, 0Bh
    int 10h

    ; Escribir '7' en rojo claro sobre negro
    mov ah, BIOS_WRITE_ATTR
    mov al, "7"
    xor bh, bh
    mov bl, ATTR_ROJO_NEGRO
    mov cx, 1
    int 10h

    ; Esperar tecla y salir
    mov ah, DOS_WAIT_KEY
    int 21h
    mov ah, DOS_EXIT
    xor al, al
    int 21h