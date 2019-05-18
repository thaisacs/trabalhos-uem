#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri May 17 17:36:24 2019

@author: thais
"""

from library import images
from library import algorithms

imgName = 'images/strawberries_fullcolor.tif'
n = 50
mode = 1
# 1: Uniform
# 2: Median Cut

def main():
    img_in = images.readRGB(imgName)
    
    if(mode == 1):
        img_out = uniform(img_in, n);
    else:
        img_out = medianCut(img_in, n);
    
    images.showRGB('image in', img_in)
    images.showRGB('image out', img_out)
    
    #cv2.waitKey(0)
    #cv2.destroyAllWindows()

main()
