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
import matplotlib.pyplot as plt
from operator import itemgetter
import sys

img_name = 'images/daith2.jpg'
n = 128 
mode = 2
# 1: Uniform
# 2: Median Cut

def read_rgb(name):
    bgr_img = cv2.imread(name)
    b,g,r = cv2.split(bgr_img)
    return cv2.merge([r,g,b])

def show_rgb(label, img):
    r,g,b = cv2.split(img)
    cv2.imshow(label, cv2.merge([b,g,r]))

def write_rgb(name, img):
    r,g,b = cv2.split(img)
    cv2.imwrite(name, cv2.merge([b,g,r]))

#### UNIFORM ####

def split_cube(n):
    divisor = 2
    fatores = []
    while(n != 1):
        if(n % divisor == 0):
            fatores.append(divisor)
            n = n / divisor
        else:
            divisor += 1

    #insere 1 nos fatores caso nao tenha 3 fatores
    while(len(fatores) < 3):
        fatores.append(1)
    
    while(len(fatores) > 3):
        min1 = min(fatores)
        fatores.remove(min1)
        min2 = min(fatores)
        fatores.remove(min2)
        novoMin = min1 * min2
        fatores.append(novoMin)

    return fatores[0], fatores[1], fatores[2]

def create_LUT(n):
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

def calculate_range(bucket, band):
    values = np.zeros(len(bucket), dtype=np.uint8)
    
    if(band == 'r'):
        for i in range(0, len(values)):
            values[i] = bucket[i][0]
    elif(band == 'g'):
        for i in range(0, len(values)):
            values[i] = bucket[i][1]
    else:
        for i in range(0, len(values)):
            values[i] = bucket[i][2]
    
    return np.max(values) - np.min(values)

def create_bucket(r, g, b):
    bucket = np.zeros([len(r)*len(r[0]), 3], dtype=np.uint8) 
    
    index = 0

    for i in range(0, len(r)):
        for j in range(0, len(r[i])):
            bucket[index][0] = r[i][j]
            bucket[index][1] = g[i][j]
            bucket[index][2] = b[i][j]
            index += 1
    
    return bucket

def apply_colors(img_in, colors):
    r,g,b = cv2.split(img_in)
   
    for i in range(0, len(r)):
        for j in range(0, len(r[i])):
            index_dis = 0
            distances = np.zeros(len(colors))
            pixel = np.array([r[i][j], g[i][j], b[i][j]])
            for color in colors:
                distances[index_dis] = distance.euclidean(pixel, color)
                index_dis += 1
            dist_min = np.min(distances)
            k, = np.where(distances == dist_min)
            r[i][j] = colors[k[0]][0]
            g[i][j] = colors[k[0]][1]
            b[i][j] = colors[k[0]][2]
    
    return cv2.merge([r,g,b])

def cut(buckets):
    new_buckets = []

    for bucket in buckets:
        r_range = calculate_range(bucket, 'r')
        g_range = calculate_range(bucket, 'g')
        b_range = calculate_range(bucket, 'b')
        
        if(r_range > g_range and r_range > b_range):
            bucket = sorted(bucket, key=itemgetter(0))
        elif(g_range > r_range and g_range > b_range):
            bucket = sorted(bucket, key=itemgetter(1))
        else:
            bucket = sorted(bucket, key=itemgetter(2))

        bucket_one = np.zeros([len(bucket)//2, 3])
        bucket_two = np.zeros([len(bucket)-len(bucket_one), 3])
        
        index_one = 0
        index_two = 0
        
        for i in range(0, len(bucket)):
            if i < len(bucket)//2:
                bucket_one[index_one][0] = bucket[i][0]
                bucket_one[index_one][1] = bucket[i][1]
                bucket_one[index_one][2] = bucket[i][2]
                index_one += 1
            else:
                bucket_two[index_two][0] = bucket[i][0]
                bucket_two[index_two][1] = bucket[i][1]
                bucket_two[index_two][2] = bucket[i][2]
                index_two += 1

        new_buckets.append(bucket_one)
        new_buckets.append(bucket_two)


    return new_buckets

def median_cut(img_in, n):
    r,g,b = cv2.split(img_in)
    
    buckets = []
    buckets.append(create_bucket(r, g, b))
    
    i = 1
    while i < n:
        buckets = cut(buckets)
        i = 2*i
   
    colors = np.zeros([n, 3], dtype=np.uint8) 
    index_c = 0
    for bucket in buckets:
        rB = np.zeros(len(bucket), dtype=np.uint8) 
        gB = np.zeros(len(bucket), dtype=np.uint8) 
        bB = np.zeros(len(bucket), dtype=np.uint8) 
        
        for i in range(0,len(bucket)):
            rB[i] = bucket[i][0]
            gB[i] = bucket[i][1]
            bB[i] = bucket[i][2]
        
        colors[index_c][0] = np.mean(rB)
        colors[index_c][1] = np.mean(gB)
        colors[index_c][2] = np.mean(bB)
        index_c += 1
    
    print(colors)
    return apply_colors(img_in, colors)

def main():
    img_in = read_rgb(img_name)
    
    if(mode == 1):
        img_out = uniform(img_in, n);
    else:
        img_out = median_cut(img_in, n);
    
    write_rgb('out.jpg', img_out)

main()
