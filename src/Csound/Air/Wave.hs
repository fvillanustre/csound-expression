-- | Basic waveforms that are used most often. 
-- A waveform function takes in a time varied frequency (in Hz).
module Csound.Air.Wave (
	 -- * Bipolar
    osc, oscBy, saw, isaw, pulse, sqr, tri, blosc,

    -- * Unipolar
    unipolar, bipolar, on, uon, uosc, uoscBy, usaw, uisaw, upulse, usqr, utri, ublosc,

    -- * Noise
    rndh, urndh, rndi, urndi, white, pink,

    -- * Low frequency oscillators
    Lfo, lfo
) where

import Csound.Typed
import Csound.Typed.Opcode hiding (lfo)
import Csound.Tab(sine, sines4)

-- | A pure tone (sine wave).
osc :: Sig -> Sig
osc cps = oscil3 1 cps sine

-- | An oscillator with user provided waveform.
oscBy :: Tab -> Sig -> Sig
oscBy tb cps = oscil3 1 cps tb

-- unipolar waveforms

-- | Turns a bipolar sound (ranges from -1 to 1) to unipolar (ranges from 0 to 1)
unipolar :: Sig -> Sig
unipolar a = 0.5 + 0.5 * a

-- | Turns an unipolar sound (ranges from 0 to 1) to bipolar (ranges from -1 to 1)
bipolar :: Sig -> Sig
bipolar a = 2 * a - 1

-- | Unipolar pure tone.
uosc :: Sig -> Sig
uosc = unipolar . osc

-- | Unipolar 'Csound.Air.oscBy'.
uoscBy :: Tab -> Sig -> Sig
uoscBy tb = unipolar . oscBy tb

-- | Unipolar sawtooth.
usaw :: Sig -> Sig
usaw = unipolar . saw

-- | Unipolar integrated sawtooth.
uisaw :: Sig -> Sig
uisaw = unipolar . isaw

-- | Unipolar square wave.
usqr :: Sig -> Sig
usqr = unipolar . sqr

-- | Unipolar triangle wave.
utri :: Sig -> Sig
utri = unipolar . tri

-- | Unipolar pulse.
upulse :: Sig -> Sig
upulse = unipolar . pulse

-- | Unipolar band-limited oscillator.
ublosc :: Tab -> Sig -> Sig
ublosc tb = unipolar . blosc tb

-- rescaling

-- | Rescaling of the bipolar signal (-1, 1) -> (a, b)
-- 
-- > on a b biSig
on :: Sig -> Sig -> Sig -> Sig
on a b x = uon a b $ unipolar x 

-- | Rescaling of the unipolar signal (0, 1) -> (a, b)
-- 
-- > on a b uniSig
uon :: Sig -> Sig -> Sig -> Sig
uon a b x = a + (b - a) * x

--------------------------------------------------------------------------
-- noise

-- | Constant random signal. It updates random numbers with given frequency.
--
-- > constRnd freq 
rndh :: Sig -> SE Sig
rndh = randh 1

-- | Linear random signal. It updates random numbers with given frequency.
--
-- > rndi freq 
rndi :: Sig -> SE Sig
rndi = randi 1

-- | Unipolar @rndh@
urndh :: Sig -> SE Sig
urndh = fmap unipolar . rndh

-- | Unipolar @rndi@
urndi :: Sig -> SE Sig
urndi = fmap unipolar . rndi

-- | White noise.
white :: SE Sig 
white = noise 1 0

-- | Pink noise.
pink :: SE Sig
pink = pinkish 1

--------------------------------------------------------------------------
-- lfo

-- | Low frequency oscillator
type Lfo = Sig

-- | Low frequency oscillator
--
-- > lfo shape depth rate
lfo :: (Sig -> Sig) -> Sig -> Sig -> Sig
lfo shape depth rate = depth * shape rate


