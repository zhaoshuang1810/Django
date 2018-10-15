*** Settings ***
Force Tags        DocTest    Subject
Library           ../../Lib/JsonRead.py
Library           Collections
Resource          ../../Business/API/BusApiCom.robot
Resource          ../../Business/API/Bus_Basic.robot
Variables         ../../Data/Variables.py

*** Variables ***
${examTypeId}     2
${videosInfoId}


*** Test Cases ***
get/subjects
	[Documentation]    根据考试类型id查询科目列表
	[Tags]    Run
	change_examtypeId    2      ${examTypeId}      24
	${params}    getParam_doc   get    /subjects
	set to dictionary      ${params}    examTypeId=${examTypeId}
	${resp}    getApiResp    get    /subjects    params=${params}
	${result}    docmentAssert    get    /subjects    ${resp}
	should be true     ${result[0]}     ${result}

get/subjects/courses
	[Documentation]    当前科目下所有公开课列表，按照章节分组
	[Tags]    Run
	${resp}    getApiResp    get    /subjects/courses
	set suite variable      ${videosInfoId}      ${resp['courseList'][0]['items'][0]['id']}
	${result}    docmentAssert    get    /subjects/courses    ${resp}
	should be true     ${result[0]}     ${result}

get/subjects/videosInfo
	[Documentation]    根据视频id查询视频详情
	[Tags]    Run
	${params}    getParam_doc   get    /subjects/videosInfo
    set to dictionary     ${params}    videosInfoId=${videosInfoId}
	${resp}    getApiResp    get    /subjects/videosInfo    params=${params}
	${result}    docmentAssert    get    /subjects/videosInfo    ${resp}
	should be true     ${result[0]}     ${result}

post/subjects/courses/peopleSum
	[Documentation]    增加公开课观看人数
	[Tags]    Run
	${params}    getParam_doc    post     /subjects/courses/peopleSum
	set to dictionary     ${params}    courseId=${videosInfoId}
	${resp}    getApiResp    post    /subjects/courses/peopleSum    params=${params}
	${result}    docmentAssert    post    /subjects/courses/peopleSum    ${resp}
	should be true     ${result[0]}     ${result}

get/subjects/courses/coinStatus
	[Documentation]    当前可以兑换的状态
	[Tags]    Run
	${resp}    getApiResp    get    /subjects/courses/coinStatus
	${result}    docmentAssert    get    /subjects/courses/coinStatus    ${resp}
	should be true     ${result[0]}     ${result}

post/subjects/courses/exchange
	[Documentation]    积分兑换课程
	[Tags]    Run
	${params}    getParam_doc    post     /subjects/courses/exchange
	set to dictionary     ${params}    type=GOLD_COIN     videosInfoId=${videosInfoId}
	${resp}    getApiResp    post    /subjects/courses/exchange    params=${params}
	${result}    docmentAssert    post    /subjects/courses/exchange    ${resp}
	should be true     ${result[0]}     ${result}

get/draw/assist/share/{userId}/{videosInfoId}
	[Documentation]    获取用户活动详情
	[Tags]    Run
	${params}    getParam_doc   get    /draw/assist/share/{userId}/{videosInfoId}
	set to dictionary     ${params}    userId=${userId}      videosInfoId=${videosInfoId}
	${resp}    getApiResp    get    /draw/assist/share/{userId}/{videosInfoId}    params=${params}
	should be true     ${True}     返回图片

