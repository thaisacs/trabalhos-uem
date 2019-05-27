#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri May 17 17:36:24 2019

@authors: raul 
          thais
"""

import numpy as np
import cv2

imgName = 'images/strawberries_fullcolor.tif'
n = 4 
mode = 1
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

#### UNIFORM QUANTIZATION ####

def splitCube(n):
    for i in range(n-1, 0, -1):
        for j in range(n-1, 0, -1):
            for k in range(n-1, 0, -1):
                if(i*j*k == n):
                    return i, j, k
    
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

def createLUTv2(colors):
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

#### MEDIAN CUT ####

def calculateRange(Bucket, Band):
    Max = 0
    Min = 10000
    
    if(Band == 'r'):
        for i in Bucket:
            if i['r'] < Min:
                Min = i['r']
            if i['r'] > Max:
                Max = i['r']
    elif(Band == 'g'):
        for i in Bucket:
            if i['g'] < Min:
                Min = i['g']
            if i['g'] > Max:
                Max = i['g']
    else:
        for i in Bucket:
            if i['b'] < Min:
                Min = i['b']
            if i['b'] > Max:
                Max = i['b']
    
    return Max - Min

def createBucket(r, g, b):
    Bucket = []
    
    for i in range(0, len(r)):
        for j in range(0, len(r[i])):
            Bucket.append({'r': r[i][j], 'g': g[i][j], 'b': b[i][j]})
    
    return Bucket

def cut(Buckets):
    NewBuckets = []

    for B in Buckets:
        rRange = calculateRange(B, 'r')
        gRange = calculateRange(B, 'g')
        bRange = calculateRange(B, 'b')
        
        B1 = []
        B2 = []

        if(rRange > gRange and rRange > bRange):
            B = sorted(B, key = lambda i: i['r'])
        elif(gRange > rRange and gRange > bRange):
            B = sorted(B, key = lambda i: i['g'])
        else:
            B = sorted(B, key = lambda i: i['b'])
        
        for i in range(0, len(B)):
            if i < len(B)/2:
                B1.append(B[i])
            else:
                B2.append(B[i])

        NewBuckets.append(B1)
        NewBuckets.append(B2)

    return NewBuckets

def medianCut(img_in, n):
    r,g,b = cv2.split(img_in)
    
    Buckets = []
    Buckets.append(createBucket(r, g, b))
    
    i = 1
    while i < n:
        Buckets = cut(Buckets)
        i = 2*i

    ResulR = []
    ResulG = []
    ResulB = []

    for B in Buckets:
        rB = []
        gB = []
        bB = []
        for i in B:
            rB.append(i['r'])
            gB.append(i['g'])
            bB.append(i['b'])
        ResulR.append(int(np.mean(rB)))
        ResulB.append(int(np.mean(gB)))
        ResulG.append(int(np.mean(rB)))

    ResulR = np.asarray(ResulR, dtype = np.int)
    ResulB = np.asarray(ResulB, dtype = np.int)
    ResulG = np.asarray(ResulG, dtype = np.int)

    r[:] = (createLUTv2(ResulR))[r[:]]
    g[:] = (createLUTv2(ResulG))[g[:]]
    b[:] = (createLUTv2(ResulB))[b[:]]
    
    #return img_in
    return cv2.merge([r,g,b])

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
