#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri May 17 17:36:24 2019

@authors: raul 
          thais
"""

import numpy as np
import cv2
from scipy.spatial import distance

img_name = 'images/daith2.jpg'
n = 16 
mode = 2
# 1: Uniform
# 2: Median Cut

def readRGB(name):
    bgr_img = cv2.imread(name)
    b,g,r = cv2.split(bgr_img)
    return cv2.merge([r,g,b])

def showRGB(label, img):
    r,g,b = cv2.split(img)
    cv2.imshow(label, cv2.merge([b,g,r]))

def writeRGB(name, img):
    r,g,b = cv2.split(img)
    cv2.imwrite(name, cv2.merge([b,g,r]))

#### UNIFORM ####

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
        distances = abs(colors - i)
        min_dist = distances.min()
        index_dist, = np.where(distances == min_dist)
        LUT[i] = colors[index_dist[0]]

    return LUT

def uniform(img_in, n):
    x,y,z = splitCube(n)
    r,g,b = cv2.split(img_in)
    
    r[:] = (createLUT(x))[r[:]]
    g[:] = (createLUT(y))[g[:]]
    b[:] = (createLUT(z))[b[:]]

    return cv2.merge([r,g,b])

#### MEDIAN CUT ####

def calculateRange(bucket, band):
    color_max = 0
    color_min = 255 
    
    if(band == 'r'):
        for i in bucket:
            if i['r'] < color_min:
                color_min = i['r']
            if i['r'] > color_max:
                color_max = i['r']
    elif(band == 'g'):
        for i in bucket:
            if i['g'] < color_min:
                color_min = i['g']
            if i['g'] > color_max:
                color_max = i['g']
    else:
        for i in bucket:
            if i['b'] < color_min:
                color_min = i['b']
            if i['b'] > color_max:
                color_max = i['b']
    
    return color_max - color_min

def createBucket(r, g, b):
    Bucket = []
    
    for i in range(0, len(r)):
        for j in range(0, len(r[i])):
            Bucket.append({'r': r[i][j], 'g': g[i][j], 'b': b[i][j]})
    
    return Bucket

def applyColors(img_in, Colors):
    r,g,b = cv2.split(img_in)
   
    new_r = np.zeros(len(r))
    new_g = np.zeros(len(g))
    new_b = np.zeros(len(b))

    for i in range(0, len(r)):
        for j in range(0, len(r[i])):
            Distance = np.zeros(len(Colors))
            for k in range(0, len(Colors)):
                pixel = ((r[i][j], g[i][j], b[i][j]))
                color = ((Colors[k]['r'], Colors[k]['g'], Colors[k]['b']))
                Distance[k] = distance.euclidean(pixel, color)
            Min = Distance.min()
            k, = np.where(Distance == Min)
            r[i][j] = Colors[k[0]]['r']
            g[i][j] = Colors[k[0]]['g']
            b[i][j] = Colors[k[0]]['b']

    return cv2.merge([r,g,b])

def cut(buckets):
    new_buckets = []

    for bucket in buckets:
        rRange = calculateRange(bucket, 'r')
        gRange = calculateRange(bucket, 'g')
        bRange = calculateRange(bucket, 'b')
        
        B1 = []
        B2 = []

        if(rRange > gRange and rRange > bRange):
            bucket = sorted(bucket, key = lambda i: i['r'])
        elif(gRange > rRange and gRange > bRange):
            bucket = sorted(bucket, key = lambda i: i['g'])
        else:
            bucket = sorted(bucket, key = lambda i: i['b'])
        
        for i in range(0, len(bucket)):
            if i < len(bucket)/2:
                B1.append(bucket[i])
            else:
                B2.append(bucket[i])

        new_buckets.append(B1)
        new_buckets.append(B2)

    return new_buckets

def medianCut(img_in, n):
    r,g,b = cv2.split(img_in)
    
    buckets = []
    buckets.append(createBucket(r, g, b))
    
    i = 1
    while i < n:
        buckets = cut(buckets)
        i = 2*i
    
    colors = []

    for bucket in buckets:
        rB = []
        gB = []
        bB = []
        
        for i in bucket:
            rB.append(i['r'])
            gB.append(i['g'])
            bB.append(i['b'])
        
        colors.append({'r': int(np.mean(rB)), 'g': int(np.mean(gB)), 'b': int(np.mean(bB))})
    
    return applyColors(img_in, colors)

def main():
    img_in = readRGB(img_name)
    
    if(mode == 1):
        img_out = uniform(img_in, n);
    else:
        img_out = medianCut(img_in, n);
    
    writeRGB('out.jpg', img_out)

main()
