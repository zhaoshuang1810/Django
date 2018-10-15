*** Settings ***
Force Tags        DocTest    IM
Library           ../../Lib/JsonRead.py
Library           Collections
Resource          ../../Business/API/BusApiCom.robot
Variables         ../../Data/Variables.py


*** Variables ***
${imId}       @TGS#a5YDTFIFL


*** Test Cases ***
post/commodity/api/v1/IM/quit
	[Documentation]    聊天室退出（芒果会计小程序）
	[Tags]    Run
	${params}    getParam_doc    post    /commodity/api/v1/IM/quit
	set to dictionary       ${params}     imId=${imId}
	${resp}    getApiResp    post    /commodity/api/v1/IM/quit    params=${params}
	${result}    docmentAssert    post    /commodity/api/v1/IM/quit    ${resp}
	should be true     ${result[0]}     ${result}

post/commodity/api/v1/IM/join
	[Documentation]    聊天室加入（芒果会计小程序）
	[Tags]    Run
	${params}    getParam_doc    post    /commodity/api/v1/IM/join
	set to dictionary       ${params}     imId=${imId}
	${resp}    getApiResp    post    /commodity/api/v1/IM/join    params=${params}
	${result}    docmentAssert    post    /commodity/api/v1/IM/join    ${resp}
	should be true     ${result[0]}     ${result}

