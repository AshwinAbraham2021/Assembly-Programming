# Assembly Language

This repository consists of assembly language files written by me while I was learning the language as part of the [Year of Security](https://github.com/CSecIITB/module-1-c-and-asm) Programme conducted by the [Cybersecurity Club](https://github.com/CSecIITB) at IIT Bombay.

Some resources I found useful while learning Assembly Programming were:
- [The CS 216 Webpage from the University of Virginia](https://www.cs.virginia.edu/~evans/cs216/guides/x86.html)
- [The Wikibook on x86 assembly](https://en.wikibooks.org/wiki/X86_Assembly/Print_Version)
- [Some resources from the CS 301 course taught by Dr Lawlor from the University of Alaska](https://docs.google.com/document/d/1J1ZD4JbgTFrfdv_vsJBe96NcNoEwsm7LTQasWZcnMN8/edit)

# Usage Instructions
All the assembly code here was written for x86 64 bit systems running Linux.
The assembly code has been written in the Intel Syntax and is to be assembled with the [Netwide Assembler](https://www.nasm.us/) (NASM).

To get NASM in Linux, just enter:

    sudo apt install nasm
in the terminal

To assemble an x86 assembly file (named ```file.asm```, for example) in 64 bit mode, execute:

    nasm -f elf64 file.asm,

This will output an object file called ```file.o``` by default.

If ```file.asm``` called C library functions (such as ```main```, ```printf```, ```scanf```, etc), to create the executable we must compile and link 
the object file using a C compiler such as GCC.

    gcc file.o

Some errors may be rectified by using the ```-no-pie``` option

    gcc -no-pie file.o

```Tib.asm``` and ```clib.asm``` are to be compiled this way.


If the function instead relies solely on standard CPU instructions and System Calls, such as the ```read``` and ```write``` syscalls, then we can use the linker directly instead of GCC.

    ld file.o

```standalone.asm``` is to be compiled this way.

If ```file.asm``` just defines functions to be linked in a C/C++ file, we can use GCC again

    gcc file.o other_file.c

```func.asm``` is to be linked with ```linkasm.c``` in this way

In all of these examples, unless otherwise specidied ```a.out``` is the standard executable file and ```file.o``` is the object module formed after compilation/assembly.

# CPU Emulator

YoS 9.11 is a 8-bit computer with 256 bytes of addressable "memory" (RAM). 
On booting up, the processor sets the "instruction pointer" to the first byte of memory (address = 0x00) and 
starts decoding and executing "instructions". All instructions are 3 bytes long and are described in detail below.
There are 8 "registers" : r0, r1, ... r7 which temporarily hold data while the processor works. 
Each register is 8 bits wide, meaning it can store values in the range [0, 255].
<details>
<summary></summary>
https://i.postimg.cc/LXXJv2gd/t.jpg
</details>

### Instructions

Example : (note that all values we use from now on are in hexadecimal)
```                                 
          _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
	 |       |       |       |       |
	 |  08   |  03   |  00   |  . .  | . . . . 
         |_ _ _ _|_ _ _ _|_ _ _ _|_ _ _ _|_ _ _ _
             |      |         |       `----------- The next instruction to be run starts here (in most cases)
	     |      |         | 
	     |      `---------|--------- The second and third byte generally denote numerical constants 
             |                `--------- or the register(s) to use in executing an instrution
	     |
	     `----------- The first byte specifies what operation the processor / CPU
	                  has to perform. It identifies the type of the instruction.
			  All the instruction types (based on the first byte of the 
			  instruction) used by the YoS processor are specified below.
```

1. **LOAD_CONST**<br>
Value in the first byte of instruction = opcode = 0x00
<br>This instruction loads the constant in the third byte of the 
     instruction to the register referenced by the second byte.
<br>*Eg.* 00 00 80 => loads the constant 0x80 (= 128) to r0

2. **ADD_CONST**
<br>opcode = 0x01
<br>This instruction adds the constant in the third byte of the 
     instruction to the register referenced by the second byte.
<br>*Eg.* 01 00 80 => adds the constant 0x80 (= 128) to r0 (If the
       value of the register was 0x01, the new value would be 0x81)

3. **SUB_CONST**
<br>opcode = 0x02
<br>This instruction subtracts the constant in the third byte of the 
     instruction to the register referenced by the second byte.
<br>*Eg.* 02 00 80 => subtracts the constant 0x80 (= 128) from r0

4. **ADD**
<br> opcode = 0x03
<br> This instruction adds the values stored in the registers 
     referenced by the second and third byte of the instruction and 
     stores it back in the register referenced by the second byte.
<br>*Eg.* 03 07 01 => stores value of r7+r1 into r1

5. **SUB**
<br>opcode = 0x04
<br>This instruction subtracts the values stored in the register
     referenced by the second byte from the register referenced by 
     the third byte of the instruction and stores it back in the
     register referenced by the second byte.
<br>*Eg.* 04 02 03 => stores value of r2-r3 into r2

6. **PRINT**
<br>opcode = 0x05
<br>This instruction prints the ASCII character corresponding to the 
     value stored in the register referenced by the second byte. 
     The third byte's value has no significance to the instruction.
<br>*Eg.* 05 06 00 => if r6 stores 0x41 (= 65), 'A' is printed on the
       screen.

7. **JUMP_IF_NOT_ZERO** (JNZ)
<br>opcode = 0x06
<br>Usually, after the execution of an instruction, the processor 
     moves on to execute the instuction stored next (adjacent) in memory. 
     The JNZ instruction modifies the control flow of the program based on 
     the value of the register referenced by the second byte. If the
     value is not zero, the processor jumps to the byte referenced by
     the third byte of the instruction and starts reading and executing
     instructions from there. If the value if zero, no jump occurs and
     the processor executes the instructions stored next in memory.
<br>*Eg.* 06 02 09 => If the value in r2 is non-zero, processor sets the 
       instruction pointer to 10th byte in memory (address 0x00 
       corresponds to the first byte of memory)

8. **JUMP_IF_ZERO** (JZ)
<br>opcode = 0x07
<br>Same, as JUMP_IF_NOT_ZERO but the jump instead happens when the value 
     stored in the register referred by the second byte is zero.
     
9. **LOAD**
<br>opcode = 0x08
<br>This instruction loads the byte stored at the address specified by
     the value in register referred by the third byte of the instruction
     to the register referred by the second byte.
<br>*Eg.* 08 03 00 => If the value in r0 is 7, this instruction stores the
   value at address 7 in memory into r3 i.e. r3 = memory[7]

10. **STORE**
<br>opcode = 0x09
<br>This instruction stores the value in the register referred by the 
     third byte of the instruction to the memory location whose address 
     is given by the value of the register reffered by the second byte.
<br>*Eg.* 09 03 00 => If the value in r3 is 4 and r0 is 7, this instruction
   stores 7 into address 4 of memory i.e. memory[4] = 7

11. **HALT**
<br>opcode = 0xff
<br>This instruction halts the processor. The processor is done for the day at this point.<br>
