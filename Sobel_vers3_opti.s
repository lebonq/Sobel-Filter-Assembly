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

compteur:
        .word 6



;;;;;; Glossaire ;;;;;;
; r1: offset pour r1 (72 au début)
; r2: registre de calcul de Gx
; r3: registre de calcul de Gy
; r4: valeur a calculer (pixel)
; r5: registre temporaire de calcul
; r6; compteur de colonne sobel (=6)
; r7: resultat calcul Gx
; r8: 
; r9: resultat calcul Gy
; r10: 
; r11: 
; r12: compteur de ligne sobel (=6)
; r13: 
; r14: registre temporaire pour le calcul de la valeur absolue de Gx
; r15: resultat de la valeur absolue de Gx
; r16: registre temporaire pour le calcul de la valeur absolue de Gy
; r17: resultat de la valeur absolue de Gy
; r18: resultat du gradient
; r19: compteur pour remplir le sobelized (=36)
; r20: offset pour remplir la sobelized
; r21: 

;;;;;;;;;;;;;;;;;;;;;;;

.text
    ;initialisation
    daddi r19, r19, #36
    movn r20,r20,r0 ;initialisation de r20 à 0

    lw r6, compteur(r0)
    lw r12,compteur(r0)

    
boucleG:
    lw r4, img(r1) ;chargement de l'image (commence à 0)
    dsub r7, r0, r4 ;valeur de Gx (*-1)
    dadd r9,r9,r4 ;valeur de Gy (*1)


    daddi r1, r1, #8 ;incrementation de l'offset de l'image
    lw r4, img(r1) ;chargement de l'image
    ;pas de calcul pour Gx (*0)
    dsll r3,r4,1 ;valeur de Gy (*2)
    dadd r9, r9, r3 ;ajout de la valeur de Gy

    daddi r1, r1, #8 ;incrementation de l'offset de l'image
    lw r4, img(r1) ;chargement de l'image
    dadd r7,r7,r4 ;valeur de Gx (*1)
    dadd r9,r9,r4 ;valeur de Gy (*1)

    ;ligne de 0 pour Gy donc pas de calcul
    daddi r1, r1, #48 ;on passe a la ligne suivante
    lw r4, img(r1) ;chargement de l'image
    dsll r2,r4,1 ;valeur de Gx (*2), on met dans un registre r2 temporaire
    dsub r5, r0, r2 ;valeur de Gx (*-1), on met dans un registre r5 temporaire
    dadd r7,r7,r5 ;ajout de la valeur a Gx
    
    ;pas de calcul pour Gx (*0)
    daddi r1, r1, #16 ;incrementation de l'offset de l'image (on decale de 2 valeurs)
    lw r4, img(r1) ;chargement de l'image
    dsll r2,r4,1 ;valeur de Gx (*2), on met dans un registre r2 temporaire
    dadd r7, r7, r2 ;ajout de la valeur de Gx

    daddi r1, r1, #48 ;on passe a la ligne suivante
    lw r4, img(r1) ;chargement de l'image
    dsub r2, r0, r4 ;;valeur de Gx (*-1), on met dans un registre r2 temporaire
    dadd r7,r7,r2 ;ajout de la valeur de Gx
    dsub r3, r0, r4 ;valeur de Gy (*-1), on met dans un registre r3 temporaire
    dadd r9, r9, r3 ;ajout de la valeur de Gy

    daddi r1, r1, #8 ;incrementation de l'offset de l'image
    lw r4, img(r1) ;chargement de l'image
    ;pas de calcul pour Gx (*0)
    dsll r3,r4,1 ;valeur de Gy (*2), on met dans un registre r3 temporaire
    dsub r5, r0, r3 ;valeur de Gy (*-1)
    dadd r9,r9,r5

    daddi r1, r1, #8 ;incrementation de l'offset de l'image
    lw r4, img(r1) ;chargement de l'image
    dadd r7,r7,r4 ;valeur de Gx (*1)
    dsub r3, r0, r4 ;valeur de Gy (*-1)
    dadd r9,r9,r3

    movn r2, r0, r2 ;reintialisation de r2
    movn r3, r0,r3 ;reintialisation de r3

    ;calcul des valeurs absolues
    dsra r14,r7,31
    dsra r16,r9,31
    daddi r19, r19, #-1 ;decrementation compteur sobelized

	xor r15,r14,r7
    xor r17,r16,r9
    daddi r1,r1, #-136 ;on se replace a la prochaine valeur dont on veut calculer le gradient

	dsub r15,r15,r14
    dsub r17,r17,r16
    daddi r6,r6,#-1 ;decrementation colonne sobel

    ;calcul du gradient final
    dadd r18,r15,r17 ;somme des valeurs absolues
    
    
    movn r7,r0,r7 ;reinitialisation du resultat Gx
    movn r9,r0,r9 ;reinitialisation du resultat Gy
    sw r18,sobelized(r20) ;store la valeur dans la sobelized
    daddi r20,r20, #8 ;incrementation dans l'offset du sobelized
    

    bnez r6,boucleG

    lw r6, compteur(r0) ;remet le compteur a 6

    daddi r12,r12,#-1 ;decrementation ligne sobel
    daddi r1,r1,#16 ;on passe a la premiere valeur de la prochaine ligne
    bnez r12, boucleG 

    halt











