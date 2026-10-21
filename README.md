# Homebrew tap of Peppe37

This tap holds the apps I make:

- [Notcholino](https://github.com/Peppe37/Notcholino), a free and open-source app that turns the notch of your MacBook into a place for what is playing, your calendar, files you are carrying around, device popups and plugins.
- [Splash](https://github.com/Peppe37/Splash), a free and open-source app that puts animated wallpapers on your Mac.

## Install

```sh
brew install --cask Peppe37/tap/notcholino
brew install --cask Peppe37/tap/splash
```

Use the full name once: it also tells Homebrew you trust this tap. After that, `brew upgrade --cask notcholino` (or `splash`) updates it.

To remove one: `brew uninstall --cask notcholino` (add `--zap` to delete its settings and the plugins you installed), or `brew uninstall --cask splash` (add `--zap` to delete its settings, scenes and recorded loops).

## About this tap

- Notcholino and Splash are alphas and are **not notarized by Apple** yet. Homebrew's official cask repository only takes notarized apps, so for now it lives here. The casks remove the quarantine flag that Homebrew puts on the download, so the apps open normally.
- Each cask follows the releases of its app on its own: a workflow checks for a new one every hour, updates the version and checksum, verifies them against the real DMG, and commits. See [`update.yml`](.github/workflows/update.yml) (Notcholino) and [`update-splash.yml`](.github/workflows/update-splash.yml).
- Every release of the apps is flagged as a pre-release for now, which is why Homebrew's own audit complains about it.

Report problems with an app in its repository ([Notcholino](https://github.com/Peppe37/Notcholino/issues), [Splash](https://github.com/Peppe37/Splash/issues)), and problems with installing it here.

## License

The files of this tap are MIT. Notcholino and Splash are GPL-3.0.
