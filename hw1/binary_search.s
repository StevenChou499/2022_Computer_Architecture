.data
array: .word -1, 0, 3, 5, 9, 12
length: .word 6
p_arr: .string "All array elements : "
space: .string " "
forn1: .string "For number "
forn2: .string ", the position is: "
newline: .string "\n"

.text
main:
    # calling convention
    # int search(int* nums, int numsSize, int target)
    la  a0, array                    # store array address in a0 (first argument)
    la  a1, length
    lw  a1, 0(a1)                    # store array length in a1 (second argument)
    addi a2 x0 12                    # store target element in a2 (third argument)
    addi sp sp -12                   # open stack frame for 3 arguments
    sw a0, 8(sp)                     # push array address into stack
    sw a1, 4(sp)                     # push array length into stack
    sw a2, 0(sp)                     # push target into stack
    
    # call search function
    jal ra search
    
    # return from function call, return value is at a0 register
    addi t0 a0 0                     # move return value to t0
    lw a2, 0(sp)                     # pop target from stack
    lw a1, 4(sp)                     # pop array length from stack
    lw a0, 8(sp)                     # pop array address from stack
    addi sp sp 12                    # close stack frame
    la a0 p_arr                      # print "All array elements : "
    li a7 4
    ecall
    
    # print all the elements in p_for
    #jal ra p_for
    
    # print the rest message and exit
    la a0 newline                    # print new line
    li a7 4
    ecall
    la a0 forn1                      # print "For number "
    li a7 4
    ecall
    li a0 12                          # print 9
    li a7 1
    ecall  
    la a0 forn2                      # print ", the position is: "
    li a7 4
    ecall
    addi a0 t0 0                     # print index
    li a7 1
    ecall
    la a0 newline                    # print new line
    li a7 4
    ecall
    li a7 10
    ecall
    
    
search:
    # for arguments, a0: array address, a1: array length, a2: target
    # for temp, t0: left, t1: right, t2: mid
    addi t0 x0 0                     # left = 0
    addi t1 a1 -1                    # right = numsSize - 1

left_right_comp:
    bge t1 t0 whileloop
    li a0 -1                         # ready to return -1
    ret                              # return to main function
    
whileloop:
    sub t3 t1 t0                     # temp = right - left
    srli t3 t3 1                     # temp = temp / 2
    add t3 t3 t0                     # temp = temp + left
    addi t2 t3 0                     # mid = left + (right - left) / 2
    # t4: nums[mid], t5: temp for array address, t6: temp for comparison
    addi t5 a0 0                     # t5 = array address
    addi t6 x0 0                     # t6 = 0
    
cmpindex:
    blt t6 t2 getaddr
    lw t4 0(t5)                      # t4 = nums[mid]
    beq t4 a2 retmid                 # if nums[mid] = target, go to retmid
    blt t4 a2 change_left            # if nums[mid] < target, go to ch_left
    addi t1 t2 -1                    # else, right = mid - 1
    j left_right_comp                # back to while loop

getaddr:
    addi t5 t5 4                     # t5 = t5 + 4
    addi t6 t6 1                     # t6 = t6 + 1
    j cmpindex
    
retmid:
    addi a0 t6 0                     # copy t6 to a0 for return
    ret

change_left:
    addi t0 t2 1                     # left = mid + 1
    j left_right_comp                # back to while loop

p_for:
    li t0 0
    ret