from library import config
import struct
import wave
import numpy as np

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

def writeTextFile(FileName, Text):
    File = open(FileName, "w+")
    File.write(Text)

def writeAudioFile(FileName, sine_wave):
    with wave.open(FileName, 'w') as wave_file:
        wave_file.setparams((
            config.nchannels, config.sampwidth, config.sampling_rate, config.nframes,
            config.comptype, config.compname))

        for s in sine_wave:
            wave_file.writeframes(struct.pack('h', int(s * config.amplitude)))

def openAudioFile(FileName):
    with wave.open(FileName) as wave_file:
        data = wave_file.readframes(config.nframes)
        data = struct.unpack('{n}h'.format(n=config.nframes), data)
    return np.array(data)
