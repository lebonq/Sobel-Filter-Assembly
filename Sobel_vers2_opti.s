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


Gx: 
		.word -1, 0, 1
		.word -2, 0, 2
		.word -1, 0, 1

	    
Gy: 
		.word 1, 2, 1
		.word 0, 0, 0
		.word -1, -2, -1

compteurligne:
        .word 3


;;;;;; Glossaire ;;;;;;
; r1: offset pour r1 (72 au début)
; r2: valeur de Gx
; r3: valeur de Gy
; r4: valeur a calculer
; r5: resultat multiplication Gx
; r6; compteur de valeur (=3)
; r7: resultat calcul Gx
; r8: resultat multiplication Gy
; r9: resultat calcul Gy
; r10: offset filtre
; r11: inutilise
; r12: compteur de nbr de ligne matrice (=3)
; r13: resultat gradient
; r14: regsitre temporaire pour le calcul de la valeur absolue de Gx
; r15: resultat de la valeur absolue de Gx
; r16: regsitre temporaire pour le calcul de la valeur absolue de Gy
; r17: resultat de la valeur absolue de Gy
; r18: resultat du gradient
; r19: compteur pour remplir le sobelized (=36)
; r20: offset pour remplir la sobelized
; r21: compteur ligne img (=6)

;;;;;;;;;;;;;;;;;;;;;;;

.text
    ;initialisation
    daddi r6, r6, #3
    movn r10, r10,r0 ;intialisation r8 a 0
    daddi r12,r12, #3
    daddi r19, r19, #36
    movn r20,r20,r0 ;initialisation de r20 à 0
    daddi r21,r21, #6

    
boucleG:
    lw r4, img(r1) ;chargement de l'image
    lw r2, Gx(r10) ;chargement de la valeur de Gx
    lw r3, Gy(r10) ;chargement de la valeur de Gy

    ;multiplication Gx
    mult r4, r2
    daddi r6, r6, #-1 ;decrementation du compteur de valeur sur la meme ligne
    daddi r1, r1, #8 ;incrementation de l'offset de l'image (sur la meme ligne)
    mflo r5

    ;mulitplication Gy
    mult r3, r4
    daddi r10, r10, #8 ;incrementation de l'offset des filtres
    mflo r8

    ;calcul Gx
    dadd r7, r7, r5

    ;calcul Gy
    dadd r9,r9,r8
    
    bnez r6, boucleG ;si on a pas finis de parcourir toute la ligne
    
    daddi r12, r12, #-1 ;decrementation du compteur nombre de ligne
    daddi r1, r1, #40 ;on passe a la ligne suivante
    lw r6, compteurligne(r0) ;remet le compteur a 3
    bnez r12, boucleG ;si on a pas finis de parcourir toute la matrice de l'image

    ;calcul de la valeur absolue Gx et Gy (ligne alternée + une instruction)
    dsra r14,r7,31
    dsra r16,r9,31
    movn r10,r0,r10 ;reinitialisation de l'offset des filtres
    
    
	xor r15,r14,r7
    xor r17,r16,r9
    daddi r12,r12, #3 ;reinitialisation compteur nbr ligne matrice
    
	dsub r15,r15,r14
    dsub r17,r17,r16
    daddi r1,r1, #-184 ;on se replace a la prochaine valeur dont on veut calculer le gradient
    lw r6, compteurligne(r0) ;remet le compteur a 3

    ;calcul du gradient final
    dadd r18,r15,r17 ;somme des valeurs absolues

    movn r7,r0,r7 ;reinitialisation du resultat Gx
    daddi r19, r19, #-1 ;decrementation compteur sobelized
    sw r18,sobelized(r20) ;store la valeur dans la sobelized
    movn r9,r0,r9 ;reinitialisation du resultat Gy
    daddi r21,r21,#-1 ;decrementation compteur ligne matrice
    daddi r20,r20, #8 ;incrementation dans l'offset du sobelized
    
    bnez r21, boucleG ;remplissage de la premiere ligne du sobelized

    daddi r1,r1,#16 ;on passe a la premiere valeur de la prochaine ligne
    daddi r21,r21,#6 ;on remet le compteur a 6
    bnez r19,boucleG

    halt
