*** Settings ***
Force Tags        DocTest    AnswerPlan
Library           ../../Lib/JsonRead.py
Resource          ../../Business/API/BusApiCom.robot
Variables         ../../Data/Variables.py


*** Test Cases ***
get/answerPlans
	[Documentation]    个人答题计划生成确认
	[Tags]    Run
	${resp}    getApiResp    get    /answerPlans
	${result}    docmentAssert    get    /answerPlans    ${resp}
	should be true     ${result[0]}     ${result}

