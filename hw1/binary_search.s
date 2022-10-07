.data
array: .word -1, 0, 3, 5, 9, 12
length: .word 6

.text
main:
    # calling convention
    # int search(int* nums, int numsSize, int target)
    la  a0, array                    # store array address in a0 (first argument)
    la  a1, length
    lw  a1, 0(a1)                    # store array length in a1 (second argument)
    addi a2 x0 9                     # store target element in a2 (third argument)
    
    # call search function
    jal ra search
    
    # return from function call, return value is at a0 register
    li a7 1
    ecall
    li a7 10
    ecall
    
search:
    # for arguments, a0: array address, a1: array length, a2: target
    # for temp, t0: left, t1: right, t2: mid
    add t0 x0 x0                     # left = 0
    addi t1 a1 -1                    # right = numsSize - 1

while_loop:
    bge t1 t0 get_mid
    li a0 -1                         # ready to return -1
    ret                              # return to main function
    
get_mid:
    sub t2 t1 t0                     # t2 = right - left
    srai t2 t2 1                     # t2 = (right - left) / 2
    add t2 t0 t2                     # mid = t2 = left + (right - left) / 2
    # t3: temp for comparison, t4: nums[mid], t5: temp address of array
    add t3 x0 x0                     # t3 = 0
    add t5 a0 x0
    
cmpindex:
    blt t3 t2 getaddr
    lw t4 0(t5)                      # t4 = nums[mid]
    blt a2 t4 change_right           # if nums[mid] > target , right = middle - 1
    blt t4 a2 change_left            # if nums[mid] < target , left = middle + 1
    
    #else return middle
    add a0 t2 x0                     # a0 = t2 (return middle)
    ret

change_right:
    addi t1 t2 -1                    # right = mid - 1
    j while_loop                     # back to while loop
    
change_left:
    addi t0 t2 1                     # left = mid + 1
    j while_loop                     # back to while loop

getaddr:
    addi t5 t5 4                     # t5 = t5 + 4
    addi t3 t3 1                     # t3 = t3 + 1
    j cmpindex