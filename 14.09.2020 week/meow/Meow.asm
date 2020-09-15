format PE console

entry Start

include 'win32a.inc'

section '.data' data readable writable

    messageStr db 'How many times to pat a cat? ',0
    resultStr db 'meow ',0

    emptyStr db ' %d',0
    NULL = 0
    A dd ?

section '.code' code readable executable
    Start:
        push messageStr
        call [printf]

        push A
        push emptyStr
        call [scanf]
        mov ebx, 1
        lp:
            push resultStr
            call [printf]
            add ebx,1
            cmp ebx, [A]
            jle lp
            jmp finish

        finish:
        call [getch]

        push NULL
        call [ExitProcess]

section '.idata' import data readable

        library kernel, 'kernel32.dll' ,\
                msvcrt, 'msvcrt.dll'

        import kernel ,\
               ExitProcess, 'ExitProcess'

        import msvcrt ,\
               printf, 'printf',\
               scanf, 'scanf',\
               getch, '_getch'
    