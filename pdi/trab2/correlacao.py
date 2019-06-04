import numpy as np
import cv2

#abre imagem em tons de cinza
img_in = cv2.imread("images/daith1.jpg",0)

#definicao do tipo da mascara
tipo = 1

#TIPO:
#0: mascara identidade
#1: filtro da media
#2: filtro da media ponderada
#3: borda horizontal
#4: borda vertical

if tipo == 0:
    mascara = np.array([[1,1,1],[1,1,1],[1,1,1]],dtype=np.uint8) #centro: [1][1]
elif tipo == 1:
    mascara = np.array([[1,1,1],[1,1,1],[1,1,1]],dtype=np.uint8) / 9 #centro: [1][1]
elif tipo == 2:
    mascara = np.array([[1,2,1],[2,4,2],[1,2,1]],dtype=np.uint8) #centro: [1][1]
elif tipo == 3:
    mascara = np.array([[-1,-1,-1],[0,0,0],[1,1,1]],dtype=np.uint8) #centro: [1][1]
elif tipo == 4:
    mascara = np.array([[-1,0,1],[-1,0,1],[-1,0,1]],dtype=np.uint8) #centro: [1][1]

#obter dimensoes da imagem
(altura,largura) = img_in.shape

#criar imagem de zeros
img = np.zeros((altura+2,largura+2), dtype=np.uint8)

#criar imagem com borda de pizza
img[1:altura+1,1:largura+1] = img_in

#TRANSLACOES
corr = np.zeros((altura,largura), dtype=np.uint8)
for i in range(3):
    for j in range(3):
        crop = img[i:altura+i,j:largura+j]
        corr = corr + crop * mascara[i][j]

#NORMALIZACAO
corr = corr.astype(np.uint8)

cv2.imshow("image in",img_in)
cv2.imshow("image out",corr)
cv2.waitKey(0)
cv2.destroyAllWindows()
