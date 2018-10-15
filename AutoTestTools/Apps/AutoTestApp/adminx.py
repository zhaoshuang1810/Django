# -*- coding: utf-8 -*-
from __future__ import unicode_literals

import xadmin
from xadmin import views

# Register your models here.
from AutoTestApp.models import *
from xadmin.layout import Fieldset, Row

class GlobalSetting(object):
    # 设置base_site.html的Title
    site_title = '自动化测试'
    # 设置base_site.html的Footer
    site_footer  = '轻题库'
    # global_models_icon = {
    #     V_UserInfo: "glyphicon glyphicon-user", UserDistrict: "fa fa-cloud"
    # }  # 设置models的全局图标
    menu_style = "accordion"
xadmin.site.register(views.CommAdminView, GlobalSetting)


class tag_setting(object):
    list_display = ('tagName', 'documentation')
    ordering = ['tagName']


class data_setting(object):
    list_display = ('varName', 'value', 'documentation', 'chanel')
    ordering = ['varName']
    # list_editable = ['value']
    search_fields = ['varName', 'value']



# @xadmin.sites.register(Case)
class case_setting(object):

    def formfield_for_foreignkey(self, db_field, request=None, **kwargs):
        """对外键进行设置"""
        if db_field.name == 'writer':
            kwargs['initial'] = request.user.id
            kwargs['queryset'] = User.objects.filter(username=request.user.username)
        return super(case_setting, self).formfield_for_foreignkey(db_field, request, **kwargs)


    form_layout = (
        Fieldset(u'',
                 Row('name' ,'writer'),
                 Row('documentation', ),
                 Row('business', ),
                 Row('tags', ),
                 css_class='unsort no_title'

                 ),
    )

    def get_tags(self, obj):
        return ",".join([t.tagName for t in obj.tags.all()])

    search_fields = ['id', 'name']
    # listdisplay设置要显示在列表中的字段（id字段是Django模型的默认主键）
    list_display = ('id', 'name', 'get_tags', 'doc')
    # list_editable = ['sort']
    list_display_links = ('name',)
    ordering = ('sort', 'id')
    style_fields = {'tags': 'm2m_transfer', 'business': 'm2m_transfer'}
    # filter_vertical = ('tags', 'business')
    list_per_page = 50


class business_setting(object):
    fieldsets = (
        ("用例", {'fields': ['user', 'bus_basic', 'params']}),
    )

    def data(self, obj):
        params = [p.varName + "=" + p.value for p in obj.params.all()]
        return ";\n".join(params)

    def bus(self, obj):
        return [b.name for b in Business_basic.objects.filter(id=obj.bus_basic_id)]

    def userinfo(self, obj):
        return [u.name + "_" + u.reqchannel for u in User.objects.filter(id=obj.user_id)]

    # listdisplay设置要显示在列表中的字段（id字段是Django模型的默认主键）
    list_display = ('bus', 'data', 'userinfo',)
    ordering = ('user_id', 'bus_basic_id',)
    filter_horizontal = ('params',)
    list_per_page = 50


class business_basic_setting(object):
    search_fields = ['name', "nameEn"]
    # listdisplay设置要显示在列表中的字段（id字段是Django模型的默认主键）
    list_display = ('name', 'nameEn', "params", 'doc')
    list_display_links = ('name',)
    # list_editable = [ 'params']
    ordering = ['name']
    search_fields = ['name', 'nameEn', 'params']
    list_per_page = 50


class user_setting(object):
    # listdisplay设置要显示在列表中的字段（id字段是Django模型的默认主键）
    list_display = ('name', 'userId', 'reqchannel')
    list_display_links = ('userId', 'name')
    ordering = ['name']
    search_fields = ['name', 'userId', 'reqchannel']
    list_per_page = 50


xadmin.site.register(Tag, tag_setting)
xadmin.site.register(Data, data_setting)
xadmin.site.register(Case, case_setting)
xadmin.site.register(Business, business_setting)
xadmin.site.register(Business_basic, business_basic_setting)
xadmin.site.register(User, user_setting)
