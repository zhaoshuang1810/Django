# coding=utf-8
import os
import shutil
import time
from Conf.Properties import media_dir


def copy_result(channel, file_name):
	time_str = time.strftime('%Y%m%d_%H%M%S', time.localtime(time.time()))
	dir_path_1 = os.path.join(media_dir, 'results')
	dir_path_2 = os.path.join(media_dir, 'history', channel + '_result_' + time_str)
	dir_1 = os.path.join(dir_path_1, file_name)
	dir_2 = os.path.join(dir_path_2, file_name)

	if not os.path.isfile(dir_1):
		print("%s not exist!" % (dir_1))
	else:
		if not os.path.exists(dir_path_2):
			os.makedirs(dir_path_2)  # 创建路径
		shutil.copyfile(dir_1, dir_2)  # 复制文件
		print("copy %s -> %s" % (dir_1, dir_2))


def run_robot_cmd(**kwargs):
	file_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "RunCase")
	suite = kwargs.get("suites", "/test/test.robot")
	include_tag = kwargs.get("include", "")
	exclude_tag = kwargs.get("exclude", "")
	if exclude_tag:
		exclude_tag = "NotRun," + exclude_tag
	else:
		exclude_tag = "NotRun"

	suites = list(filter(None, suite.split("/")))
	for s in suites:
		file_dir = os.path.join(file_dir, s)

	def _get_tag_str(tag, param_name):
		tag_str = ""
		if tag:
			tags = tag.split(",")
			for t in tags:
				if t:
					tag_str = tag_str + "--" + param_name + " " + t + " "
		return tag_str

	include = _get_tag_str(include_tag, "include")
	exclude = _get_tag_str(exclude_tag, "exclude")

	cmd = "python3 -m  robot.run -d " + os.path.join(media_dir, "results") + " " + exclude + include + file_dir
	print(cmd)
	os.system(cmd)
	# 保存报告
	copy_result(suites[0], "log.html")
	copy_result(suites[0], "report.html")


if __name__ == '__main__':
	print(1)
