import numpy as np
import cv2

def splitCube(n):
    return 4,3,2

def createLUT(n):
    colors = (np.linspace(0, 255, n, dtype=np.int))
    dist = int(np.ceil(colors[1]/2))
    LUT = np.zeros(256)

    for i in range(1,n):
        k = colors[i] 
        LUT[k-dist:k+dist+1] = k

    LUT[colors[n-1]-dist:colors[n-1]+1] = colors[n-1]
    return LUT

def uniform(img_in, n):
    a,b,c = splitCube(n)
    r,g,b = cv2.split(img_in)
    r[:] = (createLUT(4))[r[:]]
    g[:] = (createLUT(3))[g[:]]
    b[:] = (createLUT(2))[b[:]]
    
    return cv2.merge([r,g,b])

def medianCut(img_in, n):
    return img_in