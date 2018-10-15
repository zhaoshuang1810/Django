# -*- coding: utf-8 -*-
from __future__ import unicode_literals

import json
import os
import shutil

from django.http import HttpResponse
from django.shortcuts import render

# Create your views here.
import run_cmd
from AutoTestApp.models import Case
from AutoTestApp.models import Tag
from AutoTestTools.mysql import get_sql_data
from Conf.Properties import case_dir, media_dir
from Util.CreateTestCases import CreateTestCases
from Util.RFMethodName import CaseName


def search_keywords(data, **kwargs):
	data1 = data
	data2 = []
	if kwargs.get('keyword_name', ""):
		for d in data1:
			if kwargs['keyword_name'] in d[1]:
				data2.append(d)
		data = data2

	data1 = data
	data2 = []
	if kwargs.get('keyword_tag', ''):
		for d in data1:
			if kwargs['keyword_tag'] in d[4]:
				data2.append(d)
		data = data2
	return data


def index(request):
	return render(request, 'index.html')


def test(request):
	selectChannel = request.GET.get('channel')
	if not selectChannel:
		selectChannel = "API"
	case_names = CaseName().get_case_name(case_dir)
	data = case_names.get(selectChannel, "")
	channel = [("1", "API"), ("2", "GUI"), ("3", "API_Doc")]
	return render(request, 'test.html', {'data': data, "channel": channel, "selectChannel": selectChannel})


def run_case(request):
	selectChannel = request.GET.get('channel')
	suitename = request.GET.get('suitename')
	run_cmd.run_robot_cmd(suites=selectChannel + "/" + suitename + ".robot")
	resp = {"success": True}
	return HttpResponse(json.dumps(resp), content_type="application/json")


def run_tagcase(request):
	selectChannel = request.GET.get('channel')
	include = request.GET.get('include')
	exclude = request.GET.get('exclude')
	print(include,exclude)
	run_cmd.run_robot_cmd(suites=selectChannel, include=include, exclude=exclude)
	resp = {"success": True}
	return HttpResponse(json.dumps(resp), content_type="application/json")


def case(request):
	tags = [(t.id,t.tagName) for t in Tag.objects.all().order_by('tagName')]
	tags.insert(0,('0',""))
	keyword_name = request.GET.get("keyword_name")
	keyword_tag = request.GET.get("keyword_tag")
	data = search_keywords(get_sql_data(), keyword_name=keyword_name, keyword_tag=keyword_tag)
	return render(request, 'case.html', {'data': data,"tags":tags})


def del_data(request):
	del_num = request.GET.get("del")
	Case.objects.filter(id=del_num).update(del_flag=1)

	resp = {"success": True}
	return HttpResponse(json.dumps(resp), content_type="application/json")


def sort(request):
	id = request.GET.get('id')
	sort = request.GET.get('sort')
	Case.objects.filter(id=id).update(sort=sort)
	resp = {"success": True}
	return HttpResponse(json.dumps(resp), content_type="application/json")


def create_case(request):
	channel = request.GET.get("channel")
	create_nums = request.GET.get('create')
	if create_nums:
		case_ids = create_nums.split(",")
		CreateTestCases(case_ids, client=channel).new_cases()
		run_cmd.run_robot_cmd()
	resp = {"success": True, "create": create_nums, "channel": channel}
	return HttpResponse(json.dumps(resp), content_type="application/json")


def save_case(request):
	channel = request.GET.get("channel")
	suitename = request.GET.get('suitename')

	dir_path_1 = os.path.join(case_dir, "test")
	dir_path_2 = os.path.join(case_dir, channel)
	dir_1 = os.path.join(dir_path_1, "test.robot")
	dir_2 = os.path.join(dir_path_2, suitename)

	if not os.path.isfile(dir_1):
		print("%s not exist!" % (dir_1))
	else:
		if not os.path.exists(dir_path_2):
			os.makedirs(dir_path_2)  # 创建路径
		shutil.copyfile(dir_1, dir_2)  # 复制文件
		print("copy %s -> %s" % (dir_1, dir_2))

	resp = {"success": True}
	return HttpResponse(json.dumps(resp), content_type="application/json")


def historyreport(request):
	for root, dirs, files in os.walk(os.path.join(media_dir,'history')):
			folder = dirs
			break
	folder.sort(reverse=True)
	return render(request, 'historyreport.html', {'data': folder}, locals())
