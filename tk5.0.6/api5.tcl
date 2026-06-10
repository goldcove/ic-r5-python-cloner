####################################################################
# This file is part of tk5, a utility program for the
# ICOM IC-R5 receiver.
# 
#    Copyright (C) 2004, Bob Parnass
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
####################################################################

set RadioAddress	EE
set RadioAddressHex	\xEE
set PCAddress		EF
set PCAddressHex	\xEF

# set Nmessages		252
# set Nmessages		868
set Nmessages		896
set BytesPerMessage	64
set NBanks		18
set NChanPerBank	1000
set VNChanPerBank	1000
set ChanNumberRepeat	yes
set HasLabels           yes

###################################################################
# Starting address (in hexadecimal) for each field in
# the memory image.
###################################################################

set ImageAddr(MemoryFreqs)		00  ;# to C7F
set ImageAddr(MemoryMult)		02
set ImageAddr(MemoryToneFlag)		03  ;# bits 2, 3
set ImageAddr(MemoryModes)		03  ;# bits 4, 5
set ImageAddr(MemoryDuplex)		03  ;# bits 6, 7
set ImageAddr(MemoryOffset)		04
set ImageAddr(MemoryToneCode)		06
set ImageAddr(MemoryDToneCode)		07
set ImageAddr(MemorySteps)		08
set ImageAddr(MemoryLabels)		0B

set ImageAddr(SearchFreqFirst)		3E80
set ImageAddr(SearchDuplexFirst)	3E83
set ImageAddr(SearchOffsetFirst)	3E83
set ImageAddr(SearchModeFirst)		3E83
set ImageAddr(SearchToneFlagFirst)	3E83
set ImageAddr(SearchStepFirst)		3E88
set ImageAddr(SearchLabelFirst)		3E8B

set ImageAddr(SearchFreqSecond)		3E90
set ImageAddr(SearchDuplexSecond)	3E93
set ImageAddr(SearchOffsetSecond)	3E93
set ImageAddr(SearchModeSecond)		3E93
set ImageAddr(SearchToneFlagSecond)	3E93
set ImageAddr(SearchStepSecond)		3E98
set ImageAddr(SearchLabelSecond)	3E9B
set ImageAddr(TVMode)			4E20
set ImageAddr(TVFreq)			4E21
set ImageAddr(TVLabel)			4E24
set ImageAddr(MemorySkip)		5080
set ImageAddr(MemoryBankNumber)		5080
set ImageAddr(MemoryBankCh)		5081
set ImageAddr(SearchHideFirst)		5850
set ImageAddr(SearchHideSecond)		5852
set ImageAddr(TVHide)			58C0
set ImageAddr(TVSkip)			58CA
set ImageAddr(BankLabels)		5A10
set ImageAddr(SetMenuNumber)		6FAC
set ImageAddr(DialStep)			6FAD
set ImageAddr(Beep)			6FAF
set ImageAddr(Lamp)			6FB1
set ImageAddr(PowerSave)		6FB2
set ImageAddr(AMantenna)		6FB3
set ImageAddr(FMantenna)		6FB4
set ImageAddr(ExpandedSetModeFlag)	6FB5
set ImageAddr(LockEffect)		6FB6
set ImageAddr(DialAccel)		6FB7
set ImageAddr(Monitor)			6FB8
set ImageAddr(AutoOff)			6FB9
set ImageAddr(Pause)			6FBA
set ImageAddr(Resume)			6FBB
set ImageAddr(ScanStopBeep)		6FBC
set ImageAddr(Contrast)			6FC6

# fix me -- the following offests are incorrect
set ImageAddr(BandStackFreq)		0E10 ;# 10 of them
set ImageAddr(BandStackDuplex)		0E13
set ImageAddr(BandStackOffset)		0E13
set ImageAddr(BandStackModes)		0E16 ;# 10 of them
set ImageAddr(BandStackToneCode)	0E16
set ImageAddr(BandStackSkip)		0E17
set ImageAddr(BandStackToneFlag)	0E17
set ImageAddr(BandStackSteps)		0E17
set ImageAddr(BankScan)			0E65
set ImageAddr(UserComment)		0FA0
set ImageAddr(FileVersion)		0FB0


# Key lock effect

set LockEffect(NORMAL)	0
set LockEffect(NO_SQL)	1
set LockEffect(NO_VOL)	2
set LockEffect(ALL)	3

set RLockEffect(0)	NORMAL
set RLockEffect(1)	NO_SQL
set RLockEffect(2)	NO_VOL
set RLockEffect(3)	ALL



# AM antenna choices
set AMant(EXT)	0
set AMant(INTERNAL_BAR)	1

set RAMant(0)	EXT
set RAMant(1)	INTERNAL_BAR

# FM antenna choices
set FMant(EXT)	0
set FMant(EARPHONE)	1

set RFMant(0)	EXT
set RFMant(1)	EARPHONE


set BankID(0)	A
set BankID(1)	B
set BankID(2)	C
set BankID(3)	D
set BankID(4)	E
set BankID(5)	F
set BankID(6)	G
set BankID(7)	H
set BankID(8)	J
set BankID(9)	L
set BankID(10)	N
set BankID(11)	O
set BankID(12)	P
set BankID(13)	Q
set BankID(14)	R
set BankID(15)	T
set BankID(16)	U
set BankID(17)	Y

set RBankID(A)	0
set RBankID(B)	1
set RBankID(C)	2
set RBankID(D)	3
set RBankID(E)	4
set RBankID(F)	5
set RBankID(G)	6
set RBankID(H)	7
set RBankID(J)	8
set RBankID(L)	9
set RBankID(N)	10
set RBankID(O)	11
set RBankID(P)	12
set RBankID(Q)	13
set RBankID(R)	14
set RBankID(T)	15
set RBankID(U)	16
set RBankID(Y)	17


set Band(USA,0,low)		.005
set Band(USA,0,high)		1.620
set Band(USA,1,low)		1.625
set Band(USA,1,high)		29.995
set Band(USA,2,low)		30.000
set Band(USA,2,high)		107.995
set Band(USA,3,low)		76.000	;# Euro models
set Band(USA,3,high)		76.995	;# Euro models
set Band(USA,4,low)		108.000
set Band(USA,4,high)		135.995
set Band(USA,5,low)		136.000
set Band(USA,5,high)		255.095
set Band(USA,6,low)		255.100
set Band(USA,6,high)		382.095
set Band(USA,7,low)		382.100
set Band(USA,7,high)		769.795
set Band(USA,8,low)		769.800
set Band(USA,8,high)		960.095
set Band(USA,9,low)		960.100
set Band(USA,9,high)		1599.995

