; *********************************************
; *  314 Principles of Programming Languages  *
; *  Fall 2016                              *
; *********************************************
;; -----------------------------------------------------
;; ENVIRONMENT
;; contains "ctv", "vtc",and "reduce" definitions
(load "include.ss")

;; contains a test document consisting of three paragraphs. 
(load "document.ss")

;; contains a test-dictionary, which has a much smaller dictionary for testing
;; the dictionary is needed for spell checking
;(load "test-dictionary.ss")

(load "dictionary.ss") ;; the real thing with 45,000 words


;; -----------------------------------------------------
;; HELPER FUNCTIONS

;; *** CODE FOR ANY HELPER FUNCTION GOES HERE ***



;;input: paragraph and encoder
;;output: encoded paragrah
(define encode-p
  (lambda (p encoder)						;;encode paragraph 
	(map (lambda (w) (encoder w)) p)			;;for each word in paragraph encode it 
    )
)


;;input: paragraph and decoder
;;output: decoded paragrah
(define decode-p
  (lambda (p decoder)						;;decode paragraph 
	(map (lambda (w) (decoder w)) p)			;;for each word in paragraph decode it 
    )
)

;;input: paragraph
;;output: length of correctly spelt words 
(define length 
   (lambda (p) 
       (cond 
		((null? p)					;;end of list , return 0.
			0
		)
        	((spell-checker (car p)) 			;;current word is correctly spelt, add one for length and continue checking the rest of the list 
           		(+ 1 (length (cdr p)))
         	)
        	(else 
	  		(+ 0 (length (cdr p)))			;;current word is not correctly spelt. continue checking the rest of list
         	)

       )
   )
)

;;input: a paragraph
;;output: a list with 26 encodings of the paragraph. 
(define createEncodings
  (lambda (p i)
    (cond 
      ((null? p) 						
		'()
      )
      ((= i 26) 
		'()
      )
      (else
		(cons (map (lambda(w) ((encode-n i) w)) p)  (createEncodings p (+ 1 i)))		;;create a new encoding with another shift 
	)
     )
  )
)


;;input: l is list e is element i is counter 
;;output: finds index of an element in list 
(define findIndex
   (lambda(l e i) 
	
	(cond 
		((null? l)
			i
		)
        	((eq? e (car l))
			i 
         	)
        	(else 
	  		(findIndex (cdr l) e (+ 1 i))
         	)

       )

   )

)

;;input: encoded paragraph
;;output: value of n that will decode it for you. 
(define test
   (lambda(p)  
     (let* (	 (v1 (createEncodings p 0))  ;;create all encodings
         	 (v2 (map (lambda(x)(length x))v1));;get the lengths of correct amount
	         (v3 (apply max v2));;get the max length
		 (v4 (findIndex v2 v3 0)) ;;return index of max element 
		 (v5 (list-ref v1 v4));;returns paragraph encoding with most correct
		 (v6 (car(car v5)));;first letter in encoded
		 (v7 (car(car p)));;first letter in encoded original
		 (v8 (ctv v6));;value of decoded letter
		 (v9 (ctv v7));;value of encoded original letter 
		 (v10 (- v8 v9))
		;;get largest paragraph use (list-ref ‘(a b c d e f) 2)
		;;find the difference between curr paragraph and other one
	   )
     		 v10
     )
    )
) 




;;Gen - B Helper Functions

;;input: paragraph
;;output: value of n to decode the doc
(define getNDecode
   (lambda(p)  
     (let* (	  (l (countLetters p 0))
		  (m (apply max l))
		  (listTop (topNums m l))
		  (letters (getLetterVals listTop 0));; letters with top values
	   )


		  (if (= (len letters) 1)
			(cadr (getE_A_T (car letters) p))
						
			(let* (	 (values (map(lambda(l)(getE_A_T l p)) letters)  )
         			 (lengths  (h1 values)  )
				 (maxxx (apply max lengths))
				 (indexxx   (findIndex lengths maxxx 0))
				 (top (list-ref values indexxx))
				 (valueOfN (list-ref top 1))
	      	      	   )
     		         	valueOfN
    			 )
		  )
     )
    )
) 


;;input: list
;;output: length
(define len 
	(lambda(x)
		(cond 
			((null? x)
				0
			)(else
				(+ 1 (len(cdr x)))
			)
		)
	)
)

;;input: list holding (letter occurrences correctlyspeltwords)
;;output: list with just correctlyspeltwords number
(define h1 
   (lambda(x)
        (cond 
			((null? x)
				'()
			)(else
				
				(cons (list-ref (car x) 2) (h1 (cdr x)))
			)
        )
   )
)


