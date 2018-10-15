# coding=utf-8
import xlrd
import json
from xlutils.copy import copy
from Util.ParserSwagger import ParserSwagger
from Lib.Function import *
from Conf.Properties import *


class YamlTable(object):
	_Title = ['id', 'path', 'method', 'tag', 'host', 'basepath', 'param_method', 'param_required', 'params',
			  'resps',
			  'reqchannel', 'time', 'yaml_name', 'remark']
	_sheet_name = "sheet1"

	def __init__(self):
		self.workbook = xlrd.open_workbook(yaml_table)
		self.sheet = self.workbook.sheet_by_name(self._sheet_name)

	def trans_excel(self):
		for file_name in yaml_names:
			self.trans_yaml_one_to_excel(file_name)


	def get_new_paths(self):
		col = self._get_title_colnum("time")
		col_path = self._get_title_colnum("path")
		col_method = self._get_title_colnum("method")
		col_tag = self._get_title_colnum("tag")
		col_yaml_name= self._get_title_colnum("yaml_name")
		times = self.sheet.col_values(col)
		time_position = self.get_element_positions_from_list(times)

		news = time_position.get("new", [])
		new_path = []
		for new in news:
			path = self.sheet.cell_value(new, col_path)
			method = self.sheet.cell_value(new, col_method)
			tag = self.sheet.cell_value(new, col_tag)
			yaml_name = self.sheet.cell_value(new, col_yaml_name)
			new_path.append([path, method, tag, yaml_name])
		return new_path


	def get_filename(self, **kwargs):
		col = self._get_title_colnum("yaml_name")
		col_tag = self._get_title_colnum("tag")
		col_path = self._get_title_colnum("path")
		if "tag" in kwargs.keys():
			tags = self.sheet.col_values(col_tag)
			return self.sheet.cell_value(tags.index(kwargs['tag']), col)

		if "path" in kwargs.keys():
			paths = self.sheet.col_values(col_path)
			return self.sheet.cell_value(paths.index(kwargs['path']), col)


	def get_tags(self):
		col = self._get_title_colnum("tag")
		tags = self.sheet.col_values(col)
		return list(set(tags.remove("tag")))


	def get_paths(self):
		col = self._get_title_colnum("path")
		paths = self.sheet.col_values(col)
		return list(set(paths.remove("path")))


	def get_path_modes(self, path):
		modes = []
		col = self._get_title_colnum("path")
		paths = self.sheet.col_values(col)
		path_position = self.get_element_positions_from_list(paths)
		position = path_position.get(path, [])
		col_method = self._get_title_colnum("method")
		for p in position:
			modes.append(self.sheet.cell_value(p, col_method))
		return modes


	def get_path_tag(self, path):
		col = self._get_title_colnum("path")
		paths = self.sheet.col_values(col)
		col_tag = self._get_title_colnum("tag")
		return self.sheet.cell_value(paths.index(path), col_tag)


	def get_tags_paths(self):
		tags_paths = {}
		col = self._get_title_colnum("tag")
		path_col = self._get_title_colnum("path")
		tags = self.sheet.col_values(col)
		tag_position = self.get_element_positions_from_list(tags)
		for tag, position in tag_position.items():
			for i in range(len(position)):
				path = self.sheet.cell_value(position[i], path_col)
				position[i] = path
			tags_paths.update({tag: position})
		return tags_paths


	def get_value(self, path, method, value_title_name):
		row = self._get_path_rownum(path, method)
		col = self._get_title_colnum(value_title_name)
		text = self.sheet.cell(row, col)
		try:
			value = json.loads(text.value)
		except:
			if text.ctype in [0, 1]:
				value = text.value.encode("utf-8")
			elif text.ctype == 2:
				value = int(text.value)
			elif text.ctype == 4:
				value = True
			else:
				value = text.value

		return value


	def _get_path_rownum(self, path, method):
		row = -1
		col_path_values = self.sheet.col_values(1)
		path_position = self.get_element_positions_from_list(col_path_values)
		position = path_position.get(path, [])
		for p in position:
			if method == self.sheet.cell_value(p, 2):
				row = p
				break
		return row


	def _get_title_colnum(self, title_name):
		return self._Title.index(title_name)


	def trans_yaml_one_to_excel(self, file_name):
		workbook = xlrd.open_workbook(yaml_table)
		sheet = self.workbook.sheet_by_name(self._sheet_name)

		col_name = self._get_title_colnum("yaml_name")
		file_dir = os.path.join(yaml_dir, file_name + ".yaml")
		paser = ParserSwagger(file_dir)
		col_path_values = sheet.col_values(1)
		path_position = self.get_element_positions_from_list(col_path_values)
		len2 = len(col_path_values)

		workbook_copy = copy(workbook)
		sheet_copy = workbook_copy.get_sheet(self._sheet_name)

		i = 0
		col_path = self._get_title_colnum("path")
		for path in paser.paths:
			if path == sheet.cell_value(0, col_path):
				continue
			positon = path_position.get(path, [])
			modes = paser.get_path_modes(path)
			tag = paser.get_path_tags(path)[0]
			for method in modes:
				params = paser.paths_data[path][method]['parameters']
				param = self._param_format(params)
				resp = paser.paths_data[path][method]['responses']['200']
				content = [path, method, tag, paser.host, paser.basePath, param[0], param[1], param[2], resp]
				if positon:
					for p in positon:
						method_sheet = sheet.cell(p, 2).value
						if method == method_sheet:
							row = p
							now_time = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
							self._write_path(sheet_copy, row, content, now_time)
							sheet_copy.write(row, col_name, file_name)
							positon.remove(p)
				else:
					row = len2 + i
					self._write_path(sheet_copy, row, content, "new")
					sheet_copy.write(row, col_name, file_name)
					i += 1

		workbook_copy.save("temp.xls")
		Function().movefile("temp.xls", yaml_table)


	def _param_format(self, params):
		name = {}
		method = {}
		required = {}
		if len(params) > 0:
			for param in params:
				name.update(param['name'])
				required.update({list(param['name'].keys())[0]: param['required']})
				method.update({list(param['name'].keys())[0]: param['method']})

		name = json.dumps(name)
		method = json.dumps(method)
		required = json.dumps(required)
		return (method, required, name)


	def _write_path(self, sheet, row, content, result):
		sheet.write(row, 0, row)
		for i in range(len(content)):
			cont = content[i]
			if isinstance(cont, (list, dict)):
				cont = json.dumps(cont)
			sheet.write(row, i + 1, cont)
		col = self._get_title_colnum("time")
		sheet.write(row, col, result)


	@staticmethod
	def get_element_positions_from_list(var_list):
		list_positoin = []
		for i in var_list:
			address_index = [x for x in range(len(var_list)) if var_list[x] == i]
			list_positoin.append([i, address_index])
		resp = dict(list_positoin)
		return resp


if __name__ == '__main__':
	#
	filename = os.path.join(curr_dir, "yaml", "exam-swagger.yaml")
	table = YamlTable()
	table.trans_yaml_one_to_excel('exam-swagger')