##########################################################
# Translation tables
##########################################################

# Internal 6-bit number to an ASCII character.
# (Used for memory channel labels)

set A2int(\()	8
set A2int(\))	9
set A2int(*)	10
set A2int(+)	11
set A2int(-)	13
set A2int(=)	29
set A2int(,)	14
set A2int(/)	15
set A2int(|)	26

set A2int(0)	16
set A2int(1)	17
set A2int(2)	18
set A2int(3)	19
set A2int(4)	20
set A2int(5)	21
set A2int(6)	22
set A2int(7)	23
set A2int(8)	24
set A2int(9)	25
set A2int(A)	33
set A2int(B)	34
set A2int(C)	35
set A2int(D)	36
set A2int(E)	37
set A2int(F)	38
set A2int(G)	39
set A2int(H)	40
set A2int(I)	41
set A2int(J)	42
set A2int(K)	43
set A2int(L)	44
set A2int(M)	45
set A2int(N)	46
set A2int(O)	47
set A2int(P)	48
set A2int(Q)	49
set A2int(R)	50
set A2int(S)	51
set A2int(T)	52
set A2int(U)	53
set A2int(V)	54
set A2int(W)	55
set A2int(X)	56
set A2int(Y)	57
set A2int(Z)	58

set Int2a(0)	" "
set Int2a(8)	"("
set Int2a(9)	")"
set Int2a(10)	"*"
set Int2a(11)	"+"
set Int2a(13)	"-"
set Int2a(29)	"="
set Int2a(14)	","
set Int2a(15)	"/"
set Int2a(26)	"|"

set Int2a(16)	0
set Int2a(17)	1
set Int2a(18)	2
set Int2a(19)	3
set Int2a(20)	4
set Int2a(21)	5
set Int2a(22)	6
set Int2a(23)	7
set Int2a(24)	8
set Int2a(25)	9
set Int2a(33)	A
set Int2a(34)	B
set Int2a(35)	C
set Int2a(36)	D
set Int2a(37)	E
set Int2a(38)	F
set Int2a(39)	G
set Int2a(40)	H
set Int2a(41)	I
set Int2a(42)	J
set Int2a(43)	K
set Int2a(44)	L
set Int2a(45)	M
set Int2a(46)	N
set Int2a(47)	O
set Int2a(48)	P
set Int2a(49)	Q
set Int2a(50)	R
set Int2a(51)	S
set Int2a(52)	T
set Int2a(53)	U
set Int2a(54)	V
set Int2a(55)	W
set Int2a(56)	X
set Int2a(57)	Y
set Int2a(58)	Z


# Lamp operation
set Lamp(OFF)	0
set Lamp(ON)	1
set Lamp(AUTO)	2

set RLamp(0)	OFF
set RLamp(1)	ON
set RLamp(2)	AUTO

# Dial select
set Dial(100kHz)	0
set Dial(1MHz)		1
set Dial(10MHz)		2

set RDial(0)	100kHz
set RDial(1)	1MHz
set RDial(2)	10MHz

# Monitor key
set Monitor(PUSH)	0
set Monitor(HOLD)	1

set RMonitor(0)	PUSH
set RMonitor(1)	HOLD

# Auto Power Off

set AutoOff(OFF)	0
set AutoOff(30)		1	
set AutoOff(60)		2
set AutoOff(90)		3
set AutoOff(120)	4

set RAutoOff(0)		OFF
set RAutoOff(1)		30
set RAutoOff(2)		60
set RAutoOff(3)		90
set RAutoOff(4)		120


# Scan Pause
set Pause(2)	0
set Pause(4)	1
set Pause(6)	2
set Pause(8)	3
set Pause(10)	4
set Pause(12)	5
set Pause(14)	6
set Pause(16)	7
set Pause(18)	8
set Pause(20)	9
set Pause(HOLD)	10

set RPause(0)	2
set RPause(1)	4
set RPause(2)	6
set RPause(3)	8
set RPause(4)	10
set RPause(5)	12
set RPause(6)	14
set RPause(7)	16
set RPause(8)	18
set RPause(9)	20
set RPause(10)	HOLD



# Scan Resume
set Resume(0)		0
set Resume(1)		1
set Resume(2)		2
set Resume(3)		3
set Resume(4)		4
set Resume(5)		5
set Resume(HOLD)	6

set RResume(0)	0
set RResume(1)	1
set RResume(2)	2
set RResume(3)	3
set RResume(4)	4
set RResume(5)	5
set RResume(6)	HOLD


set Step(5)		"0"
set Step(6.25)		"1"
set Step(8.33)		"2"
set Step(9)		"3"
set Step(10)		"4"
set Step(12.5)		"5"
set Step(15)		"6"
set Step(20)		"7"
set Step(25)		"8"
set Step(30)		"9"
set Step(50)		"10"
set Step(100)		"11"

set RStep(0)		"5"
set RStep(1)		"6.25"
set RStep(2)		"8.33"
set RStep(3)		"9"
set RStep(4)		"10"
set RStep(5)		"12.5"
set RStep(6)		"15"
set RStep(7)		"20"
set RStep(8)		"25"
set RStep(9)		"30"
set RStep(10)		"50"
set RStep(11)		"100"

# 2-bit value used to encode frequencies.
# Frequencies consist of a step and a multiplier.
set RIstep(0)		5
set RIstep(1)		6.25
set RIstep(2)		8.33
set RIstep(3)		9

set Istep(5)		0
set Istep(6.25)		1
set Istep(8.33)		2
set Istep(9)		3

# Correspondence between the step size the user sees
# and the step used to represent the frequency internally.
set Wstep(5)	5
set Wstep(6.25)	6.25
set Wstep(8.33)	8.33
set Wstep(9)	9
set Wstep(10)	5
set Wstep(12.5)	6.25
set Wstep(15)	5
set Wstep(20)	5
set Wstep(25)	5
set Wstep(30)	5
set Wstep(50)	5
set Wstep(100)	5
set Wstep(200)	5

set Mode(M0) "0"
set Mode(M7) "7"
set Mode(M8) "8"
set Mode(M9) "9"
set Mode(MA) "A"
set Mode(MB) "B"
set Mode(MC) "C"
set Mode(MD) "D"
set Mode(ME) "E"
set Mode(MF) "F"

set Mode(NFM) "0"
set Mode(WFM) "1"
set Mode(AM) "2"

set RMode(0) NFM
set RMode(1) WFM
set RMode(2) AM

set Skip(scan)	0
set Skip(skip)	1
set Skip(pskip)	3

