(class +Asteroid)
(class +Spaceship)

(setq A (new '(+Asteroid)))
(setq S (new '(+Spaceship)))

(dmu collide< (X Y)
   (prin "?? Bang, what happened? ")
   (println X Y) )

(dmu collide< ((X +Asteroid) (Y +Asteroid))
   (prin "AA Look at the beautiful fireworks! ")
   (println X Y) )

(dmu collide< ((X +Asteroid) (Y +Spaceship))
   (prin "AS Is it fatal? ")
   (println X Y) )

(dmu collide< ((X +Spaceship) (Y +Asteroid))
   (prin "SA Is it fatal? ")
   (println X Y) )

(dmu collide< ((X +Spaceship) (Y +Spaceship))
   (prin "SS Who's fault was it? ")
   (println X Y) )

(collide< A A) # AA Look at the beautiful fireworks! $519672026 $519672026
(collide< A S) # AS Is it fatal? $519672026 $519672040
(collide< S A) # SA Is it fatal? $519672040 $519672026
(collide< S S) # SS Who's fault was it? $519672040 $519672040
(collide< A 1) # ?? Bang, what happened? $519672026 1
(collide< 2 A) # ?? Bang, what happened? 2 $519672026
(collide< S 3) # ?? Bang, what happened? $519672040 3
(collide< 4 S) # ?? Bang, what happened? 4 $519672040
(collide< 5 T) # ?? Bang, what happened? 5 T
(collide< T)   # ?? Bang, what happened? T NIL
(collide<)     # ?? Bang, what happened? NIL NIL

# …or try the bank account example from PAIP:

(class +Acc)                        # account
(class +LtdAcc +Acc)                # account with withdrawal limit

(dmu withdraw< ((A +Acc) Amt)
   (with A
      (if (< (: bal) Amt)
         'insufficient-funds
         (dec (:: bal) Amt) ) ) )

(dmu withdraw< ((A +LtdAcc) Amt)
   (with A
      (if (< (: lim) Amt)
         'over-limit
         (mmNext) ) ) )

(setq F (new '(+Acc) 'nm "Fred" 'bal 5000 'irt 6))
(setq G (new '(+LtdAcc) 'nm "George" 'bal 4000 'irt 5 'lim 1000))

(withdraw< F 6000) # -> insufficient-funds
(withdraw< F 1000) # -> 4000
(withdraw< G 2000) # -> over-limit
(withdraw< G 200)  # -> 3800
