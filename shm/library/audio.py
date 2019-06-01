import numpy as np
from library import config

def generate_wave(frequency, time = 0.25):
    samples_num = int(time * config.sampling_rate)
    config.nframes += samples_num
    return [np.sin(2 * np.pi * frequency * x / config.sampling_rate)
                for x in range(samples_num)]
