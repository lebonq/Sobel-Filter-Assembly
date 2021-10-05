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
		.word   0,0,0,0,0,0,0,0
		.word   0,0,0,0,0,0,0,0
		.word   0,0,0,0,0,0,0,0
		.word   0,0,0,0,0,0,0,0
		.word   0,0,0,0,0,0,0,0
		.word   0,0,0,0,0,0,0,0
		.word   0,0,0,0,0,0,0,0
		.word   0,0,0,0,0,0,0,0

filtreGx: 
		.word -1, 0, 1
		.word -2, 0, 2
		.word -1, 0, 1

	    
filtreGy: 
		.word 1, 2, 1
		.word 0, 0, 0
		.word -1, -2, -1

tailleFiltre:
		.word 9

tailleSousMatrice:
		.word 3

decalageMatrice:
        .word 72

tailleSob:
		.word 6

;;;;; Glossaire de registres ;;;;;
; r1 decalage pour la matrice de l'image
; r2 image filtrée
; r3 le filtre horizontal
; r4 le filtre vertical
; r5 partie de l'image où nous travaillons (nous ignorons les bords de l'image pour appliquer le filtre de Sobel)
; r6 resultat horizontal
; r7 resultat vertical
; r8 decalage pour les filtres
; r9 taille du filtre : compteur des calcules des filtres
; r10 registre temporaire des multiplication horizontal Gx
; r11 registre temporaire des multiplication vertical Gy
; r12 decalage de la matrice pour remplir la sobelized
; r13 compteur sur la largeur de notre sous matrice dans l'image
; r14 taille du filtre
; r15 le gradient
; r16 compteur largeur du sobelized (=6)
; r17 compteur hauteur du sobelized (=6)
; r18 decalage sobel
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.text
	lw r2, sobelized(r0)
	lw r3, filtreGx(r0)
	lw r5, img(r1) ;on veut commencer à la valeur 7 et non au coin gauche
	lw r4, filtreGy(r0)
	lw r13, tailleSousMatrice(r0)
	lw r14, tailleFiltre(r0)
	lw r16, tailleSob(r0)
	lw r17, tailleSob(r0)
	lw r18, decalageMatrice(r0)
	daddi r31,r31,#-1
	j calculFiltres ; demarrer le programme a la fonction calculFiltres

resetImage:
	daddi r1,r1,#40
	lw r13, tailleSousMatrice(r0)
	j afterResetCompteur
	
calculFiltres: 
	daddi r8,r8,#8 ; on incremente le decalage du filtre
	daddi r1,r1,#8 ; on incremente le decalage de l'image
	daddi r13,r13,#-1 ; on decremente le decalage de la sous matrice
	daddi r14,r14,#-1 

	dmult r3, r5 ; multiplication horizontal
	mflo r10

	dmult r4, r5 ; multiplication vertical
	mflo r11
        
	beqz r13, resetImage
        
afterResetCompteur:
	lw r5,img(r1) ; charge la prochaine valeur de l'image
        
	dadd r6,r6,r10 ; resultat Gx
	lw r3, filtreGx(r8) ; met la prochaine valeur du filtreGx
	dadd r7,r7,r11 ; resultat Gy
	lw r4, filtreGy(r8) ; met la prochaine valeur du filtreGy
	
    bnez r14, calculFiltres ; fin de boucle

	lw r14, tailleFiltre(r0)
	daddi r1,r1,#-184 ; pour faire commencer le filtre à la prochaine valeur de l'image (carré)
	movn r8,r0,r8 ; on remet a 0 le registre de decalage du filtre
	lw r3, filtreGx(r8) ; met la prochaine valeur du filtreGx
	lw r4, filtreGy(r8) ; met la prochaine valeur du filtreGy
	lw r13, tailleSousMatrice(r0) ; on remet à 3 le registre de la taille de la sous matrice

	dsra r19,r6,31
	xor r20,r19,r6
	dsub r20,r20,r19

	dsra r21,r7,31
	xor r22,r21,r7
	dsub r22,r22,r21

	dadd r15,r22,r20
	;dsrl r15,r15,#1
	sw r15,sobelized(r18)
	daddi r18,r18,#8
	daddi r16,r16,#-1
	movn r6,r0,r6 ;
	movn r7,r0,r7 ;
	movn r15,r0,r15 ;

	lw r5,img(r1) ; charge la prochaine valeur de l'image

	bnez r16, calculFiltres

	lw r16, tailleSob(r0)
	daddi r1,r1,#16
	daddi r18,r18,#16
	daddi r17,r17,#-1
	lw r5,img(r1) ; charge la prochaine valeur de l'image
	
	bnez r17,calculFiltres

	halt