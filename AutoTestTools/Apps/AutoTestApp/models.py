# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models
from django.contrib.auth.models import User as AUser


# Create your models here.


class Tag(models.Model):
	id = models.AutoField(primary_key=True)
	tagName = models.CharField(max_length=30, verbose_name="标签名称", unique=True)
	documentation = models.TextField(verbose_name="标签描述")
	del_flag = models.IntegerField(default=0, editable=False)

	class Meta:
		verbose_name = "用例标签"
		verbose_name_plural = verbose_name
		ordering = ['tagName']

	def __str__(self):
		return self.tagName


class Data(models.Model):
	id = models.AutoField(primary_key=True)
	varName = models.CharField(max_length=30, verbose_name="变量名称", unique=True)
	value = models.CharField(max_length=60, verbose_name="变量值", help_text="a：代表普通变量; a,b,c,d：代表数组; a=1,b=2,c=3：代表字典")
	documentation = models.TextField(verbose_name="变量描述", blank=True)
	chanel_list = [
		(0, "从PY文件中导入变量"),
		(1, "直接手动输入变量值")
	]
	chanel = models.IntegerField(verbose_name="变量位置", choices=chanel_list, default=1, editable=True)
	del_flag = models.IntegerField(default=0, editable=False)

	class Meta:
		verbose_name = "用例参数"
		verbose_name_plural = verbose_name
		ordering = ['varName']

	def __str__(self):
		return self.varName + "=" + self.value


class Business_basic(models.Model):
	id = models.AutoField(primary_key=True)
	name = models.CharField(max_length=30, verbose_name="业务名称", unique=True)
	nameEn = models.CharField(max_length=30, verbose_name="英文名称", unique=True, help_text="英文名称，执行用例时用")
	params = models.CharField(max_length=60, verbose_name="参数", blank=True, help_text="参数个数，参数类型……")
	documentation = models.TextField(verbose_name="业务描述", blank=True, help_text="业务实现的功能")
	del_flag = models.IntegerField(default=0, editable=False)

	class Meta:
		verbose_name = "基础业务"
		verbose_name_plural = verbose_name
		ordering = ['name']

	def doc(self):
		if len(str(self.documentation)) > 60:
			return "{}......".format(str(self.documentation)[0:60])
		else:
			return str(self.documentation)

	def __str__(self):
		return self.name + " " + self.params


class User(models.Model):
	id = models.AutoField(primary_key=True)
	userId = models.IntegerField(verbose_name="用户ID", unique=True)
	name = models.CharField(max_length=16, verbose_name="用户名称")
	reqchannel = models.CharField(max_length=30, choices=(("MASTER", "轻题库"), ("MANGO_ACCOUNTING", "芒果会计")),
								  default="MASTER", verbose_name="所在渠道")
	token = models.TextField(verbose_name="用户Token")
	date = models.DateField(auto_now=True)
	del_flag = models.IntegerField(default=0, editable=False)

	class Meta:
		verbose_name = "用户信息"
		verbose_name_plural = verbose_name
		ordering = ['name']

	def __str__(self):
		return self.name + "_" + self.reqchannel


class Business(models.Model):
	id = models.AutoField(primary_key=True)
	user = models.ForeignKey(User, on_delete=models.CASCADE, verbose_name="执行者")
	bus_basic = models.ForeignKey(Business_basic, on_delete=models.CASCADE, verbose_name="业务名称")
	params = models.ManyToManyField(Data, verbose_name="输入参数名", blank=True, help_text="从参数列表中选择")
	sort = models.IntegerField(verbose_name="排序", default=999)
	date = models.DateField(auto_now=True)
	del_flag = models.IntegerField(default=0, editable=False)

	def data(self):
		params = [p.varName + "=" + p.value for p in self.params.all()]
		return ";\n".join(params)

	def bus(self):
		return [b.name for b in Business_basic.objects.filter(id=self.bus_basic_id)][0]

	def userinfo(self):
		return [u.name + "_" + u.reqchannel for u in User.objects.filter(id=self.user_id)][0]

	class Meta:
		verbose_name = "用例流程"
		verbose_name_plural = verbose_name
		ordering = ['user_id', 'bus_basic_id']

	def __str__(self):
		sql_b = Business_basic.objects.get(id=self.bus_basic_id)
		sql_u = User.objects.get(id=self.user_id)
		data = str(sql_u.userId) + "-" + sql_b.name + " "
		if self.data():
			return data + "(" + self.data() + ")"
		else:
			return data


class FunModule(models.Model):
	id = models.AutoField(primary_key=True)
	name = models.CharField(max_length=50, verbose_name="功能名称", unique=True)
	tag = models.CharField(max_length=50, verbose_name="标签名称", unique=True, help_text="输入英文")
	documentation = models.TextField(verbose_name="功能描述描述", blank=True)
	del_flag = models.IntegerField(default=0, editable=False)

	person = models.ForeignKey(AUser, verbose_name='功能负责人', blank=True, null=True)

	class Meta:
		verbose_name = "功能模块"
		verbose_name_plural = verbose_name
		ordering = ['name']

	def __str__(self):
		return self.name


class Case(models.Model):
	id = models.AutoField(primary_key=True)
	name = models.CharField(max_length=50, verbose_name="用例名称", unique=True)
	isrun = models.IntegerField(choices=((1, "执行"), (2, "不执行")), default=1, verbose_name="是否执行")
	tags = models.ManyToManyField(Tag, blank=True, verbose_name="用例标签")
	business = models.ManyToManyField('Business', verbose_name="用例流程", blank=True)
	documentation = models.TextField(verbose_name="用例描述", blank=True)
	sort = models.IntegerField(verbose_name="排序", default=999)
	date = models.DateField(auto_now=True)
	del_flag = models.IntegerField(default=0, editable=True)

	writer = models.ForeignKey(AUser, on_delete=models.CASCADE, blank=True, null=True)
	funmodule = models.ForeignKey(FunModule, on_delete=models.CASCADE, verbose_name="功能模块")

	def doc(self):
		if len(str(self.documentation)) > 60:
			return "{}......".format(str(self.documentation)[0:60])
		else:
			return str(self.documentation)

	def allTags(self):
		return ",".join([t.tagName for t in self.tags.all()])

	def caseid(self):
		return 'TestCase' + str(self.id).zfill(3)

	class Meta:
		verbose_name = "测试用例"
		verbose_name_plural = verbose_name
		ordering = ['funmodule', 'sort']

	def __str__(self):
		return self.name
