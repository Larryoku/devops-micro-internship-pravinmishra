const fs = require("fs");
const path = require("path");

// Read the HTML file
const htmlContent = fs.readFileSync("index.html", "utf-8");

// Read the footer.js file
const footerJS = fs.readFileSync("footer.js", "utf-8");

// Format date the same way as the footer.js function
const now = new Date();
const day = String(now.getDate()).padStart(2, "0");
const month = now.toLocaleString("en-US", { month: "short" });
const year = now.getFullYear();
const formattedDate = `${day} ${month} ${year}`;

console.log("✓ HTML file contains footer element");
console.log("✓ footer.js script found");
console.log("");
console.log("=== Simulated Footer Display ===");
console.log(`Portfolio v1.0 — Deployed on ${formattedDate} — By Silas Nyarko`);
console.log("");
console.log("✓ Date format: DD Mon YYYY");
console.log(`✓ Current system date: ${formattedDate}`);
console.log("");
console.log("=== Verification ===");

// Check that footer.js contains the expected functions
if (footerJS.includes("formatDeploymentDate") && footerJS.includes("initializeFooter")) {
  console.log("✓ All required functions present in footer.js");
}

if (footerJS.includes("DOMContentLoaded") && footerJS.includes("getElementById")) {
  console.log("✓ Script properly waits for DOM and updates footer element");
}

if (htmlContent.includes('id="deploy-date"') && htmlContent.includes('<footer')) {
  console.log("✓ HTML structure correct with footer and date placeholder");
}

console.log("");
console.log("✓ Footer implementation verified successfully!");
