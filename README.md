# OpenHere

Do you use Spaces/Mission Control on your Mac?

Do you get frustrated when you open a web link, and you get switched to a
different Space or the link silently opens in a new browser tab in a different
Space?

Me too.

`OpenHere` ensures that web links are opened in the current Space.

## How It Works

`OpenHere` is set to the deafult web browser, so it will receive any links that
are opened. When links are opened, `OpenHere` uses the Accessibility APIs to see
if there is a browser window in the current Space. If there isn't, it will open
a new browser window. The link is then opened in a new tab in your chosen
browser. Browser interaction uses the AppleScript scripting bridge.

## Installation

* Download the DMG for the latest
  [release](https://github.com/marcisme/OpenHere/releases)
* Open the disk image
* Drag `OpenHere` into your `Applications` folder
* Launch `OpenHere`
* Click on the `Open System Preferences` button
* Click the lock icon
* Click `Accessibility` in the left pane
* Check `OpenHere.app` in the list on the right
* Launch `OpenHere` again
* Select the browser you want links opened with
* Click the `Set OpenHere as Default Browser` button
* Click `Use OpenHere`
* Open a link to verify it opens in your desired browser

You can check for updates via the `OpenHere` > `Check for Updates...` menu item.

## Features

* Open links in the current Space
* Prevent window activation when opening several links in a row

## Usage

You should now be able to open links as you do normally, and they should always
open in the current Space.

If you want to change which browser `OpenHere` forwards links to or check for
updates, launch `OpenHere` directly.

![Select Browser](/images/select-browser.png)

If you decide `OpenHere` isn't for you, you can restore your preferred default
browser by selecting it in `System Preferences` > `General` > `Default web
browser`.

## Supported Browsers

Currents versions of the following should work.

* Safari
* Safari Technology Preview
* Chrome

## Privacy

`OpenHere` does not and will never log anything about the URLs that it opens.

You can walk through the entire execution path from where the [link open event
is handled](/OpenHere/AppDelegate.swift#L80-L86), to the [general
browser handling](/OpenHere/BrowserManager.swift#L80-L95), to the
browser-specific handling for [Chrome](/OpenHere/Browsers/Chrome.m),
[Safari](/OpenHere/Browsers/Safari.m) and [Safari Technology
Preview](/OpenHere/Browsers/SafariTechnologyPreview.m).

The only third party framework in use is [Sparkle](https://sparkle-project.org),
which provides the auto update functionality.

## Contributions

Please [open an issue](https://github.com/marcisme/OpenHere/issues/new) to discuss any potential changes.

## License

`OpenHere` is released under the [GPL](/LICENSE) license.

## Attribution

AppleScript, Mission Control, and Spaces are trademarks of Apple Inc.,
registered in the U.S. and other countries.

