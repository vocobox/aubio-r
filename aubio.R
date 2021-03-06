#------------------------------------------------------------------------------
# ----------------------------   AUBIO API  -----------------------------------
#------------------------------------------------------------------------------
#
# aubioonset : onset detection
# aubiopitch : pitch detection
# aubiocut   : audio to midi / cut file into multiple onsets 
# aubionotes : audio to midi
# aubiomfcc  : mel spectrum coefficients
# aubioquiet : extract quit and loud regions
# aubiotrack : extract beats from audio signal

note.C0 = 16.35
note.A0 = 27.50
note.C4 = 261.63
note.A4 = 440.00
note.A5 = 880
note.C8 = 4186.0
note.B8 = 7902

trace = FALSE

#------------------------------------------------------------------------------
# AUBIO PITCH
#
# -i      --input            input file
# -o      --output           output file
# -r      --samplerate       select samplerate
# -B      --bufsize          set buffer size
# -H      --hopsize          set hopsize
# -p      --pitch            select pitch detection algorithm
# -u      --pitch-unit       select pitch output unit
# -l      --pitch-tolerance  select pitch tolerance
# -s      --silence          select silence threshold
# -m      --mix-input        mix input signal with output signal
# -f      --force-overwrite  overwrite output file if needed
# -j      --jack             use Jack
# -v      --verbose          be verbose
# -h      --help             display this message

aubio.pitch.p = c('default', 'schmitt', 'fcomb', 'mcomb', 'specacf', 'yinfft')

aubiopitch <- function(file, args){
  cmd = paste("aubiopitch", args, inout(file))
  if(trace)
    print(cmd)
  pitch = cmdRun(cmd, out(file))
  names(pitch)[1] = "time"
  names(pitch)[2] = "frequency"
  return(pitch)  
}


#------------------------------------------------------------------------------
## AUBIO ONSET
#
# -i      --input            input file
# -o      --output           output file
# -r      --samplerate       select samplerate
# -B      --bufsize          set buffer size
# -H      --hopsize          set hopsize
# -O      --onset            select onset detection algorithm
# -t      --onset-threshold  set onset detection threshold
# -s      --silence          select silence threshold
# -m      --mix-input        mix input signal with output signal
# -f      --force-overwrite  overwrite output file if needed
# -j      --jack             use Jack
# -v      --verbose          be verbose
# -h      --help             display this message

aubio.onset.O = c('default', 'energy', 'hfc', 'complex', 'phase', 'specdiff', 'kl', 'mkl', 'specflux')

aubioonset <- function(file, args){
  cmd = paste("aubioonset", args, inout(file))
  if(trace)
    print(cmd)
  onsets <- cmdRun(cmd, out(file))
  return(onsets)  
}

#------------------------------------------------------------------------------
# AUBIO MFCC : Mel Spectrum Coefficients

aubiomfcc <- function(file, args){
  cmd = paste("aubiomfcc", args, inout(file))
  if(trace)
    print(cmd)
  onsets <- cmdRun(cmd, out(file))
  return(onsets)  
}

#------------------------------------------------------------------------------
# AUBIO CUT : WAV to midi

aubiocut <- function(file, args){
  cmd = paste("aubiocut", args, inout(file))
  if(trace)
    print(cmd)
  onsets <- cmdRun(cmd, out(file))
  return(onsets)  
}

#------------------------------------------------------------------------------
# AUBIO NOTES : WAV to midi

aubionotes <- function(file, args){
  cmd = paste("aubionotes", args, inout(file))
  if(trace)
    print(cmd)
  onsets <- cmdRun(cmd, out(file))
  return(onsets)  
}


#------------------------------------------------------------------------------
# AUBIO QUIET : Detects quiet and loud regions 

aubioquiet <- function(file, args){
  cmd = paste("aubioquiet", args, inout(file))
  if(trace)
    print(cmd)
  onsets <- cmdRun(cmd, out(file))
  return(onsets)  
}


#------------------------------------------------------------------------------
# AUBIO TRACK : Beat detection

aubiotrack <- function(file, args){
  cmd = paste("aubiotrack", args, inout(file))
  if(trace)
    print(cmd)
  onsets <- cmdRun(cmd, out(file))
  return(onsets)  
}

#------------------------------------------------------------------------------
# FILTER UTILS

filterTimeRange <- function(pitch, timeRange){
  outOfRange <- (pitch[,1] < timeRange[1]) | (pitch[,1] > timeRange[2])
  return(pitch[!outOfRange,])
}

# Replace pitch events by NaN if they're standing out of frequency range
filterFreqRange <- function(pitch, freqRangeHz){
  pitchFilter = pitch
  pitchFilter[pitch$frequency < freqRangeHz[1], 2] = NaN
  pitchFilter[pitch$frequency > freqRangeHz[2], 2] = NaN
  return(pitchFilter)
}

#------------------------------------------------------------------------------
# RUN SYSTEM COMMANDS

cmdRun <- function(cmd, out){
  system(cmd)
  aubioOut <- read.table(out)
  return(aubioOut)
}

inout <- function(file){
  return(paste("-i", file, ">",  out(file)))
}

out <- function(file){
  return(paste(file, ".txt", sep=''))
}