set RSkip(0)	" "
set RSkip(1)	skip
set RSkip(2)	" "
set RSkip(3)	pskip


# Dial select step
set RDial(0)	100kHz
set RDial(1)	1MHz
set RDial(2)	10MHz


##########################################################
# Encoding in a .ICF file.
##########################################################
set Icf2Hex(g)	0
set Icf2Hex(h)	1
set Icf2Hex(i)	2
set Icf2Hex(j)	3
set Icf2Hex(k)	4
set Icf2Hex(l)	5
set Icf2Hex(m)	6
set Icf2Hex(n)	7
set Icf2Hex(o)	8
set Icf2Hex(p)	9
set Icf2Hex(x)	a
set Icf2Hex(y)	b
set Icf2Hex(z)	c
set Icf2Hex({)	d
set Icf2Hex(|)	e
set Icf2Hex(})	f

set Hex2Digit(30)	0
set Hex2Digit(31)	1
set Hex2Digit(32)	2
set Hex2Digit(33)	3
set Hex2Digit(34)	4
set Hex2Digit(35)	5
set Hex2Digit(36)	6
set Hex2Digit(37)	7
set Hex2Digit(38)	8
set Hex2Digit(39)	9
set Hex2Digit(41)	A
set Hex2Digit(42)	B
set Hex2Digit(43)	C
set Hex2Digit(44)	D
set Hex2Digit(45)	E
set Hex2Digit(46)	F

set Digit2Hex(0)	30
set Digit2Hex(1)	31
set Digit2Hex(2)	32
set Digit2Hex(3)	33
set Digit2Hex(4)	34
set Digit2Hex(5)	35
set Digit2Hex(6)	36
set Digit2Hex(7)	37
set Digit2Hex(8)	38
set Digit2Hex(9)	39
set Digit2Hex(A)	41
set Digit2Hex(B)	42
set Digit2Hex(C)	43
set Digit2Hex(D)	44
set Digit2Hex(E)	45
set Digit2Hex(F)	46



set ToneFlag(0)	off	;# no TSQL or DTCS
set ToneFlag(1)	t	;# TSQL
set ToneFlag(2)	b	;# TQSL with pocket beep
set ToneFlag(3)	d	;# DTCS
set ToneFlag(4)	p	;# DTCS with pocket beep

set RToneFlag(off)	0
set RToneFlag(t)	1	;# TSQL
set RToneFlag(b)	2	;# TSQL with pocket beep
set RToneFlag(d)	3	;# DTCS
set RToneFlag(p)	4	;# DTCS with pocket beep


# CTCSS codes (there are 50 codes total)
set CtcssBias		0

set Ctcss(0.0)		0
set Ctcss(67.0)		0
set Ctcss(69.3)		1
set Ctcss(71.9)		2
set Ctcss(74.4)		3
set Ctcss(77.0)		4
set Ctcss(79.7)		5

set Ctcss(82.5)		6
set Ctcss(85.4)		7
set Ctcss(88.5)		8
set Ctcss(91.5)		9
set Ctcss(94.8)		10
set Ctcss(97.4)		11
set Ctcss(100.0)	12
set Ctcss(103.5)	13
set Ctcss(107.2)	14
set Ctcss(110.9)	15

set Ctcss(114.8)	16
set Ctcss(118.8)	17
set Ctcss(123.0)	18
set Ctcss(127.3)	19
set Ctcss(131.8)	20
set Ctcss(136.5)	21
set Ctcss(141.3)	22
set Ctcss(146.2)	23
set Ctcss(151.4)	24
set Ctcss(156.7)	25

set Ctcss(159.8)	26
set Ctcss(162.2)	27
set Ctcss(165.5)	28
set Ctcss(167.9)	29
set Ctcss(171.3)	30
set Ctcss(173.8)	31
set Ctcss(177.3)	32
set Ctcss(179.9)	33
set Ctcss(183.5)	34
set Ctcss(186.2)	35

set Ctcss(189.9)	36
set Ctcss(192.8)	37
set Ctcss(196.6)	38
set Ctcss(199.5)	39
set Ctcss(203.5)	40
set Ctcss(206.5)	41
set Ctcss(210.7)	42
set Ctcss(218.1)	43
set Ctcss(225.7)	44
set Ctcss(229.1)	45

set Ctcss(233.6)	46
set Ctcss(241.8)	47
set Ctcss(250.3)	48
set Ctcss(254.1)	49


set RCtcss(0)	67.0
set RCtcss(1)	69.3
set RCtcss(2)	71.9
set RCtcss(3)	74.4
set RCtcss(4)	77.0
set RCtcss(5)	79.7
set RCtcss(6)	82.5
set RCtcss(7)	85.4
set RCtcss(8)	88.5
set RCtcss(9)	91.5

set RCtcss(10)	94.8
set RCtcss(11)	97.4
set RCtcss(12)	100.0
set RCtcss(13)	103.5
set RCtcss(14)	107.2
set RCtcss(15)	110.9
set RCtcss(16)	114.8
set RCtcss(17)	118.8
set RCtcss(18)	123.0
set RCtcss(19)	127.3

set RCtcss(20)	131.8
set RCtcss(21)	136.5
set RCtcss(22)	141.3
set RCtcss(23)	146.2
set RCtcss(24)	151.4
set RCtcss(25)	156.7
set RCtcss(26)	159.8
set RCtcss(27)	162.2
set RCtcss(28)	165.5
set RCtcss(29)	167.9

set RCtcss(30)	171.3
set RCtcss(31)	173.8
set RCtcss(32)	177.3
set RCtcss(33)	179.9
set RCtcss(34)	183.5
set RCtcss(35)	186.2
set RCtcss(36)	189.9
set RCtcss(37)	192.8
set RCtcss(38)	196.6
set RCtcss(39)	199.5

set RCtcss(40)	203.5
set RCtcss(41)	206.5
set RCtcss(42)	210.7
set RCtcss(43)	218.1
set RCtcss(44)	225.7
set RCtcss(45)	229.1
set RCtcss(46)	233.6
set RCtcss(46)	241.8
set RCtcss(48)	250.3
set RCtcss(49)	254.1

# DCS / DTCS digital coded scquelh

