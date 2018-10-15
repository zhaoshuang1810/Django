*** Settings ***
Force Tags        DocTest    CUT_PRICE
Library           ../../Lib/JsonRead.py
Library           ../../Lib/GetSQL.py
Library           Collections
Resource          ../../Business/API/BusApiCom.robot
Variables         ../../Data/Variables.py


*** Variables ***
&{headers_m}     token=${token_m}     reqchannel=${reqchannel[1]}
&{headers_m01}     token=${token_m01}     reqchannel=${reqchannel[1]}
${commodityId}      5
${type}             0
${costPrice}        298000


*** Test Cases ***
post/trans/api/v1/cutPrice/reSystemCutPrice
	[Documentation]    系统砍价
	[Tags]    Run    MANGO
	${params}    getParam_doc    post    /trans/api/v1/cutPrice/reSystemCutPrice
    set to dictionary      ${params}    commodityId=${commodityId}    type=${type}     costPrice=${costPrice}
	${resp}    getApiResp    post    /trans/api/v1/cutPrice/reSystemCutPrice    params=${params}    &{headers_m}
	${result}    docmentAssert    post    /trans/api/v1/cutPrice/reSystemCutPrice    ${resp}
	should be true     ${result[0]}     ${result}

post/trans/api/v1/cutPrice/getCutPriceHelpTimes
	[Documentation]    用户帮助砍价次数
	[Tags]    Run    MANGO
	${resp}    getApiResp    get    /trans/api/v1/cutPrice/getCutPriceHelpTimes     &{headers_m}
	${result}    docmentAssert    get    /trans/api/v1/cutPrice/getCutPriceHelpTimes    ${resp}
	should be true     ${result[0]}     ${result}

post/trans/api/v1/cutPrice/friendsCutPrice
	[Documentation]    好友砍价
	[Tags]    Run    MANGO
    update commodity cut To create date      ${commodityId}     ${userId_m}    ${userId_m01}
    ${params}    getParam_doc    get    /users/share
    set to dictionary      ${params}    shareType=CUT
    remove from dictionary      ${params}    pkLogId
    ${resp}    getApiResp    get    /users/share    params=${params}    &{headers_m}
	${params}    getParam_doc    post    /trans/api/v1/cutPrice/friendsCutPrice
	set to dictionary      ${params}    commodityId=${commodityId}    mark=${token_m_30}
	${resp}    getApiResp    post    /trans/api/v1/cutPrice/friendsCutPrice    params=${params}    &{headers_m01}
	${result}    docmentAssert    post    /trans/api/v1/cutPrice/friendsCutPrice    ${resp}
	should be true     ${result[0]}     ${result}

get/trans/api/v1/cutPrice/getCommodityInfo
	[Documentation]    获取用户活动详情
	[Tags]    Run    MANGO
	${params}    getParam_doc    get    /trans/api/v1/cutPrice/getCommodityInfo
	set to dictionary      ${params}    commodityId=${commodityId}    mark=${token_m_30}
	${resp}    getApiResp    get    /trans/api/v1/cutPrice/getCommodityInfo    params=${params}    &{headers_m}
	${result}    docmentAssert    get    /trans/api/v1/cutPrice/getCommodityInfo    ${resp}
	should be true     ${result[0]}     ${result}

post/trans/api/v1/cutPrice/systemCutPrice
	[Documentation]    系统砍价,已废弃
	[Tags]    NotRun    MANGO
	${params}    getParam_doc    post    /trans/api/v1/cutPrice/systemCutPrice
	${resp}    getApiResp    post    /trans/api/v1/cutPrice/systemCutPrice    params=${params}    &{headers_m}
	${result}    docmentAssert    post    /trans/api/v1/cutPrice/systemCutPrice    ${resp}
	should be true     ${result[0]}     ${result}

