format PE console      ;формат ожидаемого вывода

entry Start            ;объ€вл€ем ключевое слово дл€ входа в программу

include 'win32a.inc'

section '.data' data readable writable    ;секци€ пам€ти, которую будем использовать в прогармме

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

    name rd 2    ;destination registry
    age rd 1
    NULL = 0

section '.code' code readable executable     ;секци€ кода с соответсвующими флагами

    Start: 
        push nameStr        ;кладем в стэк строку и вызываем ее в консоль при помощи комманды printf
        call[printf]

        push name
        push formatStr     ;считываем вводимое пользователем значение и присваиваем его ссылке на name
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

        cmp [age], 20      ;реализуем условный оператор if else, дл€ этого сравниваем значение, которое хранитс€ в ссылке на age
        jl label2          ;jumpm if less если возраст оказалс€ больше мы переходим к выполнению label2
                push bStr
                jmp finish
        label2:
                push zStr
                jmp finish
        finish:
        call [printf]
        call [getch]      ;вызываем комманду getch чтобы программа сразу не закрывалась
        push  NULL
        call[ExitProcess]  ;вызываем комманду ExitProcess дл€ того чтобы закрыть программу, класть 0 в стэк не так важно, но стоит




section '.idata' import data readable      ;импортируемые бибилиотеки
    
        library kernel, 'kernel32.dll' ,\
                msvcrt, 'msvcrt.dll'

        import kernel ,\
               ExitProcess, 'ExitProcess'

        import msvcrt ,\
               printf, 'printf',\
               scanf, 'scanf',\
               getch, '_getch'