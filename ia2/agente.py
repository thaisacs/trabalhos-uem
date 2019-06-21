from pgmpy.models import BayesianModel
from pgmpy.factors.discrete import TabularCPD
from pgmpy.inference import VariableElimination
import sys
import os
import warnings

warnings.filterwarnings("ignore")

QTT_OPC = 5
# sintomas
FALTA_DE_AR = 1
TOSSE = 2
FEBRE = 3
PERDA_DE_PESO = 4
DOR_NO_PEITO = 5
FUMANTE = 6
ASIA = 7

def stop():
    print("|                                                         |")
    input("         PRECIONE ENTER PARA CONTINUAR....")
def printAndExit(s):
    print(s)
    sys.exit()

def printHeader():
    print("|.........................................................|")
    print("|.#####...####...####..######..####..#####..#####..##..##.|")
    print("|.##..##.##..##.##..##...##...##..##.##..##.##..##..####..|")
    print("|.##..##.##..##.##.......##...##..##.#####..#####....##...|")
    print("|.##..##.##..##.##..##...##...##..##.##..##.##.......##...|")
    print("|.#####...####...####....##....####..##..##.##.......##...|")
    print("|.........................................................|")
    #print("|  _____  _                     __      _   _            |")
    #print("| |  __ \(_)                   /_/     | | (_)           |")
    #print("| | |  | |_  __ _  __ _ _ __   ___  ___| |_ _  ___ ___   |")
    #print("| | |  | | |/ _` |/ _` | '_ \ / _ \/ __| __| |/ __/ _ \  |")
    #print("| | |__| | | (_| | (_| | | | | (_) \__ | |_| | (_| (_) | |")
    #print("| |_____/|_|\__,_|\__, |_| |_|\___/|___/\__|_|\___\___/  |")
    #print("|                  __/ |                                 |")
    #print("|                 |___/                                  |")
    print("|        .----.                                           |")
    print("|       ===(_)==   OLÁ! SOU O DOCTORPY...                 |")
    print("|      // 6  6 \\\  /                                      |")
    print("|      (    7   )                                         |")
    print("|       \ '--' /                                          |")
    print("|        \_ ._/                                           |")
    print("|       __)  (__         **THAIS CAMACHO**                |")
    print("|.........................................................|")

def printMenu():
    print("|    ==> O QUE VOCÊ DESEJA...                             |")
    print("|         [1] CONSULTAR                                   |")
    print("|         [2] INFERIR NA REDE                             |")
    print("|         [3] VISUALIZAR INFORMAÇÕES DA REDE              |")
    print("|         [0] SAIR                                        |")

def printConsultMenu():
    print("|    ==> ME FALE UM POUCO SOBRE SEUS SINTOMAS...          |")
    print("|         [1] ESTOU COM FALTA DE AR                       |")
    print("|         [2] ESTOU COM TOSSE                             |")
    print("|         [3] ESTOU COM FEBRE                             |")
    print("|         [4] PERDI PESO NOS ÚLTIMOS DIAS                 |")
    print("|         [5] ESTOU COM DOR NO PEITO                      |")

def printInferenceMenu():
    print("|         [1] ESTOU COM TUBERCULOSE?                      |")
    print("|         [2] ESTOU COM BRONQUITE?                        |")
    print("|         [3] ESTOU COM CÂNCER NO PULMÃO?                 |")

def printTableSmoke():
    print("|        +---------+---------------+                      |")
    print("|        |         | probabilidade |                      |")
    print("|        |---------+---------------|                      |")
    print("|        | SIM     |     50.0      |                      |")
    print("|        | NÃO     |     50.0      |                      |")
    print("|        |---------+---------------|                      |")

def printTableAsia():
    print("|        +---------+---------------+                      |")
    print("|        |         | probabilidade |                      |")
    print("|        |---------+---------------|                      |")
    print("|        | SIM     |     1.0       |                      |")
    print("|        | NÃO     |     99.0      |                      |")
    print("|        |---------+---------------|                      |")

