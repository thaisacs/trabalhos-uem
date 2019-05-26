import numpy as np
from library import config

def generateWave(frequency = 0, time = 0.25):
    print(time)
    return [np.sin(2 * np.pi * frequency * x / config.sampling_rate)
                for x in range(int(config.num_samples*time))]
