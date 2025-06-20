# Laboratorio 02 - Timer0 y Botones en Assembler

## Resumen General
Este proyecto implementa un sistema de control basado en el microcontrolador PIC16F877A que combina:
1. Un **contador automático** que incrementa cada 100ms usando el módulo Timer0
2. Un **contador manual hexadecimal** controlado por botones con visualización en display de 7 segmentos
3. Un **sistema de alarma** que detecta coincidencias entre ambos contadores

El sistema integra hardware (botones, displays y LEDs) con programación en bajo nivel (Assembler), demostrando el manejo de:
- Temporizadores internos
- Circuitos antirebote
- Conversión binario-hexadecimal
- Control preciso de tiempos

## Características Principales

🛠️ Módulos Implementados:
  • Timer0 con preescaler configurable
  • Driver para display 7 segmentos
  • Lógica antirebote para entradas
  • Sistema de comparación de valores

⚙️ Configuración:
  - Oscilador interno 4MHz
  - Prescaler 1:256 para Timer0
  - 2 entradas digitales (botones)
  - 3 salidas (LEDs + display)


