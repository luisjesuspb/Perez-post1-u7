; post2b.asm - Control interactivo de cursor y color con teclado (INT 10h + INT 16h)
; Compilar: nasm -f bin post2b.asm -o post2b.com

ORG 100h

BIOS_SCROLL_UP  equ 06h
BIOS_SET_CURSOR equ 02h
BIOS_WRITE_ATTR equ 09h
BIOS_READ_KEY   equ 00h
DOS_EXIT        equ 4Ch

ATTR_NORMAL     equ 07h
ATTR_HEADER     equ 1Fh     ; Blanco brillante sobre azul
SCAN_UP         equ 48h
SCAN_DOWN       equ 50h
SCAN_LEFT       equ 4Bh
SCAN_RIGHT      equ 4Dh
KEY_ESC         equ 1Bh

section .data
    msg_instruc db "Flechas: Mover  |  C: Cambiar color  |  ESC: Salir", "$"
    pos_fila    db 12       ; Fila inicial (centro)
    pos_col     db 40       ; Columna inicial (centro)
    color_act   db 0Ah      ; Verde brillante inicial

section .text
start:
    ; 1. Limpiar pantalla
    mov ah, BIOS_SCROLL_UP
    xor al, al
    xor cx, cx
    mov dx, 184Fh
    mov bh, ATTR_NORMAL
    int 10h

    ; 2. Dibujar barra de instrucciones en fila 0
    mov si, msg_instruc
    mov dh, 0
    mov dl, 14
    mov bl, ATTR_HEADER
    call imprimir_cadena_color

    ; 3. Dibujar el puntero inicial en pantalla
    call dibujar_puntero

bucle_control:
    ; Esperar tecla (AH = Scan Code, AL = ASCII)
    mov ah, BIOS_READ_KEY
    int 16h

    ; Verificar salida con ESC
    cmp al, KEY_ESC
    je  salir_dos

    ; Verificar cambio de color con 'c' o 'C'
    cmp al, 'c'
    je  cambiar_color
    cmp al, 'C'
    je  cambiar_color

    ; Verificar teclas de direccion (Scan Codes)
    cmp ah, SCAN_UP
    je  mover_arriba
    cmp ah, SCAN_DOWN
    je  mover_abajo
    cmp ah, SCAN_LEFT
    je  mover_izquierda
    cmp ah, SCAN_RIGHT
    je  mover_derecha

    jmp bucle_control

mover_arriba:
    cmp byte [pos_fila], 2      ; Limite superior (debajo del titulo)
    jbe bucle_control
    call borrar_puntero
    dec byte [pos_fila]
    call dibujar_puntero
    jmp bucle_control

mover_abajo:
    cmp byte [pos_fila], 23     ; Limite inferior
    jae bucle_control
    call borrar_puntero
    inc byte [pos_fila]
    call dibujar_puntero
    jmp bucle_control

mover_izquierda:
    cmp byte [pos_col], 1       ; Limite izquierdo
    jbe bucle_control
    call borrar_puntero
    dec byte [pos_col]
    call dibujar_puntero
    jmp bucle_control

mover_derecha:
    cmp byte [pos_col], 78      ; Limite derecho
    jae bucle_control
    call borrar_puntero
    inc byte [pos_col]
    call dibujar_puntero
    jmp bucle_control

cambiar_color:
    inc byte [color_act]
    and byte [color_act], 0Fh   ; Mantener colores 01h-0Fh sobre fondo negro
    cmp byte [color_act], 0
    jne .actualizar
    mov byte [color_act], 09h   ; Evitar negro sobre negro
.actualizar:
    call dibujar_puntero
    jmp bucle_control

salir_dos:
    mov ah, DOS_EXIT
    xor al, al
    int 21h

; -------------------------------------------------------------------------
; Subrutinas auxiliares
; -------------------------------------------------------------------------
dibujar_puntero:
    mov ah, BIOS_SET_CURSOR
    xor bh, bh
    mov dh, [pos_fila]
    mov dl, [pos_col]
    int 10h

    mov ah, BIOS_WRITE_ATTR
    mov al, 02h                 ; Caracter carita/simbolo
    xor bh, bh
    mov bl, [color_act]
    mov cx, 1
    int 10h
    ret

borrar_puntero:
    mov ah, BIOS_SET_CURSOR
    xor bh, bh
    mov dh, [pos_fila]
    mov dl, [pos_col]
    int 10h

    mov ah, BIOS_WRITE_ATTR
    mov al, ' '
    xor bh, bh
    mov bl, ATTR_NORMAL
    mov cx, 1
    int 10h
    ret

imprimir_cadena_color:
.siguiente:
    mov al, [si]
    cmp al, "$"
    je  .fin
    mov ah, BIOS_SET_CURSOR
    xor bh, bh
    int 10h
    mov ah, BIOS_WRITE_ATTR
    xor bh, bh
    mov cx, 1
    int 10h
    inc si
    inc dl
    jmp .siguiente
.fin:
    ret