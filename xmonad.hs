-- xmonad configuration used by Anupam Jain
-- Author: Anupam Jain
import XMonad hiding ((|||))
import XMonad.Layout.LayoutCombinators ((|||), JumpToLayout(..))
import XMonad.Layout.Renamed (renamed, Rename(..))
import XMonad.Config.Gnome (gnomeConfig)
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat)
import XMonad.Hooks.ManageDocks (avoidStruts)
import XMonad.Layout.NoBorders (smartBorders, noBorders)
import XMonad.Layout.Tabbed (tabbed)
import XMonad.Layout.Decoration (shrinkText, defaultTheme, activeBorderColor, activeColor, activeTextColor, inactiveBorderColor, inactiveColor, inactiveTextColor, decoHeight)
import XMonad.Layout.Fullscreen (fullscreenFull)
--import XMonad.Layout.Spiral (spiral)
import XMonad.Util.EZConfig (additionalKeysP, removeKeysP)
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
    --, [ className =? c --> doShift "2:web" | c <- myWebs]
    , [ isFullscreen   --> (doF W.focusDown <+> doFullFloat)]
    ]
  where
    myIgnores = ["Synapse", "Guake.py"]
    myFloats  = ["Galculator"]
    --myWebs    = ["Firefox", "Chromium", "Google-chrome"]


------------------------------------------------------------------------
-- Layouts
-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice. We use the modified implementation
-- from XMonad.Layout.LayoutCombinators so that we can jump to a
-- specific Layout instead of having to cycle through them.
--
-- We also provide descriptive names to some layouts to make it
-- easy to jump to them.
--

myLayout =
  -- These do not overlap with gnome-panel
  avoidStruts
   (   rename "Tall"       ( Tall 1 (3/100) (1/2)            )
   ||| rename "Mirror"     ( Mirror (Tall 1 (3/100) (1/2))   )
   ||| rename "Tabbed"     ( tabbed shrinkText myTabColors   )
   ||| rename "Maximised"  ( Full                            )
   -- ||| rename "Spiral"     ( spiral (6/7)                    )
   )
  -- These effectively take over the entire screen
  |||  rename "Fullscreen" ( noBorders (fullscreenFull Full) )
  where
    rename s = renamed [Replace s]


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
myKeys = concat
  [
    -- Setup M-x subspace keys to directly jump to layouts
    [ ( "M-S-<Up>", sendMessage $ JumpToLayout "Fullscreen" )
    , ( "M-S-f",    sendMessage $ JumpToLayout "Maximised"  )
    , ( "M-S-t",    sendMessage $ JumpToLayout "Tabbed"     )
    , ( "M-S-l",    sendMessage $ JumpToLayout "Tall"       )
    , ( "M-S-m",    sendMessage $ JumpToLayout "Mirror"     )
    ],
    -- Use the dmenu shortcut for Synapse
    [ ( "M-p",      spawn "exec synapse"            )
    ]
  ]

-- Key bindings to remove
myUnKeys =
    -- Remove default dmenu binding to allow overriding
    -- (already changed by gnome-config to gnome-run command)
    [ "M-p"
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
  }
  `removeKeysP`     myUnKeys
  `additionalKeysP` myKeys


------------------------------------------------------------------------
-- Run xmonad with all the defaults we set up.
--
main = xmonad defaults

