# coding=utf-8
import datetime
import re

from Util.MySQL import *
import json


class GetSQL(object):
	def __init__(self):
		pass

	def get_type_id(self, exam_type=None, subject=None):
		u'''
		根据给定的汉字，获取对应的考试类型或科目类型id
		:param exam_type:
		:param subject:
		:return:
		'''
		mysql = MySQL()
		sql = {}
		if exam_type:
			fields = "id"
			query = "SELECT " + fields + " FROM `exam_type` WHERE primary_categories='" + exam_type + "'"
			print(query)
			result = mysql.getAllRow(query)
			self._getSqlDict(sql, fields, result)
			sql["exam_type_id"] = sql['id']

		if subject:
			fields = "id"
			query = "SELECT " + fields + " FROM `subject` WHERE subject_name='" + subject + "'"
			print(query)
			result = mysql.getAllRow(query)
			self._getSqlDict(sql, fields, result)
			sql["subject_id"] = sql['id']
		sql.pop("id")
		print(sql)
		return sql

	def update_learning_plan_daily_To_compliance(self, user_id, **kwargs):
		mysql = MySQL()
		sql = {}

		string = ""
		if 'exam_type_id' in list(kwargs.keys()):
			string = string + " AND exam_type_id=" + str(kwargs['exam_type_id'])
		if "subject_id" in list(kwargs.keys()):
			string = string + " AND subject_id=" + str(kwargs['subject_id'])

		fields = "id,compliance"
		query = "SELECT " + fields + " FROM `learning_plan_daily` WHERE DATE_FORMAT(create_date,'%Y%m%d') = DATE_FORMAT(NOW(),'%Y%m%d') AND user_id=" + str(
			user_id) + string
		print(query)
		count = mysql.getRowCount(query)
		print('count = ', count)
		if count > 0:
			result = mysql.getAllRow(query)
			self._getSqlDict(sql, fields, result)
			for i in range(len(sql['id'])):
				if ord(sql['compliance'][i]) > 0:
					query = "UPDATE `learning_plan_daily` SET compliance=0,answer_sum=0,correct_answer_sum=0 WHERE id=" + str(
						sql['id'][i])
					print(query)
					mysql.editData(query)
		print("MySQL update success！")

	def update_user_clock_in_To_details(self, user_id, **kwargs):
		mysql = MySQL()
		sql = {}

		string = ""
		if 'exam_type_id' in list(kwargs.keys()):
			string = string + " AND exam_type_id=" + str(kwargs['exam_type_id'])
		if "subject_id" in list(kwargs.keys()):
			string = string + " AND subject_id=" + str(kwargs['subject_id'])

		fields = "id,clock_in_details"
		query = "SELECT " + fields + " FROM `user_clock_in` WHERE DATE_FORMAT(create_date,'%Y%m') = DATE_FORMAT(NOW(),'%Y%m') AND user_id=" + str(
			user_id) + string
		print(query)
		result = mysql.getAllRow(query)
		self._getSqlDict(sql, fields, result)
		for i in range(len(sql['id'])):
			id = sql['id'][i]
			clock_in_details = sql['clock_in_details'][i]
			index = re.search(str(datetime.datetime.now().day) + ":", clock_in_details).end()
			clock_in_details = clock_in_details[:index] + "2" + clock_in_details[index + 1:]
			query = "UPDATE `user_clock_in` SET clock_in_details='" + clock_in_details + "' WHERE id=" + str(
				id) + " AND user_id=" + str(user_id)
			print(query)
			mysql.editData(query)
		print("MySQL update success！")

	def update_assist_detail_To_del_flag(self, user_id):
		mysql = MySQL()
		query = "UPDATE `assist_detail` SET del_flag=1 WHERE self=0 AND  TO_DAYS(create_date) = TO_DAYS(NOW())AND user_id=" + str(
			user_id)
		print(query)
		mysql.editData(query)
		print("MySQL update success！")

	def update_learning_plan_To_del_flag(self, user_id, exam_type_id):
		mysql = MySQL()
		query = "UPDATE `learning_plan` SET del_flag=1 WHERE del_flag=0 AND user_id=" + str(
			user_id) + " AND exam_type_id=" + str(exam_type_id)
		print(query)
		mysql.editData(query)
		print("MySQL update success！")

	def update_commodity_cut_To_create_date(self, commodity_id, user_id_1, user_id_2):
		mysql = MySQL()
		query = "UPDATE `commodity_cut` SET create_date = DATE_SUB(create_date,INTERVAL '1 0:0:0' DAY_SECOND) WHERE TO_DAYS(create_date)= TO_DAYS(NOW()) AND commodity_id=" + str(
			commodity_id) + " AND launch_user_id=" + str(user_id_1) + " AND help_user_id=" + str(user_id_2)
		print(query)
		mysql.editData(query)
		print("MySQL update success！")

	def update_already_order_To_pay_status(self, pay_status):
		mysql = MySQL()
		query = "UPDATE `commodity_order` SET pay_status=" + str(pay_status) + " WHERE id=931"
		print(query)
		mysql.editData(query)
		print("MySQL update success！")
		query = "UPDATE `commodity_order_details` SET pay_status=" + str(pay_status) + " WHERE id=932"
		print(query)
		mysql.editData(query)
		print("MySQL update success！")

	def update_group_order_To_del_flag(self, user_id):
		mysql = MySQL()
		query = "UPDATE `group_order` SET del_flag=1 WHERE del_flag=0 AND create_by=" + str(user_id)
		print(query)
		mysql.editData(query)
		print("MySQL update success！")

	def update_group_order_To_status(self, id):
		mysql = MySQL()
		query = "UPDATE `group_order` SET `status`=10 WHERE id=" + str(id)
		print(query)
		mysql.editData(query)
		print("MySQL update success！")

	def table_user(self, user_id):
		mysql = MySQL()
		sql = {}
		fields = "head_image_url,nick_name,gender,location,phone_number,source"
		query = "SELECT " + fields + " FROM `user` WHERE del_flag=0 AND id=" + str(user_id)
		print(query)
		result = mysql.getFistRow(query)
		self._getSqlDict(sql, fields, result)
		if sql['location']:
			sql['location'] = sql['location'].split(":")
		print(sql)
		return sql

	def table_relation_user_exam_type(self, user_id, **kwargs):
		mysql = MySQL()
		sql = {}
		keys = kwargs.keys()
		fields = "exam_type_id,secondary_categories,user_integral,level_id,subject_id,dan_grading_id,current_star,pk_sum,win_sum"
		if "exam_type_id" in keys:
			condition = "user_id=" + str(user_id) + " AND exam_type_id=" + str(kwargs['exam_type_id'])
		else:
			condition = "current=1 AND user_id=" + str(user_id)
		query = "SELECT " + fields + " FROM `relation_user_exam_type` WHERE del_flag=0 AND " + condition
		print(query)
		result = mysql.getFistRow(query)
		self._getSqlDict(sql, fields, result)
		print(sql)
		return sql

	def table_exam_type(self, **kwargs):
		mysql = MySQL()
		sql = {}
		keys = kwargs.keys()
		if 'exam_type_id' in keys:
			fields = "primary_categories"
			query = "SELECT " + fields + " FROM `exam_type` WHERE id=(SELECT parent_id FROM `exam_type` WHERE id=" + str(
				kwargs['exam_type_id']) + ")"
			print(query)
			result = mysql.getFistRow(query)
			self._getSqlDict(sql, fields, result)
			sql['parent_primary_categories'] = sql['primary_categories']

			query = "SELECT " + fields + " FROM `exam_type` WHERE id=" + str(kwargs['exam_type_id'])
			print(query)
			result = mysql.getFistRow(query)
			self._getSqlDict(sql, fields, result)

		if 'exam_type_name' in keys:
			fields = "id"
			query = "SELECT " + fields + " FROM `exam_type` WHERE primary_categories='" + str(
				kwargs['exam_type_name']) + "'"
			print(query)
			result = mysql.getFistRow(query)
			self._getSqlDict(sql, fields, result)
		print(sql)
		return sql

	def table_exam_time(self, **kwargs):
		mysql = MySQL()
		sql = {}
		keys = kwargs.keys()
		if 'exam_type_id' in keys:
			fields = "begain_date,end_date,`year`"
			query = "SELECT " + fields + " FROM `exam_time` WHERE del_flag=0 AND begain_date>NOW() AND id IN (SELECT exam_time_id FROM `relation_exam_time_type` WHERE exam_type_id=" + str(
				kwargs['exam_type_id']) + ")"
			print(query)
			result = mysql.getFistRow(query)
			self._getSqlDict(sql, fields, result)
			sql['begain_date'] = str(sql['begain_date'])
			sql['end_date'] = str(sql['end_date'])
		print(sql)
		return sql

	def table_level(self, **kwargs):
		mysql = MySQL()
		sql = {}
		keys = kwargs.keys()
		fields = "level_num,min_integral,max_integral,level_name"
		if "level_id" in keys:
			query = "SELECT " + fields + " FROM `level` WHERE id=" + str(kwargs['level_id'])
			print(query)
			result = mysql.getFistRow(query)
			self._getSqlDict(sql, fields, result)
		print(sql)
		return sql

	def table_subject(self, **kwargs):
		mysql = MySQL()
		sql = {}
		keys = list(kwargs.keys())
		if "subject_id" in keys:
			fields = "subject_name"
			query = "SELECT " + fields + " FROM `subject` WHERE id=" + str(kwargs['subject_id'])
			print(query)
			result = mysql.getFistRow(query)
			self._getSqlDict(sql, fields, result)

		if "exam_type_id" in keys:
			fields = "id"
			query = "SELECT " + fields + " FROM `subject` WHERE exam_type_id=" + str(kwargs['exam_type_id'])
			print(query)
			result = mysql.getAllRow(query)
			self._getSqlDict(sql, fields, result)

		if "subject_name" in keys:
			fields = "id"
			if 'exam_type_id' in keys:
				query = "SELECT " + fields + " FROM `subject` WHERE subject_name='" + str(
					kwargs['subject_name']) + "' and exam_type_id=" + str(kwargs['exam_type_id'])
			else:
				query = "SELECT " + fields + " FROM `subject` WHERE subject_name='" + str(kwargs['subject_name']) + "'"
			print(query)
			result = mysql.getFistRow(query)
			self._getSqlDict(sql, fields, result)
		print(sql)
		return sql

	def table_dan_grading(self, **kwargs):
		mysql = MySQL()
		sql = {}
		keys = kwargs.keys()
		fields = "dan_grading_name,min_star,max_star,number,integral"
		if "dan_grading_id" in keys:
			query = "SELECT " + fields + " FROM `dan_grading` WHERE del_flag=0 AND id=" + str(kwargs['dan_grading_id'])
			print(query)
			result = mysql.getFistRow(query)
			self._getSqlDict(sql, fields, result)
		print(sql)
		return sql

	def table_user_cartogram(self, user_id, **kwargs):
		mysql = MySQL()
		sql = {}
		fields = "answer_ration,diligent,accuracy,duration_ratio,score_ratio,question_sum"
		query = "SELECT " + fields + " FROM `user_cartogram` WHERE user_id=" + str(user_id)
		print(query)
		result = mysql.getFistRow(query)
		self._getSqlDict(sql, fields, result)
		print(sql)
		return sql

	def table_exam_question(self, **kwargs):
		mysql = MySQL()
		sql = {}
		keys = kwargs.keys()
		fields = "id,question_type,question_desc,correct_answer,options_desc,correct_answer_desc"
		if "id" in keys:
			query = "SELECT " + fields + " FROM `exam_question` WHERE id=" + str(kwargs['id'])
			print(query)
			result = mysql.getFistRow(query)
			self._getSqlDict(sql, fields, result)
			sql['options_desc'] = json.loads(sql['options_desc'])

		if "chapter_id" in keys:
			query = "SELECT " + fields + " FROM `exam_question` WHERE del_flag=0 AND chapter_id=" + str(
				kwargs['chapter_id']) + " GROUP BY question_number ASC"
			print(query)
			result = mysql.getAllRow(query)
			self._getSqlDict(sql, fields, result)
			sql['options_desc'] = json.loads(sql['options_desc'])
		print(sql)
		return sql

	def table_pk_log(self, **kwargs):
		mysql = MySQL()
		sql = {}
		keys = kwargs.keys()
		fields = "win_user_id,pk_type,question_ids,surpass,head_img_urls"
		if "pk_log_id" in keys:
			query = "SELECT " + fields + " FROM `pk_log` WHERE id=" + str(kwargs['pk_log_id'])
			print(query)
			result = mysql.getFistRow(query)
			self._getSqlDict(sql, fields, result)
			if sql['question_ids']:
				sql['question_ids'] = sql['question_ids'].split(",")
			if sql['head_img_urls']:
				sql['head_img_urls'] = sql['head_img_urls'].split(",")
			if not sql['surpass']:
				sql['surpass'] = 0
		print(sql)
		return sql

	def table_relation_pk_share(self, **kwargs):
		mysql = MySQL()
		sql = {}
		keys = kwargs.keys()
		fields = "source_user_id,share_mark"
		if "pk_log_id" in keys:
			query = "SELECT " + fields + " FROM `relation_pk_share` WHERE pk_log_id=" + str(kwargs['pk_log_id'])
			print(query)
			result = mysql.getFistRow(query)
			self._getSqlDict(sql, fields, result)
		print(sql)
		return sql

	def table_chapter(self, **kwargs):
		mysql = MySQL()
		sql = {}
		fields = "id,question_sum,done_sum"
		if "id" in kwargs.keys():
			query = "SELECT " + fields + " FROM `chapter` WHERE id=" + str(kwargs['id'])
			print(query)
			result = mysql.getFistRow(query)
			self._getSqlDict(sql, fields, result)

		if "subject_id" in kwargs.keys():
			query = "SELECT " + fields + " FROM `chapter` WHERE del_flag=0 AND subject_id=" + str(
				kwargs['subject_id']) + " GROUP BY chapter_number ASC"
			print(query)
			result = mysql.getAllRow(query)
			self._getSqlDict(sql, fields, result)

		print(sql)
		return sql

	def table_chapter_practice_plan(self, user_id, **kwargs):
		mysql = MySQL()
		sql = {}
		keys = kwargs.keys()
		fields = "question_ids,schedule,step_sum,complete_question_sum"
		if "chapter_id" in keys:
			query = "SELECT " + fields + " FROM `chapter_practice_plan` WHERE del_flag=0 AND user_id=" + str(
				user_id) + " AND chapter_id=" + str(kwargs['chapter_id'])
			print(query)
			result = mysql.getFistRow(query)
			self._getSqlDict(sql, fields, result)
			sql['question_ids'] = sql['question_ids'].split(",")
		print(sql)
		return sql

	@staticmethod
	def _getSqlDict(sql, fields, result):
		listfields = fields.split(",")
		for i in range(len(listfields)):
			if "(" in listfields[i]:
				if "(*)" in listfields[i]:
					listfields[i] = listfields[i][:-3]
				else:
					listfields[i] = listfields[i].replace("(", "_")[:-1]
			if result == 0 or result[i] is None:
				sql[listfields[i]] = ""
			else:
				sql[listfields[i]] = result[i]
