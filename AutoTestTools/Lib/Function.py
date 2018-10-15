# coding=utf-8

from datetime import timedelta
from datetime import datetime
import time
import random
import os
import shutil


class Function(object):
	def __init__(self):
		pass

	def movefile(self, srcfile, dstfile):
		u'''
		移动文件
		:param srcfile: 全路径文件
		:param dstfile:
		:return:
		'''
		if not os.path.isfile(srcfile):
			print ("%s not exist!" % (srcfile))
		else:
			fpath, fname = os.path.split(dstfile)  # 分离文件名和路径
			if not os.path.exists(fpath):
				os.makedirs(fpath)  # 创建路径
			shutil.move(srcfile, dstfile)  # 移动文件
			print ("move %s -> %s" % (srcfile, dstfile))

	def copyfile(self, srcfile, dstfile):
		u'''
		复制文件
		:param srcfile:
		:param dstfile:
		:return:
		'''
		if not os.path.isfile(srcfile):
			print ("%s not exist!" % (srcfile))
		else:
			fpath, fname = os.path.split(dstfile)  # 分离文件名和路径
			if not os.path.exists(fpath):
				os.makedirs(fpath)  # 创建路径
			shutil.copyfile(srcfile, dstfile)  # 复制文件
			print ("copy %s -> %s" % (srcfile, dstfile))

	def deletefile(self, srcfile):
		u'''
		删除文件
		:param srcfile:
		:return:
		'''
		if not os.path.isfile(srcfile):
			print ("%s not exist!" % (srcfile))
		else:
			shutil.rmtree(srcfile)  # 删除文件
			print ("delete %s" % srcfile)

	def convertSeconds(self,minutes):
		u'''
		将分钟转换成秒
		:param minutes:
		:return:
		'''
		minutes = str(minutes)
		list1 = minutes.split("\'")
		seconds = int(list1[0]) * 60 + int(list1[1])
		return seconds

	def convertTimestamp(self, data):
		u'''
		将时间转换成时间戳
		'''
		# 转换成时间数组
		timeArray = time.strptime(data, "%Y-%m-%d %H:%M:%S")
		# 转换成时间戳
		timestamp = int(time.mktime(timeArray)*1000)
		return timestamp

	def convertTimestr(self, timestamp):
		u'''
		将时间戳转换成时间字符串,北京时间
		'''
		utc_time = datetime.utcfromtimestamp(timestamp/1000)
		timeStr = utc_time + timedelta(hours=8)
		return timeStr

	def _convertZone(self,timestamp):
		time_stamp = timestamp/1000
		loc_time = time.localtime(time_stamp)
		time1 = time.strftime("%Y-%m-%d %H:%M:%S", loc_time)
		print(time1)
		utc_time = datetime.utcfromtimestamp(time_stamp)
		time2 = utc_time + timedelta(hours=8)
		print(time2)

	def getPercent(self, num, sum, n):
		u'''
		返回百分数，四舍五入到小数点后n位
		:param num:分子
		:param sum:分母
		:param n:小数点后几位，如果位0，返回整数
		:return:
		'''
		num = int(num)
		sum = int(sum)
		n = int(n)
		if num == 0:
			return 0
		elif sum == 0:
			return 0
		else:
			num = float(num)
			sum = float(sum)
			rate = round(num * 100 / sum, n)
			if n==0:
				rate = int(rate)
			return rate

	def getPercentUp(self, num, sum):
		u'''
		返回百分数,向上取整
		:param num:
		:param sum:
		:return:
		'''
		num = int(num)
		sum = int(sum)
		if num == 0:
			return 0
		elif sum==0:
			return 0
		else:
			rate = num * 100 / sum
			return rate+1

	def getPercentDown(self, num, sum):
		u'''
		返回百分数,向下取整
		:param num:
		:param sum:
		:return:
		'''
		num = int(num)
		sum = int(sum)
		if num == 0:
			return 0
		elif sum==0:
			return 0
		else:
			rate = num * 100 / sum
			return rate

	def getRandomInt(self, num1, num2):
		u'''
		获取num1到num2的随机整数,包含上下限
		'''
		return random.randint(int(num1), int(num2))

	def getRandomChar(self, string, num):
		u'''
		在字符串string中获取num个字符，返回值为list
		'''
		return random.sample(string, num)

	def getRandomStr(self, listn):
		u'''
		在listn中随机获取其中一个字符串，返回string
		'''
		return random.choice(listn)

	def getRandomList(self, listn):
		u'''
		在listn中随机获取多个元素，返回list
		'''
		re_list = []
		l = len(listn)
		if l>0:
			n = self.getRandomInt(1,l)
			for i in range(n):
				ele = random.choice(listn)
				if ele in re_list:
					pass
				else:
					re_list.append(ele)
		return re_list

	def contain_zh(self, word):
		u'''
		判断word中是否有中文
		:return:
		'''
		import re
		zh_pattern = re.compile(u'[\u4e00-\u9fa5]+')
		word = word.decode("utf-8")
		match = zh_pattern.search(word)
		# if match:
		# 	zh = re.findall(zh_pattern, word)
		# 	for c in zh:
		# 		word = word.replace(c, "zhongwen")
		return match

if __name__ == '__main__':
	f = Function()
	f.convertZone(1532540222000)

