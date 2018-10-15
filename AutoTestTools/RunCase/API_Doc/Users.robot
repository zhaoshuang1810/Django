*** Settings ***
Force Tags        DocTest    Users
Library           ../../Lib/JsonRead.py
Library           Collections
Resource          ../../Business/API/BusApiCom.robot
Variables         ../../Data/Variables.py


*** Variables ***
${examTypeId}           2
${subjectId}            24


*** Test Cases ***
get/users/home
	[Documentation]    欢迎页详情
	[Tags]    Run
	${resp}    getApiResp    get    /users/home
	${result}    docmentAssert    get    /users/home    ${resp}
	should be true     ${result[0]}     ${result}

get/users/share
	[Documentation]    小程序分享
	[Tags]    Run
	${params}    getParam_doc    get      /users/share
	set to dictionary      ${params}     shareType=DATA
	remove from dictionary      ${params}     pkLogId
	${resp}    getApiResp    get    /users/share    params=${params}
	${result}    docmentAssert    get    /users/share    ${resp}
	should be true     ${result[0]}     ${result}

put/users/examTypes
	[Documentation]    修改用户考试类型
	[Tags]    Run
	${params}    getParam_doc     put    /users/examTypes
	set to dictionary      ${params}     examTypeId=${examTypeId}
	${resp}    getApiResp    put    /users/examTypes    params=${params}
	${result}    docmentAssert    put    /users/examTypes    ${resp}
	should be true     ${result[0]}     ${result}

put/users/subjects
	[Documentation]    修改用户科目
	[Tags]    Run
	${params}    getParam_doc    put    /users/subjects
	set to dictionary      ${params}     subjectId=${subjectId}
	${resp}    getApiResp    put    /users/subjects    params=${params}
	${result}    docmentAssert    put    /users/subjects    ${resp}
	should be true     ${result[0]}     ${result}

get/users/me
	[Documentation]    首页我的详情
	[Tags]    Run
	${params}    getParam_doc     get    /users/me
	set to dictionary      ${params}     lat=111    lon=222
	${resp}    getApiResp    get    /users/me    params=${params}
	${result}    docmentAssert    get    /users/me    ${resp}
	should be true     ${result[0]}     ${result}

post/users/advice
	[Documentation]    用户意见反馈
	[Tags]    Run
	${params}    getParam_doc    post    /users/advice
	set to dictionary      ${params}     content=反馈内容好不好    userIp=172.16.165.133
	${resp}    getApiResp    post    /users/advice    params=${params}
	${result}    docmentAssert    post    /users/advice    ${resp}
	should be true     ${result[0]}     ${result}

post/users/conllects/{questionId}
	[Documentation]    用户收藏
	[Tags]    Run
	${params}    getParam_doc    post    /users/conllects/{questionId}
	set to dictionary      ${params}     questionId=43230
	${resp}    getApiResp    post    /users/conllects/{questionId}    params=${params}
	${result}    docmentAssert    post    /users/conllects/{questionId}    ${resp}
	should be true     ${result[0]}     ${result}

get/users/me/info
	[Documentation]    我的数据
	[Tags]    Run
	${params}    getParam_doc    get    /users/me/info
	set to dictionary      ${params}     mark=${EMPTY}
	${resp}    getApiResp    get    /users/me/info    params=${params}
	${result}    docmentAssert    get    /users/me/info    ${resp}
	should be true     ${result[0]}     ${result}

get/users/push
	[Documentation]    首页推送消息集合
	[Tags]    Run
	${resp}    getApiResp    get    /users/push
	${result}    docmentAssert    get    /users/push    ${resp}
	should be true     ${result[0]}     ${result}

post/users/signIn
	[Documentation]    用户签到
	[Tags]    Run
	${resp}    getApiResp    post    /users/signIn
	${result}    docmentAssert    post    /users/signIn    ${resp}
	should be true     ${result[0]}     ${result}

get/users/support
	[Documentation]    题库数据支持
	[Tags]    Run
	${resp}    getApiResp    get    /users/support
	${result}    docmentAssert    get    /users/support    ${resp}
	should be true     ${result[0]}     ${result}

get/users/token
	[Documentation]    微信登陆获取尚德token对（公众号不可用）
	[Tags]    NotRun
	${params}    getParam_doc    get    /users/token
	${resp}    getApiResp    get    /users/token    params=${params}
	${result}    docmentAssert    get    /users/token    ${resp}
	should be true     ${result[0]}     ${result}

get/users/token/refresh
	[Documentation]    换取新的尚德token对
	[Tags]    NotRun
	${params}    getParam_doc    get    /users/token/refresh
	${resp}    getApiResp    get    /users/token/refresh    params=${params}
	${result}    docmentAssert    get    /users/token/refresh    ${resp}
	should be true     ${result[0]}     ${result}

get/users/versions
	[Documentation]    版本提示动态值；参数code通过微信动态获取，暂时获取不到
	[Tags]    NotRun
	${params}    getParam_doc    get    /users/versions
	${resp}    getApiResp    get    /users/versions    params=${params}
	${result}    docmentAssert    get    /users/versions    ${resp}
	should be true     ${result[0]}     ${result}

post/users/unchainPaper
	[Documentation]    授权解锁 模拟试卷
	[Tags]    NotRun
	${params}    getParam_doc    post    /users/unchainPaper
	${resp}    getApiResp    post    /users/unchainPaper    params=${params}
	${result}    docmentAssert    post    /users/unchainPaper    ${resp}
	should be true     ${result[0]}     ${result}

post/users/survey
	[Documentation]    用户测试数据提交
	[Tags]    NotRun
	${params}    getParam_doc    post    /users/survey
	${resp}    getApiResp    post    /users/survey    params=${params}
	${result}    docmentAssert    post    /users/survey    ${resp}
	should be true     ${result[0]}     ${result}

get/users/passRate
	[Documentation]    用户通过率
	[Tags]    Run
	${resp}    getApiResp    get    /users/passRate
	${result}    docmentAssert    get    /users/passRate    ${resp}
	should be true     ${result[0]}     ${result}

get/users/phone
	[Documentation]    用户手机号信息
	[Tags]    Run
	${resp}    getApiResp    get    /users/phone
	${result}    docmentAssert    get    /users/phone    ${resp}
	should be true     ${result[0]}     ${result}

post/users/phone
	[Documentation]    用户绑定手机号码
	[Tags]    NotRun
	${params}    getParam_doc    post    /users/phone
	${resp}    getApiResp    post    /users/phone    params=${params}
	${result}    docmentAssert    post    /users/phone    ${resp}
	should be true     ${result[0]}     ${result}

