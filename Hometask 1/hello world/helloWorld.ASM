format PE console       ;��������� ������ ���������� ������. � ������ ������ ���������� �����

entry start             ;����������� ����� �����

include 'win32a.inc'

section '.data' data readable writable  ;������ ���������������� ������, ���������� ��������������� �������
;������ ������ ���������, �������� ������ �� ������ ��������� ������ 8 ���� �������� �����
        helloStr db 'Hello world',0
        NULL = 0

section '.code' code readable writable executable    ;������ ����

        start:                      ;����� ����� � ���������
                push helloStr       ;�������� � ���� ������ � ����������
                call [printf]       ;�������� �������� printf, ������� ������� ���������� ����� � ������� � ������� ����

                call [getch]        ;�������� �������� getch ����� ��������� ����� �� ����������� (����� ������ �� ����� �������)
                ;������ getch ����� ��� ��������� ������ ����� � ����� �� ����������

                push NULL
                call [ExitProcess]  ;�������� �������� ������ �� ���������. ��� �� ���������, �� ����� ��� ���� ��� �������

section 'idata' import data readable ;������������� �������� �� ���������� kernel32.dll

        library kernel, 'kernel32.dll',\
                msvcrt, 'msvcrt.dll'

        import kernel,\
               ExitProcess, 'ExitProcess'

        import msvcrt,\
        printf, 'printf',\
        getch, '_getch'