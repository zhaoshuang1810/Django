*** Settings ***
Force Tags        DocTest    DRAW
Library           ../../Lib/JsonRead.py
Resource          ../../Business/API/BusApiCom.robot
Variables         ../../Data/Variables.py


*** Test Cases ***
get/draw/assist/share/{userId}/{videosInfoId}
	[Documentation]    获取用户活动详情；在Subject.robot文件中执行
	[Tags]    NotRun
	${params}    getParam_doc    get    /draw/assist/share/{userId}/{videosInfoId}
	${resp}    getApiResp    get    /draw/assist/share/{userId}/{videosInfoId}    params=${params}
	${result}    docmentAssert    get    /draw/assist/share/{userId}/{videosInfoId}    ${resp}
	should be true     ${result[0]}     ${result}

