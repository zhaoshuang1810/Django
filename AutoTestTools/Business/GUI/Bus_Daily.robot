*** Settings ***
Library           AppiumLibrary
Library           Collections
Library           ../../Lib/PrivateMethod.py
Resource	      BusGuiCom.robot

*** Keywords ***
dailyPractice_answers
    [Arguments]    ${answer}
    [Documentation]   答题
    click_location     location023
    ${len}    get length      ${answer}
    ${x}    set variable    0
    :for    ${a}    in    @{answer}
    \      ${x}    evaluate     int(${x})+1
    \      click_location     location035    ${a}
    \      exit for loop if      ${x}==${len}
    \      re_swipe_left_if_multiple_choice
    re_click_submit

dailyPractice_clockin
    [Documentation]  打卡
    click_location    location055
    ${location}    get location    location057
    ${exist}     is_element_exist    ${location}
    should be true      ${exist}     打卡后,没有跳转到分享页面

re_swipe_left_if_multiple_choice
    [Documentation]  对选题
    ${location}     get location     location031
    ${text}     get text      ${location}
    ${choice}    set variable if     "${text}"=="多选题"     ${True}     ${False}
    run keyword if     ${choice}    swipe by percent      80    50    20    50

re_click_submit
    [Documentation]  提交答案
    click_exsit_location     location037
    click_location     location042
    click_exsit_location     location046


