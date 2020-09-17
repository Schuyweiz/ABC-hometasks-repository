format PE console   ;ожидаемы формат вывода, в данном случае консольный вывод

entry Start         ;точка входа в программу

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
        push emptyStr  ;вводим в стэк строку и считываем ввод пользователя. Присваиваем значение ссылке А (последняя для вывода из стека)
        call [scanf]

        mov eax, [A]    ;перемещаем значение по ссылке А в регистр еах
        mov ecx, 4      ;перемещаем 4 в регистр есх
        mov edx, 0      ;инициализируем 0 для регистра edx
        imul eax,2      ;умножаем значение в регистре eax при помощи умножения целых чисел
        sub eax, 6      ;вычитаем из значения в регистре еах 6
        div ecx         ;делим значение в регистре еах на значение в регистре есх


        push eax        ;остаток от деления в последней операции остается в регистре еах
        push resStr
        call [printf]

        call [getch]    ;вызываем комманду getch чтобы программа сразу не закрывалась

        push NULL
        call[ExitProcess]   ;закрываем программу вызовом комманды ExitProcess, класть в стек 0 не обязательно, но без него мовэтон

section '.idata' import data readable        ;импорты комманд из бибилотеки kernel32.dll

        library kernel, 'kernel32.dll' ,\
                msvcrt, 'msvcrt.dll'

        import kernel ,\
               ExitProcess, 'ExitProcess'

        import msvcrt ,\
               printf, 'printf',\
               scanf, 'scanf',\
               getch, '_getch'
                                                     