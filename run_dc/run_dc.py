def alter(file,old_str,new_str):
  """
  替换文件中的字符串
  :param file:文件名
  :param old_str:就字符串
  :param new_str:新字符串
  :return:
  """
  file_data = ""
  with open(file, "r", encoding="utf-8") as f:
    for line in f:
      if old_str in line:
        line = new_str
  #      line = line.replace(old_str,new_str)
      file_data += line
  with open(file,"w",encoding="utf-8") as f:
    f.write(file_data)


import os
funcs = ["relu","leakyrelu","sigmoid","hardtanh"]
test_widths = [2,3,4,5,6,7,8,16,32]
decimal     = [1,1,1,1,2,2,2,2,2]
for func in funcs:
  os.system("mkdir " + func)
  for i in range(len(test_widths)):
    os.system("mkdir ./"+ func +"/" + func + str(test_widths[i])+"_"+str(decimal[i]))
    os.system("mkdir ./"+ func +"/" + func + str(test_widths[i])+"_" +str(decimal[i]) +"/report")



test_widths = [2,3,4,5,6,7,8,16,32]
decimal     = [1,1,1,1,2,2,2,2,2]

for i in test_widths:
  alter("./Activation-Func/ActivationFunctionLib.v", "relu_sign#(parameter WIDTH", "module relu_sign#(parameter WIDTH = " +  str(i) + ")(\n")
  alter("./compiler_ActFunc.tcl","./relu/relu","set root_directory            ./relu/relu"+ str(i)+"_2\n")
  os.system("dc_shell-t -f compiler_ActFunc.tcl")



# for sigmoid
for i in range(len(test_widths)):
  alter("./Activation-Func/ActivationFunctionLib.v", "sigmoid_sign#(parameter WIDTH", "module sigmoid_sign#(parameter WIDTH = "+str(test_widths[i])+", DECIMAL_POINT = "+str(test_widths[i]-decimal[i])+")(\n")
  alter("./compiler_ActFunc.tcl","set top_design","set top_design sigmoid_sign\n")
  alter("./compiler_ActFunc.tcl","current_design","current_design sigmoid_sign\n")
  alter("./compiler_ActFunc.tcl","set root_directory","set root_directory            ./sigmoid/sigmoid"+ str(test_widths[i])+"_"+str(decimal[i])+"\n")
  os.system("dc_shell-t -f compiler_ActFunc.tcl")



# for leakyrelu_sign
for i in range(len(test_widths)):
  alter("./Activation-Func/ActivationFunctionLib.v", "leakyRelu_sign#(parameter WIDTH", "module leakyRelu_sign#(parameter WIDTH = "+str(test_widths[i])+ ", NEGATIVE_SLOPE_SHIFT = 5)(\n")
  alter("./compiler_ActFunc.tcl","set top_design","set top_design leakyRelu_sign\n")
  alter("./compiler_ActFunc.tcl","current_design","current_design leakyRelu_sign\n")
  alter("./compiler_ActFunc.tcl","set root_directory","set root_directory            ./leakyrelu/leakyrelu"+ str(test_widths[i])+"_2\n")
  os.system("dc_shell-t -f compiler_ActFunc.tcl")
 

# for hardtanh
for i in range(len(test_widths)):
  alter("./Activation-Func/ActivationFunctionLib.v", "hardtanh_sign#(parameter WIDTH", "module hardtanh_sign#(parameter WIDTH = "+str(test_widths[i])+", DECIMAL_POINT = "+str(test_widths[i]-decimal[i])+")(\n")
  alter("./compiler_ActFunc.tcl","set top_design","set top_design hardtanh_sign\n")
  alter("./compiler_ActFunc.tcl","current_design","current_design hardtanh_sign\n")
  alter("./compiler_ActFunc.tcl","set root_directory","set root_directory            ./hardtanh/hardtanh"+ str(test_widths[i])+"_"+str(decimal[i])+"\n")
  os.system("dc_shell-t -f compiler_ActFunc.tcl")
  
