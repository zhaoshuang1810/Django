*** Settings ***
Force Tags         FunTestAPI
Resource        ../../Business/API/Bus_Basic.robot
Resource        ../../Business/API/Bus_Coin.robot
Resource        ../../Business/API/Bus_Daily.robot
Resource        ../../Business/API/Bus_Learn.robot
Variables       ../../Data/Variables.py


*** Variables ***
${examplace-01}          北京市
${examtime-01}          2019年04月
@{subjects-0301}          法学概论    企业管理概论    国民经济统计概论
@{examtype-03}          自考    市场营销（专）
${subjecttype-0501}          语言学概论
@{answers-01}          A    B    1
${subjecttype-0502}          中国古代文学史（一）
${answers-04}          -1
${answers-02}          0
${subjecttype-0504}          中国现代文学史
${answers-03}          1
${subjecttype-0503}          外国文学史
@{examtype-02}          自考    公共课（专）
@{subjects-0201}          思想道德修养与法律基础    大学语文
@{examtype-05}          自考    汉语言文学（本）
@{subjects-0501}          语言学概论    外国文学史    中国现代文学史    中国古代文学史（一）
@{subjects-0202}          思想道德修养与法律基础    大学语文    经济法概论（财经类）


*** Test Cases ***
TestCase003
    [Documentation]    无考试类型的状态下，创建学习计划
     [Tags]    Run    API    LearnPlan
    learnplan_unexist    130395    ${examtype-03}
    learnplan_create    130395    ${examplace-01}    ${examtime-01}    ${subjects-0301}

TestCase008
    [Documentation]    在已经有学习计划的情况下，创建学习计划失败
     [Tags]    Run    API    LearnPlan
    learnplan_exist    130395    ${examtype-02}    ${subjects-0201}
    learnplan_create_fail    130395    ${examplace-01}    ${examtime-01}    ${subjects-0201}

TestCase014
    [Documentation]    学习计划，调整已有的学习计划
     [Tags]    Run    API    LearnPlan
    learnplan_exist    130395    ${examtype-02}    ${subjects-0201}
    learnplan_update    130395    ${examplace-01}    ${examtime-01}    ${subjects-0202}

TestCase012
    [Documentation]    学习计划-自考,汉语言文学（本），修改到首次进入时的答题状态
     [Tags]    Run    API    LearnPlan
    learnplan_exist    130395    ${examtype-05}    ${subjects-0501}
    change_first_answer_status    130395

TestCase004
    [Documentation]    自考,汉语言文学（本）下，学习计划，首次答题获得轻豆
     [Tags]    Run    API    LearnPlan
    learnplan_answers_first    130395    ${subjecttype-0504}    ${answers-02}
    learnplan_answers_first    130395    ${subjecttype-0501}    ${answers-01}
    learnplan_answers_first    130395    ${subjecttype-0502}    ${answers-04}
    learnplan_answer_lastsubject    130395    ${subjecttype-0503}    ${answers-03}

TestCase013
    [Documentation]    学习计划下的科目，重复答题，轻豆不变
     [Tags]    Run    API    LearnPlan
    learnplan_answers_unfirst    130395    ${subjecttype-0501}    ${answers-02}
    learnplan_answers_unfirst    130395    ${subjecttype-0502}    ${answers-01}

