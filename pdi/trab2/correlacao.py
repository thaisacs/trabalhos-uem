import numpy as np
import cv2

#abre imagem em tons de cinza
img_in = cv2.imread("images/abstrata.jpg",0)

#definicao do tipo da mascara
tipo = 0

#TIPO:
#0: mascara identidade
#1: filtro da media
#2: filtro da media ponderada
#3: borda horizontal
#4: borda vertical

#definicao do algoritmo
algoritmo = 1

#ALGORITMO
#0: correlacao por translacao
#1: correlacao por for i for j

if tipo == 0:
    mascara = np.array([[1,1,1],[1,1,1],[1,1,1]],dtype=np.uint8) #centro: [1][1]
elif tipo == 1:
    mascara = np.array([[1,1,1],[1,1,1],[1,1,1]],dtype=np.uint8) / 9 #centro: [1][1]
elif tipo == 2:
    mascara = np.array([[1,2,1],[2,4,2],[1,2,1]],dtype=np.uint8) / 16 #centro: [1][1]
elif tipo == 3:
    mascara = np.array([[-1,-1,-1],[0,0,0],[1,1,1]],dtype=np.uint8) #centro: [1][1]
elif tipo == 4:
    mascara = np.array([[-1,0,1],[-1,0,1],[-1,0,1]],dtype=np.uint8) #centro: [1][1]

#obter dimensoes da imagem
(altura,largura) = img_in.shape

def correlacao_translacao(imagem): ##### METODO TRANSLACAO #####
    #criar imagem de zeros
    img = np.zeros((altura+2,largura+2), dtype=np.uint8)

    #criar imagem com borda de pizza
    img[1:altura+1,1:largura+1] = imagem

    #TRANSLACOES
    corr = np.zeros((altura,largura), dtype=np.uint8)
    for i in range(3):
        for j in range(3):
            crop = img[i:altura+i,j:largura+j]
            corr = corr + crop * mascara[i][j]

    #NORMALIZACAO
    corr = corr / np.amax(corr)
    corr = corr * 255
    #mudar tipo para uint8
    corr = corr.astype(np.uint8)

    return corr

def correlacao_for_ij(imagem): ##### METODO FOR i FOR j
    #criar imagem de zeros
    img = np.zeros((altura+2,largura+2), dtype=np.uint8)
    
    #criar imagem com borda de pizza
    img[1:altura+1,1:largura+1] = imagem

    #criar correlacao de zeros
    corr = np.zeros((altura,largura), dtype=np.uint8)

    #varre a imagem com for i for j
    for i in range(altura):
        for j in range(largura):
            #faz um crop 3x3 da imagem que sera multiplicado pela mascara
            crop = img[i:i+3,j:j+3]
            
            corr[i][j] = multiplicar_mascara(mascara,crop)

    #NORMALIZACAO
    corr = corr / np.amax(corr)
    corr = corr * 255
    #mudar tipo para uint8
    corr = corr.astype(np.uint8)

    return corr

def multiplicar_mascara(mascara, crop):
    #multiplica a mascara por um crop 3x3 da imagem
    out = mascara * crop
    #retorna a soma dos valores
    return out.sum()


if(algoritmo == 0):
    cv2.imshow("image in",img_in)
    cv2.imshow("image out",correlacao_translacao(img_in))
    cv2.waitKey(0)
    cv2.destroyAllWindows()
else:
    cv2.imshow("image in",img_in)
    cv2.imshow("image out",correlacao_for_ij(img_in))
    cv2.waitKey(0)
    cv2.destroyAllWindows()