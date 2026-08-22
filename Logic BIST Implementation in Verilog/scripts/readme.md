# Logic BIST for ISCAS '85 c432 Interrupt Controller Circuit

## Project Overview
This project implements a Logic Built-In Self-Test (BIST) system for the **c432 interrupt controller circuit**. The design integrates multiple components, including a **Test Pattern Generator (TPG)**, **Phase Shifter*, **Mode Select Circuit**, **Output Respone Analyzer**, **Controller** to facilitate effective testing and fault detection in digital circuits.

## File Structure
The project is divided into modular components, with each module represented as a separate file for clarity and maintainability:

### 1. **tpg_36.v**
- Contains the implementation of the **Type-2 Modular Form LFSR-based Test Pattern Generator (TPG)**.
- Responsible for generating pseudorandom test patterns used to test the Circuit-Under-Test (CUT).

### 2. **phaseshifter.v**
- Implements the **Phase Shifter** to ensure diverse bit sequences are provided to different parts of the CUT.
- Ensures better fault coverage by avoiding repetitive or structurally dependent patterns.

### 3. **mode.v**
- Implements the **Mode Select Circuit**.
- Controls whether the circuit operates in normal mode or test mode based on the BIST input signal.

### 4. **c432.v**
- Contains the implementation of the **c432 interrupt controller circuit** (the CUT).
- This is the circuit being tested using the BIST system.

### 5. **misr_c432.v**
- Implements the **Multiple Input Signature Register (MISR)** -**Output Response Analyzer (ORA)**.
- Collects the output of the CUT and compresses it into a signature for fault detection.

## 6. **bist_controller.v**
- Implements the **BIST Controller**.
- Coordinates the testing process by managing control inputs to the TPG, mode and MISR.

## 7. c432_tb.v
- Wrapper module intergrating all the modules.
- Testbench to simulate the BIST system designed for CUT.

## 8. **phaseshifter.py**
- Python script to find tap points for achieving desired phase shift.
- Used to deseign **phaseshifter.v**.

## 9. **saf.py**
- Python script to inject stuck-at-faults into c432 benchmark circuit.
- Produced a temporary **c432_sa.v** with the faults injected- used for testing the BIST implementation

## Instruction to Run Code
- Run safe.py. Give 0 for fault-free simulation. Give a positive value for fault-injection.
- Run c432_tb.v.

## For running saf.py
1. Run command *python3 saf.py*
2. Enter *n*, number of stuck-at-faults you want to inject.
3. Enter node name and node value (stuck-at-1 or stuck-at-0) of each node.
4. c432 circuit with the faults injected, which is used in the testbench for testing is generated.

## How to Run Verilog Testbench (c432_tb.v)
1. Ensure all files are available in the working directory.
2. Use a Verilog simulator such as **ModelSim** (Preferred).
3. Compile and simulate the **c432_tb.v** file.
4. Check and Verify Output with and without introducing stuck-at-faults.

## For running phaseshifter.py
1. Run command *python3 phaseshifter.py*
2. Enter *n*, the phase shift you want to achieve.
3. Enter the input bit you want to phase shift.
4. The tap points to be XORed to achieve that phase shift is produced as result.


