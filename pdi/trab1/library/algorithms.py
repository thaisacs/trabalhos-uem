import numpy as np
import cv2

def splitCube(n):
    return 5,5,5

def createLUT(n):
    colors = (np.linspace(0, 255, n, dtype=np.int))
    LUT = np.zeros(256)

    for i in range(0, 256):
        a = abs(colors - i)
        m = a.min()
        k, = np.where(a == m)
        LUT[i] = colors[k[0]]

    return LUT

def uniform(img_in, n):
    x,y,z = splitCube(n)
    r,g,b = cv2.split(img_in)
    r[:] = (createLUT(x))[r[:]]
    g[:] = (createLUT(y))[g[:]]
    b[:] = (createLUT(z))[b[:]]
    return cv2.merge([r,g,b])

def medianCut(img_in, n):
    return img_in