import struct
import wave
from library import config

def readTextFile(FileName):
    Text = ""
    File = open(FileName, "r")
    if(File.mode == 'r'):
        Text = File.read()
    File.close()
    return Text

def writeMorseFile(FileName, Code):
    File = open(FileName, "w+")
    File.write(Code)

def writeAudioFile(FileName, sine_wave):
    with wave.open(FileName, 'w') as wave_file:
        wave_file.setparams((
            config.nchannels, config.sampwidth, config.sampling_rate, config.nframes,
            config.comptype, config.compname))

        for s in sine_wave:
            wave_file.writeframes(struct.pack('h', int(s * config.amplitude)))
