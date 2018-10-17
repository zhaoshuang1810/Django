# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django import forms

import xadmin
from xadmin import views

# Register your models here.
from AutoTestApp.models import *
from xadmin.layout import Fieldset, Row


class GlobalSetting(object):
    # 设置base_site.html的Title
    site_title = '自动化测试'
    # 设置base_site.html的Footer
    site_footer = '轻题库'
    # menu_style = "accordion"


xadmin.site.register(views.CommAdminView, GlobalSetting)


class TagForm(forms.ModelForm):
    tags = forms.ModelMultipleChoiceField(
        queryset=Tag.objects.all(),
        widget=forms.CheckboxSelectMultiple(),
        label="用例标签",
        initial="3",
        required=False)

    class Meta:
        model = Case
        # 规定哪些字段不想加入表单中
        exclude = []


@xadmin.sites.register(Case)
class case_setting(object):
    form = TagForm

    # 保存时，默认保存当前登录用户
    def save_models(self):
        self.new_obj.writer = self.request.user
        super().save_models()

    # 按顺序显示对应字段
    form_layout = (
        Fieldset(u'基础信息',
                 Row('funmodule'),
                 Row('name'),
                 Row('documentation', ),
                 Row('tags', ),
                 Row('business', ),
                 # 其他字段
                 css_class='unsort no_title'
                 ),
        Fieldset(u'默认字段',
                 Row('isrun','sort'),
                 Row('writer', 'del_flag')
                 ),
    )
    # 搜索字段
    search_fields = ['id', 'name']
    # listdisplay设置要显示在列表中的字段（id字段是Django模型的默认主键）
    list_display = ('caseid', 'funmodule','name', 'doc')
    # 可点击链接字段
    list_display_links = ('name',)
    # 多对多，选框美化
    style_fields = {'tags': 'm2m_transfer', 'business': 'm2m_transfer'}
    # 每页显示20条数据
    list_per_page = 20
    # list_editable 设置默认可编辑字段
    # list_editable = ['sort',]


@xadmin.sites.register(Business)
class business_setting(object):
    form_layout = (
        Fieldset(u'',
                 Row('user'),
                 Row('bus_basic', ),
                 Row('params', ),
                 ),
    )

    list_display = ('bus', 'data', 'userinfo')
    style_fields = {'params': 'm2m_transfer', 'business': 'm2m_transfer'}
    list_per_page = 20


@xadmin.sites.register(Data)
class data_setting(object):
    list_display = ('varName', 'value', 'documentation')
    search_fields = ['varName', 'value']

@xadmin.sites.register(Business_basic)
class business_basic_setting(object):
    search_fields = ['name', "nameEn"]
    list_display = ('name', "nameEn", "params", 'doc')
    list_display_links = ('name',)
    list_per_page = 20


@xadmin.sites.register(User)
class user_setting(object):
    list_display = ('userId','name',  'reqchannel')
    list_display_links = ('userId', 'name')
    search_fields = ['name', 'userId']
    list_per_page = 20

@xadmin.sites.register(Tag)
class tag_setting(object):
    list_display = ('tagName', 'documentation')


@xadmin.sites.register(FunModule)
class funmoudle_setting(object):
    list_display = ('name', "tag", "person")
    list_per_page = 20

