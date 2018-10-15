# coding=utf-8

import sys, os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from AutoTestTools.mysql import execute_sql
from Data import Variables
import json
import requests
from Conf.Properties import *
from Util.YamlTable import YamlTable
import re


class HttpRequest(object):
	def __init__(self):
		self.url = url

	def getUserInfo(self,user):
		token = execute_sql("SELECT token FROM `autotestapp_user` WHERE userId=" + str(user))[0][0]
		reqchannel = execute_sql("SELECT reqchannel FROM `autotestapp_user` WHERE userId=" + str(user))[0][0]

		return token,reqchannel


	def getResponse(self, user, mode, path,  params=None):
		table = YamlTable()
		token, reqchannel = self.getUserInfo(user)
		headers = {"Authorization": token,"ReqChannel": reqchannel}

		uri = path
		if params:
			pattern = re.compile(r'{\w*}')
			path_params = re.findall(pattern, path)
			for p in path_params:
				key = p[1:-1]
				uri = uri.replace(str(p), str(params[key]))
				del params[key]

		basepath = table.get_value(path, mode, "basepath").decode()

		if basepath in path:
			basepath = ""
		url = self.url + basepath + uri

		response = self._getRespMode(mode, path=path, url=url, headers=headers, params=params)

		print(mode, "    URL = ", response.url)
		print("Headers = ", headers)
		print("Params = ", params)
		resp_text = response.text
		if "Content-Type" in response.headers:
			if "image/jpeg" in response.headers['Content-Type']:
				resp_text = "image"
		print("Resp = ", resp_text)
		resp = self._getRespContent(response)
		return resp, resp_text

	def getResponse_2(self, mode, path, **kwargs):
		table = YamlTable()
		token = Variables.token
		reqchannel = Variables.reqchannel[0]

		headers = {"Authorization": kwargs.get('token', token),
				   "ReqChannel": kwargs.get('reqchannel', reqchannel)}

		uri = path
		params = kwargs.get("params", "")
		if params:
			pattern = re.compile(r'{\w*}')
			path_params = re.findall(pattern, path)
			for p in path_params:
				key = p[1:-1]
				uri = uri.replace(str(p), str(params[key]))
				del params[key]

		basepath = table.get_value(path, mode, "basepath").decode()

		if basepath in path:
			basepath = ""
		url = self.url + basepath + uri

		response = self._getRespMode(mode, path=path, url=url, headers=headers, params=params)

		print(mode, "    URL = ", response.url)
		print("Headers = ", headers)
		print("Params = ", params)
		resp_text = response.text
		if "Content-Type" in response.headers:
			if "image/jpeg" in response.headers['Content-Type']:
				resp_text = "image"
		print("Resp = ", resp_text)
		resp = self._getRespContent(response)
		return resp, resp_text

	def _getRespMode(self, mode, **kwargs):
		table = YamlTable()

		path = kwargs.get("path")
		url_0 = kwargs.get("url")
		headers = kwargs.get("headers")
		params = kwargs.get("params")

		if mode == "post":
			headers['Content-Type'] = "application/json"
			response = requests.post(url_0, data=json.dumps(params), headers=headers, verify=False)
		elif mode == "put":
			param_method = table.get_value(path, mode, "param_method")
			if "body" in list(param_method.values()):
				headers['Content-Type'] = "application/json"
				response = requests.put(url_0, data=json.dumps(params), headers=headers, verify=False)
			else:
				response = requests.put(url_0, params=params, headers=headers, verify=False)
		else:
			response = requests.get(url_0, params=params, headers=headers, verify=False)
		return response

	def _getRespContent(self, response):
		code = response.status_code
		content = response.content
		if code == 200:
			try:
				content = json.loads(content)
			except:
				print("json loads failure")
		resp = (code, content)
		return resp


if __name__ == '__main__':
	print(HttpRequest().getResponse_2("post", "/users/conllects/{questionId}", params={'questionId': 43230}))
