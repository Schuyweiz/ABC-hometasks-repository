format PE console     ;ожидаемый формат вывода

entry Start           ;определяем ключевое слово для точки входа

include 'win32a.inc'

section '.data' data readable writable  ;секция чтобы определить память, которой мы будем пользоваться

    messageStr db 'How many times to pat a cat? ',0
    resultStr db 'meow ',0

    emptyStr db ' %d',0
    NULL = 0  ;константа
    A dd ?

section '.code' code readable executable     ;секция непосредственно кода
    Start:
        push messageStr      ;кладем строку в стак и выводим ее на экран, вызовом комманды printf
        call [printf]

        push A
        push emptyStr
        call [scanf]
        mov ebx, 1       ;инициализируем значение регистра ebx
        lp:              ;реализуем цикл for
            push resultStr
            call [printf]
            add ebx,1        ;увеличиваем значение счётчика цикла
            cmp ebx, [A]     ;сравниваем его со значением, хранящимся в ссылке А, по которой мы храним значение ввода пользователя
            jle lp           ;jump if less or equals прыгаем в начало цкла, если счётчик меньше или равен значению ввода
            jmp finish       ;переходим к выполнению блока окончания программы

        finish:
        call [getch]         ;вызываем комманду getch чтобы программа сразу не закрывалась

        push NULL
        call [ExitProcess]  ;вызываем комманду завершения выполнения программы, класть 0 в стэк не обязательно, но
        ;без него вроде как мовэтон

section '.idata' import data readable    ;секция импортов комманд из библиотеки kernel32.dll

        library kernel, 'kernel32.dll' ,\
                msvcrt, 'msvcrt.dll'

        import kernel ,\
               ExitProcess, 'ExitProcess'

        import msvcrt ,\
               printf, 'printf',\
               scanf, 'scanf',\
               getch, '_getch'
    