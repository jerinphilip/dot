import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.NoBorders
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Actions.WorkspaceNames
import XMonad.Layout.Minimize
import qualified Graphics.X11.ExtraTypes.XF86 as ExtraKey
import System.IO

main = do
    let keys = [
            ((mod4Mask, xK_s), spawn "xscreensaver-command -lock"),
            ((mod4Mask, xK_Return), spawn "gnome-terminal"),
            ((mod4Mask, xK_b), spawn "firefox"),
            ((mod4Mask, xK_e), spawn "nautilus -w"),
            ((mod4Mask, xK_n), withFocused minimizeWindow),
            ((mod4Mask, xK_f), sendMessage ToggleLayout),
            ((mod4Mask .|. controlMask, xK_n), sendMessage RestoreNextMinimizedWin),

			((0 , ExtraKey.xF86XK_AudioMute), spawn "amixer -q set Master toggle"),
			((0 , ExtraKey.xF86XK_AudioLowerVolume), spawn "amixer -q set Master 5%- unmute"),
			((0 , ExtraKey.xF86XK_AudioRaiseVolume), spawn "amixer -q set Master 5%+ unmute"),
			((0 , ExtraKey.xF86XK_KbdBrightnessUp), spawn "xbacklight -inc 10"),
			((0 , ExtraKey.xF86XK_MonBrightnessUp), spawn "xbacklight -inc 10"),
			((0 , ExtraKey.xF86XK_KbdBrightnessDown), spawn "xbacklight -dec 10"),
			((0 , ExtraKey.xF86XK_MonBrightnessDown), spawn "xbacklight -dec 10")]

    xmproc <- spawnPipe "xmobar /home/jerin/.xmobarrc"
    tray <- spawn "stalonetray -c /home/jerin/.stalonetrayrc" -- SystemTray
    dunst <- spawn "dunst -config /home/jerin/.config/dunst/dunstrc" --Notifications

    xmonad $ defaultConfig {
        manageHook = manageDocks <+> (isFullscreen --> doFullFloat)  <+> manageHook defaultConfig,
        layoutHook = avoidStruts $ smartBorders $ toggleLayouts Full $ layoutHook defaultConfig,
        handleEventHook = mconcat
                          [ docksEventHook
                          , handleEventHook defaultConfig ],
        logHook = dynamicLogWithPP xmobarPP
                    { 
                        ppOutput = hPutStrLn xmproc,
                        ppTitle = xmobarColor "green" "" . shorten 50,
                        -- ppHiddenNoWindows = xmobarColor "grey" "",
                        ppVisible = wrap "(" ")",
                        ppUrgent = xmobarColor "red" "yellow"
                    },
        modMask = mod4Mask -- Rebind modkey
    } `additionalKeys` keys 