def printTableTub():
    print("|        +---------+---------------+                      |")
    print("|        |         | probabilidade |                      |")
    print("|        |         +-------+-------|                      |")
    print("|        |         | SIM   | NÃO   |                      |")
    print("|        |---------+-------+-------|                      |")
    print("|        | SIM     | 5.0   | 95.0  |                      |")
    print("|        | NÃO     | 1.0   | 99.0  |                      |")
    print("|        |---------+---------------|                      |")

def printTableLung():
    print("|        +---------+---------------+                      |")
    print("|        |         | probabilidade |                      |")
    print("|        |         +-------+-------|                      |")
    print("|        |         | SIM   | NÃO   |                      |")
    print("|        |---------+-------+-------|                      |")
    print("|        | SIM     | 10.0  | 90.0  |                      |")
    print("|        | NÃO     | 1.0   | 99.0  |                      |")
    print("|        |---------+---------------|                      |")

def printTableBronc():
    print("|        +---------+---------------+                      |")
    print("|        |         | probabilidade |                      |")
    print("|        |         +-------+-------|                      |")
    print("|        |         | SIM   | NÃO   |                      |")
    print("|        |---------+-------+-------|                      |")
    print("|        | SIM     | 60.0  | 40.0  |                      |")
    print("|        | NÃO     | 30.0  | 70.0  |                      |")
    print("|        |---------+---------------|                      |")

def printTableXRAY():
    print("|        +---------+---------------+                      |")
    print("|        |         | probabilidade |                      |")
    print("|        |         +-------+-------|                      |")
    print("|        |         | SIM   | NÃO   |                      |")
    print("|        |---------+-------+-------|                      |")
    print("|        | SIM     | 98.0  | 2.0   |                      |")
    print("|        | NÃO     | 5.0   | 95.0  |                      |")
    print("|        |---------+---------------|                      |")

def printTableDysp():
    print("|        +---------+---------------+                      |")
    print("|        |         | probabilidade |                      |")
    print("|        |         +-------+-------|                      |")
    print("|        |         | SIM   | NÃO   |                      |")
    print("|        |---------+-------+-------|                      |")
    print("|        |SIM | SIM| 90.0  | 10.0  |                      |")
    print("|        |NÃO | SIM| 70.0  | 30.0  |                      |")
    print("|        |SIM | NÃO| 80.0  | 20.0  |                      |")
    print("|        |NÃO | NÃO| 10.0  | 90.0  |                      |")
    print("|        |---------+---------------|                      |")

def printTableEither():
    print("|        +---------+---------------+                      |")
    print("|        |         | probabilidade |                      |")
    print("|        |         +-------+-------|                      |")
    print("|        |         | SIM   | NÃO   |                      |")
    print("|        |---------+-------+-------|                      |")
    print("|        |SIM | SIM| 100.0 | 00.0  |                      |")
    print("|        |NÃO | SIM| 100.0 | 00.0  |                      |")
    print("|        |SIM | NÃO| 100.0 | 00.0  |                      |")
    print("|        |NÃO | NÃO| 00.0  | 100.0 |                      |")
    print("|        |---------+---------------|                      |")

def readInt():
    i = input("         R: ")
    while(len(i) < 1):
        i = input("         R: ")
    return int(i)

def readInput():
    values = []
    i = input("         R: ")
    if(len(i) > QTT_OPC):
        printAndExit("|    ==> OPÇÃO INVÁLIDA!!!                                |")
    for index in range(len(i)):
        values.append(int(i[index]))
    return values

