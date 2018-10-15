# coding=utf-8


class AssertResp(object):

	def __init__(self):
		pass

	def assertRespValue(self, resp_http, resp_data):
		u'''
		断言接口返回值是否与预期一致
		:param resp_http: 接口返回值
		:param resp_data: 设置的期望值
		:return:
		'''
		result = [True]
		if isinstance(resp_data, dict):
			self._assertDictValue(resp_http, resp_data, result, "")
		elif isinstance(resp_data, list):
			self._assertListValue(resp_http, resp_data, result, "")
		else:
			pass
		return result

	def _assertDictValue(self, resp_http, resp_data, result, key_path):
		keys = resp_data.keys()
		for key in keys:
			key_path0 = key_path + "[\'" + key + "\']"
			if isinstance(resp_data[key], dict):
				self._assertDictValue(resp_http[key], resp_data[key], result, key_path0)
			elif isinstance(resp_data[key], list):
				self._assertListValue(resp_http[key], resp_data[key], result, key_path0)
			else:
				if resp_data[key] == resp_http[key]:
					pass
				else:
					result[0] = False
					resp = {"value" + key_path0: {"ResponseValue": resp_http[key], "ExpectedValue": resp_data[key]}}
					result.append(resp)

	def _assertListValue(self, resp_http, resp_data, result, key_path):
		for i in range(len(resp_data)):
			key_path0 = key_path + "[" + str(i) + "]"
			print(key_path0)
			if isinstance(resp_data[i], dict):
				self._assertDictValue(resp_http[i], resp_data[i], result, key_path0)
			elif isinstance(resp_data[i], list):
				self._assertListValue(resp_http[i], resp_data[i], result, key_path0)
			else:
				if resp_data[i] == resp_http[i]:
					pass
				else:
					result[0] = False
					resp = {"value" + key_path0: {"ResponseValue": resp_http[i], "ExpectedValue": resp_data[i]}}
					result.append(resp)

	def assertResp(self, resp_http, resp_doc):
		u'''
		断言接口返回值的字段类型与文档是否一致
		:param resp_http:接口返回值
		:param resp_doc:接口文档
		:return:
		'''
		result = [True]
		assertType = self._assertType(resp_http, resp_doc)
		if assertType[0]:
			if isinstance(resp_doc, dict):
				self._assertDict(resp_http, resp_doc, result, "")
			elif isinstance(resp_doc, list):
				self._assertList(resp_http, resp_doc, result, "")
			else:
				pass
		else:
			result[0] = False
			resp = {"type": {"ResponseType": assertType[1], "DocumentType": assertType[2]}}
			result.append(resp)
		return result

	def _assertDict(self, resp_http, resp_doc, result, key_path):
		assertType = self._assertType(resp_http, resp_doc)
		if assertType[0]:
			keys_http = list(resp_http.keys())
			keys_http.sort()
			keys_doc = list(resp_doc.keys())
			keys_doc.sort()

			if keys_http == keys_doc:
				for key in keys_doc:
					key_path0 = key_path + "[\'" + key + "\']"
					if isinstance(resp_doc[key], dict):
						self._assertDict(resp_http[key], resp_doc[key], result, key_path0)
					elif isinstance(resp_doc[key], list):
						self._assertList(resp_http[key], resp_doc[key], result, key_path0)
					else:
						assertType = self._assertType(resp_http[key], resp_doc[key])
						if assertType[0]:
							pass
						else:
							result[0] = False
							resp = {"tpye" + key_path0: {"ResponseType": assertType[1], "DocumentType": assertType[2]}}
							result.append(resp)

			else:
				result[0] = False
				index1 = []
				index2 = []
				for key1 in keys_http:
					for key2 in keys_doc:
						if key1 == key2:
							i1 = keys_http.index(key1)
							i2 = keys_doc.index(key2)
							index1.append(i1)
							index2.append(i2)
				index1.reverse()
				for i in index1:
					keys_http.pop(i)
				index2.sort()
				index2.reverse()
				for i in index2:
					keys_doc.pop(i)

				resp = {"key" + key_path: {"ResponseKeys": keys_http, "DocumentKeys": keys_doc}}
				result.append(resp)
		else:
			result[0] = False
			resp = {"type" + key_path: {"ResponseType": assertType[1], "DocumentType": assertType[2]}}
			result.append(resp)

	def _assertList(self, resp_http, resp_doc, result, key_path):
		assertType_0 = self._assertType(resp_http, resp_doc)
		if assertType_0[0]:
			key_path = key_path + "[0]"
			if len(resp_http) > 0:
				assertType = self._assertType(resp_http[0], resp_doc[0])
				if assertType[0]:
					if isinstance(resp_doc[0], dict):
						self._assertDict(resp_http[0], resp_doc[0], result, key_path)
					elif isinstance(resp_doc[0], list):
						self._assertList(resp_http[0], resp_doc[0], result, key_path)
					else:
						pass
				else:
					result[0] = False
					resp = {"type" + key_path: {"ResponseType": assertType[1], "DocumentType": assertType[2]}}
					result.append(resp)
			else:
				result[0] = False
				resp = {"list" + key_path: "Response Value is  empty "}
				result.append(resp)
		else:
			result[0] = False
			resp = {"type" + key_path: {"ResponseType": assertType_0[1], "DocumentType": assertType_0[2]}}
			result.append(resp)

	def _assertType(self, resp_http, resp_doc):
		# if isinstance(resp_http, unicode):
		# 	resp_http = resp_http.encode("utf-8")
		# if isinstance(resp_doc, unicode):
		# 	resp_doc = resp_doc.encode("utf-8")

		t1 = type(resp_http)
		t2 = type(resp_doc)
		if t1 == t2:
			resp = [True, t1]
		elif not resp_http and not isinstance(resp_doc, (list, dict)):
			resp = [True, resp_http, resp_doc]
		else:
			resp = [False, t1, t2]
		return resp


if __name__ == '__main__':
	resp = {}
	resp_doc = {}
	aa = AssertResp().assertResp(resp, resp_doc)
	print(aa)
