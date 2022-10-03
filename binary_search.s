.data
array: .word -1, 2, 3, 5, 9, 12
length: .word 6

main:
    # calling convention
    # int search(int* nums, int numsSize, int target)
    la  a0, array                    # store array address in a0 (first argument)
    la  a1, length
    lw  a1, 0(a1)                    # store array length in a1 (second argument)
    addi a2 x0 9                     # store target element in a2 (third argument)
    # call search function
    jalr ra search
    
search:
    addi t1 x0 x0                   # left = 0
    sub 