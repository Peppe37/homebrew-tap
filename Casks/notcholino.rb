cask "notcholino" do
  version "1.0.0"
  sha256 "7e1e968f764afef660c67e4b857862150fdc90bdd01183587653776fe7c9dc1d"

  url "https://github.com/Peppe37/Notcholino/releases/download/v#{version}/Notcholino-#{version}.dmg"
  name "Notcholino"
  desc "Notch app: now playing, calendar, file shelf, device popups and plugins"
  homepage "https://peppe37.github.io/Notcholino/"

  # Every release is a pre-release for now, so GitHub's "latest" is not enough: look at all of them
  livecheck do
    url :url
    regex(/^v?(\d+(?:\.\d+)+(?:-beta)?)$/i)
    strategy :github_releases do |json, regex|
      json.filter_map do |release|
        next if release["draft"]

        release["tag_name"]&.[](regex, 1)
      end
    end
  end

  depends_on macos: :sonoma

  app "Notcholino.app"

  # The app is not notarized yet, so macOS would block its first launch. This tap removes the
  # quarantine flag that Homebrew puts on the download.
  postflight_steps do
    run "/usr/bin/xattr",
        args:         ["-dr", "com.apple.quarantine", "{{appdir}}/Notcholino.app"],
        must_succeed: false
  end

  zap trash: [
    "~/Library/Application Support/Notcholino",
    "~/Library/Caches/com.giuseppe.Notcholino",
    "~/Library/Preferences/com.giuseppe.Notcholino.plist",
  ]

  caveats <<~EOS
    Notcholino is not notarized by Apple yet: this cask clears the
    quarantine flag so it opens normally. Permissions (Calendar, Accessibility...) are asked from the app.
  EOS
end
