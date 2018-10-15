*** Settings ***
Force Tags        DocTest    COIN
Library           ../../Lib/JsonRead.py
Library           Collections
Resource          ../../Business/API/BusApiCom.robot
Variables         ../../Data/Variables.py

*** Test Cases ***
get/coin/details
	[Documentation]    积分详情列表
	[Tags]    Run
	${resp}    getApiResp    get    /coin/details
	${field}    set variable if      ${resp['showTwoMonthsAgo']}     ${EMPTY}       twoMonthsAgo
	${result}    docmentAssert2    get    /coin/details    ${resp}    ${field}
	should be true     ${result[0]}     ${result}

get/coin/push
	[Documentation]    青豆消息推送
	[Tags]    Run
	${params}    getParam_doc    get    /coin/push
	set to dictionary      ${params}    messageType=DETAILS
	${resp}    getApiResp    get    /coin/push    params=${params}
	${result}    docmentAssert    get    /coin/push    ${resp}
	should be true     ${result[0]}     ${result}

get/coin/center
	[Documentation]    积分中心接口
	[Tags]    Run
	${resp}    getApiResp    get    /coin/center
	${result}    docmentAssert    get    /coin/center    ${resp}
	should be true     ${result[0]}     ${result}

