*** Settings ***
Documentation    Tests the Selenium practice form using Java remote keywords.

Library          Remote    http://127.0.0.1:8270/browser
Library          Collections
Library          OperatingSystem

Test Teardown    Close Browser


*** Variables ***
${URL}            https://www.selenium.dev/selenium/web/web-form.html
${INPUT_TEXT}     Hello from Robot Framework and Java!
${UPLOAD_FILE}    ${OUTPUT DIR}${/}upload.txt


*** Test Cases ***
Submit Form Successfully
    [Documentation]    Submit text and verify the confirmation message.
    [Tags]    smoke    submission
    Given The Web Form Is Open
    When I Enter Text Into The Form    ${INPUT_TEXT}
    And I Submit The Form
    Then The Confirmation Message Should Be    Received!

Replace Existing Text
    [Documentation]    Replacing a field value should remove its previous text.
    [Tags]    text
    Given The Web Form Is Open
    When I Fill The Field    my-text    Original text
    And I Fill The Field    my-text    Replacement text
    Then The Field Value Should Be    my-text    Replacement text

Enter Unicode Text
    [Documentation]    Preserve accented characters and special symbols.
    [Tags]    text
    Given The Web Form Is Open
    When I Fill The Field    my-text    Olá, João! Ação & qualidade.
    Then The Field Value Should Be    my-text    Olá, João! Ação & qualidade.

Enter Password
    [Documentation]    Accept a password value and retain the password input type.
    [Tags]    password
    Given The Web Form Is Open
    When I Fill The Field    my-password    ExamplePassword123!
    Then The Field Value Should Be    my-password    ExamplePassword123!
    And The Field Attribute Should Be    my-password    type    password

Enter Multiline Text
    [Documentation]    Preserve line breaks in the textarea.
    [Tags]    textarea
    Given The Web Form Is Open
    When I Fill The Field    my-textarea    First line\nSecond line
    Then The Field Value Should Be    my-textarea    First line\nSecond line

Disabled Field Is Not Enabled
    [Documentation]    The disabled input should remain unavailable for editing.
    [Tags]    disabled
    Given The Web Form Is Open
    Then The Field Enabled State Should Be    my-disabled    ${False}
    And The Field Value Should Be    my-disabled    ${EMPTY}

Readonly Field Cannot Be Changed
    [Documentation]    Typing should not modify the readonly input.
    [Tags]    readonly
    Given The Web Form Is Open
    Then The Field Attribute Should Be    my-readonly    readonly    true
    When I Attempt To Type Into The Field    my-readonly    Changed
    Then The Field Value Should Be    my-readonly    Readonly input

Dropdown Has Expected Default And Options
    [Documentation]    Verify the initial selection and all displayed options.
    [Tags]    dropdown
    Given The Web Form Is Open
    Then The Selected Dropdown Option Should Be    Open this select menu
    And The Dropdown Options Should Be
    ...    Open this select menu
    ...    One
    ...    Two
    ...    Three

Select Dropdown Option One
    [Documentation]    Select the first numbered option by visible text.
    [Tags]    dropdown
    Given The Web Form Is Open
    When I Select The Dropdown Option    One
    Then The Selected Dropdown Option Should Be    One

Select Dropdown Option Two
    [Documentation]    Select the second numbered option by visible text.
    [Tags]    smoke    dropdown
    Given The Web Form Is Open
    When I Select The Dropdown Option    Two
    Then The Selected Dropdown Option Should Be    Two

Select Dropdown Option Three
    [Documentation]    Select the third numbered option by visible text.
    [Tags]    dropdown
    Given The Web Form Is Open
    When I Select The Dropdown Option    Three
    Then The Selected Dropdown Option Should Be    Three

Select Dropdown By Value
    [Documentation]    The HTML value 2 should select the label Two.
    [Tags]    dropdown
    Given The Web Form Is Open
    When I Select The Dropdown Value    2
    Then The Selected Dropdown Option Should Be    Two

Enter Suggested Datalist Value
    [Documentation]    Verify available suggestions and enter one of them.
    [Tags]    datalist
    Given The Web Form Is Open
    Then The Datalist Suggestions Should Be
    ...    San Francisco
    ...    New York
    ...    Seattle
    ...    Los Angeles
    ...    Chicago
    When I Fill The Field    my-datalist    Seattle
    Then The Field Value Should Be    my-datalist    Seattle

Enter Custom Datalist Value
    [Documentation]    A datalist allows text outside its suggested values.
    [Tags]    datalist
    Given The Web Form Is Open
    When I Fill The Field    my-datalist    Torrinha
    Then The Field Value Should Be    my-datalist    Torrinha

Attach A File
    [Documentation]    Attach a generated local text file to the file input.
    [Tags]    upload
    Given The Web Form Is Open
    And An Upload File Exists
    When I Attach The Upload File
    Then The Attached Filename Should Be    upload.txt

