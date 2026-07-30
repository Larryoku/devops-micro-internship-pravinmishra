const { chromium } = require("playwright");

(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage();
  await page.goto("http://localhost:8080/index.html");
  
  // Wait for the footer to be populated with the date
  await page.waitForFunction(() => {
    const dateElement = document.getElementById("deploy-date");
    return dateElement && dateElement.textContent !== "loading...";
  }, { timeout: 5000 });
  
  // Take screenshot
  await page.screenshot({ path: "footer-screenshot.png", fullPage: true });
  
  // Log the footer content
  const footerText = await page.textContent("footer");
  console.log("Footer content:", footerText);
  
  await browser.close();
})();
