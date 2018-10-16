# coding=utf-8

from AutoTestTools.mysql import execute_sql
from Conf.Properties import *
from Util.RFMethodName import BusinessName


class CreateTestCases(object):
	def __init__(self, case_ids, client="API"):
		self.dir = os.path.join(curr_dir, "RunCase", "test", "test.robot")
		self.case_ids = case_ids
		self.client = client

	def new_cases(self):
		self.new_file()
		for case_id in self.case_ids:
			f = open(self.dir, "a+", encoding='utf-8')
			content = self._write_cases(case_id)
			f.writelines(content)
			f.write("\n")
			f.close()

	def new_file(self):
		content = self._write_settings() + self._write_variables()
		content.append("*** Test Cases ***\n")
		with open(self.dir, "w", encoding='utf-8') as f:
			f.writelines(content)

	def _write_settings(self):
		content = []
		content.append("*** Settings ***\n")
		content.append("Force Tags         FunTest" + self.client + "\n")
		if self.client == "GUI":
			content.append("Suite Setup	         Setup_suite\n")
			content.append("Suite Teardown	     Teardown_suite\n")
			content.append("Test Setup	         Setup_test\n")
			content.append("Test Teardown	     Teardown_test\n")
			content.append("Resource             ../../Business/GUI/Init.robot\n")
		business_file_name = BusinessName().get_file_name(bus_dir)
		for resource in business_file_name.get(self.client, 'API'):
			content.append("Resource        ../../Business/" + self.client + "/" + resource + "\n")
		content.append("Variables       ../../Data/Variables.py\n")
		content.append("\n\n")
		return content

	def _write_variables(self):
		content = []
		case_ids_string = ",".join(self.case_ids)
		sql = "SELECT varName,`value` FROM `autotestapp_data` WHERE id in (SELECT data_id FROM `autotestapp_business_params` WHERE business_id in (SELECT business_id FROM `autotestapp_case_business` WHERE case_id in(" + case_ids_string + ")))"
		params = execute_sql(sql)
		params_list = []
		for param in params:
			sql = "SELECT chanel FROM `autotestapp_data` WHERE varName='" + param[0] + "'"
			chanel = execute_sql(sql)[0][0]
			if chanel == 1:
				if "=" in param[1]:
					var_name = "&{" + param[0] + "}"
				elif "," in param[1] and "=" not in param[1]:
					var_name = "@{" + param[0] + "}"
				else:
					var_name = "${" + param[0] + "}"
				params_list.append(var_name + "          " + "    ".join(param[1].split(",")) + "\n")
		if params_list:
			content.append("*** Variables ***\n")
			content = content + params_list
			content.append("\n\n")
		return content

	def _write_cases(self, case_id):
		content = []

		num = int(case_id)
		name_num = str(case_id)
		if num / 1 < 10:
			name_num = "00" + name_num
		elif num / 10 < 10:
			name_num = "0" + name_num
		else:
			pass
		name = "TestCase" + name_num + "\n"
		content.append(name)

		sql = "SELECT `name` FROM `autotestapp_case` WHERE id=" + str(case_id)
		documentation = execute_sql(sql)[0][0]
		if documentation:
			content.append("    [Documentation]    " + documentation + "\n")

		sql = "SELECT isrun FROM `autotestapp_case` WHERE id=" + str(case_id)
		isrun = execute_sql(sql)[0][0]
		if isrun == 1:
			tag_content = "     [Tags]    Run"
		else:
			tag_content = "     [Tags]    NotRun"

		sql = "SELECT b.tag FROM `autotestapp_case` a INNER JOIN `AutoTestApp_funmodule` b WHERE b.id=a.funmodule_id AND a.id=" + str(case_id)
		funtag = execute_sql(sql)[0][0]
		tag_content = tag_content + "    " + funtag

		sql = "SELECT tagName FROM `autotestapp_tag` WHERE id IN (SELECT tag_id FROM `autotestapp_case_tags` WHERE case_id=" + str(
			case_id) + ")"
		tags = execute_sql(sql)
		tags_list = []
		for tag in tags:
			tags_list.append(tag[0])
		if tags_list:
			string = "    ".join(tags_list)
			tag_content = tag_content + "    " + string
		content.append(tag_content + "\n")

		content = content + self._get_business_content(case_id)
		return content

	def _get_business_content(self,case_id):
		content = []
		sql = "SELECT b.business_id,c.`name`,c.nameEn,c.params,a.user_id FROM (`autotestapp_business` a  LEFT JOIN `autotestapp_business_basic` c on  a.bus_basic_id=c.id) inner join `autotestapp_case_business` b on a.id=b.business_id WHERE b.case_id=" + str(
			case_id) + " ORDER BY b.id"
		business = execute_sql(sql)
		process_list = []
		for bus in business:
			process = []
			process.append(bus[2])
			if self.client == "API":
				sql = "SELECT userId FROM `autotestapp_user` WHERE id="+ str(bus[4])
				userId = execute_sql(sql)[0][0]
				process.append(str(userId))
			if bus[3]:
				bus3 = bus[3].split(",")
				bus3.sort()
				sql = "SELECT a.varName FROM `autotestapp_data` a INNER JOIN `autotestapp_business_params` b  WHERE a.id=b.data_id AND b.business_id=" + str(
					bus[0])
				params = list(execute_sql(sql))
				params.sort()
				for i in range(len(bus3)):
					index = bus3.index(bus[3].split(",")[i])
					process.append("${" + params[index][0] + "}")
			process_list.append(process)
		for process in process_list:
			string = "    ".join(process)
			content.append("    " + string + "\n")
		return content

