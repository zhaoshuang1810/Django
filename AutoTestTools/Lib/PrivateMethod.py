# coding=utf-8
import datetime
import random
import time

from Lib.Function import Function
from Lib.GetSQL import GetSQL


class PrivateMethod(object):
	def __init__(self):
		pass

	def parser_examtype(self,text):
		text = text.split(">")
		resp = []
		for t in text:
			t = t.strip()
			if "..." in t:
				t = t.replace("...","")
			resp.append(t)
		return resp

	def addDay(self, day):
		u'''
		在当前时间上加上天数，返回字符串，接口/learningPlan/dailySurvey的参数
		:param day: 14
		:return:2018年10月01日
		'''
		day = int(day)-1
		now = datetime.datetime.now()
		delta = datetime.timedelta(days=day)
		n_days = now + delta
		a = n_days.strftime('%Y-%m=%d')
		b= a.replace("-", '年').replace("=", "月") + "日"
		return b

	def getCurrentLearnplanSubjectIds(self, planSubjectInfo):
		u'''
		根据查看学习计划信息接口返回值，获取 科目类型
		:param respinfo:
		:return:
		'''
		subjectIds = []
		for sub in planSubjectInfo:
			subjectIds.append(str(sub['subjectId']))
		return ",".join(subjectIds)

	def getSubjectInExamtype(self, examtypeid, subjcets):
		u'''
		获取参数中每一个科目的id，同时判断是否是当前考试类型下
		:param subjcets: list
		:return:
		'''
		subjcets_list = []
		subjcets_error = []
		for name in subjcets:
			result = GetSQL().table_subject(exam_type_id=examtypeid, subject_name=name)
			s_id = result['id']
			if s_id:
				subjcets_list.append(str(s_id))
			else:
				subjcets_error.append(name)
		return ",".join(subjcets_list), ",".join(subjcets_error)

	def changeExamtimeStr(self, examTime):
		u'''
		将学习计划中返回的时间字符串，转换成****年**月
		:param examTime:  2018-10-01 09:00:00
		:return:
		'''

		time_list = examTime.split("-")

		return time_list[0] + "年" + time_list[1] + "月"

	def typeEnToZh(self, **kwargs):
		examtype_id = kwargs.get("exam", "")
		subjecttype_id = kwargs.get("subject", "")

	def typeZhToEn(self, **kwargs):
		u'''
		将中文的二级考试类型，科目类型转换成id
		:param kwargs: exam=公共课（本）  subject=中国近现代史纲要
		:return:
		'''
		examtype = kwargs.get("exam", "")
		subjecttype = kwargs.get("subject", "")
		examtypeId = 0
		subjecttypeId = 0
		if examtype:
			result = GetSQL().table_exam_type(exam_type_name=examtype)
			examtypeId = result['id']
			if subjecttype:
				result = GetSQL().table_subject(exam_type_id=examtypeId, subject_name=subjecttype)
				subjecttypeId = result['id']
			else:
				result = GetSQL().table_subject(exam_type_id=examtypeId)
				subjecttypeId = result['id'][0]
		return examtypeId, subjecttypeId

	def getQuestionAnswer(self, examQuestion, answer):

		def getAnswerDesc(examQuestion0, answer0):
			questionType = examQuestion0['questionType']
			correctAnswer = examQuestion0['answer']['correctAnswer']
			correctAnswer = ",".join(list(filter(None, correctAnswer.split(","))))
			answerDescs = []
			for option in examQuestion0['options']:
				answerDescs.append(option['option'])

			answerDesc = ""
			try:
				answer0 = int(answer0)
				if answer0 > 0:
					answerDesc = correctAnswer
				elif answer0 < 0:
					if questionType == "MULTIPLE_ANSWER":
						i = 0
						while i < 5:
							answerDesc = ",".join(Function().getRandomList(answerDescs))
							if answerDesc != correctAnswer:
								break
					else:
						answerDescs.remove(correctAnswer)
						answerDesc = random.choice(answerDescs)
				else:
					if questionType == "MULTIPLE_ANSWER":
						answerDesc = ",".join(Function().getRandomList(answerDescs))
					else:
						answerDesc = random.choice(answerDescs)
			except:
				answerDesc = answer0
			return answerDesc

		questions = []
		q_num = len(examQuestion)
		if isinstance(answer,int):
			answer = list(str(answer))
		else :
			answer = list(answer)
		a_num = len(answer)
		duration_sum = 0
		for num in range(q_num):
			answerDate = int(time.time()) * 1000
			duration = random.randint(1, 10)
			duration_sum += duration
			question = {"questionId": examQuestion[num]['questionId'], "answerDate": answerDate, "duration": duration}
			if num < a_num:
				answerDesc = getAnswerDesc(examQuestion[num], answer[num])
			else:
				answerDesc = getAnswerDesc(examQuestion[num], answer[a_num - 1])
			question['answerDesc'] = answerDesc

			questions.append(question)
		return questions, duration_sum

	def examTimeInfo(self, begin_date, end_date):
		now = datetime.datetime.now()
		now = now.date()

		def formatting(begin_date):
			begin_date = str(begin_date).split(".")[0]
			begin = datetime.datetime.strptime(begin_date, "%Y-%m-%d")
			begin = begin.date()

			list_begin = begin_date.split("-")
			list_begin.insert(1, u'年')
			list_begin.insert(3, u'月')
			list_begin.insert(5, u'日')
			begin_str = "".join(list_begin)
			return begin, begin_str

		begin, begin_str = formatting(begin_date)
		end, end_str = formatting(end_date)

		data = {'examDate': '', 'intervalDays': '', 'examType': ''}

		if now < begin:
			data['examDate'] = begin_str
			intervalDays = begin - now
			data['intervalDays'] = intervalDays.days
			data['examType'] = "WAITING"
		elif now > end:
			pass
		else:
			data['examDate'] = end_str
			intervalDays = end - now
			data['intervalDays'] = intervalDays
			data['examType'] = "NOW"
		return data

	def getPkScore(self, correct, answer, duration, isLast):
		u'''
		通过答题时间的长短，返回获得的分数
		'''
		if correct == answer:
			if 0 <= int(duration) <= 2:
				score = 10
			elif 2 < int(duration) <= 4:
				score = 8
			elif 4 < int(duration) <= 6:
				score = 6
			elif 6 < int(duration) <= 8:
				score = 4
			elif 8 < int(duration) <= 10:
				score = 2
			else:
				score = 0

			if isLast:
				score *= 2
		else:
			score = 0
		return score

	def getPKresult(self, scorelist1, scorelist2):
		u'''
		根据每题得分，判断PK结果
		'''
		scorelist1 = list(scorelist1)
		scorelist2 = list(scorelist2)
		sum1 = 0
		sum2 = 0
		for x in range(len(scorelist1) - 1):
			sum1 += scorelist1[x]
			sum2 += scorelist2[x]
		if sum1 <= sum2:
			sum1 += scorelist1[-1]
			sum2 += scorelist2[-1]
			if sum1 > sum2:
				result = "FINAL_HIT"
			elif sum1 == sum2:
				result = "DRAW"
			else:
				result = "LOSE"
		else:
			sum1 += scorelist1[-1]
			sum2 += scorelist2[-1]
			if sum1 > sum2:
				if sum1 - sum2 <= 2:
					result = "WIN_MARGIN"
				else:
					result = "WIN"
			elif sum1 == sum2:
				result = "DRAW"
			else:
				result = "LOSE"
		return result

	def getPKGranding(self, beforeGrading, beforeStar, results):
		u'''
		通过pk前的段位及星星数量和pk结果，获取当前的段位名称，星星数量
		'''
		grading = (u'黑铁', u'青铜', u'白银', u'黄金', u'铂金', u'钻石', u'星耀', u'王者')
		star = (1, 2, 3, 5, 7, 9, 12, 100)

		if str(results) in ("WIN", "WIN_MARGIN", "FINAL_HIT"):
			pkstar = int(beforeStar) + 1
		elif str(results) == "LOSE":
			pkstar = int(beforeStar) - 1
		elif str(results) == "DRAW":
			pkstar = int(beforeStar)
		else:
			pkstar = int(beforeStar)

		index = grading.index(beforeGrading)
		if pkstar < 0:
			pkgrading = beforeGrading
			pkstar = 0
		elif pkstar == star[index]:
			pkgrading = grading[index + 1]
			pkstar = 0
		else:
			pkgrading = beforeGrading

		data = {"pkgrading": pkgrading, "pkstar": pkstar}
		return data

	def getApmTile(self, title_int):
		u'''
		根据title的int值，返回对应的汉字
		:param title_int:
		:return:
		'''
		title_int = int(title_int)
		title = ""
		if title_int == 1:
			title = u"玉女无痕手"
		elif title_int == 2:
			title = u"兰花拂穴手"
		elif title_int == 3:
			title = u"隔空点穴手"
		elif title_int == 4:
			title = u"葵花点穴手"
		else:
			print(u"暂时还没有称号")

		return title

	def getApmFinal(self, pointSum):
		u'''
		根据点击次数返回获得题量和称号
		:param pointSum: 点击次数
		:return:
		'''
		final = {"pointSum": pointSum}
		pointSum = int(pointSum)
		if pointSum == 0:
			final['question'] = 0
		elif 0 < pointSum < 10:
			final['question'] = 5
		elif 10 <= pointSum < 20:
			final['question'] = 10
		elif 20 <= pointSum < 30:
			final['question'] = 15
		elif 30 <= pointSum < 45:
			final['question'] = 20
		elif 45 <= pointSum < 60:
			final['question'] = 25
		elif 60 <= pointSum < 80:
			final['question'] = 30
		else:
			final['question'] = 35

		if 0 <= pointSum < 40:
			final['title'] = u"玉女无痕手"
		elif 40 <= pointSum < 60:
			final['title'] = u"兰花拂穴手"
		elif 60 <= pointSum < 100:
			final['title'] = u"隔空点穴手"
		else:
			final['title'] = u"葵花点穴手"

		return final

	def getQuestion(self, qtype, options, method):
		u'''
		返回要回答得选项
		:param qtype:  题目类型
		:param options: 选项
		:param method: 0:随机/整数：正确/负数：错误
		:return:
		'''
		resp = ""
		if qtype == 'SINGLE_ANSWER' or qtype == 'JUDGE_ANSWER':
			keys = options.keys()
			if method == 0:
				resp = random.choice(keys)
			elif method > 0:
				for key in keys:
					if options[key]:
						resp = key
						break
			else:
				for key in keys:
					if options[key]:
						pass
					else:
						resp = key
						break
		elif qtype == 'MULTIPLE_ANSWER':
			answer = []
			keys = options.keys()
			if method == 0:
				n = random.randint(1, int(len(keys)))
				for i in range(n):
					re = random.choice(keys)
					if re in answer:
						pass
					else:
						answer.append(re)
			elif method > 0:
				for key in keys:
					if options[key]:
						answer.append(key)
			else:
				for key in keys:
					if options[key]:
						pass
					else:
						answer.append(key)
			answer.sort()
			resp = ",".join(answer)
		else:
			print("qtype is not in ['SINGLE_ANSWER','JUDGE_ANSWER','MULTIPLE_ANSWER']")

		return resp

	def signIn_getCount(self, day):
		u'''
		根据打卡的天数获取轻豆数
		:param day:第几天签到
		:return:
		'''
		add = [1, 1, 2, 2, 4, 5, 7]
		count = add[int(day) - 1]
		return count


if __name__ == '__main__':

	print(1111)
