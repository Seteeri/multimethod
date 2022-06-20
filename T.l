(chdir "pico/multimethod"
  (load 
    "multimethod.l"
    "delegate.l"))

# export doesn't seem to work...
# import into current namespace (assumes this file loaded in pico)
(import multimethod~dmu)
(import multimethod~dg)
