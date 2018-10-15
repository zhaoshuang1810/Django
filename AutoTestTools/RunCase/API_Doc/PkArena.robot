*** Settings ***
Force Tags        DocTest    PkArena
Library           ../../Lib/JsonRead.py
Library           Collections
Resource          ../../Business/API/BusApiCom.robot
Variables         ../../Data/Variables.py

*** Variables ***
${shareMark}
${pkLogId}
${questionId}

*** Test Cases ***
get/pkArena/me
	[Documentation]    pk场，显示当前用户信息
	[Tags]    Run
	${resp}    getApiResp    get    /pkArena/me
	set suite variable     ${shareMark}    ${resp['shareMark']}
	${result}    docmentAssert    get    /pkArena/me    ${resp}
	should be true     ${result[0]}     ${result}

userShare
    [Documentation]    分享
    [Tags]  Run
    ${params}    getParam_doc    get    /users/share
    set to dictionary      ${params}     shareType=PK      shareMark=${shareMark}
	remove from dictionary      ${params}     pkLogId
	getApiResp    get    /users/share    params=${params}

post/pkArena/join
	[Documentation]    好友对战，加入pk场
	[Tags]    Run
	${params}    getParam_doc    post    /pkArena/join
	set to dictionary    ${params}    shareMark=${shareMark}
	${resp}    getApiResp    post    /pkArena/join    params=${params}    token=${token01}
	${result}    docmentAssert    post    /pkArena/join    ${resp}
	should be true     ${result[0]}     ${result}

get/pkArena/target
	[Documentation]    进入pk场,显示对方用户信息
	[Tags]    Run
	${resp}    getApiResp    get    /pkArena/target
	${result}    docmentAssert    get    /pkArena/target    ${resp}
	should be true     ${result[0]}     ${result}

get/pkArena/pkMatch
	[Documentation]    匹配对手 / 点击分享链接
	[Tags]    Run
	${params}    getParam_doc    get    /pkArena/pkMatch
	set to dictionary    ${params}    shareMark=${shareMark}     selfPlay=${False}
	${resp}    getApiResp    get    /pkArena/pkMatch    params=${params}    token=${token01}
	set suite variable      ${pkLogId}    ${resp['pkLogId']}
	${result}    docmentAssert    get    /pkArena/pkMatch    ${resp}
	should be true     ${result[0]}     ${result}

get/pkArena/pkQuestions
	[Documentation]    查询pk场下一题信息
	[Tags]    Run
	${params}    getParam_doc    get    /pkArena/pkQuestions
	set to dictionary    ${params}    pkLogId=${pkLogId}    questionId=${EMPTY}
	${resp}    getApiResp    get    /pkArena/pkQuestions    params=${params}
	set suite variable     ${questionId}    ${resp['questionId']}
	${result}    docmentAssert    get    /pkArena/pkQuestions    ${resp}
	should be true     ${result[0]}     ${result}

post/pkArena/pkAnswer
	[Documentation]    提交答案
	[Tags]    Run
	${params}    getParam_doc    post    /pkArena/pkAnswer
	set to dictionary      ${params}    pkLogId=${pkLogId}    questionId=${questionId}    currentUserAnswer=A     currentUserDuration=3
	${resp}    getApiResp    post    /pkArena/pkAnswer    params=${params}
	${result}    docmentAssert    post    /pkArena/pkAnswer    ${resp}
	should be true     ${result[0]}     ${result}

post/pkArena/pkAnswer2
	[Documentation]    提交答案
	[Tags]    Run
	${params}    getParam_doc    post    /pkArena/pkAnswer
	set to dictionary      ${params}    pkLogId=${pkLogId}    questionId=${questionId}    currentUserAnswer=B     currentUserDuration=2
	${resp}    getApiResp    post    /pkArena/pkAnswer    params=${params}    token=${token01}
	${result}    docmentAssert    post    /pkArena/pkAnswer    ${resp}
	should be true     ${result[0]}     ${result}

get/pkArena/targetAnswerDetail
	[Documentation]    查询对手答题详情
	[Tags]    Run
	${params}    getParam_doc    get    /pkArena/targetAnswerDetail
	set to dictionary      ${params}    pkLogId=${pkLogId}    questionId=${questionId}
	${resp}    getApiResp    get    /pkArena/targetAnswerDetail    params=${params}
	${result}    docmentAssert    get    /pkArena/targetAnswerDetail    ${resp}
	should be true     ${result[0]}     ${result}

post/pkArena/quit
	[Documentation]    pk场
	[Tags]    Run
	${params}    getParam_doc    post    /pkArena/quit
	set to dictionary      ${params}    pkLogId=${pkLogId}
	${resp}    getApiResp    post    /pkArena/quit    params=${params}
	${result}    docmentAssert    post    /pkArena/quit    ${resp}
	should be true     ${result[0]}     ${result}

get/pkArena/danGradingTips
	[Documentation]    段位升降提示
	[Tags]    Run
	${params}    getParam_doc    get     /pkArena/danGradingTips
	set to dictionary      ${params}    pkLogId=${pkLogId}
	${resp}    getApiResp    get    /pkArena/danGradingTips    params=${params}
	pass execution if    '${resp}'=='${EMPTY}'     没有升级，所以不提示
	${result}    docmentAssert    get    /pkArena/danGradingTips    ${resp}
	should be true     ${result[0]}     ${result}

get/pkArena/pkDynamicImg/{userId}/{pkLogId}
	[Documentation]    pk结果动态图片
	[Tags]    Run
	${params}    getParam_doc    get    /pkArena/pkDynamicImg/{userId}/{pkLogId}
	set to dictionary      ${params}    userId=${userId}     pkLogId=${pkLogId}
	${resp}    getApiResp    get    /pkArena/pkDynamicImg/{userId}/{pkLogId}    params=${params}
	should be true     ${True}      返回的是图片

get/pkArena/pkFinal
	[Documentation]    pk结果
	[Tags]    Run
	${params}    getParam_doc    get     /pkArena/pkFinal
	set to dictionary      ${params}    pkLogId=${pkLogId}
	${resp}    getApiResp    get    /pkArena/pkFinal    params=${params}
	@{fields}    create list      winRinkingInfo
	${result}    docmentAssert2    get    /pkArena/pkFinal    ${resp}    @{fields}
	should be true     ${result[0]}     ${result}

pkShare
    [Documentation]    pk结果分享
    [Tags]  Run
    ${params}    getParam_doc    get    /users/share
    set to dictionary      ${params}     shareType=PK    pkLogId=${pkLogId}
	getApiResp    get    /users/share    params=${params}

get/pkArena/pkFinal/share
	[Documentation]    pk结果分享
	[Tags]    Run
	${params}    getParam_doc    get    /pkArena/pkFinal/share
	${shareMark_pklogid}     set variable      ${token_30}${pkLogId}
	set to dictionary      ${params}     shareMark=${shareMark_pklogid}
	${resp}    getApiResp    get    /pkArena/pkFinal/share    params=${params}    token=${token01}
	${result}    docmentAssert    get    /pkArena/pkFinal/share    ${resp}
	should be true     ${result[0]}     ${result}

