*** Settings ***
Library       ../Lib/HttpRequest.py
Library       ../Lib/JsonRead.py
Library       ../Lib/AssertResp.py
Library       Collections


*** Keywords ***
getApiResp
    [Arguments]   ${headers}    ${mode}    ${path}    ${params}=${EMPTY}
    ${resp}      getResponse     ${headers}    ${mode}    ${path}     ${params}
    should be equal as integers      ${resp[0]}    200
    log    ${resp[1]}
    [Return]     ${resp[1]}

docmentAssert
    [Arguments]    ${mode}    ${path}    ${resp}
    ${resp_doc}     getResp_doc     ${mode}    ${path}
    log    ${resp}
    log    ${resp_doc}
    ${result}    assertresp    ${resp}    ${resp_doc}
    [Return]    ${result}

docmentAssert2
    [Arguments]    ${mode}    ${path}    ${resp}     @{off_fields}
    [Documentation]    去除不想要对比的字段
    ${resp_doc}     getResp_doc     ${mode}    ${path}
    remove from dictionary      ${resp}     @{off_fields}
    remove from dictionary     ${resp_doc}     @{off_fields}
    log    ${resp}
    log    ${resp_doc}
    ${result}    assertresp    ${resp}    ${resp_doc}
    [Return]    ${result}

respValueAssert
    [Arguments]    ${filename}    ${casename}    ${resp}
    ${resp_data}     getResp_data    ${filename}    ${casename}
    log    ${resp}
    log    ${resp_data}
    ${result}    assertrespvalue    ${resp}    ${resp_data}
    [Return]    ${result}


re_change_examtype
    [Arguments]      ${headers}     ${examtypeid}     ${subjectid}
    [Documentation]  切换考试类型，科目类型
    ${params}    create dictionary       examTypeId=${examtypeid}     recomment=${True}
	${resp}    getApiResp    ${headers}    put    /users/examTypes    ${params}
	${params}    create dictionary       subjectId=${subjectid}
	${resp}    getApiResp    ${headers}    put    /users/subjects    ${params}
	${params}    create dictionary      lat=${EMPTY}      lon=${EMPTY}
	${resp}    getApiResp    ${headers}    get    /users/me    ${params}
	should be equal as strings    ${resp['examTypeId']}      ${examtypeid}
	should be equal as strings    ${resp['currentSubjectId']}      ${subjectid}


