*** Settings ***
Resource         BusApiCom.robot
Resource         Bus_Basic.robot
Resource         Bus_Coin.robot
Library          ../../Lib/PrivateMethod.py
Library          ../../Lib/JsonRead.py
Library          ../../Lib/GetSQL.py
Library           Collections
Variables        ../../Data/Variables.py

*** Variables ***
@{userAnswer_pid}     userId    userAnswerId    answerPlanId    assignmentId    examPaperId    chapterId
@{not_requiredId}     userAnswerId    examPaperId    chapterId    assignmentId


*** Keywords ***
dailyPractice_unClockin_all
    [Arguments]    ${user}
    [Documentation]  每日一练所有科目，未打卡状态
    update_user_clock_in_To_details    ${user}

dailyPractice_unClockin
    [Arguments]   ${user}    ${examtype_name}    ${subject_name}
    [Documentation]  每日一练某个科目，未打卡状态
    ${examtypeId}    ${subjectId}    change_subjecttype    ${user}    ${examtype_name}   ${subject_name}
    update_user_clock_in_To_details     ${user}    subject_id=${subjectId}


dailyPractice_answers
    [Arguments]    ${user}    ${answer}
    [Documentation]   答题
    ${assignmentId}    ${examQuestion}    re_get_daily_examQuestion    ${user}
    ${params}    getParam_doc    post    /userAnswer
    remove from dictionary      ${params}    @{not_requiredId}
    set to dictionary      ${params}      planType=${planType[0]}    assignmentId=${assignmentId}
    ${resp}    getApiRespContent    ${user}    get    /answerPlans
    set to dictionary      ${params}      userId=${user}     answerPlanId=${resp['answerPlanId']}
    ${questions}     ${duration_sum}   getQuestionAnswer      ${examQuestion}    ${answer}
    set to dictionary      ${params}     questions=${questions}
    set to dictionary      ${params}     duration=${duration_sum}
    ${resp}    getApiRespContent    ${user}    post    /userAnswer    ${params}   
    [Return]     ${params}    ${resp}

dailyPractice_clockin_first
    [Arguments]     ${user}
    [Documentation]  每日一练首次打卡，获取轻豆
    ${total_1}     re_get_cointotal    ${user}
    ${answer_status}    ${clockIn_status}    re_get_answer_and_clockIn_status    ${user}
    should be true       ${answer_status}      答题失败
    should be true      int(${clockIn_status})==1    当前不是打卡状态
    ${resp}    getApiRespContent    ${user}    post    /dailyPractice/userClockIn
    should be true     ${resp['isFirst']}     不是首次打卡
    re_assert_coin_record   ${user}    2    10
    ${total_2}     re_get_cointotal    ${user}
    should be true      int(${total_2})>int(${total_1})    轻豆未增加

dailyPractice_clockin_unfirst
    [Arguments]  ${user}
    [Documentation]  每日一练不同科目重复打卡，轻豆不变
    ${total_1}     re_get_cointotal    ${user}
    ${answer_status}    ${clockIn_status}    re_get_answer_and_clockIn_status    ${user}
    should be true       ${answer_status}      答题失败
    should be true      int(${clockIn_status})==1   当前不是打卡状态
    ${resp}    getApiRespContent    ${user}    post    /dailyPractice/userClockIn
    should be true     not ${resp['isFirst']}     首次打卡
    ${total_2}     re_get_cointotal    ${user}
    should be true      int(${total_2})==int(${total_1})    轻豆变化了

dailyPractice_clockin_fail
    [Arguments]      ${user}
    [Documentation]  每日一练同一科目重复打卡，打卡失败
    ${answer_status}    ${clockIn_status}    re_get_answer_and_clockIn_status    ${user}
    should be true       ${answer_status}      答题失败
    should be true      int(${clockIn_status})==0    当前是未打卡状态
    ${respcode}    getApiRespCode    ${user}    post    /dailyPractice/userClockIn
    should be true      int(${respcode})!=200     打卡成功

re_get_daily_examQuestion
    [Arguments]      ${user}
    [Documentation]  获取题目详情
    ${params}    getParam_doc    get    /dailyPractice/examPapers
	${yyyy}    ${mm}     ${dd}    Get Time    year,month,day
	set to dictionary    ${params}    year=${yyyy}     month=${mm}    number=${dd}
	${resp}    getApiRespContent    ${user}    get    /dailyPractice/examPapers    ${params}   
    ${params}    getParam_doc    get    /questionTypes/examQuestion
    ${assignmentId}    get from dictionary      ${resp['assignmentList'][0]}     assignmentId
    remove from dictionary      ${params}    userAnswerId
    set to dictionary      ${params}    stratumId=${assignmentId}    planType=${planType[0]}    needAnswer=1
    ${resp}    getApiRespContent    ${user}    get    /questionTypes/examQuestion    ${params}   
    [Return]   ${assignmentId}   ${resp}

re_get_answer_and_clockIn_status
    [Arguments]  ${user}
    [Documentation]  获取当前科目 答题和打卡状态  clockIn_status （0 ：已打卡 1： 去打卡：可以打卡 2： 去打卡,不可以打卡 3：未打卡）
    ${params}    getParam_doc    get    /dailyPractice/examPapers
	${yyyy}    ${mm}     ${dd}    Get Time    year,month,day
	set to dictionary    ${params}    year=${yyyy}     month=${mm}    number=${dd}
	${resp}    getApiRespContent    ${user}    get    /dailyPractice/examPapers    ${params}   
    ${answer_status}     set variable if     ${resp['assignmentList'][0]['total']}==${resp['assignmentList'][0]['current']}      ${True}     ${False}
    ${clockIn_status}    get from dictionary      ${resp}    clockIn
    [Return]    ${answer_status}    ${clockIn_status}