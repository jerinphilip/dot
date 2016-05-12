import XMonad
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.UrgencyHook
import XMonad.Util.Run 
import qualified XMonad.StackSet as W
import XMonad.Util.NamedWindows
import System.IO

data LibNotifyUrgencyHook = LibNotifyUrgencyHook deriving (Read, Show)
instance UrgencyHook LibNotifyUrgencyHook where
    urgencyHook LibNotifyUrgencyHook w = do
        name <- getName w
        Just idx <- fmap (W.findTag w) $ gets windowset
        safeSpawn "notify-send" [show name, "workspace" ++ idx ]


main = do
    xmproc <- spawnPipe "xmobar"
    xmonad 
        $ withUrgencyHook LibNotifyUrgencyHook
        $ defaultConfig {
        manageHook = manageDocks <+> manageHook defaultConfig,
        layoutHook = avoidStruts $ layoutHook defaultConfig,
        logHook = dynamicLogWithPP xmobarPP {
                    ppOutput = hPutStrLn xmproc,
                    ppTitle = xmobarColor "green" "". shorten 50
        },
        terminal = "gnome-terminal",
        modMask = mod4Mask,
        borderWidth=0
    }