def consultAsia(s):
    t = asia_infer.query(variables=['tub'], evidence={'asia': 0})
    t = t['tub'].values[0]
    print("|    ==> PESSOAS QUE VISITAM A ÁSIA POSSUEM {:.1f}%          |".format(t*100))
    print("|        DE CHANCES DE TEREM TUBERCULOSE                  |")
    if((TOSSE in s) and (PERDA_DE_PESO in s) and (FEBRE in s)):
        print("|    ==> TOSSE, PERDA DE PESO E FEBRE SÃO SINTOMAS DA     |")
        print("|        TUBERCULOSE                                      |")
    elif((TOSSE in s) and (PERDA_DE_PESO in s)):
        print("|    ==> TOSSE E PERDA DE PESO SÃO SINTOMAS DA            |")
        print("|        TUBERCULOSE                                      |")
    elif((FEBRE in s) and (PERDA_DE_PESO in s)):
        print("|    ==> FEBRE E PERDA DE PESO SÃO SINTOMAS DA            |")
        print("|        TUBERCULOSE                                      |")
    elif((FEBRE in s) and (TOSSE in s)):
        print("|    ==> FEBRE E TOSSE SÃO SINTOMAS DA TUBERCULOSE        |")
    elif((FEBRE in s)):
        print("|    ==> FEBRE É SINTOMA DA TUBERCULOSE                   |")
    elif((TOSSE in s)):
        print("|    ==> TOSSE É SINTOMA DA TUBERCULOSE                   |")
    elif((PERDA_DE_PESO in s)):
        print("|    ==> PERDA DE PESO É SINTOMA DA TUBERCULOSE           |")
    l = asia_infer.query(variables=['tub'])
    l = l['tub'].values[0]
    print("|    ==> HÁ {:.1f}% DE CHANCES DE VOCÊ ESTAR COM            |".format(l*100))
    print("|        TUBERCULOSE                                      |")

def consultSmoke(s):
    b = asia_infer.query(variables=['bronc'], evidence={'smoke': 0})
    l = asia_infer.query(variables=['lung'], evidence={'smoke': 0})
    f = asia_infer.query(variables=['dysp'], evidence={'smoke': 0, 'bronc': 0})
    b = b['bronc'].values[0]
    l = l['lung'].values[0]
    f = f['dysp'].values[0]
    print("|    ==> PESSOAS QUE FUMAM POSSUEM {:.1f}% DE CHANCES       |".format(b*100))
    print("|        DE TEREM BRONQUITE E {:.1f}% DE CHANCES TEREM      |".format(l*100))
    print("|        CÂNCER DE PULMÃO                                 |")
    if(FALTA_DE_AR in s):        
        print("|    ==> {:.1F}% DAS PESSOAS QUE POSSUEM BRONQUITE E FUMAM, |".format(f*100))
        print("|        SENTEM FALTA DE AR                               |")
        if(TOSSE in s):
            print("|    ==> TOSSE É UM SINTOMA DA BRONQUITE                  |")
        l = asia_infer.query(variables=['bronc'])
        l = l['bronc'].values[0]
        print("|    ==> HÁ {:.1f}% DE CHANCES DE VOCÊ ESTAR COM BRONQUITE  |".format(l*100))
    else:
        if((TOSSE in s) and (DOR_NO_PEITO in s) and (PERDA_DE_PESO in s)):
            print("|    ==> TOSSE, DOR NO PEITO E PERDA DE PESO SÃO SINTOMAS |")
            print("|        DE CÂNCER NO PULMÃO                              |")
        elif((TOSSE in s) and (DOR_NO_PEITO in s)):
            print("|    ==> TOSSE E DOR NO PEITO SÃO SINTOMAS DE             |")
            print("|        CÂNCER NO PULMÃO                                 |")
        elif((TOSSE in s) and (PERDA_DE_PESO in s)):
            print("|    ==> TOSSE E PERDE DE PESO SÃO SINTOMAS DE            |")
            print("|        CÂNCER NO PULMÃO                                 |")
        elif((DOR_NO_PEITO in s) and (PERDA_DE_PESO in s)):
            print("|    ==> DOR NO PEITO E PERDE DE PESO SÃO SINTOMAS DE     |")
            print("|        CÂNCER NO PULMÃO                                 |")
        elif((DOR_NO_PEITO in s)):
            print("|    ==> DOR NO PEITO É SINTOMA DE CÂNCER NO PULMÃO       |")
        elif((PERDA_DE_PESO in s)):
            print("|    ==> PERDE DE PESO É SINTOMA DE CÂNCER NO PULMÃO      |")
        elif((TOSSE in s)):
            print("|    ==> TOSSE É SINTOMA DE CÂNCER NO PULMÃO              |")
        l = asia_infer.query(variables=['lung'])
        l = l['lung'].values[0]
        print("|    ==> HÁ {:.1f}% DE CHANCES DE VOCÊ ESTAR COM CÂNCER     |".format(l*100))
        print("|        NO PULMÃO                                        |")

