package com.example.automation;

import java.time.Duration;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.openqa.selenium.support.ui.Select;

public class BrowserKeywords {

    private WebDriver driver;
    private WebDriverWait wait;

    public void openBrowser(String url) {
        driver = new ChromeDriver();
        wait = new WebDriverWait(driver, Duration.ofSeconds(10));

        driver.get(url);
    }

    public void enterText(String text) {
        wait.until(
            ExpectedConditions.visibilityOfElementLocated(
                By.name("my-text")
            )
        ).sendKeys(text);
    }

    public void submitForm() {
        wait.until(
            ExpectedConditions.elementToBeClickable(
                By.cssSelector("button[type='submit']")
            )
        ).click();
    }

    public String getConfirmationMessage() {
        return wait.until(
            ExpectedConditions.visibilityOfElementLocated(
                By.id("message")
            )
        ).getText();
    }

    public void closeBrowser() {
        if (driver != null) {
            try {
                driver.quit();
            } finally {
                driver = null;
                wait = null;
            }
        }
    }
        public void selectDropdownOption(String optionText) {
        Select dropdown = new Select(
            driver.findElement(By.name("my-select"))
        );

        dropdown.selectByVisibleText(optionText);
    }
        public String getSelectedDropdownOption() {
        Select dropdown = new Select(
            driver.findElement(By.name("my-select"))
        );

        return dropdown.getFirstSelectedOption().getText();
    }
}