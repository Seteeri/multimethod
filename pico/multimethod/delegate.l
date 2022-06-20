(symbols 'multimethod 'pico)

#{

  Several ways to delegate:
  - Build after all methods defined
  - Build as methods are defined

  Can make macro to generate constructor and forward methods
  -> composite definition

  Entry: key cls fmt excl

  * Implement fmt

}#

(de dg (List)
  (prog1
    (make
      (let I NIL
        (for Pair List # For each entry
          (let ((Key Cls Fmt Excl) Pair)
            (push 'Excl 'T) # skip constructor
            (for Meth
                  (filter # filter methods
                    '((X)
                      (not (member (car X) Excl)))
                    (val Cls))
              (let (Sym (car Meth)
                    Nm (name Sym))
                # quit on name conflict
                (when (idx 'I Sym)
                  (quit
                    (text
                      "dg: method conflict! key=@1 method=@2 classes=@3"
                      (sym Key)
                      (sym Nm)
                      (sym Cls))))
                (idx 'I Sym T)
                (let (@dg
                        (if Fmt
                            (intern
                              (let (C (chop Nm)
                                    ?? (index '? C))
                                (pack
                                  (head (if ?? -2 -1) C)
                                  "-"
                                  (name Key)
                                  (if ?? "?>" ">")))
                              T)
                            (intern Nm T))
                      @arg '@
                      @qsym (cons 'quote Sym)
                      @key Key)
                  (link # build, link dm form
                    (fill
                      '(dm @dg @arg
                        (pass @qsym (: @key))))))))))))
    #(pretty @)
    (run @)))


