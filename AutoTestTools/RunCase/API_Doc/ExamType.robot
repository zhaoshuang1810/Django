*** Settings ***
Force Tags        DocTest    ExamType
Library           ../../Lib/JsonRead.py
Resource          ../../Business/API/BusApiCom.robot
Variables         ../../Data/Variables.py


*** Test Cases ***
get/examTypes
	[Documentation]    查询考试类型列表
	[Tags]    Run
	${resp}    getApiResp    get    /examTypes
	${result}    docmentAssert    get    /examTypes    ${resp}
	should be true     ${result[0]}     ${result}

get/examTypes/subjects
	[Documentation]    获取考试类型列表-包含科目
	[Tags]    Run
	${resp}    getApiResp    get    /examTypes/subjects
	${result}    docmentAssert    get    /examTypes/subjects    ${resp}
	should be true     ${result[0]}     ${result}

