*** Settings ***
Force Tags         FunTestAPI
Resource        ../../Business/API/Bus_Basic.robot
Resource        ../../Business/API/Bus_Coin.robot
Resource        ../../Business/API/Bus_Daily.robot
Resource        ../../Business/API/Bus_Learn.robot
Variables       ../../Data/Variables.py


*** Variables ***
${subjecttype-0101/0401}          现代管理学
@{examtype-01}          自考    行政管理（专）
@{examtype-04}          自考    广告（本）
@{examtype-06}          自考    人力资源（本）
${subjecttype-0601}          行政管理学


*** Test Cases ***
TestCase002
    [Documentation]    修改考试类型-自考,行政管理（专）
     [Tags]    Run    API    BasicInfo
    change_examtype    130395    ${examtype-01}

TestCase001
    [Documentation]    修改科目类型-现代管理学（自考,广告（本））
     [Tags]    Run    API    BasicInfo
    change_subjecttype    130395    ${examtype-04}    ${subjecttype-0101/0401}

TestCase010
    [Documentation]    修改科目类型-现代管理学（行政管理（专））
     [Tags]    Run    API    BasicInfo
    change_subjecttype    130395    ${examtype-01}    ${subjecttype-0101/0401}

TestCase011
    [Documentation]    修改科目类型-行政管理学（人力资源（本））
     [Tags]    Run    API    BasicInfo
    change_subjecttype    130395    ${examtype-06}    ${subjecttype-0601}

