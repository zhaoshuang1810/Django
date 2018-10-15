*** Settings ***
Force Tags        DocTest    TRANS
Library           ../../Lib/JsonRead.py
Library           ../../Lib/GetSQL.py
Library           Collections
Resource          ../../Business/API/BusApiCom.robot
Variables         ../../Data/Variables.py


*** Variables ***
&{headers_m}     token=${token_m}     reqchannel=${reqchannel[1]}
${commodityId}
${commodityIds}
${orderCode}


*** Test Cases ***
post/trans/api/v1/order/prePay
	[Documentation]    预生成订单（芒果会计小程序）
	[Tags]    Run    MANGO
	${params}    getParam_doc   post    /trans/api/v1/order/prePay
	set to dictionary       ${params}     prePayType=CUT
	set to dictionary       ${params['0']}     commodityId=8    commodityNum=1
	${resp}    getApiResp    post    /trans/api/v1/order/prePay    params=${params}    &{headers_m}
	${result}    docmentAssert    post    /trans/api/v1/order/prePay    ${resp}
	should be true     ${result[0]}     ${result}

get/trans/api/v1/order
	[Documentation]    未支付订单列表（公众号）
	[Tags]    Run    MANGO
	${resp}    getApiResp    get    /trans/api/v1/order    &{headers_m}
	set suite variable      ${orderCode}    ${resp[0]['orderCode']}
	${result}    docmentAssert    get    /trans/api/v1/order    ${resp}
	should be true     ${result[0]}     ${result}

post/trans/api/v1/order/pay
	[Documentation]    立即支付（公众号）
	[Tags]    Run    MANGO
	${params}    getParam_doc   post    /trans/api/v1/order/pay
	set to dictionary    ${params}     orderCode=${orderCode}     type=MANGO_ACCOUNTING
	remove from dictionary      ${params}      orderId
	${resp}    getApiResp    post    /trans/api/v1/order/pay    params=${params}    &{headers_m}
	${result}    docmentAssert    post    /trans/api/v1/order/pay    ${resp}
	should be true     ${result[0]}     ${result}

get/trans/api/v1/commodity/already_recommendInfos
	[Documentation]    已购列表（芒果会计小程序）
	[Tags]    Run    MANGO
	update already order To pay status    2
	${resp}    getApiResp    get    /trans/api/v1/commodity/already    &{headers_m}
	${result}    docmentAssert2    get    /trans/api/v1/commodity/already    ${resp}    alreadyInfos
	should be true     ${result[0]}     ${result}

get/trans/api/v1/commodity/already_alreadyInfos
	[Documentation]    已购列表（芒果会计小程序）
	[Tags]    Run    MANGO
	update already order To pay status    1
	${resp}    getApiResp    get    /trans/api/v1/commodity/already    &{headers_m}
	set suite variable      ${commodityId}     ${resp['alreadyInfos'][0]['commodityId']}
	${result}    docmentAssert2    get    /trans/api/v1/commodity/already    ${resp}    recommendInfos
	should be true     ${result[0]}     ${result}

get/trans/api/v1/commodity/already/details
	[Documentation]    已购详情（芒果会计小程序）
	[Tags]    Run    MANGO
	${params}    getParam_doc   get    /trans/api/v1/commodity/already/details
	set to dictionary    ${params}      commodityId=${commodityId}
	${resp}    getApiResp    get    /trans/api/v1/commodity/already/details    params=${params}    &{headers_m}
	${result}    docmentAssert    get    /trans/api/v1/commodity/already/details    ${resp}
	should be true     ${result[0]}     ${result}

get/trans/api/v1/commodity/recommend
	[Documentation]    商城推荐列表（芒果会计小程序）
	[Tags]    Run    MANGO
	${params}    getParam_doc   get    /trans/api/v1/commodity/recommend
	set to dictionary    ${params}    activityType=${EMPTY}
	${resp}    getApiResp    get    /trans/api/v1/commodity/recommend    params=${params}    &{headers_m}
	${result}    docmentAssert    get    /trans/api/v1/commodity/recommend    ${resp}
	should be true     ${result[0]}     ${result}

