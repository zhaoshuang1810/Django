*** Settings ***
Library           AppiumLibrary
Library           ../../Lib/Function.py
Library           ../../Lib/PrivateMethod.py
Library           ../../Lib/Android.py
Variables         ../../Conf/Properties.py
Resource	       BusGuiCom.robot


*** Variables ***
&{android_info}      platformName=${platformName}   platformVersion=${platformVersion}   deviceName=${deviceName}      noReset=${noReset}   fullReset=${fullReset}   fastReset=${fastReset}


*** Keywords ***
Setup_suite
    [Documentation]     Suite Setup
    open_old_app

open_new_app
    [Documentation]  通过apk打开app
    Open Application     ${remote_url}     app=${app}    &{android_info}
    sleep    10
    click_exsit_location    location007
    click_exsit_location    location011
    swipe by percent     80    50    20    50
    click_location    location013

open_old_app
    [Documentation]  通过appActivity，打开app
    Open Application     ${remote_url}     appPackage=${appPackage}   appActivity=${appActivity}    &{android_info}
    sleep    10

Teardown_suite
    [Documentation]     Suite Teardown
    Close Application

Setup_test
    [Documentation]  Test Setup，进入首页
    click_location    location001


Teardown_test
    [Documentation]  Test Teardown，返回首页
    back_until_loction_exist     location001