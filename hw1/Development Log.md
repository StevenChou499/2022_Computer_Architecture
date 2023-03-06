# Development Log

## RV32I Simulator
contributed by < [`StevenChou499`](https://github.com/StevenChou499) >

## Binary Search
* Problem description : 
> Given an array of integers `nums` which is sorted in ascending order, and an integer `target`, write a function to search `target` in `nums`. If `target` exists, then return its index. Otherwise, return `-1`.
> 
> You must write an algorithm with `O(log n)` runtime complexity.

## Implementation
Before implementing in assembly code, it is better to first implement the solution in C programming language for better understanding and easier conversion from C to assembly.

### C programming language
The following is my full C code: 
```c
#include <stdio.h>

int array[6] = {-1, 0, 3, 5, 9, 12};
int length = 6;

int search(int* nums, int numsSize, int target)
{
    int left = 0, right = numsSize - 1;
    while (left <= right)
    {
        int middle = left + (right - left) / 2;
        
        if (nums[middle] == target)
            return middle;
        
        else if (nums[middle] < target)
            left = middle + 1;
        
        else
            right = middle - 1;
    }
    return -1;
}

int main(void)
{
    int index = search(array, length, 9);
    printf("%d", index);
    return 0;
}
```

### Assembly code
```asm
.data
array: .word -1, 0, 3, 5, 9, 12
length: .word 6

.text
main:
    # calling convention
    # int search(int* nums, int numsSize, int target)
    la     a0, array                # store array address in a0 (first argument)
    la     a1, length
    lw     a1, 0(a1)                # store array length in a1 (second argument)
    addi   a2, x0, 9                # store target element in a2 (third argument)
    
    # call search function
    jal    ra, search
    
    # return from function call, return value is at a0 register
    li     a7, 1
    ecall
    li     a7, 10
    ecall
    
search:
    # for arguments, a0: array address, a1: array length, a2: target
    # for temp, t0: left, t1: right, t2: mid
    add    t0, x0, x0               # left = 0
    addi   t1, a1, -1               # right = numsSize - 1

while_loop:
    bge    t1, t0, get_mid
    li     a0, -1                   # ready to return -1
    ret                             # return to main function
    
get_mid:
    sub    t2, t1, t0               # t2 = right - left
    srai   t2, t2, 1                # t2 = (right - left) / 2
    add    t2, t0, t2               # mid = t2 = left + (right - left) / 2
    # t3: temp for comparison, t4: nums[mid], t5: temp address of array
    add    t3, x0, x0               # t3 = 0
    add    t5, a0, x0
    
cmpindex:
    blt    t3, t2, getaddr
    lw     t4, 0(t5)                # t4 = nums[mid]
    blt    a2, t4, change_right     # if nums[mid] > target , right = middle - 1
    blt    t4, a2, change_left      # if nums[mid] < target , left = middle + 1
    
    # else return middle
    add    a0, t2, x0               # a0 = t2 (return middle)
    ret

change_right:
    addi   t1, t2, -1               # right = mid - 1
    j      while_loop               # back to while loop
    
change_left:
    addi   t0, t2, 1                # left = mid + 1
    j      while_loop               # back to while loop

getaddr:
    addi   t5, t5, 4                # t5 = t5 + 4
    addi   t3, t3, 1                # t3 = t3 + 1
    j      cmpindex
```

## Five Stage of Processor Pipelining
With respect to single cycle processor, pipelining is a really great way to reduce critical path and increase clock rate and throughput. In our RISC-V processor simulator [Ripes](https://github.com/mortbopet/Ripes), there are mainly five pipelining stages, include IF (instruction fetch), ID (instruction decode), EX (execute), MEM (memory) and WB (writeback).

### IF (Instruction Fetch)
In the first stage of CPU pipelining, the CPU fetchs the instruction from memory (cache) by utilizing the program counter register, which is a register storing the address of the instruction which CPU is going to execute.

 * below is the Instruction Fetch diagram : 

![](https://i.imgur.com/M1T5FwY.png)

First the MUX will decide which will be our next PC value. In normal senario, PC will just add 4, which is simply the next instruction address. But in some cases, such as branching or unconditional jumps, PC will change to a total different value. Below is the jumping example, when the jumping instruction is being executed, we can see that the MUX chooses the output of the ALU as the next instruction address (`0x00000054`) instead of the current instruction address plus 4 (`0x00000090`)

![](https://i.imgur.com/GyiZMLB.png)

After we get our PC value, we can now go get the instruction at the right address, which is in the instruction memory (cache).

Also, we need to increment the PC by 4 in order for the next instruction to get fetched.

### ID (Instruction Decode)
The next stage is the instruction decode stage. 
 * below is the instruction decode diagram : 
![](https://i.imgur.com/civV2mv.png)

Now we get our instruction via the program counter, the instruction is sent into the decoder. The decoder will figure out the below problems : 
1. Which kind of instruction it is (R-type? I-type? etc.)
2. Whether we will need registers for the execution and which register will we need
3. Whether we need the immediate generator (via opcode)

After figuring out all the above problems, we can now send the correct output to the register files and the immediate generators. The register files receive the registers id (R1 idx and R2 idx), output the value of the registers in Reg1 and Reg2 ports. Also in some writeback stages, sometime we will need to write back a new value to a specific register (such as register manipulation), sometimes we don't (such as branching or nop), so we will need two more ports (Wr data and Wr idx) for data and register id and a write enable for preventing unwanted change to the registers.

The immediate generator receives the opcode and the instruction, if we will need a immediate, the generator extract the immediate part of the instruction and sign-extend it, output the value to the execution stage.

 * below is the example : 

For `add x10 x7 x0` instruction, we will need two register  `x7` and  `x0` for input, the register files receives two ids, and output both the values (which is `0x00000000` for `x0` and `0x00000002` for `x7` ).

![](https://i.imgur.com/Ei4P5Z8.png)

For `addi x30 x30 4` instruction, we only need one register for input, and a immediate for another input, the register files receives one id (we don't care the other one) and output the value (Reg1) which is `0x10000004`. Also the immediate generator receives the instruction and output the 32-bit immediate.

![](https://i.imgur.com/577QyS2.png)

In writeback stage of instruction `sub x7 x6 x5` , we need to write back the new value of the destination register (which is register `x7` with a new value of `2` ), so we need to enable write for the register files.

![](https://i.imgur.com/6lCMv9N.png)

### EX (Execution)
The third stage is the execution stage.

![](https://i.imgur.com/0GHiD8I.png)

We can see there are for MUXes for selecting the correct inputs for the ALU, which is a place for performing real caculations.

For instruction `add x7 x5 x7` , we will use two register for the input of the ALU and perform the addition (3 + 1 = 4).

![](https://i.imgur.com/t4zW12C.png)

For instruction `srai x7 x7 1` , we need register 1 (`x7` ) and an immediate ( `1` ) for the ALU input and output the value (2 >> 1 = 1).

![](https://i.imgur.com/wbdO55R.png)

For instruction `auipc x11 0x10000` , we need PC and an immediate for the ALU input and output the sum (0x00000008 + 0x10000000 = 0x10000008).

![](https://i.imgur.com/Uem96t7.png)

In the branching instructions, we will need a branch comparator to decide whether we have to take the branch or don't. For example, in instruction `blt x28 x7 40` , the value of register `x28` is `0x00000000` and the value of register `x7` is `0x00000002` , so we will branch (PC value changed to `0x0000007c` ).

![](https://i.imgur.com/IGitO9a.png)

After a few instructions, we met the same instruction `blt x28 x7 40` again. Now the value of register `x28` is `0x00000002` and the value of register `x28` is `0x00000002` , so we won't branch (PC value doesn't change to `0x0000007c` ).

![](https://i.imgur.com/WmYuPpk.png)

### MEM (Memory Access)

Now we are at the fourth stage of pipelining, which is the memory access stage.

![](https://i.imgur.com/oQRDJsW.png)

There are two main memory accesses, read in or write out.

For reading in, the data memory get the address from the ALU output and output the correct value to the output port.

![](https://i.imgur.com/V16KPHY.png)

For writing out, the data memory also gets the address from the ALU output, but right now we have to write a specific value to the desire address, so we also need a Data in and a write enable to prevent writing unexpected value to the data memory.

![](https://i.imgur.com/eFhZXHh.png)

### WB (Writeback)

We are now in the final stage, which is the write back stage.

![](https://i.imgur.com/8MjiuHr.png)

The write back stage gets the value from either data memory, pc or the ALU output, by utilizing the MUX we can choose which value we want to use.

For example, in instruction `jal x1 20` , the MUX chooses the value of PC + 4 and store back to register `ra` (ABI of `x1` ).

![](https://i.imgur.com/0TweJeC.png)

In instruction `add x5 x0 x0` , which is a normal addition instruction, the MUX chooses the ALU output to write back to the register files.

![](https://i.imgur.com/3FP0fVW.png)

In instruction `lw x29 9 x40` , which is a load word instruction, we need to load a word from the data memory to the register files, so the MUX chooses the data memory output and write back to the register files.

![](https://i.imgur.com/CNlbiV2.png)

## Pipeline Hazards
Although pipelining increases the CPU throughput, there are new problems encountered after we implement pipelining in our CPU. These problems are called **"Hazards"**, there are three main hazards in pipelining, which is structural hazards, data hazards and control hazards.

:::info
Hazards only happened in pipelining. Single cycle CPU won't encounter hazards.
:::

### Structural Hazards
Structural hazard occurs when more than one pipeline stages want to use the same hardware resources. For example, the register file will be read in the decoding stage and be written in the writeback stage. This will lead to a problem that whether which stage can use the resource or even take first.

![](https://i.imgur.com/oRsrKLA.png)

Possible solutions : 
 * Solution 1 : Stall
     * Instructions need to take turns to use the resource, the waiting instruction has to stall (not used).
 * Solution 2 : Adding more hardware to support more stages.
     * For example, register file can add more ports to support both reading and writing at the same time.
 * Solution 3 : Double Pumping
     * Double Pumping utilized both of the rising edge and the falling edge of the same clock cycle. For example, because accessing the register file is really fast, we can writing in the register file on the rising edge of the clock, and reading out the register file on the falling edge of the clock (very common in modern day processors).

We will also face structural hazard in instruction fetch stage and memory access stage, because both of the stages are trying to access the memory.

![](https://i.imgur.com/05aSqRH.png)

We can use different and seperate cache (small and fast pieces of memory) to prevent from accessing the same hardware.
:::info
When facing structural hazards, we can always solve the problem by adding more hardware resources.
:::

There are no Structural Hazards in the Ripes simulator.

### Data Hazards
Data hazards will occur when a specific data is not modified in time the future instruction. For example, in the below instructions, register `t0` is still in the memory stage (hasn't write back) after the addition instruction, but right now the subtraction instruction needs the register `t0` to be ready, this lead to a data hazard.

```asm
add t0, t1, t2
sub t4, t0, t3
```

Possible solutions : 
 * Solution 1 : Stalling
     * Simply just wait for the previous instruction to finish perform writeback stage, and do the rest instruction (reduce performance).
:::info
Stalling simply mean adding `nop` (no operation) between two instructions. A `nop` instruction is actually `add x0 x0 x0` , which does nothing.
:::
 * Solution 2 : Data Forwarding
     * By adding more hardware, we can now directly send the output to a specific stage for the next instruction (need more hardware).
     * For example, when facing two consecutive register manipulation with the same register as the source register, we can simply wired the ALU output of the previous instruction to the ALU input of the next instruction.

![](https://i.imgur.com/8QAlnld.png)

#### Forwarding Fail
In most cases, forwarding will solve data hazards. But in some cases, such as the below example, forwarding is not able to solve the problem.
```asm
lw t0, 0(t1)
sub t3, t0, t2           # register t0 just not in time even with forwarding
```

In the above example, the register `t0` is still in the memory stage when the subtraction instruction is in the execution stage, both of the stage runs simultaneously, so the result is simply not ready even with forwarding.

![](https://i.imgur.com/WFzM549.png)

There are also some solutions for it : 
 * Solution 1 : Stall, in hardware it's also called "hardware interlock"
 * Possible solution 2 : We can reposition our loading instruction (calling the instrucion earlier) if possible to avoid using the data immediate after load.

#### Data Hazards in our cases
There are plenty of data hazards in our cases, fortunately we can solve most of the problems by data forwarding.

The bottom picture is a example, the first instruction `auipc` needs register `x10` to be the destination register, but the next instruction `addi x10 x10 0` needs register `x10` to be the source register, which data hazard will occur. In the Ripes simulator, we can see the value of `x10` ( `0x10000000` ) is sent from the memory stage back to the execution stage, also the MUX will choose the register `x10` as the source register, which sucesslly perform data forwarding.

![](https://i.imgur.com/AER9IQU.png)

Another example is occur at the writeback stage and the execution stage. From the bottom picture, instruction `add x5 x5 x0` is at the writeback stage, and the instruction `bge x6 x5 12` is at the execution stage. To prevent data hazard, the value of register `x5` was sent back to execution stage.

![](https://i.imgur.com/Ubmi7BA.png)

Below is the only data hazard which we cannot solve by data forwarding. In the below example, the instruction `lw x29 0 x30` load the value into register `x29` , but at the same time the next instruction `blt x12 x29 16` uses the same register `x29` for branch comparing, so we must stall for a clock cycle in order for the value of register `x29` to be correct.

![](https://i.imgur.com/dLAEBjP.png)

### Control Hazards
Control hazards may occur when we use branching and jumping instructions. When the branch instruction is in the execution stage, the branch result will be caculated, but at the same time there are two instructions already in the instruction fetch and decode stage. So when we decided to take the branch, the two previous instruction will needed to be discard and wait for the correct instruction to fill up the pipeline (which will take two clock cycles).

:::info
Control Hazard always occur in jumping instructions.
:::

 * Solution 1 : Stall
     * When executing the branch instruction, we need to wait for two clock cycle in order to fetch the correct instruction.
 * Solution 2 : Branch Prediction
     * Simply guess (or estimate) whether we will take the branch or not, if we guessed right, then no stalls are needed, but we when we guessed wrong, we also need to stall 2 clock cycles (So the prediction accuracy largly effects the  execution efficiency).

:::info
Because branch prediction effect a large portion of the execution efficiency. Having a great branch predictor is a great way to increase performance.
:::

#### Control Hazards in our cases
There are plenty of control hazards occured in our cases.

For the jumping instruction `jal x1 20` as an example, when the instruction is in the execution stage, there are already two instructions in the fetch and decode stage, so after we perform our jumping, we need to clear the previous two instrucitons in order to execute the correct one.

 * The instructions in the first two stage ( `addi x17 x0 1` and `ecall` ) are going to be filled by `nop` : 

![](https://i.imgur.com/orCYvGG.png)

 * Fill in the correct instruction `add x5 x0 x0` : 

![](https://i.imgur.com/joz4Wql.png)

Another example is for branching. 
 * In the execution stage of instruction `blt x28 x7 40` , there is already two instructions in the previous stage : 

![](https://i.imgur.com/naJHK2E.png)

 * But after we get the branch comparator result, we have to take the branch, so we need to discard two previous instructions, replace with `nop` and fill in the correct instrucion : 

![](https://i.imgur.com/9ScQuW9.png)

 * Ultimately when we met the same branch instruction, we will be able to take the branch and reserve the previos instruction to the execution stage : 

![](https://i.imgur.com/te1istR.png)

