*** Settings ***
Force Tags         FunTestGUI
Suite Setup	         Setup_suite
Suite Teardown	     Teardown_suite
Test Setup	         Setup_test
Test Teardown	     Teardown_test
Resource             ../../Business/GUI/Init.robot
Resource        ../../Business/GUI/Bus_Basic.robot
Variables       ../../Data/Variables.py


*** Variables ***
${subjecttype-0101/0401}          现代管理学
@{examtype-04}          自考    广告（本）


*** Test Cases ***
TestCase001
    [Documentation]    修改科目类型-现代管理学（自考,广告（本））
     [Tags]    Run    API    BasicInfo
    change_subjecttype    130395    ${examtype-04}    ${subjecttype-0101/0401}