def consultEither(s):
    b = asia_infer.query(variables=['dysp'], evidence={'either': 0, 'bronc': 0})
    b = b['dysp'].values[0]
    print("|    ==> {:.1f}% DAS PESSOAS QUE POSSUEM BRONQUITE          |".format(b*100))
    print("|        TUBERCULOSE E CÂNCER NO PULMÃO, SENTEM FALTA     |") 
    print("|        DE AR                                            |")
    l = asia_infer.query(variables=['tub'])
    l = l['tub'].values[0]
    print("|    ==> HÁ {:.1f}% DE CHANCES DE VOCÊ ESTAR COM            |".format(l*100))
    print("|        TUBERCULOSE                                      |")
    l = asia_infer.query(variables=['bronc'])
    l = l['bronc'].values[0]
    print("|    ==> HÁ {:.1f}% DE CHANCES DE VOCÊ ESTAR COM BRONQUITE  |".format(l*100))
    l = asia_infer.query(variables=['lung'])
    l = l['lung'].values[0]
    print("|    ==> HÁ {:.1f}% DE CHANCES DE VOCÊ ESTAR COM CÂNCER     |".format(l*100))
    print("|        NO PULMÃO                                        |")

def consultAsiaAndSmoke(s):
    if(FALTA_DE_AR not in s):
        consultAsia(s)
        consultSmoke(s)
    else:
        consultEither(s)

def readSN(s):
    i = input(s)
    while(i != "S" and i != "N"):
        i = input(s)
    return i

def consult():
    s = []
    print("|    ==> ME FALE UM POUCO SOBRE VOCÊ...                   |")
    print("|        ==> VISITOU A ÁSIA NOS ÚLTIMOS DIAS? [S\\N]       |")
    if(readSN("             R: ") == "S"):
        s.append(ASIA)
    print("|        ==> VOCÊ É FUMANTE? [S\\N]                        |")
    if(readSN("             R: ") =="S"):
        s.append(FUMANTE)
    if((FUMANTE not in s) and (ASIA not in s)):
        print("|    ==> NÃO POSSO TE AJUDAR...                           |")
    else:
        printConsultMenu()
        r = readInput()
        s = r + s
        if (ASIA in s) and (FUMANTE in s):
            consultAsiaAndSmoke(s)
        elif (ASIA in s):
            consultAsia(s)
        elif(FUMANTE in s):
            consultSmoke(s)
    stop()

def inference():
    print("|    ==> INFERIR NA REDE...                               |")
    printInferenceMenu()
    r = readInt()
    while(r <= 0 or r >= 4):
        r = readInt()
    if(r == 1):
        l = asia_infer.query(variables=['tub'])
        l = l['tub'].values[0]
        print("|    ==> HÁ {:.1f}% DE CHANCES DE VOCÊ ESTAR COM            |".format(l*100))
        print("|        TUBERCULOSE                                      |")
    elif(r == 2):
        l = asia_infer.query(variables=['bronc'])
        l = l['bronc'].values[0]
        print("|    ==> HÁ {:.1f}% DE CHANCES DE VOCÊ ESTAR COM BRONQUITE  |".format(l*100))
    else:
        l = asia_infer.query(variables=['lung'])
        l = l['lung'].values[0]
        print("|    ==> HÁ {:.1f}% DE CHANCES DE VOCÊ ESTAR COM CÂNCER     |".format(l*100))
        print("|        NO PULMÃO                                        |")
    stop()