;;input: letter and par
;;output: list = (letter shiftN lengthOfCorrect)
(define getE_A_T
  (lambda(letter p)
	 (let* (
			(shiftE (- (ctv 'e) (ctv letter)))
			(shiftA (- (ctv 'a) (ctv letter)))
			(shiftT (- (ctv 't) (ctv letter)))
			(ePar (encode-p p (encode-n shiftE)))
			(aPar (encode-p p (encode-n shiftA))) 
			(tPar (encode-p p (encode-n shiftT))) 
			(encodings (list ePar aPar tPar))
			(lengths (map(lambda(pp)(length pp)) encodings))
			(max (apply max lengths))
			(indexx (findIndex lengths max 0))	
         	)
		(cond 
			((= max 0);;no encoding is right 
				(list letter 0 0)
			)
			((= indexx 0) 
				(list letter shiftE (car lengths))
			) 
			((= indexx 1)
				(list letter shiftA (cadr lengths))
			)
			((= indexx 2)
				(list letter shiftT (list-ref lengths 2))
			)
			(else    
				'()
			)
		) 

		
	)
  )
)





;;input: take a paragraph
;;output: list holding number of references 
;;ex) (countLetters )

(define countLetters
   (lambda(p i)  

	(cond 
		((= i 26) ;;end of list , return 0.
				 '()
		)(else


    			(let* (
				 (letter (vtc i))  
         			 (o  (populatePar p letter ))
				 (added (reduce + (flatten o) 0 ))
				 (numOfOcc (/ added (+ 1 i)))

	   			) 	 
				 ;numOfOcc
				(cons numOfOcc (countLetters p (+ 1 i)))
     			)
		)  
        )
   )
) 

;;input: paragraph and letter
;;output: occurrences of a letter in a paragraph 
(define populatePar 
	(lambda (p letter)
		(cond 
			((null? p)
				'()
			)(else
				(map (lambda(w)(populateWord w letter))p)
			)
       		)
	)
)

;;input: word
;;output: occurrences of a letter in a word 
(define populateWord 
	(lambda (w letter)
		(cond 
			((null? w)
				'()
			)((eq? letter (car w))
				(cons (+ (ctv letter) 1) (populateWord (cdr w) letter)) 
         		)
        		(else 
	  			(cons 0 (populateWord (cdr w) letter)) 
         		)
       		)
	)
)


;;input: list and number
;;output: list with just the number and everything else 0
(define topNums 
    (lambda (m l)
		(cond 
			((null? l) 
				'()
			) 
			((= m (car l))
				(cons (car l) (topNums m (cdr l))) 
			)
			(else    
				(cons 0 (topNums m (cdr l)))
			)
		) 
    )
)


;;input: list holding values of correclyspeltwords
;;output: list containing the letters that have the correctlyspeltwords 
(define getLetterVals 
    (lambda (list i)
		(cond 
			((null? list) 
				'()
			) 
			((= 0 (car list))
				(getLetterVals(cdr list) (+ 1 i))
			)
			(else    
				(cons (vtc i) (getLetterVals(cdr list) (+ 1 i)))
			)
		) 
    )
)









;; -----------------------------------------------------
;; SPELL CHECKER FUNCTION

;;check a word's spell correctness
;;INPUT:a word(a global variable "dictionary" is included in the file "test-dictionary.ss", and can be used directly here)
;;OUTPUT:true(#t) or false(#f)

(define spell-checker 
  (lambda (w)
	(cond ((member w dictionary) #t)
	(else #f))
   )
)

;; -----------------------------------------------------
;; ENCODING FUNCTIONS

;;generate an Caesar Cipher single word encoders
;;INPUT:a number "n"
;;OUTPUT:a function, whose input=a word, output=encoded word



(define encode-n						;;encode word
  (lambda (n);;"n" is the distance, eg. n=3: a->d,b->e,...z->c
      (lambda (w);; returning"w" is the word to be encoded
	(map (lambda (x) (vtc (modulo (+ (ctv x) n) 26))) w)
      )    
   )
)

(define encode-d
  (lambda (d encoder)						;;encode document 
	(map (lambda (p) (encode-p p encoder)) d)
    )
)


    
;; -----------------------------------------------------
;; DECODE FUNCTION GENERATORS
;; 2 generators should be implemented, and each of them returns a decoder

;;generate a decoder using brute-force-version spell-checker
;;INPUT:an encoded paragraph "p"
;;OUTPUT:a decoder, whose input=a word, output=decoded word
(define Gen-Decoder-A
  (lambda (p)

	(let (
			(n (test p))
		)

			
		(lambda (w)
			(map (lambda (x) (vtc (modulo (+ (ctv x) n) 26))) w)	
		)
	)
  )
)



;;generate a decoder using frequency analysis
;;INPUT: an encoded paragraph “p”
;;OUTPUT:a decoder, whose input=a word, output=decoded word
(define Gen-Decoder-B
  (lambda (p)
		(let (
			(n (getNDecode p))
			)

				(lambda (w)	
					(map (lambda (x) (vtc (modulo (+ (ctv x) n) 26))) w)
				)
		)
  )
)

;; -----------------------------------------------------
;; CODE-BREAKER FUNCTION

;;a codebreaker
;;INPUT: an encoded document(of course by a Caesar's Cipher), a decoder(generated by functions above)
;;OUTPUT: a decoded document
(define Code-Breaker
  (lambda (d decoder)
    
	(map (lambda (p) (decode-p p decoder)) d)
     
   )
)

;; -----------------------------------------------------
;; EXAMPLE APPLICATIONS OF FUNCTIONS
;;(spell-checker '(h e l l o))
;;(define add5 (encode-n 5))
;;(encode-d document add5)



;;(define decoderSP1 (Gen-Decoder-A paragraph))
;;(define decoderFA1 (Gen-Decoder-B paragraph))
;;(Code-Breaker document decoderSP1)
