(symbols 'multimethod 'pico)

#{

  Several ways to delegate:
  - Build after all methods defined
  - Build as methods are defined

  Can make macro to generate constructor and forward methods
  -> composite definition

  Entry: key cls fmt excl

  * Implement fmt

  Bug with del>
  -> need to get symbol from same namespace
  
}#

(de intern-delegate (Nm Fmt Key)
  (if Fmt # intern in current namespace
      (intern
        (let (C (chop Nm)
              ?? (index '? C))
          (pack
            (head (if ?? -2 -1) C)
            "-"
            (name Key)
            (if ?? "?>" ">")))
        T)
      (intern Nm T)))

(de delegate (List)
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
              (let (Sym (intern (name (car Meth)) T) #(car Meth)
                    Nm (name Sym))
                # quit on *sym* conflict (not just name)
                (when (idx 'I Sym)
                  (quit
                    (text
                      "dg: @1 @2 -- method already exists on class @3 property key @4"
                      (sym Nm)
                      (sym Cls)
                      (sym *Class)
                      (sym Key))))
                (idx 'I Sym T)
                (let (@dg (intern-delegate Nm Fmt Key)
                      @arg '@
                      @qsym (cons 'quote Sym)
                      @key Key)
                  (link # build, link dm form
                    (fill
                      '(dm @dg @arg
                        (pass @qsym (: @key))))))))))))
    #(pretty @)
    (run @)))


