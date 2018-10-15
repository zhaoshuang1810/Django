# coding=utf-8
import os
import sys

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.append(BASE_DIR)
from Conf.Properties import *
from Conf.CommonVariables import *
from Util.YamlTable import YamlTable


class JsonRead(object):
	def __init__(self):
		pass

	def getParam_data(self, filename, casename):
		dir = os.path.join(param_datas_dir, filename + ".json")
		with open(dir, 'r') as load_f:
			load_dict = json.load(load_f)
		param_dict = load_dict[casename]
		param = self._valueChangeVar(param_dict)
		print (param)
		return param

	def getResp_data(self, filename, casename):
		dir = os.path.join(resp_datas_dir, filename + ".json")
		with open(dir, 'r') as load_f:
			load_dict = json.load(load_f)
		resp_dict = load_dict[casename]
		print (resp_dict)
		resp = self._valueChangeVar(resp_dict)
		print (resp)
		return resp

	def _valueChangeVar(self,resp_dict):
		if isinstance(resp_dict,list):
			dict_1 = resp_dict[0]
			self._valueChangeVar(dict_1)
		elif isinstance(resp_dict,dict):
			for key,value in resp_dict.items():
				if value in sql_varibles:
					value_1 = eval(value)
					resp_dict[key] = value_1
				else:
					if isinstance(value,list):
						value_1 = value[0]
						self._valueChangeVar(value_1)
					elif isinstance(value,dict):
						self._valueChangeVar(value)
					else:
						pass
		else:
			pass
		return resp_dict

	def getResp_doc(self, mode, path):
		return YamlTable().get_value(path,mode,"resps")

	def getParam_doc(self, mode, path):
		table = YamlTable()
		params = table.get_value(path,mode,"params")
		method = table.get_value(path,mode,"param_method")
		if "body" in list(method.values()):
			params = list(params.values())[0]
		return params

	def getTags_Paths(self):
		return YamlTable().get_tags_paths()


if __name__ == '__main__':
	resp = JsonRead().getParam_doc("post", "/userAnswer")
	print ("================")
	print (resp)
