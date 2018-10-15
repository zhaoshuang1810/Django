# coding=utf-8
import os

from Util.YamlTable import YamlTable
from Util.CreateAPICases import CreateAPICases
from Conf.Properties import yaml_names, api_cases_dir, yaml_dir


def run_create_api_cases():
	table = YamlTable()
	for file_name in yaml_names:
		table.trans_yaml_one_to_excel(file_name)
	new_path = YamlTable().get_new_paths()
	print(new_path)
	for path, method, tag, yaml_name in new_path:
		file_dir = os.path.join(yaml_dir, yaml_name + ".yaml")
		new_case = CreateAPICases(file_dir)
		if not os.path.exists(os.path.join(api_cases_dir, tag + ".robot")):
			new_case.fileOne(tag)
		new_case.newCaseOne(path, method, tag)


if __name__ == '__main__':
	# 创建api文档用例
	run_create_api_cases()
