*** Settings ***
Force Tags        DocTest    Ranking
Library           ../../Lib/JsonRead.py
Library           Collections
Resource          ../../Business/API/BusApiCom.robot
Variables         ../../Data/Variables.py


*** Test Cases ***
get/ranking/pkArena
	[Documentation]    排行榜-pk场
	[Tags]    Run
	${params}    getParam_doc    get    /ranking/pkArena
    set to dictionary      ${params}     filter=friends
	${resp}    getApiResp    get    /ranking/pkArena    params=${params}
	${result}    docmentAssert    get    /ranking/pkArena    ${resp}
	should be true     ${result[0]}     ${result}

get/ranking/learningPlan
	[Documentation]    学习计划排行场
	[Tags]    Run
	${params}    getParam_doc    get    /ranking/learningPlan
	set to dictionary     ${params}    area=PROVINC    type=PASS_RATE
	${resp}    getApiResp    get    /ranking/learningPlan    params=${params}
	${result}    docmentAssert    get    /ranking/learningPlan    ${resp}
	should be true     ${result[0]}     ${result}