set Dcs(023)	0
set Dcs(025)	1
set Dcs(026)	2
set Dcs(031)	3
set Dcs(032)	4
set Dcs(036)	5
set Dcs(043)	6
set Dcs(047)	7
set Dcs(051)	8
set Dcs(053)	9
set Dcs(054)	10
set Dcs(065)	11
set Dcs(071)	12
set Dcs(072)	13
set Dcs(073)	14
set Dcs(074)	15
set Dcs(114)	16
set Dcs(115)	17
set Dcs(116)	18
set Dcs(122)	19
set Dcs(125)	20
set Dcs(131)	21
set Dcs(132)	22
set Dcs(134)	23
set Dcs(143)	24
set Dcs(145)	25
set Dcs(152)	26
set Dcs(155)	27
set Dcs(156)	28
set Dcs(162)	29
set Dcs(165)	30
set Dcs(172)	31
set Dcs(174)	32
set Dcs(205)	33
set Dcs(212)	34
set Dcs(223)	35
set Dcs(225)	36
set Dcs(226)	37
set Dcs(243)	38
set Dcs(244)	39
set Dcs(245)	40
set Dcs(246)	41
set Dcs(251)	42
set Dcs(252)	43
set Dcs(255)	44
set Dcs(261)	45
set Dcs(263)	46
set Dcs(265)	47
set Dcs(266)	48
set Dcs(271)	49
set Dcs(274)	50
set Dcs(306)	51
set Dcs(311)	52
set Dcs(315)	53
set Dcs(325)	54
set Dcs(331)	55
set Dcs(332)	56
set Dcs(343)	57
set Dcs(346)	58
set Dcs(351)	59
set Dcs(356)	60
set Dcs(364)	61
set Dcs(365)	62
set Dcs(371)	63
set Dcs(411)	64
set Dcs(412)	65
set Dcs(413)	66
set Dcs(423)	67
set Dcs(431)	68
set Dcs(432)	69
set Dcs(445)	70
set Dcs(446)	71
set Dcs(452)	72
set Dcs(454)	73
set Dcs(455)	74
set Dcs(462)	75
set Dcs(464)	76
set Dcs(465)	77
set Dcs(466)	78
set Dcs(503)	79
set Dcs(506)	80
set Dcs(516)	81
set Dcs(523)	82
set Dcs(526)	83
set Dcs(532)	84
set Dcs(546)	85
set Dcs(565)	86
set Dcs(606)	87
set Dcs(612)	88
set Dcs(624)	89
set Dcs(627)	90
set Dcs(631)	91
set Dcs(632)	92
set Dcs(654)	93
set Dcs(662)	94
set Dcs(664)	95
set Dcs(703)	96
set Dcs(712)	97
set Dcs(723)	98
set Dcs(731)	99
set Dcs(732)	100
set Dcs(734)	101
set Dcs(743)	102
set Dcs(754)	103


set RDcs(0)	"023"
set RDcs(1)	"025"
set RDcs(2)	"026"
set RDcs(3)	"031"
set RDcs(4)	"032"
set RDcs(5)	"036"
set RDcs(6)	"043"
set RDcs(7)	"047"
set RDcs(8)	"051"
set RDcs(9)	"053"
set RDcs(10)	"054"
set RDcs(11)	"065"
set RDcs(12)	"071"
set RDcs(13)	"072"
set RDcs(14)	"073"
set RDcs(15)	"074"
set RDcs(16)	"114"
set RDcs(17)	"115"
set RDcs(18)	"116"
set RDcs(19)	"122"
set RDcs(20)	"125"
set RDcs(21)	"131"
set RDcs(22)	"132"
set RDcs(23)	"134"
set RDcs(24)	"143"
set RDcs(25)	"145"
set RDcs(26)	"152"
set RDcs(27)	"155"
set RDcs(28)	"156"
set RDcs(29)	"162"
set RDcs(30)	"165"
set RDcs(31)	"172"
set RDcs(32)	"174"
set RDcs(33)	"205"
set RDcs(34)	"212"
set RDcs(35)	"223"
set RDcs(36)	"225"
set RDcs(37)	"226"
set RDcs(38)	"243"
set RDcs(39)	"244"
set RDcs(40)	"245"
set RDcs(41)	"246"
set RDcs(42)	"251"
set RDcs(43)	"252"
set RDcs(44)	"255"
set RDcs(45)	"261"
set RDcs(46)	"263"
set RDcs(47)	"265"
set RDcs(48)	"266"
set RDcs(49)	"271"
set RDcs(50)	"274"
set RDcs(51)	"306"
set RDcs(52)	"311"
set RDcs(53)	"315"
set RDcs(54)	"325"
set RDcs(55)	"331"
set RDcs(56)	"332"
set RDcs(57)	"343"
set RDcs(58)	"346"
set RDcs(59)	"351"
set RDcs(60)	"356"
set RDcs(61)	"364"
set RDcs(62)	"365"
set RDcs(63)	"371"
set RDcs(64)	"411"
set RDcs(65)	"412"
set RDcs(66)	"413"
set RDcs(67)	"423"
set RDcs(68)	"431"
set RDcs(69)	"432"
set RDcs(70)	"445"
set RDcs(71)	"446"
set RDcs(72)	"452"
set RDcs(73)	"454"
set RDcs(74)	"455"
set RDcs(75)	"462"
set RDcs(76)	"464"
set RDcs(77)	"465"
set RDcs(78)	"466"
set RDcs(79)	"503"
set RDcs(80)	"506"
set RDcs(81)	"516"
set RDcs(82)	"523"
set RDcs(83)	"526"
set RDcs(84)	"532"
set RDcs(85)	"546"
set RDcs(86)	"565"
set RDcs(87)	"606"
set RDcs(88)	"612"
set RDcs(89)	"624"
set RDcs(90)	"627"
set RDcs(91)	"631"
set RDcs(92)	"632"
set RDcs(93)	"654"
set RDcs(94)	"662"
set RDcs(95)	"664"
set RDcs(96)	"703"
set RDcs(97)	"712"
set RDcs(98)	"723"
set RDcs(99)	"731"
set RDcs(100)	"732"
set RDcs(101)	"734"
set RDcs(102)	"743"
set RDcs(103)	"754"

