#!/bin/sh
# Applies the Rex app preferences worth keeping. The rest of
# com.superlogical.rex (window frames, last focused session, activity state,
# Sparkle and sync keys) is machine state and stays out of version control.

[ "$(uname -s)" = "Darwin" ] || exit 0

domain=com.superlogical.rex

# Appearance
defaults write "$domain" Workspace.appearance -string system
defaults write "$domain" Workspace.lightThemeID -string merino-light
defaults write "$domain" Workspace.darkThemeID -string merino-dark
defaults write "$domain" Workspace.interfaceStyle -string blendTheme
defaults write "$domain" Workspace.usesStandardInactiveWindowPaneStyles -bool true
defaults write "$domain" Workspace.inactivePaneFadeMode -string both

# Tabs, sidebar and activity
defaults write "$domain" Workspace.tabStyle -string vertical
defaults write "$domain" Workspace.tabBarEdge -string top
defaults write "$domain" Workspace.tabIconTintMode -string off
defaults write "$domain" Workspace.sidebarPosition -string left
defaults write "$domain" Workspace.sidebarWidth -float 388
defaults write "$domain" Workspace.activityGrouping -string priority

# Terminal
defaults write "$domain" Workspace.terminalFontName -string "Red Hat Mono"
defaults write "$domain" Workspace.terminalFontPointSize -float 17
defaults write "$domain" Workspace.terminalFontSmoothing -bool true
defaults write "$domain" Workspace.terminalCellHeightPercent -float 1
defaults write "$domain" Workspace.terminalAllowsLigatures -bool true
defaults write "$domain" Workspace.terminalUsesBoldFace -bool true
defaults write "$domain" Workspace.terminalUsesItalicFace -bool true
defaults write "$domain" Workspace.terminalUseThemePalette -bool true
defaults write "$domain" Workspace.terminalSmoothScrolling -bool true
defaults write "$domain" Workspace.terminalCopyOnSelect -bool false
defaults write "$domain" Workspace.terminalCursorStyle -string block
defaults write "$domain" Workspace.terminalCursorStyleForced -bool false
defaults write "$domain" Workspace.cursorShadersEnabled -bool false
