*** Settings ***
Resource         BusApiCom.robot
Library          ../../Lib/PrivateMethod.py

*** Keywords ***
change_examtype
    [Arguments]    ${user}    ${examtype_name}
    ${examTypeId}    ${subjecttypeId}    typeZhToEn     exam=${examtype_name[1]}
	${list}    change_examtypeId    ${user}    ${examtypeId}     ${subjecttypeId}
	should be equal as strings    ${list[1]}      ${examtype_name[1]}
	[Return]   ${examtypeId}    ${subjecttypeId}

change_subjecttype
    [Arguments]    ${user}    ${examtype_name}   ${subject_name}
    ${examTypeId}    ${subjecttypeId}     typeZhToEn     exam=${examtype_name[1]}    subject=${subject_name}
    ${list}    change_subjecttypeId   ${user}    ${subjecttypeId}
	should be equal as strings    ${list[3]}      ${subject_name}
	[Return]  ${examtypeId}    ${subjecttypeId}

change_examtypeId
    [Arguments]    ${user}    ${examTypeId}    ${subjectId}
     ${params}    create dictionary       examTypeId=${examTypeId}     recomment=${True}
	${resp}    getApiRespContent    ${user}       put    /users/examTypes    ${params}
	sleep     1s
	${params}    create dictionary       subjectId=${subjectId}
	${resp}    getApiRespContent    ${user}     put    /users/subjects    ${params}
	sleep     2s
	${params}    create dictionary      lat=${EMPTY}      lon=${EMPTY}
	${resp}    getApiRespContent    ${user}      get    /users/me    ${params}
	${examType}    get from dictionary    ${resp}    examType
	${subject}    get from dictionary    ${resp}    currentSubject
	should be equal as integers    ${resp['examTypeId']}      ${examTypeId}
	should be equal as integers    ${resp['currentSubjectId']}      ${subjectId}
	${list}    create list      ${examTypeId}    ${examType}     ${subjectId}    ${subject}
	[Return]   ${list}

change_subjecttypeId
    [Arguments]    ${user}    ${subjectId}
	${params}    create dictionary       subjectId=${subjectId}
	${resp}    getApiRespContent    ${user}     put    /users/subjects    ${params}
	sleep     2s
	${params}    create dictionary      lat=${EMPTY}      lon=${EMPTY}
	${resp}    getApiRespContent    ${user}      get    /users/me    ${params}
	${examTypeId}    get from dictionary    ${resp}    examTypeId
	${examType}    get from dictionary    ${resp}    examType
	${subject}    get from dictionary    ${resp}    currentSubject
	should be equal as integers    ${resp['currentSubjectId']}      ${subjectId}
	${list}    create list      ${examTypeId}    ${examType}     ${subjectId}    ${subject}
	[Return]   ${list}

get_current_examtype
    [Arguments]     ${user}
    ${params}    create dictionary      lat=${EMPTY}      lon=${EMPTY}
	${resp}    getApiRespContent    ${user}     get    /users/me    ${params}
	${examTypeId}    get from dictionary    ${resp}    examTypeId
	${examType}    get from dictionary    ${resp}    examType
	${subjectId}    get from dictionary    ${resp}    currentSubjectId
	${subject}    get from dictionary    ${resp}    currentSubject
	${list}    create list      ${examTypeId}    ${examType}    ${subjectId}    ${subject}
	[Return]     ${list}

