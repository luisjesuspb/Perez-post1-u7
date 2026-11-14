; post1c.asm - Escritura de cadena caracter a caracter con color y posicion exacta
; Compilar: nasm -f bin post1c.asm -o post1c.com

ORG 100h

BIOS_SCROLL_UP  equ 06h
BIOS_SET_CURSOR equ 02h
BIOS_WRITE_ATTR equ 09h
DOS_WAIT_KEY    equ 07h
DOS_EXIT        equ 4Ch

ATTR_NORMAL     equ 07h
ATTR_VERDE_BRIL equ 0Ah     ; Verde brillante sobre fondo negro
FILA_TITULO     equ 5
COL_TITULO      equ 25

section .data
    titulo  db "UNIDAD 7 - PANTALLA Y TECLADO", "$"

section .text
start:
    ; Limpiar pantalla completa
    mov ah, BIOS_SCROLL_UP
    xor al, al
    xor cx, cx
    mov dx, 184Fh
    mov bh, ATTR_NORMAL
    int 10h

    ; Inicializar puntero de cadena y coordenadas de inicio
    mov si, titulo
    mov dl, col_inicio
    mov dh, FILA_TITULO

.bucle_dibujo:
    mov al, [si]            ; Leer caracter actual
    cmp al, "$"             ; Verificar delimitador de fin de cadena
    je  .fin_dibujo

    ; Posicionar cursor en (DH, DL)
    mov ah, BIOS_SET_CURSOR
    xor bh, bh
    int 10h

    ; Escribir caracter actual con atributo verde brillante
    mov ah, BIOS_WRITE_ATTR
    xor bh, bh
    mov bl, ATTR_VERDE_BRIL
    mov cx, 1
    int 10h

    inc si                  ; Siguiente byte de la cadena
    inc dl                  ; Siguiente columna en pantalla
    jmp .bucle_dibujo

.fin_dibujo:
    mov ah, DOS_WAIT_KEY
    int 21h
    mov ah, DOS_EXIT
    xor al, al
    int 21h

col_inicio equ COL_TITULO