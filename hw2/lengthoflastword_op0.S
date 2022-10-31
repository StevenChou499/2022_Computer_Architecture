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
fstr:       .string "For string \""
            .set flen, .-fstr
answrstr:   .string "\", length of last word : "
            .set answrlen, .-answrstr  
newline:    .string "\n"
            .set nllen, .-newline

.text
_start:
        # function : lengthOfLastWord(char * s)
        # a0 : pointer to the start of the string
        la          a0, str1
        # find the position of the last letter is not space
        jal         ra, lengthoflastword        # call strlen()
        add         a2, x0, a0
        la          a0, str1
        li          a1, str1len
        jal         print_result

        la          a0, str2
        # find the position of the last letter is not space
        jal         ra, lengthoflastword        # call strlen()
        add         a2, x0, a0
        la          a0, str2
        li          a1, str2len
        jal         print_result

        la          a0, str3
        # find the position of the last letter is not space
        jal         ra, lengthoflastword        # call strlen()
        add         a2, x0, a0
        la          a0, str3
        li          a1, str3len
        jal         print_result

        li          a0, 0             # return value is 0
        li          a7, SYSEXIT       # end
        ecall

nochar:
        li          a0, 0
        ret
lengthoflastword:
        lb          t0, 0(a0)
        beq         t0, x0, nochar
        addi        a1, x0, 1         # there are at least one character
findend:
        # a0 : moving pointer untill we reach the end of the string
        # a1 : counting the number of characters
        addi        a0, a0, 1         # find the last position of the string
        addi        a1, a1, 1
        lb          t0, 0(a0)
        bne         t0, x0, findend
        li          a2, 32            # store space to register a3
loop1:
        # now we reach the end of the string
        beq         a1, x0, return    # if encounter the last position, return
        addi        a0, a0, -1        # s--
        addi        a1, a1, -1        # the last position is not space
        lb          t0, 0(a0)         # t0 = s[i]
        beq         t0, a2, loop1     # while(char[i] == " ")
        add         a3, x0, a0        # a3 = a0
        add         a0, x0, x0
loop2:
        beq         a1, x0, return    # if encounter the last position, return
        addi        a1, a1, -1
        addi        a3, a3, -1
        addi        a0, a0, 1         # s++
        lb          t0, 0(a3)         # t0 = s[i]
        bne         t0, a2, loop2     
return:
        ret

print_result:
        add         s0, x0, a0
        add         s1, x0, a1
        add         s2, x0, a2
        li          a7, SYSWRITE
        li          a0, 1             # print For string : "
        la          a1, fstr
        la          a2, flen
        ecall

        li          a7, SYSWRITE
        li          a0, 1             # print i am a student  
        add         a1, x0, s0
        add         a2, x0, s1
        ecall

        li          a7, SYSWRITE
        li          a0, 1             # print ", length of last word is   
        la          a1, answrstr
        li          a2, answrlen
        ecall

        li          a7, SYSWRITE
        addi        a1, s2, 48        # get length
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
