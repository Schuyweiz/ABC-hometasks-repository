format PE console

entry Start

include 'win32a.inc'

section '.data' data readable writable

    nameStr db 'What is your name? ',0
    niceMeetStr db 'Nice to meet you, %s ',0
    meStr db ' My name is Kirill ',0
    howOldStr db 'how old are you? ' ,0
    ageStr db 'Wow! You are %d years old!',0
    bStr db ' Boomer',0
    zStr db ' Zoomer',0
    paceStr db ' %d',0
    emptyStr db '%d',0
    formatStr db '%s',0

    name rd 2
    age rd 1
    NULL = 0

section '.code' code readable executable

    Start: 
        push nameStr
        call[printf]

        push name
        push formatStr
        call[scanf]

        push meStr
        push name
        push niceMeetStr
        call [printf]

        push howOldStr
        call [printf]

        push age
        push emptyStr
        call [scanf]
        push [age]
        push ageStr
        call [printf]

        cmp [age], 20
        jl label2
                push bStr
                jmp finish
        label2:
                push zStr
                jmp finish
        finish:
        call [printf]
        call [getch]
        push  NULL
        call[ExitProcess]

        cmp [age], 20



section '.idata' import data readable
    
        library kernel, 'kernel32.dll' ,\
                msvcrt, 'msvcrt.dll'

        import kernel ,\
               ExitProcess, 'ExitProcess'

        import msvcrt ,\
               printf, 'printf',\
               scanf, 'scanf',\
               getch, '_getch'