# AnimeUnlock — an SDDM theme

A frosted-glass SDDM greeter that matches the reference design, with two
extras you asked for: a **profile (account) selector on the left** of the
unlock pill and a **desktop-session selector on the right**.

```
                19:50
                Thursday, 22 October                            29° Clear sky

                          .-------------------------------------------.
   ( Profile )   (  Type your password to unlock  )   ( Session )        ( ) ( ) ( )
```

Layout previews live in `Previews/` (`idle.jpg`, `entry.jpg`). They are
reconstructions of the layout rather than real screenshots, so run the
greeter in test mode if you want the exact thing.

## The login flow

1. **Idle screen** — after boot SDDM shows the wallpaper with the clock, the
   weather pill, the profile selector, the *“Type your password to unlock”*
   pill and the session selector along the bottom, and the circled power
   buttons in the bottom-right corner.

2. **Entry screen** — the moment anyone starts typing (or clicks the unlock
   pill) the wallpaper cross-fades to its **blurred** variant and a password
   bar slides in, flanked by the same profile and session selectors. The
   power buttons move into the bar, exactly like the second reference image.
   Press **Esc** on an empty field to go back to the idle screen.

3. Type the password and press **Enter** (or the round arrow) to log in. A
   wrong password shakes the bar and shows a short message.

## Install

```bash
bash install.sh
```

That copies the theme to `/usr/share/sddm/themes/AnimeUnlock` and drops
`/etc/sddm.conf.d/zz-animeunlock.conf` pointing SDDM at it. Then log out, or:

```bash
sudo systemctl restart sddm
```

Manual install (any distro):

```bash
sudo cp -r AnimeUnlock /usr/share/sddm/themes/
# then in /etc/sddm.conf (or a file under /etc/sddm.conf.d/):
#   [Theme]
#   Current=AnimeUnlock
```

Preview it live without logging out:

```bash
sddm-greeter --test-mode --theme /usr/share/sddm/themes/AnimeUnlock
```

## Customising

Everything lives in `theme.conf` next to `Main.qml`:

| Key | What it does |
| --- | --- |
| `background` | Wallpaper on the idle screen |
| `backgroundBlur` | Wallpaper the screen cross-fades to once you type |
| `AvatarImage` | Round avatar in the password bar. Empty by default, which shows the account's initial; point it at an image to use one |
| `FontFamily` / `MonoFontFamily` | UI font and the monospace prompt/date font |
| `PromptText` | The idle pill text |
| `WeatherText` / `ShowWeather` | The top-right pill (SDDM has no network, so it is a static label) |
| `AlwaysShowPowerButtons` | `true` (default) always shows the suspend / restart / power buttons; `false` hides whichever ones SDDM reports it cannot do |
| `PillFrost` / `PillBlurRadius` | Frosted-glass pills: `true` (default) blurs the wallpaper behind each pill, radius 40px |
| `DimBackground` | 0–1 darkening of the idle screen |
| `BlurDuration` | Cross-fade time in ms |
| `ScreenWidth` / `ScreenHeight` | Leave 0 to auto-detect |

### Using your own wallpaper

1. Drop your image in as `assets/background.jpg`.
2. Regenerate the blurred copy so the transition still matches:

   ```bash
   python3 make_blur.py            # or: python3 make_blur.py my-wall.jpg
   ```

`make_blur.py` just needs Pillow.

## Frosted glass

The pills blur whatever wallpaper sits behind them. That needs a blur effect,
and its module name changed between Qt versions — `QtGraphicalEffects` on
Qt 5, `Qt5Compat.GraphicalEffects` on Qt 6 — so the theme ships both and uses
whichever the greeter can load (you will see a one-line "module not installed"
note for the one that fails, which is harmless). If neither is available the
pills fall back to their plain translucent fill; set `PillFrost="false"` if
you would rather skip it.

## Notes

* The theme reads the accounts from SDDM’s own user list, so the profile
  selector shows whatever accounts exist on the machine (only the display
  name is shown, as requested). The session selector lists the installed
  desktop sessions — Hyprland, i3, Plasma, GNOME, … — automatically.
* No icon fonts or extra Qt modules are needed. Icons are drawn on a Canvas,
  and the “blur” is a pre-rendered image cross-fade, which is fast and works
  on both Qt 5 and Qt 6 greeters. The only optional module is
  `QtGraphicalEffects`, used solely to crop a user’s `~/.face` picture into a
  circle; if it is missing the bundled round avatar is used instead and
  everything else keeps working.

## Files

```
AnimeUnlock/
├── Main.qml                 greeter entry point, background + flow logic
├── metadata.desktop         theme metadata
├── theme.conf               all the knobs
├── make_blur.py             regenerates the blurred wallpaper
├── install.sh
├── Previews/
│   ├── idle.jpg
│   └── entry.jpg
├── assets/
│   ├── background.jpg
│   ├── background_blur.jpg
│   └── avatar.png
└── components/
    ├── Clock.qml
    ├── WeatherPill.qml
    ├── ProfileSelector.qml
    ├── SessionSelector.qml
    ├── UnlockPill.qml
    ├── PasswordBar.qml
    ├── PowerButtons.qml
    ├── IconButton.qml
    ├── Icon.qml             canvas-drawn icons
    └── RoundImage.qml       optional circular crop
```

Licensed GPL-3.0-or-later.
