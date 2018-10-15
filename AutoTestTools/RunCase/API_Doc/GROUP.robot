*** Settings ***
Force Tags        DocTest    GROUP
Library           ../../Lib/JsonRead.py
Library           ../../Lib/GetSQL.py
Library           Collections
Resource          ../../Business/API/BusApiCom.robot
Variables         ../../Data/Variables.py

*** Variables ***
&{headers_m}     token=${token_m}     reqchannel=${reqchannel[1]}
&{headers_m01}     token=${token_m01}     reqchannel=${reqchannel[1]}
${activityId}         2
${commodityId}        30
${id}
${status}


*** Test Cases ***
post/trans/api/v1/group/create
	[Documentation]    开团
	[Tags]    Run    MANGO
	update group order To del flag      ${userId_m}
	${params}    getParam_doc    post    /trans/api/v1/group/create
	set to dictionary        ${params}     activityId=${activityId}      commodityId=${commodityId}
	${resp}    getApiResp    post    /trans/api/v1/group/create    params=${params}    &{headers_m}
	set suite variable      ${id}    ${resp['groupOrderId']}
	update group order To status     ${id}
	${result}    docmentAssert    post    /trans/api/v1/group/create    ${resp}
	should be true     ${result[0]}     ${result}

get/trans/api/v1/group/list
	[Documentation]    可以加入团列表
	[Tags]    Run    MANGO
	${params}    getParam_doc    get    /trans/api/v1/group/list
	set to dictionary        ${params}     activityId=${activityId}
	${resp}    getApiResp    get    /trans/api/v1/group/list    params=${params}    &{headers_m01}
	${result}    docmentAssert    get    /trans/api/v1/group/list    ${resp}
	should be true     ${result[0]}     ${result}

get/trans/api/v1/group/isAdd
	[Documentation]    是否参团
	[Tags]    Run    MANGO
	${params}    getParam_doc    get    /trans/api/v1/group/isAdd
	set to dictionary        ${params}     activityId=${activityId}
	${resp}    getApiResp    get    /trans/api/v1/group/isAdd    params=${params}    &{headers_m01}
	${result}    docmentAssert    get    /trans/api/v1/group/isAdd    ${resp}
	should be true     ${result[0]}     ${result}

post/trans/api/v1/group/add/{id}
	[Documentation]    参团
	[Tags]    Run    MANGO
	${params}    getParam_doc    post    /trans/api/v1/group/add/{id}
	set to dictionary        ${params}       id=${id}
	${resp}    getApiResp    post    /trans/api/v1/group/add/{id}    params=${params}    &{headers_m01}
	${result}    docmentAssert    post    /trans/api/v1/group/add/{id}    ${resp}
	should be true     ${result[0]}     ${result}

get/trans/api/v1/group/getGroupInfo
	[Documentation]    获取拼团信息
	[Tags]    Run    MANGO
	${params}    getParam_doc    get    /trans/api/v1/group/getGroupInfo
	set to dictionary        ${params}       id=${id}
	${resp}    getApiResp    get    /trans/api/v1/group/getGroupInfo    params=${params}    &{headers_m}
	set suite variable      ${status}      ${resp['status']}
	${result}    docmentAssert    get    /trans/api/v1/group/getGroupInfo    ${resp}
	should be true     ${result[0]}     ${result}

get/trans/api/v1/group/groupList
	[Documentation]    可以加入团列表(如果当前没有拼团/拼团已过期/拼团失败[headImage,nickName,needPeople,orderId,timeRemaining]如果正在进行中[headImage,nickName]
	[Tags]    Run    MANGO
	${params}    getParam_doc    get    /trans/api/v1/group/groupList
	set to dictionary      ${params}     activityId=${activityId}      status=${status}
	${resp}    getApiResp    get    /trans/api/v1/group/groupList    params=${params}    &{headers_m}
	${result}    docmentAssert    get    /trans/api/v1/group/groupList    ${resp}
	should be true     ${result[0]}     ${result}





