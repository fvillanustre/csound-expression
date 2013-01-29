module Main where

import Data.List(transpose)
import Csound

sinWave = gen 16384 10 [1]
osc :: Tab -> Sig -> Sig
osc tab phs = oscil 1 phs tab
    
rec :: Sig 
rec = osc sinWave rec

instr1 :: (D, D) -> SE [Sig]
instr1 (amp, phs) = do
    r1 <- rand 440
    r2 <- rand 440    
    out $ k r1 r2 * kr (osc sinWave (sig phs))
    where k r1 r2 = sig amp * ifB (notB $ ((1 :: Sig) <* 2) ||* ((1 :: Sig) >* 2)) r1 r2
          
          
instr2 :: (S, D, D) -> SE [Sig]
instr2 (fileName, amp, phs) = out $ ifB (a <* b) (sig amp) (sig phs)
    where (a, b) = soundin2 fileName


sco1 = line $ map temp [(1, 440), (0.5, 220), (1, 440)]            
sco2 = chord [    
    temp (str "boo.wav", 0, 1),
    temp (str "boo.wav", 1, 2)]
    
res :: Msg -> SE [Sig]
res msg = do
    b <- delayr 1
    tap <- deltap 0.5    
    delayw (q + 0.2 * tap)    

    b2 <- delayr 1
    tap2 <- deltap 0.5    
    delayw (q + 0.2 * tap2)        

    return [q + tap, q + tap2]
    where q = osc sinWave $ sig $ cpsmidi msg    


q = csd def mixing [sco instr2 sco2]

main :: IO ()
main = writeFile "tmp.csd" q