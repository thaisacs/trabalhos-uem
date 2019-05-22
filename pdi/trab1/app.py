#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri May 17 17:36:24 2019

@author: thais
"""

import numpy as np
import cv2

imgName = 'images/strawberries_fullcolor.tif'
n = 50
mode = 2
# 1: Uniform
# 2: Median Cut

def readSG(name): # read shades of gray image
    return cv2.imread(name, 0)

def readRGB(name):
    bgr_img = cv2.imread(name)
    b,g,r = cv2.split(bgr_img)
    return cv2.merge([r,g,b])

def show(label, img):
    cv2.imshow(label, img)
    
def showRGB(label, img):
    r,g,b = cv2.split(img)
    cv2.imshow(label, cv2.merge([b,g,r]))
    
def splitCube(n):
    return 4,3,2

def createLUT(n):
    colors = np.linspace(0, 255, n, dtype=np.int)
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

def calculateContrast(band):
    min = band.min()
    max = band.max()
    return max - min

def cutting(br, bg, bb):
    print(br)
    print(bg)
    print(bb)

def medianCut(img_in, n):
    r,g,b = cv2.split(img_in)
    
    br = np.array(r)
    bg = np.array(g)
    bb = np.array(b)
    
    cutting(br, bg, bb)
    
    return img_in

def main():
    img_in = readRGB(imgName)
    img = img_in.copy()
    
    if(mode == 1):
        img_out = uniform(img, n);
    else:
        img_out = medianCut(img, n);
    
    showRGB('image in', img_in)
    showRGB('image out', img_out)
    
    cv2.waitKey(0)
    cv2.destroyAllWindows()

main()