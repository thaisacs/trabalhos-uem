import cv2

def readSG(name): # read shades of gray image
    return cv2.imread(name, 0)

def readRGB(name):
    bgr_img = cv2.imread(name)
    b, g, r = cv2.split(bgr_img)
    return cv2.merge([r,g,b])

def show(label, img):
    cv2.imshow(label, img)