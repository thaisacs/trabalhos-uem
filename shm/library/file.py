from library import config
import struct
import wave
import numpy as np

def read_input_file(file_name):
    text = ""
    file_in = open(file_name, "r")
    if(file_in.mode == 'r'):
        text = file_in.read()
    else:
        sys.exit(0)
    file_in.close()
    return text

def write_output_file(file_name, code):
    file_out = open(file_name, "w+")
    file_out.write(code)

def write_audio_file(file_name, sine_wave):
    with wave.open(file_name, 'w') as wave_file:
        wave_file.setparams((
            config.nchannels, config.sampwidth, config.sampling_rate, config.nframes,
            config.comptype, config.compname))

        for s in sine_wave:
            wave_file.writeframes(struct.pack('h', int(s * config.amplitude)))

def read_audio_file(file_name):
    file_wave = wave.open(file_name)
    with wave.open(file_name) as wave_file:
        data = wave_file.readframes(file_wave.getnframes())
        data = struct.unpack('{n}h'.format(n=file_wave.getnframes()), data)
    return np.array(data)

