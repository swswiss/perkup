import "@hotwired/turbo-rails"
import "controllers"

let deferredPrompt;

document.addEventListener("DOMContentLoaded", () => {
  const banner = document.getElementById("pwa-install-banner");
  const installBtn = document.getElementById("install-btn");
  const closeBtn = document.getElementById("close-install");

  if (!banner) return; // safety check

  // iOS detection
  const isIos = /iphone|ipad|ipod/i.test(navigator.userAgent);

  function isInStandaloneMode() {
    return ('standalone' in window.navigator) && window.navigator.standalone;
  }

  // Show banner for iOS Safari users
  if (isIos && !isInStandaloneMode() && !localStorage.getItem("pwaPromptDismissed")) {
    banner.classList.add("ios");
    banner.style.display = "block";          // show banner
    document.querySelector(".safari-hint")?.classList.add("show"); // show iOS instructions
  }

  // Android: beforeinstallprompt
  window.addEventListener("beforeinstallprompt", (e) => {
    e.preventDefault();
    deferredPrompt = e;

    // Show banner for Android (not iOS)
    if (!isIos && !localStorage.getItem("pwaPromptDismissed")) {
      setTimeout(() => {
        banner.style.display = "block";
      }, 1000);
    }
  });

  // Install button click
  installBtn?.addEventListener("click", async () => {
    if (deferredPrompt) {
      deferredPrompt.prompt();
      const { outcome } = await deferredPrompt.userChoice;
      console.log("Install outcome:", outcome);
      deferredPrompt = null;
    }
    banner.style.display = "none";
  });

  // Close button click
  closeBtn?.addEventListener("click", () => {
    localStorage.setItem("pwaPromptDismissed", "true");
    banner.style.display = "none";
  });
});
