*** Settings ***
Force Tags        DocTest    LEARN
Library           ../../Lib/JsonRead.py
Resource          ../../Business/API/BusApiCom.robot
Variables         ../../Data/Variables.py


*** Test Cases ***
get/learnTask/getSingleTask
	[Documentation]    查询单科任务进度
	[Tags]    Run
	${resp}    getApiResp    get    /learnTask/getSingleTask
	${result}    docmentAssert    get    /learnTask/getSingleTask    ${resp}
	should be true     ${result[0]}     ${result}

get/learnTask/getDayTask
	[Documentation]    查询每日学习计划
	[Tags]    Run
	${resp}    getApiResp    get    /learnTask/getDayTask
	${result}    docmentAssert    get    /learnTask/getDayTask    ${resp}
	should be true     ${result[0]}     ${result}

get/learnTask/getTotalTask
	[Documentation]    查询总任务进度
	[Tags]    Run
	${params}    getParam_doc    get     /learnTask/getTotalTask
	${yyyy}    ${mm}    Get Time    year,month
	set to dictionary    ${params}    year=${yyyy}     month=${mm}
	${resp}    getApiResp    get    /learnTask/getTotalTask    params=${params}
	${result}    docmentAssert    get    /learnTask/getTotalTask    ${resp}
	should be true     ${result[0]}     ${result}

