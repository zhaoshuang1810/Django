*** Settings ***
Force Tags        DocTest    message
Library           ../../Lib/JsonRead.py
Library           Collections
Resource          ../../Business/API/BusApiCom.robot
Variables         ../../Data/Variables.py


*** Test Cases ***
get/verify
	[Documentation]    验证验证码：本地验证没有问题，不能持续集成，暂不执行
	[Tags]    NotRun
	${params}    getParam_doc    get    /verify
	${resp}    getApiResp    get    /verify    params=${params}
	${result}    docmentAssert    get    /verify    ${resp}
	should be true     ${result[0]}     ${result}

post/
	[Documentation]    发送消息：本地验证没有问题，不能持续集成，暂不执行
	[Tags]    NotRun
	${params}    getParam_doc    post    /
	${resp}    getApiResp    post    /    params=${params}
	${result}    docmentAssert    post    /    ${resp}
	should be true     ${result[0]}     ${result}

