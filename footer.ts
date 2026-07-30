// Format the current date as "DD Mon YYYY"
function formatDeploymentDate(): string {
  const now = new Date();
  const day = String(now.getDate()).padStart(2, '0');
  const month = now.toLocaleString('en-US', { month: 'short' });
  const year = now.getFullYear();
  return `${day} ${month} ${year}`;
}

// Initialize footer with dynamic deployment date
function initializeFooter(): void {
  const deployDateElement = document.getElementById('deploy-date');
  if (deployDateElement) {
    deployDateElement.textContent = formatDeploymentDate();
  }
}

// Run when DOM is ready
document.addEventListener('DOMContentLoaded', initializeFooter);
