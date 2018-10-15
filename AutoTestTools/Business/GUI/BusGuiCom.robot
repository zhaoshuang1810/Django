*** Settings ***
Library           AppiumLibrary
Library           Collections
Library           ../../Lib/Function.py
Library           ../../Lib/PrivateMethod.py
Library           ../../Lib/Android.py
Variables         ../../Conf/Properties.py


*** Keywords ***
element_screenshot
    [Arguments]      ${imageName}       @{locator}
    [Documentation]   元素截图
    ${image}    evaluate      os.path.join("${screenshot_dir}","temp_screen.png")     os
    capture page screenshot    ${image}
    ${locator}      get location    @{locator}
    ${location}    get element location      ${locator}
    ${size}    get element size      ${locator}
    ${end_x}    evaluate    ${location["x"]}+${size["width"]}
    ${end_y}    evaluate    ${location["y"]}+${size["height"]}
    screenShot    ${image}     ${location["x"]}    ${location["y"]}     ${end_x}    ${end_y}
    copyImage    ${image}     ${screenshot_dir}    ${imageName}
    sleep    0.5

get_picture_similarity
    [Arguments]     ${imageName}
    [Documentation]    获取两张图片的相似度，相同的文件名，不同的路径
    ${image1}    evaluate      os.path.join("${screenshot_dir}","${imageName}"+".png")     os
    ${image2}    evaluate      os.path.join("${compareImage_dir}","${imageName}"+".png")     os
    ${resp}    compareImages     ${image1}    ${image2}    ${resultImage_dir}     ${imageName}
    [Return]   ${resp}

click_exsit_location
    [Arguments]     @{location}
    [Documentation]  判断元素是否存在，如果存在，则点击
     ${location}    get location    @{location}
     ${exist}     is_element_exist    ${location}
     run keyword if     ${exist}     run keywords    click element    ${location}    AND     sleep   3
     ...    ELSE    log     ${location}该元素不存在

click_location
    [Arguments]     @{location}
    [Documentation]  点击元素，不需要判断是否存在
     ${location}    get location    @{location}
     click element     ${location}
     sleep     3

swipe_up_until_loction_exist
    [Arguments]     @{location}
    [Documentation]   向上滑动屏幕，直到元素出现
     ${location}    get location    @{location}
     :for    ${x}    in range    5
     \      ${exist}     is_element_exist    ${location}
     \       run keyword if      not ${exist}     swipe by percent     50    65    50   35
     \       sleep     3
     \       exit for loop if      ${exist}

back_until_loction_exist
    [Arguments]     @{location}
    [Documentation]   点击物理返回键，直到元素出现
     ${location}    get location    @{location}
     :for    ${x}    in range    5
     \      ${exist}     is_element_exist    ${location}
     \       run keyword if      not ${exist}     press keycode     4
     \       sleep     3
     \       exit for loop if      ${exist}