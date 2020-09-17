format PE console       ;указываем формат ожидаемого вывода. В данном случае консольный вывод

entry start             ;обозначение точки входа

include 'win32a.inc'

section '.data' data readable writable  ;секция предопределенной памяти, помеченной соответсвующими флагами
;кстати важное замечание, название секции не должно содержать больше 8 букв учитывая точку
        helloStr db 'Hello world',0
        NULL = 0

section '.code' code readable executable    ;секция кода

        start:                      ;точка входа в программу
                push helloStr       ;помещаем в стек строку с сообщением
                call [printf]       ;вызываем комманду printf, которая выводит содержимое стека в консоль и очищает стек

                call [getch]        ;вызываем комманду getch чтобы программа сразу не закрывалась (нужно нажать на любую клавишу)
                ;вообще getch вроде как считывает первую букву и сразу ее возвращает

                push NULL
                call [ExitProcess]  ;вызываем комманду выхода из программы. Нул не обяателен, но вроде без него это мовэтон

section 'idata' import data readable ;импортируемые комманды из библиотеки kernel32.dll

        library kernel, 'kernel32.dll',\
                msvcrt, 'msvcrt.dll'

        import kernel,\
               ExitProcess, 'ExitProcess'

        import msvcrt,\
        printf, 'printf',\
        getch, '_getch'