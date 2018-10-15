*** Settings ***
Force Tags        DocTest    LearningPlan
Library           ../../Lib/JsonRead.py
Library           ../../Lib/GetSQL.py
Library           ../../Lib/PrivateMethod.py
Library           Collections
Resource          ../../Business/API/BusApiCom.robot
Resource          ../../Business/API/Bus_Basic.robot
Variables         ../../Data/Variables.py
Suite Setup      change_subjecttypeId    2    ${subjectId}

*** Variables ***
${provinceId}        3
${examTime}          2019-10-01 09:00:00
${examTypeId}        3
${subjectId}         2
${subjectIds}        2,17,96,137
${learningPlanId}


*** Test Cases ***
get/learningPlan/provinces
	[Documentation]    学习计划省份列表
	[Tags]    Run
	${params}    getParam_doc   get    /learningPlan/provinces
	set to dictionary       ${params}     provinceName=${EMPTY}
	${resp}    getApiResp    get    /learningPlan/provinces    params=${params}
	${result}    docmentAssert    get    /learningPlan/provinces    ${resp}
	should be true     ${result[0]}     ${result}

get/learningPlan/examTimes
	[Documentation]    考试时间列表
	[Tags]    Run
	${params}    getParam_doc   get    /learningPlan/examTimes
	set to dictionary       ${params}     provinceId=${provinceId}
	${resp}    getApiResp    get    /learningPlan/examTimes    params=${params}
	${result}    docmentAssert    get    /learningPlan/examTimes    ${resp}
	should be true     ${result[0]}     ${result}

get/learningPlan/dailyPlanQuestions
	[Documentation]    根据课程动态查询问题信息
	[Tags]    Run
	${params}    getParam_doc   get    /learningPlan/dailyPlanQuestions
	set to dictionary       ${params}     subjectIds=${subjectIds}     examTime=${examTime}
	${resp}    getApiResp    get    /learningPlan/dailyPlanQuestions    params=${params}
	${result}    docmentAssert    get    /learningPlan/dailyPlanQuestions    ${resp}
	should be true     ${result[0]}     ${result}

post/learningPlan
	[Documentation]    创建学习计划
	[Tags]    Run
	update learning plan To del flag     ${userId}     ${examTypeId}
	${params}    getParam_doc   post    /learningPlan
	remove from dictionary      ${params}    prepareTime
	set to dictionary       ${params}     provinceId=${provinceId}    examTypeId=${examTypeId}    subjectIds=${subjectId}     examTime=${examTime}
	${resp}    getApiResp    post    /learningPlan    params=${params}
	${result}    docmentAssert    post    /learningPlan    ${resp}
	should be true     ${result[0]}     ${result}

get/learningPlan/info
	[Documentation]    查看学习计划
	[Tags]    Run
	${resp}    getApiResp    get    /learningPlan/info
	set suite variable      ${learningPlanId}     ${resp['id']}
	${result}    docmentAssert    get    /learningPlan/info    ${resp}
	should be true     ${result[0]}     ${result}

put/learningPlan/update
	[Documentation]    修改学习计划
	[Tags]    Run
	${params}    getParam_doc   put    /learningPlan/update
	remove from dictionary      ${params}    prepareTime
    set to dictionary    ${params}    learningPlanId=${learningPlanId}    provinceId=${provinceId}    examTypeId=${examTypeId}    subjectIds=${subjectIds}     examTime=${examTime}
	${resp}    getApiResp    put    /learningPlan/update    params=${params}
	${result}    docmentAssert    put    /learningPlan/update    ${resp}
	should be true     ${result[0]}     ${result}

get/learningPlan/progress
	[Documentation]    查看个人学习计划执行情况
	[Tags]    Run
	${resp}    getApiResp    get    /learningPlan/progress
	${result}    docmentAssert    get    /learningPlan/progress    ${resp}
	should be true     ${result[0]}     ${result}

get/learningPlan/dailyCoin
	[Documentation]    个人学习计划可获得的最大青豆数量
	[Tags]    Run
	${resp}    getApiResp    get    /learningPlan/dailyCoin
	${result}    docmentAssert    get    /learningPlan/dailyCoin    ${resp}
	should be true     ${result[0]}     ${result}

get/learningPlan/push
	[Documentation]    首页消息弹幕
	[Tags]    Run
	${params}    getParam_doc    get    /learningPlan/push
	set to dictionary      ${params}      messageType=LEARNING_PLAN
	${resp}    getApiResp    get    /learningPlan/push    params=${params}
	${result}    docmentAssert    get    /learningPlan/push    ${resp}
	should be true     ${result[0]}     ${result}

get/learningPlan/dailyAnswerQuestion
	[Documentation]    学习计划执行（周/月）
	[Tags]    Run
	${params}    getParam_doc    get    /learningPlan/dailyAnswerQuestion
	set to dictionary    ${params}    calendarType=WEEK
	${resp}    getApiResp    get    /learningPlan/dailyAnswerQuestion    params=${params}
	${result}    docmentAssert    get    /learningPlan/dailyAnswerQuestion    ${resp}
	should be true     ${result[0]}     ${result}
	set to dictionary    ${params}    calendarType=MONTH
	${resp}    getApiResp    get    /learningPlan/dailyAnswerQuestion    params=${params}
	${result}    docmentAssert    get    /learningPlan/dailyAnswerQuestion    ${resp}
	should be true     ${result[0]}     ${result}

get/learningPlan/dailySurvey
	[Documentation]    学习计划执行进度
	[Tags]    Run
	${params}    getParam_doc    get    /learningPlan/dailySurvey
	${time}    addDay    14
	set to dictionary      ${params}    queryTime=${time}
	${resp}    getApiResp    get    /learningPlan/dailySurvey    params=${params}
	${result}    docmentAssert    get    /learningPlan/dailySurvey    ${resp}
	should be true     ${result[0]}     ${result}

post/learningPlan/videos/unlock
	[Documentation]    学习计划-解锁视频
	[Tags]    Run
	${params}    getParam_doc    post    /learningPlan/videos/unlock
	set to dictionary      ${params}      type=OPEN_FOURTEEN
	${resp}    getApiResp    post    /learningPlan/videos/unlock    params=${params}
	${result}    docmentAssert    post    /learningPlan/videos/unlock    ${resp}
	should be true     ${result[0]}     ${result}



