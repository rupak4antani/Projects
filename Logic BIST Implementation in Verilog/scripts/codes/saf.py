import os
import subprocess
import re
search_text="//Marker"
replace_text = ""
search_text1="c432_1"
replace_text1="c432_sa"


"""   Node names={N1_new, N4_new, N8_new, N11_new, N14_new, N17_new, N21_new, N24_new, N27_new, N30_new,N34_new, N37_new, N40_new, N43_new, N47_new, N50_new, 
                 N53_new, N56_new, N60_new, N63_new, N66_new, N69_new, N73_new, N76_new, N79_new, N82_new, N86_new, N89_new, N92_new, N95_new,N99_new, N102_new, 
                 N105_new, N108_new, N112_new, N115_new, N118,N119,N122,N123,N126,N127,N130,N131,N134,N135,N138,N139,N142,N143,N146,N147,N150,N151,N154,N157,
                 N158,N159,N162,N165,N168,N171,N174,N177,N180,N183,N184,N185,N186,N187,N188,N189,N190,N191,N192,N193,N194,N195,N196,N197,N198,N199,N203,N213,N224,
                 N227,N230,N233,N236,N239,N242,N243,N246,N247,N250,N251,N254,N255,N256,N257,N258,N259,N260,N263,N264,N267,N270,N273,N276,N279,N282,N285,N288,N289,
                 N290,N291, N292,N293,N294,N295,N296,N300,N301,N302,N303,N304,N305,N306,N307,N308,N309,N319,N330,N331,N332,N333,N334,N335,N336,N337,N338,N339,N340,
                 N341,N342,N343,N344,N345,N346,N347,N348,N349,N350,N351,N352,N353,N354,N355,N356,N357,N360,N371,N372,N373,N374,N375,N376,N377,N378,N379,N380,N381,
                 N386,N393,N399,N404,N407,N411,N414,N415,N416,N417,N418,N419,N420,N422,N425,N428,N429,N223,N329,N370,N421,N430,N431,N432}.
                 Node names with _new are inputs
"""

n = int(input("Enter number of stuck at faults you want to introduce in the test circuit: "))
for _ in range(n):
    node = input("Enter node name where you want to introduce stuck at fault (Names of all nodes given in comment): ")
    bit = int(input("Enter whether you want Stuck-at-1 or Stuck-at-0 fault at that node: "))
    if bit == 1 or bit == 0:
        # Append the formatted string with "force" before user_choice
        replace_text += f'force {node} ={bit};\n'
    else:
        print("Invalid value")

print(replace_text)
fp1 = open("c432_1.v",'r') 
fp2 =open("c432_sa.v",'w')
data = fp1.read() 
data=data.replace(search_text,replace_text)
data=data.replace(search_text1,replace_text1)
fp2.write(data) 

