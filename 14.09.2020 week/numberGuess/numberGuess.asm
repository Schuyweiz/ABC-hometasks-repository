format PE console

entry Start

include 'win32a.inc'

section '.data' data readable writable

    msgStr db 'Choose a number, multiply it by 4, add 6 and divide by 2. ',0
    msgStr2 db 'What result did you get?  ' , 0
    resStr db 'Your number is %d',0

    emptyStr db ' %d',0
    NULL = 0
    A dd ?

section '.code' code readable executable
    Start:
        push msgStr
        call [printf]

        push msgStr2
        call [printf]

        push A
        push emptyStr
        call [scanf]

        mov eax, [A]
        mov ecx, 4
        mov edx, 0
        imul eax,2
        sub eax, 6
        div ecx


        push eax
        push resStr
        call [printf]

        call [getch]

        push NULL
        call[ExitProcess]

section '.idata' import data readable

        library kernel, 'kernel32.dll' ,\
                msvcrt, 'msvcrt.dll'

        import kernel ,\
               ExitProcess, 'ExitProcess'

        import msvcrt ,\
               printf, 'printf',\
               scanf, 'scanf',\
               getch, '_getch'
                                                     