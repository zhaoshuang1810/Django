*** Settings ***
Resource         BusApiCom.robot
Resource         Bus_Basic.robot
Resource         Bus_Coin.robot
Library          ../../Lib/PrivateMethod.py
Library          ../../Lib/GetSQL.py
Variables        ../../Data/Variables.py

*** Variables ***
@{userAnswer_pid}     userId    userAnswerId    answerPlanId    assignmentId    examPaperId    chapterId
@{not_requiredId}     userAnswerId    examPaperId    chapterId    assignmentId


*** Keywords ***
learnplan_exist
    [Arguments]    ${user}     ${examtype}    ${subjects}
    ${examTypeId}    ${subjecttypeId}    change_examtype    ${user}    ${examtype}
    ${respcode}   getApiRespCode    ${user}    get    /learningPlan/info
    return from keyword if     ${respcode}==200      ${True}
    learnplan_create       北京市    2019年04月     ${subjects}
    [Return]         ${True}

learnplan_unexist
    [Arguments]    ${user}     ${examtype}
    ${examTypeId}    ${subjecttypeId}    change_examtype    ${user}    ${examtype}
    ${respcode}   getApiRespCode    ${user}    get    /learningPlan/info
    return from keyword if     ${respcode}==603     ${True}
    learnplan_delete    ${user}
    [Return]         ${True}

change_first_answer_status
    [Arguments]  ${user}
    [Documentation]  通过修改数据库，学习计划改为首次学习
    ${list}   get_current_examtype    ${user}
    update_learning_plan_daily_To_compliance     ${user}    exam_type_id=${list[0]}

learnplan_create_fail
    [Arguments]    ${user}     ${place}     ${time}     ${subjects}
	${params}    re_get_plan_params    ${user}     ${place}     ${time}     ${subjects}
	${respcode}    getApiRespCode    ${user}    post    /learningPlan    ${params}   
	should be true      ${respcode}==601     没有创建失败

learnplan_create
    [Arguments]    ${user}     ${place}     ${time}     ${subjects}
	${params}    re_get_plan_params    ${user}     ${place}     ${time}     ${subjects}
	${resp}    getApiRespContent    ${user}    post    /learningPlan    ${params}   
	should be true      ${resp}     创建学习计划失败

learnplan_delete
    [Arguments]    ${user}
    [Documentation]   删除当前学习计划
    ${list}   get_current_examtype    ${user}
    ${examTypeId}    set variable      ${list[0]}
    update learning plan To del flag     ${user}     ${examTypeId}
    ${respcode}   getApiRespCode    ${user}    get    /learningPlan/info
    should be equal as integers      ${respcode}    603

learnplan_update
    [Arguments]    ${user}       ${place}     ${time}     ${subjects}
    [Documentation]    调整学习计划
    ${params}    re_get_plan_params    ${user}     ${place}     ${time}     ${subjects}
	${resp}    getApiRespContent    ${user}    put    /learningPlan/update    ${params}   
	should be true      ${resp}     调整学习计划失败

learnplan_answers_first
    [Arguments]    ${user}     ${subjecttype}    ${answer}
    [Documentation]  题未做过，第一次做
    ${total_1}     re_get_cointotal    ${user}
    re_learn_subject_answer     ${user}     ${subjecttype}    ${answer}
    ${subjectTaskId}    ${finish}    re_get_subjectTaskId    ${user}      ${subjecttype}
    should be true      ${finish}     答题失败
    re_assert_coin_record    ${user}    0    6    10
    ${total_2}     re_get_cointotal    ${user}
    should be true      int(${total_2})>${total_1}    轻豆未增加

learnplan_answers_unfirst
    [Arguments]    ${user}     ${subjecttype}    ${answer}
    [Documentation]     题已做过，重复做
    ${total_1}     re_get_cointotal    ${user}
    ${subjectTaskId}    ${finish}    re_get_subjectTaskId    ${user}      ${subjecttype}
    should be true      ${finish}    学习计划科目${subjecttype} 的题今日还未做过
    re_learn_subject_answer     ${user}     ${subjecttype}    ${answer}
    ${total_2}     re_get_cointotal    ${user}
    should be true      int(${total_2})==${total_1}    轻豆应该不变

learnplan_answer_lastsubject
    [Arguments]    ${user}     ${subjecttype}    ${answer}
    [Documentation]  学习计划最后一个科目答题结束后，不仅本身增加轻豆10，还会额外增加轻豆50
    ${total_1}     re_get_cointotal    ${user}
    re_learn_subject_answer     ${user}     ${subjecttype}    ${answer}
    ${subjectTaskId}    ${finish}    re_get_subjectTaskId    ${user}      ${subjecttype}
    should be true      ${finish}     答题失败
    re_assert_coin_record    ${user}    0    6    50
    re_assert_coin_record    ${user}    1    6    10
    ${total_2}     re_get_cointotal    ${user}
    should be true      int(${total_2})>${total_1}    轻豆未增加

