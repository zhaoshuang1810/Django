*** Settings ***
Force Tags        DocTest    DailyPractice
Library           ../../Lib/JsonRead.py
Library           ../../Lib/PrivateMethod.py
Library           Collections
Resource          ../../Business/API/BusApiCom.robot
Variables         ../../Data/Variables.py


*** Variables ***
@{not_requiredId}     userAnswerId    examPaperId    chapterId
${planType}           DAILY_PRACTICE
${assignmentId}
${current}
${total}
${examQuestion}

*** Test Cases ***
get/dailyPractice/calendar
	[Documentation]    每日一练日历
	[Tags]    Run
	${params}    getParam_doc    get    /dailyPractice/calendar
	${yyyy}    ${mm}    Get Time    year,month
	set to dictionary    ${params}    year=${yyyy}     month=${mm}
	${resp}    getApiResp    get    /dailyPractice/calendar    params=${params}
	${result}    docmentAssert    get    /dailyPractice/calendar    ${resp}
	should be true     ${result[0]}     ${result}

get/dailyPractice/examPapers
	[Documentation]    每日一练任务列表
	[Tags]    Run
	${params}    getParam_doc    get    /dailyPractice/examPapers
	${yyyy}    ${mm}     ${dd}    Get Time    year,month,day
	set to dictionary    ${params}    year=${yyyy}     month=${mm}    number=${dd}
	${resp}    getApiResp    get    /dailyPractice/examPapers    params=${params}
	set suite variable      ${clockIn}    ${resp['clockIn']}
	set suite variable      ${assignmentId}    ${resp['assignmentList'][0]['assignmentId']}
	set suite variable      ${current}    ${resp['assignmentList'][0]['current']}
	set suite variable      ${total}    ${resp['assignmentList'][0]['total']}
	${result}    docmentAssert    get    /dailyPractice/examPapers    ${resp}
	should be true     ${result[0]}     ${result}

getQuestionList
	[Documentation]    题目详情 (8种类型)
	[Tags]    Run
	${params}    getParam_doc       get    /questionTypes/examQuestion
	remove from dictionary     ${params}    userAnswerId
	set to dictionary      ${params}    stratumId=${assignmentId}    planType=${planType}    needAnswer=1
	${resp}    getApiResp    get    /questionTypes/examQuestion    params=${params}
	set suite variable      ${examQuestion}    ${resp}

userAnswer
	[Documentation]    判题请求
	[Tags]    Run
	pass execution if     ${current}==${total}    题已经答过了
	${params}    getParam_doc    post    /userAnswer
	remove from dictionary     ${params}    @{not_requiredId}
	set to dictionary      ${params}    userId=${userId}    assignmentId=${assignmentId}    planType=${planType}     duration=50
	${resp}    getApiResp    get    /answerPlans
	set to dictionary      ${params}    answerPlanId    ${resp['answerPlanId']}
	${questions}      getQuestionAnswer     ${examQuestion}    0
	set to dictionary      ${params}    questions    ${questions[0]}
	${resp}    getApiResp    post    /userAnswer    params=${params}
	${result}    docmentAssert    post    /userAnswer    ${resp}
	should be true     ${result[0]}     ${result}

post/dailyPractice/userClockIn
	[Documentation]    今日打卡
	[Tags]    Run
	${resp}    getApiResp    post    /dailyPractice/userClockIn
	${result}    docmentAssert    post    /dailyPractice/userClockIn    ${resp}
	should be true     ${result[0]}     ${result}

get/dailyPractice/clockInSum
	[Documentation]    打卡总数
	[Tags]    Run
	${resp}    getApiResp    get    /dailyPractice/clockInSum
	${result}    docmentAssert    get    /dailyPractice/clockInSum    ${resp}
	should be true     ${result[0]}     ${result}