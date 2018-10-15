*** Settings ***
Force Tags        DocTest    UserAnswer
Library           ../../Lib/JsonRead.py
Library           Collections
Resource          ../../Business/API/BusApiCom.robot
Variables         ../../Data/Variables.py

*** Variables ***
${userAnswerId}              243087


*** Test Cases ***
post/userAnswer
	[Documentation]    判题请求，DailyPractice用例执行
	[Tags]    NotRun
	${params}    getParam_doc    post    /userAnswer
	${resp}    getApiResp    post    /userAnswer    params=${params}
	${result}    docmentAssert    post    /userAnswer    ${resp}
	should be true     ${result[0]}     ${result}

get/userAnswer/{userAnswerId}
	[Documentation]    获取判题信息,历史答题记录
	[Tags]    Run
	${params}    getParam_doc    get     /userAnswer/{userAnswerId}
	set to dictionary        ${params}     infoType=answerDone      userAnswerId=${userAnswerId}
	${resp}    getApiResp    get    /userAnswer/{userAnswerId}    params=${params}
	${result}    docmentAssert    get    /userAnswer/{userAnswerId}    ${resp}
	should be true     ${result[0]}     ${result}

