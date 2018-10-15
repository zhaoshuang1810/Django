*** Settings ***
Force Tags        DocTest    Assist
Library           ../../Lib/JsonRead.py
Library           ../../Lib/GetSQL.py
Library           Collections
Resource          ../../Business/API/BusApiCom.robot
Variables         ../../Data/Variables.py

*** Variables ***
${type}                OPEN_CLASS
${targetObjectId}      283
${assistId}


*** Test Cases ***
post/assist
	[Documentation]    创建助力活动
	[Tags]    Run
	${params}    getParam_doc    post    /assist
	set to dictionary     ${params}    type=${type}    targetObjectId=${targetObjectId}
	${resp}    getApiResp    post    /assist    params=${params}
	${result}    docmentAssert    post    /assist    ${resp}
	should be true     ${result[0]}     ${result}

get/assist/share
	[Documentation]    分享助力活动
	[Tags]    Run
	${params}    getParam_doc    get    /assist/share
	set to dictionary     ${params}    shareMark=${token_30}
	${resp}    getApiResp    get    /assist/share    params=${params}
	${result}    docmentAssert    get    /assist/share    ${resp}
	should be true     ${result[0]}     ${result}

post/assist/join
	[Documentation]    好友助力
	[Tags]    Run
	${params}    getParam_doc    post    /assist/join
	set to dictionary     ${params}    type=${type}    targetObjectId=${targetObjectId}    mark=${token_30}
	remove from dictionary      ${params}    signature    extentionObject    timeFlag
	${resp}    getApiResp    post    /assist/join    params=${params}    token=${token01}
	${result}    docmentAssert    post    /assist/join    ${resp}
	should be true     ${result[0]}     ${result}
	pass execution if   ${resp['result']}     助力成功
    update_assist_detail_To_del_flag    ${userId01}
	${params}    getParam_doc    post    /assist/join
	set to dictionary     ${params}    type=${type}    targetObjectId=${targetObjectId}    mark=${token_30}
	remove from dictionary      ${params}    signature    extentionObject    timeFlag
	${resp}    getApiResp    post    /assist/join    params=${params}    token=${token01}
	${result}    docmentAssert    post    /assist/join    ${resp}
	should be true     ${result[0]}     ${result}

get/assist
	[Documentation]    助力详情
	[Tags]    Run
	${params}    getParam_doc    get    /assist
	set to dictionary     ${params}    type=${type}    targetObjectId=${targetObjectId}    mark=${EMPTY}
	${resp}    getApiResp    get    /assist    params=${params}
	${result}    docmentAssert    get    /assist    ${resp}
	should be true     ${result[0]}     ${result}

get/assist/joinNum
	[Documentation]    参加某项助力活动的人数
	[Tags]    Run
	${params}    getParam_doc    get    /assist/joinNum
	set to dictionary     ${params}    type=${type}
	${resp}    getApiResp    get    /assist/joinNum    params=${params}
	${result}    docmentAssert    get    /assist/joinNum    ${resp}
	should be true     ${result[0]}     ${result}

get/assit/list
	[Documentation]    助力列表
	[Tags]    Run
	${params}    getParam_doc    get    /assist/list
	set to dictionary     ${params}    type=${type}
	${resp}    getApiResp    get    /assist/list    params=${params}
	set suite variable      ${assistId}      ${resp['assistInfoList'][0]['assistId']}
	${result}    docmentAssert    get    /assist/list    ${resp}
	should be true     ${result[0]}     ${result}

post/assist/restart/{assistId}
	[Documentation]    重新开始
	[Tags]    Run
	${params}    getParam_doc    post    /assist/restart/{assistId}
	set to dictionary     ${params}    assistId=${assistId}
	${resp}    getApiResp    post    /assist/restart/{assistId}    params=${params}
	${result}    docmentAssert    post    /assist/restart/{assistId}    ${resp}
	should be true     ${result[0]}     ${result}

