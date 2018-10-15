*** Settings ***
Force Tags        DocTest    QuestionType
Library           ../../Lib/JsonRead.py
Library           Collections
Resource          ../../Business/API/BusApiCom.robot
Resource          ../../Business/API/Bus_Basic.robot
Variables         ../../Data/Variables.py
Suite Setup      change_subjecttypeId    2    ${subjecttypeId}


*** Variables ***
${subjecttypeId}         24
${chapterId}        29848


*** Test Cases ***
post/questionTypes/next
	[Documentation]    题目下一阶段
	[Tags]    Run
	${params}    getParam_doc    post    /questionTypes/next
	set to dictionary    ${params}    chapterId=${chapterId}     planType=CHAPTER_PRACTICE
	${resp}    getApiResp    post    /questionTypes/next    params=${params}
	${result}    docmentAssert    post    /questionTypes/next    ${resp}
	should be true     ${result[0]}     ${result}

get/questionTypes/examQuestion
	[Documentation]    题目详情 (8种类型)
	[Tags]    Run
	${params}    getParam_doc    get      /questionTypes/examQuestion
	remove from dictionary     ${params}    userAnswerId
	set to dictionary    ${params}    stratumId=${chapterId}     planType=CHAPTER_PRACTICE    needAnswer=1
	${resp}    getApiResp    get    /questionTypes/examQuestion    params=${params}
	${result}    docmentAssert    get    /questionTypes/examQuestion    ${resp}
	should be true     ${result[0]}     ${result}

get/questionTypes/myQuestionStem/{chapterId}
	[Documentation]    我的收藏列表/我的错题列表
	[Tags]    Run
	${params}    getParam_doc    get    /questionTypes/myQuestionStem/{chapterId}
	set to dictionary    ${params}    chapterId=${chapterId}     planType=MY_COLLECT
	${resp}    getApiResp    get    /questionTypes/myQuestionStem/{chapterId}    params=${params}
	${result}    docmentAssert    get    /questionTypes/myQuestionStem/{chapterId}    ${resp}
	should be true     ${result[0]}     ${result}

get/questionTypes/examPapers/history
	[Documentation]    套卷模拟历史纪录
	[Tags]    Run
	${resp}    getApiResp    get    /questionTypes/examPapers/history
	${result}    docmentAssert    get    /questionTypes/examPapers/history    ${resp}
	should be true     ${result[0]}     ${result}

get/questionTypes/chapters
	[Documentation]    章节列表 （章节练习/只做错题/我的收藏/我的错题）
	[Tags]    Run
	${params}    getParam_doc    get     /questionTypes/chapters
	set to dictionary    ${params}     planType=MY_COLLECT
	${resp}    getApiResp    get    /questionTypes/chapters    params=${params}
	${result}    docmentAssert    get    /questionTypes/chapters    ${resp}
	should be true     ${result[0]}     ${result}

get/questionTypes/examPapers
	[Documentation]    套卷模拟列表
	[Tags]    Run
	${resp}    getApiResp    get    /questionTypes/examPapers
	${result}    docmentAssert    get    /questionTypes/examPapers    ${resp}
	should be true     ${result[0]}     ${result}

