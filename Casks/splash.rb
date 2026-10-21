cask "splash" do
  version "0.1.0-alpha"
  sha256 "a01fd2f48650dfaee7288aac3533cd7c072a8caccc202bf7b887d1e033ca10c6"

  url "https://github.com/Peppe37/Splash/releases/download/v#{version}/Splash-#{version}.dmg"
  name "Splash"
  desc "Animated wallpapers with presets and optional AI"
  homepage "https://peppe37.github.io/Splash/"

  # Every release is a pre-release for now, so GitHub's "latest" is not enough: look at all of them
  livecheck do
    url :url
    regex(/^v?(\d+(?:\.\d+)+-alpha)$/i)
    strategy :github_releases do |json, regex|
      json.filter_map do |release|
        next if release["draft"]

        release["tag_name"]&.[](regex, 1)
      end
    end
  end

  depends_on macos: :sonoma

  app "Splash.app"
  # The command line tool lives inside the app; this makes `splash` available in the Terminal.
  binary "#{appdir}/Splash.app/Contents/MacOS/splash-cli", target: "splash"

  # The app is not notarized yet, so macOS would block its first launch. This tap removes the
  # quarantine flag that Homebrew puts on the download.
  postflight_steps do
    run "/usr/bin/xattr",
        args:         ["-dr", "com.apple.quarantine", "{{appdir}}/Splash.app"],
        must_succeed: false
  end

  # The wallpaper runs in its own process, which has to stop before the app can be removed.
  uninstall quit: "com.giuseppe.splash.runner"

  zap trash: [
    "~/Library/Application Support/Splash",
    "~/Library/Caches/com.giuseppe.splash.editor",
    "~/Library/Preferences/com.giuseppe.splash.editor.plist",
    "~/Library/Preferences/com.giuseppe.splash.plist",
  ]

  caveats <<~EOS
    Splash is an alpha and is not notarized by Apple yet: this cask clears the
    quarantine flag so it opens normally. The wallpaper keeps running in the menu bar after you close the window.
    To put your previous wallpaper back, use "Put back my previous wallpaper" in Splash.
  EOS
end
