-- xmonad configuration used by Anupam Jain
-- Author: Anupam Jain
import XMonad
import XMonad.Config.Gnome (gnomeConfig)
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat)
import XMonad.Hooks.ManageDocks (avoidStruts)
import XMonad.Layout.NoBorders (smartBorders, noBorders)
import XMonad.Layout.Tabbed (tabbed)
import XMonad.Layout.Decoration (shrinkText, defaultTheme, activeBorderColor, activeColor, activeTextColor, inactiveBorderColor, inactiveColor, inactiveTextColor, decoHeight)
import XMonad.Layout.Fullscreen (fullscreenFull)
import XMonad.Layout.Spiral (spiral)
import XMonad.Util.EZConfig (additionalKeysP)
import qualified XMonad.StackSet as W

------------------------------------------------------------------------
-- Workspaces
-- The default number of workspaces (virtual screens) and their names.
--
myWorkspaces = ["1:default", "2:web", "3:background", "4:misc"] ++ map show [5..9]


------------------------------------------------------------------------
-- Window rules
-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll . concat $
    -- Merge in the gnome manageHook configuration
    [ [ manageHook gnomeConfig ]
    , [ className =? c --> doIgnore | c <- myIgnores]
    , [ className =? c --> doFloat | c <- myFloats]
    , [ className =? c --> doShift "2:web" | c <- myWebs]
    , [ isFullscreen   --> (doF W.focusDown <+> doFullFloat)]
    ]
  where
    myIgnores = ["Synapse", "Guake.py"]
    myFloats  = ["Galculator"]
    myWebs    = ["Firefox", "Chromium", "Google-chrome"]


------------------------------------------------------------------------
-- Layouts
-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayout = avoidStruts (
    Tall 1 (3/100) (1/2) |||
    Mirror (Tall 1 (3/100) (1/2)) |||
    tabbed shrinkText myTabColors |||
    Full |||
    spiral (6/7)) |||
    noBorders (fullscreenFull Full)


------------------------------------------------------------------------
-- My Tabbed Layout colors
-- Chosen to match Molokai colors

myTabColors = defaultTheme
  { activeColor         = "#5B5A4E"
  , activeBorderColor   = "#999999"
  , activeTextColor     = "#FFFFFF"
  , inactiveColor       = "#1B1D1E"
  , inactiveBorderColor = "#403D3D"
  , inactiveTextColor   = "#FFFFFF"
  , decoHeight          = 16
  }


------------------------------------------------------------------------
-- Key bindings
-- Using EZConfig
myKeys =
  [
  ]


------------------------------------------------------------------------
-- Combine it all together
-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will 
-- use the defaults defined in xmonad/XMonad/Config.hs
-- 
-- No need to modify this.
--
defaults = gnomeConfig
  { workspaces         = myWorkspaces
  , layoutHook         = smartBorders myLayout
  , manageHook         = myManageHook
  } `additionalKeysP` myKeys


------------------------------------------------------------------------
-- Run xmonad with all the defaults we set up.
--
main = xmonad defaults

