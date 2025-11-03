{...}: {
  xdg.desktopEntries = {
    "chrome-youtube" = {
      name = "YouTube (Chrome)";
      exec = "google-chrome --app=https://www.youtube.com";
      categories = ["Network" "WebBrowser"];
      mimeType = ["application/x-extension-youtube" "text/html" "text/xml"];
      icon = ./icons/youtube.svg;
    };
  };
}