def printInfoNet():
    os.system('clear')    
    printHeader()
    print("|    ==> INFORMAÇÕES DA REDE BAYEASIANA                   |")
    print("|    ==> (asia)                                           |")
    printTableAsia()
    stop()
    print("|    ==> (smoke)                                          |")
    printTableSmoke()
    stop()
    print("|    ==> (tub | asia)                                     |")
    printTableTub()
    stop()
    print("|    ==> (lung | smoke)                                   |")
    printTableLung()
    stop()
    print("|    ==> (bronc | smoke)                                  |")
    printTableBronc()
    stop()
    print("|    ==> (xray | either)                                  |")
    printTableXRAY()
    stop()
    print("|    ==> (dysp | bronc, either)                           |")
    printTableDysp()
    stop()
    print("|    ==> (either | lung, tub)                             |")
    printTableEither()
    stop()

def createBayesianNetwork():
    # defining the network structure
    model = BayesianModel([('asia', 'tub'),
                           ('smoke', 'bronc'),
                           ('smoke', 'lung' ),
                           ('lung', 'either'),
                           ('tub', 'either' ),
                           ('bronc', 'dysp' ),
                           ('either', 'xray'),
                           ('either', 'dysp')
                           ]) 
    # defining the parameters
    cpd_asia  = TabularCPD(variable='asia', variable_card=2, values=[[0.01], [0.99]])
    cpd_smoke = TabularCPD(variable='smoke', variable_card=2, values=[[0.5], [0.5]])
    cpd_tub = TabularCPD(variable='tub', variable_card=2, 
                         values=[[0.05, 0.99], [0.95, 0.01]],
                         evidence=['asia'], evidence_card=[2])
    cpd_lung = TabularCPD(variable='lung', variable_card=2, 
                          values=[[0.1, 0.99], [0.9, 0.01]],
                          evidence=['smoke'], evidence_card=[2])
    cpd_bronc = TabularCPD(variable='bronc', variable_card=2, 
                           values=[[0.6, 0.7], [0.4, 0.3]],
                           evidence=['smoke'], evidence_card=[2])
    cpd_either = TabularCPD(variable='either', variable_card=2, 
                            values=[[1.0, 1.0, 1.0, 0.0], [0.0, 0.0, 0.0, 1.0]],
                            evidence=['lung', 'tub'], evidence_card=[2, 2])
    cpd_xray = TabularCPD(variable='xray', variable_card=2, 
                          values=[[0.98, 0.95], [0.02, 0.05]],
                          evidence=['either'], evidence_card=[2])
    cpd_dysp = TabularCPD(variable='dysp', variable_card=2, 
                          values=[[0.9, 0.7, 0.8, 0.1], [0.1, 0.3, 0.2, 0.9]],
                          evidence=['bronc', 'either'], evidence_card=[2, 2])
    # Associating the CPDs with the network
    model.add_cpds(cpd_asia, cpd_smoke, cpd_tub, cpd_lung, cpd_bronc, cpd_either, cpd_xray, cpd_dysp)
    model.check_model()
    return model

def main():
    os.system('clear')    
    # print info
    printHeader()
    printMenu()
    r = readInt()
    # start
    while(r >= 1 and r <= 3):
         if(r == 1):
             consult()
         elif(r == 2):
             inference()
         else:
             printInfoNet()
         os.system('clear')    
         printHeader()
         printMenu()
         r = readInt()

asia_model = createBayesianNetwork()
asia_infer = VariableElimination(asia_model)

main()
