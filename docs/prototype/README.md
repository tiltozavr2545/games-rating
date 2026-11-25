# Review flow prototype

[Phone at 89 minutes](previews/phone-draft.png) · [Web editor at 90 minutes](previews/web-editor.png) · [Published guest view](previews/guest-review.png)

Interactive Flutter wireframes with a fictional game and player. Start in a narrow phone layout, write a note at 89 minutes, then press “Сохранить черновик”. “Вид гостя” shows the public view. Return with the browser Back button. Press “Обновить часы” to simulate the 90th minute and switch to the desktop layout. Scroll the score strip to 7.5, optionally pick a play status or mark a spoiler, and press “Опубликовать”.

Publication opens the guest view at `/#/reviews/lighthouse`. Paste the address into another tab of the same browser profile to inspect the public snapshot. Drafts and publications use this browser's local storage. Separate browser profiles and physical devices have separate sample data. To repeat from 89 minutes, use a fresh private window or clear this origin's site data. Both layouts are available through the preview switch.

## Run locally

From this directory with Flutter installed:

```sh
flutter pub get
flutter run -d chrome
```

For an already built preview, serve the web output with `python3 -m http.server 8765 --bind 127.0.0.1 --directory build/web` and open `http://127.0.0.1:8765`. Build with `flutter build web --no-web-resources-cdn` to include the renderer locally.

## Verify the flow

Run `flutter test` in this directory. The test exercises the draft boundary, reopens the editor, selects 7.5 on the wider layout and reveals a spoiler in the guest view. Production acceptance cases, including authorization and real cross-device sync, are in the [publication rules](../publication-rules.md).
