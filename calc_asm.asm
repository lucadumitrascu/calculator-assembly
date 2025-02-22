.MODEL SMALL
.STACK 100h

.data
; Calculatorul va afisa doar valorile cuprinse intre 0 si 99    ; inclusiv.
; Daca rezultatul calculului va fi un numar mai mare decat 99 nu ; va afisa rezultatul
; Asemanator si cu cazul in care am un numar negativ.

;Valorile care intra in calculator
valoare1 dw 100
valoare2 dw 2

;Variabila pentru selectia operatiei
operatie db ?; ? = urmeaza sa fie initializata in momentul
             ; rularii

;Rezultatul de 2 cifre al oricarei operatii impartit in cat si ;rest
catul dw 0
restul dw 0

titlu_aplicatie db 10,13,"Calculator Assembly$"
mesaj3 db 10,13,"Alegeti din urmatoarele optiuni: $"
operatie1 db 10,13,"Adunare -> 1$"
operatie2 db 10,13,"Scadere -> 2$"
operatie3 db 10,13,"Inmultire -> 3$"
operatie4 db 10,13,"Impartire -> 4$"
suma_text db 10,13,"Rezultat adunare: $"
scadere_text db 10,13,"Rezultat scadere: $"
inmultire_text db 10,13,"Rezultat inmultire: $"
impartire_text db 10,13,"Rezultat impartire: $"
iesire db 10,13,"Inchide program -> 5$"
alegere db 10,13,"Alegere: $"
rezultat db 10,13,"Rezultat: $"

; Erorile
numar_prea_mare db 10,13,"Rezultatul este >= 100 sau nu poate fi impartit exact$"
numar_negativ db 10,13,"Rezultatul este < 0$"

.code
start:
mov ax,@data
mov ds,ax

mov ah,09h
mov dx, offset titlu_aplicatie ; afisare titlu
int 21h

mov ah,09h
mov dx, offset mesaj3; Afisare mesaj
int 21h

; Afisare variante
mov dx, offset operatie1
int 21h
mov dx, offset operatie2
int 21h
mov dx, offset operatie3
int 21h
mov dx, offset operatie4
int 21h
mov dx, offset iesire;
int 21h

optiuni:
mov ah, 09h
mov dx, offset alegere
int 21h

mov ah, 01h
int 21h
mov operatie, al; se incarca in variabila operatie valoare
                ; introdusa de la tastatura de catre utilizator

;Gestionare optiuni
cmp operatie, "1"
JE adunare  ; Jump if Equal 1 to adunare

cmp operatie, "2"
JE scadere  ; Jump if Equal 2 to scadere

cmp operatie, "3"
JE inmultire; Jump if Equal 3 to inmultire

cmp operatie, "4"
JE impartire; Jump if Equal 4 to impartire

cmp operatie, "5"
JE iesire1  ; Jump if Equal 5 to iesire din program


iesire1:
mov ah, 4Ch ; incheierea programului, eliberarea memoriei
int 21h
jmp sfarsit

adunare:
mov ah, 09h
mov dx, offset suma_text ; Afisare "Rezultatul adunare: '
int 21h

mov ax, valoare1 ; se incarca in ax prima valoare
add ax, valoare2 ; se aduna prima valoare cu a doua valoare
jmp afisare ; sare la afisare

scadere:
mov ah, 09h
mov dx, offset scadere_text
int 21h

mov ax, [valoare1] ; valoarea efectiva a variabilei folosind
                   ;[nume_varibila]
sub ax, [valoare2]
jmp afisare ; asemanator cu adunarea

inmultire:
mov ah, 09h
mov dx, offset inmultire_text
int 21h

mov ax, [valoare1]
mul byte ptr [valoare2] ; byte ptr specifica ca operatia de
  ; inmultire trebuie sa aiba loc pe un singur byte de date
; adica se asigura ca instructiunile lucreaza doar cu primii 8
; biti ai valorii stocate

jmp afisare ; asemanator cu scaderea

impartire:
mov ah, 09h
mov dx, offset impartire_text
int 21h

mov ax, [valoare1]
div byte ptr [valoare2]
jmp afisare ; asemanator cu inmultirea

afisare:

cmp ax, 0
jl mai_mic_decat_0 ; JUMP if AX < 0 to mai_mic_decat_0

cmp ax, 100
jge mai_mare_decat_100 ; JUMP if AX >= 100 to
                       ; mai_mare_decat_100


mov cx, 10 ; se ?ncarc? cx cu valoarea 10 pentru impartire
mov dx, 0 ; setare dx la 0
div cx ; se imparte ax la 10 pentru a separa cele 2
       ; caractere ?n rest si cat
mov catul, ax ; se adauga catul stocat in ax in variabila
              ; catul
mov restul, dx ; se adauga restul stoacat in dx in variabila
               ; restul
 
add [catul], '0' ; transformare in caracter
mov ah, 02h      ; functia pentru afisarea unui caracter
mov dx, [catul]
int 21h

add [restul], '0'; la fel ca la cat
mov dx, [restul]
int 21h
jmp optiuni      ; sare inapoi pentru a selecta alta operatie


mai_mare_decat_100:
mov ah, 09h
mov dx, offset numar_prea_mare
int 21h
jmp optiuni

mai_mic_decat_0:
mov ah, 09h
mov dx, offset numar_negativ
int 21h

jmp optiuni

sfarsit:
end start
