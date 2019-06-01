import cv2
import numpy as np

img = cv2.imread('cameraman.tif',0)

img_in = img.copy()

n = 2 

colors = np.linspace(0,255,n)

print(colors)

for i in range(0,len(img)):
    for j in range(0,len(img[i])):
        a = abs(colors - img[i][j])
        m = a.min()
        k, = np.where(a == m) 
        img[i][j] = colors[k]

cv2.imshow('image in',img_in)
cv2.imshow('image',img)
cv2.waitKey(0)
cv2.destroyAllWindows()
