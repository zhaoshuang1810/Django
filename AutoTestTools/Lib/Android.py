# coding=utf-8
import shutil
from PIL import Image
from skimage.measure import compare_ssim
import imutils
import cv2
from Conf.Properties import location_table
import xlrd
import re,os


class Android(object):
	_sheet_name = "Sheet1"
	_Title = ['locationID', 'method', 'location', 'documentation', 'page', 'remark']

	def __init__(self):
		pass

	def get_location(self, locationid, text=None):
		workbook = xlrd.open_workbook(location_table)
		sheet = workbook.sheet_by_name(self._sheet_name)
		row = sheet.col_values(0).index(locationid)
		method = sheet.cell_value(row, self._Title.index("method"))
		location = sheet.cell_value(row, self._Title.index("location"))
		if text:
			pattern = "({.+?})"
			location = re.sub(pattern, text, location)
		values = [method, location]
		return "=".join(values)

	def screenShot(self, image_path, start_x, start_y, end_x, end_y):
		u'''
		在image图上，根据坐标截图
		:param start_x:
		:param start_y:
		:param end_x:
		:param end_y:
		:return:
		'''
		box = (start_x, start_y, end_x, end_y)
		image = Image.open(image_path)
		newImage = image.crop(box)
		newImage.save(image_path)
		return self

	def copyImage(self, image, dirPath, imageName, form="png"):
		u'''
		将截屏文件image,复制到指定目录下
		:param dirPath:
		:param imageName:
		:param form:
		:return:
		'''
		if not os.path.isdir(dirPath):
			os.makedirs(dirPath)
		shutil.copyfile(image, os.path.join(dirPath, str(imageName) + "." + form))

	def compareImages(self, image_1, image_2, dirPath="", imageName="result", form="png"):
		u'''
		比较两张图片，将比较的结果图片存放到对应目录
		:param image_1:
		:param image_2:
		:param dirPath:
		:param imageName:
		:param form:
		:return:
		'''
		# 加载两张图片并将他们转换为灰度：
		image1 = cv2.imread(image_1)
		image2 = cv2.imread(image_2)
		# 获取图的大小
		sp = image1.shape
		h = sp[0]
		w = sp[1]
		# 设置成同等大小
		imageA = cv2.resize(image1, (w, h), interpolation=cv2.INTER_CUBIC)
		imageB = cv2.resize(image2, (w, h), interpolation=cv2.INTER_CUBIC)

		grayA = cv2.cvtColor(imageA, cv2.COLOR_BGR2GRAY)
		grayB = cv2.cvtColor(imageB, cv2.COLOR_BGR2GRAY)
		# 计算两个灰度图像之间的结构相似度指数
		(score, diff) = compare_ssim(grayA, grayB, full=True)
		diff = (diff * 255).astype("uint8")
		# print("SSIM:{}".format(score))
		# 找到不同点的轮廓以致于我们可以在被标识为“不同”的区域周围放置矩形
		thresh = cv2.threshold(diff, 0, 255, cv2.THRESH_BINARY_INV | cv2.THRESH_OTSU)[1]
		cnts = cv2.findContours(thresh.copy(), cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
		cnts = cnts[0] if imutils.is_cv2() else cnts[1]
		# 找到一系列区域，在区域周围放置矩形
		for c in cnts:
			(x, y, w, h) = cv2.boundingRect(c)
			cv2.rectangle(imageA, (x, y), (x + w, y + h), (0, 0, 255), 2)
			cv2.rectangle(imageB, (x, y), (x + w, y + h), (0, 0, 255), 2)
		# 用cv2.imshow 展现最终对比之后的图片， cv2.imwrite 保存最终的结果图片
		# cv2.imshow("Modifieda", imageA)
		# cv2.imshow("Modifiedb", imageB)
		cv2.imwrite(os.path.join(dirPath,  str(imageName) + "_1." + form) , imageA)
		cv2.imwrite(os.path.join(dirPath,  str(imageName) + "_2." + form) , imageB)
		cv2.waitKey(0)
		return float(score)

	def __del__(self):
		pass


if __name__ == '__main__':
	print (Android().get_location("location004"))