Checkboxes Have Expected Initial States
    [Documentation]    Verify checked and unchecked defaults.
    [Tags]    checkbox
    Given The Web Form Is Open
    Then The Control Selected State Should Be    my-check-1    ${True}
    And The Control Selected State Should Be    my-check-2    ${False}

Select Default Checkbox
    [Documentation]    Select the initially unchecked checkbox.
    [Tags]    smoke    checkbox
    Given The Web Form Is Open
    When I Set The Checkbox State    my-check-2    ${True}
    Then The Control Selected State Should Be    my-check-2    ${True}
    And The Control Selected State Should Be    my-check-1    ${True}

Deselect Checked Checkbox
    [Documentation]    Deselect the initially checked checkbox.
    [Tags]    checkbox
    Given The Web Form Is Open
    When I Set The Checkbox State    my-check-1    ${False}
    Then The Control Selected State Should Be    my-check-1    ${False}
    And The Control Selected State Should Be    my-check-2    ${False}

Selecting Checkbox Twice Keeps It Selected
    [Documentation]    Setting the same state twice should not toggle the checkbox.
    [Tags]    checkbox
    Given The Web Form Is Open
    When I Set The Checkbox State    my-check-2    ${True}
    And I Set The Checkbox State    my-check-2    ${True}
    Then The Control Selected State Should Be    my-check-2    ${True}

Radio Buttons Have Expected Initial States
    [Documentation]    Verify which radio button is initially selected.
    [Tags]    radio
    Given The Web Form Is Open
    Then The Control Selected State Should Be    my-radio-1    ${True}
    And The Control Selected State Should Be    my-radio-2    ${False}

Switch Radio Selection
    [Documentation]    Selecting one radio should deselect the other.
    [Tags]    radio
    Given The Web Form Is Open
    When I Select The Radio Button    my-radio-2
    Then The Control Selected State Should Be    my-radio-2    ${True}
    And The Control Selected State Should Be    my-radio-1    ${False}
    When I Select The Radio Button    my-radio-1
    Then The Control Selected State Should Be    my-radio-1    ${True}
    And The Control Selected State Should Be    my-radio-2    ${False}

Color Has Expected Default
    [Documentation]    Verify the color control's initial value.
    [Tags]    color
    Given The Web Form Is Open
    Then The Field Value Should Be    my-colors    \#563d7c

Change Color Value
    [Documentation]    Update the HTML color value without opening the OS dialog.
    [Tags]    color
    Given The Web Form Is Open
    When I Set The Color    \#00ff00
    Then The Field Value Should Be    my-colors    \#00ff00

Open Date Picker
    [Documentation]    Clicking the date input should display its calendar.
    [Tags]    date
    Given The Web Form Is Open
    When I Open The Date Picker
    Then The Date Picker Should Be Visible

Enter Date
    [Documentation]    Enter a date using the control's default month/day/year format.
    [Tags]    date
    Given The Web Form Is Open
    When I Enter The Date    06/15/2025
    Then The Field Value Should Be    my-date    06/15/2025

Range Has Expected Default And Bounds
    [Documentation]    Verify the initial value, limits, and increment.
    [Tags]    range
    Given The Web Form Is Open
    Then The Field Value Should Be    my-range    5
    And The Field Attribute Should Be    my-range    min    0
    And The Field Attribute Should Be    my-range    max    10
    And The Field Attribute Should Be    my-range    step    1

Move Range To Minimum
    [Documentation]    Use keyboard interaction to select the minimum value.
    [Tags]    range
    Given The Web Form Is Open
    When I Set The Range    0
    Then The Field Value Should Be    my-range    0

Move Range To Maximum
    [Documentation]    Use keyboard interaction to select the maximum value.
    [Tags]    range
    Given The Web Form Is Open
    When I Set The Range    10
    Then The Field Value Should Be    my-range    10

Move Range To Intermediate Value
    [Documentation]    Use keyboard interaction to select an intermediate value.
    [Tags]    range
    Given The Web Form Is Open
    When I Set The Range    7
    Then The Field Value Should Be    my-range    7

Hidden Input Is Not Displayed
    [Documentation]    The hidden input should exist without being visible.
    [Tags]    hidden
    Given The Web Form Is Open
    Then The Field Displayed State Should Be    my-hidden    ${False}
    And The Field Attribute Should Be    my-hidden    type    hidden

Return To Index
    [Documentation]    Follow the link back to the Selenium page index.
    [Tags]    navigation
    Given The Web Form Is Open
    When I Follow The Return To Index Link
    Then The Current URL Should End With    /index.html


*** Keywords ***
The Web Form Is Open
    [Documentation]    Open a new browser session on the practice form.
    Open Browser    ${URL}

I Enter Text Into The Form
    [Documentation]    Fill the main text input.
    [Arguments]    ${text}
    Enter Text    ${text}

