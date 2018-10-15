# coding=utf-8

import os
import re


class CaseName(object):
	def __init__(self):
		pass

	def get_path_dirs(self, path):
		i = -1
		folder = []
		folder_dirs = []
		for root, dirs, files in os.walk(path):
			l = len(folder)
			i = i + 1
			if i == 0:
				folder = dirs
				continue
			elif 0 < i <= l:
				folder_dirs.append(root)
			else:
				break
		folder.remove("test")
		folder_dirs.remove(os.path.join(path, 'test'))
		return folder, folder_dirs

	def get_file_name(self, path):
		folder, dirs = self.get_path_dirs(path)
		file_name = {}
		for i in range(len(folder)):
			file_name[folder[i]] = os.listdir(dirs[i])
		return file_name

	def get_case_name(self, path):
		folder, dirs = self.get_path_dirs(path)
		file_name = self.get_file_name(path)
		case_detail = {}
		for i in range(len(folder)):
			case_detail[folder[i]] = {}
			for fn in file_name[folder[i]]:
				key = fn.split(".")[0]
				case_detail[folder[i]][key] = {}
				file_dir = os.path.join(dirs[i], fn)
				with open(file_dir,encoding='utf-8') as f:
					content = [r.rstrip() for r in f.readlines()]
				index = content.index('*** Test Cases ***')
				for j in range(index + 1, len(content)-2):
					if re.match("\w", content[j]):
						name = content[j]
						case_detail[folder[i]][key][name] = {}
						if "[Documentation]" in content[j + 1]:
							case_detail[folder[i]][key][name]['doc'] = content[j + 1].replace("[Documentation]","").strip()
						else:
							case_detail[folder[i]][key][name]['doc'] = ""
						if "[Tags]" in content[j + 2]:
							case_detail[folder[i]][key][name]['tag'] = content[j + 2].replace("[Tags]","").strip().replace("    ",",")
						else:
							case_detail[folder[i]][key][name]['tag'] = ""
		return case_detail


class BusinessName(object):
	def __init__(self):
		pass

	def get_path_dirs(self, path):
		i = -1
		folder = []
		folder_dirs = []
		for root, dirs, files in os.walk(path):
			l = len(folder)
			i = i + 1
			if i == 0:
				folder = dirs
				continue
			elif 0 < i <= l:
				folder_dirs.append(root)
			else:
				break
		return folder, folder_dirs

	def get_file_name(self, path):
		folder, dirs = self.get_path_dirs(path)
		file_name = {}
		for i in range(len(folder)):
			names = os.listdir(dirs[i])
			for name in os.listdir(dirs[i]):
				if not re.match("Bus_", name):
					names.remove(name)
			file_name[folder[i]] = names
		return file_name

	def get_business_name(self, path):
		folder, dirs = self.get_path_dirs(path)
		file_name = self.get_file_name(path)
		business_name = {}
		for i in range(len(folder)):
			business_name[folder[i]] = []
			for fn in file_name[folder[i]]:
				file_dir = os.path.join(dirs[i], fn)
				with open(file_dir,encoding='utf-8') as f:
					content = [r.rstrip() for r in f.readlines()]
				index = content.index('*** Keywords ***')
				for j in range(index + 1, len(content)):
					if re.match("\w", content[j]) and not re.match("re_", content[j]):
						business_name[folder[i]].append(content[j])

		return business_name


if __name__ == '__main__':
	from Conf.Properties import case_dir

	names = CaseName().get_case_name(case_dir)
	print(case_dir)
	print(names)
