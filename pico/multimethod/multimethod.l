#{

  TODO:

  * Dispatch on basic data types
    * e.g. atom pair num sym etc.,
    * e.g. (dmu collide< ((A +Asteroid) (B pair)) …)
  * Dispatch on value
    * e.g. (dmu collide< ((A +Asteroid) (B (= "Bill"))) …).
  * Add 'before 'after and 'around methods as in CLOS
    * next implemented -> 'mm-next
  * Undefine methods
    * also remove from cache

  Note, it is not possible to add a dispatch on any user defined-predicate
  since the dispatch table could not be sorted automatically.

}#

(symbols 'multimethod 'pico)

(local) (subclass?)
(de subclass? (X Y)
  (if (pair Y)
      (loop
        (NIL Y T)
        (NIL (subclass? X (pop 'Y))) )
      (let Q (if (pair X) X (val X)) # dfs
        (use H
            (loop
              (NIL Q)
              (setq H (pop 'Q))
              (T (= H Y) T)
              (for HH (val H)
                (push 'Q HH) ) ) ) ) ) )

(local) (mm-applicable)
(de mm-applicable (K M)
  (use (KK MM)
    (loop
        (NIL
          (or K M)
          T)
        (setq
          KK (pop 'K)
          MM (pop 'M))
        (NIL
          (or (not MM) (= KK MM) (subclass? KK MM))
          NIL) ) ) )

(local) (mm-apply mm-cache)
(de mm-apply @
  # optimize applicable method building by caching lookups
  (let ("N" (next)
        "A" (rest)
        "K" (mapcar type "A")
        "Mm" (cache 'mm-cache "K"
              (filter
                '((M) (mm-applicable "K" (car M)))
                (get "N" 'mm)) ))
    (ifn "Mm"
      (quit 'mm (list "No applicable method" "N" "A" "K"))
      (let
        mm-next
          '(()
            (ifn (cdr (pop '"Mm"))
              (quit 'mm (list "No other method" "N" "A" "K"))
              (apply @ "A") ) )
        (apply (cdr (pop '"Mm")) "A") ) ) ) )

(local) (mm-def)
(de mm-def (N P)
  (let L (get N 'mm)
    (ifn L
      (put N 'mm (list P))
      (use X
        (loop
          (NIL L (put N 'mm (mm-sort (cons P (get N 'mm)))))
          (setq X (pop 'L))
          (T (= (car P) (car X)) (con X (cdr P))) ) ) ) ) )

(local) (dmu)
(de dmu A
  (let (N (car A) AA (cadr A) B (cddr A))
    (unless (val N)
      (def N (fill '(@ (pass mm-apply 'N)) 'N)) ) # bug shared!?
    (mm-def N
      (cons
        (mapcar
          '((X) (when (pair X) (cdr X)))
          AA)
        (cons
          (mapcar
            '((X) (if (pair X) (car X) X))
            AA)
          B) ) ) ) )

(local) (mm-lt)
(de mm-lt (L R)
  (use (LH RH)
    (loop
      (NIL (or L R))
      (setq LH (pop 'L) RH (pop 'R))
      (T (and (not LH) RH) NIL)
      (T
      (when LH
          (or (not RH) (and (<> LH RH) (subclass? LH RH))) )
      T ) ) ) )

(local) (mm-sort)
(de mm-sort (L)
  (mm-order L
    '((L R) (mm-lt (car L) (car R)))) )

(local) (mm-order)
(de mm-order (Lst Lt) # TODO built-in or better sort log(N) instead of N^2
  (let Q NIL
    (for X Lst
      (let S 0
        (for Y Lst
          (when (apply Lt NIL (car X) (car Y))
            (inc 'S) ) )
        (push 'Q (cons S X))) )
  (flip
    (mapcar cdr (by car sort Q))) ) )
