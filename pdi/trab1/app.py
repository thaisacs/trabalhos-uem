#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri May 17 17:36:24 2019

@author: thais
"""

from library import images
import cv2

imgName = 'images/strawberries_fullcolor.tif'

def main():
    img = images.readRGB(imgName)
    images.show('img in', img)
    
    cv2.waitKey(0)
    cv2.destroyAllWindows()

main()
