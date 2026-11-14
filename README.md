# Perez-post1-u7
# Arquitectura de Computadores - Unidad 7: Pantalla y Teclado (x86 / NASM)

**Estudiante:** Luis Jesús Pérez  
**Repositorio:** `Perez-post1-u7`  
**Entorno:** NASM (Netwide Assembler) + DOSBox 0.74-3  

---

## 1. Descripción General
Práctica de programación en lenguaje ensamblador de 16 bits (`.COM`) orientada al control directo de periféricos de entrada/salida estándar en modo real x86 mediante interrupciones del BIOS (`INT 10h`, `INT 16h`) y servicios del sistema operativo DOS (`INT 21h`).

---

## 2. Estructura del Repositorio

```text
Perez-post1-u7/
├── parte1/
│   ├── post1.asm / post1.com     # Salida básica de texto con INT 21h
│   ├── post1b.asm / post1b.com   # Limpieza de pantalla y posicionamiento de cursor (INT 10h)
│   ├── post1c.asm / post1c.com   # Escritura de cadenas con atributos de color (INT 10h)
│   └── post1d.asm / post1d.com   # Interfaz estructurada con subrutinas de color
├── parte2/
│   ├── post2a.asm / post2a.com   # Lectura de teclado y decodificación ASCII / Scan Code (INT 16h)
│   └── post2b.asm / post2b.com   # Control interactivo de cursor y color por teclado
├── capturas/                     # Evidencias de compilación (NASM) y ejecución (DOSBox)
└── README.md                     # Documentación del proyecto
3. Resumen de Programas e Interrupciones UtilizadasParteArchivoInterrupciones y FuncionesDescripción FuncionalParte 1post1.asmINT 21h (AH=09h, AH=4Ch)Impresión básica de cadena terminada en $ y retorno limpio a DOS.Parte 1post1b.asmINT 10h (AH=06h, AH=02h)Limpieza de ventana de video y posicionamiento exacto del cursor (fila, columna).Parte 1post1c.asmINT 10h (AH=09h)Renderizado carácter a carácter con byte de atributo (color de texto y fondo).Parte 1post1d.asmINT 10h + Subrutina CALL/RETPantalla estructurada con encabezado, cuerpo y pie usando rutinas reutilizables.Parte 2post2a.asmINT 16h (AH=00h)Captura bloqueante de teclado y conversión a hexadecimal de códigos ASCII (AL) y Scan Code (AH).Parte 2post2b.asmINT 10h + INT 16hDesplazamiento en tiempo real mediante teclas direccionales y cambio dinámico de atributos de color.4. Instrucciones de Compilación y EjecuciónCompilación con NASM (Terminal)Bashnasm -f bin parte1/post1d.asm -o parte1/post1d.com
nasm -f bin parte2/post2b.asm -o parte2/post2b.com
Ejecución en DOSBoxDOSmount c C:\Users\ezlayfer\perez-post1-u7
c:
cd \PARTE1
post1d.com

cd \PARTE2
post2b.com
5. Evidencias de EjecuciónLas capturas de compilación y ejecución correspondientes a cada punto de control se encuentran almacenadas en el directorio capturas/.
---

### Subir el `README.md` (junto con `post2b` si aún no lo habías commiteado)

Ejecuta en tu terminal de VS Code (`PS C:\Users\ezlayfer\perez-post1-u7>`):

```powershell
git add README.md
git commit -m "Documentacion: Agregar README completo del laboratorio Unidad 7"
git push
