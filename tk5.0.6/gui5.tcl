###################################################################
# This file is part of tk5, a utility program for the
# ICOM IC-R5 receiver.
# 
#    Copyright (C) 2004, Bob Parnass, AJ9S
#
# tk5 is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published
# by the Free Software Foundation; either version 2 of the License,
# or (at your option) any later version.
# 
# tk5 is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with tk5; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
# 02111-1307  USA
###################################################################


proc MakeGui { } \
{
	global Cht
	global Chvector
	global GlobalParam
	global ReadRadioFlag
	global TemplateSavedFlag

	set Cht ""
	set GlobalParam(TemplateFilename) untitled.tr5

	set TemplateSavedFlag no
	set ReadRadioFlag no

	# Set custom font and colors.

	SetAppearance

	###############################################################
	# Menu bar along the top edge.
	###############################################################
	set fr_menubar [MakeMenuBar .mb]
	set mf [frame .mainframe]
	set fr_line1 [frame $mf.line1]
	set fr_lim [frame $mf.lim]
	# frame $mf.chtable
	# set Cht $mf.chtable
	
	set fr_misc [MakeMiscFrame $fr_line1.omsg]
	set fr_display [MakeDisplayFrame $fr_line1.dis]
	set fr_blabels [MakeBankLabelsFrame $fr_line1.blabels]
	set fr_title [MakeTitleFrame $fr_line1.title]
	pack $fr_title -side right -fill y
	pack $fr_misc $fr_display $fr_blabels -side left -fill y
	pack $fr_blabels -side left -fill y

	###############################################################
	# Memory channel scrolled window
	###############################################################

	
	if {$GlobalParam(EditMemoryChannels) == "off"} \
		{
		toplevel .mc
		set Cht .mc
		
		# Prevent user from closing the channel list window unless
		# he elects to exit the entire program.
		
		wm protocol .mc WM_DELETE_WINDOW {ExitApplication}
		wm title $Cht "tk5 Memory Channels"
		wm iconify $Cht
		}

	###############################################################
	# VFO controls window
	###############################################################
	toplevel .vfo
	set fr_vfo .vfo.ctls
	frame $fr_vfo -relief groove

	set fr_search [MakeSearchFrame $fr_vfo.search]

	pack $fr_search \
		-side left \
		-fill both -expand true

	pack $fr_vfo
	
	# Prevent user from closing the VFO controls window unless
	# he elects to exit the entire program.
	wm protocol .vfo WM_DELETE_WINDOW {ExitApplication}
	wm title .vfo "tk5 VFO Settings"
	



	###############################################################
	# Memory Bank controls window
	###############################################################

#	toplevel .mbank
#	set mbank .mbank.ctls
#	frame $mbank -relief groove
#	wm title .mbank "tk5 Memory Bank"
#
#	set fr_bank [MakeMemoryBankFrame $mbank.bank]
#
#	pack $fr_bank -side left -fill both -expand true
#	pack $mbank -side left -fill both -expand true
#	
#	# Prevent user from closing the Bank window unless
#	# he elects to exit the entire program.
#	wm protocol .mbank WM_DELETE_WINDOW {ExitApplication}
#


	###############################################################
	# TV controls window
	###############################################################
	toplevel .tv
	set fr_tv .tv.ctls
	frame $fr_tv -relief groove

	set fr_tvc [MakeTVFrame $fr_tv.c]

	pack $fr_tvc \
		-side left \
		-fill both -expand true

	pack $fr_tv
	
	# Prevent user from closing the window unless
	# he elects to exit the entire program.
	wm protocol .tv WM_DELETE_WINDOW {ExitApplication}
	wm title .tv "tk5 Television Settings "
	
	###############################################################
	# Secondary controls window
	###############################################################
	toplevel .controls
	set ctls .controls.ctls
	frame $ctls -relief groove

	set fr_com [MakeCommFrame $ctls.com]

	pack $fr_com -side left -fill both -expand true
	
	###############################################################
	
	set Chvector ""
	
	pack $fr_menubar -side top -fill x -pady 3 -padx 3
	pack $fr_line1 -side top -fill x -pady 3 -padx 3
	pack $fr_lim -side top -fill x -pady 3 -padx 3
	
	
	pack $ctls -side top -fill both -expand true -padx 3 -pady 3
	pack .mainframe -side top -fill both -expand true
	
	update idletasks
	
	###############################################################
	#  Ask the window manager to catch the delete window
	#  event.
	###############################################################
	wm protocol . WM_DELETE_WINDOW {ExitApplication}
	
	# Prevent user from shrinking or expanding main window.
	wm minsize . [winfo width .] [winfo height .]
	# wm maxsize . [winfo width .] [winfo height .]
	
	wm protocol .controls WM_DELETE_WINDOW {ExitApplication}
	wm title .controls "tk5 Secondary Controls"
	# Prevent user from overshrinking or expanding controls window.
	wm minsize .controls [winfo width .controls] [winfo height .controls]
	wm maxsize .controls [winfo width .controls] [winfo height .controls]
	
	
	# Prevent user from shrinking or expanding window.
	wm minsize .vfo [winfo width .vfo] [winfo height .vfo]
	# wm maxsize .vfo [winfo width .vfo] [winfo height .vfo]


	# Force main window to appear on top by hiding, then
	# then showing it.
	wm withdraw .
	wm deiconify .

	return
}


###################################################################
# Alter color and font appearance based on user preferences.
###################################################################
proc SetAppearance { } \
{
	global GlobalParam

	if {$GlobalParam(Font) != "" } \
		{
		# Designate a custom font for most widgets.
		option add *font $GlobalParam(Font)
		}

	if {$GlobalParam(BackGroundColor) != "" } \
		{
		# Designate a custom background color for most widgets.
		option add *background $GlobalParam(BackGroundColor)
		}

	if {$GlobalParam(ForeGroundColor) != "" } \
		{
		# Designate a custom foreground color for most widgets.
		option add *foreground $GlobalParam(ForeGroundColor)
		}

	if {$GlobalParam(TroughColor) != "" } \
		{
		# Designate a custom slider trough color
		# for most scale widgets.
		option add *troughColor $GlobalParam(TroughColor)
		}

	return
}



##########################################################
# Check if the configuration file exists.
# If it exits, return 1.
#
# Otherwise, prompt the user to select the
# serial port.
##########################################################

proc FirstTimeCheck { Rcfile } \
{
	global AboutMsg
	global GlobalParam
	global Libdir
	global tcl_platform

	if { [file readable $Rcfile] == 1 } \
		{
		return 0
		}

	tk_dialog .about "About tk5" \
		$AboutMsg info 0 OK

	# No readable config file found.
	# Treat this as the first time the user has run the program.

	# Create a new window with radio buttions and
	# an entry field so user can designate the proper
	# serial port.

	set msg "Please identify the serial port to which\n"
	set msg [append msg "your IC-R5 receiver is connected."]

	toplevel .serialport
	set sp .serialport

	label $sp.intro -text $msg

	frame $sp.rbframe
	set fr $sp.rbframe

	if { $tcl_platform(platform) == "windows" } \
		{
		# For Windows.
		radiobutton $fr.com1 -text COM1: -variable port \
			-value {COM1:}
		radiobutton $fr.com2 -text COM2: -variable port \
			-value {COM2:} 
		radiobutton $fr.com3 -text COM3: -variable port \
			-value {COM3:} 
		radiobutton $fr.com4 -text COM4: -variable port \
			-value {COM4:} 

		pack $fr.com1 $fr.com2 $fr.com3 $fr.com4 \
			-side top -padx 3 -pady 3 -anchor w

		} \
	else \
		{
		# For unix, mac, etc..
		radiobutton $fr.s0 -text /dev/ttyS0 -variable port \
			-value {/dev/ttyS0} 
		radiobutton $fr.s1 -text /dev/ttyS1 -variable port \
			-value {/dev/ttyS1} 
		radiobutton $fr.s2 -text /dev/ttyS2 -variable port \
			-value {/dev/ttyS2} 
		radiobutton $fr.s3 -text /dev/ttyS3 -variable port \
			-value {/dev/ttyS3} 
		radiobutton $fr.s4 -text /dev/ttyS4 -variable port \
			-value {/dev/ttyS4} 
		radiobutton $fr.s5 -text /dev/ttyS5 -variable port \
			-value {/dev/ttyS5} 

		pack \
			$fr.s0 $fr.s1 $fr.s2 \
			$fr.s3 $fr.s4 $fr.s5 \
			-side top -padx 3 -pady 3 -anchor w

		}

	radiobutton $fr.other -text "other (enter below)" \
		-variable port \
		-value other

	entry $fr.ent -width 30 -textvariable otherport

	pack $fr.other $fr.ent \
		-side top -padx 3 -pady 3 -anchor w

	button $sp.ok -text "OK" \
		-command \
			{ \
			global GlobalParam

			if {$port == "other"} \
				{
				set GlobalParam(Device) $otherport
				} \
			else \
				{
				set GlobalParam(Device) $port
				}
			# puts stderr "entered $GlobalParam(Device)"
			}

	button $sp.exit -text "Exit" \
		-command { exit }

	pack $sp.intro -side top -padx 3 -pady 3
	pack $fr -side top -padx 3 -pady 3
	pack $sp.ok $sp.exit -side left -padx 3 -pady 3 -expand true



	bind $fr.ent <Key-Return> \
		{
		global GlobalParam
		set GlobalParam(Device) $otherport
		}

	wm title $sp "Select serial port"
	wm protocol $sp WM_DELETE_WINDOW {exit}

	set errorflag true

	while { $errorflag == "true" } \
		{
		tkwait variable GlobalParam(Device)

		if { $tcl_platform(platform) != "unix" } \
			{
			set errorflag false
			break
			}

		# The following tests do not work properly
		# in Windows. That is why we won't perform
		# the serial port tests when running Windows version.

		if { ([file readable $GlobalParam(Device)] != 1) \
			|| ([file writable $GlobalParam(Device)] != 1)}\
			{
			# Device must be readable, writable

			bell
			tk_dialog .badport "Serial port problem" \
				"Serial port problem" error 0 OK
			} \
		else \
			{
			set errorflag false
			}
		}

	destroy $sp
	return 1
}

##########################################################
# ExitApplication
#
# This procedure can do any cleanup necessary before
# exiting the program.
#
# Disable computer control of the radio, then quit.
##########################################################
proc ExitApplication { } \
{
	global GlobalParam
	global ReadRadioFlag
	global TemplateSavedFlag

	if { ($ReadRadioFlag == "yes") \
		&&  ($TemplateSavedFlag == "no") } \
		{
		set msg "You did not save the template data"
		append msg " in a file."

		set result [tk_dialog .sav "Warning" \
			$msg \
			warning 0 Cancel Exit ]

		if {$result == 0} \
			{
			return
			}
		}

	set GlobalParam(EditMemoryChannels) \
		$GlobalParam(EditMemoryChannelsNext) 
	SaveSetup
	# DisableCControl

	exit
}


##########################################################
# NoExitApplication
#
# This procedure prevents the user from
# killing the window.
##########################################################
proc NoExitApplication { } \
{

	set response [tk_dialog .quitit "Exit?" \
		"Do not close this window." \
		warning 0 OK ]

	return
}
##########################################################
#
# Scroll_Set manages optional scrollbars.
#
# From "Practical Programming in Tcl and Tk,"
# second edition, by Brent B. Welch.
# Example 27-2
#
##########################################################

proc Scroll_Set {scrollbar geoCmd offset size} {
	if {$offset != 0.0 || $size != 1.0} {
		eval $geoCmd;# Make sure it is visible
		$scrollbar set $offset $size
	} else {
		set manager [lindex $geoCmd 0]
		$manager forget $scrollbar								;# hide it
	}
}


##########################################################
#
# Listbox with optional scrollbars.
#
#
# Inputs: basename of configuration file
#
# From "Practical Programming in Tcl and Tk,"
# second edition, by Brent B. Welch.
# Example 27-3
#
##########################################################

proc Scrolled_Listbox { f args } {
	frame $f
	listbox $f.list \
		-font {courier 12} \
		-xscrollcommand [list Scroll_Set $f.xscroll \
			[list grid $f.xscroll -row 1 -column 0 -sticky we]] \
		-yscrollcommand [list Scroll_Set $f.yscroll \
			[list grid $f.yscroll -row 0 -column 1 -sticky ns]]
	eval {$f.list configure} $args
	scrollbar $f.xscroll -orient horizontal \
		-command [list $f.list xview]
	scrollbar $f.yscroll -orient vertical \
		-command [list $f.list yview]
	grid $f.list $f.yscroll -sticky news
	grid $f.xscroll -sticky news

	grid rowconfigure $f 0 -weight 1
	grid columnconfigure $f 0 -weight 1

	return $f.list
}


##########################################################
#
# Create a scrollable frame.
#
#
# From "Effective Tcl/Tk Programming,"
# by Mark Harrison and Michael McLennan.
# Page 121.
#
##########################################################

proc ScrollformCreate { win } \
{

	frame $win -class Scrollform -relief groove -borderwidth 3
	scrollbar $win.sbar -command "$win.vport yview"
	pack $win.sbar -side right -fill y

	canvas $win.vport -yscrollcommand "$win.sbar set"
	pack $win.vport -side left -fill both -expand true

	frame $win.vport.form
	$win.vport create window 0 0 -anchor nw \
		-window $win.vport.form

	bind $win.vport.form <Configure> "ScrollFormResize $win"
	return $win
}

proc ScrollFormResize { win } \
{
	set bbox [ $win.vport bbox all ]
	set wid [ winfo width $win.vport.form ]
	$win.vport configure -width $wid \
		-scrollregion $bbox -yscrollincrement 0.1i
}

proc ScrollFormInterior { win } \
{
	return "$win.vport.form"
}


##########################################################
# Contruct the top row of pulldown menus
##########################################################
proc MakeMenuBar { f } \
{
	global AboutMsg
	global Device
	global FileTypes
	global GlobalParam
	global Pgm
	global Version

	# File pull down menu
	frame $f -relief groove -borderwidth 3

	menubutton $f.file -text "File" -menu $f.file.m \
		-underline 0
	menubutton $f.view -text "View" -menu $f.view.m \
		-underline 0
	menubutton $f.data -text "Data" -menu $f.data.m \
		-underline 0
	menubutton $f.radio -text "Radio" -menu $f.radio.m \
		-underline 0
	menubutton $f.help -text "Help" -menu $f.help.m \
		-underline 0
	
	
	menu $f.view.m
	AddView $f.view.m

	menu $f.data.m
	AddData $f.data.m
	
	menu $f.help.m


	$f.help.m add command -label "Readme" \
		-underline 0 \
		-command { \
			set helpfile [format "%s/README" $Libdir ]
			set win [textdisplay_create "README"]
			textdisplay_file $win $helpfile
			}

	$f.help.m add command -label "Tcl info" \
		-underline 0 \
		-command { \
			tk_dialog .about "Tcl info" \
				[HelpTclInfo] info 0 OK
			}

	$f.help.m add command -label "License" \
		-underline 0 \
		-command { \
			set helpfile [format "%s/COPYING" $Libdir ]
			set win [textdisplay_create "Notice"]
			textdisplay_file $win $helpfile
			}
	
	$f.help.m add command -label "About tk5" \
		-underline 0 \
		-command { \
			tk_dialog .about "About tk5" \
				$AboutMsg info 0 OK
			}
	
	menu $f.file.m -tearoff no

	$f.file.m add command -label "Open ..." \
		-underline 0 \
		-command {OpenTemplate .mainframe}
	
	$f.file.m add command -label "Save" \
		-underline 0 \
		-command {SaveTemplate .mainframe 0}

	$f.file.m add command -label "Save As ..." \
		-underline 0 \
		-command {SaveTemplate .mainframe 1}

	$f.file.m add separator

	set msg "Import memory channels from CSV file ..."
	$f.file.m add command -label $msg \
		-underline 0 \
		-command {\
			ImportCSV .
			}

	set msg "Export memory channels to CSV file..."
	$f.file.m add command -label $msg \
		-underline 0 \
		-command {ExportChannels .mainframe}

	$f.file.m add separator

	$f.file.m add command -label "Exit" \
		-underline 1 \
		-command { ExitApplication}
	
	menu $f.radio.m -tearoff no
	AddRadio $f.radio.m


	pack $f.file $f.view $f.data $f.radio -side left -padx 10
	pack $f.help -side right
	
	update
	return $f
}



proc MakeScrollPane {w x y} {
   frame $w -class ScrollPane -width $x -height $y
   canvas $w.c -xscrollcommand [list $w.x set] -yscrollcommand [list $w.y set]
   scrollbar $w.x -orient horizontal -command [list $w.c xview]
   scrollbar $w.y -orient vertical   -command [list $w.c yview]
   set f [frame $w.c.content -borderwidth 0 -highlightthickness 0]
   $w.c create window 0 0 -anchor nw -window $f
   grid $w.c $w.y -sticky nsew
   grid $w.x      -sticky nsew
   grid rowconfigure    $w 0 -weight 1
   grid columnconfigure $w 0 -weight 1
   # This binding makes the scroll-region of the canvas behave correctly as
   # you place more things in the content frame.
   bind $f <Configure> [list Scrollpane_cfg $w %w %h]
   $w.c configure -borderwidth 0 -highlightthickness 0
   return $f
}
proc Scrollpane_cfg {w wide high} {
   set newSR [list 0 0 $wide $high]
	return
   if {![string equals [$w cget -scrollregion] $newSR]} {
      $w configure -scrollregion $newSR
   }
}



