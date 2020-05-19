
funcs = ["relu","leakyrelu","sigmoid","hardtanh"]
test_widths = [2,3,4,5,6,7,8,16,32]
decimal     = [1,1,1,1,2,2,2,2,2]
for i in range(len(test_widths)):
  test_widths[i] = str(test_widths[i])
  decimal[i] = str(decimal[i])


area_total = []
power_total = []
timing_total = []
with open("Activation_Function_report.rpt", "w") as f:
  for func in funcs:
    for i in range(len(test_widths)):
      root_directory = "./" + func + "/" + func + test_widths[i] + "_" + decimal[i] + "/report"

      area_path   = root_directory + "/area.rpt"
      power_path  = root_directory + "/power.rpt"
      timing_path = root_directory + "/timing.rpt"


      with open(area_path,"r") as area_report:
        area_lines = area_report.readlines();

      area = area_lines[27][33:-1]
      area_total.append(area)



      with open(power_path,"r") as power_report:
        power_lines = power_report.readlines();

      power = power_lines[54][68:-1]
      power_total.append(power)

      with open(timing_path,"r") as timing_report:
        for line in timing_report:
          if "slack" in line:
            slack = line[52:-1]
            timing_total.append(slack)
      f.write(func + test_widths[i] + "_" + decimal[i]  + "\n")
      f.write("area = " + area   + "\n")
      f.write("power = " + power  + "\n")
      f.write("timing = " + slack +  "\n\n")
f.close()

with open("document.rpt","w") as f1:
  for i in area_total:
    f1.write(i+"\n")
  f1.write("\n")
  for i in power_total:
    f1.write(i + "\n")
  f1.write("\n")
  for i in timing_total:
    f1.write(i + "\n")