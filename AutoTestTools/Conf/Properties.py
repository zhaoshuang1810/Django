import os

url = "https://exam.zmgongzuoshi.top"

# mysql
dbHost = '172.16.164.173'
dbPort = 3301
dbName = 'exam_shangde_01'
dbUsername = 'root'
dbPassword = 'feo@2030'
dbCharset = 'utf8'

# dir
curr_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
bus_dir = os.path.join(curr_dir, "Business")
case_dir = os.path.join(curr_dir, "RunCase")
conf_dir = os.path.join(curr_dir, "Conf")
media_dir = os.path.join(curr_dir, "AutoTestTools", 'media')
yaml_dir = os.path.join(curr_dir, "yaml")
yaml_names = list(filter(None, [y.split(".")[0] for y in os.listdir(yaml_dir)]))
yaml_table = os.path.join(curr_dir, "Excel", "yaml_table.xls")
api_cases_dir = os.path.join(case_dir, "API_Doc")
param_datas_dir = os.path.join(curr_dir, "Data", "params")
resp_datas_dir = os.path.join(curr_dir, "Data", "resps")
screenshot_dir = os.path.join(curr_dir,"Image","Screenshot")
compareImage_dir = os.path.join(curr_dir,"Image","Compare")
resultImage_dir = os.path.join(curr_dir,"Image","Result")
location_table = os.path.join(curr_dir, "Excel", "ElementLocation.xlsx")

# app
remote_url = "http://localhost:4723/wd/hub"
platformName = "Android"
platformVersion = "6.0.1"
deviceName = "android"
noReset = True
fullReset = False
fastReset = False
app = os.path.join(conf_dir, "exam_qing.apk")
appPackage = "com.sunlands.feo.exam.qing"
appActivity = ".MainActivity"