cask "notcholino" do
  version "0.28.1-alpha"
  sha256 "eb04cfbe62d32597dae56d37d8aa871e11bbdbe10f0dfc1f2211c25666335f63"

  url "https://github.com/Peppe37/Notcholino/releases/download/v#{version}/Notcholino-#{version}.dmg"
  name "Notcholino"
  desc "Notch app: now playing, calendar, file shelf, device popups and plugins"
  homepage "https://peppe37.github.io/Notcholino/"

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
    Notcholino is an alpha and is not notarized by Apple yet: this cask clears the
    quarantine flag so it opens normally. Permissions (Calendar, Accessibility...) are asked from the app.
  EOS
end