##########################################################
#
# Initialize a few global variables.
#
# Return the pathname to a configuration file in the user's
# HOME directory
#
# Returns:
#	list of 2 elements:
#		-name of configuration file
#		-name of label file
#
##########################################################
proc InitStuff { } \
{
	global argv0
	global DisplayFontSize
	global env
	global Home
	global Pgm
	global RootDir
	global tcl_platform


	set platform $tcl_platform(platform) 
	switch -glob $platform \
		{
		{unix} \
			{
			set Home $env(HOME)
			set rcfile [format "%s/.tk5rc" $Home]
			set labelfile [format "%s/.tk5la" $Home]

			set DisplayFontSize "Courier 56 bold"
			}
		{macintosh} \
			{

			# Configuration file should be
			# named $HOME/.tk5rc

			# Use forward slashes within Tcl/Tk
			# instead of colons.

			set Home $env(HOME)
			regsub -all {:} $Home "/" Home
			set rcfile [format "%s/.tk5rc" $Home]
			set labelfile [format "%s/.tk5la" $Home]

			# The following font line may need changing.
			set DisplayFontSize "Courier 56 bold"
			}
		{windows} \
			{

			# Configuration file should be
			# named $tk5/tk5.ini
			# Use forward slashes within Tcl/Tk
			# instead of backslashes.

			set Home $env(tk5)
			regsub -all {\\} $Home "/" Home
			set rcfile [format "%s/tk5.ini" $Home]
			set labelfile [format "%s/tk5.lab" $Home]

			set DisplayFontSize "Courier 28 bold"
			}
		default \
			{
			puts "Operating System $platform not supported."
			exit 1
			}
		}
	set Home $env(HOME)
	# set Pgm [string last "/" $argv0]


	set lst [list $rcfile $labelfile]
	return $lst
}

###################################################################
# Disable computer control of radio.
###################################################################
proc DisableCControl { } \
{
	global Sid

	after 500

	catch {close $Sid}
	return
}

##########################################################
# Copy memory image to radio
#
# Returns:
#	0	-ok
#	1	-error
#	2	-error, cannot read radio version info
##########################################################
proc WriteImage { }\
{
	global GlobalParam
	global Mimage
	global Nmessages
	global Sid

	set totmsgs $Nmessages


	set s [GetModelInfo]
	binary scan $s "H*" x
	set GlobalParam(RadioVersion) $x

	if {$GlobalParam(RadioVersion) == ""} \
		{
		# Error while asking radio for version info.
		return 2
		}
	# Create and display progress bar.
	toplevel .pbw
	wm title .pbw "Writing to radio"
	grab set .pbw
	set p [MakeWaitWindow .pbw.g 0 PaleGreen]
	set pc 0
	gauge_value $p $pc
	update


	set db 0

	# Open serial port.
	OpenDevice

	# Write "clone in mode" command, including
	# radio version information.

	SendCloneIn

	set bptr 0
	set maddr 0

	# For each message.
	for {set i 0} {$i < $Nmessages} {incr i} \
		{
		# Variable line contains info in the format it
		# will be written to the radio.
		set line ""

		# Variable bline contains packed hex gulp.
		set bline ""

		# A message sent to the radio consists of:
		# E4 - Payload Data Command code
		# Memory Gulp (unpacked so 2 bytes represent 1 byte):
		#
		# memory address (4 bytes unpacked)
		# number of bytes (2 bytes unpacked)
		# image data (64 bytes unpacked)

		append line [binary format "H2" E4 ]

		# Memory address
		set hmaddr [format "%04x" $maddr]
		set bmaddr [binary format "H4" $hmaddr]
		append bline $bmaddr

		# Byte count
		# set hn [binary format "H2" 10]
		set hn [binary format "H2" 20]
		append bline $hn

		# Copy the next chunk of the image

		# set end [expr {$bptr + 15}]
		set end [expr {$bptr + 31}]
		set s [string range $Mimage $bptr $end]
		append bline $s

		#
		# Calulate and append the checksum byte
		#

		# Checksum is decimal.
		set cksum [CalcCheckSum $bline]

		# Convert checksum to hexadecimal.
		set hcksum [format "%02x" $cksum]

		set bcksum [binary format "H2" $hcksum ]

		append bline $bcksum

		# Unpack the binary stuff.
		# This makes it twice as long.

		set msg [DumpBinary $bline]

		# puts stderr "WriteImage: before packing:\n$msg\n"
		set ubuf [UnpackString $bline]
		append line $ubuf

		SendCmd $Sid $line

		# Read back the message we just sent to "clean out"
		# the serial buffers.
		# If we don't do this, WindowsXP will hang after
		# the download to the radio is completed.


		if { [ReadEcho $line] } \
			{
			# Error.
			# We did not read back what we wrote.
			puts stderr "WriteImage: Error while reading echo from message $i."
			# Data xfer suceeded.
			# Zap the progress bar.
			grab release .pbw
			catch {destroy .pbw}

			# Close serial port.
			DisableCControl

			return 1
			}

		# incr bptr 16
		# incr maddr 16
		incr bptr 32
		incr maddr 32

		# Update progress bar widget.
		set pc [ expr $i * 100 / $totmsgs ]
		if {$pc >= 100.0} \
			{
			set pc 99
			}
		gauge_value $p $pc
		}


	SendTermination
	if {[GetTerminationResult]} \
		{
		# Data xfer failed.
		set code 1
		} \
	else \
		{
		# Data xfer suceeded.
		set code 0
		}

	# Zap the progress bar.
	grab release .pbw
	catch {destroy .pbw}

	# Close serial port.
	DisableCControl

	return $code
}


##########################################################
# Copy memory image from radio
##########################################################
proc ReadImage { } \
{
	global GlobalParam
	global Mimage
	global Nmessages
	global Pgm
	global Sid

	set code 0


	set s [GetModelInfo]
	binary scan $s "H*" x
	set GlobalParam(RadioVersion) $x

	if {$GlobalParam(RadioVersion) == ""} \
		{
		# Error while asking radio for version info.
		return 2
		}

	# Create and display progress bar.
	toplevel .pbw
	wm title .pbw "Reading radio"
	grab set .pbw
	set p [MakeWaitWindow .pbw.g 0 PaleGreen]
	set pc 0
	gauge_value $p $pc
	update

	set Mimage ""

	# Open serial port.
	OpenDevice


	SendCloneOut

	# For each message.
	for {set i 0} {$i < 5000} {incr i} \
		{
		set line [ReadXferRx]
		set len [string length $line]

		# puts stderr "ReadImage: i= $i, len= $len"

		# Update progress bar widget.
		set pc [ expr {$i * 100 / $Nmessages} ]
		if {$pc >= 100.0} \
			{
			set pc 99
			}
		gauge_value $p $pc

		set cc [string range $line 0 0]
		binary scan $cc "H2" s
		# Examine the command code byte.
		if { [string compare -nocase -length 1 $cc \xe5] == 0} \
			{
			# This was a termination message.
			# There is no more data to read.
			set code 0
			# puts stderr "Read $i records."
			break
			}

		if {$len != 73} \
			{
			# Error while reading from radio.
			set code -1
			break
			}

		# Got a data record.
		# Temorarily convert it from funky unpacked
		# format to binary format.
		# Then, perform a checksum calculation on it.

		# set pline [PackString [string range $line 1 42]]
		set pline [PackString [string range $line 1 73]]
		set plen [string length $pline]

		# puts stderr "ReadXferRx: line length is: $len"
	
		# set dbuf [string range $pline 0 18] 
		# set cksum [string range $pline 19 19] 
		set dbuf [string range $pline 0 34] 
		set cksum [string range $pline 35 35] 
		set ccksum [CalcCheckSum $dbuf]
	
		binary scan $cksum "H*" icksum
		scan $icksum "%x" cksum
	
#		puts stderr [format "CHECKSUM radio: %s, calculated: %s\n" \
				$cksum $ccksum]
	
		if {$cksum != $ccksum} \
			{
			set msg [format \
				"%s: error, checksum mismatch, radio: %s, calculated: %s\n" \
				$Pgm $cksum $ccksum]
			Tattle $msg
			tk_dialog .error "Checksum error while reading" \
				$msg error 0 OK

			# Close serial port.
			DisableCControl

			exit
			}


		# Strip off memory address and count bytes.
		set buf [string range $dbuf 3 end]
		append Mimage $buf
		}

	set GlobalParam(NmsgsRead) $i


	# Zap the progress bar.
	grab release .pbw
	destroy .pbw

	# Close serial port.
	DisableCControl

	return $code
}



