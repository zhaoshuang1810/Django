*** Settings ***
Force Tags        DocTest    PushMessage
Library           ../../Lib/JsonRead.py
Library           Collections
Resource          ../../Business/API/BusApiCom.robot
Variables         ../../Data/Variables.py


*** Test Cases ***
post/pushMessage/formid
	[Documentation]    模版消息
	[Tags]    Run
	${params}    getParam_doc    post     /pushMessage/formid
    set to dictionary     ${params}    messageType=CLOCK_IN_REMIND     formId=1529380333208
	${resp}    getApiResp    post    /pushMessage/formid    params=${params}
	${result}    docmentAssert    post    /pushMessage/formid    ${resp}
	should be true     ${result[0]}     ${result}

