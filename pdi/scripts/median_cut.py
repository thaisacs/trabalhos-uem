#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat May 18 14:40:47 2019

@author: thais
"""

import cv2
import numpy as np

img_in = cv2.imread('cameraman.tif',0)
img_out = img_in.copy()
n = 10

colors = np.array(img_out.copy())

def medianCut(n, img):
    for i in range(0, len(colors)):
        print(i)
    #    n_colors[i].(np.split(element[i], 2))
    #    n_colors[i+1].(np.split(element[i], 2))
    #colors = n_colors

medianCut(n, img_out)

cv2.imshow('image in',img_in)
cv2.imshow('image out',img_out)
cv2.waitKey(0)
cv2.destroyAllWindows()
