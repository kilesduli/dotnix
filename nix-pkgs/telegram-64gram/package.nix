{ lib
, stdenv
, telegram-desktop
, withWebkit ? true
, source-64gram
, patches-telegram
,
}:
telegram-desktop.override {
  pname = "telegram-64gram";
  inherit withWebkit;
  unwrapped = telegram-desktop.unwrapped.overrideAttrs (old: rec {
    pname = "telegram-64gram-unwrapped";
    version = "1.1.58-unstable";

    inherit (source-64gram) src;

    patches =
      let
        extra-patches = patches-telegram.src;
      in
      (old.patches or [ ]) ++
      [
        "${extra-patches}/0001-Disable-sponsored-messages.patch"
        "${extra-patches}/0002-Disable-saving-restrictions.patch"
        "${extra-patches}/0003-Disable-invite-peeking-restrictions.patch"
        "${extra-patches}/0005-Option-to-disable-stories.patch"
      ]
    ;

    cmakeFlags = (old.cmakeFlags or [ ]) ++ [
      (lib.cmakeBool "DESKTOP_APP_DISABLE_AUTOUPDATE" true)
    ];

    meta = {
      description = "Unofficial Telegram Desktop providing Windows 64bit build and extra features";
      license = lib.licenses.gpl3Only;
      platforms = lib.platforms.all;
      homepage = "https://github.com/TDesktop-x64/tdesktop";
      maintainers = [ ];
      mainProgram = if stdenv.hostPlatform.isLinux then "telegram-desktop" else "Telegram";
    };
  });
}
