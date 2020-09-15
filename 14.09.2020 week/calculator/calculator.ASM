format PE console

entry Start

include  'win32a.inc'

section '.data' data readable writable

        strA db 'Enter A: ',0  
        strB db 'Enter B: ',0
        strOp db 'Enter operation: ',0

        resStr db 'Result: %d' , 0
        resMod db '/%d' ,0

        spaceStr db ' %d',0
        emptyStr db '%d',0

        infinity db 'infinity',0
        point db ',',0

        A dd ?
        B dd ?
        C dd ?

        NULL = 0

section '.code' code readable executable ;помечаем секцию, содержащую код
;флагами код, доступный для чтения и доступный для запуска

        Start:
                push strA
                call[printf]

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
;поместили в стак цифры и операцию. Операция находиться на самом верху
;вызываем ее при помощи getch и сравниваем по коду символа с символом +
                call[getch]

                cmp eax, 43
                jne notAdd    ;конструкция if else, если сравнение даёт 1, то
;выполняется код первого блока. Если 0, то блока после notAdd: 
                    mov ecx, [A] ;поместили значение внутри ссылки на А в ecx
                    add ecx, [B] ;добавили в него значение из ссылки на В

                    push ecx ;добавили в стэк
                    push resStr
                    call [printf] ;вызвали операцию вывода на экран содержимого 
                                    ;стека

                    jmp finish ;"прыгаем" к выполннию блока finish:
                notAdd:

                cmp eax, 45 ;для операции -
                jne notSub
                    mov ecx, [A]
                    sub ecx, [B]

                    push ecx
                    push resStr
                    call [printf]

                    jmp finish
                notSub:

                cmp eax, 42 ;для операции *
                jne notMul
                    mov ecx, [A]
                    imul ecx, [B]

                    push ecx
                    push resStr
                    call [printf]
                    jmp finish


                notMul:

                cmp eax, 37 ; для деления без остатка
                jne notMod
                    mov eax, [A] ;перемещаем значение из ссылки на А в регистр
                                                        ;аккумулятор
                    mov ecx, [B] ;значение из ссылки на В в регистр циклов
                    mov edx, 0 ;присваиваем 0 регистру 

                    cmp [B],0 ;сравниваем значение из ссылки на В с нулём
                    jne notNullDiv
                        push infinity ;кладем в стек бесконечность и вызываем
                        call [printf]


                     notNullDiv:

                     div ecx ;у операции div всего одна операнда которая
                             ;обозначает делитель и регистр куда помещается
                             ;остаток. Результата деления помещается в eax
                     mov [C], edx ;присваиваем значению эл-та ссылки С остаток

                     push eax
                     push resStr
                     call [printf]

                     push [C]
                     push spaceStr
                     call [printf]

                     push [B]
                     push resMod
                     call [printf] ;пихаем в стек и выводим на экран
                     jmp finish
                notMod:

                cmp eax, 47 ; для деления с состатком
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

                     lp:
                        mov eax, [C]
                        mov ecx, [B]
                        imul eax, 10

                        mov edx, 0
                        div ecx
                        mov [C], edx

                        push eax
                        push emptyStr
                        call [printf]


                     add ebx,1
                     cmp ebx, 3
                     jne lp

                     jmp finish
                notDiv:


                finish:

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




                   