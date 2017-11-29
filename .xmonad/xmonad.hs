import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.NoBorders
import XMonad.Util.Run
import XMonad.Util.SpawnOnce
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Actions.WorkspaceNames
import XMonad.Layout.Minimize
import XMonad.Layout.Tabbed
import qualified Graphics.X11.ExtraTypes.XF86 as ExtraKey
import System.IO
import XMonad.Actions.CycleWS
import XMonad.Util.WorkspaceCompare
import XMonad.StackSet
import XMonad.Actions.UpdateFocus
import XMonad.Actions.GridSelect
import XMonad.Actions.WindowBringer
import XMonad.Hooks.UrgencyHook
import XMonad.Util.NamedWindows

data LibNotifyUrgencyHook = LibNotifyUrgencyHook deriving (Read, Show)

instance UrgencyHook LibNotifyUrgencyHook where
    urgencyHook LibNotifyUrgencyHook w = do
        name     <- getName w
        Just idx <- fmap (findTag w) $ gets windowset
        safeSpawn "notify-send" [show name, "workspace " ++ idx]




main = do
    let keys = [
            ((mod4Mask .|. shiftMask, xK_g     ), gotoMenu),
            ((mod4Mask .|. shiftMask, xK_b     ), bringMenu),
            ((mod4Mask, xK_s), spawn "xscreensaver-command -lock"),
            ((mod4Mask, xK_Return), spawn "gnome-terminal"),
            ((mod4Mask, xK_u), spawn "notify-send \"$(date +\"%B %d, %y\")\" \"$(date +\"%H:%M\")\""),
            ((mod4Mask, xK_b), spawn "firefox"),
            ((mod4Mask, xK_c), spawn "google-chrome-stable --proxy-pac-url=http://proxy.iiit.ac.in/proxy.pac"),
            ((mod4Mask, xK_x), spawn "nautilus -w"),
            ((mod4Mask, xK_n), withFocused minimizeWindow),
            ((mod4Mask, xK_f), sendMessage ToggleLayout),
            ((mod4Mask .|. controlMask, xK_n), sendMessage RestoreNextMinimizedWin),
            ((mod4Mask, xK_g), goToSelected defaultGSConfig),
			((0 , ExtraKey.xF86XK_AudioMute), spawn "amixer -q set Master toggle"),
			((0 , ExtraKey.xF86XK_AudioLowerVolume), spawn "amixer -q set Master 5%- unmute"),
			((0 , ExtraKey.xF86XK_AudioRaiseVolume), spawn "amixer -q set Master 5%+ unmute"),
			-- ((0 , ExtraKey.xF86XK_KbdBrightnessUp), spawn "xbacklight -inc 10"),
			-- ((0 , ExtraKey.xF86XK_MonBrightnessUp), spawn "xbacklight -inc 10"),
			((0 , ExtraKey.xF86XK_MonBrightnessUp), spawn "light -A 5"),
			((0 , ExtraKey.xF86XK_KbdBrightnessUp), spawn "light -U 5"),
			-- ((0 , ExtraKey.xF86XK_KbdBrightnessDown), spawn "xbacklight -dec 10"),
			-- ((0 , ExtraKey.xF86XK_MonBrightnessDown), spawn "xbacklight -dec 10")]
			((0 , ExtraKey.xF86XK_KbdBrightnessDown), spawn "light -A 5"),
			((0 , ExtraKey.xF86XK_MonBrightnessDown), spawn "light -U 5"),
            ((mod4Mask, xK_Right), nextWS),
            ((mod4Mask, xK_Left), prevWS),
            ((mod4Mask .|. shiftMask, xK_Right), shiftToNext >> nextWS),
            ((mod4Mask .|. shiftMask, xK_Left), shiftToPrev  >> prevWS),
            ((mod4Mask, xK_z), toggleWS), 
            ((mod4Mask .|. controlMask, xK_Right),        -- a crazy keybinding!
               do t <- findWorkspace getSortByXineramaRule Next NonEmptyWS 2
                  windows . view $ t), 
            ((mod4Mask .|. shiftMask, xK_r      ), renameWorkspace def)
            ]

    xmproc <- spawnPipe "xmobar /home/jerin/.xmobarrc"
    tray <- spawn "stalonetray -c /home/jerin/.stalonetrayrc" -- SystemTray
    dunst <- spawn "dunst -config /home/jerin/.config/dunst/dunstrc" --Notifications

    let tabConfig = defaultTheme {
        activeBorderColor = "#7C7C7C",
        activeTextColor = "#CEFFAC",
        activeColor = "#000000",
        inactiveBorderColor = "#7C7C7C",
        inactiveTextColor = "#EEEEEE",
        inactiveColor = "#000000",
        fontName = "-xos4-terminus-*-*-*-*-12-*-*-*-*-*-*-*"
    }


    xmonad $ withUrgencyHook LibNotifyUrgencyHook $ defaultConfig {
        startupHook = do
            startupHook defaultConfig
            spawnOnce "/home/jerin/.xmonad/autostart"
            adjustEventInput,
        manageHook = manageDocks <+> (isFullscreen --> doFullFloat)  <+> manageHook defaultConfig,
        layoutHook = avoidStruts $ 
                        smartBorders $ 
                            toggleLayouts Full $ 
                                (tabbed shrinkText tabConfig ||| layoutHook defaultConfig),
        handleEventHook = mconcat
                          [ docksEventHook
                          , handleEventHook defaultConfig ],
        -- logHook = workspaceNamesPP xmobarPP >>= dynamicLogString >>= xmonadPropLog,
        -- logHook = dynamicLogWithPP xmobarPP
        --             { 
        --                 ppOutput = hPutStrLn xmproc,
        --                 ppTitle = xmobarColor "green" "" . shorten 50,
        --                 -- ppHiddenNoWindows = xmobarColor "grey" "",
        --                 ppVisible = wrap "(" ")",
        --                 ppUrgent = xmobarColor "red" "yellow"
        --             },
        logHook = workspaceNamesPP xmobarPP { 
        --                 ppOutput = hPutStrLn xmproc,
                        ppTitle = xmobarColor "green" "" . shorten 50,
                        -- ppHiddenNoWindows = xmobarColor "grey" "",
                        ppVisible = wrap "(" ")",
                        ppUrgent = xmobarColor "red" "yellow"
                    } >>= dynamicLogString >>= (xmonadPropLog' "_xworkspaces"),
        modMask = mod4Mask -- Rebind modkey
    } `additionalKeys` keys 
