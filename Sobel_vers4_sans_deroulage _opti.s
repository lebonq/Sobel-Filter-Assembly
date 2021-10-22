.data
img:
	.word   1,1,1,1,1,1,1,1
	.word   1,7,9,1,4,3,3,1
	.word   1,8,3,5,2,1,0,1
	.word   1,5,6,3,2,7,8,1
	.word   1,9,4,2,6,3,1,1
	.word   1,6,5,3,5,7,8,1
	.word   1,2,5,5,3,7,1,1
	.word   1,1,1,1,1,1,1,1

sobelized:
	.word   0,0,0,0,0,0
	.word   0,0,0,0,0,0
	.word   0,0,0,0,0,0
	.word   0,0,0,0,0,0
	.word   0,0,0,0,0,0
	.word   0,0,0,0,0,0

compteur:
	.word 6

nbval:
	.word 36

start_image:
	.word 72

;;;;;; Glossaire ;;;;;;
; r1 : offset pour r1 (72 au début)
; r2 : compteur de de valeur sobel
; r3 : compteur de ligne sobel
; r4 : valeur en 0,0 du filtre
; r5 : valeur en 1,0 du filtre
; r6 : valeur en 2,0 du filtre
; r7 : valeur en 0,1 du filtre
;  : valeur en 1,1 du filtre pixel du centre jamais utilise car le filtre est tjr 0
; r8 : valeur en 2,1 du filtre
; r9: valeur en 0,2 du filtre
; r10: valeur en 1,2 du filtre
; r11: valeur en 2,2 du filtre
; r12: Gy
; r13: Gx
; r14: res
; r15: pour la valeur absolu
; r16: pour la valeur absolu
; r17: pour la valeur absolu
; r18: offset sobelized
;;;;;;;;;;;;;;;;;;;;;;;

.text
;initialisation

	lw r1,start_image(r0)
	lw r2,nbval(r0)
	lw r18,sobelized(r0)

boucle1:
	lw r3,compteur(r0)
boucle2:

	;On charge notre partie de l'image

	lw r4, -72(r1) 
	lw r5, -64(r1) ; *2
	lw r6, -56(r1) 
	lw r7, -8(r1) ; *2
	;lw r8, 0(r1) ;pixel du centre jamais utilise car le filtre est tjr 0
	lw r8,  8(r1) ; *2
	lw r9,  56(r1) 
	lw r10, 64(r1) ; *2 
	lw r11, 72(r1) 

	;On multiplie par 2
	dsll r5,r5,1
	dsll r7,r7,1
	dsll r8,r8,1
	dsll r10,r10,1

	;Calcul de Gy
	dadd r12,r0,r4
	dadd r13,r0,r8
	dadd r12,r12,r6
	dadd r13,r13,r11
	dadd r12,r12,r5
	dadd r13,r13,r6
	dsub r12,r12,r9
	dsub r13,r13,r9
	dsub r12,r12,r10
	dsub r13,r13,r7
	dsub r12,r12,r11
	dsub r13,r13,r4

	;calcul des valeurs absolues
    dsra r14,r12,31
	dsra r16,r13,31
	daddi r1,r1,#8 ; on decale le centre de la matrice
	daddi r3,r3,#-1 ; decremente le nombre de valeru sur la ligne
    xor r17,r16,r13
	xor r15,r14,r12
	daddi r2,r2,#-1 ; Decrement ele nombre de valeur traite
    dsub r17,r17,r16
	dsub r15,r15,r14

    ;calcul du gradient final
    dadd r14,r15,r17 ;somme des valeurs absolues
	;On store le resultat
	sw r14,sobelized(r18)
	
	daddi r18,r18,#8
	
	bnez r3,boucle2
	daddi r1,r1,#16
	bnez r2,boucle1

halt