###################################################################
# this takes a string and converts the
# first character in it to an integer
#   in the range 0-255
#
# if the string is empty, returns an empty string
###################################################################

proc Char2Int { c } \
{
	set tmp ""

	set n [binary scan $c "c" tmp]

	if { ($n == 1) && ($tmp < 0) } \
		{
		# Force negative number to be positive

		set tmp [expr $tmp + 256]
		}
	return "$tmp"
}


###################################################################
# Calculate the 2s complement modulo 256 checksum byte for a string by
# summing all the ascii character values,
# getting the 2s complement, then modulo 256.
###################################################################

proc CalcCheckSum { s } \
{

	set len [string length $s]
	set sum 0

	binary scan $s "H*" x

#	regsub -all ".." $x { \0} x
#	puts stderr "CalcCheckSum: $x"

	for {set i 0} {$i < $len} {incr i} \
		{
         	set c [string index $s $i]
         	set tmp [Char2Int $c]

		# set xtmp [format "%x" $tmp]
		# puts stderr "CalcCheckSum: $i (of $len): xtmp = $xtmp"

         	set sum [expr {$sum + $tmp}]
		}

#	set xsum [format "%x" $sum]
#	puts stderr "CalcCheckSum: xsum = $xsum"
#
	set sum [expr {0 - $sum}]

#	set ysum [format "%x" $sum]
#	puts stderr "CalcCheckSum: ysum = $ysum"

	set sum [expr $sum % 256]

#	set zsum [format "%x" $sum]
#	puts stderr "CalcCheckSum: zsum = $zsum"

	return $sum
 }

###################################################################
# Create a string of "n" bytes where each byte is \xff (255 decimal).
###################################################################

proc Padff { n } \
{
	set ffrecd ""
	set byte [binary format "H2" ff]

	for {set i 0} {$i < $n} {incr i} \
		{
		append ffrecd $byte
		}
	return $ffrecd
}



##########################################################
# Open the serial port.
#
# Notes:
#	This procedure sets the global variable Sid.
#
# Returns:
#	"" -ok
#	This procedure exits if there is an error in opening or
#	configuring the serial port.
#
##########################################################

proc OpenDevice {} \
{
	global Pgm
	global GlobalParam
	global Sid
	global tcl_platform

	set msg ""

	 set platform $tcl_platform(platform) 
	 switch -glob $platform \
		{
		{unix} \
			{

			if [ catch { open $GlobalParam(Device) "r+"} \
				Sid] \
				{
				set msg "Error while trying to open "
				append msg "serial port "
				append msg $GlobalParam(Device)
				}
			}
		{macintosh} \
			{
			if [ catch { open $GlobalParam(Device) "r+"} \
				Sid] \
				{
				set msg "Error while trying to open "
				append msg "serial port "
				append msg $GlobalParam(Device)
				}
			}
		{windows} \
			{
			if [ catch { open $GlobalParam(Device) RDWR} \
				Sid] \
				{
				set msg "Error while trying to open "
				append msg "serial port "
				append msg $GlobalParam(Device)
				}
			}
		default \
			{
			set msg "$Pgm error: Platform $platform "
			append msg "not supported."
			}
		}

	waiter 500

	# If port opened ok,
	if { $msg == "" } \
		{
		# Set up the serial port parameters (similar to stty)
		if {[SetSerialP n]} \
			{
			set msg "$Pgm error: "
			append msg "Cannot configure serial port\n"
			append msg "$GlobalParam(Device)"
			# Close serial port.
			DisableCControl
			}
		}

	if {$msg != ""} \
		{
		Tattle $msg
		tk_dialog .opnerror "Serial port error" \
			$msg error 0 OK
		exit
		}
	waiter 1000

	return "" 
}

###################################################################
# Return the preamble for messages sent from computer to radio.
###################################################################
proc MsgPreamble { } \
{
	global RadioAddress
	global PCAddress

	# byte 0 = FE
	# byte 1 = FE
	# byte 2 = (radio's unique address)
	# byte 3 = (computer's address)

	set preamble [ binary format "H2H2H2H2" fe fe \
		$RadioAddress $PCAddress ]

	return $preamble
}


###################################################################
#
# Send "command" to radio.
# Write command to error stream if Debug flag is set.
#
###################################################################
proc SendCmd { Sid command } \
{
	global GlobalParam


	set cmd [MsgPreamble]
	append cmd $command
	append cmd [binary format "H2" fd]


	if { $GlobalParam(Debug) > 0 } \
		{
		binary scan $cmd "H*" s

		# Insert a space between each pair of hex digits
		# to improve readability.

		regsub -all ".." $s { \0} s
		set msg ""
		set msg [ append msg "---> " $s]
		Tattle $msg
		}

	# Write data to serial port.

	puts -nonewline $Sid $cmd
	flush $Sid
	return
}

