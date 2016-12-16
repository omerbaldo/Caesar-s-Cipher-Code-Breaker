# Caesar-s-Cipher-Code-Breaker
Fun project where I got to break Caesars Cipher using two different algorithms.

Algorithm A: brute force code breaker 
The encode input words are encoded for each possible value of n. For each value, a spell
checker determines whether the resulting words are words in the English
language. The value of n 0 for which most words are spelled correctly is
assumed to be decoding value.


Frequency Analysis Gen-Decoder-B

In english, some letteres occur more than others. Knowing the distribution of the different
letters, this method just counts the number of occurrences of each letter in the encoded words. If there are enough words to be statistically relevant, the letter distribution can be used to identify the most common letters in
English, namely ’e’, ’t’, and ’a’. 


To Run:

Download mz scheme
Run mz scheme in main directory 

Type in these commands to test gen-decoder-a:

(load "decode.ss")
(define paragraph '((a a f f f)(c z  z)(j t)(b)))
(define document '(((a a f f f)(c z  z)(j t)(b))))
(define decoderSP1 (Gen-Decoder-A paragraph))
(Code-Breaker document decoderSP1)

Type in these commands to test gen-decoder-b:

(define document '(((a a f f f)(c z  z)(j t)(b))))

(define paragraph '((a a f f f)(c z  z)(j t)(b)))

(define decoderFA1 (Gen-Decoder-B paragraph))
(Code-Breaker document decoderFA1 )