##########################################################
# Add widgets to the view menu
##########################################################
proc AddView { m } \
{
	global GlobalParam


	# Change font.

	if {$GlobalParam(Font) == ""} \
		{
		set msg "Change Font"
		} \
	else \
		{
		set msg [format "Change Font (%s)" $GlobalParam(Font)]
		}

	$m add command -label $msg -command \
		{
		set ft [font_select]
		if {$ft != ""} \
			{
			set GlobalParam(Font) $ft

			set msg "The change will take effect next "
			set msg [append msg "time you start tk5."]

			tk_dialog .wcf "Change Appearance" \
				$msg info 0 OK
			}
		}

	$m add command -label "Restore Original Font" -command \
		{
		set GlobalParam(Font) ""
		set msg "The change will take effect next "
		set msg [append msg "time you start tk5."]

		tk_dialog .wcf "Change Appearance" $msg info 0 OK
		}

	$m add separator

	$m add command -label "Change Panel Color" -command \
		{
		set col [tk_chooseColor -initialcolor #d9d9d9]
		if {$col != ""} \
			{
			set GlobalParam(BackGroundColor) $col

			set msg "The change will take effect next "
			set msg [append msg "time you start tk5."]

			tk_dialog .wcf "Change Appearance" \
				$msg info 0 OK
			}
		}

	$m add command -label "Change Lettering Color" -command \
		{
		set col [tk_chooseColor -initialcolor black]
		if {$col != ""} \
			{
			set GlobalParam(ForeGroundColor) $col

			set msg "The change will take effect next "
			set msg [append msg "time you start tk5."]

			tk_dialog .wcf "Change Appearance" \
				$msg info 0 OK
			}
		}

	$m add command -label "Change Slider Trough Color" -command \
		{
		set col [tk_chooseColor -initialcolor #c3c3c3]
		if {$col != ""} \
			{
			set GlobalParam(TroughColor) $col

			set msg "The change will take effect next "
			set msg [append msg "time you start tk5."]

			tk_dialog .wcf "Change Appearance" \
				$msg info 0 OK
			}
		}

	$m add separator


	# Helpful tips balloons


	$m add  checkbutton \
		-label "Balloon Help Windows" \
                -variable GlobalParam(BalloonHelpWindows) \
                -onvalue on -offvalue off 

	return
}


##########################################################
# Add widgets to the Data menu
##########################################################
proc AddData { m } \
{
	global GlobalParam


	set hint ""
	append hint "The Encode Image operation "
	append hint "is designed for use when "
	append hint "testing tk5."
	balloonhelp_for $m $hint

	$m add command -label "Validate data" \
		-command \
			{
			if {[ValidateData] == 0} \
				{
				tk_dialog .info "Valiate data" \
				"The data is ok." info 0 OK
				}
			}


#	$m add command -label "Check for duplicate frequencies" \
#		-command { CkDuplicate }

	$m add command -label "Encode Image" \
		-command { \
			if {[ValidateData] == 0} \
				{
				MakeWait
				EncodeImage
				KillWait
				}
			}

	$m add separator
	
	
#	$m add command -label "Swap Memory Banks ..." \
#		-command { MakeSwapFrame }
#
#	$m add command -label "Sort Channels ..." \
		-command { MakeSortFrame }

	$m add command -label "Clear All Channels" \
		-command { ClearAllChannels }

	return
}



##########################################################
# Add choices to the Radio menu
##########################################################
proc AddRadio { m } \
{
	global GlobalParam
	global Libdir


	$m add command -label "Read from radio ..." \
		-command { \
			Radio2Template .mainframe
			update
			}
	
	$m add command -label "Write to radio ..." \
		-command { \
			Image2Radio .mainframe
			update
			}
	
	
	$m add separator
	$m add command -label "Interrogate radio for model info ..." \
		-command { \
			global GlobalParam

			set s [GetModelInfo]
			binary scan $s "H*" x
			set GlobalParam(RadioVersion) $x
			update
			}
	

	$m add separator


	$m add radiobutton -label "Model with 10 kHz BCB steps" \
		-variable GlobalParam(WhichModel) \
		-value 10

	$m add radiobutton -label "Model with 9 kHz BCB steps" \
		-variable GlobalParam(WhichModel) \
		-value 9



	$m add separator

	$m add command -label "Configure Serial Port ..." \
		-command { MakeConfigurePortFrame }


	$m add separator


	$m add  checkbutton \
		-label "Debug" \
                -variable GlobalParam(Debug) \
                -onvalue "1" \
                -offvalue "0"

	return $m
}



###################################################################
#
# Permit user to adjust serial port settings.
# Create a popup window.
#
###################################################################

proc MakeConfigurePortFrame { } \
{
	global GlobalParam
	global tcl_platform
	global tcl_version

	catch {destroy .timingwin}
	toplevel .timingwin
	wm title .timingwin "Configure serial port"

	set f .timingwin

	set a $f.a
	frame $a -relief flat -borderwidth 3

	label $a.lrtslevel \
		-text "Set RTS pin to +12 VDC" \
		-borderwidth 3
	checkbutton $a.rtslevel -text "" \
		-variable GlobalParam(RTSline) \
		-onvalue "12" -offvalue "-12"

	set hint ""
	append hint "Some cloning cables require +12 VDC on "
	append hint "the RTS pin, but most do not."
	balloonhelp_for $a.lrtslevel $hint
	balloonhelp_for $a.rtslevel $hint

	label $a.lcableechos \
		-text "Read back commands from serial port" \
		-borderwidth 3
	checkbutton $a.cableechos -text "" \
		-variable GlobalParam(CableEchos) \
		-onvalue 1 -offvalue 0

	set hint ""
	append hint "Read back commands if:\n\n"
	append hint "(1) You are using Microsoft Windows "
	append hint "and using either the Purple or RT Sytems "
	append hint "CT29A cloning cable.\n\n"
	append hint "(2) You are using Linux and using \n"
	append hint "an RT Systems CT29A cloning cable.\n\n"
	append hint "Do not read back commands if "
	append hint "you are using Bill Petrowsky's 2-transistor "
	append hint "cable. "

	balloonhelp_for $a.cableechos $hint
	balloonhelp_for $a.lcableechos $hint

        grid $a.lrtslevel  -row 10 -column 0 -sticky w
        grid $a.rtslevel  -row 10 -column 1 -sticky w
        grid $a.lcableechos  -row 20 -column 0 -sticky w
        grid $a.cableechos  -row 20 -column 1 -sticky w

	pack $a -side top -anchor w -padx 3 -pady 3 -expand true


	button $f.ok -text "OK" -command \
		{
		catch {destroy .timingwin}
		}

	pack $f.ok -side top -padx 3 -pady 3 -expand true

	update
	return
}

##########################################################
#
# Create a progress gauge widget.
#
#
# From "Effective Tcl/Tk Programming,"
# by Mark Harrison and Michael McLennan.
# Page 125.
#
##########################################################
proc gauge_create {win {color ""}} \
{
	frame $win -class Gauge

	# set len [option get $win length Length]
	set len 300

	canvas $win.display -borderwidth 0 -background white \
		-highlightthickness 0 -width $len -height 20
	pack $win.display -expand yes -padx 10
	if {$color == ""} \
		{
		set color [option get $win color Color]
		}


	$win.display create rectangle 0 0 0 20 \
		-outline "" -fill $color -tags bar
	$win.display create text [expr {0.5 * $len}] 10 \
		-anchor c -text "0%" -tags value
	return $win
}

proc gauge_value {win val} \
{
	if {$val < 0 || $val > 100} \
		{
		error "bad value \"$val\": should be 0-100"
		}
	set msg [format "%.0f%%" $val]
	$win.display itemconfigure value -text $msg

	set w [expr {0.01 * $val * [winfo width $win.display]}]
	set h [winfo height $win.display]
	$win.display coords bar 0 0 $w $h

	update
}

proc MakeWaitWindow {f cnflag color} \
{
	global CancelXfer

	set CancelXfer 0

	frame $f
	button $f.cancel -text Cancel -command {\
		global CancelXfer; set CancelXfer 1; puts "Canceled"}

	gauge_create $f.g PaleGreen
	option add *Gauge.borderWidth 2 widgetDefault
	option add *Gauge.relief sunken widgetDefault
	option add *Gauge.length 300 widgetDefault
	option add *Gauge.color gray widgetDefault

	pack $f.g -expand yes -fill both \
		-padx 10 -pady 10

	if {$cnflag} \
		{
		pack $f.cancel -side top -padx 3 -pady 3
		}

	

	pack $f
	return $f.g
}

##########################################################
#
# Copy data from radio to template image (a lengthy string).
#
##########################################################
proc Radio2Template { f }\
{
	global Cht
	global FileTypes
	global GlobalParam
	global Home
	global MemFreq
	global MemMode
	global ReadRadioFlag


	set msg ""
	append msg "Instructions (read all steps):\n"
	append msg "1) Ensure the radio is connected to your computer"
	append msg " and powered on.\n"


	set result [tk_dialog .info "Read from radio" \
		$msg \
		info 0 OK Cancel ]

	if {$result} \
		{
		return
		}

	# Read memory image from radio.
	if {[ReadImage]} \
		{
		set ReadRadioFlag no

		set msg "Error while reading from radio."
		tk_dialog .error $msg $msg error 0 OK
		return
		}
		
	set GlobalParam(Populated) 1
	# ZapBankLabels
	DecodeImage
	ShowChannels $Cht

	set msg "Transfer Complete.\n"
	append msg "Look at the radio display "
	append msg "to see if it displays a message."

	tk_dialog .belch "Read IC-R5" \
		$msg info 0 OK

	set ReadRadioFlag yes

	return
}

##########################################################
# Write memory image to a template file.
##########################################################
proc SaveTemplate { f asflag } \
{
	global GlobalParam
	global TemplateSavedFlag
	global ReadRadioFlag
	global Mimage
	global Nmessages

	if {[string length $Mimage] <= 0} \
		{
		set msg "You must first read template data from"
		append msg " the radio before saving it in a"
		append msg " template file."
		append msg " (Use the Radio menu for reading"
		append msg " from the radio.)"

		tk_dialog .error "No template data" \
			$msg error 0 OK
		return
		}

	set mitypes \
		{
		{"IC-R5 template files"           {.tr5}     }
		}

	set filename $GlobalParam(TemplateFilename)

	if { ($GlobalParam(TemplateFilename) == "") \
		|| ($asflag) } \
		{
		set filename \
			[Mytk_getSaveFile $f \
			$GlobalParam(MemoryFileDir) \
			.tr5 \
			"Save IC-R5 data to template file" \
			$mitypes]
		}



	if { $filename != "" }\
		{

		if {[ValidateData]} {return}
		MakeWait
		EncodeImage

		# Truncate memory image to the proper length.
		# We want to ignore the several FF records
		# which may have been appended
		# at the end of the image.

		set n [expr {($Nmessages * 32) - 1}]
		set Mimage [string range $Mimage 0 $n]

		KillWait

		set GlobalParam(TemplateFilename) $filename
		SetWinTitle

		set GlobalParam(MemoryFileDir) \
			[ Dirname $GlobalParam(TemplateFilename) ]

		set fid [open $GlobalParam(TemplateFilename) "w"]
		fconfigure $fid -translation binary
		puts -nonewline $fid $Mimage
		close $fid
		set TemplateSavedFlag yes
		}

	return
}


##########################################################
# Read memory image from a template file.
##########################################################
proc OpenTemplate { f } \
{
	global BytesPerMessage
	global Cht
	global GlobalParam
	global Mimage
	global Nmessages

	set mitypes \
		{
		{"IC-R5 template files"           {.tr5}     }
		{"Percon web files"           {.icf .ICF}    }
		{"www.ic-r5.com files"           {.ic5 .IC5}    }
		}

	set GlobalParam(TemplateFilename) [Mytk_getOpenFile \
		$f $GlobalParam(MemoryFileDir) \
		"Open template file" $mitypes]


	if { $GlobalParam(TemplateFilename) != "" }\
		{
		set GlobalParam(MemoryFileDir) \
			[ Dirname $GlobalParam(TemplateFilename) ]


		if [ catch { open $GlobalParam(TemplateFilename) "r"} fid] \
			{
			# error
			tk_dialog .error "tk5" \
				"Cannot open file $file" \
				error 0 OK
			set GlobalParam(TemplateFilename) ""
			return
			} 
		fconfigure $fid -translation binary


		if { [regexp -nocase {\.icf$}  \
			$GlobalParam(TemplateFilename)] } \
			{
			# User wants to read a Percon .ICF file.
			set GlobalParam(TemplateFilename) ""
			set code [ReadICFFile $fid]
			if {$code == 0} \
				{
				DecodeImage
				}
			} \
		elseif { [regexp -nocase {\.ic5$}  \
			$GlobalParam(TemplateFilename)] } \
			{
			# User wants to read a www.ic-r5.com .IC5 file.
			set GlobalParam(TemplateFilename) ""
			set code [ReadIC5File $fid]
			if {$code == 0} \
				{
				DecodeImage
				}
			} \
		elseif { [regexp -nocase {\.tr5$} \
			$GlobalParam(TemplateFilename)] } \
			{
			# User specified a .tr5 file.
			set nbytes [expr {$Nmessages * $BytesPerMessage / 2}]
			set Mimage [read $fid $nbytes]
			if { [string length $Mimage] != $nbytes } \
				{
				# Corrupted file.
				set msg "Corrupted template file " 
				append msg $GlobalParam(TemplateFilename)
				tk_dialog .error "tk5" \
					"Corrupted template file" \
					error 0 OK

				set code 1
				} \
			else \
				{
				set code 0
				DecodeImage
				set lst [ReadVariables \
					$GlobalParam(TemplateFilename) $fid]
				# ZapBankLabels
				}
			}

		close $fid
		SetWinTitle
		if {$code == 0} \
			{
			set GlobalParam(Populated) 1
			ShowChannels $Cht
			}
		}

	return
}


##########################################################
# Read data from a .ICF (ICOM Clone Format) file
##########################################################
proc ReadICFFile { fid }\
{
	global Cht
	global GlobalParam
	global Icf2Hex
	global Mimage


	if {$fid == ""} then {return ""}


	# Read entire .ICF file at one time.
	set allicf [read $fid]

	set line ""
	set i 0

	set Mimage ""
	# For each line in the file.
	foreach line [split $allicf "\n" ] \
		{
		update

		incr i

		# trim any spurious characters from end, e.g., \r

		# Skip the first 2 lines in the file.


		if { $i > 2 } then\
			{
			set line [string range $line 0 37]
			set nchar [string len $line]

			# for each char in the line

			# set c [string range $line $j $j]
			set buf [string range $line 6 $nchar]

			# Translate to binary
			set buf [string toupper $buf]
			set pbuf [PackString $buf]
			append Mimage $pbuf
			}
		}
		
	set GlobalParam(TemplateFilename) ""

	return 0
}


##########################################################
# Read data from a .IC5 (www.ic-r5.com) file
##########################################################
proc ReadIC5File { fid }\
{
	global Cht
	global GlobalParam
	global Icf2Hex
	global Mimage


	if {$fid == ""} then {return ""}

	set file $GlobalParam(TemplateFilename)

	# Read entire .IC5 file at one time.
	set allicf [read $fid]

	# Sanity test the file.
	set len [string length $allicf]
	if {$len != 64562} \
		{
		# Corrupted file or unexpected length.
		tk_dialog .error "tk5" \
			"Corrupt file $file. Wrong size." \
			error 0 OK
		set GlobalParam(TemplateFilename) ""
		return 1
		}

	set line ""
	set i 0

	set addr 0
	set Mimage ""
	foreach line [split $allicf "\n" ] \
		{
		update

		incr i

		if { [string length $line] == 0} { break }

		# trim any spurious characters from end, e.g., \r

		# Skip the first 2 lines in the file.


		if { $i > 2 } then\
			{
			set haddr [format "%04x" $addr]
			set xaddr [string range $line 0 3]
			set xaddr [string tolower $xaddr]

#			puts stderr "$i, haddr: $haddr, xaddr: $xaddr"
			# If hex address mismatch
			if {$xaddr != $haddr} \
				{
				# Corrupted file or unexpected fmt.
				tk_dialog .error "tk5" \
				"Corrupt file $file. Wrong format." \
				error 0 OK

				set GlobalParam(TemplateFilename) ""
				set Mimage ""
				return 1
				}

			set line [string range $line 0 69]
			set nchar [string len $line]

			set buf [string range $line 6 $nchar]

			# Translate to binary
			set buf [string toupper $buf]
			set pbuf [PackString $buf]
			append Mimage $pbuf
			incr addr 32
			}
		}
		
	set GlobalParam(TemplateFilename) ""

	return 0
}


##########################################################
# Import memory channels from a .csv file
##########################################################
proc ImportCSV { f }\
{
	global BankID
	global Cht
	global CtcssBias
	global GlobalParam
	global Mimage
	global ImageAddr


	if { ([info exists Mimage] == 0) \
		|| ([string length $Mimage] <= 0)} \
		{
		set msg "You must open a template file\n"
		append msg " or read an image from the radio\n"
		append msg " before importing channels.\n"

		tk_dialog .importinfo "tk5" \
			$msg info 0 OK
		return
		}


	set filetypes \
		{
		{"IC-R5 memory channel files"     {.csv .txt}     }
		}


	set filename [Mytk_getOpenFile $f \
		$GlobalParam(MemoryFileDir) \
		"Import channels" $filetypes]

	if {$filename == ""} then {return ""}

	set GlobalParam(MemoryFileDir) [ Dirname $filename ]

	if [ catch { open $filename "r"} fid] \
		{
		# error
		tk_dialog .error "tk5" \
			"Cannot open file $file" \
			error 0 OK

		return
		} 

	# Read entire .csv file at one time.
	set allchannels [read $fid]

	set line ""
	set i 0

	# For each line in the .csv file.
	foreach line [split $allchannels "\n" ] \
		{
		update

		incr i
		if { $i > 1 } then\
			{
			# Delete double quote characters.
			regsub -all "\"" $line "" bline
			set line $bline

			if {$line == ""} then {continue}
#			puts stderr "line: $line."
			
			set msg [ParseCsvLine $line]
			if {$msg != ""} \
				{
				set response [ErrorInFile \
					$msg $line $filename]
				if {$response == 0} then {continue} \
				else {ExitApplication}
				}
			}
		}
		
	ShowChannels $Cht
	close $fid

	return
}

###################################################################
# Parse a line from the csv file.  Perform sanity checks on
# the field values and store them in array variables.
#
# Returns:
#	empty string	-ok
#	descriptive error message string otherwise
###################################################################

proc ParseCsvLine {line} \
{
	global Ctcss
	global CtcssBias
	global Dcs
	global GlobalParam
	global ImageAddr
	global Mimage
	global MemBankLetter
	global MemBankCh
	global MemDuplex
	global MemFreq
	global MemHide
	global MemLabel
	global MemMode
	global MemOffset
	global MemSkip
	global MemStep
	global MemDToneCode
	global MemDTonePolarity
	global MemToneCode
	global MemToneFlag
	global Mode
	global RBankID
	global Skip
	global Step
	global ToneFlag

	set endlabel $GlobalParam(LabelLength)
	incr endlabel -1

	if {$line == ""} {return error}
	set mlist [split $line ","]

	set n [llength $mlist] 
	set m [ expr {15 - $n} ]

	# Add empty fields to the end of the line
	# if there are too few fields.

	for {set i 0} {$i < $m} {incr i} \
		{
		append line ","
		}

	set mlist [split $line ","]

	set i [lindex $mlist 0]
	set ch $i
	set freq [lindex $mlist 1]
	set mode [lindex $mlist 2]
	set step [lindex $mlist 3]
	set offset [lindex $mlist 4]
	set duplex [lindex $mlist 5]
	set toneflag [lindex $mlist 6]
	set ctcss [lindex $mlist 7]
	set dcs [lindex $mlist 8]
	set polarity [lindex $mlist 9]
	set skip [lindex $mlist 10]
	set bn [lindex $mlist 11]
	set membankch [lindex $mlist 12]
	set label [lindex $mlist 13]

#	puts stderr "freq: $freq, label: $label"
	set bn [string toupper $bn]

	if { $bn != ""} \
		{
		if { [info exists RBankID($bn)] == 0 } \
			{
			return "Invalid bank $bn."
			}
		}

	if {$membankch != ""} \
		{
		if {($membankch < 0) || ($membankch > 99)} \
			{
			return "Invalid bank channel $membankch."
			}
		}

	if { ($i < 0) || ($i > 999) } \
		{
		return "Invalid memory number $i."
		}

	
	if { ($freq < $GlobalParam(LowestFreq)) \
		|| ($freq > $GlobalParam(HighestFreq)) } \
		{
		return "Invalid frequency $freq."
		}

	set nmode [string toupper $mode]
	if {$nmode == ""} \
		{
		set nmode NFM
		}
	if { [info exists Mode($nmode)] == 0 } \
		{
		return "Invalid mode $mode."
		}

	set nstep $step
	if {$nstep == ""} \
		{
		set nstep 5
		}
	if {[info exists Step($nstep)] == 0 } \
		{
		return "Invalid step $step."
		}

	if {$offset == ""} \
		{
		set noffset 0.000
		} \
	else \
		{
		set noffset [format "%.3f" $offset]
		}

	if { ($noffset < 0.0) || ($noffset > 159.995) } \
		{
		return "Invalid offset $offset."
		}

	# If duplex field consists of one or more spaces,
	# translate it.

	if { [regexp {^[[:blank:]]+$} $duplex] != 0} \
		{
		set duplex ""
		}

	if {($duplex != "") \
		&& ($duplex != " ") \
		&& ($duplex != "+") \
		&& ($duplex != "-")} \
		{
		return "Invalid duplex flag $duplex."
		}

	if {$duplex == " "} \
		{
		set duplex ""
		}

	if {$toneflag == "d"} \
		{
		set ntoneflag d
		} \
	elseif {$toneflag == "t"} \
		{
		set ntoneflag t
		} \
	elseif {$toneflag == "b"} \
		{
		set ntoneflag b
		} \
	elseif {$toneflag == "p"} \
		{
		set ntoneflag p
		} \
	else \
		{
		set ntoneflag off
		}


	set nctcss $ctcss

	if {$ctcss == ""} \
		{
		set nctcss 0.0
		} \
	elseif { [regexp {\.} $ctcss] == 0} \
		{
		# CTCSS code is probably an integer
		# so append .0 to it.
		set nctcss [format "%s.0" $ctcss]
		}

	if { [info exists Ctcss($nctcss)] == 0 } \
		{
		return "Invalid CTCSS code $ctcss."
		}

	set odcs $dcs
	if {($dcs == "") || ($dcs == 0)} \
		{
		set dcs "023"
		}
	# Pad with zeroes on the left until there are 3 characters.
	# This is to compensate for people who use Excel to
	# edit csv files. Excel may ruthlessly trim leading zeroes.

	set dcs [PadLeft0 3 $dcs]

	if { [info exists Dcs($dcs)] == 0 } \
		{
		return "Invalid DCS code $odcs."
		}

	set polarity [string tolower $polarity]

	if { ($polarity != "") && ($polarity != "normal") \
		&& ($polarity != "n") && ($polarity != "r") \
		&& ($polarity != "reverse") } \
		{
		return "Invalid DCS Polarity $polarity."
		}

	# Must be null, a space, skip, or pskip to be valid.
	if {($skip != "") && ($skip != " ")} \
		{
		if { [info exists Skip($skip)] == 0 } \
			{
			return "Invalid skip value $skip."
			}
		}

	ZapChannel $ch
	set MemHide($ch) ""
	set MemFreq($ch) [format "%.5f" $freq]
	set MemMode($ch) $nmode
	set MemStep($ch) $nstep
	set MemOffset($ch) $noffset
	set MemDuplex($ch) $duplex
	set MemToneFlag($ch) $ntoneflag
	set MemToneCode($ch) $nctcss
	set MemDToneCode($ch) $dcs
	set MemDTonePolarity($ch) $polarity
	set MemSkip($ch) $skip
	set MemBankLetter($ch) $bn
	set MemBankCh($ch) $membankch

	set s [string range $label 0 $endlabel]
	set s [string trimright $s " "]
	set MemLabel($ch) $s

	return ""
}


##########################################################
# Read memory image from an open Goran Valaski .r2 file
#
# Inputs:
#		fid	-file descriptor
##########################################################
proc ReadR5File { fid }\
{
	global GlobalParam
	global Mimage
	global Nmessages
	global Pgm


	# Read the first part of .r2 file one record at a time.

	set image ""

	for {set i 0} {$i < $Nmessages} {incr i} \
		{
		set line [read $fid 46]
		set len [string length $line]
		if {$len != 46} \
			{
			set msg "$Pgm: "
			append msg "Corruption in .r2 file"
			puts stderr $msg

			tk_dialog .error "tk5" \
				"Corrupted template file" \
				error 0 OK

			return -1
			}

		set cc [string index $line 4]

		if { [string compare -nocase -length 1 $cc \xE4] } \
			{
			set msg "$Pgm: "
			append msg "Corruption in template file"
			puts stderr $msg

			tk_dialog .error "tk5" \
				"Corrupted template file" \
				error 0 OK

			return -1
			}
	

		set pline [PackString [string range $line 5 44]]
		set plen [string length $pline]

		set dbuf [string range $pline 0 18] 
		set cksum [string range $pline 19 19] 
		set ccksum [CalcCheckSum $dbuf]
	
		binary scan $cksum "H*" icksum
		scan $icksum "%x" cksum
	
#		puts stderr [format "CHECKSUM file: %s, calculated: %s\n" \
#				$cksum $ccksum]
	
		if {$cksum != $ccksum} \
			{
			set msg [format \
				"%s: error, checksum mismatch, radio: %s, calculated: %s\n" \
				$Pgm $cksum $ccksum]
			Tattle $msg
			tk_dialog .error "Checksum error while reading file" \
				$msg error 0 OK
			return -1
			}


		# Strip off memory address and count bytes.
		set buf [string range $dbuf 3 end]
		# set buf [string range $pline 5 44]

#		set abuf "$i) "
#		append abuf [DumpBinary $buf]
#		puts stderr $abuf

		append image $buf
		}

	set Mimage $image
	return 0
}


##########################################################
# Read memory image from an open Butel ARC2 .IC2 file
#
# Inputs:
#		fid	-file descriptor
##########################################################
proc ReadIC2File { fid }\
{
	global GlobalParam
	global Mimage
	global Nmessages
	global Pgm


	# Read the first part of .r2 file one line at a time.

	set image ""

	for {set i 0} {$i < $Nmessages} {incr i} \
		{
		set len [gets $fid line]
		if {$len < 40} \
			{
			set msg "$Pgm: "
			append msg "Corruption in ARC .IC2 file"
			puts stderr $msg

			tk_dialog .error "tk5" \
				"Corrupted ARC2 .IC2 file" \
				error 0 OK

			return -1
			}

		set line [string range $line 0 39]
		set pline [binary format "H40" $line]
		set plen [string length $pline]

		set dbuf [string range $pline 0 18] 


		set cksum [string range $pline 19 19] 
		set ccksum [CalcCheckSum $dbuf]
	
		binary scan $cksum "H*" icksum
		scan $icksum "%x" cksum
	
#		puts stderr [format "CHECKSUM file: %s, calculated: %s\n" \
#				$cksum $ccksum]
	
		if {$cksum != $ccksum} \
			{
			set msg [format \
				"%s: error, checksum mismatch, radio: %s, calculated: %s\n" \
				$Pgm $cksum $ccksum]
			Tattle $msg
			tk_dialog .error "Checksum error while reading file" \
				$msg error 0 OK
			return -1
			}


		# Strip off memory address and count bytes.
		set buf [string range $dbuf 3 end]
		# set buf [string range $pline 5 44]

#		set abuf "$i) "
#		append abuf [DumpBinary $buf]
#		puts stderr $abuf

		append image $buf
		}

	set Mimage $image
	return 0
}



##########################################################
# Show memory channels in a window.
##########################################################
proc ShowChannels { f }\
{
	global BankLabel
	global Chb
	global Chvector
	global GlobalParam
	global MemBankCh
	global MemBankLetter
	global MemDuplex
	global MemFreq
	global MemHide
	global MemLabel
	global MemMode
	global MemOffset
	global MemSkip
	global MemStep
	global MemDToneCode
	global MemToneCode
	global MemToneFlag
	global NBanks
	global RMode

	set Chvector ""

	if {$GlobalParam(EditMemoryChannels) == "on"} {return}

	for {set ch 0} {$ch < 1000} {incr ch} \
		{

		if {($MemHide($ch) != "hide")  \
			&& ($MemFreq($ch) > 0.0001)}  \
			{
			if { ($MemOffset($ch) < .001) \
				|| ($MemDuplex($ch) == "") \
				|| ($MemDuplex($ch) == " ") } \
				{
				set offset ""
				} \
			else \
				{
				set offset [format "%9.5f" \
					$MemOffset($ch)]
				}

			if { $MemToneFlag($ch) == "d"} \
				{
				# DCS
				set toneflag $MemToneFlag($ch)
				set dtonecode $MemDToneCode($ch)
				set tonecode ""
				} \
			elseif { $MemToneFlag($ch) == "p"} \
				{
				# DCS with pocket beep
				set toneflag $MemToneFlag($ch)
				set dtonecode $MemDToneCode($ch)
				set tonecode ""
				} \
			elseif { $MemToneFlag($ch) == "t"} \
				{
				# CTCSS
				set toneflag $MemToneFlag($ch)
				set dtonecode ""
				set tonecode $MemToneCode($ch)
				} \
			elseif { $MemToneFlag($ch) == "b"} \
				{
				# CTCSS with pocket beep
				set toneflag $MemToneFlag($ch)
				set dtonecode ""
				set tonecode $MemToneCode($ch)
				} \
			else \
				{
				# presume Tone is off, so
				# hide CTCSS the code.
				set toneflag ""
				set tonecode ""
				set dtonecode ""
				} 

			set mode [string toupper $MemMode($ch)]
			set s [format "%3d %11.5f %-3s %5s %9s %1s %1s %5s %3s %-5s %1s %2s %-s" \
				$ch $MemFreq($ch) \
				$mode \
				$MemStep($ch) \
				$offset \
				$MemDuplex($ch) \
				$toneflag \
				$tonecode \
				$dtonecode \
				$MemSkip($ch) \
				$MemBankLetter($ch) \
				$MemBankCh($ch) \
				$MemLabel($ch)
				]
			lappend Chvector $s
			} \
		else \
			{
			# puts stderr "ch $ch, $MemSkip($ch)"
			}
		}
		
	catch {destroy $f.lch}
	set Chb [ List_channels $f.lch $Chvector 30 ]

	# Force memory ch window to appear on top by hiding, then
	# then showing it.
	catch {wm withdraw $f}
	catch {wm deiconify $f}


	$Chb activate 1
	pack $f.lch -side top

	wm maxsize .vfo [winfo width .vfo] [winfo height .vfo]

	return
}

##########################################################
# Export memory channels to a .csv file
##########################################################
proc ExportChannels { f }\
{
	global FileTypes
	global GlobalParam
	global Home
	global MemBankCh
	global MemBankLetter
	global MemDuplex
	global MemFreq
	global MemHide
	global MemLabel
	global MemMode
	global MemOffset
	global MemSkip
	global MemStep
	global MemDTonePolarity
	global MemDToneCode
	global MemToneCode
	global MemToneFlag
	global Mimage
	global Ofilename

	set endlabel $GlobalParam(LabelLength)
	incr endlabel -1

	if { ([info exists Mimage] == 0) \
		|| ([string length $Mimage] <= 0) } \
		{
		set msg "You must read data from the radio"
		append msg " before exporting channels."
		append msg " (See the Radio menu.)"
		tk_dialog .info "tk5" $msg info 0 OK
		return
		}


	set Ofilename [Mytk_getSaveFile $f \
		$GlobalParam(MemoryFileDir) \
		.csv \
		"Export memory channels to .csv file" \
		$FileTypes]


	if {$Ofilename != ""} \
		{
		# puts stderr "ExportChannels: Ofilename $Ofilename"
		set GlobalParam(MemoryFileDir) [ Dirname $Ofilename ]

		set fid [open $Ofilename "w"]


		# Write first line as the field names.
		puts -nonewline $fid [format "Mem,MHz,Mode,"]
		puts -nonewline $fid [format "Step,Offset,Duplex,"]
		puts -nonewline $fid [format "TSQL,CTCSS,DCS,Polarity,"]
		puts $fid [format "Skip,Bank,Ch,Label"]

		set s ""
		for {set ch 0} {$ch < 1000} {incr ch} \
			{
			if {($MemHide($ch) == "hide") \
				|| ($MemFreq($ch) == "") \
				|| ($MemFreq($ch) <= .000001)} \
				{
				continue
				}

			if {$MemToneFlag($ch) == "t"} \
				{
				set toneflag t
				} \
			elseif {$MemToneFlag($ch) == "b"} \
				{
				set toneflag b
				} \
			elseif {$MemToneFlag($ch) == "d"} \
				{
				set toneflag d
				} \
			elseif {$MemToneFlag($ch) == "p"} \
				{
				set toneflag p
				} \
			else \
				{
				set toneflag ""
				}

			set skip $MemSkip($ch)
			if {$skip == " "} \
				{
				set skip ""
				}

			set duplex $MemDuplex($ch)
			if {$duplex == " "} \
				{
				set duplex ""
				}

			if { [info exists MemBankLetter($ch)] == 0} \
				{
				set bank ""
				} \
			else \
				{
				set bank $MemBankLetter($ch)
				}

			if { [info exists MemBankCh($ch)] == 0} \
				{
				set bchan ""
				} \
			else \
				{
				set bchan $MemBankCh($ch)
				}

			set s [format "%d,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s," \
				$ch $MemFreq($ch) \
				$MemMode($ch) \
				$MemStep($ch) \
				$MemOffset($ch) \
				$duplex \
				$toneflag \
				$MemToneCode($ch) \
				$MemDToneCode($ch) \
				$MemDTonePolarity($ch) \
				$skip \
				$bank \
				$bchan ]

			if {$MemLabel($ch) != ""} \
				{
				set lab [string range \
					$MemLabel($ch) 0 \
					$endlabel]
				set lab [string trimright $lab \
					 " "]
				set lab [format "\"%s\"" $lab]

				append s $lab
				}
			puts $fid $s
			}

		close $fid
		tk_dialog .belch "Export" \
			"Export Complete" info 0 OK

		}
	return
}

##########################################################
# Create a popup window which tells the user
# that the file already exists.  Ask for guidance.
#
# Returns:
#	Cancel
#	Overwrite
##########################################################

proc FileExistsDialog { file } \
{
	set result [tk_dialog .fed "Warning" \
		"File $file already exists. Overwrite file?" \
		warning 0 Cancel Overwrite ]

	puts "result is $result"
	return $result
}


##########################################################
# Copy memory image to the radio
##########################################################
proc Image2Radio { f }\
{
	global FileTypes
	global Mimage
	global ReadRadioFlag

	if { ([info exists Mimage] == 0) \
		|| ([string length $Mimage] <= 0)} \
		{
		# No image to write.
		set msg "You must first read template data from"
		append msg " the radio or a file before"
		append msg " writing it to the radio."

		tk_dialog .error "Write to radio" $msg error 0 OK
		}

	if {$ReadRadioFlag == "yes"} \
		{
		# We read an image from the radio.
		# Cannot read from and write to the radio
		# during the same session or else the radio
		# complains. (Reason unknown.)
		#
		# Tell user to save the image file, exit
		# the program, restart the program, read
		# the image file, then write to the radio.

		set msg ""
		append msg "You cannot read from the radio "
		append msg "and write to the radio during the same "
		append msg "session.\n\n"
		append msg "Please:\n"
		append msg "1) Save the memory image in a file,\n"
		append msg "using File --> Save As ...\n"
		append msg "2) Exit this program.\n"
		append msg "3) Restart this program.\n"
		append msg "4) Open the image file you saved "
		append msg "previously, using File --> Open ...\n "
		append msg "5) Then, you can write the image "
		append msg "to the radio."

		tk_dialog .belch "Write blocked warning" \
			$msg warning 0 OK
		return
		}

	if {[ValidateData]} {return}
	MakeWait
	EncodeImage
	KillWait

	set msg ""
	append msg "Instructions:\n"
	append msg "1) Ensure the radio is connected to"
	append msg " your computer and radio power is on.\n"

	set result [tk_dialog .info "Write to IC-R5" \
		$msg \
		info 0 OK Cancel ]

	if {$result} \
		{
		# User canceled the write.
		return
		}

	set wcode [WriteImage]
	if {$wcode == 1} \
		{
		set msg "Error while writing to the radio."
		tk_dialog .error "Write error" $msg error 0 OK
		KillWait
		} \
	elseif {$wcode == 2} \
		{
		set msg "Error, cannot read radio version info."
		tk_dialog .error "Write error" $msg error 0 OK
		KillWait
		} \
	else \
		{
		set msg "Transfer Complete.\n"
		append msg "Look at the radio display "
		append msg "to view a status message."
		tk_dialog .belch "Transfer Complete" \
			$msg info 0 OK
		}

	return
}

###################################################################
# Return 1 if frequency is in range 0 - 2000 exclusive.
###################################################################
proc FreqInRange { f units } \
{
	if {$units == "mhz" } \
		{
		if { $f > 0 && $f < 2000.0 } \
			{
			return 1
			}
		} \
	elseif {$units == "khz" } \
		{
		if { $f > 0 && $f < 2000000.0 } \
			{
			return 1
			}
		}
	return 0
}

###################################################################
# Return 1 if string 's' is a valid frequency.
# Return 0 otherwise.
#
# Units should be kHz or MHz
###################################################################
proc CheckFreqValid { s units }\
{
	if {$s == ""} then {return 0}

	# Check for non-digit and non decimal point chars.
	set rc [regexp {^[0-9.]*$} $s]
	if {$rc == 0} then {return 0}


	# All digits.
	set rc [regexp {^[0-9]*$} $s]
	if {$rc == 1} \
		{
		return [FreqInRange $s $units]
		}

	if {$s == "."} then {return 0}

	# Check for Two or more decimal points
	set tmp $s
	set tmp [split $s "."]
	set n [llength $tmp]
	if { $n >= 3 } then {return 0}
	
	return [FreqInRange $s $units]
}


###################################################################
# Set default receiver parameters
###################################################################
proc SetUp { } \
{
	global env
	global GlobalParam
	global RootDir
	global tcl_platform


	if { [regexp "Darwin" $tcl_platform(os) ] } \
		{
		# For Mac OS X.
		set RootDir ":"
		} \
	else \
		{
		set RootDir "/"
		}

	set GlobalParam(Debug) 0
	# set GlobalParam(Device) /dev/ttyS1
	set GlobalParam(Ifilename) {}
	set GlobalParam(MemoryFileDir) $RootDir
	set GlobalParam(PreviousFreq) 0.0

	return
}



###################################################################
# 
# Define receiver parameters before we read the
# global parameter configuration file in case they are missing
# from the configuration file.
# This avoids a tcl error if we tried to refer to an
# undefined variable.
#
# These initial definitions will be overridden with
# definitions from the configuration file.
#
###################################################################

proc PresetGlobals { } \
{
	global GlobalParam
	global Mode
	global Rcfile
	global RootDir
	global tcl_platform

	set GlobalParam(BalloonHelpWindows) on

	set GlobalParam(AMantenna) EXT
	set GlobalParam(Attenuator) 0
	set GlobalParam(AutoOff) OFF
	set GlobalParam(BackGroundColor) ""
	set GlobalParam(BankScan) 0
	set GlobalParam(BankSort) -1
	set GlobalParam(BatterySaver) 1
	set GlobalParam(Beep) 1
	set GlobalParam(CableEchos) 1
	set GlobalParam(Contrast) 2
	set GlobalParam(Debug) 0
	set GlobalParam(Dial) 1MHz
	set GlobalParam(DialAccel) 1
	set GlobalParam(DTRline) 12
	set GlobalParam(EditMemoryChannels) off
	set GlobalParam(EditMemoryChannelsNext) \
		$GlobalParam(EditMemoryChannels)
	set GlobalParam(FMantenna) EXT
	set GlobalParam(Font) ""
	set GlobalParam(ForeGroundColor) ""
	set GlobalParam(Lamp) AUTO
	set GlobalParam(LimitSearch) 0
	set GlobalParam(Lock) 0
	set GlobalParam(LockEffect) NORMAL
	set GlobalParam(MemoryFileDir) $RootDir
	set GlobalParam(Mode) $Mode(NFM)
	set GlobalParam(Monitor) PUSH
	set GlobalParam(Pause) 10
	set GlobalParam(PowerSave) 1
	set GlobalParam(RadioVersion) ""
	set GlobalParam(Resume) 2
	set GlobalParam(DTRline) 12
	set GlobalParam(RTSline) -12
	set GlobalParam(ScanStopBeep) 0
	set GlobalParam(SetMenuItem) 0
	set GlobalParam(TroughColor) ""
	set GlobalParam(TuningStep) 5
	set GlobalParam(VFOSearch) ALL
	set GlobalParam(VFOFreq) 162.4000
	set GlobalParam(WhichModel) 10
	set GlobalParam(WXFreq) 162.55
	set GlobalParam(WXMode) AUTO

	return
}


###################################################################
# Set global variables after reading the global
# configuration file so these settings override
# whatever values were in the configuration file.
###################################################################

proc OverrideGlobals { } \
{
	global env
	global GlobalParam
	global RootDir
	global tcl_platform


	set GlobalParam(BypassAllEncoding) 0
	set GlobalParam(EditMemoryChannelsNext) \
		$GlobalParam(EditMemoryChannels)
	set GlobalParam(FileVersion) "                "
	set GlobalParam(Ifilename) {}
	set GlobalParam(LowestFreq) .100
	set GlobalParam(HighestFreq) 1309.995
	set GlobalParam(LabelLength) 6
	set GlobalParam(NmsgsRead) 0
	set GlobalParam(Populated) 0
	set GlobalParam(SortBank) 0
	set GlobalParam(SortType) freq
	set GlobalParam(TemplateFilename) {}
	set GlobalParam(UserComment) "                "
	set GlobalParam(UserPort) 0

	# Note on MacOS X:
	# The initial directory passed to the file chooser widget.
	# The problem here is that osx's tcl is utterly busted.
	# The _only_ pathname it accepts is ':' - no other ones work.
	# Now this isn't as bad as you might think because
	# the native macos file selector widget persistantly
	# remembers the last place you opened/saved a file
	# for a particular application. So the logic to
	# remember this is simply redundant on macos anyway...
	# Presumably they'll fix this someday and we can take
	# out the hack.
	# - Ben Mesander

	if { [regexp "Darwin" $tcl_platform(os) ] } \
		{
		# kluge for MacOS X.

		set GlobalParam(LogFileDir) $RootDir
		set GlobalParam(MemoryFileDir) $RootDir

		if {$GlobalParam(Ifilename) != ""} \
			{
			set GlobalParam(Ifilename) $RootDir
			}
		}

	return
}

###################################################################
#
# Parse data from inside the memory image and store it
# in global arrays.
#
###################################################################
proc DecodeImage { } \
{
	global MemFreq
	global MemDuplex
	global MemMode
	global MemOffset
	global MemStep
	global MemToneCode
	global MemToneFlag

	MakeWait
	update idletasks


	ZapBankLabels

	for {set ch 0} {$ch < 1000} {incr ch} \
		{
		ZapChannel $ch
		}

	DecodeMisc
	DecodeMemories
	DecodeBankLabels
	DecodeSearchBanks
	DecodeTV
	DecodeHiddenTVChannelFlags
	DecodeSkipTVChannelFlags

	update idletasks
	KillWait
	update idletasks
	return
}

###################################################################
#
# Parse data from inside the memory image and store it
# in global arrays.
#
###################################################################
proc DecodeMisc { } \
{
	global GlobalParam
	global ImageAddr
	global Mimage
	global Priority
	global PriorityMode
	global RAMant
	global RAutoOff
	global RDial
	global RFMant
	global RBatterySaver
	global RMode
	global RMonitor
	global RLockEffect
	global RLamp
	global RFstep
	global RPause
	global RResume
	global RStep




#	# Parse file version
#	scan $ImageAddr(FileVersion) "%x" first
#	set last [expr {$first + 15}]
#	set GlobalParam(FileVersion) \
#		[string range $Mimage $first $last]
#
#	# Parse user comment 
#	scan $ImageAddr(UserComment) "%x" first
#	set last [expr {$first + 15}]
#	set GlobalParam(UserComment) \
#		[string range $Mimage $first $last]



	# Parse Lock function effect
	scan $ImageAddr(LockEffect) "%x" first
	set s [string range $Mimage $first $first]
	set n [Char2Int $s]
	if { [info exists RLockEffect($n)] } \
		{
		set GlobalParam(LockEffect) $RLockEffect($n)
		} \
	else \
		{
		set GlobalParam(LockEffect) NORMAL
		}

	# Parse dial acceleration flag
	scan $ImageAddr(DialAccel) "%x" first
	set byte [string range $Mimage $first $first]
	set GlobalParam(DialAccel) [Char2Int $byte]


	# Parse power save flag
	scan $ImageAddr(PowerSave) "%x" first
	set byte [string range $Mimage $first $first]
	set GlobalParam(PowerSave) [Char2Int $byte]

#	# Parse bank scan flag
#	scan $ImageAddr(BankScan) "%x" first
#	set byte [string range $Mimage $first $first]
#	set GlobalParam(BankScan) [Char2Int $byte]
#

	# Parse beep tone, on or off flag
	scan $ImageAddr(Beep) "%x" first
	set byte [string range $Mimage $first $first]
	set GlobalParam(Beep) [Char2Int $byte]

#	# parse Tuning Step
#	scan $ImageAddr(VFOStep) "%x" first
#	set byte [string range $Mimage $first $first]
#	binary scan $byte "H2" s
#
#	if { [info exists RStep($s)] } \
#		{
#		set GlobalParam(TuningStep) $RStep($s)
#		} \
#	else \
#		{
#		set GlobalParam(TuningStep) AUTO
#		}
#
#	# Parse VFO/Limit Search bit
#	scan $ImageAddr(FlagByte0) "%x" first
#	set s [string range $Mimage $first $first]
#	set GlobalParam(LimitSearch) [GetBit $s 3]




	# Parse Auto Power Off
	scan $ImageAddr(AutoOff) "%x" first
	set s [string range $Mimage $first $first]
	set n [Char2Int $s]
	if { [info exists RAutoOff($n)] } \
		{
		set GlobalParam(AutoOff) $RAutoOff($n)
		} \
	else \
		{
		set GlobalParam(AutoOff) OFF
		}


	# parse Expanded Set Mode Flag
	scan $ImageAddr(ExpandedSetModeFlag) "%x" first
	set s [string range $Mimage $first $first]
	set GlobalParam(ExpandedSetMode) [Char2Int $s]

	# parse Scan stop beep flag
	scan $ImageAddr(ScanStopBeep) "%x" first
	set s [string range $Mimage $first $first]
	set GlobalParam(ScanStopBeep) [Char2Int $s]

	# Parse Dial
	scan $ImageAddr(DialStep) "%x" first
	set s [string range $Mimage $first $first]
	set n [Char2Int $s]
	if { [info exists RDial($n)] } \
		{
		set GlobalParam(Dial) $RDial($n)
		} \
	else \
		{
		set GlobalParam(Dial) 1MHz
		}



	# decode display contrast
	# contrast is stored in the image as one less.
	scan $ImageAddr(Contrast) "%x" first
	set s [string range $Mimage $first $first]
	set n [Char2Int $s]
	if { ($n >= 0) && ($n <= 3) } \
		{
		incr n
		set GlobalParam(Contrast) $n
		} \
	else \
		{
		set GlobalParam(Contrast) 2
		}


	scan $ImageAddr(Lamp) "%x" first
	set s [string range $Mimage $first $first]
	set n [Char2Int $s]
	if { [info exists RLamp($n)] } \
		{
		set GlobalParam(Lamp) $RLamp($n)
		} \
	else \
		{
		set GlobalParam(Lamp) AUTO
		}


	# parse AM antenna
	scan $ImageAddr(AMantenna) "%x" first
	set s [string range $Mimage $first $first]
	set n [Char2Int $s]
	if { [info exists RAMant($n)] } \
		{
		set GlobalParam(AMantenna) $RAMant($n)
		} \
	else \
		{
		set GlobalParam(AMantenna) EXT
		}


	# parse FM antenna
	scan $ImageAddr(FMantenna) "%x" first
	set s [string range $Mimage $first $first]
	set n [Char2Int $s]
	if { [info exists RFMant($n)] } \
		{
		set GlobalParam(FMantenna) $RFMant($n)
		} \
	else \
		{
		set GlobalParam(FMantenna) EXT
		}


	scan $ImageAddr(Pause) "%x" first
	set s [string range $Mimage $first $first]
	set n [Char2Int $s]
	if { [info exists RPause($n)] } \
		{
		set GlobalParam(Pause) $RPause($n)
		} \
	else \
		{
		set GlobalParam(Pause) 2
		}


	scan $ImageAddr(Resume) "%x" first
	set s [string range $Mimage $first $first]
	set n [Char2Int $s]
	if { [info exists RResume($n)] } \
		{
		set GlobalParam(Resume) $RResume($n)
		} \
	else \
		{
		set GlobalParam(Resume) 2
		}


	# Monitor key
	scan $ImageAddr(Monitor) "%x" first
	set s [string range $Mimage $first $first]
	set n [Char2Int $s]
	if { [info exists RMonitor($n)] } \
		{
		set GlobalParam(Monitor) $RMonitor($n)
		} \
	else \
		{
		set GlobalParam(Monitor) PUSH
		}


#	# Parse Fast Tuning Step
#	scan $ImageAddr(FastTuningStep) "%x" first
#	set s [string range $Mimage $first $first]
#	set n [Char2Int $s]
#	if { [info exists RFstep($n)] } \
#		{
#		set GlobalParam(FastTuningStep) $RFstep($n)
#		} \
#	else \
#		{
#		set GlobalParam(FastTuningStep) 1MHz
#		}

	return
}


###################################################################
#
# Parse data from inside the memory image and store it
# in global arrays.
#
# NOTES:
#	Each memory channel is represented by 8 consecutive bytes.
#	The first 3 bytes contain the frequency digits in hex.
#	The most significant nibble in the first byte is 0-E.
#	Frequencies of 1000 MHz and higher start with a letter.
#
#	The fourth byte is a little strange. It contains both the
#	simplex/duplex flag and part of the offset
#
#	
###################################################################
proc DecodeMemories { } \
{
	global BankID
	global CtcssBias
	global Mimage
	global MemBankLetter
	global MemBankCh
	global MemDuplex
	global MemFreq
	global MemHide
	global MemLabel
	global MemMode
	global MemOffset
	global MemSkip
	global MemStep
	global MemDToneCode
	global MemDTonePolarity
	global MemToneCode
	global MemToneFlag
	global ImageAddr
	global RCtcss
	global RDcs
	global RMode
	global RSkip
	global RStep
	global ToneFlag


	# Parse memory channel frequencies.
	scan $ImageAddr(MemoryFreqs) "%x" first
	set last [expr {$first + 2}]

	for {set ch 0} {$ch < 1000} {incr ch} \
		{
		set s [string range $Mimage $first $last]

		set f [Internal2Freq3 $s]

		if {$f < .001} \
			{
			set MemFreq($ch) ""
			} \
		else \
			{
			set MemFreq($ch) $f
			}
		incr first 16
		incr last 16
		}


	# Parse memory channel offset frequencies.
	scan $ImageAddr(MemoryOffset) "%x" first
	set last [expr {$first + 1}]

	scan $ImageAddr(MemoryMult) "%x" mfirst

	for {set ch 0} {$ch < 1000} {incr ch} \
		{
		set s [string range $Mimage $first $last]
		set m [string index $Mimage $mfirst]

		set f [Offset2Freq $s $m]

		if {$f < .001} {set f ""}

		set MemOffset($ch) $f

		incr first 16
		incr last 16
		incr mfirst 16
		}


	# Parse memory channel duplex/simplex flag.
	scan $ImageAddr(MemoryDuplex) "%x" first

	for {set ch 0} {$ch < 1000} {incr ch} \
		{
		set MemDuplex($ch) " "

		set byte [string range $Mimage $first $first]
		set n [GetBitField $byte 6 7]

		if {$n == 0}\
			{
			set MemDuplex($ch) " "
			} \
		elseif {$n == 1} \
			{
			set MemDuplex($ch) "-"
			} \
		elseif {$n == 2} \
			{
			set MemDuplex($ch) "+"
			} \
		else \
			{
			set MemDuplex($ch) " "
			}

		incr first 16
		incr last 16
		}



	# Parse memory channel mode.
	scan $ImageAddr(MemoryModes) "%x" first

	for {set ch 0} {$ch < 1000} {incr ch} \
		{
		set byte [string range $Mimage $first $first]

		set m [GetBitField $byte 4 5]

		if { [info exists RMode($m)] } \
			{
			set MemMode($ch) $RMode($m)
			} \
		else \
			{
			set MemMode($ch) NFM
			}

		incr first 16
		incr last 16
		}


	# Parse memory channel tone flag.
	scan $ImageAddr(MemoryToneFlag) "%x" first

	for {set ch 0} {$ch < 1000} {incr ch} \
		{
		set byte [string range $Mimage $first $first]

		set m [GetBitField $byte 0 3]
		if { [info exists ToneFlag($m)] } \
			{
			set MemToneFlag($ch) $ToneFlag($m)
			} \
		else \
			{
			set MemToneFlag($ch) "off"
			}

		incr first 16
		incr last 16
		}

	# Parse memory CTCSS tone code.
	scan $ImageAddr(MemoryToneCode) "%x" first

	for {set ch 0} {$ch < 1000} {incr ch} \
		{
		set MemToneCode($ch) "0.0"
		set byte [string range $Mimage $first $first]

		set n [Char2Int $byte]
		# fix me
		incr n $CtcssBias
		if { [info exists RCtcss($n)] } \
			{
			set MemToneCode($ch) $RCtcss($n)
			} \
		else \
			{
			set MemToneCode($ch) "0.0"
			}
		incr first 16
		incr last 16
		}



	# Parse memory DCS tone code.
	scan $ImageAddr(MemoryDToneCode) "%x" first

	for {set ch 0} {$ch < 1000} {incr ch} \
		{
		set MemDToneCode($ch) "0"
		set byte [string range $Mimage $first $first]

		
		if { [GetBitField $byte 0 0] } \
			{
			set MemDTonePolarity($ch) r
			} \
		else \
			{
			set MemDTonePolarity($ch) n
			}

		set n [GetBitField $byte 1 7]

		if { [info exists RDcs($n)] } \
			{
			set MemDToneCode($ch) $RDcs($n)
			} \
		else \
			{
			set MemDToneCode($ch) "023"
			} 

		incr first 16
		incr last 16
		}


	# Parse skip field.
	scan $ImageAddr(MemorySkip) "%x" first

	for {set ch 0} {$ch < 1000} {incr ch} \
		{
		set byte [string range $Mimage $first $first]


		set n [GetBitField $byte 1 2]
		if { [info exists RSkip($n)] } \
			{
			set MemSkip($ch) $RSkip($n)
			} \
		else \
			{
			set MemSkip($ch) " "
			}

		incr first 2
		incr last 2
		}


	# Parse bank letter field.
	scan $ImageAddr(MemoryBankNumber) "%x" first

	for {set ch 0} {$ch < 1000} {incr ch} \
		{
		set byte [string range $Mimage $first $first]
		if { [string compare -nocase -length 1 $byte \xff] == 0}  \
			{
			# hidden memory channel, not programmed
			set MemHide($ch) "hide"
			} \
		else \
			{
			set MemHide($ch) ""
			}

		set n [GetBitField $byte 3 7]
		if {$n == 31} \
			{
			# no bank
			set MemBankLetter($ch) ""
			}

		if { [info exists BankID($n)] } \
			{
			set MemBankLetter($ch) $BankID($n)
			} \
		else \
			{
			set MemBankLetter($ch) ""
			}

		incr first 2
		incr last 2
		}


	# Parse bank memory channel field.
	scan $ImageAddr(MemoryBankCh) "%x" first

	for {set ch 0} {$ch < 1000} {incr ch} \
		{
		set byte [string range $Mimage $first $first]

		if { [string compare -nocase -length 1 $byte \xff] == 0}  \
			{
			# no bank channel
			set MemBankCh($ch) ""
			} \
		else \
			{
			set n [GetBitField $byte 1 7]
			if {$n <= 99} \
				{
				set MemBankCh($ch) $n
				} \
			else \
				{
				# invalid channel
				set MemBankCh($ch) ""
				}

			}

		incr first 2
		incr last 2
		}


	# Parse memory channel step size.
	scan $ImageAddr(MemorySteps) "%x" first

	for {set ch 0} {$ch < 1000} {incr ch} \
		{
		set byte [string range $Mimage $first $first]


		set n [GetBitField $byte 0 3]
		if { [info exists RStep($n)] } \
			{
			set MemStep($ch) $RStep($n)
			} \
		else \
			{
			set MemStep($ch) 5
			}

		incr first 16
		incr last 16
		}



	# Parse label field.
	scan $ImageAddr(MemoryLabels) "%x" first
	set last [expr {$first + 4}]

	for {set ch 0} {$ch < 1000} {incr ch} \
		{
		set s [string range $Mimage $first $last]
		set MemLabel($ch) [Internal2MemoryLabel $s]

		incr first 16
		incr last 16
		}


	# Parse the hide field.
	scan $ImageAddr(MemoryBankNumber) "%x" first

	for {set ch 0} {$ch < 1000} {incr ch} \
		{
		set byte [string range $Mimage $first $first]
		if { [string compare -nocase -length 1 $byte \xff] == 0}  \
			{
			# hidden memory channel, not programmed
			ZapChannel $ch
			set MemHide($ch) "hide"
			} \
		else \
			{
			set MemHide($ch) ""
			}
		incr first 2
		}

	return
}


###################################################################
#
# Parse data from inside the memory image and store it
# in global arrays.
#
###################################################################
proc DecodeTV { } \
{
	global ImageAddr
	global TV
	global Mimage


	# Parse TV channel frequencies.
	scan $ImageAddr(TVFreq) "%x" first
	set last [expr {$first + 2}]

	for {set ch 0} {$ch < 70} {incr ch} \
		{
		set s [string range $Mimage $first $last]

		set f [Internal2TV3 $s]

		if {$f < .001} \
			{
			set TV($ch,freq) ""
			} \
		else \
			{
			set TV($ch,freq) $f
			}
#		puts stderr "tv ch: $ch, f: $f"
		incr first 8
		incr last 8
		}



	# Parse TV channel mode.
	scan $ImageAddr(TVMode) "%x" first

	for {set ch 0} {$ch < 70} {incr ch} \
		{
		set byte [string index $Mimage $first]

		if { [string compare -nocase -length 1 $byte \x01] == 0}  \
			{
			# WFM
			set TV($ch,mode) WFM
			} \
		elseif { [string compare -nocase -length 1 $byte \x02] == 0}  \
			{
			# AM
			set TV($ch,mode) AM
			} \
		else  \
			{
			# Bogus mode
			puts -nonewline stderr "TV channel $ch, "
			puts stderr "unknown mode. Defaulting to WFM."
			set TV($ch,mode) WFM
			}

		incr first 8
		}


	# Parse label field.
	scan $ImageAddr(TVLabel) "%x" first
	set last [expr {$first + 3}]

	for {set ch 0} {$ch < 70} {incr ch} \
		{
		set s [string range $Mimage $first $last]

		# Translate bogus characters to spaces
		regsub -all {[^A-Za-z0-9 .,\+\*/()\-=]} $s " " s

		# Labels must be upper case.
		set s [string toupper $s]
		set TV($ch,label) $s

		incr first 8
		incr last 8
		}


	# Parse hide field.
	scan $ImageAddr(TVHide) "%x" first

	for {set ch 0} {$ch < 70} {incr ch} \
		{
		# fix me
		set TV($ch,hide) 0
		}


	# Parse skip field.
	DecodeSkipTVChannelFlags

	return
}


###################################################################
#
# Parse data from inside the memory image and store it
# in global arrays.
#
###################################################################
proc DecodeBankLabels { } \
{
	global BankLabel
	global GlobalParam
	global Mimage
	global ImageAddr

	# Parse bank names.
	scan $ImageAddr(BankLabels) "%x" first
	set last [expr {$first + 5}]

	for {set bn 0} {$bn < 18} {incr bn}  \
		{
		set s [string range $Mimage $first $last]
		set BankLabel($bn) [Internal2BankLabel $s]

		incr first 6
		incr last 6
		}

	return
}


###################################################################
# Encode the bank labels into a memory image.
###################################################################

proc EncodeBankLabels { image } \
{
	global BankLabel
	global GlobalParam
	global Mimage
	global ImageAddr

	# Bank names.
	scan $ImageAddr(BankLabels) "%x" first
	set last [expr {$first + 5}]

	for {set bn 0} {$bn < 18} {incr bn}  \
		{
		set s [BankLabel2Internal $BankLabel($bn)]

		set image [string replace $image $first $last $s]

		incr first 6
		incr last 6
		}

	return $image
}


###################################################################
#
# Parse data from inside the memory image and store it
# in global arrays.
#
###################################################################
proc DecodeSearchBanks { } \
{
	global LimitScan
	global Mimage
	global ImageAddr
	global RMode
	global RStep



	# Parse search bank lower hidden flag.
	scan $ImageAddr(SearchHideFirst) "%x" first

	for {set bn 0} {$bn < 25} {incr bn} \
		{
		set byte [string range $Mimage $first $first]

		if { [string compare -nocase -length 1 $byte \xff] == 0}  \
			{
			# hidden bank, not programmed
			set LimitScan($bn,lhide) "hide"
			set LimitScan($bn,lower) ""
			} \
		else \
			{
			set LimitScan($bn,lhide) ""
			}
		incr first 4
		}


	# Parse search bank upper hidden flag.
	scan $ImageAddr(SearchHideSecond) "%x" first

	for {set bn 0} {$bn < 25} {incr bn} \
		{
		set byte [string range $Mimage $first $first]

		if { [string compare -nocase -length 1 $byte \xff] == 0}  \
			{
			# hidden bank, not programmed
			set LimitScan($bn,uhide) "hide"
			set LimitScan($bn,upper) ""
			} \
		else \
			{
			set LimitScan($bn,uhide) ""
			}
		incr first 4
		}


	# Parse search bank frequencies.
	scan $ImageAddr(SearchFreqFirst) "%x" first
	set last [expr {$first + 2}]

	for {set bn 0} {$bn < 25} {incr bn}  \
		{
		set s [string range $Mimage $first $last]

		set f [Internal2Freq3 $s]

		if {($LimitScan($bn,lhide) == "hide") \
			|| ($f < .001)} \
			{
			set LimitScan($bn,lower) ""
			} \
		else \
			{
			set LimitScan($bn,lower) $f
			}

		incr first 32
		incr last 32
		}


	# Parse seach bank frequencies.
	scan $ImageAddr(SearchFreqSecond) "%x" first
	set last [expr {$first + 2}]

	for {set bn 0} {$bn < 25} {incr bn}  \
		{
		set s [string range $Mimage $first $last]

		set f [Internal2Freq3 $s]

		if {($LimitScan($bn,uhide) == "hide") \
			|| ($f < .001)} \
			{
			set LimitScan($bn,upper) ""
			} \
		else \
			{
			set LimitScan($bn,upper) $f
			}
		incr first 32
		incr last 32
		}



	# Parse mode.
	scan $ImageAddr(SearchModeFirst) "%x" first

	for {set bn 0} {$bn < 25} {incr bn} \
		{
		set byte [string range $Mimage $first $first]

		set m [GetBitField $byte 4 5]

		if { [info exists RMode($m)] } \
			{
			set LimitScan($bn,lmode) $RMode($m)
			} \
		else \
			{
			set LimitScan($bn,lmode) NFM
			}

		incr first 32
		incr last 32
		}

	scan $ImageAddr(SearchModeSecond) "%x" first

	for {set bn 0} {$bn < 25} {incr bn} \
		{
		set byte [string range $Mimage $first $first]

		set m [GetBitField $byte 4 5]

		if { [info exists RMode($m)] } \
			{
			set LimitScan($bn,umode) $RMode($m)
			} \
		else \
			{
			set LimitScan($bn,umode) NFM
			}

		incr first 32
		incr last 32
		}


	# Parse step size.

	scan $ImageAddr(SearchStepFirst) "%x" first

	for {set bn 0} {$bn < 25} {incr bn} \
		{
		set byte [string range $Mimage $first $first]

		set n [GetBitField $byte 0 3]
		if { [info exists RStep($n)] } \
			{
			set LimitScan($bn,lstep) $RStep($n)
			} \
		else \
			{
			set LimitScan($bn,lstep) 5
			}

		incr first 32
		incr last 32
		}

	scan $ImageAddr(SearchStepSecond) "%x" first

	for {set bn 0} {$bn < 25} {incr bn} \
		{
		set byte [string range $Mimage $first $first]

		set n [GetBitField $byte 0 3]
		if { [info exists RStep($n)] } \
			{
			set LimitScan($bn,ustep) $RStep($n)
			} \
		else \
			{
			set LimitScan($bn,ustep) 5
			}

		incr first 32
		incr last 32
		}



	# Parse lower label.
	scan $ImageAddr(SearchLabelFirst) "%x" first
	set last [expr {$first + 5}]

	for {set bn 0} {$bn < 25} {incr bn}  \
		{
		set s [string range $Mimage $first $last]
		set LimitScan($bn,llabel) [Internal2MemoryLabel $s]

		incr first 32
		incr last 32
		}




	# Parse upper label.
	scan $ImageAddr(SearchLabelSecond) "%x" first
	set last [expr {$first + 5}]

	for {set bn 0} {$bn < 25} {incr bn}  \
		{
		set s [string range $Mimage $first $last]
		set LimitScan($bn,ulabel) [Internal2MemoryLabel $s]

		incr first 32
		incr last 32
		}



	return
}


###################################################################
# Decode a 3 byte BCD frequency.
#
# Returns:	frequency in MHz
###################################################################

proc BCD2Freq3 { s } \
{
	global GlobalParam
	

	# Note: Icom packs two digits per byte, one per nibble.
	# An important exception is the most significant nibble
	# in the most significant byte.  That nibble can be
	# 0-9 or a-f.
	# a-f means 10-15.


	# set abuf ""
	# append abuf [DumpBinary $s]
	# puts stderr "s: $abuf"

	if {[string length $s] == 0} \
		{
		return "0.0000"
		}

	binary scan $s "H6" as
	if {$GlobalParam(WhichModel) == 9} \
		{
		if { $as == "ffffff" } {return "0.0000"} \
		else \
			{
			set rc [regexp {ffff$} $as]
			if {$rc} \
				{
				# The last 2 bytes are ff
				# which means
				# 9 kHz spacing and 
				# freqency is .495 - 1.620 MHz

				# Multiply value in first byte
				# by .009 and add it to .495

				set b [string index $s 0]
				binary scan $b "H2" imult
				scan $imult "%x" mult
				set f [expr {($mult * .009) + .495}]
				set f [format "%.4f" $f]
				return $f
				}
			}
		}


	# Frequency digit pairs.

	set i 0

	set f1 [string index $s $i]
	binary scan $f1 "H2" f1
	regsub -nocase {a} $f1 10 f1
	regsub -nocase {b} $f1 11 f1
	regsub -nocase {c} $f1 12 f1
	regsub -nocase {d} $f1 13 f1
	regsub -nocase {e} $f1 14 f1
	regsub -nocase {f} $f1 15 f1
	incr i

	set f2 [string index $s $i]
	binary scan $f2 "H2" f2
	incr i

	set f3 [string index $s $i]
	binary scan $f3 "H2" f3
	incr i


	set f [format "%s%s%s" $f1 $f2 $f3]
	set f [string trimleft $f 0]

	if { $f == ""} \
		{
		set f "00000000"
		}

	# Check for non-digit chars.
	set rc [regexp {^[0-9]*$} $f]
	if {$rc == 0} then {set f "00000000"}

	set f [expr {$f/1000.0}]
	set f [ format "%.4f" $f]

	if {($GlobalParam(WhichModel) == 9) \
		&& ($f >= .495) && ($f <= 1.620)} \
		{
		return [format "%.5f" $f]
		}

	set len [string length $f]
	set j [expr {$len - 2}]

	set c [string index $f $j]
	if {($c == "2") || ($c == "7")} \
		{
		# If the kHz position digit is a 2 or 5,
		# force the last digit to be 5.
		set f [string replace $f end end 5]
		} \
	elseif {($c == "1") || ($c == "6")} \
		{
		# If the kHz position digit is a 1 or 6,
		# force the last digit to be 2.
		set f [string replace $f end end 2]
		} \
	elseif {($c == "3") || ($c == "8")} \
		{
		# If the kHz position digit is a 3 or 8,
		# force the last digit to be 7.
		set f [string replace $f end end 7]
		}
	return [format "%.5f" $f]
}


###################################################################
# Decode a 3 byte internally-represented frequency.
#
# Returns:	frequency in MHz
###################################################################

proc Internal2Freq3 { s } \
{
	global GlobalParam
	global RIstep
	
	# set abuf [DumpBinary $s]
	# puts stderr "s: $abuf"

	if {[string length $s] == 0} \
		{
		return "0.0000"
		}

	set b0 [string index $s 0]
	set b1 [string index $s 1]
	set b2 [string index $s 2]

	set n0 [Char2Int $b0]
	set n1 [Char2Int $b1]

	set n2 [GetBitField $b2 6 7]
	set nstep [GetBitField $b2 2 3]
	if { [info exists RIstep($nstep)] } \
		{
		set step [expr {$RIstep($nstep) / 1000.0}]
		} \
	else \
		{
		puts stderr "invalid step $nstep"
		exit
		}

	set step $RIstep($nstep)

	set mult [expr { ($n2 * 256 * 256) + ($n1 * 256) + $n0}]
	

	set freq [ expr { $mult * $step/ 1000.0 } ]
	# puts stderr "nstep: $nstep, mult: $mult, freq: $freq"

	set f $freq
	return [format "%.5f" $f]
}


###################################################################
# Decode a 3 byte internally-represented TV channel frequency.
#
# Returns:	frequency in MHz
###################################################################

proc Internal2TV3 { s } \
{
	global GlobalParam
	
	# set abuf [DumpBinary $s]
	# puts stderr "s: $abuf"

	if {[string length $s] == 0} \
		{
		return "0.0000"
		}

	set b0 [string index $s 0]
	set b1 [string index $s 1]
	set b2 [string index $s 2]

	set n0 [Char2Int $b0]
	set n1 [Char2Int $b1]
	set n2 [Char2Int $b2]

	set mult [expr { ($n2 * 256 * 256) + ($n1 * 256) + $n0}]
	
	set freq [ expr { $mult * 5/ 1000.0 } ]

	set f $freq
	return [format "%.3f" $f]
}


###################################################################
# Encode a frequency into a 3 byte internally-represented TV frequency.
#
# Returns:	3-byte string
###################################################################

proc TV2Internal3 { f } \
{
	global GlobalParam
	
	if { ($f <= .0) } \
		{
		set bytes [binary format "H2H2H2" 00 00 00]
		return $bytes
		}

	# Convert frequency to kHz, then divide by 5
	# because it is the number of 5 kHz steps.
	set nf [expr {$f * 200}]
	set nf [expr {int($nf)}]

	# The most significant bits go in the final byte.
	set n2 [expr {$nf / (256 * 256)}]
	set n2 [expr {int($n2)}]


	# The least significant bits go in the first byte.
	set tmp [expr {$nf / (256)}]
	set tmp [expr {int($tmp)}]
	set tmp [expr {256 * $tmp}]
	set n0 [expr {$nf - $tmp}]

	# The most middle bits go in the middle byte.
	set tmp [expr {($n2 * 256 * 256) + $n0}]
	set n1 [expr {($nf - $tmp)/256}]
	set n1 [expr {int($n1)}]

	set h0 [format "%02x" $n0]
	set h1 [format "%02x" $n1]
	set h2 [format "%02x" $n2]

	set bytes [binary format "H2H2H2" $h0 $h1 $h2]

	# set buf [DumpBinary $bytes]
	# puts stderr "TV2Internal3: f: $f, bytes: $buf"

	return $bytes
}


###################################################################
# Decode an internally-represented offset.
#
# Inputs;
#		s - a 2-byte string
#		m - a 1-byte string which contains the multiplier
#			coded in the two most significant bits
#
# Returns:	frequency in MHz
###################################################################

proc Offset2Freq { s m } \
{
	global GlobalParam
	global RIstep
	

	set sbuf [DumpBinary $s]
	set mbuf [DumpBinary $m]

	if { ($s == 0) || ($m == "") } \
		{
		return "0.0000"
		}

	set b0 [string index $s 0]
	set b1 [string index $s 1]

	set n0 [Char2Int $b0]
	set n1 [Char2Int $b1]

	set nstep [GetBitField $m 0 1]
	if { [info exists RIstep($nstep)] } \
		{
		set step [expr {$RIstep($nstep) / 1000.0}]
		} \
	else \
		{
		puts stderr "invalid step $nstep"
		exit
		}

	set step $RIstep($nstep)

	set mult [expr { ($n1 * 256) + $n0}]
	

	set freq [ expr { $mult * $step/ 1000.0 } ]
	# puts stderr "nstep: $nstep, mult: $mult, freq: $freq"

	set f [format "%.5f" $freq]
	# puts stderr "s: $sbuf, m: $mbuf, freq: $f"
	return $f
}



###################################################################
# Encode a frequency into a 2 byte internally-represented value.
# This is used for encoding duplex offset values, which consist
# of a 2-byte number and a multiplier.
#
# Inputs:
#	f	-frequency between 0 and 159.995 MHz
#	step	-step size in kHz
#
# Returns:
#	a 2-element list, consisting of:
#		a 2-byte binary string
#		a multiplier value
###################################################################

proc Freq2Offset { f step } \
{
	global GlobalParam
	global Istep
	global Wstep

	# puts stderr "Freq2Offset: f: $f, step: $step"
	if {($f  == "") \
		|| ($f < 0) \
		|| ($f > 159.995) } \
		{
		# Frequency is out of range or null.
		# puts stderr "Frequency $f not a valid offset."
		set fbytes [binary format "H2H2" 00 00]
		return [list $fbytes 0]
		} 

	if { [info exists Wstep($step)] } \
		{
		# determine the internal step
		set ns $Istep($Wstep($step))

		set khz [expr {$f * 1000}]
		set m [expr {$khz / $Wstep($step)}]

		# mid significant 8 bits
		set midbits [ expr {fmod($m,65536)}]
		set midbits [ expr {int($midbits/256)}]

		# least significant 8 bits
		set lsbits [ expr {fmod($m,256)}]
		set lsbits [ expr {int($lsbits)}]

		set s [format "%02x" $midbits]
		set b1 [binary format "H2" $s]

		set s [format "%02x" $lsbits]
		set b0 [binary format "H2" $s]

		set fbytes $b0
		append fbytes $b1

		# set abuf [DumpBinary $fbytes]
		# puts stderr "f: $f, step: $step, ns: $ns, m: $m, fbytes: $abuf"

		return [list $fbytes $ns]
		} \
	else \
		{
		# Undefined step value
		puts stderr "Undefined step value $step, frequency $f"
		# set fbytes [binary format "H2H2H2" 00 00 00]

		set fbytes [binary format "H2H2" 00 00]
		return [list $fbytes 0]
		}
}

###################################################################
# Encode a frequency into a 3 byte internally-represented value.
#
# Returns:	a 3-byte string
###################################################################

proc Freq2Internal3 { f step } \
{
	global GlobalParam
	global Istep
	global Wstep

	# puts stderr "Freq2Internal3: f: $f, step: $step"
	if {($f  == "") \
		|| ($f < $GlobalParam(LowestFreq)) \
		|| ($f > $GlobalParam(HighestFreq)) } \
		{
		# Frequency is out of range
		set fbytes [binary format "H2H2H2" 00 00 00]
		return $fbytes
		} 

	if { [info exists Wstep($step)] } \
		{
		# determine the internal step
		set ns $Istep($Wstep($step))

		# Add 1 to prevent rounding error.
		set khz [expr {($f * 1000) + 1}]
		set m [expr {$khz / $Wstep($step)}]

		# most significant 2 bits
		set msbits [expr {($m / 256) / 256}]
		set msbits [expr {int($msbits)}]

		# mid significant 8 bits
		set midbits [ expr {fmod($m,65536)}]
		set midbits [ expr {int($midbits/256)}]

		# least significant 8 bits
		set lsbits [ expr {fmod($m,256)}]
		set lsbits [ expr {int($lsbits)}]

		set b2 [binary format "H2" 00]
		set b2 [SetBitField $b2 2 3 $ns]
		set b2 [SetBitField $b2 6 7 $msbits]

		set s [format "%02x" $midbits]
		set b1 [binary format "H2" $s]

		set s [format "%02x" $lsbits]
		set b0 [binary format "H2" $s]

		set fbytes $b0
		append fbytes $b1
		append fbytes $b2

		set abuf [DumpBinary $fbytes]
		# puts stderr "f: $f, step: $step, ns: $ns, fbytes: $abuf"

		return $fbytes
		} \
	else \
		{
		# Undefined step value
		set fbytes [binary format "H2H2H2" 00 00 00]
		return $fbytes
		}
}


###################################################################
# Decode a 2-1/2 byte BCD frequency offset.
#
# Returns:	frequency in MHz
###################################################################

proc BCD2Offset { s } \
{
	global GlobalParam
	

	# Note: ICOM packs two digits per byte, one per nibble.
	# An important exception is the least significant nibble
	# in the most significant byte.  That nibble can be
	# 0-9 or a-f.
	# a-f means 10-15.

	# Frequency digit pairs.

	set i 0

	set f1 [string index $s $i]

	# Extract right nibble of most significant byte.
	set f1 [GetBitField $f1 4 7]
	incr i

	set f2 [string index $s $i]
	binary scan $f2 "H2" f2
	incr i

	set f3 [string index $s $i]
	binary scan $f3 "H2" f3
	incr i


	set f [format "%d%s%s" $f1 $f2 $f3]
	set f [string trimleft $f 0]

	if { $f == ""} \
		{
		set f "00000000"
		}

	# Check for non-digit chars.
	set rc [regexp {^[0-9]*$} $f]
	if {$rc == 0} then {set f "00000000"}

	set f [expr {$f/1000.0}]
	set f [ format "%.3f" $f]
	return $f
}



###################################################################
# Create widgets for the name of this program.
###################################################################
proc MakeTitleFrame { f }\
{
	global DisplayFontSize 
	global Version

	frame $f -relief flat -borderwidth 3

	# set s [format "tk5 v%s" $Version]
	set s [format "tk5"]

	label $f.lab -text $s \
		-background blue \
		-foreground white \
		-relief raised \
		-borderwidth 3 \
		-font $DisplayFontSize 

	set s ""
	append s [format "Version %s\n" $Version]
	append s "Experimental Utility\n"
	append s "for the ICOM IC-R5 Receiver\n"
	append s "Copyright 2004, Bob Parnass"

	label $f.use -text $s \
		-background black \
		-foreground white \
		-relief raised \
		-borderwidth 3

	pack $f.lab $f.use -side top -padx 0 -pady 0 \
		-fill y -fill x -expand true

	return $f
}


###################################################################
# Create frame for display parameters. 
###################################################################
proc MakeDisplayFrame { f }\
{

	frame $f -relief groove -borderwidth 3
	label $f.lab -text "Display, Keypad Settings" \
		-borderwidth 3
	pack $f.lab -side top

	frame $f.b -relief flat -borderwidth 3
	MakeDispWidgets  $f.b
	pack $f.b -side top -expand true -fill both

	return $f
}

proc MakeDispWidgets {f} \
{
	global GlobalParam


        label $f.lmonitor -text "Monitor key" -borderwidth 3
	tk_optionMenu $f.monitor GlobalParam(Monitor) PUSH HOLD


        label $f.llockeffect -text "Key lock effect" -borderwidth 3
	tk_optionMenu $f.lockeffect GlobalParam(LockEffect) \
		NORMAL NO_SQL NO_VOL ALL



        label $f.lcontrast -text "Display contrast" -borderwidth 3
	tk_optionMenu $f.contrast GlobalParam(Contrast) \
		1 2 3 4


        label $f.llamp -text "Lamp" -borderwidth 3
	tk_optionMenu $f.lamp GlobalParam(Lamp) OFF ON AUTO


	checkbutton $f.beep -text "Confirmation beep" \
		-variable GlobalParam(Beep) \
		-onvalue 1 -offvalue 0



	grid $f.lmonitor -row 10 -column 0 -sticky w
	grid $f.monitor -row 10 -column 1 -sticky e

	grid $f.llockeffect -row 20 -column 0 -sticky w
	grid $f.lockeffect -row 20 -column 1 -sticky e


	grid $f.lcontrast -row 25 -column 0 -sticky w
	grid $f.contrast -row 25 -column 1 -sticky e


	grid $f.llamp -row 30 -column 0 -sticky w
	grid $f.lamp -row 30 -column 1 -sticky e

	grid $f.beep -row 40 -column 0 -sticky w -columnspan 2

	return

}

###################################################################
# Create frame for memory bank labels. 
###################################################################

proc MakeBankLabelsFrame { f } \
{
	global GlobalParam

	frame $f -relief groove -borderwidth 3

	ScrollformCreate $f.b
	pack $f.b -expand yes -fill both

	set w [ScrollFormInterior $f.b]


	label $w.ltitle -text "Memory Banks" -borderwidth 3
	label $w.lbank -text "Bank" -borderwidth 3
	label $w.lname -text "Label" -borderwidth 3

	for {set i 0} {$i < 18} {incr i} \
		{
		MakeBankLabel $w $i
		}

	set c 1
	grid $w.ltitle -row 0 -column 1 -columnspan 2
	grid $w.lbank -row 1 -column $c ; incr c
	grid $w.lname -row 1 -column $c ; incr c


	set hint ""
	append hint "You may create memory bank labels "
	append hint "up to $GlobalParam(LabelLength) "
	append hint "characters long. "
	balloonhelp_for $f $hint



	pack $f.b -side top -fill both -expand true -padx 3 -pady 3

	return $f
}

###################################################################
# Create one a set of widgets for one memory bank. 
###################################################################
proc MakeBankLabel { f bn } \
{
	global BankID
	global BankLabel
	global GlobalParam


	if {[info exists BankID($bn)]} \
		{
		set bid "$BankID($bn)"
		} \
	else \
		{
		set bid $bn
		} 

	label $f.id$bn -text "$bid" -borderwidth 3

	entry $f.label$bn -width 10 \
		-textvariable BankLabel($bn) \
		-background white 


	set row [expr {$bn + 2}]

	set c 1
	grid $f.id$bn -row $row -column $c ; incr c
	grid $f.label$bn -row $row -column $c ; incr c 

	return $f
}


###################################################################
# Create 25 search banks. 
###################################################################
proc MakeSearchFrame { f }\
{
	global GlobalParam


	frame $f -relief groove -borderwidth 3

	frame $f.rb -relief groove -borderwidth 3
	set r $f.rb


        label $r.ldial -text "Fast dial step" -borderwidth 3
	tk_optionMenu $r.dial GlobalParam(Dial) 100kHz 1MHz 10MHz

	# checkbutton $r.dialaccel -text "Dial acceleration" 
	checkbutton $r.dialaccel -text "" \
		-variable GlobalParam(DialAccel) \
		-onvalue 1 -offvalue 0

        label $r.ldialaccel -text "Dial acceleration" -borderwidth 3

        label $r.lvfosearch -text "VFO Search" -borderwidth 3
	$r.lvfosearch configure -foreground yellow

	tk_optionMenu $r.vfosearch GlobalParam(VFOSearch) \
		BAND ALL \
		PROG0 PROG1 PROG2 PROG3 PROG4 PROG5 \
		PROG6 PROG7 PROG8 PROG9 \
		PROG10 PROG11 PROG12 PROG13 PROG14 PROG15 \
		PROG16 PROG17 PROG18 PROG19 \
		PROG20 PROG21 PROG22 PROG23 PROG24

	grid $r.ldial -row 8 -column 1 -sticky w
	grid $r.dial -row 8 -column 2 -sticky ew
	grid $r.ldialaccel -row 12 -column 1 -sticky w
	grid $r.dialaccel -row 12 -column 2 -sticky e

	# pack $r.lvfosearch $r.vfosearch -side left
	pack $r -side top -padx 3 -pady 3

	label $f.lab -text "\nLimit Search Banks" -borderwidth 3
	pack $f.lab -side top -padx 3 -pady 3


	ScrollformCreate $f.b
	pack $f.b -expand yes -fill both

	set w [ScrollFormInterior $f.b]


	label $w.lowerf -text "Lower Freq" -borderwidth 3
	label $w.lowerm -text "Mode" -borderwidth 3
	label $w.lowers -text "Step" -borderwidth 3
	label $w.lowerl -text "Label" -borderwidth 3
	label $w.divider -text "" -borderwidth 3

	label $w.upperf -text "Upper Freq" -borderwidth 3
	label $w.upperm -text "Mode" -borderwidth 3
	label $w.uppers -text "Step" -borderwidth 3
	label $w.upperl -text "Label" -borderwidth 3

	for {set i 0} {$i < 25} {incr i} \
		{
		MakeSearchBank $w $i
		}

	set c 1
	grid $w.lowerf -row 1 -column $c ; incr c
	grid $w.lowerm -row 1 -column $c ; incr c
	grid $w.lowers -row 1 -column $c ; incr c
	grid $w.lowerl -row 1 -column $c ; incr c
	grid $w.divider -row 1 -column $c ; incr c
	grid $w.upperf -row 1 -column $c ; incr c
	grid $w.upperm -row 1 -column $c ; incr c
	grid $w.uppers -row 1 -column $c ; incr c
	grid $w.upperl -row 1 -column $c ; incr c

	pack $f.b -side top -fill both -expand true -padx 3 -pady 3

	return $f
}



###################################################################
# Create one a set of widgets for one search bank. 
###################################################################
proc MakeSearchBank { f bn }\
{
	global LimitScan
	global GlobalParam

	label $f.lab$bn -text "PROG$bn" -borderwidth 3

	entry $f.lower$bn -width 10 \
		-textvariable LimitScan($bn,lower) \
		-background white 

	tk_optionMenu $f.lmodemenu$bn LimitScan($bn,lmode) \
		NFM WFM AM

	tk_optionMenu $f.lstep$bn LimitScan($bn,lstep) \
		5 6.25 8.33 9 10 12.5 15 20 25 30 50 100


	entry $f.lowerlabel$bn -width 10 \
		-textvariable LimitScan($bn,llabel) \
		-background white 


	set hint ""
	append hint "Limit Search labels are saved by the software, "
	append hint "but are not actually used by the radio. "
	balloonhelp_for $f.lowerlabel$bn $hint

	label $f.divider$bn -text " ---- " -borderwidth 3


	entry $f.upper$bn -width 10 \
		-textvariable LimitScan($bn,upper) \
		-background white 

	tk_optionMenu $f.umodemenu$bn LimitScan($bn,umode) \
		NFM WFM AM

	tk_optionMenu $f.ustep$bn LimitScan($bn,ustep) \
		5 6.25 8.33 9 10 12.5 15 20 25 30 50 100

	entry $f.upperlabel$bn -width 10 \
		-textvariable LimitScan($bn,ulabel) \
		-background white 

	set hint ""
	append hint "Limit Search labels are saved by the software, "
	append hint "but are not actually used by the radio. "
	balloonhelp_for $f.upperlabel$bn $hint

	set row [expr {$bn + 2}]

	set c 0
	grid $f.lab$bn -row $row -column $c ; incr c
	grid $f.lower$bn -row $row -column $c ; incr c 
	grid $f.lmodemenu$bn -row $row -column $c -sticky ew ; incr c
	grid $f.lstep$bn -row $row -column $c -sticky ew ; incr c
	grid $f.lowerlabel$bn -row $row -column $c -sticky ew ; incr c
	grid $f.divider$bn -row $row -column $c ; incr c
	grid $f.upper$bn -row $row -column $c ; incr c
	grid $f.umodemenu$bn -row $row -column $c -sticky ew ; incr c
	grid $f.ustep$bn -row $row -column $c -sticky ew ; incr c
	grid $f.upperlabel$bn -row $row -column $c -sticky ew ; incr c

	return $f
}



###################################################################
# Create frame for misc parameters. 
###################################################################
proc MakeMiscFrame { f }\
{

	frame $f -relief groove -borderwidth 3
	label $f.lab -text "Misc. Settings" \
		-borderwidth 3
	pack $f.lab -side top

	frame $f.b -relief flat -borderwidth 3
	MakeMiscWidgets  $f.b
	pack $f.b -side top -expand true -fill both

	return $f
}


###################################################################
# Create widgets for misc. parameters. 
###################################################################
proc MakeMiscWidgets { f } \
{
	global GlobalParam
	global Priority
	global PriorityMode



        label $f.lamantenna -text "AM broadcast antenna" -borderwidth 3
	tk_optionMenu $f.amantenna GlobalParam(AMantenna) \
		EXT INTERNAL_BAR

        label $f.lfmantenna -text "FM broadcast antenna" -borderwidth 3
	tk_optionMenu $f.fmantenna GlobalParam(FMantenna) EXT EARPHONE

	checkbutton $f.battery -text "Power save" \
		-variable GlobalParam(PowerSave) \
		-onvalue 1 -offvalue 0


        label $f.lautooff -text "Auto power off (min.)" -borderwidth 3
        tk_optionMenu $f.autooff GlobalParam(AutoOff) \
                OFF 30 60 90 120

	label $f.lpause -text "Scan pause (sec.)" -borderwidth 3
        tk_optionMenu $f.pause GlobalParam(Pause) \
                2 4 6 8 10 12 14 16 18 20 HOLD


	set hint ""
	append hint "When receiving signals, "
	append hint "the radio will stop scanning "
	append hint "to let you hear the transmission for the "
	append hint "length of time determined by the Scan Pause "
	append hint "value. "
	balloonhelp_for $f.lpause $hint
	balloonhelp_for $f.pause $hint


        label $f.labresume -text "Scan resume (sec.)" -borderwidth 3
        tk_optionMenu $f.resume GlobalParam(Resume) \
                0 1 2 3 4 5 HOLD


	set hint ""
	append hint "After a transmission ends, the radio waits "
	append hint "a brief period before resuming the scan. "
	balloonhelp_for $f.labresume $hint
	balloonhelp_for $f.resume $hint


#	checkbutton $f.atten -text "Attenuator" \
#		-variable GlobalParam(Attenuator) \
#		-onvalue 1 -offvalue 0

	checkbutton $f.scanstopbeep -text "Scan stop beep" \
		-variable GlobalParam(ScanStopBeep) \
		-onvalue 1 -offvalue 0

	checkbutton $f.expanded -text "Expanded set mode" \
		-variable GlobalParam(ExpandedSetMode) \
		-onvalue 1 -offvalue 0

#	$f.atten configure -foreground yellow

	grid $f.lamantenna  -row 10 -column 0 -sticky w
	grid $f.amantenna -row 10 -column 1 -sticky ew

	grid $f.lfmantenna  -row 20 -column 0 -sticky w
	grid $f.fmantenna -row 20 -column 1 -sticky ew

        grid $f.battery -row 30 -column 0 -sticky w -columnspan 2

	grid $f.lautooff  -row 40 -column 0 -sticky w
	grid $f.autooff -row 40 -column 1 -sticky ew

	grid $f.lpause  -row 50 -column 0 -sticky w
	grid $f.pause -row 50 -column 1 -sticky ew

	grid $f.labresume  -row 60 -column 0 -sticky w
	grid $f.resume -row 60 -column 1 -sticky ew

#       grid $f.atten  -row 12 -column 0 -sticky w -columnspan 2

	grid $f.scanstopbeep  -row 80 -column 0 -sticky w -columnspan 2
	grid $f.expanded  -row 90 -column 0 -sticky w -columnspan 2

	return $f
}


###################################################################
# Create frame for Communications parameters. 
###################################################################
proc MakeCommFrame { f }\
{

	frame $f -relief groove -borderwidth 3
	label $f.lab -text "Debugging Information" \
		-borderwidth 3
	pack $f.lab -side top

	frame $f.b -relief flat -borderwidth 3
	MakeCommWidgets  $f.b

	set hint ""
	append hint "Serial Communications fields "
	append hint "are useful for testing tk5. "
	balloonhelp_for $f $hint


	pack $f.b -side top -expand true -fill y

	return $f
}


###################################################################
# Create widgets for Communications params. 
###################################################################
proc MakeCommWidgets { f } \
{
	global GlobalParam

	label $f.labpre -text "Radio Version" -borderwidth 3
	entry $f.pre -width 26 \
		-textvariable GlobalParam(RadioVersion) \
		-background yellow 

	label $f.lfileversion -text "File Version" -borderwidth 3
	entry $f.fileversion -width 26 \
		-textvariable GlobalParam(FileVersion) \
		-background yellow 

	label $f.lusercomment -text "User comment" -borderwidth 3
	entry $f.usercomment -width 26 \
		-textvariable GlobalParam(UserComment) \
		-background yellow 



	label $f.labnmsgs -text "Number Messages Read" -borderwidth 3
	entry $f.nmsgs -width 5 \
		-textvariable GlobalParam(NmsgsRead) \
		-background yellow 

	checkbutton $f.bypassall -text "Bypass All Encoding" \
		-variable GlobalParam(BypassAllEncoding) \
		-onvalue 1 -offvalue 0



	grid $f.labpre  -row 0 -column 0 -sticky w
	grid $f.pre	-row 0 -column 1 -sticky e

	grid $f.lfileversion  -row 4 -column 0 -sticky w
	grid $f.fileversion	-row 4 -column 1 -sticky e

	grid $f.lusercomment  -row 8 -column 0 -sticky w
	grid $f.usercomment	-row 8 -column 1 -sticky e

	grid $f.labnmsgs -row 12 -column 0 -sticky w
	grid $f.nmsgs	-row 12 -column 1 -sticky e
	grid $f.bypassall	-row 16 -column 0 -columnspan 2

	return $f
}



###################################################################
# Create TV channel frequencies.
###################################################################
proc MakeTVFrame { f }\
{
	global GlobalParam

	frame $f -relief groove -borderwidth 3

	ScrollformCreate $f.b
	pack $f.b -expand yes -fill both
	set w [ScrollFormInterior $f.b]

	set msg1 "TV Channels\n(1999.995 MHz max)"
	label $w.msg1 -text $msg1 -borderwidth 3

	label $w.ln -text "" -borderwidth 3
	label $w.lfreq -text "Freq" -borderwidth 3
	label $w.lmode -text "Mode" -borderwidth 3
	label $w.llabel -text "Label" -borderwidth 3


	for {set i 0} {$i < 70} {incr i} \
		{
		MakeTVChan $w $i
		}

	set r 1

	grid $w.msg1 -row $r -column 1 -columnspan 5

	incr r
	grid $w.ln -row $r -column 1
	grid $w.lfreq -row $r -column 2
	grid $w.lmode -row $r -column 3
	grid $w.llabel -row $r -column 4


	set hint ""
	append hint "TV channel notes:\n\n"
	append hint "- TV channel frequencies must be multiples "
	append hint "of 5 kHz.\n\n"
	append hint "- North American TV channels are WFM mode.\n\n"
	append hint "- TV channel labels are 4 characters or less.\n\n"
	append hint "- Select Skip for channels you want "
	append hint "to ignore. "
	append hint "(To access skipped TV channels when using the "
	append hint "the radio, press and hold the FUNC key while "
	append hint "rotating the selector knob.)"
	balloonhelp_for $f $hint

	return $f
}



###################################################################
# Create one a set of widgets for tv channel freq. 
###################################################################
proc MakeTVChan { f bn }\
{
	global TV
	global GlobalParam

	set j $bn
	incr j

	label $f.lab$bn -text "$j" -borderwidth 3

	entry $f.f$bn -width 10 \
		-textvariable TV($bn,freq) -background white 

	tk_optionMenu $f.modemenu$bn TV($bn,mode) \
		WFM AM

	entry $f.label$bn -width 10 \
		-textvariable TV($bn,label) -background white 

#	checkbutton $f.hide$bn -text "Hide" \
#		-variable TV($bn,hide) \
#		-onvalue 1 -offvalue 0

	checkbutton $f.skip$bn -text "Skip" \
		-variable TV($bn,skip) \
		-onvalue 1 -offvalue 0

	set r [expr {$bn + 5}]
	grid $f.lab$bn -row $r -column 1
	grid $f.f$bn -row $r -column 2
	grid $f.modemenu$bn -row $r -column 3
	grid $f.label$bn -row $r -column 4
#	grid $f.hide$bn -row $r -column 5
	grid $f.skip$bn -row $r -column 6

	return $f
}


###################################################################
# Encode the information from the data structures into
# the memory image string which can be written to the radio.
#
# We don't understand the meaning of all the bytes in
# the memory image.  Therefore, the
# image string must already exist and we will only
# change the bytes which we understand.
#
###################################################################
proc EncodeImage { } \
{
	global GlobalParam
	global Mimage

	if {$GlobalParam(BypassAllEncoding)} \
		{
		puts stderr "EncodeImage: skip encoding"
		return 0
		}

	# puts stderr "EncodeImage: encoding"
	if { ([info exists Mimage] == 0) } \
		{
		puts stderr "EncodeImage: image does not exist"
		return error
		}

	set image $Mimage

	set image [EncodeMisc $image]
	if { [string length $image] == 0} {return error}

	set image [EncodeMemories $image]
	if { [string length $image] == 0} {return error}

	set image [EncodeBankLabels $image]
	if { [string length $image] == 0} {return error}

	set image [EncodeSearchBanks $image]
	if { [string length $image] == 0} {return error}

	set image [EncodeTV $image]
	if { [string length $image] == 0} {return error}

	set Mimage $image

	return 0
}



###################################################################
# Encode misc
# information into a memory image.
###################################################################
proc EncodeMisc { image } \
{
	global AMant
	global AutoOff
	global BatterySaver
	global Dial
	global FMant
	global Fstep
	global ImageAddr
	global GlobalParam
	global Lamp
	global LockEffect
	global Mimage
	global Mode
	global Monitor
	global Pause
	global Priority
	global PriorityMode
	global Resume
	global Step


#	# Priority frequency and mode.
#
#	set s [FreqMode2BCD $Priority $PriorityMode ""]
#
#	scan $ImageAddr(Priority) "%x" first
#	set last [expr {$first + 3}]
#	set image [string replace $image $first $last $s]
#
#
#	# VFO frequency
#
#	set s [Freq2BCD3p $GlobalParam(VFOFreq)]
#	scan $ImageAddr(VFOFreq) "%x" first
#	set last [expr {$first + 3}]
#	set image [string replace $image $first $last $s]
#
#	# VFO mode.
#	scan $ImageAddr(VFOMode) "%x" first
#	set last $first
#
#	set m $GlobalParam(VFOMode)
#	if { [info exists Mode($m)] } \
#		{
#		set c $Mode($m)
#		} \
#	else \
#		{
#		set c $Mode(NFM)
#		}
#
#	set s [format "%02x" $c]
#	set b [binary format "H2" $s]
#	set image [string replace $image $first $first $b]
#
#
#	# Set Attenuator bit
#	scan $ImageAddr(FlagByte3) "%x" first
#	set byte [string index $image $first]
#	set newbyte [AssignBit $byte 5 $GlobalParam(Attenuator)]
#	set image [string replace $image $first $first $newbyte]
#
#
#	# Set Keypad Lock bit
#	scan $ImageAddr(FlagByte3) "%x" first
#	set byte [string index $image $first]
#	set newbyte [AssignBit $byte 1 $GlobalParam(Lock)]
#	set image [string replace $image $first $first $newbyte]
#



	# encode Lock function effect
	scan $ImageAddr(LockEffect) "%x" first
	set byte [string index $image $first]
	set n [format "%02x" $LockEffect($GlobalParam(LockEffect))]
	set newbyte [binary format "H2" $n]
	set image [string replace $image $first $first $newbyte]


	# encode Scan Resume.
	# Scan Resume is stored in one hex byte as one
	# less than what the user sees on the radio's display.
	# Example: Resume of 12 seconds is stored as 0B.



	# encode Scan stop beep flag
	scan $ImageAddr(ScanStopBeep) "%x" first
	set s [format "%02x" $GlobalParam(ScanStopBeep)]
	set b [binary format "H2" $s]
	set image [string replace $image $first $first $b]

	# encode Expanded Set Mode Flag
	scan $ImageAddr(ExpandedSetModeFlag) "%x" first
	set s [format "%02x" $GlobalParam(ExpandedSetMode)]
	set b [binary format "H2" $s]
	set image [string replace $image $first $first $b]

	# encode Dial Acceleration
	scan $ImageAddr(DialAccel) "%x" first
	set s [format "%02x" $GlobalParam(DialAccel)]
	set b [binary format "H2" $s]
	set image [string replace $image $first $first $b]

	# encode Power Saver
	scan $ImageAddr(PowerSave) "%x" first
	set s [format "%02x" $GlobalParam(PowerSave)]
	set b [binary format "H2" $s]
	set image [string replace $image $first $first $b]


#	# Tuning Step is stored in one byte.
#	# Important note:
#	# There is a correlation between the Tuning Step byte
#	# and bit 7 of FlagByte3.
#	# Bit 7 = 0 if step is AUTO,
#	# othewise Bit 7 = 1.
#
#	scan $ImageAddr(VFOStep) "%x" first
#	set c $GlobalParam(TuningStep)
#	# Translate to hex equivalent
#	set c $Step($c)
#	set b [binary format "H2" $c]
#	set image [string replace $image $first $first $b]
#
#	scan $ImageAddr(FlagByte3) "%x" first
#	set b [string range $image $first $first]
#	if {$GlobalParam(TuningStep) == "AUTO"} \
#		{
#		set b [ClearBit $b 7]
#		} \
#	else \
#		{
#		set b [SetBit $b 7]
#		}
#	set image [string replace $image $first $first $b]
#
#	# Bank scan flag
#	scan $ImageAddr(FlagByte0) "%x" first
#	set b [string range $image $first $first]
#	set b [AssignBit $b 4 $GlobalParam(BankScan)]
#	set image [string replace $image $first $first $b]



	# encode AM broadcast antenna
	scan $ImageAddr(AMantenna) "%x" first
	set c $GlobalParam(AMantenna)
	# Translate to hex equivalent
	set c [format "%02x" $AMant($c)]
	set b [binary format "H2" $c]
	set image [string replace $image $first $first $b]


	# encode FM broadcast antenna
	scan $ImageAddr(FMantenna) "%x" first
	set c $GlobalParam(FMantenna)
	# Translate to hex equivalent
	set c [format "%02x" $FMant($c)]
	set b [binary format "H2" $c]
	set image [string replace $image $first $first $b]

	# Pause
	scan $ImageAddr(Pause) "%x" first
	set b [string range $image $first $first]
	set s [format "%02x" $Pause($GlobalParam(Pause))]
	set b [binary format "H2" $s]
	set image [string replace $image $first $first $b]

	# Resume
	scan $ImageAddr(Resume) "%x" first
	set b [string range $image $first $first]
	set s [format "%02x" $Resume($GlobalParam(Resume))]
	set b [binary format "H2" $s]
	set image [string replace $image $first $first $b]


	# Monitor flag
	scan $ImageAddr(Monitor) "%x" first
	set b [string range $image $first $first]
	set s [format "%02x" $Monitor($GlobalParam(Monitor))]
	set b [binary format "H2" $s]
	set image [string replace $image $first $first $b]


	# encode Beep tone flag
	scan $ImageAddr(Beep) "%x" first
	set b [string range $image $first $first]
	set s [format "%02x" $GlobalParam(Beep)]
	set b [binary format "H2" $s]
	set image [string replace $image $first $first $b]


	# encode Auto Power Off
	scan $ImageAddr(AutoOff) "%x" first
	set byte [string index $image $first]
	set n [format "%02x" $AutoOff($GlobalParam(AutoOff))]
	set newbyte [binary format "H2" $n]
	set image [string replace $image $first $first $newbyte]

	# encode Dial fast step
	scan $ImageAddr(DialStep) "%x" first
	set byte [string index $image $first]
	set n [format "%02x" $Dial($GlobalParam(Dial))]
	set newbyte [binary format "H2" $n]
	set image [string replace $image $first $first $newbyte]



	# encode Contrast
	# contrast is stored in the image as one less.
	scan $ImageAddr(Contrast) "%x" first
	set byte [string index $image $first]
	set n  $GlobalParam(Contrast)
	incr n -1
	set n [format "%02x" $n]
	set newbyte [binary format "H2" $n]
	set image [string replace $image $first $first $newbyte]



	# encode Lamp
	scan $ImageAddr(Lamp) "%x" first
	set byte [string index $image $first]
	set n [format "%02x" $Lamp($GlobalParam(Lamp))]
	set newbyte [binary format "H2" $n]
	set image [string replace $image $first $first $newbyte]


#	# Set VFO/Limit Search bit
#	scan $ImageAddr(FlagByte0) "%x" first
#	set byte [string index $image $first]
#	set newbyte [AssignBit $byte 3 $GlobalParam(LimitSearch)]
#	set image [string replace $image $first $first $newbyte]
#
#	# Fast Tuning Step is stored in one byte
#	scan $ImageAddr(FastTuningStep) "%x" first
#	set s $GlobalParam(FastTuningStep)
#	set s [format "%02x" $Fstep($s)]
#	set b [binary format "H2" $s]
#	set image [string replace $image $first $first $b]


	return $image
}

###################################################################
# Encode the memory channel frequency, mode, and preferential
# flag information into a memory image.
###################################################################

proc EncodeMemories { image } \
{
	global Ctcss
	global CtcssBias
	global Dcs
	global ImageAddr
	global MemBankLetter
	global MemBankCh
	global MemDuplex
	global MemFreq
	global MemHide
	global MemLabel
	global MemMode
	global MemOffset
	global MemSkip
	global MemStep
	global MemDToneCode
	global MemDTonePolarity
	global MemToneCode
	global MemToneFlag
	global Mode
	global RBankID
	global RToneFlag
	global Skip
	global Step
	global Mimage
	global ImageAddr

	for {set ch 0} {$ch < 1000} {incr ch} \
		{
		if {$MemHide($ch) == "hide"} \
			{
			set $MemFreq($ch) 0
			}
		}

	# Encode channel frequency.
	scan $ImageAddr(MemoryFreqs) "%x" first
	set last [expr {$first + 2}]

	for {set ch 0} {$ch < 1000} {incr ch} \
		{
		set b [ Freq2Internal3 $MemFreq($ch) $MemStep($ch) ]
#		set buf [DumpBinary $b]
#		puts stderr "ch: $ch, f: $MemFreq($ch), $buf"

		set image [string replace $image $first $last $b]

		incr first 16
		incr last 16
		}


	# Encode memory step.
	scan $ImageAddr(MemorySteps) "%x" first

	for {set ch 0} {$ch < 1000} {incr ch} \
		{
		set b [string index $image $first]

		if { [info exists Step($MemStep($ch))] } \
			{
			set m $Step($MemStep($ch))
			} \
		else \
			{
			set m $Step(5)
			}

		set b [SetBitField $b 0 3 $m]

		set image [string replace $image $first $first $b]

		incr first 16
		}


	# Encode memory label.
	scan $ImageAddr(MemoryLabels) "%x" first
	set last [expr {$first + 4}]

	for {set ch 0} {$ch < 1000} {incr ch} \
		{
		set s [MemoryLabel2Internal $MemLabel($ch)]

		set len [string length $s]
		# puts stderr "ch: $ch, s: $s, first: $first, last: $last, len: $len"
		set image [string replace $image $first $last $s]

		incr first 16
		incr last 16
		}


	# Encode memory hide flag.
	scan $ImageAddr(MemoryBankNumber) "%x" first
	set last [expr {$first + 1}]

	for {set ch 0} {$ch < 1000} {incr ch} \
		{

		if {$MemHide($ch) == "hide"} \
			{
			set b [binary format "H2H2" FF FF]
			} \
		else \
			{
			set b [binary format "H2H2" 1F FF]
			}

#		set abuf " $ch) "
#		append abuf [DumpBinary $b]
#		puts stderr $abuf

		set image [string replace $image $first $last $b]

		incr first 2
		incr last 2
		}

	# Encode bank letter.
	scan $ImageAddr(MemoryBankNumber) "%x" first

	for {set ch 0} {$ch < 1000} {incr ch} \
		{
		if {$MemHide($ch) == "hide"} \
			{
			incr first 2
			continue
			}

		set b [string index $image $first]
		if { [info exists RBankID($MemBankLetter($ch))] } \
			{
			set n $RBankID($MemBankLetter($ch))
			} \
		else \
			{
			# Invalid bank, so default it to no bank.
			set n 31
			}
		set b [SetBitField $b 3 7 $n]
		set image [string replace $image $first $first $b]
		incr first 2
		}


	# Encode bank channel number.
	scan $ImageAddr(MemoryBankCh) "%x" first

	for {set ch 0} {$ch < 1000} {incr ch} \
		{
		if {$MemHide($ch) == "hide"} \
			{
			incr first 2
			continue
			}
		set n $MemBankCh($ch)
		if { [info exists RBankID($MemBankLetter($ch))] \
			&& ($n >= 0) && ($n <= 99) } \
			{
			set hn [format "%02x" $n]
			set b [binary format "H2" $hn]
			} \
		else \
			{
			# This memory is not assigned to
			# a bank or channel number is invalid.
			set b [binary format "H2" FF]
			}
		set image [string replace $image $first $first $b]
		incr first 2
		}


	# Encode memory mode.
	scan $ImageAddr(MemoryModes) "%x" first
	set last $first

	for {set ch 0} {$ch < 1000} {incr ch} \
		{

		if { [info exists Mode($MemMode($ch))] } \
			{
			set m $Mode($MemMode($ch))
			} \
		else \
			{
			set m $Mode(NFM)
			}

		set b [string index $image $first]
		set b [SetBitField $b 4 5 $m]

		set image [string replace $image $first $last $b]

		incr first 16
		incr last 16
		}

	# Encode channel duplex/simplex flag.
	scan $ImageAddr(MemoryDuplex) "%x" first

	for {set ch 0} {$ch < 1000} {incr ch} \
		{
		set b [string index $image $first]

		if {$MemDuplex($ch) == "+"} \
			{
			set n 2
			} \
		elseif {$MemDuplex($ch) == "-"} \
			{
			set n 1
			} \
		else \
			{
			set n 0
			}

		set b [SetBitField $b 6 7 $n]
		set image [string replace $image $first $first $b]

		incr first 16
		}



	# Encode a frequency offset for a channel.
	scan $ImageAddr(MemoryOffset) "%x" first
	set last [expr {$first + 1}]

	scan $ImageAddr(MemoryMult) "%x" mfirst

	for {set ch 0} {$ch < 1000} {incr ch} \
		{
		set lst [ Freq2Offset $MemOffset($ch) $MemStep($ch) ]
		set s [ lindex $lst 0 ]
		set image [string replace $image $first $last $s]

		set m [ lindex $lst 1 ]
		set b [string index $image $mfirst]
		set b [SetBitField $b 0 1 $m]
		set image [string replace $image $mfirst $mfirst $b]

		incr first 16
		incr last 16
		incr mfirst 16
		}



	# Encode CTCSS code.
	scan $ImageAddr(MemoryToneCode) "%x" first

	for {set ch 0} {$ch < 1000} {incr ch} \
		{
		set b [ string index $image $first ]

		# CTCSS code
		set ccode $MemToneCode($ch)
		if { [info exists Ctcss($ccode)] == 0 } \
			{
			set n 0
			} \
		else \
			{
			set n [expr {$Ctcss($ccode) - $CtcssBias}]
			}


		set hn [format "%02x" $n]
		set b [binary format "H2" $hn]

		set image [string replace $image $first $first $b]

		incr first 16
		}



	# Encode Tone Squelch Flag.
	scan $ImageAddr(MemoryToneFlag) "%x" first

	for {set ch 0} {$ch < 1000} {incr ch} \
		{
		set b [ string index $image $first ]

		# Tone Squelch flag
		set m $MemToneFlag($ch)
		if { [info exists RToneFlag($m)] } \
			{
			set b [SetBitField $b 0 3 $RToneFlag($m)]
			} \
		else \
			{
			set b [SetBitField $b 0 3 $RToneFlag(off)]
			}

		set image [string replace $image $first $first $b]

		incr first 16
		}


	# Encode DCS code and polarity.
	scan $ImageAddr(MemoryDToneCode) "%x" first

	for {set ch 0} {$ch < 1000} {incr ch} \
		{
		set b [ string index $image $first ]

		# DCS code
		set ccode $MemDToneCode($ch)
		if { [info exists Dcs($ccode)] == 0 } \
			{
			set n 0
			} \
		else \
			{
			set n $Dcs($ccode)
			}
		# puts -nonewline stderr " ($ccode $n)"

		set hn [format "%02x" $n]
		set b [binary format "H2" $hn]

		if {$MemDTonePolarity($ch) == "r"} \
			{
			# Reverse
			set b [SetBit $b 0]
			} \
		else \
			{
			# Normal
			set b [ClearBit $b 0]
			}

		set image [string replace $image $first $first $b]

		incr first 16
		}


        # Encode skip field.
        scan $ImageAddr(MemorySkip) "%x" first
        set last $first

        for {set ch 0} {$ch < 1000} {incr ch} \
                {
		if {$MemHide($ch) == "hide"} \
			{
			incr first 2
			incr last 2
			continue
			}
                if {($MemSkip($ch) != "") && ($MemSkip($ch) != " ")} \
                        {
                        if { [info exists Skip($MemSkip($ch))] } \
                                {
                                set m $Skip($MemSkip($ch))
                                } \
                        else \
                                {
                                set m $Skip(scan)
                                }
                        } \
                else \
                        {
                        set m $Skip(scan)
                        }

                set b [string index $image $first]
                set b [SetBitField $b 1 2 $m]

 		set image [string replace $image $first $last $b]
 
 		incr first 2
 		incr last 2
 		}

	return $image
}


###################################################################
# Encode the limit search bank frequencies and modes
# information into a memory image.
###################################################################

proc EncodeSearchBanks { image } \
{
	global Ctcss
	global CtcssBias
	global ImageAddr
	global LimitScan
	global Mode
	global Skip
	global Step

	global Mimage
	global ImageAddr


	# Encode lower frequency.
	scan $ImageAddr(SearchFreqFirst) "%x" first
	set last [expr {$first + 2}]

	for {set bn 0} {$bn < 25} {incr bn} \
		{
		set b [ Freq2Internal3 $LimitScan($bn,lower) \
			$LimitScan($bn,lstep)]

		set image [string replace $image $first $last $b]

		incr first 32
		incr last 32
		}


	# Encode upper frequency.
	scan $ImageAddr(SearchFreqSecond) "%x" first
	set last [expr {$first + 2}]

	for {set bn 0} {$bn < 25} {incr bn} \
		{
		set b [ Freq2Internal3 $LimitScan($bn,upper) \
			$LimitScan($bn,ustep)]

		set image [string replace $image $first $last $b]

		incr first 32
		incr last 32
		}

	for {set bn 0} {$bn < 25} {incr bn} \
		{

		# Set flag to hide lower limit if the frequency is
		# close to 0 MHz.

		if {	   ($LimitScan($bn,lower) == "") \
			|| ($LimitScan($bn,lower) < .001) } \
			{
			set LimitScan($bn,lhide) hide
			} \
		else \
			{
			set LimitScan($bn,lhide) ""
			}


		# Set flag to hide upper limit if the frequency is
		# close to 0 MHz.

		if {	   ($LimitScan($bn,upper) == "") \
			|| ($LimitScan($bn,upper) < .001) } \
			{
			set LimitScan($bn,uhide) hide
			} \
		else \
			{
			set LimitScan($bn,uhide) ""
			}

		}




	# Encode lower search limit mode
	scan $ImageAddr(SearchModeFirst) "%x" first

	for {set bn 0} {$bn < 25} {incr bn} \
		{
		set b [ string index $image $first ]

		# Mode
		set m $Mode($LimitScan($bn,lmode))
		set b [SetBitField $b 4 5 $m]

		set image [string replace $image $first $first $b]

		incr first 32
		}


	# Encode upper search limit mode
	scan $ImageAddr(SearchModeSecond) "%x" first

	for {set bn 0} {$bn < 25} {incr bn} \
		{
		set b [ string index $image $first ]

		# Mode
		set m $Mode($LimitScan($bn,umode))
		set b [SetBitField $b 4 5 $m]

		set image [string replace $image $first $first $b]

		incr first 32
		}


	# Encode lower search limit Tuning Step.
	scan $ImageAddr(SearchStepFirst) "%x" first

	for {set bn 0} {$bn < 25} {incr bn} \
		{
		set b [ string index $image $first ]

		if { [info exists Step($LimitScan($bn,lstep))] } \
			{
			set m $Step($LimitScan($bn,lstep))
			} \
		else \
			{
			set m $Step(5)
			}
		set b [SetBitField $b 0 3 $m]
		set image [string replace $image $first $first $b]

		incr first 32
		}


	# Encode upper search limit Tuning Step.
	scan $ImageAddr(SearchStepSecond) "%x" first

	for {set bn 0} {$bn < 25} {incr bn} \
		{
		set b [ string index $image $first ]

		if { [info exists Step($LimitScan($bn,ustep))] } \
			{
			set m $Step($LimitScan($bn,ustep))
			} \
		else \
			{
			set m $Step(5)
			}

		set b [SetBitField $b 0 3 $m]
		set image [string replace $image $first $first $b]

		incr first 32
		}


	# Encode lower label name
	scan $ImageAddr(SearchLabelFirst) "%x" first
	set last [expr {$first + 4}]

	for {set bn 0} {$bn < 25} {incr bn}  \
		{
		set s [MemoryLabel2Internal $LimitScan($bn,llabel)]

		set image [string replace $image $first $last $s]

		incr first 32
		incr last 32
		}



	# Encode upper label name
	scan $ImageAddr(SearchLabelSecond) "%x" first
	set last [expr {$first + 4}]

	for {set bn 0} {$bn < 25} {incr bn}  \
		{
		set s [MemoryLabel2Internal $LimitScan($bn,ulabel)]

		set image [string replace $image $first $last $s]

		incr first 32
		incr last 32
		}



	# Encode hidden flag for lower search limit.
	scan $ImageAddr(SearchHideFirst) "%x" first
	set last [expr {$first + 1}]

	for {set bn 0} {$bn < 25} {incr bn} \
		{
		if { $LimitScan($bn,lhide) == "hide" } \
			{
			set b [binary format "H2H2" FF FF]
			} \
		else \
			{
			set b [binary format "H2H2" 1F FF]
			}
		set image [string replace $image $first $last $b]

		incr first 4
		incr last 4
		}


	# Encode hidden flag for upper search limit.
	scan $ImageAddr(SearchHideSecond) "%x" first
	set last [expr {$first + 1}]

	for {set bn 0} {$bn < 25} {incr bn} \
		{
		if { $LimitScan($bn,uhide) == "hide" } \
			{
			set b [binary format "H2H2" FF FF]
			} \
		else \
			{
			set b [binary format "H2H2" 1F FF]
			}
		set image [string replace $image $first $last $b]

		incr first 4
		incr last 4
		}

	return $image
}


###################################################################
# Encode the TV channel info
# information into a memory image.
###################################################################

proc EncodeTV { image } \
{
	global TVHideByte
	global TVSkipByte
	global ImageAddr
	global Mimage
	global TV

	# Encode channel frequency.
	scan $ImageAddr(TVFreq) "%x" first
	set last [expr {$first + 2}]

	for {set ch 0} {$ch < 70} {incr ch} \
		{
		set b [ TV2Internal3 $TV($ch,freq) ]

		set image [string replace $image $first $last $b]

		incr first 8
		incr last 8
		}


	# Encode channel mode.
	scan $ImageAddr(TVMode) "%x" first

	for {set ch 0} {$ch < 70} {incr ch} \
		{
		if { $TV($ch,mode) == "WFM" } \
			{
			set b [binary format "H2" 01]
			} \
		else \
			{
			set b [binary format "H2" 02]
			}

		set image [string replace $image $first $first $b]

		incr first 8
		}


	# Encode TV channel label.
	scan $ImageAddr(TVLabel) "%x" first
	set last [expr {$first + 3}]

	for {set ch 0} {$ch < 70} {incr ch} \
		{
		set s $TV($ch,label)

		# Translate bogus characters to spaces
		regsub -all {[^A-Za-z0-9 .,\+\*/()\-=]} $s " " s

		# Labels must be upper case.
		set s [string toupper $s]
		set s [format "%-4s" $s]
		set s [string range $s 0 3]

		set image [string replace $image $first $last $s]

		incr first 8
		incr last 8
		}


	# Encode TV channel hide flag.

	ClearHiddenTVChannelFlags
        SetHiddenTVChannelFlags

	# PrintHiddenTVChannelFlags
	scan $ImageAddr(TVHide) "%x" first

	for {set i 0} {$i < 9} {incr i} \
		{
		set b [binary format "B8" $TVHideByte($i)]
		set image [string replace $image $first $first $b]
		incr first
		}

	# Encode TV channel skip flag.
	ClearSkipTVChannelFlags
        SetSkipTVChannelFlags

	scan $ImageAddr(TVSkip) "%x" first

	for {set i 0} {$i < 9} {incr i} \
		{
		set b [binary format "B8" $TVSkipByte($i)]
		set image [string replace $image $first $first $b]
		incr first
		}

	return $image
}


###################################################################
# Pop up a window which says "Please wait..."
###################################################################
proc MakeWait { } \
{
	global DisplayFontSize


	toplevel .wait

	set w .wait
	wm title $w "tk5 running"

	label $w.lab -font $DisplayFontSize -text "Please wait ..."

	pack $w.lab

	update idletasks
	waiter 500
	return
}

###################################################################
# Kill the window which says "Please wait..."
###################################################################
proc KillWait { } \
{
	catch {destroy .wait}
	update idletasks
}

###################################################################
# ValidateData tests the data.
# It pops up a window with error and/or warning messages.
# If there are warnings but no errors, the user can elect
# to continue or cancel the current operation.
#
# Returns:
#	0	- continue
#	1	- cancel the current operation
###################################################################
proc ValidateData { } \
{
	global Band
	global Emsg
	global GlobalParam
	global MemFreq
	global MemHide
	global MemMode
	global MemStep
	global LimitScan
	global Priority
	global PriorityMode
	global Skip
	global TV

	if { [info exists MemFreq(0)] == 0 } \
		{
		# No data to validate.
		return 1
		}


	if { $GlobalParam(BypassAllEncoding) } \
		{
		# do not validate.
		return 0
		}


	set Emsg ""
	set nerror 0
	set nwarning 0

	# Memory channels.
	for {set ch 0} {$ch < 1000} {incr ch} \
		{
		if {$MemHide($ch) == "hide"} {continue}
		set m "Memory $ch"
		set f $MemFreq($ch)

		set code [ValidateFreq $f $m]
		if {$code == "error"} { incr nerror } \
		elseif {$code == "warning"} { incr nwarning }

		set mode $MemMode($ch)
		set code [ValidateMode $mode $m $f]
		if {$code == "error"} { incr nerror }

		set step $MemStep($ch)
		set code [ValidateStep $step $m $f]
		if {$code == "error"} { incr nerror } \
		elseif {$code == "warning"} { incr nwarning }

		if { [expr {$nerror + $nwarning}] > 5} {break}
		}

#	puts stderr "ValidateData: done with memories"



	# TV channels.
	for {set ch 0} {$ch < 70} {incr ch} \
		{
		set nch $ch
		incr nch
		set m "TV channel $nch"
		set f $TV($ch,freq)

		set code [ValidateFreq $f $m]
		if {$code == "error"} { incr nerror } \
		elseif {$code == "warning"} { incr nwarning }

		if { [expr {$nerror + $nwarning}] > 5} {break}
		}

#	puts stderr "ValidateData: done with memories"



	# Limit scan freqs, steps
	for {set i 0} {$i < 25} {incr i} \
		{
		set m "Limit Scan bank PROG$i lower"
		set f $LimitScan($i,lower)

		set code [ValidateFreq $f $m]
		if {$code == "error"} { incr nerror } \
		elseif {$code == "warning"} { incr nwarning }

		set step $LimitScan($i,lstep)
		set code [ValidateStep $step $m $f]
		if {$code == "error"} { incr nerror } \
		elseif {$code == "warning"} { incr nwarning }

		set code [ValidateMode $LimitScan($i,lmode) $m $f]
		if {$code == "error"} { incr nerror }

		set m "Limit Scan bank PROG$i upper"
		set f $LimitScan($i,upper)

		set code [ValidateFreq $f $m]
		if {$code == "error"} { incr nerror } \
		elseif {$code == "warning"} { incr nwarning }

		set step $LimitScan($i,ustep)
		set code [ValidateStep $step $m $f]
		if {$code == "error"} { incr nerror } \
		elseif {$code == "warning"} { incr nwarning }

		set code [ValidateMode $LimitScan($i,umode) $m $f]
		if {$code == "error"} { incr nerror }
	
		if { [expr {$nerror + $nwarning}] > 5} {break}
		}

	set m "Bank/Channel assignment."
	set code [ValidateMemoryBanks $m]
	if {$code == "error"} { incr nerror }

	if {$nerror} \
		{
		tk_dialog .baddata1 "tk5 Invalid data" \
			$Emsg error 0 OK
		# puts stderr "ValidateData: returning 1"
		return 1
		}
	if {$nwarning} \
		{
		set response [tk_dialog .baddata2 \
			"tk5 Data warning" \
			$Emsg error 0 Cancel Continue]

		if {$response == 0} then {return 1} \
		else {return 0}
		}
	
	return 0
}

###################################################################
# Check a frequency for validity.
# Append the error or warning message to a global string.
#
# Returns:
#	0
#	warning
#	error
###################################################################
proc ValidateFreq {f m} \
{
	global Emsg
	global GlobalParam

	set code 0
	set msg ""

	if {( ($f != "") && ($f != 0.0) ) \
		&& (($f < $GlobalParam(LowestFreq)) \
		|| ($f > $GlobalParam(HighestFreq)))} \
		{
		append msg "\nError: $m frequency ($f) is out"
		append msg " of range.\n"
		set code error
		}

	append Emsg $msg
	return $code
}

###################################################################
# Return 1 if a string consists of 2 hex digits.
###################################################################
proc IsHex { s } \
{
	# Check for non-digit and non decimal point chars.
	set rc [regexp -nocase {^[0-9a-f][0-9a-f]$} $s]
	if {$rc} \
		{
		return 1
		} \
	else \
		{
		return 0
		}
}

###################################################################
# Check a mode for validity.
# Append the error message to a global string.
#
# Returns:
#	0
#	warning
#	error
###################################################################
proc ValidateMode {mode m f} \
{
	global GlobalParam
	global Emsg
	global Mode

	set code 0

	if { [info exists Mode($mode)] == 0} \
		{
		append Emsg "\nError: $m mode ($mode) is invalid.\n"
		set code error
		} 

	if { ($f != "") && ($f != 0.0) } \
		{
		if {($mode != "AM") \
			&& ($mode != "WFM") \
			&& ($mode != "NFM") } \
			{
			append Emsg "\nError: $m mode ($mode) "
			append Emsg "is invalid.\n"
			set code error
			}
		}


	if { ($code != "error") && ($f != "") && ($f >= .495) \
		&& ($f <= 1.620) } \
		{
		if {$GlobalParam(WhichModel) == 9} \
			{
			if {$mode != "AM"} \
				{
				append Emsg "\nWarning: $m mode "
				append Emsg "must be AM for this "
				append Emsg "version radio.\n"
				set code error
				}
			}
		}
	return $code
}


###################################################################
# Check a step size for validity.
# Append the error message to a global string.
#
# Radio version with 9 kHz step in the AM BCB may only have
# a 9 kHz step between .495 and 1.620 MHz.
#
# Radio version with 10 kHz step in the AM BCB cannot have
# a 9 kHz step between .495 and 1.620 MHz.
#
# Returns:
#	0
#	warning
#	error
###################################################################
proc ValidateStep {step m f} \
{
	global Emsg
	global GlobalParam

	set code 0

	if { ($f == "") || ($f == 0.0) } \
		{
		return 0
		}

	if {($f >= .495) && ($f <= 1.620)} \
		{
		if {($step == 9) \
			&& ($GlobalParam(WhichModel) != 9)} \
			{
			append Emsg "\nError: $m step ($step) "
			append Emsg "is invalid for this "
			append Emsg "version radio.\n"
			set code error
			} \
		elseif {($step != 9) \
			&& ($GlobalParam(WhichModel) == 9)} \
			{
			append Emsg "\nError: $m step ($step) "
			append Emsg "is invalid for this "
			append Emsg "version radio.\n"
			set code error
			}
		} \
	else \
		{
		# Extract the Hz portion of the frequency
		# to the right of the decimal point.

		set f [format "%.6f" $f]
		set lst [split $f "."]
		set fhz [ lindex $lst 1 ]
		set fhz [string trimleft $fhz 0]
		if {$fhz == ""} {set fhz 0}
		# puts stderr "f= $f, fhz= $fhz"
		# set fhz [expr {$fhz * 1000000}]

		set stephz [expr {$step * 1000}]
		set n [expr {fmod($fhz, $stephz)}]
		set n [expr {int($n)}]

#		if {$n } \
#			{
#
#			# Frequency incompatible with step size.
#			# puts stderr "f: $f, fhz: $fhz, step $step, stephz: $stephz, n: $n"
#			append Emsg "\nWarning: $m frequency ($f) "
#			append Emsg "will be adjusted to conform "
#			append Emsg "to step ($step).\n"
#			set code warning
#			}
		}

	return $code
}
###################################################################
#
# Determine if there are any bank/channels assigned more than
# once.
#
###################################################################

proc ValidateMemoryBanks { m } \
{
	global Emsg
	global MemFreq
	global MemHide
	global MemBankLetter
	global MemBankCh
	global RBankID

	set code 0

	for {set ch 0} {$ch < 1000} {incr ch} \
		{
		if { ($MemHide($ch) == "hide") \
			|| ($MemBankLetter($ch) == "") \
			|| ($MemBankCh($ch) == "") } \
			{
			continue
			}

		set key "$MemBankLetter($ch),$MemBankCh($ch)"
		if {$key == ","} {continue}

		if { ($MemBankCh($ch) < 0) || ($MemBankCh($ch) > 99) } \
			{
			append Emsg "\nError: $m\n"
			append Emsg "Memory $ch, memory "
			append Emsg "channel number must be "
			append Emsg "be 0 to 99, not $MemBankCh($ch)."
			set code error
			break
			}

		if { [info exists RBankID($MemBankLetter($ch))] == 0 } \
			{
			append Emsg "\nError: $m\n"
			append Emsg "Memory $ch, memory "
			append Emsg "bank number must be "
			append Emsg "A-H, J, L, N, O-R, T, U, "
			append Emsg "or Y, not $MemBankLetter($ch)."
			set code error
			break
			}

		# If this bank/ch is already assigned.
		if { [info exists bankch($key)] } \
			{
			# Error - Another memory location is assigned
			# to this bank and channel.
			append Emsg "\nError: $m\n"
			append Emsg "Bank $MemBankLetter($ch) "
			append Emsg "Channel $MemBankCh($ch) "
			append Emsg "cannot be assigned to two "
			append Emsg "different memories "
			append Emsg "($bankch($key) and $ch). "
			set code error
			break
			} \
		else \
			{
			# Mark this bank/ch as assigned.
			set bankch($key) $ch
			}
		
		}

	return $code
}


###################################################################
# Set title of the main window so it contains the
# current template file name.
###################################################################
proc SetWinTitle { } \
{
	global GlobalParam

	if { ( [info exists GlobalParam(TemplateFilename)] == 0 ) \
		|| ($GlobalParam(TemplateFilename) == "") } \
		{
		set filename untitled.tr5
		} \
	else \
		{
		set filename $GlobalParam(TemplateFilename)
		}

	set s [format "tk5 - %s" $filename]
	wm title . $s

	return
}


# Prevent user from shrinking or expanding window.

proc FixSize { w } \
{
	wm minsize $w [winfo width $w] [winfo height $w]
	wm maxsize $w [winfo width $w] [winfo height $w]

	return
}


######################################################################
#					Bob Parnass
#					DATE:
#
# USAGE:	SortaBank first last
#
# INPUTS:
#		first	-starting channel to sort
#		last	-ending channel to sort
#
# RETURNS:
#		0	-ok
#		-1	-error
#
#
# PURPOSE:	Sort a range of memory channels based on frequency.
#
# DESCRIPTION:
#
######################################################################
proc SortaBank { first last } \
{
	global GlobalParam
	global MemDuplex
	global MemFreq
	global MemLabel
	global MemMode
	global MemOffset
	global MemSkip
	global MemStep
	global MemToneCode
	global MemToneFlag
	global Mimage


	if {[info exists Mimage] == 0} \
		{
		set msg "You must open a template file\n"
		append msg " or read an image from the radio\n"
		append msg " before sorting channels.\n"

		tk_dialog .belch "tk5" \
			$msg info 0 OK
		return -1
		}


	if {$GlobalParam(SortType) == "freq"} \
		{
		set inlist [Bank2List MemFreq $first $last]
		set vorder [SortFreqList $inlist]
		} \
	else \
		{
		set inlist [Bank2List MemLabel $first $last]
		set vorder [SortLabelList $inlist]
		}


	set inlist [Bank2List MemFreq $first $last]
	set slist [ReorderList $inlist $vorder]
	for {set i $first; set j 0} {$i <= $last} {incr i; incr j} \
		{
		set MemFreq($i) [lindex $slist $j]
		}


	set slist [ReorderList $inlist $vorder]
	for {set i $first; set j 0} {$i <= $last} {incr i; incr j} \
		{
		set MemFreq($i) [lindex $slist $j]
		}

	set inlist [Bank2List MemMode $first $last]
	set slist [ReorderList $inlist $vorder]
	for {set i $first; set j 0} {$i <= $last} {incr i; incr j} \
		{
		set MemMode($i) [lindex $slist $j]
		if {$MemMode($i) == ""} \
			{
			set MemMode($i) NFM
			}
		}

	set inlist [Bank2List MemDuplex $first $last]
	set slist [ReorderList $inlist $vorder]
	for {set i $first; set j 0} {$i <= $last} {incr i; incr j} \
		{
		set MemDuplex($i) [lindex $slist $j]
		}

	set inlist [Bank2List MemOffset $first $last]
	set slist [ReorderList $inlist $vorder]
	for {set i $first; set j 0} {$i <= $last} {incr i; incr j} \
		{
		set MemOffset($i) [lindex $slist $j]
		}

	set inlist [Bank2List MemSkip $first $last]
	set slist [ReorderList $inlist $vorder]
	for {set i $first; set j 0} {$i <= $last} {incr i; incr j} \
		{
		set MemSkip($i) [lindex $slist $j]
		}

	set inlist [Bank2List MemToneCode $first $last]
	set slist [ReorderList $inlist $vorder]
	for {set i $first; set j 0} {$i <= $last} {incr i; incr j} \
		{
		set MemToneCode($i) [lindex $slist $j]
		}

	set inlist [Bank2List MemToneFlag $first $last]
	set slist [ReorderList $inlist $vorder]
	for {set i $first; set j 0} {$i <= $last} {incr i; incr j} \
		{
		set MemToneFlag($i) [lindex $slist $j]
		}


	set inlist [Bank2List MemStep $first $last]
	set slist [ReorderList $inlist $vorder]
	for {set i $first; set j 0} {$i <= $last} {incr i; incr j} \
		{
		set MemStep($i) [lindex $slist $j]
		}


	set inlist [Bank2List MemLabel $first $last]
	set slist [ReorderList $inlist $vorder]
	for {set i $first; set j 0} {$i <= $last} {incr i; incr j} \
		{
		set MemLabel($i) [lindex $slist $j]
		}

	return 0
}


proc ClearAllChannels { } \
{
	global Cht
	global GlobalParam
	global Mimage
	global MemFreq
	global MemSkip


	if { ([info exists Mimage] == 0) \
		|| ([string length $Mimage] <= 0)} \
		{
		# No image to write.
		set msg "You must first read template data from"
		append msg " the radio or open a file before"
		append msg " clearing memories."

		tk_dialog .error "Clear all channels" $msg error 0 OK
		return
		}


	set msg "Warning: This operation will clear all 1000 "
	append msg "memory channels."

	set result [tk_dialog .clearall "Warning" \
		$msg warning 0 Cancel "Clear Memories" ]

	if {$result == 0} {return}

	for {set ch 0} {$ch < 1000} {incr ch} \
		{
		ZapChannel $ch
		}

	ShowChannels $Cht
	return

}


proc ZapChannel { ch } \
{
	global MemBankLetter
	global MemBankCh
	global MemDuplex
	global MemFreq
	global MemHide
	global MemLabel
	global MemMode
	global MemOffset
	global MemSkip
	global MemStep
	global MemDTonePolarity
	global MemDToneCode
	global MemToneCode
	global MemToneFlag


	set MemFreq($ch) 0
	set MemDuplex($ch) ""
	set MemHide($ch) hide
	set MemLabel($ch) ""
	set MemMode($ch) NFM
	set MemOffset($ch) ""
	set MemSkip($ch) " "
	set MemStep($ch) 5
	set MemDTonePolarity($ch) n
	set MemDToneCode($ch) "023"
	set MemToneCode($ch) "88.5"
	set MemToneFlag($ch) "off"
	set MemBankLetter($ch) ""
	set MemBankCh($ch) ""

	return
}


proc ZapBankLabels { } \
{
	global BankLabel
	global NBanks


	for {set bn 0} {$bn < $NBanks} {incr bn} \
		{
		set BankLabel($bn) ""
		}

	return
}
###################################################################
# Create memory banks. 
###################################################################
proc MakeMemoryBankFrame { f }\
{
	global GlobalParam
	global MemNB

	frame $f -relief groove -borderwidth 3
	# frame $f.b -relief flat -borderwidth 3

	label $f.lab -text "Memory Bank Settings" -borderwidth 3

	pack $f.lab \
		-side top -fill both -expand false -padx 3 -pady 3

	MakeMemoryBankFrameCommon $f.common
	pack $f.common  -side left -padx 3 -pady 3 -fill both

	set MemNB $f.banknb
	MakeMemoryBankNB $MemNB
	return $f
}

###################################################################
# Make a frame for settings common to all memory banks.
###################################################################
proc MakeMemoryBankFrameCommon { f }\
{
	global GlobalParam

	frame $f -relief groove -borderwidth 3

	return $f
}

###################################################################
# Make a single tabbed notebook to hold the settings
# for the individual memory banks.
###################################################################
proc MakeMemoryBankNB { w } \
{
	global BankID
	global NBanks

	tabnotebook_create $w

	# fix me
	# for {set i 0} {$i < $NBanks} {incr i} 
	for {set i 0} {$i < 1} {incr i} \
		{
		if {[info exists BankID($i)]} \
			{
			set tl "Bank $BankID($i)"
			} \
		else \
			{
			set tl "Bank $i"
			}
		set p [tabnotebook_page $w $tl]
		set fr $p.f; MakeMemoryBankPage $fr $i
		pack $fr
		}

	pack $w -expand true -fill both
}

###################################################################
# Make a frame to hold the settings
# for one memory bank.
###################################################################
proc MakeMemoryBankPage { f bn }\
{
	global GlobalParam

	frame $f -relief flat -borderwidth 3

	MakeBankSettingsFrame $f.c1 $bn

	pack $f.c1 -side top \
		-fill both -padx 3 -pady 3 -expand true

	if {$GlobalParam(EditMemoryChannels) == "on"} \
		{
		MakeMemoryChannelFrame $f.c2 $bn
		MakeFillerFrame $f.c3 $bn

		pack $f.c2 -side left \
			-fill both -padx 3 -pady 3 -expand true

		pack $f.c3 -side left \
			-fill both -padx 3 -pady 3 -expand true
		}

	return $f
}


###################################################################
# Create one a set of widgets which pertain to
# for one memory bank. 
#
# INPUTS:
#		f	-frame to create
#		bn	-bank number
#
###################################################################
proc MakeBankSettingsFrame { f bn }\
{
	global BankID 
	global BankLabel 
	global ChanBank 
	global DisplayFontSize 
	global GlobalParam 

	frame $f -relief flat -borderwidth 3


	return $f
}


###################################################################
#
# INPUTS:
#		f	-frame to create
#		bn	-bank number
#
###################################################################
proc MakeFillerFrame { f bn }\
{
	global DisplayFontSize 

	frame $f -relief flat -borderwidth 3


	for {set i 0} {$i < 12} {incr i} \
		{
		label $f.filler$bn$i -text "-"  -relief flat \
			-borderwidth 6

		grid $f.filler$bn$i -row $i -column 0 -sticky ew 
		}

	return $f
}


###################################################################
# Create widgets for memory channels for a bank. 
###################################################################
proc MakeMemoryChannelFrame { f bn }\
{
	global GlobalParam
	global NBanks
	global NChanPerBank
	global VNChanPerBank

	frame $f -relief flat -borderwidth 3
	label $f.lab -text "Memory Channels" -borderwidth 3

	pack $f.lab -side top


	ScrollformCreate $f.b
	pack $f.b -expand yes -fill both

	set w [ScrollFormInterior $f.b]


	label $w.freq -text "Freq" -borderwidth 3
	label $w.mode -text "Mode" -borderwidth 3
	label $w.label -text "Label" -borderwidth 3
	label $w.step -text "Step" -borderwidth 3
	label $w.offset -text "Offset" -borderwidth 3
	label $w.duplex -text "Duplex" -borderwidth 3
	label $w.toneflag -text "TSQL" -borderwidth 3
	label $w.tonecode -text "CTCSS" -borderwidth 3
	label $w.skip -text "Skip" -borderwidth 3
	label $w.move -text "Move" -borderwidth 3

	if {$GlobalParam(EditMemoryChannels) == "on"} \
		{
		set ch 0
		set bn 0
		set i 0
		MakeChannel $w $bn $i $ch
		update idletasks
		}

	grid $w.freq -row 0 -column 20
	grid $w.mode -row 0 -column 30
	grid $w.label -row 0 -column 35
	grid $w.step -row 0 -column 40
	grid $w.offset -row 0 -column 50
	grid $w.duplex -row 0 -column 60
	grid $w.toneflag -row 0 -column 70
	grid $w.tonecode -row 0 -column 80
	grid $w.skip -row 0 -column 100
	grid $w.move -row 0 -column 110 -columnspan 2

	return $f
}


###################################################################
# Create one a set of widgets for one channel. 
###################################################################
proc MakeChannel { f bn n ch }\
{
	global ChanNumberRepeat
	global GlobalParam

	global MemDuplex
	global MemFreq
	global MemMode
	global MemOffset
	global MemSkip
	global MemStep
	global MemToneCode
	global MemToneFlag

	set row [expr {$n + 2}]

	if {$ChanNumberRepeat == "yes"}\
		{
		set chn $n
		} \
	else \
		{
		set chn $ch
		}

	label $f.lab$bn$ch -text "$chn" -borderwidth 3

	entry $f.freq$bn$ch -width 12 \
		-textvariable MemFreq($ch) \
		-background white 

	tk_optionMenu $f.modemenu$bn$ch MemMode($ch) \
		NFM WFM AM

	set wid [expr {2 + $GlobalParam(LabelLength)}]
	entry $f.label$bn$ch -width $wid \
		-textvariable MemLabel($ch) \
		-background white 

#	tk_optionMenu $f.stepmenu$bn$ch MemStep($ch) \
#		5 6.25 9 10 12.5 15 20 25 30 50 100
#

	entry $f.offset$bn$ch -width 12 \
		-textvariable MemOffset($ch) \
		-background white 

	tk_optionMenu $f.duplexmenu$bn$ch MemDuplex($ch) \
		" " "-" "+"

#	tk_optionMenu $f.toneflagmenu$bn$ch MemToneFlag($ch) \
#		off tsql

	entry $f.tonecode$bn$ch -width 7 \
		-textvariable MemToneCode($ch) \
		-background white 

#	tk_optionMenu $f.skipmenu$bn$ch MemSkip($ch) \
#		pskip skip hide " "
#
#

	button $f.lower$bn$ch -text "^" \
		-command "SwapChannel $ch [expr {$ch - 1}] 1"

	button $f.higher$bn$ch -text "v" \
		-command "SwapChannel $ch [expr { $ch + 1}] 1"

	button $f.insert$bn$ch -text "Insert" \
		-command "InsertChannel $ch"

	button $f.delete$bn$ch -text "Delete" \
		-command "DeleteChannel $ch"

	grid $f.lab$bn$ch -row $row -column 10
	grid $f.freq$bn$ch -row $row -column 20
	grid $f.modemenu$bn$ch -row $row -column 30 -sticky ew
	grid $f.label$bn$ch -row $row -column 35 -sticky ew
#	grid $f.stepmenu$bn$ch -row $row -column 40 -sticky ew
	grid $f.offset$bn$ch -row $row -column 50 -sticky ew
	grid $f.duplexmenu$bn$ch -row $row -column 60 -sticky ew
#	grid $f.toneflagmenu$bn$ch -row $row -column 70 -sticky ew
	grid $f.tonecode$bn$ch -row $row -column 80 -sticky ew
#	grid $f.skipmenu$bn$ch -row $row -column 100 -sticky ew
	grid $f.lower$bn$ch -row $row -column 110
	grid $f.higher$bn$ch -row $row -column 120
	grid $f.insert$bn$ch -row $row -column 130
	grid $f.delete$bn$ch -row $row -column 140

	return
}

###################################################################
# Insert a memory channel and move all the higher channels
# in the same bank higher by one channel.  Clear the current
# channel in the bank.
###################################################################
proc InsertChannel { ch } \
{
	global MemDuplex
	global MemFreq
	global MemLabel
	global MemMode
	global MemOffset
	global MemSkip
	global MemStep
	global MemToneCode
	global MemToneFlag

	global NChanPerBank
	global VNChanPerBank

	set bn [expr {int($ch/$VNChanPerBank)}]
	set last [expr {($bn * $VNChanPerBank) + $NChanPerBank - 1}]

	if {$MemFreq($last) > 0} \
		{
		# No room.

		set msg "Channel $last is not empty.\n\n"
		append msg "Please delete channel $last before "
		append msg "inserting a new channel $ch and "
		append msg "moving the existing channels higher."

		tk_dialog .belch "Insert new channel" \
			$msg error 0 OK

		return
		}

	set n [expr {$NChanPerBank - fmod($ch, $VNChanPerBank) - 1}]

	set to $last
	set from $last
	incr from -1

	for {set i 0} {$i < $n} {incr i} \
		{
		# puts stderr "InsertChannel: n: $n, moving channel $from to $to"
		set MemFreq($to) $MemFreq($from)
		set MemLabel($to) $MemLabel($from)
		set MemMode($to) $MemMode($from)
		set MemStep($to) $MemStep($from)
		set MemOffset($to) $MemOffset($from)
		set MemDuplex($to) $MemDuplex($from)
		set MemToneFlag($to) $MemToneFlag($from)
		set MemToneCode($to) $MemToneCode($from)
		set MemSkip($to) $MemSkip($from)

		incr from -1
		incr to	-1
		}

	ZapChannel $ch

}

###################################################################
# Delete a memory channel and move all the higher channels
# in the same bank to the previous channel.  Clear the last
# channel in the bank.
###################################################################

proc DeleteChannel { ch } \
{

	global MemDuplex
	global MemFreq
	global MemLabel
	global MemMode
	global MemOffset
	global MemSkip
	global MemStep
	global MemToneCode
	global MemToneFlag

	global NChanPerBank
	global VNChanPerBank

	set n [expr {$NChanPerBank - fmod($ch, $VNChanPerBank) - 1}]

	set to $ch
	set from $ch
	incr from

	for {set i 0} {$i < $n} {incr i} \
		{
		set MemFreq($to) $MemFreq($from)
		set MemLabel($to) $MemLabel($from)
		set MemMode($to) $MemMode($from)
		set MemStep($to) $MemStep($from)
		set MemOffset($to) $MemOffset($from)
		set MemDuplex($to) $MemDuplex($from)
		set MemToneFlag($to) $MemToneFlag($from)
		set MemToneCode($to) $MemToneCode($from)
		set MemSkip($to) $MemSkip($from)

		incr from	
		incr to	
		}

	set bn [expr {int($ch/$VNChanPerBank)}]
	set last [expr {($bn * $VNChanPerBank) + $NChanPerBank - 1}]

	ZapChannel $last

	return
}


###################################################################
# Swap channel with the another channel in the bank.
#
# INPUTS:
#		ch1		-first channel
#		ch2		-second channel
#		samebank	-1 = channels must be withn
#				the same bank.
#				0 = channels may be in different
#				banks.
###################################################################
proc SwapChannel { ch1 ch2 samebank } \
{
	global MemDuplex
	global MemFreq
	global MemLabel
	global MemMode
	global MemOffset
	global MemSkip
	global MemStep
	global MemToneCode
	global MemToneFlag

	global NChanPerBank
	global VNChanPerBank

	set bn [expr {int($ch1/$VNChanPerBank)}]
	set last [expr {($bn * $VNChanPerBank) + $NChanPerBank - 1}]
	set ch1r [expr {int(fmod($ch1,$VNChanPerBank))}]
	set ch2r [expr {int(fmod($ch2,$VNChanPerBank))}]

	if { $samebank && ( ($ch1 > $last) \
		|| ($ch1 < 0) \
		|| ($ch2 > $last) \
		|| ($ch2 < 0) \
		|| ($ch1r >= $NChanPerBank) \
		|| ($ch2r >= $NChanPerBank) ) } \
		{

		set msg "Cannot move channel $ch1 to $ch2."

		tk_dialog .belch "Move channel" \
			$msg error 0 OK

		return
		}

	set tmp $MemFreq($ch2)
	set MemFreq($ch2) $MemFreq($ch1)
	set MemFreq($ch1) $tmp

	set tmp $MemLabel($ch2)
	set MemLabel($ch2) $MemLabel($ch1)
	set MemLabel($ch1) $tmp

	set tmp $MemMode($ch2)
	set MemMode($ch2) $MemMode($ch1)
	set MemMode($ch1) $tmp

	set tmp $MemStep($ch2)
	set MemStep($ch2) $MemStep($ch1)
	set MemStep($ch1) $tmp

	set tmp $MemOffset($ch2)
	set MemOffset($ch2) $MemOffset($ch1)
	set MemOffset($ch1) $tmp

	set tmp $MemDuplex($ch2)
	set MemDuplex($ch2) $MemDuplex($ch1)
	set MemDuplex($ch1) $tmp

	set tmp $MemToneFlag($ch2)
	set MemToneFlag($ch2) $MemToneFlag($ch1)
	set MemToneFlag($ch1) $tmp

	set tmp $MemToneCode($ch2)
	set MemToneCode($ch2) $MemToneCode($ch1)
	set MemToneCode($ch1) $tmp

	set tmp $MemSkip($ch2)
	set MemSkip($ch2) $MemSkip($ch1)
	set MemSkip($ch1) $tmp

	return
}


###################################################################
#
# Swap the bank settings, memory channel info, fleet map,
# and talk group info for 2 banks with each other.
#
###################################################################

proc SwapBank { bn1 bn2 } \
{
	global BankLabel
	global ChanBank
	global Cht
	global GlobalParam
	global NBanks
	global NChanPerBank
	global VNChanPerBank

	# Sanity checks.
	if { $bn1 == $bn2 } \
		{
		# Swap bank with itself.
		return
		}

	if { ($bn1 < 0) || ($bn1 >= $NBanks) \
		|| ($bn2 < 0) || ($bn2 >= $NBanks) } \
		{
		# No such bank.
		return
		}

	# Swap the memory channels.
	set ch1 [expr {$bn1 * $VNChanPerBank}]
	set ch2 [expr {$bn2 * $VNChanPerBank}]

	for {set i 0} {$i < $NChanPerBank} {incr i} \
		{
		SwapChannel $ch1 $ch2 0
		incr ch1
		incr ch2
		}

	# Swap bank labels.
	set tmp $BankLabel($bn1)
	set BankLabel($bn1) $BankLabel($bn2)
	set BankLabel($bn2) $tmp

	ShowChannels $Cht
	return
}

##############################################################
# Format a 6-character bank label for internal storage.
# Make it upper case.
# If it is all blanks, make it nulls.
#
# Input:	s	-label
#
# Returns:	6-byte internal representation
##############################################################
proc BankLabel2Internal { s } \
{

	set s [ format "%-6s" $s ]
	set s [ string range $s 0 5 ]

	# Translate bogus characters to spaces
	regsub -all {[^A-Za-z0-9 .,\+\*/()\-=]} $s " " s

	# Labels must be upper case.
	set s [string toupper $s]

	if {$s == "      "} \
		{
		set s [binary format "H2H2H2H2H2H2" 00 00 00 00 00 00]
		}
	return $s
}

##############################################################
# Format a 6-character bank label for display.
# If it is all nulls, make it blanks.
#
# Input:	s	-label
#
# Returns:	6-character ASCII string
##############################################################
proc Internal2BankLabel { s } \
{

	# Translate bogus characters to spaces
	regsub -all {[^A-Za-z0-9 .,\+\*/()\-=]} $s " " s

	set s [ string range $s 0 5 ]
	set s [string trimright $s " "]

	# Labels must be upper case.
	set s [string toupper $s]

	return $s
}

##############################################################
# Translate an internal 36-bit (4-1/2 byte) label into
# ASCII for display.
# If it is all nulls, make it blanks.
#
# Input:	s	-5 byte string
#
# Returns:	6-character ASCII string
##############################################################
proc Internal2MemoryLabel { s } \
{
	global Int2a

	set b0 [string index $s 0]
	set b1 [string index $s 1]
	set b2 [string index $s 2]
	set b3 [string index $s 3]
	set b4 [string index $s 4]

	set first [GetBitField $b0 4 7]
	set second [GetBitField $b1 0 1]
	set c(0) [expr {($first * 4) + $second}]

	set c(1) [GetBitField $b1 2 7]
	set c(2) [GetBitField $b2 0 5]

	set first [GetBitField $b2 6 7]
	set second [GetBitField $b3 0 3]
	set c(3) [expr {($first * 16) + $second}]

	set first [GetBitField $b3 4 7]
	set second [GetBitField $b4 0 1]
	set c(4) [expr {($first * 4) + $second}]

	set c(5) [GetBitField $b4 2 7]

	for {set i 0} {$i < 6} {incr i} \
		{
		if { [info exists Int2a($c($i))] == 0 } \
			{
			set c($i) 0
			}
		}

	set s ""
	for {set i 0} {$i < 6} {incr i} \
		{
		append s $Int2a($c($i))
		}


	# Translate bogus characters to spaces
	# regsub -all {[^A-Za-z0-9 .,\+\*/()\-=]} $s " " s

	set s [string trimright $s " "]

	# Labels must be upper case.
	set s [string toupper $s]

	return $s
}


##############################################################
# Translate an ASCII label to internal 36-bit (4-1/2 byte)
# label into format.
# If it is all blanks, make it nulls.
#
# Input:	s	-ASCII string
#
# Returns:	5-byte binary string
##############################################################
proc MemoryLabel2Internal { s } \
{
	global A2int


	set s [ format "%-6s" $s ]
	set s [ string range $s 0 5 ]

	# Labels must be upper case.
	set s [string toupper $s]

	for {set i 0} {$i < 6} {incr i} \
		{
		set c($i) [string index $s $i]
		if { [info exists A2int($c($i))] == 0 } \
			{
			set n($i) 0
			} \
		else \
			{
			set n($i) $A2int($c($i))
			}

		}

	set b0 [binary format "H2" 00]
	set b1 [binary format "H2" 00]
	set b2 [binary format "H2" 00]
	set b3 [binary format "H2" 00]
	set b4 [binary format "H2" 00]

	set x1 [expr {int($n(0) / 4)}]
	set b0 [SetBitField $b0 4 7 $x1]

	set x2 [expr {$n(0) - ($x1 * 4)}]
	set b1 [SetBitField $b1 0 1 $x2]
	set b1 [SetBitField $b1 2 7 $n(1)]

	set b2 [SetBitField $b2 0 5 $n(2)]

	set x1 [expr {int($n(3) / 16)}]
	set b2 [SetBitField $b2 6 7 $x1]

	set x2 [expr {$n(3) - ($x1 * 16)}]
	set b3 [SetBitField $b3 0 3 $x2]

	set x1 [expr {int($n(4) / 4)}]
	set b3 [SetBitField $b3 4 7 $x1]

	set x2 [expr {$n(4) - ($x1 * 4)}]
	set b4 [SetBitField $b4 0 1 $x2]

	set b4 [SetBitField $b4 2 7 $n(5)]

	set bytes ""
	append bytes $b0 $b1 $b2 $b3 $b4

	return $bytes
}

##############################################################
# Clear the flags which indicate whether to hide a
# TV channel.
##############################################################

proc ClearHiddenTVChannelFlags { } \
{
	global TVHideByte

	for {set i 0} {$i < 9} {incr i} \
		{
		set TVHideByte($i) "00000000"
		}
	return
}

proc SetHiddenTVChannelFlags { } \
{
	global TVHideByte
	global TV

	for {set ch 0} {$ch < 70} {incr ch} \
		{
		set whichbyte [ expr { floor($ch / 8) } ]
		# set whichbyte [ expr { floor($whichbyte) } ]
		set whichbyte [ expr { int($whichbyte) } ]

		set whichbit [expr {$ch - ($whichbyte * 8)}]
		set whichbit [expr {7 - $whichbit}]


		set flag 0
		if {$TV($ch,freq) < .1} \
			{
			set flag 1
			}
	
		set TVHideByte($whichbyte) [string replace \
			$TVHideByte($whichbyte) \
			$whichbit $whichbit $flag]
		}

	return
}


###################################################################
# Decode the TV channel hidden bit flags.
###################################################################
proc DecodeHiddenTVChannelFlags { } \
{
	global ImageAddr
	global Mimage
	global TV

	scan $ImageAddr(TVHide) "%x" first

	set ch 0
	for {set j 0} {$j < 9} {incr j} \
		{
		set b [string index $Mimage $first]

		set k 7
		for {set i 0} {$i < 8} {incr i} \
			{
	
			set hidden [GetBit $b $k]

			if {$hidden} \
				{
				set TV($ch,hide) 1
				} \
			else \
				{
				set TV($ch,hide) 0
				}
			incr ch
			incr k -1
			}

		incr first
		}
	return
}


proc PrintHiddenTVChannelFlags { } \
{
	global TVHideByte

	for {set i 0} {$i < 9} {incr i} \
		{
		set s [binary format "B8" $TVHideByte($i)]
		binary scan $s "H2" s
		puts stderr "$i $TVHideByte($i) $s"
		}
	return
}


##############################################################
# Clear the flags which indicate whether to skip a
# TV channel.
##############################################################

proc ClearSkipTVChannelFlags { } \
{
	global TVSkipByte

	for {set i 0} {$i < 9} {incr i} \
		{
		set TVSkipByte($i) "00000000"
		}
	return
}

proc SetSkipTVChannelFlags { } \
{
	global TVSkipByte
	global TV

	for {set ch 0} {$ch < 70} {incr ch} \
		{
		set whichbyte [ expr { floor($ch / 8) } ]
		# set whichbyte [ expr { floor($whichbyte) } ]
		set whichbyte [ expr { int($whichbyte) } ]

		set whichbit [expr {$ch - ($whichbyte * 8)}]
		set whichbit [expr {7 - $whichbit}]


		set flag 0
		if {$TV($ch,skip)} \
			{
			set flag 1
			}
	
		set TVSkipByte($whichbyte) [string replace \
			$TVSkipByte($whichbyte) \
			$whichbit $whichbit $flag]
		}

	return
}


###################################################################
# Decode the TV channel skip bit flags.
###################################################################
proc DecodeSkipTVChannelFlags { } \
{
	global ImageAddr
	global Mimage
	global TV

	scan $ImageAddr(TVSkip) "%x" first

	set ch 0
	for {set j 0} {$j < 9} {incr j} \
		{
		set b [string index $Mimage $first]

		set k 7
		for {set i 0} {$i < 8} {incr i} \
			{
	
			set skipped [GetBit $b $k]

			if {$skipped} \
				{
				set TV($ch,skip) 1
				} \
			else \
				{
				set TV($ch,skip) 0
				}
			incr ch
			incr k -1
			}

		incr first
		}
	return
}


proc PrintSkipTVChannelFlags { } \
{
	global TVSkipByte

	for {set i 0} {$i < 9} {incr i} \
		{
		set s [binary format "B8" $TVSkipByte($i)]
		binary scan $s "H2" s
		puts stderr "$i $TVSkipByte($i) $s"
		}
	return
}
