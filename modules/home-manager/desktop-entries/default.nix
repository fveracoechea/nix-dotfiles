{...}: {
  xdg.desktopEntries = {
    "chrome-youtube" = {
      name = "YouTube (Chrome)";
      exec = "google-chrome --app=https://www.youtube.com";
      categories = ["Network" "WebBrowser"];
      mimeTypes = ["x-scheme-handler/youtube"];
      icon = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/youtube.svg";
    };
  };
}
