.org 0
# Provide program starting address to linker
.global _start

/* newlib system calls */
.set SYSEXIT,  93
.set SYSWRITE, 64

.data
str1:       .string ""
            .set str1len, .-str1
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

        li          a0, 0             # return value is 0
        li          a7, SYSEXIT       # end
        ecall

nochar:
        li          a0, 0
        ret
lengthoflastword:
        lb          t0, 0(a0)
        beq         t0, x0, nochar
        
        andi        a2, a0, 3
        add         a1, x0, a0        # a1 = a0
        bne         a2, x0, unaligned # jump if the address is unaligned
starttraverse:
        lui         a3, 0x7F7F8
        addi        a3, a3, -129      # now a3 is 0x7F7F7F7F
        addi        a4, x0, -1        # a4 = -1
findend:
        lw          t0, 0(a1)
        lw          t1, 4(a1)
        and         a2, t0, t1        # if there are NULL, a2 will have NULL too
        addi        a1, a1, 8
        and         a5, a2, a3
        add         a5, a5, a3
        or          a5, a5, a3
        beq         a5, a4, findend   # break if there are NULL

        and         a5, t0, a3
        add         a5, a5, a3
        or          a5, a5, a3
        bne         a5, a4, back4

findbyte:
        lbu         a2, -4(a1)
        sub         a3, a1, a0
        beq         a2, x0, sub4
        lbu         a2, -3(a1)
        beq         a2, x0, sub3
        lbu         a2, -2(a1)
        snez        a2, a2
        add         a2, a2, a3
        addi        a1, a2, -2
        j           findword
back4:
        addi        a1, a1, -4
        j           findbyte

checkalign:
        beq         a3, x0, starttraverse
unaligned:
        lbu         a2, 0(a1)
        addi        a1, a1, 1
        andi        a3, a1, 3
        bne         a2, x0, checkalign
        sub         a1, a1, a0
        addi        a1, a1, -1
        j           findword
sub4:
        addi        a1, a3, -4
        j           findword
sub3:
        addi        a1, a3, -3
        j           findword
findword:
        li          a2, 32            # store space to register a2
        add         a0, a1, a0
        addi        a1, a1, 1
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
