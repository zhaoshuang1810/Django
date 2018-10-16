"""AutoTestTools URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/1.11/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  url(r'^$', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  url(r'^$', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.conf.urls import url, include
    2. Add a URL to urlpatterns:  url(r'^blog/', include('blog.urls'))
"""
from django.conf.urls import url
from django.views.static import serve

import xadmin
from Apps.AutoTestApp import views
from AutoTestTools import settings

urlpatterns = [
    url(r'^$', views.index, name='index'),
    url(r'^xadmin/', xadmin.site.urls),
    url(r'^case/del_data', views.del_data, name='del_data'),
    url(r'^case/sort', views.sort, name='sort'),
    url(r'^case/create_case', views.create_case, name='create_case'),
    url(r'^case/save_case', views.save_case, name='save_case'),
    url(r'^case/', views.case, name='case'),
    url(r'^test/run_case', views.run_case, name='run_case'),
    url(r'^test/run_tagcase', views.run_tagcase, name='run_tagcase'),
    url(r'^test/', views.test, name='test'),
    url(r'^historyreport/', views.historyreport, name='historyreport'),

    url(r'^static/(?P<path>.*)$', serve, {'document_root': settings.STATIC_ROOT, 'show_indexes': True}),
    url(r'^media/(?P<path>.*)$', serve, {'document_root': settings.MEDIA_ROOT, 'show_indexes': True}),

]
