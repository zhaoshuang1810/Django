*** Settings ***
Library           AppiumLibrary
Library           Collections
Library           ../../Lib/PrivateMethod.py
Resource	      BusGuiCom.robot


*** Keywords ***
change_subjecttype
    [Arguments]    ${examtype_name}   ${subject_name}
	click_location      location003
    click_location      location004   ${examtype_name[0]}
    swipe_up_until_loction_exist     location005   ${examtype_name[1]}
    ${location}    get location    location006    ${subject_name}
    ${exist}       is_element_exist    ${location}
    run keyword if      not ${exist}      click_location      location005   ${examtype_name[1]}
    swipe_up_until_loction_exist     location006    ${subject_name}
    click_location      location006    ${subject_name}
    ${type}    get_current_type
    should contain      ${examtype_name[1]}      ${type[0]}     考试类型不一致
    should contain      ${subject_name}     ${type[1]}     科目类型不一致


get_current_type
    ${location}    get location    location003
    ${text}    get text     ${location}
    ${type}    parser examtype     ${text}
    [Return]  ${type}