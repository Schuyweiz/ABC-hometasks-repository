 format PE console
entry start 
include 'macro/import32.inc'
include 'win32a.inc'

section '.data' data readable writeable 

    N dd ?  ;size of array
    sizeB dd 0 ;size of array B
    temp dd ?  ;temporary value to work with array initialization
    aSizeStr db 'Size of A is ',0  ;string to invite the user to chose array A size
    nextEl db '[%d] = ',0 ;string to visualize input in array A
    readnum db '%d',0 ;string to read a number
    bStr db 'Array B is : ',0 ;string to announce array A
    aStr db 'Array A is : ',0 ;string to announce array B
    avgStr db 'Average is : %d',10,0 ;string to display average value
    arrayBeginStr db '[',0  ;string for displaying the beginning of an array
    arrayEndStr db ']',10,0 ;string for displaying the ending of an array
    arrayElementStr db ' %d ',0 ;string for displaying array elements
    errorMsg db 'An error occured',10,0
    finishMsg db 'Press any button to exit',0
    A rd 256 ;allocating data for the array A
    B rd 256 ;same for B
    avg dd 0 ;average

section '.code' code readable executable

    start:
    ;1) interact with the user to create array A
        call create_array_A
    ;2) calculating an average creating array B
        call solution
    ;3)display array A
        call read_array_A
    ;4) display array B
        call read_array_B

        finish: 
        push finishMsg
        call [printf]
        call [getch]
        push 0
        call [ExitProcess]

        error_finish:
        push errorMsg
        call [printf]
        add esp, 4
        jmp finish

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
create_array_A:
        ;saving return adress


        ;A size input
        push aSizeStr
        call [printf]
        add esp,4       ;clearing stack after printf (moving top of the stack pointer to its initial position)

        push N           ;initializing A size
        push readnum
        call [scanf]
        add esp,8

        cmp [N],0        ;if size is less than 1, finish program execution
        jle error_finish
        ;;;;;;;;;;;;;;;;
        ;counter
        mov ebx, 0
        ;Filling array with elements
        fill_loop_A:

                push ebx
                push nextEl
                call [printf]
                add esp, 8

                push temp
                push readnum
                call [scanf]
                add esp, 8

                mov eax, [temp]       ;retrieving input value to assign it to a register
                mov [A+ebx*8],eax     ;to the next element we go. For every new elemet we shift by 8 bytes the adress of the memory ref
                inc ebx               ;increase counter
                cmp ebx,[N]
                jne fill_loop_A  ;do until equal
                ; end of loop
ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
read_array_A:
        ;counter
        mov ebx, 0

        push aStr
        call [printf]
        add esp, 4
        push arrayBeginStr
        call [printf]
        add esp, 4


        read_loop_A:
                push dword [A+ebx*8]
                push arrayElementStr
                call [printf]
                add esp, 8

                inc ebx
                cmp ebx, [N]
                jl read_loop_A        ;do while less

        push arrayEndStr
        call [printf]
        add esp, 4

ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

proc solution   ;procedure (not sure how is that any different from a function but ok)
        xor eax, eax
        mov ebx, 0
        loop_avg:
                add eax, [A + ebx*8]
                inc ebx
                cmp ebx, [N]
                jne loop_avg

        mov edx,0          ;initializing edx with a 0 before division, otherwise the program will crash
        mov ecx, [N]       ;moving a number to divide in ecx register
        cdq
        idiv ecx
        mov [avg], eax     ;moving result into a memory cell we allocated specially for it

        push [avg]
        push avgStr
        call [printf]
        add esp , 8





        mov ebx, 0 ;counter for A
        mov ecx, 0 ;counter for Â



        fill_loop_B:

                mov eax, [A + ebx*8] ;picking an element to study
                cmp eax, [avg]       ;compairing with the average value
                jg add_element       ;if stricly greater we can add it to the array B

                end_loop:
                        inc ebx
                        cmp ebx, [N]
                        jne fill_loop_B      ;do until A counter reaches the end
                        jmp finish_create_array_B      ;jump to exit upon completion

        ;adding an element
        add_element:
                mov  [B+ecx*8], eax
                add ecx, 1
                add [sizeB], 1
                jmp end_loop   ;checking main loop if its time to finish

finish_create_array_B:  ;exit

ret
endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
read_array_B:    ;same as A


        push bStr
        call [printf]
        add esp, 4
        push arrayBeginStr
        call [printf]
        add esp, 4

        mov ebx, 0

        read_loop_B:

                push [B+ebx*8]
                push arrayElementStr
                call [printf]
                add esp, 8

                inc ebx
                cmp ebx, [sizeB]
                jne read_loop_B


        push arrayEndStr
        call [printf]
        add esp, 4

ret




section '.idata' import data readable   

        library kernel, 'kernel32.dll' ,\
                msvcrt, 'msvcrt.dll'

        import kernel ,\
               ExitProcess, 'ExitProcess'

        import msvcrt ,\
               printf, 'printf',\
               scanf, 'scanf',\
               getch, '_getch'