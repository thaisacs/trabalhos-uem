import numpy as np
from library import config

def generateWave(frequency):
    return [np.sin(2 * np.pi * frequency * t / config.sampling_rate) 
            for t in range(config.num_samples)]
