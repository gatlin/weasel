; weasel program
; (c) 2010 Gatlin Johnson <rokenrol@gmail.com>
; This program is licensed under the WTFPL license, in the public domain
; http://sam.zoy.org/wtfpl/

; create a list of acceptable characters
(setf alphabet (list "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z" " "))
; if you want to test against the canonical "weasel" string, here it is for convenience
(setf weasel "METHINKS IT IS LIKE A WEASEL")

; select-char : selects a character from a list, zero-indexed
(defun select-char (l n) ; l = the list, n = the index
    (if (= n 0)
        (first l)
    ; else
        (select-char (rest l) (- n 1))))

; random-char : selects a random index from a list
(defun random-char (l s) ; l = the list, s = size
    (select-char l (random s)))

; build-sentence : builds a string of random characters length n from a list l of characters, of size s
(defun build-sentence (l s n) ; l = the list, s = size of the list (zero-indexed), n = length of target string
    (build-sentence-helper l s n ""))

(defun build-sentence-helper (l s n w) ; w = the string we are producing
    (if (= n 1)
        (concatenate 'string w (random-char l s))
    ; else
        (build-sentence-helper l s (- n 1) (concatenate 'string w (random-char l s)))))


; now, we can build a string of random characters from a defined alphabet
; for our purposes it will be called as (build-sentence alphabet 27 28), but there's no reason not to be flexible
(defun score (target shot) ; target = the string we want shot to be, shot = the string we hope is like target
    (score-helper target shot (- (length target) 1) 0))

(defun score-helper (target shot n s) ; n = index to compare, s = running score
    (if (or (< n 0) (string= shot NIL))
        s
    ; else
        (score-helper target shot (- n 1) (+ s (if (string= (char target n) (char shot n)) 1 0)))))

; copies a string with a 5% chance per character of that character being replaced
; cp-nd is "copy non-deterministic" ; we go through each character and either return it (95%) or pick a random character (5%)
(defun cp-nd (s percent) ; s = the string we want to possibly copy with errors
    (reverse (cp-nd-helper s (- (length s) 1) percent "")))

(defun cp-nd-helper (s n percent r) ; n = the index to possibly copy, r = the string we're building
    (if (< n 0)
        r
    ; else
        (cp-nd-helper s (- n 1) percent (concatenate 'string r (if (< (random 100) percent) (random-char alphabet (length alphabet)) (string (char s n)))))))

; generate a list of size l consisting of cp-nds of a string s
(defun mutate-list (s n p) ; s = string, n = number of items, p = percent
    (mutate-list-helper s (- n 1) p nil))

(defun mutate-list-helper (s n p l) ; l = the list we're building
    (if (< n 0)
        l
    ; else
        (mutate-list-helper s (- n 1) p (cons (cp-nd s p) l))))

; highest-score : given a target and a list of candidates, returns the candidate with the highest score
(defun highest-score (target shotlist) ; target = the string we will be comparing to, shotlist = the list of 100 mutants
    (highest-score-helper target shotlist NIL))

(defun highest-score-helper (target shotlist sofar) ; sofar = winner so far
    (if (equal (rest shotlist) NIL)
        (if (string= sofar NIL)
            (build-sentence alphabet (length alphabet) (length target))
            sofar)
    ; else
        (highest-score-helper target (rest shotlist) (if (< (score target sofar) (score target (first shotlist))) 
                                                         (first shotlist) sofar))))

; evolve : given a target string as the definition as success, this function attempts to breed successful sentences
(defun evolve (target) ; target = the sentence we want to evolve
    (evolve-helper target (build-sentence alphabet (length alphabet) (length target))))

(defun evolve-helper (target shot) ; shot = the string we want to compare
    (if (string= target shot)
        shot
    ; else
        (progn 
            (print (format nil "trying: ~S" shot)) 
            (evolve-helper target (highest-score target (mutate-list shot 100 5))))))
