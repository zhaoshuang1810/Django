*** Settings ***
Force Tags        DocTest    WebSocketServer
Library           ../../Lib/JsonRead.py
Resource          ../../Business/API/BusApiCom.robot
Variables         ../../Data/Variables.py


*** Test Cases ***
get/webSocketServer/pk
	[Documentation]    pk在线状态，等待匹配对手
	[Tags]    NotRun
	${resp}    getApiResp    get    /webSocketServer/pk
	${result}    docmentAssert    get    /webSocketServer/pk    ${resp}
	should be true     ${result[0]}     ${result}

