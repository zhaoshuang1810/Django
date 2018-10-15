*** Settings ***
Force Tags         FunTestAPI
Resource        ../../Business/API/Bus_Basic.robot
Resource        ../../Business/API/Bus_Coin.robot
Resource        ../../Business/API/Bus_Daily.robot
Resource        ../../Business/API/Bus_Learn.robot
Variables       ../../Data/Variables.py


*** Variables ***
${answers-02}          0
${subjecttype-0701}          行政组织理论
@{examtype-07}          自考    行政管理（本）


*** Test Cases ***
TestCase005
    [Documentation]    每日一练首次打卡，获得轻豆
     [Tags]    Run    API    DailyPractice
    dailyPractice_answers    130395    ${answers-02}
    dailyPractice_clockin_first    130395

TestCase007
    [Documentation]    每日一练，已打卡状态下，打卡失败
     [Tags]    Run    API    DailyPractice
    dailyPractice_clockin_fail    130395

TestCase009
    [Documentation]    每日一练，切换科目类型，再次打卡，轻豆不变
     [Tags]    Run    API    DailyPractice
    dailyPractice_unClockin    130395    ${examtype-07}    ${subjecttype-0701}
    dailyPractice_answers    130395    ${answers-02}
    dailyPractice_clockin_unfirst    130395

