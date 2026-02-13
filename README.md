# AI-Native OS (Early Development)

**x86 Assembly, NASM, QEMU**

## Overview

I-Native OS is a low-level systems programming project focused on x86 assembly development and bootloader design. The project explores fundamental bare-metal concepts through hands-on implementation in a virtualized environment.

## Current Implementation

### Bootloader Development
- **16-bit Real Mode Bootloader**: Basic bootloader capable of text output to screen via BIOS interrupt (`INT 0x10`)
- **Disk I/O Operations**: Sector reading from disk via BIOS interrupt (`INT 0x13`) with basic error handling
- **Protected Mode Transition**: Global Descriptor Table (GDT) configuration and transition logic from 16-bit real mode to 32-bit protected mode via long jumps

### Assembly Programming Fundamentals
- **Control Flow**: Conditional branching (`JMP`, conditional jumps) and loop constructs
- **Memory Operations**: Basic register operations, memory addressing, and stack operations
- **Arithmetic Operations**: Simple computational routines (addition, subtraction)
- **String Processing**: Character and string manipulation using BIOS interrupts

### Development Environment
- **Assembler**: NASM (Netwide Assembler)
- **Emulator**: QEMU for x86 system emulation
- **Build Tools**: Shell scripts for automated compilation and execution

## Project Structure

- `src/`: Assembly source files (.asm)
  - `hello.asm`: Basic bootloader with screen output
  - `protected_mode.asm`: GDT setup and mode transition example
  - `asm_disk_read.asm`: Disk sector reading implementation
  - `calculator_assembly.asm`: Basic arithmetic operations
  - Additional module and exercise files
- `run_assembly.sh`: Build and execution script
- `img/`: Output directory for compiled binaries

## Long-Term Goal

Architecting a system where an AI model functions as a core primitive to enable prompt-based kernel-level reconfigurations.
