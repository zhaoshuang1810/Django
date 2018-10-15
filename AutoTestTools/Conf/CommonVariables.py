# coding=utf-8
from Lib.PrivateMethod import *
from Lib.GetSQL import *

sql_varibles = ["userId", "nickName", "headImageUrl", "examTypeId", "examTypeName", "parentName", "subjectId",
				"subjectName", "examTimeInfo", "chapterId","levelId","levelNum"]


userId = str(130395)
sql = GetSQL().table_user(userId)
nickName = sql['nick_name']
headImageUrl = sql['head_image_url']

sql = GetSQL().table_relation_user_exam_type(userId)
examTypeName = sql['secondary_categories']
examTypeId = sql['exam_type_id']
subjectId = sql['subject_id']
levelId = sql['level_id']

sql = GetSQL().table_exam_type(exam_type_id=examTypeId)
parentName = sql['primary_categories']

sql = GetSQL().table_subject(subject_id=subjectId)
subjectName = sql['subject_name']

sql = GetSQL().table_level(level_id=levelId)
levelNum = sql['level_num']

sql = GetSQL().table_exam_time(exam_type_id=examTypeId)
examTimeInfo = PrivateMethod().examTimeInfo(sql['begain_date'],sql['end_date'])

sql = GetSQL().table_chapter(subject_id=subjectId)
chapterId = sql['id'][0]

