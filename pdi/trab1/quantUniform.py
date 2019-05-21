#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue May 21 18:02:20 2019

@author: ramires
"""

import cv2
import numpy as np

img = cv2.imread("images/strawberries_fullcolor.tif")

imgIn = img.copy()

def distance(x, y):
    soma = 0
    for i in range(3):
        soma += (x[i] - y[i]) ** 2
    return np.sqrt(soma)




cv2.imshow('image in',imgIn)
cv2.imshow('image',img)
cv2.waitKey(0)
cv2.destroyAllWindows()