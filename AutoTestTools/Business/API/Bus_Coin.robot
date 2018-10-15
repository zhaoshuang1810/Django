*** Settings ***
Resource         BusApiCom.robot
Library          ../../Lib/PrivateMethod.py

*** Keywords ***
re_get_cointotal
    [Arguments]   ${user}
    ${resp}     getApiRespContent    ${user}    get    /coin/center
    ${total}     get from dictionary    ${resp}    total
    [Return]  ${total}

re_assert_coin_record
    [Arguments]   ${user}    ${num}    ${mode}     ${count}
    [Documentation]  获取轻豆中心明细，与给定参数做比较 ，num代表次数，0代表最新一次
    ${resp}    getApiRespContent    ${user}    get    /coin/details
    should be equal as integers      ${resp['month'][${num}]['mode']}     ${mode}       获取方式错误->0.系统赠送,1.签到;2.打卡,3.摇奖,4.pk任务,6.学习计划
    should be equal as integers      ${resp['month'][${num}]['count']}    ${count}     轻豆增加数量错误