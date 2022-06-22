# MIPS16 Processor VHDL Simulation

Welcome to **MIPS16 Processor VHDL Simulation** project. This project was done to fulfil the requirements of completing ENCS437 - Computer Architecture course.

This repository contains the implementation of a simple **16-bit RISC Processor** based on **MIPS Instructions** which are defined in the [Instruction Set](#instruction-set) section below.

## Instructions Format

For this processor, all instructions are 16-bit, and there are three types of instructions.

### R-Type Instructions Format
| Opcode (4-bit) | R<sub>s</sub> (3-bit) | R<sub>t</sub> (3-bit) | R<sub>d</sub> (3-bit) | Fn (3-bit) |
|:--------------:|:---------------------:|:---------------------:|:---------------------:|:----------:|

For **R-type** instructions, `Rs` and `Rt` specify the two source registers numbers, and `Rd` specifies the destination register number. The `Fn` (Function) field can specify at most eight functions for a given opcode. Opcode `0` is reserved for **R-type** instructions. It is also possible to reserve more opcodes, if more **R-type** instructions exist.


### I-Type Instructions Format

| Opcode (4-bit) | R<sub>s</sub> (3-bit) | R<sub>t</sub> (3-bit) | Immediate (6-bit) |
|:--------------:|:---------------------:|:---------------------:|:-----------------:|

For **I-type** instructions, `Rs` specifies a source register number, and `Rt` can be a second source or a destination register number. The `Immediate` constant is only 6 bits because of the fixed-size nature of the instruction. The size of the `Immediate` constant is suitable for our uses. The 6-bit `Immediate` constant is signed for all **I-type** instructions.

### J-Type Instructions Format

| Opcode (4-bit) | Immediate (12-bit) |
|:--------------:|:------------------:|

For **J-type** instructions, a 12-bit `Immediate` constant is used for `JMP` (Jump), `JAL` (Jump and Link), and `LUI` (Load Upper Immediate) instructions, which are defined in the [Instruction Set](#instruction-set).

## Instruction Set

### R-Type Instruction Set

| Opcode (4-bit) |  R<sub>s</sub> (3-bit)  |  R<sub>t</sub> (3-bit)  |   R<sub>d</sub> (3-bit)    | Fn (3-bit)  |
|:--------------:|:-----------------------:|:-----------------------:|:--------------------------:|:-----------:|
|   `0 0 0 0`    |     Register 1 (0-7)    |     Register 2 (0-7)    | Destination Register (1-7) | Value (0-7) |

1. **AND** instruction:
    - Operation: `R[Rd] = R[Rs] & R[Rt]`
    - Function number: `Fn = 0 (000)`

2. **ADD** instruction:
    - Operation: `R[Rd] = R[Rs] + R[Rt]`
    - Function number: `Fn = 1 (001)`

3. **ADDU** instruction:
    - Operation: `R[Rd] = Unsigned(R[Rs]) + Unsigned(R[Rt])`
    - Function number: `Fn = 2 (010)`

4. **SUB** instruction:
    - Operation: `R[Rd] = R[Rs] - R[Rt]`
    - Function number: `Fn = 3 (011)`

5. **CAS** instruction:
    - Operation: `R[Rd] = Max(R[Rs], R[Rt])`
    - Function number: `Fn = 4 (100)`

6. **SRAV** instruction:
    - Operation: `R[Rd] = R[Rs] >> R[Rt]`
    - Function number: `Fn = 5 (101)`

### I-Type Instruction Set

| Opcode (4-bit) | R<sub>s</sub> (3-bit) | R<sub>t</sub> (3-bit) | Immediate (6-bit) |
|:--------------:|:---------------------:|:---------------------:|:-----------------:|
|  Value (1-9)   | Register number (0-7) | Register number (0-7) |   Value (0-63)    |

1. **ANDI** instruction:
    - Operation: `R[Rt] = R[Rs] & Immediate`
    - `Opcode = 1 (0001)`

2. **ADDI** instruction:
    - Operation: `R[Rt] = R[Rs] + Immediate`
    - `Opcode = 2 (0010)`

3. **SLTI** instruction:
    - Operation: `R[Rt] = R[Rs] < Immediate`
    - `Opcode = 3 (0011)`

4. **LW** instruction:
    - Operation: `R[Rt] = M[R[Rs] + Immediate]`
    - `Opcode = 4 (0100)`

5. **LLB** instruction:
    - Operation:
    ```
   R[Rt](7:0) = M[R[Rs] + Immediate](7:0)
   R[Rt](15:8) = Sign
   ```
    - `Opcode = 5 (0101)`

6. **SW** instruction:
    - Operation: `M[R[Rs] + Immediate] = R[Rt]`
    - `Opcode = 6 (0110)`

7. **SLB** instruction:
    - Operation:
    ```
   M[R[Rs] + Immediate](7:0) = R[Rt](7:0)
   M[R[Rs] + Immediate](15:8) = Sign
   ```
    - `Opcode = 7 (0111)`

8. **LWS** instruction:
    - Operation: `R[Rd] = M[Rt + (4 * Rs)]`
    - `Opcode = 8 (1000)`

9. **BEQ** instruction:
    - Operation: `Branch to Immediate if (R[Rt] == R[Rs])`
    - `Opcode = 9 (1001)`

10. **BNE** instruction:
    - Operation: `Branch to Immediate if (R[Rt] != R[Rs])`
    - `Opcode = 10 (1010)`

## Register File
The register file contains seven 16-bit registers `R[1]` to `R[7]` with two read ports and one write port. Note that R0 is hardwired to zero.

## Memory
This processor has separate instruction and data memories with 2<sup>16</sup> words each. Each word is 16 bits or 2 bytes.
Instruction Memory is Word Addressable and Data Memory is Byte Addressable.
