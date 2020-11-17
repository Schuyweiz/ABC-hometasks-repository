format PE console

entry Start

include  'win32a.inc'

section '.data' data readable writable
        ;определяем какими данными будем пользоваться и определяем под них байты
        strA db 'Enter A: ',0   ;db == define byte  что из ебя представляет 8 бит памяти
        strB db 'Enter B: ',0
        strOp db 'Enter operation: ',0

        resStr db 'Result: %d' , 0   ;оформляем форматы вывода значений на экран функцией printf
        resMod db '/%d' ,0

        spaceStr db ' %d',0
        emptyStr db '%d',0

        infinity db 'infinity',0
        point db ',',0

        A dd ?   ;dd == define double выделяет 4 байта или 32 бита памяти
        B dd ?
        C dd ?

        NULL = 0

section '.code' code readable executable ;описываем секцию в которой пишем код. Помечаем флагами код, читабельный, запускаемый
;для дальнейшей работы с этой секцией. Так же обозначаем точку входа, Start

        Start:
                push strA     ;кладем строку в стак и вызываем ее при помощи printf
                call[printf]  ;вызываем функцию при помощи call, в данном случае вызываем printf
                ;который выводит все значения, хранящиеся в стеке на экран (и освобождает стек)

                push A
                push spaceStr
                call[scanf]

                push strB
                call[printf]

                push B
                push spaceStr
                call[scanf]

                push strOp
                call[printf]

                call[getch]

                cmp eax, 43  ;сравниваем регистр, в котором хранится знак операции со сложением
                jne notAdd   ;условный оператор, если знак операции не является не сложением, то есть является сложением,
                ;выполняется дальнейший код в блоке. jne == jump if not equal
                    mov ecx, [A] ;перемещаем значение из ссылки на А (поэтому там и стоят квадратные скобки, А это ссылка, а не само значение)
                    ;в регистр есх
                    add ecx, [B] ;прибавляем к значению в операторе есх значение на которое указывает ссылка В

                    push ecx
                    push resStr
                    call [printf]

                    jmp finish ;дойдя до этой строки в коде, мы завершили сложение и перемещаемся к маркеру finish
                notAdd:        ;код, который выполняется, если знак операции не был знаком сложения

                cmp eax, 45 ;сравниваем с кодом знака вычитания
                jne notSub
                    mov ecx, [A]
                    sub ecx, [B]

                    push ecx
                    push resStr
                    call [printf]

                    jmp finish    ;все шаги идентичны сложению, только в этом случае мы используем функцию sub для вычитания
                notSub:

                cmp eax, 42 ;сравниваем со знаком умножения
                jne notMul
                    mov ecx, [A]
                    imul ecx, [B]  ;функция imul это умножение целых чисел

                    push ecx
                    push resStr
                    call [printf]
                    jmp finish


                notMul:

                cmp eax, 37 ;Сравниваем с символом деления  с остатком
                jne notMod
                    mov eax, [A]

                    mov ecx, [B]
                    mov edx,0       ;инициализируем edx

                    cmp [B],0 ;сравниваем делитель с нулём, чтобы вывести бесконечность, если делитель равен нулю
                    jne notNullDiv
                        push infinity
                        call [printf]

                     notNullDiv:

                     div ecx ;При делении коммандой div мы делим значение, которое лежит в регстре еах на регистр, который
                     ;предоставляем в качестве аргумента комманды, в данном случае есх. Результат деления так и останется в регистре еах
                     ;а вот остаток хранится в регистре edx. ОЧЕНЬ ВАЖНО ЕГО ИНИЦИАЛИЗИРОВАТЬ так как делению по барабану целое оно или нет
                     mov [C], edx

                     push eax
                     push resStr
                     call [printf]

                     push [C]
                     push spaceStr
                     call [printf]

                     push [B]
                     push resMod
                     call [printf]
                     jmp finish
                notMod:

                cmp eax, 47 ;проверяем деление ли это
                jne notDiv
                    mov eax, [A]
                    mov ecx, [B]
                    mov edx, 0

                    cmp [B],0
                    jne notNullDiv1
                        push infinity
                        call [printf]

                        jmp finish
                     notNullDiv1:

                     div ecx
                     mov [C], edx

                     push eax
                     push resStr
                     call [printf]

                     push point
                     call[printf]
                     mov ebx, 0

                     lp:        ;здесь мы реализуем цикл for
                        mov eax, [C]    ;по сути вычисляем цифры после запятой
                        mov ecx, [B]
                        imul eax, 10

                        mov edx, 0
                        div ecx
                        mov [C], edx

                        push eax
                        push emptyStr
                        call [printf]


                     add ebx,1   ;добавляем 1 к нашему счетчику цикла (тут сделано с ebx, но все же лучше вроде как ecx, так как общепринято)
                     cmp ebx, 3  ;сравниваем счётчик с 3
                     jne lp      ;если не равны, прыгаем в начало цикла

                     jmp finish  ;если равны, то прыгаем к завершению
                notDiv:


                finish:

                call [getch] ;вызываем getch чтобы программа сразу не закрыавлась

                push NULL     ;насколько я понял это хорошая практика, очень напоминает 0 при возвращении
                ;по завершении программы на другом языке. Закомментил эту строку и ничего не поменялось. Видимо не так это важно.
                call[ExitProcess] ; завершаем работу программы

section '.idata' import data readable      ;в этой секции наши иимпорты из библиотеки kernel32. Если очень интресно, то она лежит C:\\Windowds\System32\kernel32.dll

        library kernel, 'kernel32.dll' ,\
                msvcrt, 'msvcrt.dll'

        import kernel ,\
               ExitProcess, 'ExitProcess'

        import msvcrt ,\
               printf, 'printf',\
               scanf, 'scanf',\
               getch, '_getch'




                   