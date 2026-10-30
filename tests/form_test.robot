*** Settings ***
Library          Remote    http://127.0.0.1:8270/browser

Test Teardown    closeBrowser


*** Variables ***
${URL}           https://www.selenium.dev/selenium/web/web-form.html
${INPUT_TEXT}    Hello from Robot Framework and Java!


*** Test Cases ***
Submit Form Successfully
    Given the web form is open
    When I enter text into the form    ${INPUT_TEXT}
    And I submit the form
    Then the confirmation message should be    Received!

Select dropdown option successfully
    Given the web form is open
    When I select the dropdown option    Two
    Then the selected dropdown option should be    Two


*** Keywords ***
the web form is open
    openBrowser    ${URL}

I select the dropdown option
    [Arguments]    ${option}
    selectDropdownOption    ${option}

the selected dropdown option should be
    [Arguments]    ${expected_option}
    ${actual_option}=    getSelectedDropdownOption
    Should Be Equal    ${actual_option}    ${expected_option}

I enter text into the form
    [Arguments]    ${text}
    enterText    ${text}

I submit the form
    submitForm

the confirmation message should be
    [Arguments]    ${expected_message}
    ${actual_message}=    getConfirmationMessage
    Should Be Equal    ${actual_message}    ${expected_message}
