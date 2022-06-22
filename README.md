# MIPS16 Processor VHDL Simulation

Welcome to **MIPS16 Processor VHDL Simulation** project. This project was done to fulfil the requirements of completing ENCS437 - Computer Architecture course.

This repository contains the implementation of a simple **16-bit RISC Processor** based on **MIPS Instructions** which are defined in the [Instruction Set](#instruction-set) section below.

## Instructions Format

For this processor, all instructions are 16-bit, and there are three types of instructions.

### R-Type Instructions Format
| <div style="width: 120px">Opcode (4-bit)</div> | <div style="width: 90px">R<sub>s</sub> (3-bit)</div> | <div style="width: 90px">R<sub>t</sub> (3-bit)</div> | <div style="width: 90px">R<sub>d</sub> (3-bit)</div> | <div style="width: 90px">Fn (3-bit)</div> |
|:----------------------------------------------:|:----------------------------------------------------:|:----------------------------------------------------:|:----------------------------------------------------:|:-----------------------------------------:|
For **R-type** instructions, `Rs` and `Rt` specify the two source registers numbers, and `Rd` specifies the destination register number. The `Fn` (Function) field can specify at most eight functions for a given opcode. Opcode `0` is reserved for **R-type** instructions. It is also possible to reserve more opcodes, if more **R-type** instructions exist.


### I-Type Instructions Format

| <div style="width: 120px">Opcode (4-bit)</div> | <div style="width: 90px">R<sub>s</sub> (3-bit)</div> | <div style="width:90px">R<sub>t</sub> (3-bit)</div> | <div style="width:206px">Immediate (6-bit)</div> |
|:----------------------------------------------:|:----------------------------------------------------:|:---------------------------------------------------:|:------------------------------------------------:|
For **I-type** instructions, `Rs` specifies a source register number, and `Rt` can be a second source or a destination register number. The `Immediate` constant is only 6 bits because of the fixed-size nature of the instruction. The size of the `Immediate` constant is suitable for our uses. The 6-bit `Immediate` constant is signed for all **I-type** instructions.

### J-Type Instructions Format

| <div style="width: 120px">Opcode (4-bit)</div> | <div style="width: 438px">Immediate (12-bit)</div> |
|:----------------------------------------------:|:--------------------------------------------------:|
For **J-type** instructions, a 12-bit `Immediate` constant is used for `JMP` (Jump), `JAL` (Jump and Link), and `LUI` (Load Upper Immediate) instructions, which are defined in the [Instruction Set](#instruction-set).

## Instruction Set