###################################################################
# Interrogate radio for version/model/user information
#
# Returns:
#	- a 4 byte version of IC-R5 we have.
#	- empty string if error occurred.
#
# Notes:
#	My IC-R5 returns this string:
#	21 27 00 01 20 20 20 20 ... 20 05 09 00
###################################################################
proc GetModelInfo { } \
{
	global GlobalParam
	global Sid

	# Open serial port.
	OpenDevice

	set cmd [ binary format "H2H2H2H2H2" E0 00 00 00 00 ]

	SendCmd $Sid $cmd

	while {1} \
		{
		# Read messages until we find the
		# one which matches this request.

		set line [ReadRx]

		set len [string length $line]
		set cn [string range $line 0 0]
		binary scan $cn "H*" cn

		# If this is a response to our request.
		if {$cn == "e1"} {break}

		# If we got an NG message from the radio.
		if {$cn == "fa"} {break}
		}

	set len [string length $line]

	# Check if radio sent NG msg. 
	if {$len == 1}  \
		{
		set line ""
		} \
	else \
		{
		set line [string range $line 1 4 ]
		}

	binary scan $line "H*" x
	set GlobalParam(RadioVersion) $x
#	puts stderr "GetModelInfo: RadioVersion= $x"


	# Close serial port.
	DisableCControl

	return $line
}

###################################################################
# Read a CI-V message from the serial port.
#
# Inputs:
#	any	- 0 means ignore messages with a "from address"
#		field which indicates the message is from
#		this computer.
#		- 1 means return any message
#
# Strip off the 2 address bytes.
#
# Returns: the message without the address fields.
###################################################################
proc ReadRx { {any 0} } \
{
	global GlobalParam

	global RadioAddressHex
	global PCAddressHex

	set ignored "ignoring previous echo msg from the radio."

	set line {} 

	while { 1 } \
		{
		# Read message from the bus.

		set line [ReadCIV]

		if { [string length $line] == 0} \
			{
			# Got a read error.
			break
			}

		# Examine the address bytes.
		set to [string range $line 0 0]
		set from [string range $line 1 1]

		if { ([string compare -nocase -length 1 \
			$to $PCAddressHex] != 0) \
			&& ([string compare -nocase -length 1 \
			$to $RadioAddressHex] != 0)} \
			{
			puts stderr "ReadRx: UNKNOWN MESSAGE"
			continue;
			}

		if { $any == 0 } \
			{
			if { [string compare -nocase -length 1 \
				$from $PCAddressHex] == 0} \
				{
				# This message is from us,

				# so ignore it and read again.
				continue
				} \
			} 

		# Strip of the address bytes.
		set line [string range $line 2 end]
		set len [string length $line]

		break
		}
	return $line
}


###################################################################
# Read a CI-V data transfer message from the serial port.
#
# INPUTS:
#	any	- 0 means ignore messages with a "from address"
#		field which indicates the message is from
#		this computer.
#		- 1 means return any message
#
# DESCRIPTION:
#	Read a data transfer message.
#	Calculate a checksum and compare it to the
#		checksum in the message.
#	Return an empty message if there is an error.
#	Strip off the 2 address bytes.
#
# Returns: the data transfer message without the address fields.
###################################################################
proc ReadXferRx { {any 0} } \
{
	global GlobalParam

	global RadioAddressHex
	global PCAddressHex

	set ignored "ignoring previous echo msg from the radio."

	set line {} 

	while { 1 } \
		{
		# Read message from the bus.

		set line [ReadCIV]

		if { [string length $line] == 0} \
			{
			# Got a read error.
			return ""
			}

		# Examine the address bytes.
		set to [string range $line 0 0]
		set from [string range $line 1 1]

		if { ([string compare -nocase -length 1 \
			$to $PCAddressHex] != 0) \
			&& ([string compare -nocase -length 1 \
			$to $RadioAddressHex] != 0)} \
			{
			puts stderr "ReadRx: UNKNOWN MESSAGE"
			continue;
			}

		if { $any == 0 } \
			{
			if { [string compare -nocase -length 1 \
				$from $PCAddressHex] == 0} \
				{
				# This message is from us,

				# so ignore it and read again.
				continue
				} \
			} 
		# Got a message.
		break
		}


	# Strip off the from and to address bytes.
	set line [string range $line 2 end]

	return $line
}


###################################################################
# Read a CI-V message from the serial port.
#
# Returns:
#		The message unless there was an error.
#		The empty string if there was an error.
###################################################################
proc ReadCIV { } \
{
	global GlobalParam
	global Sid


	set collision_error false

	# Skip the 2 byte "fe fe" preamble
	read $Sid 1
	read $Sid 1

	set line ""


	while { 1 } \
		{
		set b [read $Sid 1]

		# A byte of hexadecimal fc means there was an
		# error, usually a collision.

		# Note: I have observered that the radio
		# usually sends 3 consecutive fc bytes after
		# a CIV collision.   Because fc should never appear
		# in the IC-R75 data stream, we consider it 
		# an error whenever we see even a single fc byte.
		#        - Bob Parnass, 2/12/2002

		if { [string compare -nocase -length 1 $b \xfc] == 0} \
			{
			# Got an error, but continue reading bytes
			# until we get an end of message byte fe.

			set collision_error true
			set line [append line $b]
			} \
		elseif { [string compare -nocase -length 1 $b \xfd] == 0} \
			{
			# Got the end of message code byte.
			break
			} \
		elseif { [string compare -nocase -length 1 $b \xfe] == 0} \
			{
			; # Ignore leading preamble bytes.
			} \
		else \
			{
			set line [append line $b]
			}
		}

	if { $GlobalParam(Debug) > 0 } \
		{
		set msg "<--- "
		binary scan $line "H*" x

		regsub -all ".." $x { \0} x

		set msg [append msg $x]
		Tattle $msg
		}

	if { $collision_error == "true" } \
		{
		puts stderr "ReadCIV: collison error."
		set line ""
		}
	return $line
}

###################################################################
# 
# Convert an ASCII string to binary.
# The ASCII string uses two consecutive bytes, e.g., E3, to represent
# one byte of the binary string, e.g. \xE3.
#
# INPUT:	unpacked string
# RETURNS:	packed string
###################################################################

proc PackString { in } \
{
	global Hex2Digit

	set len [string length $in]

	set out ""
	# puts stderr "len $len, in: $in"

	for {set i 0} {$i < $len} {incr i 2} \
		{
		set j $i 
		set left [string index $in $j]
		incr j 
		set right [string index $in $j]

		# puts stderr "len: $len, left: $left, right: $right"

		binary scan $left "H2" ileft
		set dleft $Hex2Digit($ileft)

		binary scan $right "H2" iright
		set dright $Hex2Digit($iright)

		set s ""
		append s $dleft $dright
#		puts -nonewline stderr "$s "
		set hnum [binary format "H2" $s]

		append out $hnum

		# binary scan $left "H*" cl
		# binary scan $right "H*" cr

		# puts stderr "cl= $cl, cr= $cr, num= $num, ileft= $ileft, iright= $iright"
		}
	return $out
}