re_get_plan_params
    [Arguments]    ${user}    ${place}    ${time}    ${subjects}
    ${list}   get_current_examtype    ${user}
    ${examTypeId}    set variable      ${list[0]}
    ${placeid}     re_get_provinces    ${user}    ${place}
    should be true      int(${placeid})>0      地点输入错了
    ${timeid}     re_get_examTime    ${user}     ${placeid}     ${time}
    should not be equal as strings     ${timeid}      ${time}     考试时间输入错了
    ${subjectids}     ${subjecterrors}    getSubjectInExamtype     ${examTypeId}    ${subjects}
    should not be true      '${subjecterrors}'      ${subjecterrors}:不再当前考试类型下
	${params}    create dictionary     examTypeId=${examTypeId}    provinceId=${placeid}   subjectIds=${subjectids}     examTime=${timeid}
	[Return]   ${params}

re_learn_subject_answer
    [Arguments]  ${user}     ${subjecttype}    ${answer}
    ${params}    getParam_doc    post    /userAnswer
    remove from dictionary      ${params}    @{not_requiredId}
    ${subjectTaskId}    ${finish}    re_get_subjectTaskId    ${user}      ${subjecttype}
    set to dictionary      ${params}      planType=${planType[1]}    assignmentId=${subjectTaskId}
    ${resp}    getApiRespContent    ${user}    get    /answerPlans
    set to dictionary      ${params}      userId=${user}     answerPlanId=${resp['answerPlanId']}
    ${examQuestion}     re_get_learn_examQuestion    ${user}      ${subjecttype}
    ${questions}     ${duration_sum}   getQuestionAnswer      ${examQuestion}    ${answer}
    set to dictionary      ${params}     questions=${questions}
    set to dictionary      ${params}     duration=${duration_sum}
    ${resp}    getApiRespContent    ${user}    post    /userAnswer    ${params}
    ${userAnswerId}    get from dictionary    ${resp}    userAnswerId
    ${params}    getParam_doc    get    /userAnswer/{userAnswerId}
    set to dictionary      ${params}     userAnswerId=${userAnswerId}    infoType=answerDone
    ${resp}    getApiRespContent    ${user}    get    /userAnswer/{userAnswerId}    ${params}


re_get_learn_examQuestion
    [Arguments]    ${user}       ${subjecttype}
     [Documentation]   根据科目类型，获取题目详情
    ${subjectTaskId}    ${finish}    re_get_subjectTaskId    ${user}      ${subjecttype}
    should be true      int(${subjectTaskId})>0     科目${subjecttype}，不再当前学习计划中
     ${params}    getParam_doc    get    /questionTypes/examQuestion
    remove from dictionary      ${params}    userAnswerId
    set to dictionary      ${params}    stratumId=${subjectTaskId}    planType=${planType[1]}    needAnswer=1
    ${resp}    getApiRespContent    ${user}    get    /questionTypes/examQuestion    ${params}   
    [Return]     ${resp}


re_get_subjectTaskId
    [Arguments]    ${user}       ${subjecttype}
    [Documentation]   获取学习计划中科目对应的任务id
    ${resp}    getApiRespContent    ${user}    get    /answerPlans
    ${resp}   getApiRespContent    ${user}    get    /learningPlan/progress
    ${progressInfo}    get from dictionary     ${resp}    progressInfo
    :for    ${x}    in    @{progressInfo}
    \     ${subjectTaskId}    get from dictionary      ${x}    subjectTaskId
    \     ${finish}    get from dictionary      ${x}    finish
    \     ${subjectName}    get from dictionary      ${x}    subjectName
    \     return from keyword if      '${subjectName}'=='${subjecttype}'    ${subjectTaskId}     ${finish}
    [Return]      0    ${False}

re_get_provinces
    [Arguments]    ${user}       ${place}
    [Documentation]    判断地点输入是否正确，同时返回地点id
    ${params}    create dictionary        provinceName=北京市
	${resp}    getApiRespContent    ${user}    get    /learningPlan/provinces    ${params}   
	${placeid}     set variable    0
	:for     ${x}    in    @{resp}
	\    ${id}     get from dictionary      ${x}     id
	\    ${provinceName}    get from dictionary      ${x}     provinceName
	\    ${placeid}    set variable if      '${place}'=='${provinceName}'     ${id}
	\    exit for loop if    '${place}'=='${provinceName}'
	[Return]     ${placeid}

re_get_examTime
    [Arguments]    ${user}       ${provinceId}    ${time}
    [Documentation]    判断考试时间列表输入是否正确，返回
	${params}    create dictionary     provinceId=${provinceId}
	${resp}    getApiRespContent    ${user}    get    /learningPlan/examTimes    ${params}   
	${result}    docmentAssert    get    /learningPlan/examTimes    ${resp}
	:for    ${x}    in     @{resp}
	\    ${examTime}     get from dictionary      ${x}    examTime
	\    ${time_str}    changeExamtimeStr    ${examTime}
	\    return from keyword if      '${time}'=='${time_str}'    ${examTime}
	[Return]     ${time}


