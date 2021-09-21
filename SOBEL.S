.data
    img:    .double   1,1,1,1,1,1,1,1
            .double   1,7,9,1,4,3,3,1
            .double   1,8,3,5,2,1,0,1
            .double   1,5,6,3,2,7,8,1
            .double   1,9,4,2,6,3,1,1
            .double   1,6,5,3,5,7,8,1
            .double   1,2,5,5,3,7,1,1
            .double   1,1,1,1,1,1,1,1

    sobelized:  
            .double   0,0,0,0,0,0
            .double   0,0,0,0,0,0
            .double   0,0,0,0,0,0
            .double   0,0,0,0,0,0
            .double   0,0,0,0,0,0
            .double   0,0,0,0,0,0

    filtreGx: 
            .double -1, 0, 1
            .double -2, 0, 2
            .double -1, 0, 1

            
    filtreGy: 
            .double 1, 2, 1
            .double 0, 0, 0
            .double -1, -2, -1


.text
    halt