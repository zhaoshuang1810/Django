*** Settings ***
Force Tags         FunTestAPI
Resource        ../../Business/API/Bus_Coin.robot
Resource        ../../Business/API/Bus_Daily.robot
Resource        ../../Business/API/Bus_Basic.robot
Resource        ../../Business/API/Bus_Learn.robot
Variables       ../../Data/Variables.py


*** Variables ***
${subjecttype-0101/0401}          现代管理学
@{examtype-04}          自考    广告（本）


*** Test Cases ***
TestCase001
    [Documentation]    修改科目类型-现代管理学（自考,广告（本））
     [Tags]    Run    BasicFunction    API
    change_subjecttype    130395    ${examtype-04}    ${subjecttype-0101/0401}

