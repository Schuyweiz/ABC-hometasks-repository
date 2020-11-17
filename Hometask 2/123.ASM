format PE console
entry start
 
include 'win32a.inc'
 
;--------------------------------------------------------------------------
section '.data' data readable writable
 
        strVecSize   db 'Input size of vector: ', 0
        strIncorSize db 'Incorrect size of vector = %d', 10, 0
        strCurrIndex  db '[%d]? ', 0
        strScanInt   db '%d', 0
        strVecElemOut  db '[%d] = %d', 10, 0
        strFirstArr db 'Sourse array: ',0
        strSecondArr db 'Array of summs: ',0
 
        vec_size         dd 0
        sum              dd 0
        ;const_2         dd 2
        vec_of_sum_size  dd 0
        vec_of_sum       rd 100
        is_even          dd 0
        i                dd ?
        j                dd ?
        tmp              dd ?
        tmpStack         dd ?
        tmpStack2        dd ?
        vec              rd 100
 
;--------------------------------------------------------------------------
section '.code' code readable executable
start:
 
; 1) vector input
        call VectorInput
; 2) get vector of summs
        call GetVectorOfSumms
; 3) print a message
        push strFirstArr
        call [printf]
; 4) source vector out
        call VectorOut
; 3) print a message
        push strSecondArr
        call [printf]
; 4) result vector out
        call SecondVectorOut
 
finish:
        call [getch]
 
        push 0
        call [ExitProcess]
 
;--------------------------------------------------------------------------
VectorInput:
        push strVecSize
        call [printf]
        add esp, 4
 
        push vec_size
        push strScanInt
        call [scanf]
        add esp, 8
 
        ;check if size <= 100
        mov eax, [vec_size]
        cmp eax, 100
        jle  checkBottom
 
fail_size:
        push vec_size
        push strIncorSize
        call [printf]
        push 0
        call [ExitProcess]
 
;check if size > 0
checkBottom:
        mov eax, [vec_size]
        cmp eax, 0
        jg  getVector
        jmp fail_size
 
; else continue...
getVector:
        xor ecx, ecx            ; ecx = 0
        mov ebx, vec            ; ebx = &vec
 
getVecLoop:
        mov [tmp], ebx           ; put ebx value into tmp
        cmp ecx, [vec_size]      ; if counter-reg-value is equal to vector size
        jge endInputVector       ; to end of loop
 
        ; print current index.to_string()
        mov [i], ecx             ; save counter-reg-value into i
        push ecx                 ; push counter-reg-value into stack
        push strCurrIndex        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        call [printf]            ; print current index.to_string()
        add esp, 8               ; move to the next cell of stack
 
        ; input element
        push ebx                 ; put the following item from register(where array is) to stack
        push strScanInt
        call [scanf]
        add esp, 8               ; move to the next cell of stack
 
        mov ecx, [i]             ; put index into ecx
        inc ecx                  ; increment index
        mov ebx, [tmp]           ; put current element into ebx
        add ebx, 4               ; move to the next cell of ebx
        jmp getVecLoop           ; go to the new iteration
endInputVector:
        ret
;--------------------------------------------------------------------------
GetVectorOfSumms:
        mov [vec_of_sum_size], 0     ; counter of the second array size
 
        xor ecx, ecx            ; ecx = 0 (zeroing  counter-reg-value)
        mov ebx, vec            ; ebx = &vec
        mov [i], 0              ; current index in the first array
        mov [j], 0              ; current index in the second array
 
sumItemsLoop:
        cmp eax, [vec_size]   ;should be - 1          ; if the end of the first array
        je endSumItems                  ; to end of loop
 
        ; getting of the first element to the sum
        mov eax, [i]
        mov ebx, [vec + eax*4]
        mov [sum], ebx
 
        ; offset in the first vec
        inc eax
        mov [i], eax
 
        ; getting of the second element to the tmp
        mov eax, [i]
        mov ebx, [vec + eax*4]
        mov [tmp], ebx
 
        ; add tmp to the sum ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        mov ecx, sum       ;eax, [sum]
        add ecx, tmp       ;eax, [tmp]
        mov [sum], ecx
 
        ; put sum into second array element
        mov eax, [j]
        mov ebx, [sum]
        mov [vec_of_sum + eax*4], ebx
 
        ; offset in the second vec
        mov [j], i
 
        ; offset in the first vec
        inc eax
        mov [i], eax
 
        ; zeroing sum
        mov [sum], 0
 
;next_item
        inc eax
 
        ;add ebx, 4  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        jmp sumItemsLoop
 
endSumItems:
 
        ret
;--------------------------------------------------------------------------
VectorOut:
        mov [tmpStack], esp
        xor ecx, ecx            ; ecx = 0
        mov ebx, vec            ; ebx = &vec
putVecLoop:
        mov [tmp], ebx
        cmp ecx, [vec_size]
        je endOutputVector      ; to end of loop
        mov [i], ecx
 
        ; output element
        push dword [ebx]
        push ecx
        push strVecElemOut
        call [printf]
 
        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4
        jmp putVecLoop
endOutputVector:
        mov esp, [tmpStack]
        ret
;--------------------------------------------------------------------------
SecondVectorOut:
        mov [tmpStack2], esp
        xor ecx, ecx            ; ecx = 0
        mov ebx, vec            ; ebx = &vec
 
putVecLoop2:
        mov [tmp], ebx
        cmp ecx, [vec_of_sum_size]
        je endOutputVector2      ; to end of loop
        mov [i], ecx
 
        ; output element
        push dword [ebx]
        push ecx
        push strVecElemOut
        call [printf]
 
        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4
        jmp putVecLoop
endOutputVector2:
        mov esp, [tmpStack2]
        ret
;-------------------------------third act - including HeapApi--------------------------
                                                 
section '.idata' import data readable
    library kernel, 'kernel32.dll',\
            msvcrt, 'msvcrt.dll',\
            user32,'USER32.DLL'
 
include 'api\user32.inc'
include 'api\kernel32.inc'
    import kernel,\
           ExitProcess, 'ExitProcess',\
           HeapCreate,'HeapCreate',\
           HeapAlloc,'HeapAlloc'
  include 'api\kernel32.inc'
    import msvcrt,\
           printf, 'printf',\
           scanf, 'scanf',\
           getch, '_getch'