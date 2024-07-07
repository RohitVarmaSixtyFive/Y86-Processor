# Y-86 Processor Design

## Introduction

The project involves the development of a processor architecture based on the Y86 ISA using Verilog. The project includes both a sequential design and a 5-stage pipelined design. The goal is to create a functional processor that executes all Y86 instructions. The project also includes comprehensive testing to verify the correctness of the designs.

## Design Details

### Sequential Design

The sequential design follows the architecture discussed in Section 4.3 of the textbook. It includes the following components:
- **Fetch Stage**: Fetches instructions from memory.
- **Decode Stage**: Decodes the fetched instructions.
- **Execute Stage**: Executes arithmetic and logical operations.
- **Memory Stage**: Accesses memory for load/store instructions.
- **Write-Back Stage**: Writes results back to the register file.

#### Supported Features
- All Y86 instructions except `call` and `ret`.
- Accurate program counter (PC) management and instruction decoding.
- Correct implementation of arithmetic and logical operations.

#### Challenges
- Ensuring correct instruction sequencing and handling control flow changes.
- Managing data dependencies and avoiding hazards in a sequential setup.

### Pipelined Design

The pipelined design extends the sequential design by incorporating a 5-stage pipeline as described in Sections 4.4 and 4.5 of the textbook. The pipeline stages are:
- **Fetch (IF)**
- **Decode (ID)**
- **Execute (EX)**
- **Memory Access (MEM)**
- **Write-Back (WB)**

#### Supported Features
- All Y86 instructions except `call` and `ret`.
- Hazard detection and resolution mechanisms, including data forwarding and pipeline stalling.
- Pipeline control for managing instruction flow and eliminating structural hazards.

#### Challenges
- Implementing effective hazard detection and resolution strategies.
- Ensuring proper synchronization between pipeline stages to maintain instruction integrity.

### Extended Functionality

Both designs were enhanced to support `call` and `ret` instructions, adding the following features:
- **Call Instruction**: Pushes the return address onto the stack and jumps to the target address.
- **Ret Instruction**: Pops the return address from the stack and jumps back to it.

## Testing and Verification

### Test Cases

We developed 4 test cases covering a range of Y86 instructions to ensure comprehensive testing:
1. **Basic Arithmetic**: Tests add, sub, and logical operations.
2. **Control Flow**: Tests jumps, conditional jumps, and calls.
3. **Memory Operations**: Tests load and store instructions.
4. **Complex Program**: A sorting algorithm implemented in Y86 assembly to test a combination of operations.

### Simulation Snapshots

Simulation snapshots were taken to verify the correct execution of instructions and proper state transitions. These snapshots include:
- Instruction execution at each pipeline stage.
- Register file updates and memory access.
- Correct handling of control flow changes and hazards.

### Verification Strategies

- **Module Testing**: Each module was tested independently with specific test inputs to verify functionality.
- **Automated Testbench**: An automated testbench was developed to verify the processor and memory state after each instruction execution.
- **Assembly Program Testing**: A sorting algorithm written in Y86 assembly was used to test the integrated design, ensuring correct overall functionality.

## Conclusion

This project successfully developed both a sequential and a pipelined processor architecture based on the Y86 ISA using Verilog. The designs were thoroughly tested to meet all specifications, and additional features for handling `call` and `ret` instructions were implemented. The challenges encountered were effectively addressed, resulting in a robust and functional processor design. This project demonstrates the principles of processor design and the application of Verilog in implementing complex digital systems.

---

This report documents the design, implementation, and testing of the processor architecture, highlighting the supported features, challenges encountered, and verification strategies employed to ensure the correctness and functionality of the design.