get/trans/api/v1/commodity/system
	[Documentation]    系统课列表（芒果会计小程序）
	[Tags]    Run    MANGO
	${resp}    getApiResp    get    /trans/api/v1/commodity/system    &{headers_m}
	set suite variable      ${commodityId}     ${resp[0]['commodityId']}
	${commodityIds}    create list     ${resp[0]['commodityId']}    ${resp[1]['commodityId']}    ${resp[2]['commodityId']}
	set suite variable      ${commodityIds}
	${result}    docmentAssert    get    /trans/api/v1/commodity/system    ${resp}
	should be true     ${result[0]}     ${result}

get/trans/api/v1/commodity/system/details
	[Documentation]    系统课详情（芒果会计小程序）
	[Tags]    Run    MANGO
	${params}    getParam_doc   get    /trans/api/v1/commodity/system/details
	set to dictionary    ${params}      commodityId=${commodityId}
	${resp}    getApiResp    get    /trans/api/v1/commodity/system/details    params=${params}    &{headers_m}
	${result}    docmentAssert    get    /trans/api/v1/commodity/system/details    ${resp}
	should be true     ${result[0]}     ${result}

get/trans/api/v1/commodity/system/status
	[Documentation]    系统课状态（芒果会计小程序）
	[Tags]    Run    MANGO
	${params}    getParam_doc   get    /trans/api/v1/commodity/system/status
    set to dictionary      ${params}    commodityIds=${commodityIds}
	${resp}    getApiResp    get    /trans/api/v1/commodity/system/status    params=${params}    &{headers_m}
	${result}    docmentAssert    get    /trans/api/v1/commodity/system/status    ${resp}
	should be true     ${result[0]}     ${result}

get/trans/api/v1/users/token
	[Documentation]    微信公众号获取授权（公众号）
	[Tags]    NotRun    MANGO
	${params}    getParam_doc   get    /trans/api/v1/users/token
	${resp}    getApiResp    get    /trans/api/v1/users/token    params=${params}    &{headers_m}
	${result}    docmentAssert    get    /trans/api/v1/users/token    ${resp}
	should be true     ${result[0]}     ${result}

get/trans/api/v1/commodity/user/hasAlreadyPay
	[Documentation]    当前用户是否购买过指定商品
	[Tags]    Run    MANGO
	${params}    getParam_doc    get    /trans/api/v1/commodity/user/hasAlreadyPay
	set to dictionary      ${params}    commodityId=${commodityId}
	${resp}    getApiResp    get    /trans/api/v1/commodity/user/hasAlreadyPay    params=${params}    &{headers_m}
	${result}    docmentAssert    get    /trans/api/v1/commodity/user/hasAlreadyPay    ${resp}
	should be true     ${result[0]}     ${result}

put/trans/api/v1/commodity/buyType
	[Documentation]    修改商品购买类型
	[Tags]    Run    MANGO
	${params}    getParam_doc    put    /trans/api/v1/commodity/buyType
	set to dictionary      ${params}    commodityId=${commodityId}      oldCommodityBuyType=BUY_CUT    newCommodityBuyType=BUY_CUT
	${resp}    getApiResp    put    /trans/api/v1/commodity/buyType    params=${params}    &{headers_m}
	${result}    docmentAssert    put    /trans/api/v1/commodity/buyType    ${resp}
	should be true     ${result[0]}     ${result}

get/trans/api/v1/commodity/user/alreadyPay/videos
	[Documentation]    当前用户已购买指定商品对应的视频信息
	[Tags]    Run    MANGO
	${params}    getParam_doc    get    /trans/api/v1/commodity/user/alreadyPay/videos
	set to dictionary     ${params}    commodityId=${commodityId}
	${resp}    getApiResp    get    /trans/api/v1/commodity/user/alreadyPay/videos    params=${params}    &{headers_m}
	${result}    docmentAssert    get    /trans/api/v1/commodity/user/alreadyPay/videos    ${resp}
	should be true     ${result[0]}     ${result}

