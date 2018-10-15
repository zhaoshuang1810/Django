*** Settings ***
Force Tags        DocTest    ocpa
Library           ../../Lib/JsonRead.py
Library           Collections
Resource          ../../Business/API/BusApiCom.robot
Variables         ../../Data/Variables.py


*** Test Cases ***
post/acquisition/award
	[Documentation]    请求领取福利,没有测试地址，同时是临时项目，暂时不测
	[Tags]    NotRun
	${params}    getParam_doc    post    /acquisition/award
	${resp}    getApiResp    post    /acquisition/award    params=${params}
	${result}    docmentAssert    post    /acquisition/award    ${resp}
	should be true     ${result[0]}     ${result}

get/acquisition/form
	[Documentation]    福利表单信息上传
	[Tags]    NotRun
	${params}    getParam_doc    get    /acquisition/form
	${resp}    getApiResp    get    /acquisition/form    params=${params}
	${result}    docmentAssert    get    /acquisition/form    ${resp}
	should be true     ${result[0]}     ${result}

post/acquisition/form
	[Documentation]    福利表单信息上传
	[Tags]    NotRun
	${params}    getParam_doc    post    /acquisition/form
	${resp}    getApiResp    post    /acquisition/form    params=${params}
	${result}    docmentAssert    post    /acquisition/form    ${resp}
	should be true     ${result[0]}     ${result}


