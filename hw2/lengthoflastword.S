.org 0
# Provide program starting address to linker
.global _start

/* newlib system calls */
.set SYSEXIT,  93
.set SYSWRITE, 64

.data
str1:       .string "Hello World"
            .set str1len, .-str1
str2:       .string "I am a student  "  
            .set str2len, .-str2
str3:       .string "a"
            .set str3len, .-str3
space:      .string " "
fstr:       .string "For string : \""
            .set flen, .-fstr
answrstr:   .string "\", length of last word is "
            .set answrlen, .-answrstr  
newline:    .string "\n"
            .set nllen, .-newline

.text
# a1 = str1 address
# a2 = space
# a3 = length
# a4 = filter

_start:
        # function : lengthOfLastWord(char * s)
        la          a1, str1
        lb          a2, space
        la          a5, str1
        addi        a3, x0, 1         # initialize length = 1
        # find the position of the last letter is not space
        jal         ra, strlen        # call strlen()
        la          a1, str1
        li          a2, str1len
        jal print_result

        la          a1, str2
        lb          a2, space
        la          a5, str2
        addi        a3, x0, 1         # initialize length = 1
        # find the position of the last letter is not space
        jal         ra, strlen        # call strlen()
        la          a1, str2
        li          a2, str2len
        jal print_result
        
        la          a1, str3
        lb          a2, space
        la          a5, str3
        addi        a3, x0, 1         # initialize length = 1
        # find the position of the last letter is not space
        jal         ra, strlen        # call strlen()
        la          a1, str3
        li          a2, str3len
        jal print_result

        li          a0, 0             # return value is 0
        li          a7, SYSEXIT       # end
        ecall

nochar:
        li          a3, 0
        ret
strlen:
        lb          t0, 0(a1)
        beq         t0, x0, nochar
findend:
        addi        a1, a1, 1         # find the last position of the string
        addi        a4, a4, 1
        lb          t0, 0(a1)
        bne         t0, x0, findend
loop1:                             
        addi        a1, a1, -1        # s--
        addi        a4, a4, -1        # the last position is not space
        lb          t0, 0(a1)         # t0 = s[i]
        beq         t0, a2, loop1     # while(char[i] == " ")
        add         a1, x0, a5
loop2:  
        beq         a4, x0, return    # if encounter the last position, return
        addi        a4, a4, -1        
        addi        a1, a1, 1         # s++
        lb          t0, 0(a1)         # t0 = s[i]
        addi        a3, a3, 1         # length++
        bne         t0, a2, loop2     
        addi        a3, x0, 0         # if encounter a space, length = 0
        j           loop2
return:    
        ret
print_result:
        add         s1, x0, a1
        add         s2, x0, a2
        li          a7, SYSWRITE
        li          a0, 1             # print For string : "
        la          a1, fstr
        la          a2, flen
        ecall

        li          a7, SYSWRITE
        li          a0, 1             # print i am a student  
        add         a1, x0, s1
        add         a2, x0, s2
        ecall

        li          a7, SYSWRITE
        li          a0, 1             # print ", length of last word is   
        la          a1, answrstr
        li          a2, answrlen
        ecall

        li          a7, SYSWRITE
        addi        a1, a3, 48        # get length
        addi        sp, sp, -4
        sw          a1, 0(sp)         # store answer in stack
        li          a0, 1             # print answer
        addi        a1, sp, 0
        li          a2, 4
        ecall
        addi        sp, sp, 4

        li          a7, SYSWRITE
        li          a0, 1             # print new line
        la          a1, newline       
        li          a2, nllen
        ecall
        ret