I Fill The Field
    [Documentation]    Replace the value of an editable field identified by name.
    [Arguments]    ${name}    ${text}
    Fill Field    ${name}    ${text}

The Field Value Should Be
    [Documentation]    Compare an input's current value with the expected value.
    [Arguments]    ${name}    ${expected}
    ${actual}=    Get Field Value    ${name}
    Should Be Equal    ${actual}    ${expected}

The Field Attribute Should Be
    [Documentation]    Compare an HTML attribute with the expected value.
    [Arguments]    ${name}    ${attribute}    ${expected}
    ${actual}=    Get Field Attribute    ${name}    ${attribute}
    Should Be Equal    ${actual}    ${expected}

The Field Enabled State Should Be
    [Documentation]    Verify whether a field is enabled.
    [Arguments]    ${name}    ${expected}
    ${actual}=    Is Field Enabled    ${name}
    Should Be Equal    ${actual}    ${expected}

The Field Displayed State Should Be
    [Documentation]    Verify whether a field is displayed.
    [Arguments]    ${name}    ${expected}
    ${actual}=    Is Field Displayed    ${name}
    Should Be Equal    ${actual}    ${expected}

I Attempt To Type Into The Field
    [Documentation]    Send keys without clearing the field first.
    [Arguments]    ${name}    ${text}
    Attempt To Type Into Field    ${name}    ${text}

I Submit The Form
    [Documentation]    Click the form's submit button.
    Submit Form

The Confirmation Message Should Be
    [Documentation]    Compare the confirmation text with its expected value.
    [Arguments]    ${expected_message}
    ${actual_message}=    Get Confirmation Message
    Should Be Equal    ${actual_message}    ${expected_message}

I Select The Dropdown Option
    [Documentation]    Select a dropdown option by its visible text.
    [Arguments]    ${option}
    Select Dropdown Option    ${option}

I Select The Dropdown Value
    [Documentation]    Select a dropdown option by its HTML value.
    [Arguments]    ${value}
    Select Dropdown Value    ${value}

The Selected Dropdown Option Should Be
    [Documentation]    Verify the selected option's visible text.
    [Arguments]    ${expected_option}
    ${actual_option}=    Get Selected Dropdown Option
    Should Be Equal    ${actual_option}    ${expected_option}

The Dropdown Options Should Be
    [Documentation]    Compare all dropdown labels in their displayed order.
    [Arguments]    @{expected}
    ${actual}=    Get Dropdown Options
    Lists Should Be Equal    ${actual}    ${expected}

The Datalist Suggestions Should Be
    [Documentation]    Compare the values available in the datalist.
    [Arguments]    @{expected}
    ${actual}=    Get Datalist Options
    Lists Should Be Equal    ${actual}    ${expected}

An Upload File Exists
    [Documentation]    Create the upload fixture in the execution output folder.
    Create File    ${UPLOAD_FILE}    Robot Framework upload example.\n

I Attach The Upload File
    [Documentation]    Attach the fixture through the HTML file input.
    Upload File    ${UPLOAD_FILE}

The Attached Filename Should Be
    [Documentation]    Verify the filename selected by the file input.
    [Arguments]    ${expected}
    ${actual}=    Get Uploaded File Name
    Should Be Equal    ${actual}    ${expected}

I Set The Checkbox State
    [Documentation]    Set a checkbox to the requested boolean state.
    [Arguments]    ${id}    ${selected}
    Set Checkbox    ${id}    ${selected}

The Control Selected State Should Be
    [Documentation]    Verify a checkbox or radio button's selected state.
    [Arguments]    ${id}    ${expected}
    ${actual}=    Is Control Selected    ${id}
    Should Be Equal    ${actual}    ${expected}

I Select The Radio Button
    [Documentation]    Select a radio button identified by its ID.
    [Arguments]    ${id}
    Select Radio    ${id}

I Set The Color
    [Documentation]    Set the HTML color value and dispatch change events.
    [Arguments]    ${color}
    Set Color    ${color}

I Open The Date Picker
    [Documentation]    Click the date field to display its calendar.
    Open Date Picker

The Date Picker Should Be Visible
    [Documentation]    Verify that the calendar popup is displayed.
    ${visible}=    Is Date Picker Displayed
    Should Be Equal    ${visible}    ${True}

I Enter The Date
    [Documentation]    Enter a date and move focus out of the field.
    [Arguments]    ${date}
    Enter Date    ${date}

I Set The Range
    [Documentation]    Change the range using keyboard input.
    [Arguments]    ${value}
    Set Range    ${value}

I Follow The Return To Index Link
    [Documentation]    Navigate back to the page index.
    Return To Index

The Current URL Should End With
    [Documentation]    Verify the destination path after navigation.
    [Arguments]    ${suffix}
    ${actual}=    Get Current Url
    Should End With    ${actual}    ${suffix}