###################################################################
# 
# Convert a binary string to an ASCII string.
# The ASCII string uses two consecutive bytes, e.g., E3, to represent
# one byte of the binary string, e.g. \xE3.
#
# INPUT:	packed string
# RETURNS:	unpacked string
###################################################################

proc UnpackString { in } \
{
	global Digit2Hex

	set len [string length $in]

	set out ""

	for {set i 0} {$i < $len} {incr i} \
		{
         	set c [string index $in $i]
		binary scan $c "H2" s
		set s [string toupper $s]
         	set left [string index $s 0]
         	set right [string index $s 1]


		set dleft $Digit2Hex($left)
		set dright $Digit2Hex($right)
#		puts stderr "s= $s, $dleft $dright"

		append out [binary format "H2H2" $dleft $dright]
		}
	return $out
}

###################################################################
# Send the radio a command to accept memory data.
###################################################################
proc SendCloneIn { } \
{
	global GlobalParam
	global Sid


	set cmd [ binary format "H2" E3 ]
	append cmd [ binary format "H*" $GlobalParam(RadioVersion) ]

	SendCmd $Sid $cmd

	# Read the echo

	if { [ReadEcho $cmd] } \
		{
		# Error.
		# We did not read back what we wrote.
		puts stderr "SendCloneIn: Error while reading echo."
		}
	return
}


###################################################################
# Send the radio a command to send memory data to computer.
###################################################################
proc SendCloneOut { } \
{
	global GlobalParam
	global Sid


	set cmd [ binary format "H2" E2 ]
	append cmd [ binary format "H*" \
		$GlobalParam(RadioVersion) ]

	SendCmd $Sid $cmd

	# Read the echo

	if { [ReadEcho $cmd] } \
		{
		# Error.
		# We did not read back what we wrote.
		puts stderr "SendCloneOut: Error while reading echo."

		}
	return
}


###################################################################
# Send the radio a data termination command.
###################################################################
proc SendTermination { } \
{
	global GlobalParam
	global Sid


	set cmd [ binary format "H2" E5 ]
	append cmd "Icom Inc.80"

	SendCmd $Sid $cmd
	return
}


###################################################################
# Interrogate radio for version/model/user information
#
# Returns:
#	- 0 = no errors
#	- otherwise, error
#
# Notes:
###################################################################
proc GetTerminationResult { } \
{
	global GlobalParam
	global Sid


	while {1} \
		{
		# Read messages until we find the
		# one which matches request.

		set line [ReadRx]

		set len [string length $line]
		set cn [string range $line 0 0]
		binary scan $cn "H*" cn

		# If this is a termination result....
		if {$cn == "e6"} {break}
		}
	set x [string range $line 1 1 ]

	set code -1
	if { [string compare -nocase -length 1 $x \x00] == 0} \
		{
		set code 0
		} 
	return $code
}

proc DumpBinary { bstring } \
{
	binary scan $bstring "H*" s

	# Insert a space between each pair of hex digits
	# to improve readability.

	regsub -all ".." $s { \0} s
	return $s
}

proc ReadEcho { sent } \
{
	global GlobalParam
	global Pgm

	if {$GlobalParam(CableEchos) == 0} {return 0}

	set echo [ReadRx 1]
	if { [string compare $sent $echo] } \
		{
		# Error.
		# We did not read back what we wrote.
		puts stderr "$Pgm: Error while reading echo from message $i."
		return 1

		}
	return 0
}


###################################################################
# Set the serial port parameters.
#
#	proc SetSerialP { parity }
#
# INPUTS:
#	parity	-o or e or n
#
#
# RETURNS:
#	0	-ok
#	-1	-error occurred
#
# NOTES:
#
#	Requires tcl/tk 8.4 or later to support the ttycontrol
#	option on fconfigure.
#
#
# From: Rolf.Schroedter@dlr.de Wed Dec 18 00:44:18 2002
#
# The serial stuff in Windows is indeed more complicated than in  Unix.
# You can see this from the volume of source code.
#
# In Windows the -mode "string" interpretation resets
# all TTY states to their default values.
# A simple workaround for you is to set the baud rate
# first and only then the -ttycontrol. The following should work:
#
#	fconfigure $Sid -buffering none -translation binary  \
#		-blocking 1 \
#		-mode 9600,$parity,8,1 -ttycontrol {DTR 1 RTS 0}
#
# Or even
#	fconfigure $Sid -buffering none -translation binary \
#		-blocking 1
#	fconfigure $id	-mode 9600,$parity,8,1
#	fconfigure $id -ttycontrol {DTR 1 RTS 0}
#
# I'll have a look whether there is a way to correct this for
# future Tcl versions.
# On the other hand setting -mode is an elementary thing
# which reconfigures the UART hardware and should not be
# done during communication.
#
###################################################################
proc SetSerialP { parity } \
{
	global Pgm
	global Sid
	global GlobalParam

	set code 0

	# Set up the serial port parameters (similar to stty)
	if {($GlobalParam(DTRline) < 0) \
		&& ($GlobalParam(RTSline) < 0)} \
		{
		if { [catch {fconfigure $Sid \
			-buffering none \
			-translation binary \
			-handshake none \
			-mode 9600,$parity,8,1 -blocking 1 \
			-ttycontrol {DTR 0 RTS 0} }]} \
			{
			set code -1
			}
		} \
	elseif {($GlobalParam(DTRline) < 0) \
		&& ($GlobalParam(RTSline) > 0)} \
		{
		if { [catch {fconfigure $Sid \
			-buffering none \
			-translation binary \
			-handshake none \
			-mode 9600,$parity,8,1 -blocking 1 \
			-ttycontrol {DTR 0 RTS 1} }]} \
			{
			set code -1
			}
		} \
	elseif {($GlobalParam(DTRline) > 0) \
		&& ($GlobalParam(RTSline) < 0)} \
		{
		if { [catch {fconfigure $Sid \
			-buffering none \
			-translation binary \
			-handshake none \
			-mode 9600,$parity,8,1 -blocking 1 \
			-ttycontrol {DTR 1 RTS 0} }]} \
			{
			set code -1
			}
		} \
	else \
		{
		if { [catch {fconfigure $Sid \
			-buffering none \
			-translation binary \
			-handshake none \
			-mode 9600,$parity,8,1 -blocking 1 \
			-ttycontrol {DTR 1 RTS 1} }]} \
			{
			set code -1
			}
		}

	# Delay a half second to give serial port
	# time to settle.
	waiter 500
	return $code
}

