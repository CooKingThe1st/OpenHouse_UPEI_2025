                              1 ;--------------------------------------------------------
                              2 ; File Created by SDCC : free open source ANSI-C Compiler
                              3 ; Version 3.1.0 #7066 (Nov 22 2011) (MINGW32)
                              4 ; This file was generated Sun Oct 26 20:56:14 2025
                              5 ;--------------------------------------------------------
                              6 	.module slave_wixel_track
                              7 	.optsdcc -mmcs51 --model-medium
                              8 	
                              9 ;--------------------------------------------------------
                             10 ; Public variables in this module
                             11 ;--------------------------------------------------------
                             12 	.globl _main
                             13 	.globl _updateStateMachine
                             14 	.globl _updateRunState
                             15 	.globl _updateHomeState
                             16 	.globl _handlePacketTimeout
                             17 	.globl _receiveAndProcessPackets
                             18 	.globl _handleCmdCalibrate
                             19 	.globl _handleCmdAux
                             20 	.globl _executeManualPwm
                             21 	.globl _handleCmdRun
                             22 	.globl _handleCmdPrep
                             23 	.globl _handleCmdGoTo
                             24 	.globl _handleCmdStop
                             25 	.globl _extractPositionData
                             26 	.globl _updateRgbLeds
                             27 	.globl _gpioInit
                             28 	.globl _radioInit
                             29 	.globl _stopMotors
                             30 	.globl _setMotorsPWM
                             31 	.globl _timer3Init
                             32 	.globl _rotationController
                             33 	.globl _filterPosition
                             34 	.globl _calculateAndApplyOffset
                             35 	.globl _calculateTargetHeading
                             36 	.globl _isWithinThreshold
                             37 	.globl _abs16
                             38 	.globl _radioCrcPassed
                             39 	.globl _radioRegistersInit
                             40 	.globl _delayMs
                             41 	.globl _getMs
                             42 	.globl _boardService
                             43 	.globl _systemInit
                             44 	.globl _rotationController_PARM_2
                             45 	.globl _calculateTargetHeading_PARM_4
                             46 	.globl _calculateTargetHeading_PARM_3
                             47 	.globl _calculateTargetHeading_PARM_2
                             48 	.globl _isWithinThreshold_PARM_5
                             49 	.globl _isWithinThreshold_PARM_4
                             50 	.globl _isWithinThreshold_PARM_3
                             51 	.globl _isWithinThreshold_PARM_2
                             52 	.globl _calib_step
                             53 	.globl _cal_headingError
                             54 	.globl _cal_targetHeading
                             55 	.globl _orientationOffset
                             56 	.globl _i
                             57 	.globl _homeSubState
                             58 	.globl _runSubState
                             59 	.globl _currentWaypointIndex
                             60 	.globl _waypointInputIndex
                             61 	.globl _waypointCount
                             62 	.globl _waypoints
                             63 	.globl _manualPwmRight
                             64 	.globl _manualPwmLeft
                             65 	.globl _pwm_right
                             66 	.globl _pwm_left
                             67 	.globl _stateStartTime
                             68 	.globl _lastTargetY
                             69 	.globl _targetY
                             70 	.globl _lastTargetX
                             71 	.globl _targetX
                             72 	.globl _filteredTheta
                             73 	.globl _filteredY
                             74 	.globl _filteredX
                             75 	.globl _posTheta
                             76 	.globl _posY
                             77 	.globl _posX
                             78 	.globl _rxPulseStart
                             79 	.globl _now
                             80 	.globl _counter_loop
                             81 	.globl _lastPacketTime
                             82 	.globl _lastPacketTimeCheck
                             83 	.globl _currentState
                             84 ;--------------------------------------------------------
                             85 ; special function registers
                             86 ;--------------------------------------------------------
                             87 	.area RSEG    (ABS,DATA)
   0000                      88 	.org 0x0000
                    0080     89 Fslave_wixel_track$P0$0$0 == 0x0080
                    0080     90 _P0	=	0x0080
                    0081     91 Fslave_wixel_track$SP$0$0 == 0x0081
                    0081     92 _SP	=	0x0081
                    0082     93 Fslave_wixel_track$DPL0$0$0 == 0x0082
                    0082     94 _DPL0	=	0x0082
                    0083     95 Fslave_wixel_track$DPH0$0$0 == 0x0083
                    0083     96 _DPH0	=	0x0083
                    0084     97 Fslave_wixel_track$DPL1$0$0 == 0x0084
                    0084     98 _DPL1	=	0x0084
                    0085     99 Fslave_wixel_track$DPH1$0$0 == 0x0085
                    0085    100 _DPH1	=	0x0085
                    0086    101 Fslave_wixel_track$U0CSR$0$0 == 0x0086
                    0086    102 _U0CSR	=	0x0086
                    0087    103 Fslave_wixel_track$PCON$0$0 == 0x0087
                    0087    104 _PCON	=	0x0087
                    0088    105 Fslave_wixel_track$TCON$0$0 == 0x0088
                    0088    106 _TCON	=	0x0088
                    0089    107 Fslave_wixel_track$P0IFG$0$0 == 0x0089
                    0089    108 _P0IFG	=	0x0089
                    008A    109 Fslave_wixel_track$P1IFG$0$0 == 0x008a
                    008A    110 _P1IFG	=	0x008a
                    008B    111 Fslave_wixel_track$P2IFG$0$0 == 0x008b
                    008B    112 _P2IFG	=	0x008b
                    008C    113 Fslave_wixel_track$PICTL$0$0 == 0x008c
                    008C    114 _PICTL	=	0x008c
                    008D    115 Fslave_wixel_track$P1IEN$0$0 == 0x008d
                    008D    116 _P1IEN	=	0x008d
                    008F    117 Fslave_wixel_track$P0INP$0$0 == 0x008f
                    008F    118 _P0INP	=	0x008f
                    0090    119 Fslave_wixel_track$P1$0$0 == 0x0090
                    0090    120 _P1	=	0x0090
                    0091    121 Fslave_wixel_track$RFIM$0$0 == 0x0091
                    0091    122 _RFIM	=	0x0091
                    0092    123 Fslave_wixel_track$DPS$0$0 == 0x0092
                    0092    124 _DPS	=	0x0092
                    0093    125 Fslave_wixel_track$MPAGE$0$0 == 0x0093
                    0093    126 _MPAGE	=	0x0093
                    0095    127 Fslave_wixel_track$ENDIAN$0$0 == 0x0095
                    0095    128 _ENDIAN	=	0x0095
                    0098    129 Fslave_wixel_track$S0CON$0$0 == 0x0098
                    0098    130 _S0CON	=	0x0098
                    009A    131 Fslave_wixel_track$IEN2$0$0 == 0x009a
                    009A    132 _IEN2	=	0x009a
                    009B    133 Fslave_wixel_track$S1CON$0$0 == 0x009b
                    009B    134 _S1CON	=	0x009b
                    009C    135 Fslave_wixel_track$T2CT$0$0 == 0x009c
                    009C    136 _T2CT	=	0x009c
                    009D    137 Fslave_wixel_track$T2PR$0$0 == 0x009d
                    009D    138 _T2PR	=	0x009d
                    009E    139 Fslave_wixel_track$T2CTL$0$0 == 0x009e
                    009E    140 _T2CTL	=	0x009e
                    00A0    141 Fslave_wixel_track$P2$0$0 == 0x00a0
                    00A0    142 _P2	=	0x00a0
                    00A1    143 Fslave_wixel_track$WORIRQ$0$0 == 0x00a1
                    00A1    144 _WORIRQ	=	0x00a1
                    00A2    145 Fslave_wixel_track$WORCTRL$0$0 == 0x00a2
                    00A2    146 _WORCTRL	=	0x00a2
                    00A3    147 Fslave_wixel_track$WOREVT0$0$0 == 0x00a3
                    00A3    148 _WOREVT0	=	0x00a3
                    00A4    149 Fslave_wixel_track$WOREVT1$0$0 == 0x00a4
                    00A4    150 _WOREVT1	=	0x00a4
                    00A5    151 Fslave_wixel_track$WORTIME0$0$0 == 0x00a5
                    00A5    152 _WORTIME0	=	0x00a5
                    00A6    153 Fslave_wixel_track$WORTIME1$0$0 == 0x00a6
                    00A6    154 _WORTIME1	=	0x00a6
                    00A8    155 Fslave_wixel_track$IEN0$0$0 == 0x00a8
                    00A8    156 _IEN0	=	0x00a8
                    00A9    157 Fslave_wixel_track$IP0$0$0 == 0x00a9
                    00A9    158 _IP0	=	0x00a9
                    00AB    159 Fslave_wixel_track$FWT$0$0 == 0x00ab
                    00AB    160 _FWT	=	0x00ab
                    00AC    161 Fslave_wixel_track$FADDRL$0$0 == 0x00ac
                    00AC    162 _FADDRL	=	0x00ac
                    00AD    163 Fslave_wixel_track$FADDRH$0$0 == 0x00ad
                    00AD    164 _FADDRH	=	0x00ad
                    00AE    165 Fslave_wixel_track$FCTL$0$0 == 0x00ae
                    00AE    166 _FCTL	=	0x00ae
                    00AF    167 Fslave_wixel_track$FWDATA$0$0 == 0x00af
                    00AF    168 _FWDATA	=	0x00af
                    00B1    169 Fslave_wixel_track$ENCDI$0$0 == 0x00b1
                    00B1    170 _ENCDI	=	0x00b1
                    00B2    171 Fslave_wixel_track$ENCDO$0$0 == 0x00b2
                    00B2    172 _ENCDO	=	0x00b2
                    00B3    173 Fslave_wixel_track$ENCCS$0$0 == 0x00b3
                    00B3    174 _ENCCS	=	0x00b3
                    00B4    175 Fslave_wixel_track$ADCCON1$0$0 == 0x00b4
                    00B4    176 _ADCCON1	=	0x00b4
                    00B5    177 Fslave_wixel_track$ADCCON2$0$0 == 0x00b5
                    00B5    178 _ADCCON2	=	0x00b5
                    00B6    179 Fslave_wixel_track$ADCCON3$0$0 == 0x00b6
                    00B6    180 _ADCCON3	=	0x00b6
                    00B8    181 Fslave_wixel_track$IEN1$0$0 == 0x00b8
                    00B8    182 _IEN1	=	0x00b8
                    00B9    183 Fslave_wixel_track$IP1$0$0 == 0x00b9
                    00B9    184 _IP1	=	0x00b9
                    00BA    185 Fslave_wixel_track$ADCL$0$0 == 0x00ba
                    00BA    186 _ADCL	=	0x00ba
                    00BB    187 Fslave_wixel_track$ADCH$0$0 == 0x00bb
                    00BB    188 _ADCH	=	0x00bb
                    00BC    189 Fslave_wixel_track$RNDL$0$0 == 0x00bc
                    00BC    190 _RNDL	=	0x00bc
                    00BD    191 Fslave_wixel_track$RNDH$0$0 == 0x00bd
                    00BD    192 _RNDH	=	0x00bd
                    00BE    193 Fslave_wixel_track$SLEEP$0$0 == 0x00be
                    00BE    194 _SLEEP	=	0x00be
                    00C0    195 Fslave_wixel_track$IRCON$0$0 == 0x00c0
                    00C0    196 _IRCON	=	0x00c0
                    00C1    197 Fslave_wixel_track$U0DBUF$0$0 == 0x00c1
                    00C1    198 _U0DBUF	=	0x00c1
                    00C2    199 Fslave_wixel_track$U0BAUD$0$0 == 0x00c2
                    00C2    200 _U0BAUD	=	0x00c2
                    00C4    201 Fslave_wixel_track$U0UCR$0$0 == 0x00c4
                    00C4    202 _U0UCR	=	0x00c4
                    00C5    203 Fslave_wixel_track$U0GCR$0$0 == 0x00c5
                    00C5    204 _U0GCR	=	0x00c5
                    00C6    205 Fslave_wixel_track$CLKCON$0$0 == 0x00c6
                    00C6    206 _CLKCON	=	0x00c6
                    00C7    207 Fslave_wixel_track$MEMCTR$0$0 == 0x00c7
                    00C7    208 _MEMCTR	=	0x00c7
                    00C9    209 Fslave_wixel_track$WDCTL$0$0 == 0x00c9
                    00C9    210 _WDCTL	=	0x00c9
                    00CA    211 Fslave_wixel_track$T3CNT$0$0 == 0x00ca
                    00CA    212 _T3CNT	=	0x00ca
                    00CB    213 Fslave_wixel_track$T3CTL$0$0 == 0x00cb
                    00CB    214 _T3CTL	=	0x00cb
                    00CC    215 Fslave_wixel_track$T3CCTL0$0$0 == 0x00cc
                    00CC    216 _T3CCTL0	=	0x00cc
                    00CD    217 Fslave_wixel_track$T3CC0$0$0 == 0x00cd
                    00CD    218 _T3CC0	=	0x00cd
                    00CE    219 Fslave_wixel_track$T3CCTL1$0$0 == 0x00ce
                    00CE    220 _T3CCTL1	=	0x00ce
                    00CF    221 Fslave_wixel_track$T3CC1$0$0 == 0x00cf
                    00CF    222 _T3CC1	=	0x00cf
                    00D0    223 Fslave_wixel_track$PSW$0$0 == 0x00d0
                    00D0    224 _PSW	=	0x00d0
                    00D1    225 Fslave_wixel_track$DMAIRQ$0$0 == 0x00d1
                    00D1    226 _DMAIRQ	=	0x00d1
                    00D2    227 Fslave_wixel_track$DMA1CFGL$0$0 == 0x00d2
                    00D2    228 _DMA1CFGL	=	0x00d2
                    00D3    229 Fslave_wixel_track$DMA1CFGH$0$0 == 0x00d3
                    00D3    230 _DMA1CFGH	=	0x00d3
                    00D4    231 Fslave_wixel_track$DMA0CFGL$0$0 == 0x00d4
                    00D4    232 _DMA0CFGL	=	0x00d4
                    00D5    233 Fslave_wixel_track$DMA0CFGH$0$0 == 0x00d5
                    00D5    234 _DMA0CFGH	=	0x00d5
                    00D6    235 Fslave_wixel_track$DMAARM$0$0 == 0x00d6
                    00D6    236 _DMAARM	=	0x00d6
                    00D7    237 Fslave_wixel_track$DMAREQ$0$0 == 0x00d7
                    00D7    238 _DMAREQ	=	0x00d7
                    00D8    239 Fslave_wixel_track$TIMIF$0$0 == 0x00d8
                    00D8    240 _TIMIF	=	0x00d8
                    00D9    241 Fslave_wixel_track$RFD$0$0 == 0x00d9
                    00D9    242 _RFD	=	0x00d9
                    00DA    243 Fslave_wixel_track$T1CC0L$0$0 == 0x00da
                    00DA    244 _T1CC0L	=	0x00da
                    00DB    245 Fslave_wixel_track$T1CC0H$0$0 == 0x00db
                    00DB    246 _T1CC0H	=	0x00db
                    00DC    247 Fslave_wixel_track$T1CC1L$0$0 == 0x00dc
                    00DC    248 _T1CC1L	=	0x00dc
                    00DD    249 Fslave_wixel_track$T1CC1H$0$0 == 0x00dd
                    00DD    250 _T1CC1H	=	0x00dd
                    00DE    251 Fslave_wixel_track$T1CC2L$0$0 == 0x00de
                    00DE    252 _T1CC2L	=	0x00de
                    00DF    253 Fslave_wixel_track$T1CC2H$0$0 == 0x00df
                    00DF    254 _T1CC2H	=	0x00df
                    00E0    255 Fslave_wixel_track$ACC$0$0 == 0x00e0
                    00E0    256 _ACC	=	0x00e0
                    00E1    257 Fslave_wixel_track$RFST$0$0 == 0x00e1
                    00E1    258 _RFST	=	0x00e1
                    00E2    259 Fslave_wixel_track$T1CNTL$0$0 == 0x00e2
                    00E2    260 _T1CNTL	=	0x00e2
                    00E3    261 Fslave_wixel_track$T1CNTH$0$0 == 0x00e3
                    00E3    262 _T1CNTH	=	0x00e3
                    00E4    263 Fslave_wixel_track$T1CTL$0$0 == 0x00e4
                    00E4    264 _T1CTL	=	0x00e4
                    00E5    265 Fslave_wixel_track$T1CCTL0$0$0 == 0x00e5
                    00E5    266 _T1CCTL0	=	0x00e5
                    00E6    267 Fslave_wixel_track$T1CCTL1$0$0 == 0x00e6
                    00E6    268 _T1CCTL1	=	0x00e6
                    00E7    269 Fslave_wixel_track$T1CCTL2$0$0 == 0x00e7
                    00E7    270 _T1CCTL2	=	0x00e7
                    00E8    271 Fslave_wixel_track$IRCON2$0$0 == 0x00e8
                    00E8    272 _IRCON2	=	0x00e8
                    00E9    273 Fslave_wixel_track$RFIF$0$0 == 0x00e9
                    00E9    274 _RFIF	=	0x00e9
                    00EA    275 Fslave_wixel_track$T4CNT$0$0 == 0x00ea
                    00EA    276 _T4CNT	=	0x00ea
                    00EB    277 Fslave_wixel_track$T4CTL$0$0 == 0x00eb
                    00EB    278 _T4CTL	=	0x00eb
                    00EC    279 Fslave_wixel_track$T4CCTL0$0$0 == 0x00ec
                    00EC    280 _T4CCTL0	=	0x00ec
                    00ED    281 Fslave_wixel_track$T4CC0$0$0 == 0x00ed
                    00ED    282 _T4CC0	=	0x00ed
                    00EE    283 Fslave_wixel_track$T4CCTL1$0$0 == 0x00ee
                    00EE    284 _T4CCTL1	=	0x00ee
                    00EF    285 Fslave_wixel_track$T4CC1$0$0 == 0x00ef
                    00EF    286 _T4CC1	=	0x00ef
                    00F0    287 Fslave_wixel_track$B$0$0 == 0x00f0
                    00F0    288 _B	=	0x00f0
                    00F1    289 Fslave_wixel_track$PERCFG$0$0 == 0x00f1
                    00F1    290 _PERCFG	=	0x00f1
                    00F2    291 Fslave_wixel_track$ADCCFG$0$0 == 0x00f2
                    00F2    292 _ADCCFG	=	0x00f2
                    00F3    293 Fslave_wixel_track$P0SEL$0$0 == 0x00f3
                    00F3    294 _P0SEL	=	0x00f3
                    00F4    295 Fslave_wixel_track$P1SEL$0$0 == 0x00f4
                    00F4    296 _P1SEL	=	0x00f4
                    00F5    297 Fslave_wixel_track$P2SEL$0$0 == 0x00f5
                    00F5    298 _P2SEL	=	0x00f5
                    00F6    299 Fslave_wixel_track$P1INP$0$0 == 0x00f6
                    00F6    300 _P1INP	=	0x00f6
                    00F7    301 Fslave_wixel_track$P2INP$0$0 == 0x00f7
                    00F7    302 _P2INP	=	0x00f7
                    00F8    303 Fslave_wixel_track$U1CSR$0$0 == 0x00f8
                    00F8    304 _U1CSR	=	0x00f8
                    00F9    305 Fslave_wixel_track$U1DBUF$0$0 == 0x00f9
                    00F9    306 _U1DBUF	=	0x00f9
                    00FA    307 Fslave_wixel_track$U1BAUD$0$0 == 0x00fa
                    00FA    308 _U1BAUD	=	0x00fa
                    00FB    309 Fslave_wixel_track$U1UCR$0$0 == 0x00fb
                    00FB    310 _U1UCR	=	0x00fb
                    00FC    311 Fslave_wixel_track$U1GCR$0$0 == 0x00fc
                    00FC    312 _U1GCR	=	0x00fc
                    00FD    313 Fslave_wixel_track$P0DIR$0$0 == 0x00fd
                    00FD    314 _P0DIR	=	0x00fd
                    00FE    315 Fslave_wixel_track$P1DIR$0$0 == 0x00fe
                    00FE    316 _P1DIR	=	0x00fe
                    00FF    317 Fslave_wixel_track$P2DIR$0$0 == 0x00ff
                    00FF    318 _P2DIR	=	0x00ff
                    FFFFD5D4    319 Fslave_wixel_track$DMA0CFG$0$0 == 0xffffd5d4
                    FFFFD5D4    320 _DMA0CFG	=	0xffffd5d4
                    FFFFD3D2    321 Fslave_wixel_track$DMA1CFG$0$0 == 0xffffd3d2
                    FFFFD3D2    322 _DMA1CFG	=	0xffffd3d2
                    FFFFADAC    323 Fslave_wixel_track$FADDR$0$0 == 0xffffadac
                    FFFFADAC    324 _FADDR	=	0xffffadac
                    FFFFBBBA    325 Fslave_wixel_track$ADC$0$0 == 0xffffbbba
                    FFFFBBBA    326 _ADC	=	0xffffbbba
                    FFFFDBDA    327 Fslave_wixel_track$T1CC0$0$0 == 0xffffdbda
                    FFFFDBDA    328 _T1CC0	=	0xffffdbda
                    FFFFDDDC    329 Fslave_wixel_track$T1CC1$0$0 == 0xffffdddc
                    FFFFDDDC    330 _T1CC1	=	0xffffdddc
                    FFFFDFDE    331 Fslave_wixel_track$T1CC2$0$0 == 0xffffdfde
                    FFFFDFDE    332 _T1CC2	=	0xffffdfde
                            333 ;--------------------------------------------------------
                            334 ; special function bits
                            335 ;--------------------------------------------------------
                            336 	.area RSEG    (ABS,DATA)
   0000                     337 	.org 0x0000
                    0080    338 Fslave_wixel_track$P0_0$0$0 == 0x0080
                    0080    339 _P0_0	=	0x0080
                    0081    340 Fslave_wixel_track$P0_1$0$0 == 0x0081
                    0081    341 _P0_1	=	0x0081
                    0082    342 Fslave_wixel_track$P0_2$0$0 == 0x0082
                    0082    343 _P0_2	=	0x0082
                    0083    344 Fslave_wixel_track$P0_3$0$0 == 0x0083
                    0083    345 _P0_3	=	0x0083
                    0084    346 Fslave_wixel_track$P0_4$0$0 == 0x0084
                    0084    347 _P0_4	=	0x0084
                    0085    348 Fslave_wixel_track$P0_5$0$0 == 0x0085
                    0085    349 _P0_5	=	0x0085
                    0086    350 Fslave_wixel_track$P0_6$0$0 == 0x0086
                    0086    351 _P0_6	=	0x0086
                    0087    352 Fslave_wixel_track$P0_7$0$0 == 0x0087
                    0087    353 _P0_7	=	0x0087
                    0088    354 Fslave_wixel_track$_TCON_0$0$0 == 0x0088
                    0088    355 __TCON_0	=	0x0088
                    0089    356 Fslave_wixel_track$RFTXRXIF$0$0 == 0x0089
                    0089    357 _RFTXRXIF	=	0x0089
                    008A    358 Fslave_wixel_track$_TCON_2$0$0 == 0x008a
                    008A    359 __TCON_2	=	0x008a
                    008B    360 Fslave_wixel_track$URX0IF$0$0 == 0x008b
                    008B    361 _URX0IF	=	0x008b
                    008C    362 Fslave_wixel_track$_TCON_4$0$0 == 0x008c
                    008C    363 __TCON_4	=	0x008c
                    008D    364 Fslave_wixel_track$ADCIF$0$0 == 0x008d
                    008D    365 _ADCIF	=	0x008d
                    008E    366 Fslave_wixel_track$_TCON_6$0$0 == 0x008e
                    008E    367 __TCON_6	=	0x008e
                    008F    368 Fslave_wixel_track$URX1IF$0$0 == 0x008f
                    008F    369 _URX1IF	=	0x008f
                    0090    370 Fslave_wixel_track$P1_0$0$0 == 0x0090
                    0090    371 _P1_0	=	0x0090
                    0091    372 Fslave_wixel_track$P1_1$0$0 == 0x0091
                    0091    373 _P1_1	=	0x0091
                    0092    374 Fslave_wixel_track$P1_2$0$0 == 0x0092
                    0092    375 _P1_2	=	0x0092
                    0093    376 Fslave_wixel_track$P1_3$0$0 == 0x0093
                    0093    377 _P1_3	=	0x0093
                    0094    378 Fslave_wixel_track$P1_4$0$0 == 0x0094
                    0094    379 _P1_4	=	0x0094
                    0095    380 Fslave_wixel_track$P1_5$0$0 == 0x0095
                    0095    381 _P1_5	=	0x0095
                    0096    382 Fslave_wixel_track$P1_6$0$0 == 0x0096
                    0096    383 _P1_6	=	0x0096
                    0097    384 Fslave_wixel_track$P1_7$0$0 == 0x0097
                    0097    385 _P1_7	=	0x0097
                    0098    386 Fslave_wixel_track$ENCIF_0$0$0 == 0x0098
                    0098    387 _ENCIF_0	=	0x0098
                    0099    388 Fslave_wixel_track$ENCIF_1$0$0 == 0x0099
                    0099    389 _ENCIF_1	=	0x0099
                    009A    390 Fslave_wixel_track$_SOCON2$0$0 == 0x009a
                    009A    391 __SOCON2	=	0x009a
                    009B    392 Fslave_wixel_track$_SOCON3$0$0 == 0x009b
                    009B    393 __SOCON3	=	0x009b
                    009C    394 Fslave_wixel_track$_SOCON4$0$0 == 0x009c
                    009C    395 __SOCON4	=	0x009c
                    009D    396 Fslave_wixel_track$_SOCON5$0$0 == 0x009d
                    009D    397 __SOCON5	=	0x009d
                    009E    398 Fslave_wixel_track$_SOCON6$0$0 == 0x009e
                    009E    399 __SOCON6	=	0x009e
                    009F    400 Fslave_wixel_track$_SOCON7$0$0 == 0x009f
                    009F    401 __SOCON7	=	0x009f
                    00A0    402 Fslave_wixel_track$P2_0$0$0 == 0x00a0
                    00A0    403 _P2_0	=	0x00a0
                    00A1    404 Fslave_wixel_track$P2_1$0$0 == 0x00a1
                    00A1    405 _P2_1	=	0x00a1
                    00A2    406 Fslave_wixel_track$P2_2$0$0 == 0x00a2
                    00A2    407 _P2_2	=	0x00a2
                    00A3    408 Fslave_wixel_track$P2_3$0$0 == 0x00a3
                    00A3    409 _P2_3	=	0x00a3
                    00A4    410 Fslave_wixel_track$P2_4$0$0 == 0x00a4
                    00A4    411 _P2_4	=	0x00a4
                    00A5    412 Fslave_wixel_track$P2_5$0$0 == 0x00a5
                    00A5    413 _P2_5	=	0x00a5
                    00A6    414 Fslave_wixel_track$P2_6$0$0 == 0x00a6
                    00A6    415 _P2_6	=	0x00a6
                    00A7    416 Fslave_wixel_track$P2_7$0$0 == 0x00a7
                    00A7    417 _P2_7	=	0x00a7
                    00A8    418 Fslave_wixel_track$RFTXRXIE$0$0 == 0x00a8
                    00A8    419 _RFTXRXIE	=	0x00a8
                    00A9    420 Fslave_wixel_track$ADCIE$0$0 == 0x00a9
                    00A9    421 _ADCIE	=	0x00a9
                    00AA    422 Fslave_wixel_track$URX0IE$0$0 == 0x00aa
                    00AA    423 _URX0IE	=	0x00aa
                    00AB    424 Fslave_wixel_track$URX1IE$0$0 == 0x00ab
                    00AB    425 _URX1IE	=	0x00ab
                    00AC    426 Fslave_wixel_track$ENCIE$0$0 == 0x00ac
                    00AC    427 _ENCIE	=	0x00ac
                    00AD    428 Fslave_wixel_track$STIE$0$0 == 0x00ad
                    00AD    429 _STIE	=	0x00ad
                    00AE    430 Fslave_wixel_track$_IEN06$0$0 == 0x00ae
                    00AE    431 __IEN06	=	0x00ae
                    00AF    432 Fslave_wixel_track$EA$0$0 == 0x00af
                    00AF    433 _EA	=	0x00af
                    00B8    434 Fslave_wixel_track$DMAIE$0$0 == 0x00b8
                    00B8    435 _DMAIE	=	0x00b8
                    00B9    436 Fslave_wixel_track$T1IE$0$0 == 0x00b9
                    00B9    437 _T1IE	=	0x00b9
                    00BA    438 Fslave_wixel_track$T2IE$0$0 == 0x00ba
                    00BA    439 _T2IE	=	0x00ba
                    00BB    440 Fslave_wixel_track$T3IE$0$0 == 0x00bb
                    00BB    441 _T3IE	=	0x00bb
                    00BC    442 Fslave_wixel_track$T4IE$0$0 == 0x00bc
                    00BC    443 _T4IE	=	0x00bc
                    00BD    444 Fslave_wixel_track$P0IE$0$0 == 0x00bd
                    00BD    445 _P0IE	=	0x00bd
                    00BE    446 Fslave_wixel_track$_IEN16$0$0 == 0x00be
                    00BE    447 __IEN16	=	0x00be
                    00BF    448 Fslave_wixel_track$_IEN17$0$0 == 0x00bf
                    00BF    449 __IEN17	=	0x00bf
                    00C0    450 Fslave_wixel_track$DMAIF$0$0 == 0x00c0
                    00C0    451 _DMAIF	=	0x00c0
                    00C1    452 Fslave_wixel_track$T1IF$0$0 == 0x00c1
                    00C1    453 _T1IF	=	0x00c1
                    00C2    454 Fslave_wixel_track$T2IF$0$0 == 0x00c2
                    00C2    455 _T2IF	=	0x00c2
                    00C3    456 Fslave_wixel_track$T3IF$0$0 == 0x00c3
                    00C3    457 _T3IF	=	0x00c3
                    00C4    458 Fslave_wixel_track$T4IF$0$0 == 0x00c4
                    00C4    459 _T4IF	=	0x00c4
                    00C5    460 Fslave_wixel_track$P0IF$0$0 == 0x00c5
                    00C5    461 _P0IF	=	0x00c5
                    00C6    462 Fslave_wixel_track$_IRCON6$0$0 == 0x00c6
                    00C6    463 __IRCON6	=	0x00c6
                    00C7    464 Fslave_wixel_track$STIF$0$0 == 0x00c7
                    00C7    465 _STIF	=	0x00c7
                    00D0    466 Fslave_wixel_track$P$0$0 == 0x00d0
                    00D0    467 _P	=	0x00d0
                    00D1    468 Fslave_wixel_track$F1$0$0 == 0x00d1
                    00D1    469 _F1	=	0x00d1
                    00D2    470 Fslave_wixel_track$OV$0$0 == 0x00d2
                    00D2    471 _OV	=	0x00d2
                    00D3    472 Fslave_wixel_track$RS0$0$0 == 0x00d3
                    00D3    473 _RS0	=	0x00d3
                    00D4    474 Fslave_wixel_track$RS1$0$0 == 0x00d4
                    00D4    475 _RS1	=	0x00d4
                    00D5    476 Fslave_wixel_track$F0$0$0 == 0x00d5
                    00D5    477 _F0	=	0x00d5
                    00D6    478 Fslave_wixel_track$AC$0$0 == 0x00d6
                    00D6    479 _AC	=	0x00d6
                    00D7    480 Fslave_wixel_track$CY$0$0 == 0x00d7
                    00D7    481 _CY	=	0x00d7
                    00D8    482 Fslave_wixel_track$T3OVFIF$0$0 == 0x00d8
                    00D8    483 _T3OVFIF	=	0x00d8
                    00D9    484 Fslave_wixel_track$T3CH0IF$0$0 == 0x00d9
                    00D9    485 _T3CH0IF	=	0x00d9
                    00DA    486 Fslave_wixel_track$T3CH1IF$0$0 == 0x00da
                    00DA    487 _T3CH1IF	=	0x00da
                    00DB    488 Fslave_wixel_track$T4OVFIF$0$0 == 0x00db
                    00DB    489 _T4OVFIF	=	0x00db
                    00DC    490 Fslave_wixel_track$T4CH0IF$0$0 == 0x00dc
                    00DC    491 _T4CH0IF	=	0x00dc
                    00DD    492 Fslave_wixel_track$T4CH1IF$0$0 == 0x00dd
                    00DD    493 _T4CH1IF	=	0x00dd
                    00DE    494 Fslave_wixel_track$OVFIM$0$0 == 0x00de
                    00DE    495 _OVFIM	=	0x00de
                    00DF    496 Fslave_wixel_track$_TIMIF7$0$0 == 0x00df
                    00DF    497 __TIMIF7	=	0x00df
                    00E0    498 Fslave_wixel_track$ACC_0$0$0 == 0x00e0
                    00E0    499 _ACC_0	=	0x00e0
                    00E1    500 Fslave_wixel_track$ACC_1$0$0 == 0x00e1
                    00E1    501 _ACC_1	=	0x00e1
                    00E2    502 Fslave_wixel_track$ACC_2$0$0 == 0x00e2
                    00E2    503 _ACC_2	=	0x00e2
                    00E3    504 Fslave_wixel_track$ACC_3$0$0 == 0x00e3
                    00E3    505 _ACC_3	=	0x00e3
                    00E4    506 Fslave_wixel_track$ACC_4$0$0 == 0x00e4
                    00E4    507 _ACC_4	=	0x00e4
                    00E5    508 Fslave_wixel_track$ACC_5$0$0 == 0x00e5
                    00E5    509 _ACC_5	=	0x00e5
                    00E6    510 Fslave_wixel_track$ACC_6$0$0 == 0x00e6
                    00E6    511 _ACC_6	=	0x00e6
                    00E7    512 Fslave_wixel_track$ACC_7$0$0 == 0x00e7
                    00E7    513 _ACC_7	=	0x00e7
                    00E8    514 Fslave_wixel_track$P2IF$0$0 == 0x00e8
                    00E8    515 _P2IF	=	0x00e8
                    00E9    516 Fslave_wixel_track$UTX0IF$0$0 == 0x00e9
                    00E9    517 _UTX0IF	=	0x00e9
                    00EA    518 Fslave_wixel_track$UTX1IF$0$0 == 0x00ea
                    00EA    519 _UTX1IF	=	0x00ea
                    00EB    520 Fslave_wixel_track$P1IF$0$0 == 0x00eb
                    00EB    521 _P1IF	=	0x00eb
                    00EC    522 Fslave_wixel_track$WDTIF$0$0 == 0x00ec
                    00EC    523 _WDTIF	=	0x00ec
                    00ED    524 Fslave_wixel_track$_IRCON25$0$0 == 0x00ed
                    00ED    525 __IRCON25	=	0x00ed
                    00EE    526 Fslave_wixel_track$_IRCON26$0$0 == 0x00ee
                    00EE    527 __IRCON26	=	0x00ee
                    00EF    528 Fslave_wixel_track$_IRCON27$0$0 == 0x00ef
                    00EF    529 __IRCON27	=	0x00ef
                    00F0    530 Fslave_wixel_track$B_0$0$0 == 0x00f0
                    00F0    531 _B_0	=	0x00f0
                    00F1    532 Fslave_wixel_track$B_1$0$0 == 0x00f1
                    00F1    533 _B_1	=	0x00f1
                    00F2    534 Fslave_wixel_track$B_2$0$0 == 0x00f2
                    00F2    535 _B_2	=	0x00f2
                    00F3    536 Fslave_wixel_track$B_3$0$0 == 0x00f3
                    00F3    537 _B_3	=	0x00f3
                    00F4    538 Fslave_wixel_track$B_4$0$0 == 0x00f4
                    00F4    539 _B_4	=	0x00f4
                    00F5    540 Fslave_wixel_track$B_5$0$0 == 0x00f5
                    00F5    541 _B_5	=	0x00f5
                    00F6    542 Fslave_wixel_track$B_6$0$0 == 0x00f6
                    00F6    543 _B_6	=	0x00f6
                    00F7    544 Fslave_wixel_track$B_7$0$0 == 0x00f7
                    00F7    545 _B_7	=	0x00f7
                    00F8    546 Fslave_wixel_track$U1ACTIVE$0$0 == 0x00f8
                    00F8    547 _U1ACTIVE	=	0x00f8
                    00F9    548 Fslave_wixel_track$U1TX_BYTE$0$0 == 0x00f9
                    00F9    549 _U1TX_BYTE	=	0x00f9
                    00FA    550 Fslave_wixel_track$U1RX_BYTE$0$0 == 0x00fa
                    00FA    551 _U1RX_BYTE	=	0x00fa
                    00FB    552 Fslave_wixel_track$U1ERR$0$0 == 0x00fb
                    00FB    553 _U1ERR	=	0x00fb
                    00FC    554 Fslave_wixel_track$U1FE$0$0 == 0x00fc
                    00FC    555 _U1FE	=	0x00fc
                    00FD    556 Fslave_wixel_track$U1SLAVE$0$0 == 0x00fd
                    00FD    557 _U1SLAVE	=	0x00fd
                    00FE    558 Fslave_wixel_track$U1RE$0$0 == 0x00fe
                    00FE    559 _U1RE	=	0x00fe
                    00FF    560 Fslave_wixel_track$U1MODE$0$0 == 0x00ff
                    00FF    561 _U1MODE	=	0x00ff
                            562 ;--------------------------------------------------------
                            563 ; overlayable register banks
                            564 ;--------------------------------------------------------
                            565 	.area REG_BANK_0	(REL,OVR,DATA)
   0000                     566 	.ds 8
                            567 ;--------------------------------------------------------
                            568 ; internal ram data
                            569 ;--------------------------------------------------------
                            570 	.area DSEG    (DATA)
                    0000    571 Lslave_wixel_track.isWithinThreshold$sloc0$1$0==.
   0008                     572 _isWithinThreshold_sloc0_1_0:
   0008                     573 	.ds 4
                    0004    574 Lslave_wixel_track.calculateTargetHeading$sloc0$1$0==.
   000C                     575 _calculateTargetHeading_sloc0_1_0:
   000C                     576 	.ds 4
                    0008    577 Lslave_wixel_track.calculateAndApplyOffset$sloc0$1$0==.
   0010                     578 _calculateAndApplyOffset_sloc0_1_0:
   0010                     579 	.ds 2
                    000A    580 Lslave_wixel_track.filterPosition$sloc0$1$0==.
   0012                     581 _filterPosition_sloc0_1_0:
   0012                     582 	.ds 4
                    000E    583 Lslave_wixel_track.handlePacketTimeout$sloc0$1$0==.
   0016                     584 _handlePacketTimeout_sloc0_1_0:
   0016                     585 	.ds 4
                            586 ;--------------------------------------------------------
                            587 ; overlayable items in internal ram 
                            588 ;--------------------------------------------------------
                            589 	.area OSEG    (OVR,DATA)
                            590 ;--------------------------------------------------------
                            591 ; Stack segment in internal ram 
                            592 ;--------------------------------------------------------
                            593 	.area	SSEG	(DATA)
   0025                     594 __start__stack:
   0025                     595 	.ds	1
                            596 
                            597 ;--------------------------------------------------------
                            598 ; indirectly addressable internal ram data
                            599 ;--------------------------------------------------------
                            600 	.area ISEG    (DATA)
                            601 ;--------------------------------------------------------
                            602 ; absolute internal ram data
                            603 ;--------------------------------------------------------
                            604 	.area IABS    (ABS,DATA)
                            605 	.area IABS    (ABS,DATA)
                            606 ;--------------------------------------------------------
                            607 ; bit data
                            608 ;--------------------------------------------------------
                            609 	.area BSEG    (BIT)
                            610 ;--------------------------------------------------------
                            611 ; paged external ram data
                            612 ;--------------------------------------------------------
                            613 	.area PSEG    (PAG,XDATA)
                    0000    614 G$currentState$0$0==.
   F000                     615 _currentState::
   F000                     616 	.ds 1
                    0001    617 G$lastPacketTimeCheck$0$0==.
   F001                     618 _lastPacketTimeCheck::
   F001                     619 	.ds 2
                    0003    620 G$lastPacketTime$0$0==.
   F003                     621 _lastPacketTime::
   F003                     622 	.ds 2
                    0005    623 G$counter_loop$0$0==.
   F005                     624 _counter_loop::
   F005                     625 	.ds 2
                    0007    626 G$now$0$0==.
   F007                     627 _now::
   F007                     628 	.ds 4
                    000B    629 G$rxPulseStart$0$0==.
   F00B                     630 _rxPulseStart::
   F00B                     631 	.ds 4
                    000F    632 G$posX$0$0==.
   F00F                     633 _posX::
   F00F                     634 	.ds 2
                    0011    635 G$posY$0$0==.
   F011                     636 _posY::
   F011                     637 	.ds 2
                    0013    638 G$posTheta$0$0==.
   F013                     639 _posTheta::
   F013                     640 	.ds 2
                    0015    641 G$filteredX$0$0==.
   F015                     642 _filteredX::
   F015                     643 	.ds 2
                    0017    644 G$filteredY$0$0==.
   F017                     645 _filteredY::
   F017                     646 	.ds 2
                    0019    647 G$filteredTheta$0$0==.
   F019                     648 _filteredTheta::
   F019                     649 	.ds 2
                    001B    650 G$targetX$0$0==.
   F01B                     651 _targetX::
   F01B                     652 	.ds 2
                    001D    653 G$lastTargetX$0$0==.
   F01D                     654 _lastTargetX::
   F01D                     655 	.ds 2
                    001F    656 G$targetY$0$0==.
   F01F                     657 _targetY::
   F01F                     658 	.ds 2
                    0021    659 G$lastTargetY$0$0==.
   F021                     660 _lastTargetY::
   F021                     661 	.ds 2
                    0023    662 G$stateStartTime$0$0==.
   F023                     663 _stateStartTime::
   F023                     664 	.ds 4
                    0027    665 G$pwm_left$0$0==.
   F027                     666 _pwm_left::
   F027                     667 	.ds 2
                    0029    668 G$pwm_right$0$0==.
   F029                     669 _pwm_right::
   F029                     670 	.ds 2
                    002B    671 G$manualPwmLeft$0$0==.
   F02B                     672 _manualPwmLeft::
   F02B                     673 	.ds 2
                    002D    674 G$manualPwmRight$0$0==.
   F02D                     675 _manualPwmRight::
   F02D                     676 	.ds 2
                    002F    677 G$waypoints$0$0==.
   F02F                     678 _waypoints::
   F02F                     679 	.ds 100
                    0093    680 G$waypointCount$0$0==.
   F093                     681 _waypointCount::
   F093                     682 	.ds 1
                    0094    683 G$waypointInputIndex$0$0==.
   F094                     684 _waypointInputIndex::
   F094                     685 	.ds 1
                    0095    686 G$currentWaypointIndex$0$0==.
   F095                     687 _currentWaypointIndex::
   F095                     688 	.ds 1
                    0096    689 G$runSubState$0$0==.
   F096                     690 _runSubState::
   F096                     691 	.ds 1
                    0097    692 G$homeSubState$0$0==.
   F097                     693 _homeSubState::
   F097                     694 	.ds 1
                    0098    695 G$i$0$0==.
   F098                     696 _i::
   F098                     697 	.ds 1
                    0099    698 Fslave_wixel_track$calData$0$0==.
   F099                     699 _calData:
   F099                     700 	.ds 18
                    00AB    701 G$orientationOffset$0$0==.
   F0AB                     702 _orientationOffset::
   F0AB                     703 	.ds 2
                    00AD    704 G$cal_targetHeading$0$0==.
   F0AD                     705 _cal_targetHeading::
   F0AD                     706 	.ds 2
                    00AF    707 G$cal_headingError$0$0==.
   F0AF                     708 _cal_headingError::
   F0AF                     709 	.ds 2
                    00B1    710 G$calib_step$0$0==.
   F0B1                     711 _calib_step::
   F0B1                     712 	.ds 1
                    00B2    713 Lslave_wixel_track.isWithinThreshold$currentY$1$1==.
   F0B2                     714 _isWithinThreshold_PARM_2:
   F0B2                     715 	.ds 2
                    00B4    716 Lslave_wixel_track.isWithinThreshold$targetX$1$1==.
   F0B4                     717 _isWithinThreshold_PARM_3:
   F0B4                     718 	.ds 2
                    00B6    719 Lslave_wixel_track.isWithinThreshold$targetY$1$1==.
   F0B6                     720 _isWithinThreshold_PARM_4:
   F0B6                     721 	.ds 2
                    00B8    722 Lslave_wixel_track.isWithinThreshold$threshold$1$1==.
   F0B8                     723 _isWithinThreshold_PARM_5:
   F0B8                     724 	.ds 2
                    00BA    725 Lslave_wixel_track.isWithinThreshold$distSquared$1$1==.
   F0BA                     726 _isWithinThreshold_distSquared_1_1:
   F0BA                     727 	.ds 4
                    00BE    728 Lslave_wixel_track.calculateTargetHeading$currentY$1$1==.
   F0BE                     729 _calculateTargetHeading_PARM_2:
   F0BE                     730 	.ds 2
                    00C0    731 Lslave_wixel_track.calculateTargetHeading$goalX$1$1==.
   F0C0                     732 _calculateTargetHeading_PARM_3:
   F0C0                     733 	.ds 2
                    00C2    734 Lslave_wixel_track.calculateTargetHeading$goalY$1$1==.
   F0C2                     735 _calculateTargetHeading_PARM_4:
   F0C2                     736 	.ds 2
                    00C4    737 Lslave_wixel_track.calculateTargetHeading$dx$1$1==.
   F0C4                     738 _calculateTargetHeading_dx_1_1:
   F0C4                     739 	.ds 4
                    00C8    740 Lslave_wixel_track.calculateTargetHeading$absX$1$1==.
   F0C8                     741 _calculateTargetHeading_absX_1_1:
   F0C8                     742 	.ds 4
                    00CC    743 Lslave_wixel_track.calculateTargetHeading$absY$1$1==.
   F0CC                     744 _calculateTargetHeading_absY_1_1:
   F0CC                     745 	.ds 4
                    00D0    746 Lslave_wixel_track.calculateTargetHeading$angle$1$1==.
   F0D0                     747 _calculateTargetHeading_angle_1_1:
   F0D0                     748 	.ds 2
                    00D2    749 Lslave_wixel_track.calculateTargetHeading$ratio$1$1==.
   F0D2                     750 _calculateTargetHeading_ratio_1_1:
   F0D2                     751 	.ds 4
                    00D6    752 Lslave_wixel_track.rotationController$targetHeading$1$1==.
   F0D6                     753 _rotationController_PARM_2:
   F0D6                     754 	.ds 2
                    00D8    755 Lslave_wixel_track.handleCmdPrep$wp_x$1$1==.
   F0D8                     756 _handleCmdPrep_wp_x_1_1:
   F0D8                     757 	.ds 2
                            758 ;--------------------------------------------------------
                            759 ; external ram data
                            760 ;--------------------------------------------------------
                            761 	.area XSEG    (XDATA)
                    DF00    762 Fslave_wixel_track$SYNC1$0$0 == 0xdf00
                    DF00    763 _SYNC1	=	0xdf00
                    DF01    764 Fslave_wixel_track$SYNC0$0$0 == 0xdf01
                    DF01    765 _SYNC0	=	0xdf01
                    DF02    766 Fslave_wixel_track$PKTLEN$0$0 == 0xdf02
                    DF02    767 _PKTLEN	=	0xdf02
                    DF03    768 Fslave_wixel_track$PKTCTRL1$0$0 == 0xdf03
                    DF03    769 _PKTCTRL1	=	0xdf03
                    DF04    770 Fslave_wixel_track$PKTCTRL0$0$0 == 0xdf04
                    DF04    771 _PKTCTRL0	=	0xdf04
                    DF05    772 Fslave_wixel_track$ADDR$0$0 == 0xdf05
                    DF05    773 _ADDR	=	0xdf05
                    DF06    774 Fslave_wixel_track$CHANNR$0$0 == 0xdf06
                    DF06    775 _CHANNR	=	0xdf06
                    DF07    776 Fslave_wixel_track$FSCTRL1$0$0 == 0xdf07
                    DF07    777 _FSCTRL1	=	0xdf07
                    DF08    778 Fslave_wixel_track$FSCTRL0$0$0 == 0xdf08
                    DF08    779 _FSCTRL0	=	0xdf08
                    DF09    780 Fslave_wixel_track$FREQ2$0$0 == 0xdf09
                    DF09    781 _FREQ2	=	0xdf09
                    DF0A    782 Fslave_wixel_track$FREQ1$0$0 == 0xdf0a
                    DF0A    783 _FREQ1	=	0xdf0a
                    DF0B    784 Fslave_wixel_track$FREQ0$0$0 == 0xdf0b
                    DF0B    785 _FREQ0	=	0xdf0b
                    DF0C    786 Fslave_wixel_track$MDMCFG4$0$0 == 0xdf0c
                    DF0C    787 _MDMCFG4	=	0xdf0c
                    DF0D    788 Fslave_wixel_track$MDMCFG3$0$0 == 0xdf0d
                    DF0D    789 _MDMCFG3	=	0xdf0d
                    DF0E    790 Fslave_wixel_track$MDMCFG2$0$0 == 0xdf0e
                    DF0E    791 _MDMCFG2	=	0xdf0e
                    DF0F    792 Fslave_wixel_track$MDMCFG1$0$0 == 0xdf0f
                    DF0F    793 _MDMCFG1	=	0xdf0f
                    DF10    794 Fslave_wixel_track$MDMCFG0$0$0 == 0xdf10
                    DF10    795 _MDMCFG0	=	0xdf10
                    DF11    796 Fslave_wixel_track$DEVIATN$0$0 == 0xdf11
                    DF11    797 _DEVIATN	=	0xdf11
                    DF12    798 Fslave_wixel_track$MCSM2$0$0 == 0xdf12
                    DF12    799 _MCSM2	=	0xdf12
                    DF13    800 Fslave_wixel_track$MCSM1$0$0 == 0xdf13
                    DF13    801 _MCSM1	=	0xdf13
                    DF14    802 Fslave_wixel_track$MCSM0$0$0 == 0xdf14
                    DF14    803 _MCSM0	=	0xdf14
                    DF15    804 Fslave_wixel_track$FOCCFG$0$0 == 0xdf15
                    DF15    805 _FOCCFG	=	0xdf15
                    DF16    806 Fslave_wixel_track$BSCFG$0$0 == 0xdf16
                    DF16    807 _BSCFG	=	0xdf16
                    DF17    808 Fslave_wixel_track$AGCCTRL2$0$0 == 0xdf17
                    DF17    809 _AGCCTRL2	=	0xdf17
                    DF18    810 Fslave_wixel_track$AGCCTRL1$0$0 == 0xdf18
                    DF18    811 _AGCCTRL1	=	0xdf18
                    DF19    812 Fslave_wixel_track$AGCCTRL0$0$0 == 0xdf19
                    DF19    813 _AGCCTRL0	=	0xdf19
                    DF1A    814 Fslave_wixel_track$FREND1$0$0 == 0xdf1a
                    DF1A    815 _FREND1	=	0xdf1a
                    DF1B    816 Fslave_wixel_track$FREND0$0$0 == 0xdf1b
                    DF1B    817 _FREND0	=	0xdf1b
                    DF1C    818 Fslave_wixel_track$FSCAL3$0$0 == 0xdf1c
                    DF1C    819 _FSCAL3	=	0xdf1c
                    DF1D    820 Fslave_wixel_track$FSCAL2$0$0 == 0xdf1d
                    DF1D    821 _FSCAL2	=	0xdf1d
                    DF1E    822 Fslave_wixel_track$FSCAL1$0$0 == 0xdf1e
                    DF1E    823 _FSCAL1	=	0xdf1e
                    DF1F    824 Fslave_wixel_track$FSCAL0$0$0 == 0xdf1f
                    DF1F    825 _FSCAL0	=	0xdf1f
                    DF23    826 Fslave_wixel_track$TEST2$0$0 == 0xdf23
                    DF23    827 _TEST2	=	0xdf23
                    DF24    828 Fslave_wixel_track$TEST1$0$0 == 0xdf24
                    DF24    829 _TEST1	=	0xdf24
                    DF25    830 Fslave_wixel_track$TEST0$0$0 == 0xdf25
                    DF25    831 _TEST0	=	0xdf25
                    DF2E    832 Fslave_wixel_track$PA_TABLE0$0$0 == 0xdf2e
                    DF2E    833 _PA_TABLE0	=	0xdf2e
                    DF2F    834 Fslave_wixel_track$IOCFG2$0$0 == 0xdf2f
                    DF2F    835 _IOCFG2	=	0xdf2f
                    DF30    836 Fslave_wixel_track$IOCFG1$0$0 == 0xdf30
                    DF30    837 _IOCFG1	=	0xdf30
                    DF31    838 Fslave_wixel_track$IOCFG0$0$0 == 0xdf31
                    DF31    839 _IOCFG0	=	0xdf31
                    DF36    840 Fslave_wixel_track$PARTNUM$0$0 == 0xdf36
                    DF36    841 _PARTNUM	=	0xdf36
                    DF37    842 Fslave_wixel_track$VERSION$0$0 == 0xdf37
                    DF37    843 _VERSION	=	0xdf37
                    DF38    844 Fslave_wixel_track$FREQEST$0$0 == 0xdf38
                    DF38    845 _FREQEST	=	0xdf38
                    DF39    846 Fslave_wixel_track$LQI$0$0 == 0xdf39
                    DF39    847 _LQI	=	0xdf39
                    DF3A    848 Fslave_wixel_track$RSSI$0$0 == 0xdf3a
                    DF3A    849 _RSSI	=	0xdf3a
                    DF3B    850 Fslave_wixel_track$MARCSTATE$0$0 == 0xdf3b
                    DF3B    851 _MARCSTATE	=	0xdf3b
                    DF3C    852 Fslave_wixel_track$PKTSTATUS$0$0 == 0xdf3c
                    DF3C    853 _PKTSTATUS	=	0xdf3c
                    DF3D    854 Fslave_wixel_track$VCO_VC_DAC$0$0 == 0xdf3d
                    DF3D    855 _VCO_VC_DAC	=	0xdf3d
                    DF40    856 Fslave_wixel_track$I2SCFG0$0$0 == 0xdf40
                    DF40    857 _I2SCFG0	=	0xdf40
                    DF41    858 Fslave_wixel_track$I2SCFG1$0$0 == 0xdf41
                    DF41    859 _I2SCFG1	=	0xdf41
                    DF42    860 Fslave_wixel_track$I2SDATL$0$0 == 0xdf42
                    DF42    861 _I2SDATL	=	0xdf42
                    DF43    862 Fslave_wixel_track$I2SDATH$0$0 == 0xdf43
                    DF43    863 _I2SDATH	=	0xdf43
                    DF44    864 Fslave_wixel_track$I2SWCNT$0$0 == 0xdf44
                    DF44    865 _I2SWCNT	=	0xdf44
                    DF45    866 Fslave_wixel_track$I2SSTAT$0$0 == 0xdf45
                    DF45    867 _I2SSTAT	=	0xdf45
                    DF46    868 Fslave_wixel_track$I2SCLKF0$0$0 == 0xdf46
                    DF46    869 _I2SCLKF0	=	0xdf46
                    DF47    870 Fslave_wixel_track$I2SCLKF1$0$0 == 0xdf47
                    DF47    871 _I2SCLKF1	=	0xdf47
                    DF48    872 Fslave_wixel_track$I2SCLKF2$0$0 == 0xdf48
                    DF48    873 _I2SCLKF2	=	0xdf48
                    DE00    874 Fslave_wixel_track$USBADDR$0$0 == 0xde00
                    DE00    875 _USBADDR	=	0xde00
                    DE01    876 Fslave_wixel_track$USBPOW$0$0 == 0xde01
                    DE01    877 _USBPOW	=	0xde01
                    DE02    878 Fslave_wixel_track$USBIIF$0$0 == 0xde02
                    DE02    879 _USBIIF	=	0xde02
                    DE04    880 Fslave_wixel_track$USBOIF$0$0 == 0xde04
                    DE04    881 _USBOIF	=	0xde04
                    DE06    882 Fslave_wixel_track$USBCIF$0$0 == 0xde06
                    DE06    883 _USBCIF	=	0xde06
                    DE07    884 Fslave_wixel_track$USBIIE$0$0 == 0xde07
                    DE07    885 _USBIIE	=	0xde07
                    DE09    886 Fslave_wixel_track$USBOIE$0$0 == 0xde09
                    DE09    887 _USBOIE	=	0xde09
                    DE0B    888 Fslave_wixel_track$USBCIE$0$0 == 0xde0b
                    DE0B    889 _USBCIE	=	0xde0b
                    DE0C    890 Fslave_wixel_track$USBFRML$0$0 == 0xde0c
                    DE0C    891 _USBFRML	=	0xde0c
                    DE0D    892 Fslave_wixel_track$USBFRMH$0$0 == 0xde0d
                    DE0D    893 _USBFRMH	=	0xde0d
                    DE0E    894 Fslave_wixel_track$USBINDEX$0$0 == 0xde0e
                    DE0E    895 _USBINDEX	=	0xde0e
                    DE10    896 Fslave_wixel_track$USBMAXI$0$0 == 0xde10
                    DE10    897 _USBMAXI	=	0xde10
                    DE11    898 Fslave_wixel_track$USBCSIL$0$0 == 0xde11
                    DE11    899 _USBCSIL	=	0xde11
                    DE12    900 Fslave_wixel_track$USBCSIH$0$0 == 0xde12
                    DE12    901 _USBCSIH	=	0xde12
                    DE13    902 Fslave_wixel_track$USBMAXO$0$0 == 0xde13
                    DE13    903 _USBMAXO	=	0xde13
                    DE14    904 Fslave_wixel_track$USBCSOL$0$0 == 0xde14
                    DE14    905 _USBCSOL	=	0xde14
                    DE15    906 Fslave_wixel_track$USBCSOH$0$0 == 0xde15
                    DE15    907 _USBCSOH	=	0xde15
                    DE16    908 Fslave_wixel_track$USBCNTL$0$0 == 0xde16
                    DE16    909 _USBCNTL	=	0xde16
                    DE17    910 Fslave_wixel_track$USBCNTH$0$0 == 0xde17
                    DE17    911 _USBCNTH	=	0xde17
                    DE20    912 Fslave_wixel_track$USBF0$0$0 == 0xde20
                    DE20    913 _USBF0	=	0xde20
                    DE22    914 Fslave_wixel_track$USBF1$0$0 == 0xde22
                    DE22    915 _USBF1	=	0xde22
                    DE24    916 Fslave_wixel_track$USBF2$0$0 == 0xde24
                    DE24    917 _USBF2	=	0xde24
                    DE26    918 Fslave_wixel_track$USBF3$0$0 == 0xde26
                    DE26    919 _USBF3	=	0xde26
                    DE28    920 Fslave_wixel_track$USBF4$0$0 == 0xde28
                    DE28    921 _USBF4	=	0xde28
                    DE2A    922 Fslave_wixel_track$USBF5$0$0 == 0xde2a
                    DE2A    923 _USBF5	=	0xde2a
                    0000    924 Fslave_wixel_track$rxPacket$0$0==.
   F0FD                     925 _rxPacket:
   F0FD                     926 	.ds 67
                            927 ;--------------------------------------------------------
                            928 ; absolute external ram data
                            929 ;--------------------------------------------------------
                            930 	.area XABS    (ABS,XDATA)
                            931 ;--------------------------------------------------------
                            932 ; external initialized ram data
                            933 ;--------------------------------------------------------
                            934 	.area XISEG   (XDATA)
                            935 	.area HOME    (CODE)
                            936 	.area GSINIT0 (CODE)
                            937 	.area GSINIT1 (CODE)
                            938 	.area GSINIT2 (CODE)
                            939 	.area GSINIT3 (CODE)
                            940 	.area GSINIT4 (CODE)
                            941 	.area GSINIT5 (CODE)
                            942 	.area GSINIT  (CODE)
                            943 	.area GSFINAL (CODE)
                            944 	.area CSEG    (CODE)
                            945 ;--------------------------------------------------------
                            946 ; interrupt vector 
                            947 ;--------------------------------------------------------
                            948 	.area HOME    (CODE)
   0400                     949 __interrupt_vect:
   0400 02 04 6B            950 	ljmp	__sdcc_gsinit_startup
   0403 32                  951 	reti
   0404                     952 	.ds	7
   040B 32                  953 	reti
   040C                     954 	.ds	7
   0413 32                  955 	reti
   0414                     956 	.ds	7
   041B 32                  957 	reti
   041C                     958 	.ds	7
   0423 32                  959 	reti
   0424                     960 	.ds	7
   042B 32                  961 	reti
   042C                     962 	.ds	7
   0433 32                  963 	reti
   0434                     964 	.ds	7
   043B 32                  965 	reti
   043C                     966 	.ds	7
   0443 32                  967 	reti
   0444                     968 	.ds	7
   044B 32                  969 	reti
   044C                     970 	.ds	7
   0453 32                  971 	reti
   0454                     972 	.ds	7
   045B 32                  973 	reti
   045C                     974 	.ds	7
   0463 02 20 67            975 	ljmp	_ISR_T4
                            976 ;--------------------------------------------------------
                            977 ; global & static initialisations
                            978 ;--------------------------------------------------------
                            979 	.area HOME    (CODE)
                            980 	.area GSINIT  (CODE)
                            981 	.area GSFINAL (CODE)
                            982 	.area GSINIT  (CODE)
                            983 	.globl __sdcc_gsinit_startup
                            984 	.globl __sdcc_program_startup
                            985 	.globl __start__stack
                            986 	.globl __mcs51_genXINIT
                            987 	.globl __mcs51_genXRAMCLEAR
                            988 	.globl __mcs51_genRAMCLEAR
                    0000    989 	G$main$0$0 ==.
                    0000    990 	C$slave_wixel_track.c$111$1$1 ==.
                            991 ;	apps/slave_wixel_track/slave_wixel_track.c:111: uint8 currentState = STATE_IDLE;
   04C4 78 00               992 	mov	r0,#_currentState
   04C6 E4                  993 	clr	a
   04C7 F2                  994 	movx	@r0,a
                    0004    995 	G$main$0$0 ==.
                    0004    996 	C$slave_wixel_track.c$114$1$1 ==.
                            997 ;	apps/slave_wixel_track/slave_wixel_track.c:114: uint16 lastPacketTimeCheck = 0;
   04C8 78 01               998 	mov	r0,#_lastPacketTimeCheck
   04CA E4                  999 	clr	a
   04CB F2                 1000 	movx	@r0,a
   04CC 08                 1001 	inc	r0
   04CD F2                 1002 	movx	@r0,a
                    000A   1003 	G$main$0$0 ==.
                    000A   1004 	C$slave_wixel_track.c$115$1$1 ==.
                           1005 ;	apps/slave_wixel_track/slave_wixel_track.c:115: uint16 lastPacketTime = 0;
   04CE 78 03              1006 	mov	r0,#_lastPacketTime
   04D0 E4                 1007 	clr	a
   04D1 F2                 1008 	movx	@r0,a
   04D2 08                 1009 	inc	r0
   04D3 F2                 1010 	movx	@r0,a
                    0010   1011 	G$main$0$0 ==.
                    0010   1012 	C$slave_wixel_track.c$116$1$1 ==.
                           1013 ;	apps/slave_wixel_track/slave_wixel_track.c:116: uint16 counter_loop = 0;
   04D4 78 05              1014 	mov	r0,#_counter_loop
   04D6 E4                 1015 	clr	a
   04D7 F2                 1016 	movx	@r0,a
   04D8 08                 1017 	inc	r0
   04D9 F2                 1018 	movx	@r0,a
                    0016   1019 	G$main$0$0 ==.
                    0016   1020 	C$slave_wixel_track.c$117$1$1 ==.
                           1021 ;	apps/slave_wixel_track/slave_wixel_track.c:117: uint32 now = 0;
   04DA 78 07              1022 	mov	r0,#_now
   04DC E4                 1023 	clr	a
   04DD F2                 1024 	movx	@r0,a
   04DE 08                 1025 	inc	r0
   04DF F2                 1026 	movx	@r0,a
   04E0 08                 1027 	inc	r0
   04E1 F2                 1028 	movx	@r0,a
   04E2 08                 1029 	inc	r0
   04E3 F2                 1030 	movx	@r0,a
                    0020   1031 	G$main$0$0 ==.
                    0020   1032 	C$slave_wixel_track.c$118$1$1 ==.
                           1033 ;	apps/slave_wixel_track/slave_wixel_track.c:118: uint32 rxPulseStart = 1;
   04E4 78 0B              1034 	mov	r0,#_rxPulseStart
   04E6 74 01              1035 	mov	a,#0x01
   04E8 F2                 1036 	movx	@r0,a
   04E9 08                 1037 	inc	r0
   04EA E4                 1038 	clr	a
   04EB F2                 1039 	movx	@r0,a
   04EC 08                 1040 	inc	r0
   04ED F2                 1041 	movx	@r0,a
   04EE 08                 1042 	inc	r0
   04EF F2                 1043 	movx	@r0,a
                    002C   1044 	G$main$0$0 ==.
                    002C   1045 	C$slave_wixel_track.c$121$1$1 ==.
                           1046 ;	apps/slave_wixel_track/slave_wixel_track.c:121: int16 posX = 0;
   04F0 78 0F              1047 	mov	r0,#_posX
   04F2 E4                 1048 	clr	a
   04F3 F2                 1049 	movx	@r0,a
   04F4 08                 1050 	inc	r0
   04F5 F2                 1051 	movx	@r0,a
                    0032   1052 	G$main$0$0 ==.
                    0032   1053 	C$slave_wixel_track.c$122$1$1 ==.
                           1054 ;	apps/slave_wixel_track/slave_wixel_track.c:122: int16 posY = 0;
   04F6 78 11              1055 	mov	r0,#_posY
   04F8 E4                 1056 	clr	a
   04F9 F2                 1057 	movx	@r0,a
   04FA 08                 1058 	inc	r0
   04FB F2                 1059 	movx	@r0,a
                    0038   1060 	G$main$0$0 ==.
                    0038   1061 	C$slave_wixel_track.c$123$1$1 ==.
                           1062 ;	apps/slave_wixel_track/slave_wixel_track.c:123: int16 posTheta = 0;
   04FC 78 13              1063 	mov	r0,#_posTheta
   04FE E4                 1064 	clr	a
   04FF F2                 1065 	movx	@r0,a
   0500 08                 1066 	inc	r0
   0501 F2                 1067 	movx	@r0,a
                    003E   1068 	G$main$0$0 ==.
                    003E   1069 	C$slave_wixel_track.c$126$1$1 ==.
                           1070 ;	apps/slave_wixel_track/slave_wixel_track.c:126: int16 filteredX = 0;
   0502 78 15              1071 	mov	r0,#_filteredX
   0504 E4                 1072 	clr	a
   0505 F2                 1073 	movx	@r0,a
   0506 08                 1074 	inc	r0
   0507 F2                 1075 	movx	@r0,a
                    0044   1076 	G$main$0$0 ==.
                    0044   1077 	C$slave_wixel_track.c$127$1$1 ==.
                           1078 ;	apps/slave_wixel_track/slave_wixel_track.c:127: int16 filteredY = 0;
   0508 78 17              1079 	mov	r0,#_filteredY
   050A E4                 1080 	clr	a
   050B F2                 1081 	movx	@r0,a
   050C 08                 1082 	inc	r0
   050D F2                 1083 	movx	@r0,a
                    004A   1084 	G$main$0$0 ==.
                    004A   1085 	C$slave_wixel_track.c$128$1$1 ==.
                           1086 ;	apps/slave_wixel_track/slave_wixel_track.c:128: int16 filteredTheta = 0;
   050E 78 19              1087 	mov	r0,#_filteredTheta
   0510 E4                 1088 	clr	a
   0511 F2                 1089 	movx	@r0,a
   0512 08                 1090 	inc	r0
   0513 F2                 1091 	movx	@r0,a
                    0050   1092 	G$main$0$0 ==.
                    0050   1093 	C$slave_wixel_track.c$131$1$1 ==.
                           1094 ;	apps/slave_wixel_track/slave_wixel_track.c:131: int16 targetX = 0;
   0514 78 1B              1095 	mov	r0,#_targetX
   0516 E4                 1096 	clr	a
   0517 F2                 1097 	movx	@r0,a
   0518 08                 1098 	inc	r0
   0519 F2                 1099 	movx	@r0,a
                    0056   1100 	G$main$0$0 ==.
                    0056   1101 	C$slave_wixel_track.c$132$1$1 ==.
                           1102 ;	apps/slave_wixel_track/slave_wixel_track.c:132: int16 lastTargetX = 0;
   051A 78 1D              1103 	mov	r0,#_lastTargetX
   051C E4                 1104 	clr	a
   051D F2                 1105 	movx	@r0,a
   051E 08                 1106 	inc	r0
   051F F2                 1107 	movx	@r0,a
                    005C   1108 	G$main$0$0 ==.
                    005C   1109 	C$slave_wixel_track.c$133$1$1 ==.
                           1110 ;	apps/slave_wixel_track/slave_wixel_track.c:133: int16 targetY = 0;
   0520 78 1F              1111 	mov	r0,#_targetY
   0522 E4                 1112 	clr	a
   0523 F2                 1113 	movx	@r0,a
   0524 08                 1114 	inc	r0
   0525 F2                 1115 	movx	@r0,a
                    0062   1116 	G$main$0$0 ==.
                    0062   1117 	C$slave_wixel_track.c$134$1$1 ==.
                           1118 ;	apps/slave_wixel_track/slave_wixel_track.c:134: int16 lastTargetY = 0;
   0526 78 21              1119 	mov	r0,#_lastTargetY
   0528 E4                 1120 	clr	a
   0529 F2                 1121 	movx	@r0,a
   052A 08                 1122 	inc	r0
   052B F2                 1123 	movx	@r0,a
                    0068   1124 	G$main$0$0 ==.
                    0068   1125 	C$slave_wixel_track.c$137$1$1 ==.
                           1126 ;	apps/slave_wixel_track/slave_wixel_track.c:137: uint32 stateStartTime = 0;
   052C 78 23              1127 	mov	r0,#_stateStartTime
   052E E4                 1128 	clr	a
   052F F2                 1129 	movx	@r0,a
   0530 08                 1130 	inc	r0
   0531 F2                 1131 	movx	@r0,a
   0532 08                 1132 	inc	r0
   0533 F2                 1133 	movx	@r0,a
   0534 08                 1134 	inc	r0
   0535 F2                 1135 	movx	@r0,a
                    0072   1136 	G$main$0$0 ==.
                    0072   1137 	C$slave_wixel_track.c$140$1$1 ==.
                           1138 ;	apps/slave_wixel_track/slave_wixel_track.c:140: int16 pwm_left = 0;
   0536 78 27              1139 	mov	r0,#_pwm_left
   0538 E4                 1140 	clr	a
   0539 F2                 1141 	movx	@r0,a
   053A 08                 1142 	inc	r0
   053B F2                 1143 	movx	@r0,a
                    0078   1144 	G$main$0$0 ==.
                    0078   1145 	C$slave_wixel_track.c$141$1$1 ==.
                           1146 ;	apps/slave_wixel_track/slave_wixel_track.c:141: int16 pwm_right = 0;
   053C 78 29              1147 	mov	r0,#_pwm_right
   053E E4                 1148 	clr	a
   053F F2                 1149 	movx	@r0,a
   0540 08                 1150 	inc	r0
   0541 F2                 1151 	movx	@r0,a
                    007E   1152 	G$main$0$0 ==.
                    007E   1153 	C$slave_wixel_track.c$144$1$1 ==.
                           1154 ;	apps/slave_wixel_track/slave_wixel_track.c:144: int16 manualPwmLeft = 0;
   0542 78 2B              1155 	mov	r0,#_manualPwmLeft
   0544 E4                 1156 	clr	a
   0545 F2                 1157 	movx	@r0,a
   0546 08                 1158 	inc	r0
   0547 F2                 1159 	movx	@r0,a
                    0084   1160 	G$main$0$0 ==.
                    0084   1161 	C$slave_wixel_track.c$145$1$1 ==.
                           1162 ;	apps/slave_wixel_track/slave_wixel_track.c:145: int16 manualPwmRight = 0;
   0548 78 2D              1163 	mov	r0,#_manualPwmRight
   054A E4                 1164 	clr	a
   054B F2                 1165 	movx	@r0,a
   054C 08                 1166 	inc	r0
   054D F2                 1167 	movx	@r0,a
                    008A   1168 	G$main$0$0 ==.
                    008A   1169 	C$slave_wixel_track.c$156$1$1 ==.
                           1170 ;	apps/slave_wixel_track/slave_wixel_track.c:156: uint8 waypointCount = 0;
   054E 78 93              1171 	mov	r0,#_waypointCount
   0550 E4                 1172 	clr	a
   0551 F2                 1173 	movx	@r0,a
                    008E   1174 	G$main$0$0 ==.
                    008E   1175 	C$slave_wixel_track.c$157$1$1 ==.
                           1176 ;	apps/slave_wixel_track/slave_wixel_track.c:157: uint8 waypointInputIndex = 0;
   0552 78 94              1177 	mov	r0,#_waypointInputIndex
   0554 E4                 1178 	clr	a
   0555 F2                 1179 	movx	@r0,a
                    0092   1180 	G$main$0$0 ==.
                    0092   1181 	C$slave_wixel_track.c$158$1$1 ==.
                           1182 ;	apps/slave_wixel_track/slave_wixel_track.c:158: uint8 currentWaypointIndex = 0;
   0556 78 95              1183 	mov	r0,#_currentWaypointIndex
   0558 E4                 1184 	clr	a
   0559 F2                 1185 	movx	@r0,a
                    0096   1186 	G$main$0$0 ==.
                    0096   1187 	C$slave_wixel_track.c$161$1$1 ==.
                           1188 ;	apps/slave_wixel_track/slave_wixel_track.c:161: uint8 runSubState = 0;
   055A 78 96              1189 	mov	r0,#_runSubState
   055C E4                 1190 	clr	a
   055D F2                 1191 	movx	@r0,a
                    009A   1192 	G$main$0$0 ==.
                    009A   1193 	C$slave_wixel_track.c$164$1$1 ==.
                           1194 ;	apps/slave_wixel_track/slave_wixel_track.c:164: uint8 homeSubState = 0;
   055E 78 97              1195 	mov	r0,#_homeSubState
   0560 E4                 1196 	clr	a
   0561 F2                 1197 	movx	@r0,a
                    009E   1198 	G$main$0$0 ==.
                    009E   1199 	C$slave_wixel_track.c$177$1$1 ==.
                           1200 ;	apps/slave_wixel_track/slave_wixel_track.c:177: int16 orientationOffset = 0;  // degrees
   0562 78 AB              1201 	mov	r0,#_orientationOffset
   0564 E4                 1202 	clr	a
   0565 F2                 1203 	movx	@r0,a
   0566 08                 1204 	inc	r0
   0567 F2                 1205 	movx	@r0,a
                    00A4   1206 	G$main$0$0 ==.
                    00A4   1207 	C$slave_wixel_track.c$178$1$1 ==.
                           1208 ;	apps/slave_wixel_track/slave_wixel_track.c:178: int16 cal_targetHeading = 0;
   0568 78 AD              1209 	mov	r0,#_cal_targetHeading
   056A E4                 1210 	clr	a
   056B F2                 1211 	movx	@r0,a
   056C 08                 1212 	inc	r0
   056D F2                 1213 	movx	@r0,a
                    00AA   1214 	G$main$0$0 ==.
                    00AA   1215 	C$slave_wixel_track.c$179$1$1 ==.
                           1216 ;	apps/slave_wixel_track/slave_wixel_track.c:179: int16 cal_headingError = 0;
   056E 78 AF              1217 	mov	r0,#_cal_headingError
   0570 E4                 1218 	clr	a
   0571 F2                 1219 	movx	@r0,a
   0572 08                 1220 	inc	r0
   0573 F2                 1221 	movx	@r0,a
                    00B0   1222 	G$main$0$0 ==.
                    00B0   1223 	C$slave_wixel_track.c$180$1$1 ==.
                           1224 ;	apps/slave_wixel_track/slave_wixel_track.c:180: uint8 calib_step = 0;
   0574 78 B1              1225 	mov	r0,#_calib_step
   0576 E4                 1226 	clr	a
   0577 F2                 1227 	movx	@r0,a
                           1228 	.area GSFINAL (CODE)
   057D 02 04 66           1229 	ljmp	__sdcc_program_startup
                           1230 ;--------------------------------------------------------
                           1231 ; Home
                           1232 ;--------------------------------------------------------
                           1233 	.area HOME    (CODE)
                           1234 	.area HOME    (CODE)
   0466                    1235 __sdcc_program_startup:
   0466 12 1A F5           1236 	lcall	_main
                           1237 ;	return from main will lock up
   0469 80 FE              1238 	sjmp .
                           1239 ;--------------------------------------------------------
                           1240 ; code
                           1241 ;--------------------------------------------------------
                           1242 	.area CSEG    (CODE)
                           1243 ;------------------------------------------------------------
                           1244 ;Allocation info for local variables in function 'abs16'
                           1245 ;------------------------------------------------------------
                    0000   1246 	G$abs16$0$0 ==.
                    0000   1247 	C$slave_wixel_track.c$184$0$0 ==.
                           1248 ;	apps/slave_wixel_track/slave_wixel_track.c:184: int16 abs16(int16 val)
                           1249 ;	-----------------------------------------
                           1250 ;	 function abs16
                           1251 ;	-----------------------------------------
   0580                    1252 _abs16:
                    0007   1253 	ar7 = 0x07
                    0006   1254 	ar6 = 0x06
                    0005   1255 	ar5 = 0x05
                    0004   1256 	ar4 = 0x04
                    0003   1257 	ar3 = 0x03
                    0002   1258 	ar2 = 0x02
                    0001   1259 	ar1 = 0x01
                    0000   1260 	ar0 = 0x00
   0580 AE 82              1261 	mov	r6,dpl
                    0002   1262 	C$slave_wixel_track.c$186$1$1 ==.
                           1263 ;	apps/slave_wixel_track/slave_wixel_track.c:186: return (val < 0) ? -val : val;
   0582 E5 83              1264 	mov	a,dph
   0584 FF                 1265 	mov	r7,a
   0585 30 E7 09           1266 	jnb	acc.7,00103$
   0588 C3                 1267 	clr	c
   0589 E4                 1268 	clr	a
   058A 9E                 1269 	subb	a,r6
   058B FC                 1270 	mov	r4,a
   058C E4                 1271 	clr	a
   058D 9F                 1272 	subb	a,r7
   058E FD                 1273 	mov	r5,a
   058F 80 04              1274 	sjmp	00104$
   0591                    1275 00103$:
   0591 8E 04              1276 	mov	ar4,r6
   0593 8F 05              1277 	mov	ar5,r7
   0595                    1278 00104$:
   0595 8C 82              1279 	mov	dpl,r4
   0597 8D 83              1280 	mov	dph,r5
                    0019   1281 	C$slave_wixel_track.c$187$1$1 ==.
                    0019   1282 	XG$abs16$0$0 ==.
   0599 22                 1283 	ret
                           1284 ;------------------------------------------------------------
                           1285 ;Allocation info for local variables in function 'isWithinThreshold'
                           1286 ;------------------------------------------------------------
                           1287 ;sloc0                     Allocated with name '_isWithinThreshold_sloc0_1_0'
                           1288 ;------------------------------------------------------------
                    001A   1289 	G$isWithinThreshold$0$0 ==.
                    001A   1290 	C$slave_wixel_track.c$192$1$1 ==.
                           1291 ;	apps/slave_wixel_track/slave_wixel_track.c:192: uint8 isWithinThreshold(int16 currentX, int16 currentY, int16 targetX, int16 targetY, int16 threshold)
                           1292 ;	-----------------------------------------
                           1293 ;	 function isWithinThreshold
                           1294 ;	-----------------------------------------
   059A                    1295 _isWithinThreshold:
   059A AE 82              1296 	mov	r6,dpl
   059C AF 83              1297 	mov	r7,dph
                    001E   1298 	C$slave_wixel_track.c$194$1$1 ==.
                           1299 ;	apps/slave_wixel_track/slave_wixel_track.c:194: int16 dx = targetX - currentX;
   059E 78 B4              1300 	mov	r0,#_isWithinThreshold_PARM_3
   05A0 E2                 1301 	movx	a,@r0
   05A1 C3                 1302 	clr	c
   05A2 9E                 1303 	subb	a,r6
   05A3 FE                 1304 	mov	r6,a
   05A4 08                 1305 	inc	r0
   05A5 E2                 1306 	movx	a,@r0
   05A6 9F                 1307 	subb	a,r7
   05A7 FF                 1308 	mov	r7,a
                    0028   1309 	C$slave_wixel_track.c$195$1$1 ==.
                           1310 ;	apps/slave_wixel_track/slave_wixel_track.c:195: int16 dy = targetY - currentY;
   05A8 78 B6              1311 	mov	r0,#_isWithinThreshold_PARM_4
   05AA 79 B2              1312 	mov	r1,#_isWithinThreshold_PARM_2
   05AC E3                 1313 	movx	a,@r1
   05AD F5 F0              1314 	mov	b,a
   05AF C3                 1315 	clr	c
   05B0 E2                 1316 	movx	a,@r0
   05B1 95 F0              1317 	subb	a,b
   05B3 FC                 1318 	mov	r4,a
   05B4 09                 1319 	inc	r1
   05B5 E3                 1320 	movx	a,@r1
   05B6 F5 F0              1321 	mov	b,a
   05B8 08                 1322 	inc	r0
   05B9 E2                 1323 	movx	a,@r0
   05BA 95 F0              1324 	subb	a,b
   05BC FD                 1325 	mov	r5,a
                    003D   1326 	C$slave_wixel_track.c$196$1$1 ==.
                           1327 ;	apps/slave_wixel_track/slave_wixel_track.c:196: int32 distSquared = (int32)dx * dx + (int32)dy * dy;
   05BD EF                 1328 	mov	a,r7
   05BE 33                 1329 	rlc	a
   05BF 95 E0              1330 	subb	a,acc
   05C1 FB                 1331 	mov	r3,a
   05C2 FA                 1332 	mov	r2,a
   05C3 78 EB              1333 	mov	r0,#__mullong_PARM_2
   05C5 EE                 1334 	mov	a,r6
   05C6 F2                 1335 	movx	@r0,a
   05C7 08                 1336 	inc	r0
   05C8 EF                 1337 	mov	a,r7
   05C9 F2                 1338 	movx	@r0,a
   05CA 08                 1339 	inc	r0
   05CB EB                 1340 	mov	a,r3
   05CC F2                 1341 	movx	@r0,a
   05CD 08                 1342 	inc	r0
   05CE EA                 1343 	mov	a,r2
   05CF F2                 1344 	movx	@r0,a
   05D0 8E 82              1345 	mov	dpl,r6
   05D2 8F 83              1346 	mov	dph,r7
   05D4 8B F0              1347 	mov	b,r3
   05D6 EA                 1348 	mov	a,r2
   05D7 C0 05              1349 	push	ar5
   05D9 C0 04              1350 	push	ar4
   05DB 12 1E 60           1351 	lcall	__mullong
   05DE 85 82 08           1352 	mov	_isWithinThreshold_sloc0_1_0,dpl
   05E1 85 83 09           1353 	mov	(_isWithinThreshold_sloc0_1_0 + 1),dph
   05E4 85 F0 0A           1354 	mov	(_isWithinThreshold_sloc0_1_0 + 2),b
   05E7 F5 0B              1355 	mov	(_isWithinThreshold_sloc0_1_0 + 3),a
   05E9 D0 04              1356 	pop	ar4
   05EB D0 05              1357 	pop	ar5
   05ED ED                 1358 	mov	a,r5
   05EE 33                 1359 	rlc	a
   05EF 95 E0              1360 	subb	a,acc
   05F1 FE                 1361 	mov	r6,a
   05F2 FF                 1362 	mov	r7,a
   05F3 78 EB              1363 	mov	r0,#__mullong_PARM_2
   05F5 EC                 1364 	mov	a,r4
   05F6 F2                 1365 	movx	@r0,a
   05F7 08                 1366 	inc	r0
   05F8 ED                 1367 	mov	a,r5
   05F9 F2                 1368 	movx	@r0,a
   05FA 08                 1369 	inc	r0
   05FB EE                 1370 	mov	a,r6
   05FC F2                 1371 	movx	@r0,a
   05FD 08                 1372 	inc	r0
   05FE EF                 1373 	mov	a,r7
   05FF F2                 1374 	movx	@r0,a
   0600 8C 82              1375 	mov	dpl,r4
   0602 8D 83              1376 	mov	dph,r5
   0604 8E F0              1377 	mov	b,r6
   0606 EF                 1378 	mov	a,r7
   0607 12 1E 60           1379 	lcall	__mullong
   060A AC 82              1380 	mov	r4,dpl
   060C AD 83              1381 	mov	r5,dph
   060E AE F0              1382 	mov	r6,b
   0610 FF                 1383 	mov	r7,a
   0611 78 BA              1384 	mov	r0,#_isWithinThreshold_distSquared_1_1
   0613 EC                 1385 	mov	a,r4
   0614 25 08              1386 	add	a,_isWithinThreshold_sloc0_1_0
   0616 F2                 1387 	movx	@r0,a
   0617 ED                 1388 	mov	a,r5
   0618 35 09              1389 	addc	a,(_isWithinThreshold_sloc0_1_0 + 1)
   061A 08                 1390 	inc	r0
   061B F2                 1391 	movx	@r0,a
   061C EE                 1392 	mov	a,r6
   061D 35 0A              1393 	addc	a,(_isWithinThreshold_sloc0_1_0 + 2)
   061F 08                 1394 	inc	r0
   0620 F2                 1395 	movx	@r0,a
   0621 EF                 1396 	mov	a,r7
   0622 35 0B              1397 	addc	a,(_isWithinThreshold_sloc0_1_0 + 3)
   0624 08                 1398 	inc	r0
   0625 F2                 1399 	movx	@r0,a
                    00A6   1400 	C$slave_wixel_track.c$197$1$1 ==.
                           1401 ;	apps/slave_wixel_track/slave_wixel_track.c:197: int32 thresholdSquared = (int32)threshold * threshold;
   0626 78 B8              1402 	mov	r0,#_isWithinThreshold_PARM_5
   0628 E2                 1403 	movx	a,@r0
   0629 FA                 1404 	mov	r2,a
   062A 08                 1405 	inc	r0
   062B E2                 1406 	movx	a,@r0
   062C FB                 1407 	mov	r3,a
   062D E2                 1408 	movx	a,@r0
   062E 33                 1409 	rlc	a
   062F 95 E0              1410 	subb	a,acc
   0631 FE                 1411 	mov	r6,a
   0632 FF                 1412 	mov	r7,a
   0633 78 EB              1413 	mov	r0,#__mullong_PARM_2
   0635 EA                 1414 	mov	a,r2
   0636 F2                 1415 	movx	@r0,a
   0637 08                 1416 	inc	r0
   0638 EB                 1417 	mov	a,r3
   0639 F2                 1418 	movx	@r0,a
   063A 08                 1419 	inc	r0
   063B EE                 1420 	mov	a,r6
   063C F2                 1421 	movx	@r0,a
   063D 08                 1422 	inc	r0
   063E EF                 1423 	mov	a,r7
   063F F2                 1424 	movx	@r0,a
   0640 8A 82              1425 	mov	dpl,r2
   0642 8B 83              1426 	mov	dph,r3
   0644 8E F0              1427 	mov	b,r6
   0646 EF                 1428 	mov	a,r7
   0647 12 1E 60           1429 	lcall	__mullong
   064A AC 82              1430 	mov	r4,dpl
   064C AD 83              1431 	mov	r5,dph
   064E AE F0              1432 	mov	r6,b
   0650 FF                 1433 	mov	r7,a
                    00D1   1434 	C$slave_wixel_track.c$199$1$1 ==.
                           1435 ;	apps/slave_wixel_track/slave_wixel_track.c:199: return (distSquared < thresholdSquared);
   0651 78 BA              1436 	mov	r0,#_isWithinThreshold_distSquared_1_1
   0653 C3                 1437 	clr	c
   0654 E2                 1438 	movx	a,@r0
   0655 9C                 1439 	subb	a,r4
   0656 08                 1440 	inc	r0
   0657 E2                 1441 	movx	a,@r0
   0658 9D                 1442 	subb	a,r5
   0659 08                 1443 	inc	r0
   065A E2                 1444 	movx	a,@r0
   065B 9E                 1445 	subb	a,r6
   065C 08                 1446 	inc	r0
   065D E2                 1447 	movx	a,@r0
   065E 64 80              1448 	xrl	a,#0x80
   0660 8F F0              1449 	mov	b,r7
   0662 63 F0 80           1450 	xrl	b,#0x80
   0665 95 F0              1451 	subb	a,b
   0667 E4                 1452 	clr	a
   0668 33                 1453 	rlc	a
                    00E9   1454 	C$slave_wixel_track.c$200$1$1 ==.
                    00E9   1455 	XG$isWithinThreshold$0$0 ==.
   0669 F5 82              1456 	mov	dpl,a
   066B 22                 1457 	ret
                           1458 ;------------------------------------------------------------
                           1459 ;Allocation info for local variables in function 'calculateTargetHeading'
                           1460 ;------------------------------------------------------------
                           1461 ;sloc0                     Allocated with name '_calculateTargetHeading_sloc0_1_0'
                           1462 ;------------------------------------------------------------
                    00EC   1463 	G$calculateTargetHeading$0$0 ==.
                    00EC   1464 	C$slave_wixel_track.c$204$1$1 ==.
                           1465 ;	apps/slave_wixel_track/slave_wixel_track.c:204: int16 calculateTargetHeading(int16 currentX, int16 currentY, int16 goalX, int16 goalY)
                           1466 ;	-----------------------------------------
                           1467 ;	 function calculateTargetHeading
                           1468 ;	-----------------------------------------
   066C                    1469 _calculateTargetHeading:
   066C AE 82              1470 	mov	r6,dpl
   066E AF 83              1471 	mov	r7,dph
                    00F0   1472 	C$slave_wixel_track.c$211$1$1 ==.
                           1473 ;	apps/slave_wixel_track/slave_wixel_track.c:211: dx = (int32)goalX - (int32)currentX;
   0670 78 C0              1474 	mov	r0,#_calculateTargetHeading_PARM_3
   0672 E2                 1475 	movx	a,@r0
   0673 F5 0C              1476 	mov	_calculateTargetHeading_sloc0_1_0,a
   0675 08                 1477 	inc	r0
   0676 E2                 1478 	movx	a,@r0
   0677 F5 0D              1479 	mov	(_calculateTargetHeading_sloc0_1_0 + 1),a
   0679 E2                 1480 	movx	a,@r0
   067A 33                 1481 	rlc	a
   067B 95 E0              1482 	subb	a,acc
   067D F5 0E              1483 	mov	(_calculateTargetHeading_sloc0_1_0 + 2),a
   067F F5 0F              1484 	mov	(_calculateTargetHeading_sloc0_1_0 + 3),a
   0681 8E 04              1485 	mov	ar4,r6
   0683 EF                 1486 	mov	a,r7
   0684 FD                 1487 	mov	r5,a
   0685 33                 1488 	rlc	a
   0686 95 E0              1489 	subb	a,acc
   0688 FE                 1490 	mov	r6,a
   0689 FF                 1491 	mov	r7,a
   068A 78 C4              1492 	mov	r0,#_calculateTargetHeading_dx_1_1
   068C E5 0C              1493 	mov	a,_calculateTargetHeading_sloc0_1_0
   068E C3                 1494 	clr	c
   068F 9C                 1495 	subb	a,r4
   0690 F2                 1496 	movx	@r0,a
   0691 E5 0D              1497 	mov	a,(_calculateTargetHeading_sloc0_1_0 + 1)
   0693 9D                 1498 	subb	a,r5
   0694 08                 1499 	inc	r0
   0695 F2                 1500 	movx	@r0,a
   0696 E5 0E              1501 	mov	a,(_calculateTargetHeading_sloc0_1_0 + 2)
   0698 9E                 1502 	subb	a,r6
   0699 08                 1503 	inc	r0
   069A F2                 1504 	movx	@r0,a
   069B E5 0F              1505 	mov	a,(_calculateTargetHeading_sloc0_1_0 + 3)
   069D 9F                 1506 	subb	a,r7
   069E 08                 1507 	inc	r0
   069F F2                 1508 	movx	@r0,a
                    0120   1509 	C$slave_wixel_track.c$212$1$1 ==.
                           1510 ;	apps/slave_wixel_track/slave_wixel_track.c:212: dy = (int32)goalY - (int32)currentY;
   06A0 78 C2              1511 	mov	r0,#_calculateTargetHeading_PARM_4
   06A2 E2                 1512 	movx	a,@r0
   06A3 F5 0C              1513 	mov	_calculateTargetHeading_sloc0_1_0,a
   06A5 08                 1514 	inc	r0
   06A6 E2                 1515 	movx	a,@r0
   06A7 F5 0D              1516 	mov	(_calculateTargetHeading_sloc0_1_0 + 1),a
   06A9 E2                 1517 	movx	a,@r0
   06AA 33                 1518 	rlc	a
   06AB 95 E0              1519 	subb	a,acc
   06AD F5 0E              1520 	mov	(_calculateTargetHeading_sloc0_1_0 + 2),a
   06AF F5 0F              1521 	mov	(_calculateTargetHeading_sloc0_1_0 + 3),a
   06B1 78 BE              1522 	mov	r0,#_calculateTargetHeading_PARM_2
   06B3 E2                 1523 	movx	a,@r0
   06B4 FC                 1524 	mov	r4,a
   06B5 08                 1525 	inc	r0
   06B6 E2                 1526 	movx	a,@r0
   06B7 FD                 1527 	mov	r5,a
   06B8 E2                 1528 	movx	a,@r0
   06B9 33                 1529 	rlc	a
   06BA 95 E0              1530 	subb	a,acc
   06BC FE                 1531 	mov	r6,a
   06BD FF                 1532 	mov	r7,a
   06BE E5 0C              1533 	mov	a,_calculateTargetHeading_sloc0_1_0
   06C0 C3                 1534 	clr	c
   06C1 9C                 1535 	subb	a,r4
   06C2 FC                 1536 	mov	r4,a
   06C3 E5 0D              1537 	mov	a,(_calculateTargetHeading_sloc0_1_0 + 1)
   06C5 9D                 1538 	subb	a,r5
   06C6 FD                 1539 	mov	r5,a
   06C7 E5 0E              1540 	mov	a,(_calculateTargetHeading_sloc0_1_0 + 2)
   06C9 9E                 1541 	subb	a,r6
   06CA FE                 1542 	mov	r6,a
   06CB E5 0F              1543 	mov	a,(_calculateTargetHeading_sloc0_1_0 + 3)
   06CD 9F                 1544 	subb	a,r7
   06CE FF                 1545 	mov	r7,a
                    014F   1546 	C$slave_wixel_track.c$214$1$1 ==.
                           1547 ;	apps/slave_wixel_track/slave_wixel_track.c:214: if (dx == 0 && dy == 0)
   06CF 78 C4              1548 	mov	r0,#_calculateTargetHeading_dx_1_1
   06D1 E2                 1549 	movx	a,@r0
   06D2 F5 F0              1550 	mov	b,a
   06D4 08                 1551 	inc	r0
   06D5 E2                 1552 	movx	a,@r0
   06D6 42 F0              1553 	orl	b,a
   06D8 08                 1554 	inc	r0
   06D9 E2                 1555 	movx	a,@r0
   06DA 42 F0              1556 	orl	b,a
   06DC 08                 1557 	inc	r0
   06DD E2                 1558 	movx	a,@r0
   06DE 45 F0              1559 	orl	a,b
   06E0 70 0C              1560 	jnz	00102$
   06E2 EC                 1561 	mov	a,r4
   06E3 4D                 1562 	orl	a,r5
   06E4 4E                 1563 	orl	a,r6
   06E5 4F                 1564 	orl	a,r7
   06E6 70 06              1565 	jnz	00102$
                    0168   1566 	C$slave_wixel_track.c$215$1$1 ==.
                           1567 ;	apps/slave_wixel_track/slave_wixel_track.c:215: return 0;
   06E8 90 00 00           1568 	mov	dptr,#0x0000
   06EB 02 0A EB           1569 	ljmp	00123$
   06EE                    1570 00102$:
                    016E   1571 	C$slave_wixel_track.c$217$1$1 ==.
                           1572 ;	apps/slave_wixel_track/slave_wixel_track.c:217: if (dx == 0)
   06EE 78 C4              1573 	mov	r0,#_calculateTargetHeading_dx_1_1
   06F0 E2                 1574 	movx	a,@r0
   06F1 F5 F0              1575 	mov	b,a
   06F3 08                 1576 	inc	r0
   06F4 E2                 1577 	movx	a,@r0
   06F5 42 F0              1578 	orl	b,a
   06F7 08                 1579 	inc	r0
   06F8 E2                 1580 	movx	a,@r0
   06F9 42 F0              1581 	orl	b,a
   06FB 08                 1582 	inc	r0
   06FC E2                 1583 	movx	a,@r0
   06FD 45 F0              1584 	orl	a,b
   06FF 70 25              1585 	jnz	00105$
                    0181   1586 	C$slave_wixel_track.c$218$1$1 ==.
                           1587 ;	apps/slave_wixel_track/slave_wixel_track.c:218: return (dy > 0) ? 90 : -90;
   0701 C3                 1588 	clr	c
   0702 E4                 1589 	clr	a
   0703 9C                 1590 	subb	a,r4
   0704 E4                 1591 	clr	a
   0705 9D                 1592 	subb	a,r5
   0706 E4                 1593 	clr	a
   0707 9E                 1594 	subb	a,r6
   0708 E4                 1595 	clr	a
   0709 64 80              1596 	xrl	a,#0x80
   070B 8F F0              1597 	mov	b,r7
   070D 63 F0 80           1598 	xrl	b,#0x80
   0710 95 F0              1599 	subb	a,b
   0712 50 04              1600 	jnc	00125$
   0714 7B 5A              1601 	mov	r3,#0x5A
   0716 80 02              1602 	sjmp	00126$
   0718                    1603 00125$:
   0718 7B A6              1604 	mov	r3,#0xA6
   071A                    1605 00126$:
   071A EB                 1606 	mov	a,r3
   071B 33                 1607 	rlc	a
   071C 95 E0              1608 	subb	a,acc
   071E FA                 1609 	mov	r2,a
   071F 8B 82              1610 	mov	dpl,r3
   0721 8A 83              1611 	mov	dph,r2
   0723 02 0A EB           1612 	ljmp	00123$
   0726                    1613 00105$:
                    01A6   1614 	C$slave_wixel_track.c$220$1$1 ==.
                           1615 ;	apps/slave_wixel_track/slave_wixel_track.c:220: if (dy == 0)
   0726 EC                 1616 	mov	a,r4
   0727 4D                 1617 	orl	a,r5
   0728 4E                 1618 	orl	a,r6
   0729 4F                 1619 	orl	a,r7
   072A 70 34              1620 	jnz	00107$
                    01AC   1621 	C$slave_wixel_track.c$221$1$1 ==.
                           1622 ;	apps/slave_wixel_track/slave_wixel_track.c:221: return (dx > 0) ? 0 : 180;
   072C 78 C4              1623 	mov	r0,#_calculateTargetHeading_dx_1_1
   072E C3                 1624 	clr	c
   072F E2                 1625 	movx	a,@r0
   0730 F5 F0              1626 	mov	b,a
   0732 E4                 1627 	clr	a
   0733 95 F0              1628 	subb	a,b
   0735 08                 1629 	inc	r0
   0736 E2                 1630 	movx	a,@r0
   0737 F5 F0              1631 	mov	b,a
   0739 E4                 1632 	clr	a
   073A 95 F0              1633 	subb	a,b
   073C 08                 1634 	inc	r0
   073D E2                 1635 	movx	a,@r0
   073E F5 F0              1636 	mov	b,a
   0740 E4                 1637 	clr	a
   0741 95 F0              1638 	subb	a,b
   0743 08                 1639 	inc	r0
   0744 E2                 1640 	movx	a,@r0
   0745 F5 F0              1641 	mov	b,a
   0747 E4                 1642 	clr	a
   0748 64 80              1643 	xrl	a,#0x80
   074A 63 F0 80           1644 	xrl	b,#0x80
   074D 95 F0              1645 	subb	a,b
   074F 50 04              1646 	jnc	00127$
   0751 7B 00              1647 	mov	r3,#0x00
   0753 80 02              1648 	sjmp	00128$
   0755                    1649 00127$:
   0755 7B B4              1650 	mov	r3,#0xB4
   0757                    1651 00128$:
   0757 7A 00              1652 	mov	r2,#0x00
   0759 8B 82              1653 	mov	dpl,r3
   075B 8A 83              1654 	mov	dph,r2
   075D 02 0A EB           1655 	ljmp	00123$
   0760                    1656 00107$:
                    01E0   1657 	C$slave_wixel_track.c$223$1$1 ==.
                           1658 ;	apps/slave_wixel_track/slave_wixel_track.c:223: absX = (dx > 0) ? dx : -dx;
   0760 78 C4              1659 	mov	r0,#_calculateTargetHeading_dx_1_1
   0762 C3                 1660 	clr	c
   0763 E2                 1661 	movx	a,@r0
   0764 F5 F0              1662 	mov	b,a
   0766 E4                 1663 	clr	a
   0767 95 F0              1664 	subb	a,b
   0769 08                 1665 	inc	r0
   076A E2                 1666 	movx	a,@r0
   076B F5 F0              1667 	mov	b,a
   076D E4                 1668 	clr	a
   076E 95 F0              1669 	subb	a,b
   0770 08                 1670 	inc	r0
   0771 E2                 1671 	movx	a,@r0
   0772 F5 F0              1672 	mov	b,a
   0774 E4                 1673 	clr	a
   0775 95 F0              1674 	subb	a,b
   0777 08                 1675 	inc	r0
   0778 E2                 1676 	movx	a,@r0
   0779 F5 F0              1677 	mov	b,a
   077B E4                 1678 	clr	a
   077C 64 80              1679 	xrl	a,#0x80
   077E 63 F0 80           1680 	xrl	b,#0x80
   0781 95 F0              1681 	subb	a,b
   0783 50 14              1682 	jnc	00129$
   0785 78 C4              1683 	mov	r0,#_calculateTargetHeading_dx_1_1
   0787 79 C8              1684 	mov	r1,#_calculateTargetHeading_absX_1_1
   0789 E2                 1685 	movx	a,@r0
   078A F3                 1686 	movx	@r1,a
   078B 08                 1687 	inc	r0
   078C E2                 1688 	movx	a,@r0
   078D 09                 1689 	inc	r1
   078E F3                 1690 	movx	@r1,a
   078F 08                 1691 	inc	r0
   0790 E2                 1692 	movx	a,@r0
   0791 09                 1693 	inc	r1
   0792 F3                 1694 	movx	@r1,a
   0793 08                 1695 	inc	r0
   0794 E2                 1696 	movx	a,@r0
   0795 09                 1697 	inc	r1
   0796 F3                 1698 	movx	@r1,a
   0797 80 1F              1699 	sjmp	00130$
   0799                    1700 00129$:
   0799 78 C4              1701 	mov	r0,#_calculateTargetHeading_dx_1_1
   079B 79 C8              1702 	mov	r1,#_calculateTargetHeading_absX_1_1
   079D E2                 1703 	movx	a,@r0
   079E D3                 1704 	setb	c
   079F F4                 1705 	cpl	a
   07A0 34 00              1706 	addc	a,#0x00
   07A2 F3                 1707 	movx	@r1,a
   07A3 08                 1708 	inc	r0
   07A4 E2                 1709 	movx	a,@r0
   07A5 F4                 1710 	cpl	a
   07A6 34 00              1711 	addc	a,#0x00
   07A8 09                 1712 	inc	r1
   07A9 F3                 1713 	movx	@r1,a
   07AA 08                 1714 	inc	r0
   07AB E2                 1715 	movx	a,@r0
   07AC F4                 1716 	cpl	a
   07AD 34 00              1717 	addc	a,#0x00
   07AF 09                 1718 	inc	r1
   07B0 F3                 1719 	movx	@r1,a
   07B1 08                 1720 	inc	r0
   07B2 E2                 1721 	movx	a,@r0
   07B3 F4                 1722 	cpl	a
   07B4 34 00              1723 	addc	a,#0x00
   07B6 09                 1724 	inc	r1
   07B7 F3                 1725 	movx	@r1,a
   07B8                    1726 00130$:
   07B8 78 C8              1727 	mov	r0,#_calculateTargetHeading_absX_1_1
                    023A   1728 	C$slave_wixel_track.c$224$1$1 ==.
                           1729 ;	apps/slave_wixel_track/slave_wixel_track.c:224: absY = (dy > 0) ? dy : -dy;
   07BA C3                 1730 	clr	c
   07BB E4                 1731 	clr	a
   07BC 9C                 1732 	subb	a,r4
   07BD E4                 1733 	clr	a
   07BE 9D                 1734 	subb	a,r5
   07BF E4                 1735 	clr	a
   07C0 9E                 1736 	subb	a,r6
   07C1 E4                 1737 	clr	a
   07C2 64 80              1738 	xrl	a,#0x80
   07C4 8F F0              1739 	mov	b,r7
   07C6 63 F0 80           1740 	xrl	b,#0x80
   07C9 95 F0              1741 	subb	a,b
   07CB 50 0F              1742 	jnc	00131$
   07CD 78 CC              1743 	mov	r0,#_calculateTargetHeading_absY_1_1
   07CF EC                 1744 	mov	a,r4
   07D0 F2                 1745 	movx	@r0,a
   07D1 08                 1746 	inc	r0
   07D2 ED                 1747 	mov	a,r5
   07D3 F2                 1748 	movx	@r0,a
   07D4 08                 1749 	inc	r0
   07D5 EE                 1750 	mov	a,r6
   07D6 F2                 1751 	movx	@r0,a
   07D7 08                 1752 	inc	r0
   07D8 EF                 1753 	mov	a,r7
   07D9 F2                 1754 	movx	@r0,a
   07DA 80 12              1755 	sjmp	00132$
   07DC                    1756 00131$:
   07DC 78 CC              1757 	mov	r0,#_calculateTargetHeading_absY_1_1
   07DE C3                 1758 	clr	c
   07DF E4                 1759 	clr	a
   07E0 9C                 1760 	subb	a,r4
   07E1 F2                 1761 	movx	@r0,a
   07E2 E4                 1762 	clr	a
   07E3 9D                 1763 	subb	a,r5
   07E4 08                 1764 	inc	r0
   07E5 F2                 1765 	movx	@r0,a
   07E6 E4                 1766 	clr	a
   07E7 9E                 1767 	subb	a,r6
   07E8 08                 1768 	inc	r0
   07E9 F2                 1769 	movx	@r0,a
   07EA E4                 1770 	clr	a
   07EB 9F                 1771 	subb	a,r7
   07EC 08                 1772 	inc	r0
   07ED F2                 1773 	movx	@r0,a
   07EE                    1774 00132$:
                    026E   1775 	C$slave_wixel_track.c$226$1$1 ==.
                           1776 ;	apps/slave_wixel_track/slave_wixel_track.c:226: if (absX > absY)
   07EE 78 C8              1777 	mov	r0,#_calculateTargetHeading_absX_1_1
   07F0 79 CC              1778 	mov	r1,#_calculateTargetHeading_absY_1_1
   07F2 C3                 1779 	clr	c
   07F3 E2                 1780 	movx	a,@r0
   07F4 F5 F0              1781 	mov	b,a
   07F6 E3                 1782 	movx	a,@r1
   07F7 95 F0              1783 	subb	a,b
   07F9 08                 1784 	inc	r0
   07FA E2                 1785 	movx	a,@r0
   07FB F5 F0              1786 	mov	b,a
   07FD 09                 1787 	inc	r1
   07FE E3                 1788 	movx	a,@r1
   07FF 95 F0              1789 	subb	a,b
   0801 08                 1790 	inc	r0
   0802 E2                 1791 	movx	a,@r0
   0803 F5 F0              1792 	mov	b,a
   0805 09                 1793 	inc	r1
   0806 E3                 1794 	movx	a,@r1
   0807 95 F0              1795 	subb	a,b
   0809 08                 1796 	inc	r0
   080A E2                 1797 	movx	a,@r0
   080B F5 F0              1798 	mov	b,a
   080D 09                 1799 	inc	r1
   080E E3                 1800 	movx	a,@r1
   080F 64 80              1801 	xrl	a,#0x80
   0811 63 F0 80           1802 	xrl	b,#0x80
   0814 95 F0              1803 	subb	a,b
   0816 40 03              1804 	jc	00156$
   0818 02 09 56           1805 	ljmp	00109$
   081B                    1806 00156$:
                    029B   1807 	C$slave_wixel_track.c$228$1$1 ==.
                           1808 ;	apps/slave_wixel_track/slave_wixel_track.c:228: ratio = (absY * 1000L) / absX;
   081B C0 04              1809 	push	ar4
   081D C0 05              1810 	push	ar5
   081F C0 06              1811 	push	ar6
   0821 C0 07              1812 	push	ar7
   0823 78 CC              1813 	mov	r0,#_calculateTargetHeading_absY_1_1
   0825 79 EB              1814 	mov	r1,#__mullong_PARM_2
   0827 E2                 1815 	movx	a,@r0
   0828 F3                 1816 	movx	@r1,a
   0829 08                 1817 	inc	r0
   082A E2                 1818 	movx	a,@r0
   082B 09                 1819 	inc	r1
   082C F3                 1820 	movx	@r1,a
   082D 08                 1821 	inc	r0
   082E E2                 1822 	movx	a,@r0
   082F 09                 1823 	inc	r1
   0830 F3                 1824 	movx	@r1,a
   0831 08                 1825 	inc	r0
   0832 E2                 1826 	movx	a,@r0
   0833 09                 1827 	inc	r1
   0834 F3                 1828 	movx	@r1,a
   0835 90 03 E8           1829 	mov	dptr,#0x03E8
   0838 E4                 1830 	clr	a
   0839 F5 F0              1831 	mov	b,a
   083B C0 05              1832 	push	ar5
   083D C0 04              1833 	push	ar4
   083F 12 1E 60           1834 	lcall	__mullong
   0842 AA 82              1835 	mov	r2,dpl
   0844 AB 83              1836 	mov	r3,dph
   0846 AE F0              1837 	mov	r6,b
   0848 FF                 1838 	mov	r7,a
   0849 D0 04              1839 	pop	ar4
   084B D0 05              1840 	pop	ar5
   084D 78 C8              1841 	mov	r0,#_calculateTargetHeading_absX_1_1
   084F 79 DA              1842 	mov	r1,#__divslong_PARM_2
   0851 E2                 1843 	movx	a,@r0
   0852 F3                 1844 	movx	@r1,a
   0853 08                 1845 	inc	r0
   0854 E2                 1846 	movx	a,@r0
   0855 09                 1847 	inc	r1
   0856 F3                 1848 	movx	@r1,a
   0857 08                 1849 	inc	r0
   0858 E2                 1850 	movx	a,@r0
   0859 09                 1851 	inc	r1
   085A F3                 1852 	movx	@r1,a
   085B 08                 1853 	inc	r0
   085C E2                 1854 	movx	a,@r0
   085D 09                 1855 	inc	r1
   085E F3                 1856 	movx	@r1,a
   085F 8A 82              1857 	mov	dpl,r2
   0861 8B 83              1858 	mov	dph,r3
   0863 8E F0              1859 	mov	b,r6
   0865 EF                 1860 	mov	a,r7
   0866 C0 07              1861 	push	ar7
   0868 C0 06              1862 	push	ar6
   086A C0 05              1863 	push	ar5
   086C C0 04              1864 	push	ar4
   086E 12 1C 0F           1865 	lcall	__divslong
   0871 78 D2              1866 	mov	r0,#_calculateTargetHeading_ratio_1_1
   0873 C0 E0              1867 	push	acc
   0875 E5 82              1868 	mov	a,dpl
   0877 F2                 1869 	movx	@r0,a
   0878 08                 1870 	inc	r0
   0879 E5 83              1871 	mov	a,dph
   087B F2                 1872 	movx	@r0,a
   087C 08                 1873 	inc	r0
   087D E5 F0              1874 	mov	a,b
   087F F2                 1875 	movx	@r0,a
   0880 D0 E0              1876 	pop	acc
   0882 08                 1877 	inc	r0
   0883 F2                 1878 	movx	@r0,a
                    0304   1879 	C$slave_wixel_track.c$229$1$1 ==.
                           1880 ;	apps/slave_wixel_track/slave_wixel_track.c:229: angle = (int16)((57300L * ratio) / (1000000L + (280L * ratio * ratio) / 1000L));
   0884 78 D2              1881 	mov	r0,#_calculateTargetHeading_ratio_1_1
   0886 79 EB              1882 	mov	r1,#__mullong_PARM_2
   0888 E2                 1883 	movx	a,@r0
   0889 F3                 1884 	movx	@r1,a
   088A 08                 1885 	inc	r0
   088B E2                 1886 	movx	a,@r0
   088C 09                 1887 	inc	r1
   088D F3                 1888 	movx	@r1,a
   088E 08                 1889 	inc	r0
   088F E2                 1890 	movx	a,@r0
   0890 09                 1891 	inc	r1
   0891 F3                 1892 	movx	@r1,a
   0892 08                 1893 	inc	r0
   0893 E2                 1894 	movx	a,@r0
   0894 09                 1895 	inc	r1
   0895 F3                 1896 	movx	@r1,a
   0896 90 DF D4           1897 	mov	dptr,#0xDFD4
   0899 E4                 1898 	clr	a
   089A F5 F0              1899 	mov	b,a
   089C 12 1E 60           1900 	lcall	__mullong
   089F 85 82 0C           1901 	mov	_calculateTargetHeading_sloc0_1_0,dpl
   08A2 85 83 0D           1902 	mov	(_calculateTargetHeading_sloc0_1_0 + 1),dph
   08A5 85 F0 0E           1903 	mov	(_calculateTargetHeading_sloc0_1_0 + 2),b
   08A8 F5 0F              1904 	mov	(_calculateTargetHeading_sloc0_1_0 + 3),a
   08AA D0 04              1905 	pop	ar4
   08AC D0 05              1906 	pop	ar5
   08AE D0 06              1907 	pop	ar6
   08B0 D0 07              1908 	pop	ar7
   08B2 78 D2              1909 	mov	r0,#_calculateTargetHeading_ratio_1_1
   08B4 79 EB              1910 	mov	r1,#__mullong_PARM_2
   08B6 E2                 1911 	movx	a,@r0
   08B7 F3                 1912 	movx	@r1,a
   08B8 08                 1913 	inc	r0
   08B9 E2                 1914 	movx	a,@r0
   08BA 09                 1915 	inc	r1
   08BB F3                 1916 	movx	@r1,a
   08BC 08                 1917 	inc	r0
   08BD E2                 1918 	movx	a,@r0
   08BE 09                 1919 	inc	r1
   08BF F3                 1920 	movx	@r1,a
   08C0 08                 1921 	inc	r0
   08C1 E2                 1922 	movx	a,@r0
   08C2 09                 1923 	inc	r1
   08C3 F3                 1924 	movx	@r1,a
   08C4 90 01 18           1925 	mov	dptr,#0x0118
   08C7 E4                 1926 	clr	a
   08C8 F5 F0              1927 	mov	b,a
   08CA C0 05              1928 	push	ar5
   08CC C0 04              1929 	push	ar4
   08CE 12 1E 60           1930 	lcall	__mullong
   08D1 AA 82              1931 	mov	r2,dpl
   08D3 AB 83              1932 	mov	r3,dph
   08D5 AE F0              1933 	mov	r6,b
   08D7 FF                 1934 	mov	r7,a
   08D8 D0 04              1935 	pop	ar4
   08DA D0 05              1936 	pop	ar5
   08DC 78 D2              1937 	mov	r0,#_calculateTargetHeading_ratio_1_1
   08DE 79 EB              1938 	mov	r1,#__mullong_PARM_2
   08E0 E2                 1939 	movx	a,@r0
   08E1 F3                 1940 	movx	@r1,a
   08E2 08                 1941 	inc	r0
   08E3 E2                 1942 	movx	a,@r0
   08E4 09                 1943 	inc	r1
   08E5 F3                 1944 	movx	@r1,a
   08E6 08                 1945 	inc	r0
   08E7 E2                 1946 	movx	a,@r0
   08E8 09                 1947 	inc	r1
   08E9 F3                 1948 	movx	@r1,a
   08EA 08                 1949 	inc	r0
   08EB E2                 1950 	movx	a,@r0
   08EC 09                 1951 	inc	r1
   08ED F3                 1952 	movx	@r1,a
   08EE 8A 82              1953 	mov	dpl,r2
   08F0 8B 83              1954 	mov	dph,r3
   08F2 8E F0              1955 	mov	b,r6
   08F4 EF                 1956 	mov	a,r7
   08F5 12 1E 60           1957 	lcall	__mullong
   08F8 AC 82              1958 	mov	r4,dpl
   08FA AD 83              1959 	mov	r5,dph
   08FC AE F0              1960 	mov	r6,b
   08FE FF                 1961 	mov	r7,a
   08FF 78 DA              1962 	mov	r0,#__divslong_PARM_2
   0901 74 E8              1963 	mov	a,#0xE8
   0903 F2                 1964 	movx	@r0,a
   0904 08                 1965 	inc	r0
   0905 74 03              1966 	mov	a,#0x03
   0907 F2                 1967 	movx	@r0,a
   0908 08                 1968 	inc	r0
   0909 E4                 1969 	clr	a
   090A F2                 1970 	movx	@r0,a
   090B 08                 1971 	inc	r0
   090C F2                 1972 	movx	@r0,a
   090D 8C 82              1973 	mov	dpl,r4
   090F 8D 83              1974 	mov	dph,r5
   0911 8E F0              1975 	mov	b,r6
   0913 EF                 1976 	mov	a,r7
   0914 12 1C 0F           1977 	lcall	__divslong
   0917 AC 82              1978 	mov	r4,dpl
   0919 AD 83              1979 	mov	r5,dph
   091B AE F0              1980 	mov	r6,b
   091D FF                 1981 	mov	r7,a
   091E 78 DA              1982 	mov	r0,#__divslong_PARM_2
   0920 74 40              1983 	mov	a,#0x40
   0922 2C                 1984 	add	a,r4
   0923 F2                 1985 	movx	@r0,a
   0924 74 42              1986 	mov	a,#0x42
   0926 3D                 1987 	addc	a,r5
   0927 08                 1988 	inc	r0
   0928 F2                 1989 	movx	@r0,a
   0929 74 0F              1990 	mov	a,#0x0F
   092B 3E                 1991 	addc	a,r6
   092C 08                 1992 	inc	r0
   092D F2                 1993 	movx	@r0,a
   092E E4                 1994 	clr	a
   092F 3F                 1995 	addc	a,r7
   0930 08                 1996 	inc	r0
   0931 F2                 1997 	movx	@r0,a
   0932 85 0C 82           1998 	mov	dpl,_calculateTargetHeading_sloc0_1_0
   0935 85 0D 83           1999 	mov	dph,(_calculateTargetHeading_sloc0_1_0 + 1)
   0938 85 0E F0           2000 	mov	b,(_calculateTargetHeading_sloc0_1_0 + 2)
   093B E5 0F              2001 	mov	a,(_calculateTargetHeading_sloc0_1_0 + 3)
   093D 12 1C 0F           2002 	lcall	__divslong
   0940 AC 82              2003 	mov	r4,dpl
   0942 AD 83              2004 	mov	r5,dph
   0944 78 D0              2005 	mov	r0,#_calculateTargetHeading_angle_1_1
   0946 EC                 2006 	mov	a,r4
   0947 F2                 2007 	movx	@r0,a
   0948 08                 2008 	inc	r0
   0949 ED                 2009 	mov	a,r5
   094A F2                 2010 	movx	@r0,a
   094B D0 07              2011 	pop	ar7
   094D D0 06              2012 	pop	ar6
   094F D0 05              2013 	pop	ar5
   0951 D0 04              2014 	pop	ar4
   0953 02 0A 92           2015 	ljmp	00110$
   0956                    2016 00109$:
                    03D6   2017 	C$slave_wixel_track.c$233$1$1 ==.
                           2018 ;	apps/slave_wixel_track/slave_wixel_track.c:233: ratio = (absX * 1000L) / absY;
   0956 C0 04              2019 	push	ar4
   0958 C0 05              2020 	push	ar5
   095A C0 06              2021 	push	ar6
   095C C0 07              2022 	push	ar7
   095E 78 C8              2023 	mov	r0,#_calculateTargetHeading_absX_1_1
   0960 79 EB              2024 	mov	r1,#__mullong_PARM_2
   0962 E2                 2025 	movx	a,@r0
   0963 F3                 2026 	movx	@r1,a
   0964 08                 2027 	inc	r0
   0965 E2                 2028 	movx	a,@r0
   0966 09                 2029 	inc	r1
   0967 F3                 2030 	movx	@r1,a
   0968 08                 2031 	inc	r0
   0969 E2                 2032 	movx	a,@r0
   096A 09                 2033 	inc	r1
   096B F3                 2034 	movx	@r1,a
   096C 08                 2035 	inc	r0
   096D E2                 2036 	movx	a,@r0
   096E 09                 2037 	inc	r1
   096F F3                 2038 	movx	@r1,a
   0970 90 03 E8           2039 	mov	dptr,#0x03E8
   0973 E4                 2040 	clr	a
   0974 F5 F0              2041 	mov	b,a
   0976 C0 05              2042 	push	ar5
   0978 C0 04              2043 	push	ar4
   097A 12 1E 60           2044 	lcall	__mullong
   097D AA 82              2045 	mov	r2,dpl
   097F AB 83              2046 	mov	r3,dph
   0981 AE F0              2047 	mov	r6,b
   0983 FF                 2048 	mov	r7,a
   0984 D0 04              2049 	pop	ar4
   0986 D0 05              2050 	pop	ar5
   0988 78 CC              2051 	mov	r0,#_calculateTargetHeading_absY_1_1
   098A 79 DA              2052 	mov	r1,#__divslong_PARM_2
   098C E2                 2053 	movx	a,@r0
   098D F3                 2054 	movx	@r1,a
   098E 08                 2055 	inc	r0
   098F E2                 2056 	movx	a,@r0
   0990 09                 2057 	inc	r1
   0991 F3                 2058 	movx	@r1,a
   0992 08                 2059 	inc	r0
   0993 E2                 2060 	movx	a,@r0
   0994 09                 2061 	inc	r1
   0995 F3                 2062 	movx	@r1,a
   0996 08                 2063 	inc	r0
   0997 E2                 2064 	movx	a,@r0
   0998 09                 2065 	inc	r1
   0999 F3                 2066 	movx	@r1,a
   099A 8A 82              2067 	mov	dpl,r2
   099C 8B 83              2068 	mov	dph,r3
   099E 8E F0              2069 	mov	b,r6
   09A0 EF                 2070 	mov	a,r7
   09A1 C0 07              2071 	push	ar7
   09A3 C0 06              2072 	push	ar6
   09A5 C0 05              2073 	push	ar5
   09A7 C0 04              2074 	push	ar4
   09A9 12 1C 0F           2075 	lcall	__divslong
   09AC 78 D2              2076 	mov	r0,#_calculateTargetHeading_ratio_1_1
   09AE C0 E0              2077 	push	acc
   09B0 E5 82              2078 	mov	a,dpl
   09B2 F2                 2079 	movx	@r0,a
   09B3 08                 2080 	inc	r0
   09B4 E5 83              2081 	mov	a,dph
   09B6 F2                 2082 	movx	@r0,a
   09B7 08                 2083 	inc	r0
   09B8 E5 F0              2084 	mov	a,b
   09BA F2                 2085 	movx	@r0,a
   09BB D0 E0              2086 	pop	acc
   09BD 08                 2087 	inc	r0
   09BE F2                 2088 	movx	@r0,a
                    043F   2089 	C$slave_wixel_track.c$234$1$1 ==.
                           2090 ;	apps/slave_wixel_track/slave_wixel_track.c:234: angle = 90 - (int16)((57300L * ratio) / (1000000L + (280L * ratio * ratio) / 1000L));
   09BF 78 D2              2091 	mov	r0,#_calculateTargetHeading_ratio_1_1
   09C1 79 EB              2092 	mov	r1,#__mullong_PARM_2
   09C3 E2                 2093 	movx	a,@r0
   09C4 F3                 2094 	movx	@r1,a
   09C5 08                 2095 	inc	r0
   09C6 E2                 2096 	movx	a,@r0
   09C7 09                 2097 	inc	r1
   09C8 F3                 2098 	movx	@r1,a
   09C9 08                 2099 	inc	r0
   09CA E2                 2100 	movx	a,@r0
   09CB 09                 2101 	inc	r1
   09CC F3                 2102 	movx	@r1,a
   09CD 08                 2103 	inc	r0
   09CE E2                 2104 	movx	a,@r0
   09CF 09                 2105 	inc	r1
   09D0 F3                 2106 	movx	@r1,a
   09D1 90 DF D4           2107 	mov	dptr,#0xDFD4
   09D4 E4                 2108 	clr	a
   09D5 F5 F0              2109 	mov	b,a
   09D7 12 1E 60           2110 	lcall	__mullong
   09DA 85 82 0C           2111 	mov	_calculateTargetHeading_sloc0_1_0,dpl
   09DD 85 83 0D           2112 	mov	(_calculateTargetHeading_sloc0_1_0 + 1),dph
   09E0 85 F0 0E           2113 	mov	(_calculateTargetHeading_sloc0_1_0 + 2),b
   09E3 F5 0F              2114 	mov	(_calculateTargetHeading_sloc0_1_0 + 3),a
   09E5 D0 04              2115 	pop	ar4
   09E7 D0 05              2116 	pop	ar5
   09E9 D0 06              2117 	pop	ar6
   09EB D0 07              2118 	pop	ar7
   09ED 78 D2              2119 	mov	r0,#_calculateTargetHeading_ratio_1_1
   09EF 79 EB              2120 	mov	r1,#__mullong_PARM_2
   09F1 E2                 2121 	movx	a,@r0
   09F2 F3                 2122 	movx	@r1,a
   09F3 08                 2123 	inc	r0
   09F4 E2                 2124 	movx	a,@r0
   09F5 09                 2125 	inc	r1
   09F6 F3                 2126 	movx	@r1,a
   09F7 08                 2127 	inc	r0
   09F8 E2                 2128 	movx	a,@r0
   09F9 09                 2129 	inc	r1
   09FA F3                 2130 	movx	@r1,a
   09FB 08                 2131 	inc	r0
   09FC E2                 2132 	movx	a,@r0
   09FD 09                 2133 	inc	r1
   09FE F3                 2134 	movx	@r1,a
   09FF 90 01 18           2135 	mov	dptr,#0x0118
   0A02 E4                 2136 	clr	a
   0A03 F5 F0              2137 	mov	b,a
   0A05 C0 05              2138 	push	ar5
   0A07 C0 04              2139 	push	ar4
   0A09 12 1E 60           2140 	lcall	__mullong
   0A0C AA 82              2141 	mov	r2,dpl
   0A0E AB 83              2142 	mov	r3,dph
   0A10 AE F0              2143 	mov	r6,b
   0A12 FF                 2144 	mov	r7,a
   0A13 D0 04              2145 	pop	ar4
   0A15 D0 05              2146 	pop	ar5
   0A17 78 D2              2147 	mov	r0,#_calculateTargetHeading_ratio_1_1
   0A19 79 EB              2148 	mov	r1,#__mullong_PARM_2
   0A1B E2                 2149 	movx	a,@r0
   0A1C F3                 2150 	movx	@r1,a
   0A1D 08                 2151 	inc	r0
   0A1E E2                 2152 	movx	a,@r0
   0A1F 09                 2153 	inc	r1
   0A20 F3                 2154 	movx	@r1,a
   0A21 08                 2155 	inc	r0
   0A22 E2                 2156 	movx	a,@r0
   0A23 09                 2157 	inc	r1
   0A24 F3                 2158 	movx	@r1,a
   0A25 08                 2159 	inc	r0
   0A26 E2                 2160 	movx	a,@r0
   0A27 09                 2161 	inc	r1
   0A28 F3                 2162 	movx	@r1,a
   0A29 8A 82              2163 	mov	dpl,r2
   0A2B 8B 83              2164 	mov	dph,r3
   0A2D 8E F0              2165 	mov	b,r6
   0A2F EF                 2166 	mov	a,r7
   0A30 12 1E 60           2167 	lcall	__mullong
   0A33 AC 82              2168 	mov	r4,dpl
   0A35 AD 83              2169 	mov	r5,dph
   0A37 AE F0              2170 	mov	r6,b
   0A39 FF                 2171 	mov	r7,a
   0A3A 78 DA              2172 	mov	r0,#__divslong_PARM_2
   0A3C 74 E8              2173 	mov	a,#0xE8
   0A3E F2                 2174 	movx	@r0,a
   0A3F 08                 2175 	inc	r0
   0A40 74 03              2176 	mov	a,#0x03
   0A42 F2                 2177 	movx	@r0,a
   0A43 08                 2178 	inc	r0
   0A44 E4                 2179 	clr	a
   0A45 F2                 2180 	movx	@r0,a
   0A46 08                 2181 	inc	r0
   0A47 F2                 2182 	movx	@r0,a
   0A48 8C 82              2183 	mov	dpl,r4
   0A4A 8D 83              2184 	mov	dph,r5
   0A4C 8E F0              2185 	mov	b,r6
   0A4E EF                 2186 	mov	a,r7
   0A4F 12 1C 0F           2187 	lcall	__divslong
   0A52 AC 82              2188 	mov	r4,dpl
   0A54 AD 83              2189 	mov	r5,dph
   0A56 AE F0              2190 	mov	r6,b
   0A58 FF                 2191 	mov	r7,a
   0A59 78 DA              2192 	mov	r0,#__divslong_PARM_2
   0A5B 74 40              2193 	mov	a,#0x40
   0A5D 2C                 2194 	add	a,r4
   0A5E F2                 2195 	movx	@r0,a
   0A5F 74 42              2196 	mov	a,#0x42
   0A61 3D                 2197 	addc	a,r5
   0A62 08                 2198 	inc	r0
   0A63 F2                 2199 	movx	@r0,a
   0A64 74 0F              2200 	mov	a,#0x0F
   0A66 3E                 2201 	addc	a,r6
   0A67 08                 2202 	inc	r0
   0A68 F2                 2203 	movx	@r0,a
   0A69 E4                 2204 	clr	a
   0A6A 3F                 2205 	addc	a,r7
   0A6B 08                 2206 	inc	r0
   0A6C F2                 2207 	movx	@r0,a
   0A6D 85 0C 82           2208 	mov	dpl,_calculateTargetHeading_sloc0_1_0
   0A70 85 0D 83           2209 	mov	dph,(_calculateTargetHeading_sloc0_1_0 + 1)
   0A73 85 0E F0           2210 	mov	b,(_calculateTargetHeading_sloc0_1_0 + 2)
   0A76 E5 0F              2211 	mov	a,(_calculateTargetHeading_sloc0_1_0 + 3)
   0A78 12 1C 0F           2212 	lcall	__divslong
   0A7B AC 82              2213 	mov	r4,dpl
   0A7D AD 83              2214 	mov	r5,dph
   0A7F 78 D0              2215 	mov	r0,#_calculateTargetHeading_angle_1_1
   0A81 74 5A              2216 	mov	a,#0x5A
   0A83 C3                 2217 	clr	c
   0A84 9C                 2218 	subb	a,r4
   0A85 F2                 2219 	movx	@r0,a
   0A86 E4                 2220 	clr	a
   0A87 9D                 2221 	subb	a,r5
   0A88 08                 2222 	inc	r0
   0A89 F2                 2223 	movx	@r0,a
                    050A   2224 	C$slave_wixel_track.c$244$1$1 ==.
                           2225 ;	apps/slave_wixel_track/slave_wixel_track.c:244: return -angle;
   0A8A D0 07              2226 	pop	ar7
   0A8C D0 06              2227 	pop	ar6
   0A8E D0 05              2228 	pop	ar5
   0A90 D0 04              2229 	pop	ar4
                    0512   2230 	C$slave_wixel_track.c$234$1$1 ==.
                           2231 ;	apps/slave_wixel_track/slave_wixel_track.c:234: angle = 90 - (int16)((57300L * ratio) / (1000000L + (280L * ratio * ratio) / 1000L));
   0A92                    2232 00110$:
                    0512   2233 	C$slave_wixel_track.c$237$1$1 ==.
                           2234 ;	apps/slave_wixel_track/slave_wixel_track.c:237: if (dx >= 0 && dy >= 0)
   0A92 78 C7              2235 	mov	r0,#(_calculateTargetHeading_dx_1_1 + 3)
   0A94 E2                 2236 	movx	a,@r0
   0A95 33                 2237 	rlc	a
   0A96 E4                 2238 	clr	a
   0A97 33                 2239 	rlc	a
   0A98 FB                 2240 	mov	r3,a
   0A99 70 0F              2241 	jnz	00120$
   0A9B EF                 2242 	mov	a,r7
   0A9C 20 E7 0B           2243 	jb	acc.7,00120$
                    051F   2244 	C$slave_wixel_track.c$238$1$1 ==.
                           2245 ;	apps/slave_wixel_track/slave_wixel_track.c:238: return angle;
   0A9F 78 D0              2246 	mov	r0,#_calculateTargetHeading_angle_1_1
   0AA1 E2                 2247 	movx	a,@r0
   0AA2 F5 82              2248 	mov	dpl,a
   0AA4 08                 2249 	inc	r0
   0AA5 E2                 2250 	movx	a,@r0
   0AA6 F5 83              2251 	mov	dph,a
   0AA8 80 41              2252 	sjmp	00123$
   0AAA                    2253 00120$:
                    052A   2254 	C$slave_wixel_track.c$239$1$1 ==.
                           2255 ;	apps/slave_wixel_track/slave_wixel_track.c:239: else if (dx < 0 && dy >= 0)
   0AAA EB                 2256 	mov	a,r3
   0AAB 60 18              2257 	jz	00116$
   0AAD EF                 2258 	mov	a,r7
   0AAE 20 E7 14           2259 	jb	acc.7,00116$
                    0531   2260 	C$slave_wixel_track.c$240$1$1 ==.
                           2261 ;	apps/slave_wixel_track/slave_wixel_track.c:240: return 180 - angle;
   0AB1 78 D0              2262 	mov	r0,#_calculateTargetHeading_angle_1_1
   0AB3 D3                 2263 	setb	c
   0AB4 E2                 2264 	movx	a,@r0
   0AB5 94 B4              2265 	subb	a,#0xB4
   0AB7 F4                 2266 	cpl	a
   0AB8 B3                 2267 	cpl	c
   0AB9 F5 82              2268 	mov	dpl,a
   0ABB B3                 2269 	cpl	c
   0ABC 08                 2270 	inc	r0
   0ABD E2                 2271 	movx	a,@r0
   0ABE 94 00              2272 	subb	a,#0x00
   0AC0 F4                 2273 	cpl	a
   0AC1 F5 83              2274 	mov	dph,a
   0AC3 80 26              2275 	sjmp	00123$
   0AC5                    2276 00116$:
                    0545   2277 	C$slave_wixel_track.c$241$1$1 ==.
                           2278 ;	apps/slave_wixel_track/slave_wixel_track.c:241: else if (dx < 0 && dy < 0)
   0AC5 EB                 2279 	mov	a,r3
   0AC6 60 13              2280 	jz	00112$
   0AC8 EF                 2281 	mov	a,r7
   0AC9 30 E7 0F           2282 	jnb	acc.7,00112$
                    054C   2283 	C$slave_wixel_track.c$242$1$1 ==.
                           2284 ;	apps/slave_wixel_track/slave_wixel_track.c:242: return angle - 180;
   0ACC 78 D0              2285 	mov	r0,#_calculateTargetHeading_angle_1_1
   0ACE E2                 2286 	movx	a,@r0
   0ACF 24 4C              2287 	add	a,#0x4C
   0AD1 F5 82              2288 	mov	dpl,a
   0AD3 08                 2289 	inc	r0
   0AD4 E2                 2290 	movx	a,@r0
   0AD5 34 FF              2291 	addc	a,#0xFF
   0AD7 F5 83              2292 	mov	dph,a
   0AD9 80 10              2293 	sjmp	00123$
   0ADB                    2294 00112$:
                    055B   2295 	C$slave_wixel_track.c$244$1$1 ==.
                           2296 ;	apps/slave_wixel_track/slave_wixel_track.c:244: return -angle;
   0ADB 78 D0              2297 	mov	r0,#_calculateTargetHeading_angle_1_1
   0ADD E2                 2298 	movx	a,@r0
   0ADE D3                 2299 	setb	c
   0ADF F4                 2300 	cpl	a
   0AE0 34 00              2301 	addc	a,#0x00
   0AE2 F5 82              2302 	mov	dpl,a
   0AE4 08                 2303 	inc	r0
   0AE5 E2                 2304 	movx	a,@r0
   0AE6 F4                 2305 	cpl	a
   0AE7 34 00              2306 	addc	a,#0x00
   0AE9 F5 83              2307 	mov	dph,a
   0AEB                    2308 00123$:
                    056B   2309 	C$slave_wixel_track.c$245$1$1 ==.
                    056B   2310 	XG$calculateTargetHeading$0$0 ==.
   0AEB 22                 2311 	ret
                           2312 ;------------------------------------------------------------
                           2313 ;Allocation info for local variables in function 'calculateAndApplyOffset'
                           2314 ;------------------------------------------------------------
                           2315 ;sloc0                     Allocated with name '_calculateAndApplyOffset_sloc0_1_0'
                           2316 ;------------------------------------------------------------
                    056C   2317 	G$calculateAndApplyOffset$0$0 ==.
                    056C   2318 	C$slave_wixel_track.c$247$1$1 ==.
                           2319 ;	apps/slave_wixel_track/slave_wixel_track.c:247: void calculateAndApplyOffset()
                           2320 ;	-----------------------------------------
                           2321 ;	 function calculateAndApplyOffset
                           2322 ;	-----------------------------------------
   0AEC                    2323 _calculateAndApplyOffset:
                    056C   2324 	C$slave_wixel_track.c$250$1$1 ==.
                           2325 ;	apps/slave_wixel_track/slave_wixel_track.c:250: actualHeading = calculateTargetHeading(calData.xa, calData.ya, calData.xb, calData.yb);
   0AEC 78 99              2326 	mov	r0,#_calData
   0AEE E2                 2327 	movx	a,@r0
   0AEF FE                 2328 	mov	r6,a
   0AF0 08                 2329 	inc	r0
   0AF1 E2                 2330 	movx	a,@r0
   0AF2 FF                 2331 	mov	r7,a
   0AF3 78 9B              2332 	mov	r0,#(_calData + 0x0002)
   0AF5 E2                 2333 	movx	a,@r0
   0AF6 FC                 2334 	mov	r4,a
   0AF7 08                 2335 	inc	r0
   0AF8 E2                 2336 	movx	a,@r0
   0AF9 FD                 2337 	mov	r5,a
   0AFA 78 9F              2338 	mov	r0,#(_calData + 0x0006)
   0AFC E2                 2339 	movx	a,@r0
   0AFD F5 10              2340 	mov	_calculateAndApplyOffset_sloc0_1_0,a
   0AFF 08                 2341 	inc	r0
   0B00 E2                 2342 	movx	a,@r0
   0B01 F5 11              2343 	mov	(_calculateAndApplyOffset_sloc0_1_0 + 1),a
   0B03 78 A1              2344 	mov	r0,#(_calData + 0x0008)
   0B05 E2                 2345 	movx	a,@r0
   0B06 FA                 2346 	mov	r2,a
   0B07 08                 2347 	inc	r0
   0B08 E2                 2348 	movx	a,@r0
   0B09 FB                 2349 	mov	r3,a
   0B0A 78 BE              2350 	mov	r0,#_calculateTargetHeading_PARM_2
   0B0C EC                 2351 	mov	a,r4
   0B0D F2                 2352 	movx	@r0,a
   0B0E 08                 2353 	inc	r0
   0B0F ED                 2354 	mov	a,r5
   0B10 F2                 2355 	movx	@r0,a
   0B11 78 C0              2356 	mov	r0,#_calculateTargetHeading_PARM_3
   0B13 E5 10              2357 	mov	a,_calculateAndApplyOffset_sloc0_1_0
   0B15 F2                 2358 	movx	@r0,a
   0B16 08                 2359 	inc	r0
   0B17 E5 11              2360 	mov	a,(_calculateAndApplyOffset_sloc0_1_0 + 1)
   0B19 F2                 2361 	movx	@r0,a
   0B1A 78 C2              2362 	mov	r0,#_calculateTargetHeading_PARM_4
   0B1C EA                 2363 	mov	a,r2
   0B1D F2                 2364 	movx	@r0,a
   0B1E 08                 2365 	inc	r0
   0B1F EB                 2366 	mov	a,r3
   0B20 F2                 2367 	movx	@r0,a
   0B21 8E 82              2368 	mov	dpl,r6
   0B23 8F 83              2369 	mov	dph,r7
   0B25 12 06 6C           2370 	lcall	_calculateTargetHeading
   0B28 AE 82              2371 	mov	r6,dpl
   0B2A AF 83              2372 	mov	r7,dph
                    05AC   2373 	C$slave_wixel_track.c$251$1$1 ==.
                           2374 ;	apps/slave_wixel_track/slave_wixel_track.c:251: reportedHeading = calData.thetaa;
   0B2C 78 9D              2375 	mov	r0,#(_calData + 0x0004)
   0B2E E2                 2376 	movx	a,@r0
   0B2F FC                 2377 	mov	r4,a
   0B30 08                 2378 	inc	r0
   0B31 E2                 2379 	movx	a,@r0
   0B32 FD                 2380 	mov	r5,a
                    05B3   2381 	C$slave_wixel_track.c$252$1$1 ==.
                           2382 ;	apps/slave_wixel_track/slave_wixel_track.c:252: orientationOffset = actualHeading - reportedHeading;
   0B33 EE                 2383 	mov	a,r6
   0B34 C3                 2384 	clr	c
   0B35 9C                 2385 	subb	a,r4
   0B36 FE                 2386 	mov	r6,a
   0B37 EF                 2387 	mov	a,r7
   0B38 9D                 2388 	subb	a,r5
   0B39 FF                 2389 	mov	r7,a
   0B3A 78 AB              2390 	mov	r0,#_orientationOffset
   0B3C EE                 2391 	mov	a,r6
   0B3D F2                 2392 	movx	@r0,a
   0B3E 08                 2393 	inc	r0
   0B3F EF                 2394 	mov	a,r7
   0B40 F2                 2395 	movx	@r0,a
                    05C1   2396 	C$slave_wixel_track.c$254$1$1 ==.
                           2397 ;	apps/slave_wixel_track/slave_wixel_track.c:254: if (orientationOffset > 180) { orientationOffset -= 360; }
   0B41 C3                 2398 	clr	c
   0B42 74 B4              2399 	mov	a,#0xB4
   0B44 9E                 2400 	subb	a,r6
   0B45 E4                 2401 	clr	a
   0B46 64 80              2402 	xrl	a,#0x80
   0B48 8F F0              2403 	mov	b,r7
   0B4A 63 F0 80           2404 	xrl	b,#0x80
   0B4D 95 F0              2405 	subb	a,b
   0B4F 50 0B              2406 	jnc	00102$
   0B51 78 AB              2407 	mov	r0,#_orientationOffset
   0B53 EE                 2408 	mov	a,r6
   0B54 24 98              2409 	add	a,#0x98
   0B56 F2                 2410 	movx	@r0,a
   0B57 EF                 2411 	mov	a,r7
   0B58 34 FE              2412 	addc	a,#0xFE
   0B5A 08                 2413 	inc	r0
   0B5B F2                 2414 	movx	@r0,a
   0B5C                    2415 00102$:
                    05DC   2416 	C$slave_wixel_track.c$255$1$1 ==.
                           2417 ;	apps/slave_wixel_track/slave_wixel_track.c:255: if (orientationOffset < -180) { orientationOffset += 360; }
   0B5C 78 AB              2418 	mov	r0,#_orientationOffset
   0B5E C3                 2419 	clr	c
   0B5F E2                 2420 	movx	a,@r0
   0B60 94 4C              2421 	subb	a,#0x4C
   0B62 08                 2422 	inc	r0
   0B63 E2                 2423 	movx	a,@r0
   0B64 64 80              2424 	xrl	a,#0x80
   0B66 94 7F              2425 	subb	a,#0x7f
   0B68 50 0B              2426 	jnc	00105$
   0B6A 78 AB              2427 	mov	r0,#_orientationOffset
   0B6C E2                 2428 	movx	a,@r0
   0B6D 24 68              2429 	add	a,#0x68
   0B6F F2                 2430 	movx	@r0,a
   0B70 08                 2431 	inc	r0
   0B71 E2                 2432 	movx	a,@r0
   0B72 34 01              2433 	addc	a,#0x01
   0B74 F2                 2434 	movx	@r0,a
   0B75                    2435 00105$:
                    05F5   2436 	C$slave_wixel_track.c$256$2$1 ==.
                    05F5   2437 	XG$calculateAndApplyOffset$0$0 ==.
   0B75 22                 2438 	ret
                           2439 ;------------------------------------------------------------
                           2440 ;Allocation info for local variables in function 'filterPosition'
                           2441 ;------------------------------------------------------------
                           2442 ;sloc0                     Allocated with name '_filterPosition_sloc0_1_0'
                           2443 ;------------------------------------------------------------
                    05F6   2444 	G$filterPosition$0$0 ==.
                    05F6   2445 	C$slave_wixel_track.c$258$2$1 ==.
                           2446 ;	apps/slave_wixel_track/slave_wixel_track.c:258: void filterPosition()
                           2447 ;	-----------------------------------------
                           2448 ;	 function filterPosition
                           2449 ;	-----------------------------------------
   0B76                    2450 _filterPosition:
                    05F6   2451 	C$slave_wixel_track.c$264$1$1 ==.
                           2452 ;	apps/slave_wixel_track/slave_wixel_track.c:264: dx = posX - filteredX;
   0B76 78 0F              2453 	mov	r0,#_posX
   0B78 79 15              2454 	mov	r1,#_filteredX
   0B7A E3                 2455 	movx	a,@r1
   0B7B F5 F0              2456 	mov	b,a
   0B7D C3                 2457 	clr	c
   0B7E E2                 2458 	movx	a,@r0
   0B7F 95 F0              2459 	subb	a,b
   0B81 FE                 2460 	mov	r6,a
   0B82 09                 2461 	inc	r1
   0B83 E3                 2462 	movx	a,@r1
   0B84 F5 F0              2463 	mov	b,a
   0B86 08                 2464 	inc	r0
   0B87 E2                 2465 	movx	a,@r0
   0B88 95 F0              2466 	subb	a,b
   0B8A FF                 2467 	mov	r7,a
                    060B   2468 	C$slave_wixel_track.c$265$1$1 ==.
                           2469 ;	apps/slave_wixel_track/slave_wixel_track.c:265: dy = posY - filteredY;
   0B8B 78 11              2470 	mov	r0,#_posY
   0B8D 79 17              2471 	mov	r1,#_filteredY
   0B8F E3                 2472 	movx	a,@r1
   0B90 F5 F0              2473 	mov	b,a
   0B92 C3                 2474 	clr	c
   0B93 E2                 2475 	movx	a,@r0
   0B94 95 F0              2476 	subb	a,b
   0B96 FC                 2477 	mov	r4,a
   0B97 09                 2478 	inc	r1
   0B98 E3                 2479 	movx	a,@r1
   0B99 F5 F0              2480 	mov	b,a
   0B9B 08                 2481 	inc	r0
   0B9C E2                 2482 	movx	a,@r0
   0B9D 95 F0              2483 	subb	a,b
   0B9F FD                 2484 	mov	r5,a
                    0620   2485 	C$slave_wixel_track.c$266$1$1 ==.
                           2486 ;	apps/slave_wixel_track/slave_wixel_track.c:266: distSquared = (int32)dx * dx + (int32)dy * dy;
   0BA0 EF                 2487 	mov	a,r7
   0BA1 33                 2488 	rlc	a
   0BA2 95 E0              2489 	subb	a,acc
   0BA4 FB                 2490 	mov	r3,a
   0BA5 FA                 2491 	mov	r2,a
   0BA6 78 EB              2492 	mov	r0,#__mullong_PARM_2
   0BA8 EE                 2493 	mov	a,r6
   0BA9 F2                 2494 	movx	@r0,a
   0BAA 08                 2495 	inc	r0
   0BAB EF                 2496 	mov	a,r7
   0BAC F2                 2497 	movx	@r0,a
   0BAD 08                 2498 	inc	r0
   0BAE EB                 2499 	mov	a,r3
   0BAF F2                 2500 	movx	@r0,a
   0BB0 08                 2501 	inc	r0
   0BB1 EA                 2502 	mov	a,r2
   0BB2 F2                 2503 	movx	@r0,a
   0BB3 8E 82              2504 	mov	dpl,r6
   0BB5 8F 83              2505 	mov	dph,r7
   0BB7 8B F0              2506 	mov	b,r3
   0BB9 EA                 2507 	mov	a,r2
   0BBA C0 05              2508 	push	ar5
   0BBC C0 04              2509 	push	ar4
   0BBE 12 1E 60           2510 	lcall	__mullong
   0BC1 85 82 12           2511 	mov	_filterPosition_sloc0_1_0,dpl
   0BC4 85 83 13           2512 	mov	(_filterPosition_sloc0_1_0 + 1),dph
   0BC7 85 F0 14           2513 	mov	(_filterPosition_sloc0_1_0 + 2),b
   0BCA F5 15              2514 	mov	(_filterPosition_sloc0_1_0 + 3),a
   0BCC D0 04              2515 	pop	ar4
   0BCE D0 05              2516 	pop	ar5
   0BD0 ED                 2517 	mov	a,r5
   0BD1 33                 2518 	rlc	a
   0BD2 95 E0              2519 	subb	a,acc
   0BD4 FE                 2520 	mov	r6,a
   0BD5 FF                 2521 	mov	r7,a
   0BD6 78 EB              2522 	mov	r0,#__mullong_PARM_2
   0BD8 EC                 2523 	mov	a,r4
   0BD9 F2                 2524 	movx	@r0,a
   0BDA 08                 2525 	inc	r0
   0BDB ED                 2526 	mov	a,r5
   0BDC F2                 2527 	movx	@r0,a
   0BDD 08                 2528 	inc	r0
   0BDE EE                 2529 	mov	a,r6
   0BDF F2                 2530 	movx	@r0,a
   0BE0 08                 2531 	inc	r0
   0BE1 EF                 2532 	mov	a,r7
   0BE2 F2                 2533 	movx	@r0,a
   0BE3 8C 82              2534 	mov	dpl,r4
   0BE5 8D 83              2535 	mov	dph,r5
   0BE7 8E F0              2536 	mov	b,r6
   0BE9 EF                 2537 	mov	a,r7
   0BEA 12 1E 60           2538 	lcall	__mullong
   0BED AC 82              2539 	mov	r4,dpl
   0BEF AD 83              2540 	mov	r5,dph
   0BF1 AE F0              2541 	mov	r6,b
   0BF3 FF                 2542 	mov	r7,a
   0BF4 EC                 2543 	mov	a,r4
   0BF5 25 12              2544 	add	a,_filterPosition_sloc0_1_0
   0BF7 FC                 2545 	mov	r4,a
   0BF8 ED                 2546 	mov	a,r5
   0BF9 35 13              2547 	addc	a,(_filterPosition_sloc0_1_0 + 1)
   0BFB FD                 2548 	mov	r5,a
   0BFC EE                 2549 	mov	a,r6
   0BFD 35 14              2550 	addc	a,(_filterPosition_sloc0_1_0 + 2)
   0BFF FE                 2551 	mov	r6,a
   0C00 EF                 2552 	mov	a,r7
   0C01 35 15              2553 	addc	a,(_filterPosition_sloc0_1_0 + 3)
   0C03 FF                 2554 	mov	r7,a
                    0684   2555 	C$slave_wixel_track.c$268$1$1 ==.
                           2556 ;	apps/slave_wixel_track/slave_wixel_track.c:268: if (distSquared > (int32)POSITION_JUMP_THRESHOLD * POSITION_JUMP_THRESHOLD)
   0C04 C3                 2557 	clr	c
   0C05 74 90              2558 	mov	a,#0x90
   0C07 9C                 2559 	subb	a,r4
   0C08 74 D0              2560 	mov	a,#0xD0
   0C0A 9D                 2561 	subb	a,r5
   0C0B 74 03              2562 	mov	a,#0x03
   0C0D 9E                 2563 	subb	a,r6
   0C0E E4                 2564 	clr	a
   0C0F 64 80              2565 	xrl	a,#0x80
   0C11 8F F0              2566 	mov	b,r7
   0C13 63 F0 80           2567 	xrl	b,#0x80
   0C16 95 F0              2568 	subb	a,b
   0C18 E4                 2569 	clr	a
   0C19 33                 2570 	rlc	a
                    069A   2571 	C$slave_wixel_track.c$279$1$1 ==.
                           2572 ;	apps/slave_wixel_track/slave_wixel_track.c:279: filteredX = posX;
   0C1A 78 0F              2573 	mov	r0,#_posX
   0C1C E2                 2574 	movx	a,@r0
   0C1D FE                 2575 	mov	r6,a
   0C1E 08                 2576 	inc	r0
   0C1F E2                 2577 	movx	a,@r0
   0C20 FF                 2578 	mov	r7,a
   0C21 78 15              2579 	mov	r0,#_filteredX
   0C23 EE                 2580 	mov	a,r6
   0C24 F2                 2581 	movx	@r0,a
   0C25 08                 2582 	inc	r0
   0C26 EF                 2583 	mov	a,r7
   0C27 F2                 2584 	movx	@r0,a
                    06A8   2585 	C$slave_wixel_track.c$280$1$1 ==.
                           2586 ;	apps/slave_wixel_track/slave_wixel_track.c:280: filteredY = posY;
   0C28 78 11              2587 	mov	r0,#_posY
   0C2A E2                 2588 	movx	a,@r0
   0C2B FE                 2589 	mov	r6,a
   0C2C 08                 2590 	inc	r0
   0C2D E2                 2591 	movx	a,@r0
   0C2E FF                 2592 	mov	r7,a
   0C2F 78 17              2593 	mov	r0,#_filteredY
   0C31 EE                 2594 	mov	a,r6
   0C32 F2                 2595 	movx	@r0,a
   0C33 08                 2596 	inc	r0
   0C34 EF                 2597 	mov	a,r7
   0C35 F2                 2598 	movx	@r0,a
                    06B6   2599 	C$slave_wixel_track.c$281$1$1 ==.
                           2600 ;	apps/slave_wixel_track/slave_wixel_track.c:281: filteredTheta = posTheta;
   0C36 78 13              2601 	mov	r0,#_posTheta
   0C38 E2                 2602 	movx	a,@r0
   0C39 FE                 2603 	mov	r6,a
   0C3A 08                 2604 	inc	r0
   0C3B E2                 2605 	movx	a,@r0
   0C3C FF                 2606 	mov	r7,a
   0C3D 78 19              2607 	mov	r0,#_filteredTheta
   0C3F EE                 2608 	mov	a,r6
   0C40 F2                 2609 	movx	@r0,a
   0C41 08                 2610 	inc	r0
   0C42 EF                 2611 	mov	a,r7
   0C43 F2                 2612 	movx	@r0,a
                    06C4   2613 	C$slave_wixel_track.c$282$1$1 ==.
                    06C4   2614 	XG$filterPosition$0$0 ==.
   0C44 22                 2615 	ret
                           2616 ;------------------------------------------------------------
                           2617 ;Allocation info for local variables in function 'rotationController'
                           2618 ;------------------------------------------------------------
                    06C5   2619 	G$rotationController$0$0 ==.
                    06C5   2620 	C$slave_wixel_track.c$284$1$1 ==.
                           2621 ;	apps/slave_wixel_track/slave_wixel_track.c:284: void rotationController(int16 currentHeading, int16 targetHeading)
                           2622 ;	-----------------------------------------
                           2623 ;	 function rotationController
                           2624 ;	-----------------------------------------
   0C45                    2625 _rotationController:
   0C45 AE 82              2626 	mov	r6,dpl
   0C47 AF 83              2627 	mov	r7,dph
                    06C9   2628 	C$slave_wixel_track.c$291$1$1 ==.
                           2629 ;	apps/slave_wixel_track/slave_wixel_track.c:291: error = targetHeading - currentHeading;
   0C49 78 D6              2630 	mov	r0,#_rotationController_PARM_2
   0C4B E2                 2631 	movx	a,@r0
   0C4C C3                 2632 	clr	c
   0C4D 9E                 2633 	subb	a,r6
   0C4E FE                 2634 	mov	r6,a
   0C4F 08                 2635 	inc	r0
   0C50 E2                 2636 	movx	a,@r0
   0C51 9F                 2637 	subb	a,r7
   0C52 FF                 2638 	mov	r7,a
                    06D3   2639 	C$slave_wixel_track.c$293$1$1 ==.
                           2640 ;	apps/slave_wixel_track/slave_wixel_track.c:293: if (error > 180)
   0C53 C3                 2641 	clr	c
   0C54 74 B4              2642 	mov	a,#0xB4
   0C56 9E                 2643 	subb	a,r6
   0C57 E4                 2644 	clr	a
   0C58 64 80              2645 	xrl	a,#0x80
   0C5A 8F F0              2646 	mov	b,r7
   0C5C 63 F0 80           2647 	xrl	b,#0x80
   0C5F 95 F0              2648 	subb	a,b
   0C61 50 08              2649 	jnc	00102$
                    06E3   2650 	C$slave_wixel_track.c$294$1$1 ==.
                           2651 ;	apps/slave_wixel_track/slave_wixel_track.c:294: error -= 360;
   0C63 EE                 2652 	mov	a,r6
   0C64 24 98              2653 	add	a,#0x98
   0C66 FE                 2654 	mov	r6,a
   0C67 EF                 2655 	mov	a,r7
   0C68 34 FE              2656 	addc	a,#0xFE
   0C6A FF                 2657 	mov	r7,a
   0C6B                    2658 00102$:
                    06EB   2659 	C$slave_wixel_track.c$295$1$1 ==.
                           2660 ;	apps/slave_wixel_track/slave_wixel_track.c:295: if (error < -180)
   0C6B C3                 2661 	clr	c
   0C6C EE                 2662 	mov	a,r6
   0C6D 94 4C              2663 	subb	a,#0x4C
   0C6F EF                 2664 	mov	a,r7
   0C70 64 80              2665 	xrl	a,#0x80
   0C72 94 7F              2666 	subb	a,#0x7f
   0C74 50 08              2667 	jnc	00104$
                    06F6   2668 	C$slave_wixel_track.c$296$1$1 ==.
                           2669 ;	apps/slave_wixel_track/slave_wixel_track.c:296: error += 360;
   0C76 74 68              2670 	mov	a,#0x68
   0C78 2E                 2671 	add	a,r6
   0C79 FE                 2672 	mov	r6,a
   0C7A 74 01              2673 	mov	a,#0x01
   0C7C 3F                 2674 	addc	a,r7
   0C7D FF                 2675 	mov	r7,a
   0C7E                    2676 00104$:
                    06FE   2677 	C$slave_wixel_track.c$298$1$1 ==.
                           2678 ;	apps/slave_wixel_track/slave_wixel_track.c:298: abs_error = (error >= 0) ? error : -error;
   0C7E EF                 2679 	mov	a,r7
   0C7F 33                 2680 	rlc	a
   0C80 B3                 2681 	cpl	c
   0C81 E4                 2682 	clr	a
   0C82 33                 2683 	rlc	a
   0C83 FD                 2684 	mov	r5,a
   0C84 60 06              2685 	jz	00125$
   0C86 8E 04              2686 	mov	ar4,r6
   0C88 8F 05              2687 	mov	ar5,r7
   0C8A 80 07              2688 	sjmp	00126$
   0C8C                    2689 00125$:
   0C8C C3                 2690 	clr	c
   0C8D E4                 2691 	clr	a
   0C8E 9E                 2692 	subb	a,r6
   0C8F FC                 2693 	mov	r4,a
   0C90 E4                 2694 	clr	a
   0C91 9F                 2695 	subb	a,r7
   0C92 FD                 2696 	mov	r5,a
   0C93                    2697 00126$:
                    0713   2698 	C$slave_wixel_track.c$300$1$1 ==.
                           2699 ;	apps/slave_wixel_track/slave_wixel_track.c:300: if (abs_error < HEADING_THRESHOLD)
   0C93 C3                 2700 	clr	c
   0C94 EC                 2701 	mov	a,r4
   0C95 94 05              2702 	subb	a,#0x05
   0C97 ED                 2703 	mov	a,r5
   0C98 64 80              2704 	xrl	a,#0x80
   0C9A 94 80              2705 	subb	a,#0x80
   0C9C 50 0F              2706 	jnc	00106$
                    071E   2707 	C$slave_wixel_track.c$302$2$2 ==.
                           2708 ;	apps/slave_wixel_track/slave_wixel_track.c:302: pwm_left = 0;
   0C9E 78 27              2709 	mov	r0,#_pwm_left
   0CA0 E4                 2710 	clr	a
   0CA1 F2                 2711 	movx	@r0,a
   0CA2 08                 2712 	inc	r0
   0CA3 F2                 2713 	movx	@r0,a
                    0724   2714 	C$slave_wixel_track.c$303$2$2 ==.
                           2715 ;	apps/slave_wixel_track/slave_wixel_track.c:303: pwm_right = 0;
   0CA4 78 29              2716 	mov	r0,#_pwm_right
   0CA6 E4                 2717 	clr	a
   0CA7 F2                 2718 	movx	@r0,a
   0CA8 08                 2719 	inc	r0
   0CA9 F2                 2720 	movx	@r0,a
                    072A   2721 	C$slave_wixel_track.c$304$2$2 ==.
                           2722 ;	apps/slave_wixel_track/slave_wixel_track.c:304: return;
   0CAA 02 0D 90           2723 	ljmp	00123$
   0CAD                    2724 00106$:
                    072D   2725 	C$slave_wixel_track.c$307$1$1 ==.
                           2726 ;	apps/slave_wixel_track/slave_wixel_track.c:307: pwm_raw = ((int32)error * ROTATION_KP_NUM) / ROTATION_KP_DEN;
   0CAD 78 EB              2727 	mov	r0,#__mullong_PARM_2
   0CAF EE                 2728 	mov	a,r6
   0CB0 F2                 2729 	movx	@r0,a
   0CB1 08                 2730 	inc	r0
   0CB2 EF                 2731 	mov	a,r7
   0CB3 F2                 2732 	movx	@r0,a
   0CB4 EF                 2733 	mov	a,r7
   0CB5 33                 2734 	rlc	a
   0CB6 95 E0              2735 	subb	a,acc
   0CB8 08                 2736 	inc	r0
   0CB9 F2                 2737 	movx	@r0,a
   0CBA 08                 2738 	inc	r0
   0CBB F2                 2739 	movx	@r0,a
   0CBC 90 00 03           2740 	mov	dptr,#(0x03&0x00ff)
   0CBF E4                 2741 	clr	a
   0CC0 F5 F0              2742 	mov	b,a
   0CC2 12 1E 60           2743 	lcall	__mullong
   0CC5 AC 82              2744 	mov	r4,dpl
   0CC7 AD 83              2745 	mov	r5,dph
   0CC9 AE F0              2746 	mov	r6,b
   0CCB FF                 2747 	mov	r7,a
   0CCC 78 DA              2748 	mov	r0,#__divslong_PARM_2
   0CCE 74 02              2749 	mov	a,#0x02
   0CD0 F2                 2750 	movx	@r0,a
   0CD1 08                 2751 	inc	r0
   0CD2 E4                 2752 	clr	a
   0CD3 F2                 2753 	movx	@r0,a
   0CD4 08                 2754 	inc	r0
   0CD5 F2                 2755 	movx	@r0,a
   0CD6 08                 2756 	inc	r0
   0CD7 F2                 2757 	movx	@r0,a
   0CD8 8C 82              2758 	mov	dpl,r4
   0CDA 8D 83              2759 	mov	dph,r5
   0CDC 8E F0              2760 	mov	b,r6
   0CDE EF                 2761 	mov	a,r7
   0CDF 12 1C 0F           2762 	lcall	__divslong
   0CE2 AC 82              2763 	mov	r4,dpl
   0CE4 AD 83              2764 	mov	r5,dph
   0CE6 AE F0              2765 	mov	r6,b
   0CE8 FF                 2766 	mov	r7,a
                    0769   2767 	C$slave_wixel_track.c$309$1$1 ==.
                           2768 ;	apps/slave_wixel_track/slave_wixel_track.c:309: if (pwm_raw > MAX_ROTATION_PWM)
   0CE9 C3                 2769 	clr	c
   0CEA 74 64              2770 	mov	a,#0x64
   0CEC 9C                 2771 	subb	a,r4
   0CED E4                 2772 	clr	a
   0CEE 9D                 2773 	subb	a,r5
   0CEF E4                 2774 	clr	a
   0CF0 9E                 2775 	subb	a,r6
   0CF1 E4                 2776 	clr	a
   0CF2 64 80              2777 	xrl	a,#0x80
   0CF4 8F F0              2778 	mov	b,r7
   0CF6 63 F0 80           2779 	xrl	b,#0x80
   0CF9 95 F0              2780 	subb	a,b
   0CFB 50 06              2781 	jnc	00111$
                    077D   2782 	C$slave_wixel_track.c$310$1$1 ==.
                           2783 ;	apps/slave_wixel_track/slave_wixel_track.c:310: pwm = MAX_ROTATION_PWM;
   0CFD 7A 64              2784 	mov	r2,#0x64
   0CFF 7B 00              2785 	mov	r3,#0x00
   0D01 80 1B              2786 	sjmp	00112$
   0D03                    2787 00111$:
                    0783   2788 	C$slave_wixel_track.c$311$1$1 ==.
                           2789 ;	apps/slave_wixel_track/slave_wixel_track.c:311: else if (pwm_raw < -MAX_ROTATION_PWM)
   0D03 C3                 2790 	clr	c
   0D04 EC                 2791 	mov	a,r4
   0D05 94 9C              2792 	subb	a,#0x9C
   0D07 ED                 2793 	mov	a,r5
   0D08 94 FF              2794 	subb	a,#0xFF
   0D0A EE                 2795 	mov	a,r6
   0D0B 94 FF              2796 	subb	a,#0xFF
   0D0D EF                 2797 	mov	a,r7
   0D0E 64 80              2798 	xrl	a,#0x80
   0D10 94 7F              2799 	subb	a,#0x7f
   0D12 50 06              2800 	jnc	00108$
                    0794   2801 	C$slave_wixel_track.c$312$1$1 ==.
                           2802 ;	apps/slave_wixel_track/slave_wixel_track.c:312: pwm = -MAX_ROTATION_PWM;
   0D14 7A 9C              2803 	mov	r2,#0x9C
   0D16 7B FF              2804 	mov	r3,#0xFF
   0D18 80 04              2805 	sjmp	00112$
   0D1A                    2806 00108$:
                    079A   2807 	C$slave_wixel_track.c$314$1$1 ==.
                           2808 ;	apps/slave_wixel_track/slave_wixel_track.c:314: pwm = (int16)pwm_raw;
   0D1A 8C 02              2809 	mov	ar2,r4
   0D1C 8D 03              2810 	mov	ar3,r5
   0D1E                    2811 00112$:
                    079E   2812 	C$slave_wixel_track.c$316$1$1 ==.
                           2813 ;	apps/slave_wixel_track/slave_wixel_track.c:316: if (pwm > 0 && pwm < MIN_ROTATION_PWM)
   0D1E C3                 2814 	clr	c
   0D1F E4                 2815 	clr	a
   0D20 9A                 2816 	subb	a,r2
   0D21 E4                 2817 	clr	a
   0D22 64 80              2818 	xrl	a,#0x80
   0D24 8B F0              2819 	mov	b,r3
   0D26 63 F0 80           2820 	xrl	b,#0x80
   0D29 95 F0              2821 	subb	a,b
   0D2B 50 11              2822 	jnc	00117$
   0D2D C3                 2823 	clr	c
   0D2E EA                 2824 	mov	a,r2
   0D2F 94 32              2825 	subb	a,#0x32
   0D31 EB                 2826 	mov	a,r3
   0D32 64 80              2827 	xrl	a,#0x80
   0D34 94 80              2828 	subb	a,#0x80
   0D36 50 06              2829 	jnc	00117$
                    07B8   2830 	C$slave_wixel_track.c$317$1$1 ==.
                           2831 ;	apps/slave_wixel_track/slave_wixel_track.c:317: pwm = MIN_ROTATION_PWM;
   0D38 7A 32              2832 	mov	r2,#0x32
   0D3A 7B 00              2833 	mov	r3,#0x00
   0D3C 80 17              2834 	sjmp	00118$
   0D3E                    2835 00117$:
                    07BE   2836 	C$slave_wixel_track.c$318$1$1 ==.
                           2837 ;	apps/slave_wixel_track/slave_wixel_track.c:318: else if (pwm < 0 && pwm > -MIN_ROTATION_PWM)
   0D3E EB                 2838 	mov	a,r3
   0D3F 30 E7 13           2839 	jnb	acc.7,00118$
   0D42 C3                 2840 	clr	c
   0D43 74 CE              2841 	mov	a,#0xCE
   0D45 9A                 2842 	subb	a,r2
   0D46 74 7F              2843 	mov	a,#(0xFF ^ 0x80)
   0D48 8B F0              2844 	mov	b,r3
   0D4A 63 F0 80           2845 	xrl	b,#0x80
   0D4D 95 F0              2846 	subb	a,b
   0D4F 50 04              2847 	jnc	00118$
                    07D1   2848 	C$slave_wixel_track.c$319$1$1 ==.
                           2849 ;	apps/slave_wixel_track/slave_wixel_track.c:319: pwm = -MIN_ROTATION_PWM;
   0D51 7A CE              2850 	mov	r2,#0xCE
   0D53 7B FF              2851 	mov	r3,#0xFF
   0D55                    2852 00118$:
                    07D5   2853 	C$slave_wixel_track.c$321$1$1 ==.
                           2854 ;	apps/slave_wixel_track/slave_wixel_track.c:321: if (pwm > 0)
   0D55 C3                 2855 	clr	c
   0D56 E4                 2856 	clr	a
   0D57 9A                 2857 	subb	a,r2
   0D58 E4                 2858 	clr	a
   0D59 64 80              2859 	xrl	a,#0x80
   0D5B 8B F0              2860 	mov	b,r3
   0D5D 63 F0 80           2861 	xrl	b,#0x80
   0D60 95 F0              2862 	subb	a,b
   0D62 50 17              2863 	jnc	00121$
                    07E4   2864 	C$slave_wixel_track.c$323$2$3 ==.
                           2865 ;	apps/slave_wixel_track/slave_wixel_track.c:323: pwm_left = -pwm;
   0D64 C3                 2866 	clr	c
   0D65 E4                 2867 	clr	a
   0D66 9A                 2868 	subb	a,r2
   0D67 FE                 2869 	mov	r6,a
   0D68 E4                 2870 	clr	a
   0D69 9B                 2871 	subb	a,r3
   0D6A FF                 2872 	mov	r7,a
   0D6B 78 27              2873 	mov	r0,#_pwm_left
   0D6D EE                 2874 	mov	a,r6
   0D6E F2                 2875 	movx	@r0,a
   0D6F 08                 2876 	inc	r0
   0D70 EF                 2877 	mov	a,r7
   0D71 F2                 2878 	movx	@r0,a
                    07F2   2879 	C$slave_wixel_track.c$324$2$3 ==.
                           2880 ;	apps/slave_wixel_track/slave_wixel_track.c:324: pwm_right = pwm;
   0D72 78 29              2881 	mov	r0,#_pwm_right
   0D74 EA                 2882 	mov	a,r2
   0D75 F2                 2883 	movx	@r0,a
   0D76 08                 2884 	inc	r0
   0D77 EB                 2885 	mov	a,r3
   0D78 F2                 2886 	movx	@r0,a
   0D79 80 15              2887 	sjmp	00123$
   0D7B                    2888 00121$:
                    07FB   2889 	C$slave_wixel_track.c$328$2$4 ==.
                           2890 ;	apps/slave_wixel_track/slave_wixel_track.c:328: pwm_left = -pwm;
   0D7B C3                 2891 	clr	c
   0D7C E4                 2892 	clr	a
   0D7D 9A                 2893 	subb	a,r2
   0D7E FE                 2894 	mov	r6,a
   0D7F E4                 2895 	clr	a
   0D80 9B                 2896 	subb	a,r3
   0D81 FF                 2897 	mov	r7,a
   0D82 78 27              2898 	mov	r0,#_pwm_left
   0D84 EE                 2899 	mov	a,r6
   0D85 F2                 2900 	movx	@r0,a
   0D86 08                 2901 	inc	r0
   0D87 EF                 2902 	mov	a,r7
   0D88 F2                 2903 	movx	@r0,a
                    0809   2904 	C$slave_wixel_track.c$329$2$4 ==.
                           2905 ;	apps/slave_wixel_track/slave_wixel_track.c:329: pwm_right = pwm;
   0D89 78 29              2906 	mov	r0,#_pwm_right
   0D8B EA                 2907 	mov	a,r2
   0D8C F2                 2908 	movx	@r0,a
   0D8D 08                 2909 	inc	r0
   0D8E EB                 2910 	mov	a,r3
   0D8F F2                 2911 	movx	@r0,a
   0D90                    2912 00123$:
                    0810   2913 	C$slave_wixel_track.c$331$1$1 ==.
                    0810   2914 	XG$rotationController$0$0 ==.
   0D90 22                 2915 	ret
                           2916 ;------------------------------------------------------------
                           2917 ;Allocation info for local variables in function 'timer3Init'
                           2918 ;------------------------------------------------------------
                    0811   2919 	G$timer3Init$0$0 ==.
                    0811   2920 	C$slave_wixel_track.c$335$1$1 ==.
                           2921 ;	apps/slave_wixel_track/slave_wixel_track.c:335: void timer3Init()
                           2922 ;	-----------------------------------------
                           2923 ;	 function timer3Init
                           2924 ;	-----------------------------------------
   0D91                    2925 _timer3Init:
                    0811   2926 	C$slave_wixel_track.c$337$1$1 ==.
                           2927 ;	apps/slave_wixel_track/slave_wixel_track.c:337: T3CTL = 0b01110000;
   0D91 75 CB 70           2928 	mov	_T3CTL,#0x70
                    0814   2929 	C$slave_wixel_track.c$338$1$1 ==.
                           2930 ;	apps/slave_wixel_track/slave_wixel_track.c:338: T3CC0 = T3CC1 = 0;
   0D94 75 CF 00           2931 	mov	_T3CC1,#0x00
   0D97 75 CD 00           2932 	mov	_T3CC0,#0x00
                    081A   2933 	C$slave_wixel_track.c$339$1$1 ==.
                           2934 ;	apps/slave_wixel_track/slave_wixel_track.c:339: T3CCTL0 = T3CCTL1 = 0b00100100;
   0D9A 75 CE 24           2935 	mov	_T3CCTL1,#0x24
   0D9D 75 CC 24           2936 	mov	_T3CCTL0,#0x24
                    0820   2937 	C$slave_wixel_track.c$340$1$1 ==.
                           2938 ;	apps/slave_wixel_track/slave_wixel_track.c:340: PERCFG &= ~(1<<5);
   0DA0 AF F1              2939 	mov	r7,_PERCFG
   0DA2 53 07 DF           2940 	anl	ar7,#0xDF
   0DA5 8F F1              2941 	mov	_PERCFG,r7
                    0827   2942 	C$slave_wixel_track.c$341$1$1 ==.
                           2943 ;	apps/slave_wixel_track/slave_wixel_track.c:341: P1SEL |= (1<<R_PWM_PIN) | (1<<L_PWM_PIN);
   0DA7 43 F4 18           2944 	orl	_P1SEL,#0x18
                    082A   2945 	C$slave_wixel_track.c$342$1$1 ==.
                    082A   2946 	XG$timer3Init$0$0 ==.
   0DAA 22                 2947 	ret
                           2948 ;------------------------------------------------------------
                           2949 ;Allocation info for local variables in function 'setMotorsPWM'
                           2950 ;------------------------------------------------------------
                    082B   2951 	G$setMotorsPWM$0$0 ==.
                    082B   2952 	C$slave_wixel_track.c$344$1$1 ==.
                           2953 ;	apps/slave_wixel_track/slave_wixel_track.c:344: void setMotorsPWM()
                           2954 ;	-----------------------------------------
                           2955 ;	 function setMotorsPWM
                           2956 ;	-----------------------------------------
   0DAB                    2957 _setMotorsPWM:
                    082B   2958 	C$slave_wixel_track.c$346$1$1 ==.
                           2959 ;	apps/slave_wixel_track/slave_wixel_track.c:346: if (pwm_left >= 0)
   0DAB 78 28              2960 	mov	r0,#(_pwm_left + 1)
   0DAD E2                 2961 	movx	a,@r0
   0DAE 20 E7 09           2962 	jb	acc.7,00102$
                    0831   2963 	C$slave_wixel_track.c$348$2$2 ==.
                           2964 ;	apps/slave_wixel_track/slave_wixel_track.c:348: T3CC1 = pwm_left;
   0DB1 78 27              2965 	mov	r0,#_pwm_left
   0DB3 E2                 2966 	movx	a,@r0
   0DB4 F5 CF              2967 	mov	_T3CC1,a
                    0836   2968 	C$slave_wixel_track.c$349$2$2 ==.
                           2969 ;	apps/slave_wixel_track/slave_wixel_track.c:349: P1_6 = 0;
   0DB6 C2 96              2970 	clr	_P1_6
   0DB8 80 0C              2971 	sjmp	00103$
   0DBA                    2972 00102$:
                    083A   2973 	C$slave_wixel_track.c$353$2$3 ==.
                           2974 ;	apps/slave_wixel_track/slave_wixel_track.c:353: T3CC1 = -pwm_left;
   0DBA 78 27              2975 	mov	r0,#_pwm_left
   0DBC E2                 2976 	movx	a,@r0
   0DBD FF                 2977 	mov	r7,a
   0DBE C3                 2978 	clr	c
   0DBF E4                 2979 	clr	a
   0DC0 9F                 2980 	subb	a,r7
   0DC1 FF                 2981 	mov	r7,a
   0DC2 8F CF              2982 	mov	_T3CC1,r7
                    0844   2983 	C$slave_wixel_track.c$354$2$3 ==.
                           2984 ;	apps/slave_wixel_track/slave_wixel_track.c:354: P1_6 = 1;
   0DC4 D2 96              2985 	setb	_P1_6
   0DC6                    2986 00103$:
                    0846   2987 	C$slave_wixel_track.c$357$1$1 ==.
                           2988 ;	apps/slave_wixel_track/slave_wixel_track.c:357: if (pwm_right >= 0)
   0DC6 78 2A              2989 	mov	r0,#(_pwm_right + 1)
   0DC8 E2                 2990 	movx	a,@r0
   0DC9 20 E7 09           2991 	jb	acc.7,00105$
                    084C   2992 	C$slave_wixel_track.c$359$2$4 ==.
                           2993 ;	apps/slave_wixel_track/slave_wixel_track.c:359: T3CC0 = pwm_right;
   0DCC 78 29              2994 	mov	r0,#_pwm_right
   0DCE E2                 2995 	movx	a,@r0
   0DCF F5 CD              2996 	mov	_T3CC0,a
                    0851   2997 	C$slave_wixel_track.c$360$2$4 ==.
                           2998 ;	apps/slave_wixel_track/slave_wixel_track.c:360: P1_5 = 0;
   0DD1 C2 95              2999 	clr	_P1_5
   0DD3 80 0C              3000 	sjmp	00107$
   0DD5                    3001 00105$:
                    0855   3002 	C$slave_wixel_track.c$364$2$5 ==.
                           3003 ;	apps/slave_wixel_track/slave_wixel_track.c:364: T3CC0 = -pwm_right;
   0DD5 78 29              3004 	mov	r0,#_pwm_right
   0DD7 E2                 3005 	movx	a,@r0
   0DD8 FF                 3006 	mov	r7,a
   0DD9 C3                 3007 	clr	c
   0DDA E4                 3008 	clr	a
   0DDB 9F                 3009 	subb	a,r7
   0DDC FF                 3010 	mov	r7,a
   0DDD 8F CD              3011 	mov	_T3CC0,r7
                    085F   3012 	C$slave_wixel_track.c$365$2$5 ==.
                           3013 ;	apps/slave_wixel_track/slave_wixel_track.c:365: P1_5 = 1;
   0DDF D2 95              3014 	setb	_P1_5
   0DE1                    3015 00107$:
                    0861   3016 	C$slave_wixel_track.c$367$1$1 ==.
                    0861   3017 	XG$setMotorsPWM$0$0 ==.
   0DE1 22                 3018 	ret
                           3019 ;------------------------------------------------------------
                           3020 ;Allocation info for local variables in function 'stopMotors'
                           3021 ;------------------------------------------------------------
                    0862   3022 	G$stopMotors$0$0 ==.
                    0862   3023 	C$slave_wixel_track.c$369$1$1 ==.
                           3024 ;	apps/slave_wixel_track/slave_wixel_track.c:369: void stopMotors()
                           3025 ;	-----------------------------------------
                           3026 ;	 function stopMotors
                           3027 ;	-----------------------------------------
   0DE2                    3028 _stopMotors:
                    0862   3029 	C$slave_wixel_track.c$371$1$1 ==.
                           3030 ;	apps/slave_wixel_track/slave_wixel_track.c:371: T3CC0 = 0;
   0DE2 75 CD 00           3031 	mov	_T3CC0,#0x00
                    0865   3032 	C$slave_wixel_track.c$372$1$1 ==.
                           3033 ;	apps/slave_wixel_track/slave_wixel_track.c:372: T3CC1 = 0;
   0DE5 75 CF 00           3034 	mov	_T3CC1,#0x00
                    0868   3035 	C$slave_wixel_track.c$373$1$1 ==.
                           3036 ;	apps/slave_wixel_track/slave_wixel_track.c:373: P1_5 = 0;
   0DE8 C2 95              3037 	clr	_P1_5
                    086A   3038 	C$slave_wixel_track.c$374$1$1 ==.
                           3039 ;	apps/slave_wixel_track/slave_wixel_track.c:374: P1_6 = 0;
   0DEA C2 96              3040 	clr	_P1_6
                    086C   3041 	C$slave_wixel_track.c$375$1$1 ==.
                    086C   3042 	XG$stopMotors$0$0 ==.
   0DEC 22                 3043 	ret
                           3044 ;------------------------------------------------------------
                           3045 ;Allocation info for local variables in function 'radioInit'
                           3046 ;------------------------------------------------------------
                    086D   3047 	G$radioInit$0$0 ==.
                    086D   3048 	C$slave_wixel_track.c$379$1$1 ==.
                           3049 ;	apps/slave_wixel_track/slave_wixel_track.c:379: void radioInit()
                           3050 ;	-----------------------------------------
                           3051 ;	 function radioInit
                           3052 ;	-----------------------------------------
   0DED                    3053 _radioInit:
                    086D   3054 	C$slave_wixel_track.c$381$1$1 ==.
                           3055 ;	apps/slave_wixel_track/slave_wixel_track.c:381: radioRegistersInit();
   0DED 12 20 F3           3056 	lcall	_radioRegistersInit
                    0870   3057 	C$slave_wixel_track.c$382$1$1 ==.
                           3058 ;	apps/slave_wixel_track/slave_wixel_track.c:382: CHANNR = 128;
   0DF0 90 DF 06           3059 	mov	dptr,#_CHANNR
   0DF3 74 80              3060 	mov	a,#0x80
   0DF5 F0                 3061 	movx	@dptr,a
                    0876   3062 	C$slave_wixel_track.c$383$1$1 ==.
                           3063 ;	apps/slave_wixel_track/slave_wixel_track.c:383: PKTLEN = RADIO_PACKET_SIZE;
   0DF6 90 DF 02           3064 	mov	dptr,#_PKTLEN
   0DF9 74 40              3065 	mov	a,#0x40
   0DFB F0                 3066 	movx	@dptr,a
                    087C   3067 	C$slave_wixel_track.c$384$1$1 ==.
                           3068 ;	apps/slave_wixel_track/slave_wixel_track.c:384: MCSM0 = 0x14;
   0DFC 90 DF 14           3069 	mov	dptr,#_MCSM0
   0DFF 74 14              3070 	mov	a,#0x14
   0E01 F0                 3071 	movx	@dptr,a
                    0882   3072 	C$slave_wixel_track.c$385$1$1 ==.
                           3073 ;	apps/slave_wixel_track/slave_wixel_track.c:385: MCSM1 = 0x00;
   0E02 90 DF 13           3074 	mov	dptr,#_MCSM1
   0E05 E4                 3075 	clr	a
   0E06 F0                 3076 	movx	@dptr,a
                    0887   3077 	C$slave_wixel_track.c$386$1$1 ==.
                           3078 ;	apps/slave_wixel_track/slave_wixel_track.c:386: dmaConfig.radio.DC6 = 19;
   0E07 90 F1 46           3079 	mov	dptr,#(_dmaConfig + 0x0006)
   0E0A 74 13              3080 	mov	a,#0x13
   0E0C F0                 3081 	movx	@dptr,a
                    088D   3082 	C$slave_wixel_track.c$387$1$1 ==.
                           3083 ;	apps/slave_wixel_track/slave_wixel_track.c:387: dmaConfig.radio.SRCADDRH = XDATA_SFR_ADDRESS(RFD) >> 8;
   0E0D 7E D9              3084 	mov	r6,#_RFD
   0E0F 7F 00              3085 	mov	r7,#0x00
   0E11 74 DF              3086 	mov	a,#0xDF
   0E13 2F                 3087 	add	a,r7
   0E14 FE                 3088 	mov	r6,a
   0E15 90 F1 40           3089 	mov	dptr,#_dmaConfig
   0E18 EE                 3090 	mov	a,r6
   0E19 F0                 3091 	movx	@dptr,a
                    089A   3092 	C$slave_wixel_track.c$388$1$1 ==.
                           3093 ;	apps/slave_wixel_track/slave_wixel_track.c:388: dmaConfig.radio.SRCADDRL = XDATA_SFR_ADDRESS(RFD);
   0E1A 7E D9              3094 	mov	r6,#_RFD
   0E1C 90 F1 41           3095 	mov	dptr,#(_dmaConfig + 0x0001)
   0E1F EE                 3096 	mov	a,r6
   0E20 F0                 3097 	movx	@dptr,a
                    08A1   3098 	C$slave_wixel_track.c$389$1$1 ==.
                           3099 ;	apps/slave_wixel_track/slave_wixel_track.c:389: dmaConfig.radio.DESTADDRH = (unsigned int)rxPacket >> 8;
   0E21 7E FD              3100 	mov	r6,#_rxPacket
   0E23 7F F0              3101 	mov	r7,#(_rxPacket >> 8)
   0E25 8F 06              3102 	mov	ar6,r7
   0E27 90 F1 42           3103 	mov	dptr,#(_dmaConfig + 0x0002)
   0E2A EE                 3104 	mov	a,r6
   0E2B F0                 3105 	movx	@dptr,a
                    08AC   3106 	C$slave_wixel_track.c$390$1$1 ==.
                           3107 ;	apps/slave_wixel_track/slave_wixel_track.c:390: dmaConfig.radio.DESTADDRL = (unsigned int)rxPacket;
   0E2C 7E FD              3108 	mov	r6,#_rxPacket
   0E2E 7F F0              3109 	mov	r7,#(_rxPacket >> 8)
   0E30 90 F1 43           3110 	mov	dptr,#(_dmaConfig + 0x0003)
   0E33 EE                 3111 	mov	a,r6
   0E34 F0                 3112 	movx	@dptr,a
                    08B5   3113 	C$slave_wixel_track.c$391$1$1 ==.
                           3114 ;	apps/slave_wixel_track/slave_wixel_track.c:391: dmaConfig.radio.LENL = 1 + RADIO_PACKET_SIZE + 2;
   0E35 90 F1 45           3115 	mov	dptr,#(_dmaConfig + 0x0005)
   0E38 74 43              3116 	mov	a,#0x43
   0E3A F0                 3117 	movx	@dptr,a
                    08BB   3118 	C$slave_wixel_track.c$392$1$1 ==.
                           3119 ;	apps/slave_wixel_track/slave_wixel_track.c:392: dmaConfig.radio.VLEN_LENH = 0b10000000;
   0E3B 90 F1 44           3120 	mov	dptr,#(_dmaConfig + 0x0004)
   0E3E 74 80              3121 	mov	a,#0x80
   0E40 F0                 3122 	movx	@dptr,a
                    08C1   3123 	C$slave_wixel_track.c$393$1$1 ==.
                           3124 ;	apps/slave_wixel_track/slave_wixel_track.c:393: dmaConfig.radio.DC7 = 0x10;
   0E41 90 F1 47           3125 	mov	dptr,#(_dmaConfig + 0x0007)
   0E44 74 10              3126 	mov	a,#0x10
   0E46 F0                 3127 	movx	@dptr,a
                    08C7   3128 	C$slave_wixel_track.c$394$1$1 ==.
                           3129 ;	apps/slave_wixel_track/slave_wixel_track.c:394: DMAARM |= (1<<DMA_CHANNEL_RADIO);
   0E47 43 D6 02           3130 	orl	_DMAARM,#0x02
                    08CA   3131 	C$slave_wixel_track.c$395$1$1 ==.
                           3132 ;	apps/slave_wixel_track/slave_wixel_track.c:395: RFST = 2;
   0E4A 75 E1 02           3133 	mov	_RFST,#0x02
                    08CD   3134 	C$slave_wixel_track.c$396$1$1 ==.
                    08CD   3135 	XG$radioInit$0$0 ==.
   0E4D 22                 3136 	ret
                           3137 ;------------------------------------------------------------
                           3138 ;Allocation info for local variables in function 'gpioInit'
                           3139 ;------------------------------------------------------------
                    08CE   3140 	G$gpioInit$0$0 ==.
                    08CE   3141 	C$slave_wixel_track.c$398$1$1 ==.
                           3142 ;	apps/slave_wixel_track/slave_wixel_track.c:398: void gpioInit()
                           3143 ;	-----------------------------------------
                           3144 ;	 function gpioInit
                           3145 ;	-----------------------------------------
   0E4E                    3146 _gpioInit:
                    08CE   3147 	C$slave_wixel_track.c$400$1$1 ==.
                           3148 ;	apps/slave_wixel_track/slave_wixel_track.c:400: P1SEL = 0x00;
   0E4E 75 F4 00           3149 	mov	_P1SEL,#0x00
                    08D1   3150 	C$slave_wixel_track.c$401$1$1 ==.
                           3151 ;	apps/slave_wixel_track/slave_wixel_track.c:401: P1DIR = 0x00;
   0E51 75 FE 00           3152 	mov	_P1DIR,#0x00
                    08D4   3153 	C$slave_wixel_track.c$402$1$1 ==.
                           3154 ;	apps/slave_wixel_track/slave_wixel_track.c:402: P1 = 0x00;
   0E54 75 90 00           3155 	mov	_P1,#0x00
                    08D7   3156 	C$slave_wixel_track.c$403$1$1 ==.
                           3157 ;	apps/slave_wixel_track/slave_wixel_track.c:403: T1CTL = 0x00;
   0E57 75 E4 00           3158 	mov	_T1CTL,#0x00
                    08DA   3159 	C$slave_wixel_track.c$404$1$1 ==.
                           3160 ;	apps/slave_wixel_track/slave_wixel_track.c:404: T3CTL = 0x00;
   0E5A 75 CB 00           3161 	mov	_T3CTL,#0x00
                    08DD   3162 	C$slave_wixel_track.c$405$1$1 ==.
                           3163 ;	apps/slave_wixel_track/slave_wixel_track.c:405: T4CTL = 0x00;
   0E5D 75 EB 00           3164 	mov	_T4CTL,#0x00
                    08E0   3165 	C$slave_wixel_track.c$406$1$1 ==.
                           3166 ;	apps/slave_wixel_track/slave_wixel_track.c:406: P1DIR |= (1 << LED_RED_PIN) | (1 << LED_GREEN_PIN) | (1 << LED_BLUE_PIN);
   0E60 43 FE 86           3167 	orl	_P1DIR,#0x86
                    08E3   3168 	C$slave_wixel_track.c$407$1$1 ==.
                           3169 ;	apps/slave_wixel_track/slave_wixel_track.c:407: P1DIR |= (1 << R_DIR_PIN) | (1 << L_DIR_PIN);
   0E63 43 FE 60           3170 	orl	_P1DIR,#0x60
                    08E6   3171 	C$slave_wixel_track.c$408$1$1 ==.
                           3172 ;	apps/slave_wixel_track/slave_wixel_track.c:408: P1SEL = 0x00;
   0E66 75 F4 00           3173 	mov	_P1SEL,#0x00
                    08E9   3174 	C$slave_wixel_track.c$409$1$1 ==.
                           3175 ;	apps/slave_wixel_track/slave_wixel_track.c:409: P1_1 = 1;
   0E69 D2 91              3176 	setb	_P1_1
                    08EB   3177 	C$slave_wixel_track.c$410$1$1 ==.
                           3178 ;	apps/slave_wixel_track/slave_wixel_track.c:410: P1_2 = 1;
   0E6B D2 92              3179 	setb	_P1_2
                    08ED   3180 	C$slave_wixel_track.c$411$1$1 ==.
                           3181 ;	apps/slave_wixel_track/slave_wixel_track.c:411: P1_7 = 1;
   0E6D D2 97              3182 	setb	_P1_7
                    08EF   3183 	C$slave_wixel_track.c$412$1$1 ==.
                           3184 ;	apps/slave_wixel_track/slave_wixel_track.c:412: T3CC0 = 0;
   0E6F 75 CD 00           3185 	mov	_T3CC0,#0x00
                    08F2   3186 	C$slave_wixel_track.c$413$1$1 ==.
                           3187 ;	apps/slave_wixel_track/slave_wixel_track.c:413: T3CC1 = 0;
   0E72 75 CF 00           3188 	mov	_T3CC1,#0x00
                    08F5   3189 	C$slave_wixel_track.c$414$1$1 ==.
                           3190 ;	apps/slave_wixel_track/slave_wixel_track.c:414: P1_5 = 0;
   0E75 C2 95              3191 	clr	_P1_5
                    08F7   3192 	C$slave_wixel_track.c$415$1$1 ==.
                           3193 ;	apps/slave_wixel_track/slave_wixel_track.c:415: P1_6 = 0;
   0E77 C2 96              3194 	clr	_P1_6
                    08F9   3195 	C$slave_wixel_track.c$416$1$1 ==.
                    08F9   3196 	XG$gpioInit$0$0 ==.
   0E79 22                 3197 	ret
                           3198 ;------------------------------------------------------------
                           3199 ;Allocation info for local variables in function 'updateRgbLeds'
                           3200 ;------------------------------------------------------------
                    08FA   3201 	G$updateRgbLeds$0$0 ==.
                    08FA   3202 	C$slave_wixel_track.c$420$1$1 ==.
                           3203 ;	apps/slave_wixel_track/slave_wixel_track.c:420: void updateRgbLeds()
                           3204 ;	-----------------------------------------
                           3205 ;	 function updateRgbLeds
                           3206 ;	-----------------------------------------
   0E7A                    3207 _updateRgbLeds:
                    08FA   3208 	C$slave_wixel_track.c$422$1$1 ==.
                           3209 ;	apps/slave_wixel_track/slave_wixel_track.c:422: if (currentState == STATE_CALIBRATE_VALIDATE)
   0E7A 78 00              3210 	mov	r0,#_currentState
   0E7C E2                 3211 	movx	a,@r0
   0E7D B4 10 08           3212 	cjne	a,#0x10,00113$
                    0900   3213 	C$slave_wixel_track.c$425$2$2 ==.
                           3214 ;	apps/slave_wixel_track/slave_wixel_track.c:425: P1_2 = 0;
   0E80 C2 92              3215 	clr	_P1_2
                    0902   3216 	C$slave_wixel_track.c$426$2$2 ==.
                           3217 ;	apps/slave_wixel_track/slave_wixel_track.c:426: P1_1 = 0;
   0E82 C2 91              3218 	clr	_P1_1
                    0904   3219 	C$slave_wixel_track.c$427$2$2 ==.
                           3220 ;	apps/slave_wixel_track/slave_wixel_track.c:427: P1_7 = 1;
   0E84 D2 97              3221 	setb	_P1_7
   0E86 80 37              3222 	sjmp	00115$
   0E88                    3223 00113$:
                    0908   3224 	C$slave_wixel_track.c$429$1$1 ==.
                           3225 ;	apps/slave_wixel_track/slave_wixel_track.c:429: else if (currentState == STATE_HOME)
   0E88 78 00              3226 	mov	r0,#_currentState
   0E8A E2                 3227 	movx	a,@r0
   0E8B B4 01 08           3228 	cjne	a,#0x01,00110$
                    090E   3229 	C$slave_wixel_track.c$432$2$3 ==.
                           3230 ;	apps/slave_wixel_track/slave_wixel_track.c:432: P1_2 = 1;
   0E8E D2 92              3231 	setb	_P1_2
                    0910   3232 	C$slave_wixel_track.c$433$2$3 ==.
                           3233 ;	apps/slave_wixel_track/slave_wixel_track.c:433: P1_1 = 1;
   0E90 D2 91              3234 	setb	_P1_1
                    0912   3235 	C$slave_wixel_track.c$434$2$3 ==.
                           3236 ;	apps/slave_wixel_track/slave_wixel_track.c:434: P1_7 = 0;
   0E92 C2 97              3237 	clr	_P1_7
   0E94 80 29              3238 	sjmp	00115$
   0E96                    3239 00110$:
                    0916   3240 	C$slave_wixel_track.c$436$1$1 ==.
                           3241 ;	apps/slave_wixel_track/slave_wixel_track.c:436: else if (currentState == STATE_RUN)
   0E96 78 00              3242 	mov	r0,#_currentState
   0E98 E2                 3243 	movx	a,@r0
   0E99 B4 02 0F           3244 	cjne	a,#0x02,00107$
                    091C   3245 	C$slave_wixel_track.c$439$2$4 ==.
                           3246 ;	apps/slave_wixel_track/slave_wixel_track.c:439: P1_2 = 1;
   0E9C D2 92              3247 	setb	_P1_2
                    091E   3248 	C$slave_wixel_track.c$440$2$4 ==.
                           3249 ;	apps/slave_wixel_track/slave_wixel_track.c:440: P1_1 = 0;
   0E9E C2 91              3250 	clr	_P1_1
                    0920   3251 	C$slave_wixel_track.c$441$2$4 ==.
                           3252 ;	apps/slave_wixel_track/slave_wixel_track.c:441: P1_7 = 1;
   0EA0 D2 97              3253 	setb	_P1_7
                    0922   3254 	C$slave_wixel_track.c$443$2$4 ==.
                           3255 ;	apps/slave_wixel_track/slave_wixel_track.c:443: if (currentWaypointIndex == 0){
   0EA2 78 95              3256 	mov	r0,#_currentWaypointIndex
   0EA4 E2                 3257 	movx	a,@r0
   0EA5 70 18              3258 	jnz	00115$
                    0927   3259 	C$slave_wixel_track.c$445$3$5 ==.
                           3260 ;	apps/slave_wixel_track/slave_wixel_track.c:445: P1_7 = 0;
   0EA7 C2 97              3261 	clr	_P1_7
   0EA9 80 14              3262 	sjmp	00115$
   0EAB                    3263 00107$:
                    092B   3264 	C$slave_wixel_track.c$448$1$1 ==.
                           3265 ;	apps/slave_wixel_track/slave_wixel_track.c:448: else if (currentState == STATE_PREP)
   0EAB 78 00              3266 	mov	r0,#_currentState
   0EAD E2                 3267 	movx	a,@r0
   0EAE B4 03 08           3268 	cjne	a,#0x03,00104$
                    0931   3269 	C$slave_wixel_track.c$451$2$6 ==.
                           3270 ;	apps/slave_wixel_track/slave_wixel_track.c:451: P1_2 = 0;
   0EB1 C2 92              3271 	clr	_P1_2
                    0933   3272 	C$slave_wixel_track.c$452$2$6 ==.
                           3273 ;	apps/slave_wixel_track/slave_wixel_track.c:452: P1_1 = 1;
   0EB3 D2 91              3274 	setb	_P1_1
                    0935   3275 	C$slave_wixel_track.c$453$2$6 ==.
                           3276 ;	apps/slave_wixel_track/slave_wixel_track.c:453: P1_7 = 0;
   0EB5 C2 97              3277 	clr	_P1_7
   0EB7 80 06              3278 	sjmp	00115$
   0EB9                    3279 00104$:
                    0939   3280 	C$slave_wixel_track.c$458$2$7 ==.
                           3281 ;	apps/slave_wixel_track/slave_wixel_track.c:458: P1_2 = 0;
   0EB9 C2 92              3282 	clr	_P1_2
                    093B   3283 	C$slave_wixel_track.c$459$2$7 ==.
                           3284 ;	apps/slave_wixel_track/slave_wixel_track.c:459: P1_1 = 1;
   0EBB D2 91              3285 	setb	_P1_1
                    093D   3286 	C$slave_wixel_track.c$460$2$7 ==.
                           3287 ;	apps/slave_wixel_track/slave_wixel_track.c:460: P1_7 = 1;
   0EBD D2 97              3288 	setb	_P1_7
   0EBF                    3289 00115$:
                    093F   3290 	C$slave_wixel_track.c$462$1$1 ==.
                    093F   3291 	XG$updateRgbLeds$0$0 ==.
   0EBF 22                 3292 	ret
                           3293 ;------------------------------------------------------------
                           3294 ;Allocation info for local variables in function 'extractPositionData'
                           3295 ;------------------------------------------------------------
                    0940   3296 	G$extractPositionData$0$0 ==.
                    0940   3297 	C$slave_wixel_track.c$466$1$1 ==.
                           3298 ;	apps/slave_wixel_track/slave_wixel_track.c:466: void extractPositionData(uint8 offset)
                           3299 ;	-----------------------------------------
                           3300 ;	 function extractPositionData
                           3301 ;	-----------------------------------------
   0EC0                    3302 _extractPositionData:
                    0940   3303 	C$slave_wixel_track.c$471$1$1 ==.
                           3304 ;	apps/slave_wixel_track/slave_wixel_track.c:471: posX = (int16)((rxPacket[offset + 1] << 8) | rxPacket[offset + 2]);
   0EC0 E5 82              3305 	mov	a,dpl
   0EC2 FF                 3306 	mov	r7,a
   0EC3 04                 3307 	inc	a
   0EC4 24 FD              3308 	add	a,#_rxPacket
   0EC6 F5 82              3309 	mov	dpl,a
   0EC8 E4                 3310 	clr	a
   0EC9 34 F0              3311 	addc	a,#(_rxPacket >> 8)
   0ECB F5 83              3312 	mov	dph,a
   0ECD E0                 3313 	movx	a,@dptr
   0ECE FD                 3314 	mov	r5,a
   0ECF 7E 00              3315 	mov	r6,#0x00
   0ED1 74 02              3316 	mov	a,#0x02
   0ED3 2F                 3317 	add	a,r7
   0ED4 24 FD              3318 	add	a,#_rxPacket
   0ED6 F5 82              3319 	mov	dpl,a
   0ED8 E4                 3320 	clr	a
   0ED9 34 F0              3321 	addc	a,#(_rxPacket >> 8)
   0EDB F5 83              3322 	mov	dph,a
   0EDD E0                 3323 	movx	a,@dptr
   0EDE 7B 00              3324 	mov	r3,#0x00
   0EE0 42 06              3325 	orl	ar6,a
   0EE2 EB                 3326 	mov	a,r3
   0EE3 42 05              3327 	orl	ar5,a
   0EE5 78 0F              3328 	mov	r0,#_posX
   0EE7 EE                 3329 	mov	a,r6
   0EE8 F2                 3330 	movx	@r0,a
   0EE9 08                 3331 	inc	r0
   0EEA ED                 3332 	mov	a,r5
   0EEB F2                 3333 	movx	@r0,a
                    096C   3334 	C$slave_wixel_track.c$472$1$1 ==.
                           3335 ;	apps/slave_wixel_track/slave_wixel_track.c:472: posY = (int16)((rxPacket[offset + 3] << 8) | rxPacket[offset + 4]);
   0EEC 74 03              3336 	mov	a,#0x03
   0EEE 2F                 3337 	add	a,r7
   0EEF 24 FD              3338 	add	a,#_rxPacket
   0EF1 F5 82              3339 	mov	dpl,a
   0EF3 E4                 3340 	clr	a
   0EF4 34 F0              3341 	addc	a,#(_rxPacket >> 8)
   0EF6 F5 83              3342 	mov	dph,a
   0EF8 E0                 3343 	movx	a,@dptr
   0EF9 FD                 3344 	mov	r5,a
   0EFA 7E 00              3345 	mov	r6,#0x00
   0EFC 74 04              3346 	mov	a,#0x04
   0EFE 2F                 3347 	add	a,r7
   0EFF 24 FD              3348 	add	a,#_rxPacket
   0F01 F5 82              3349 	mov	dpl,a
   0F03 E4                 3350 	clr	a
   0F04 34 F0              3351 	addc	a,#(_rxPacket >> 8)
   0F06 F5 83              3352 	mov	dph,a
   0F08 E0                 3353 	movx	a,@dptr
   0F09 7B 00              3354 	mov	r3,#0x00
   0F0B 42 06              3355 	orl	ar6,a
   0F0D EB                 3356 	mov	a,r3
   0F0E 42 05              3357 	orl	ar5,a
   0F10 78 11              3358 	mov	r0,#_posY
   0F12 EE                 3359 	mov	a,r6
   0F13 F2                 3360 	movx	@r0,a
   0F14 08                 3361 	inc	r0
   0F15 ED                 3362 	mov	a,r5
   0F16 F2                 3363 	movx	@r0,a
                    0997   3364 	C$slave_wixel_track.c$473$1$1 ==.
                           3365 ;	apps/slave_wixel_track/slave_wixel_track.c:473: rawTheta = rxPacket[offset + 5]; 
   0F17 74 05              3366 	mov	a,#0x05
   0F19 2F                 3367 	add	a,r7
   0F1A 24 FD              3368 	add	a,#_rxPacket
   0F1C F5 82              3369 	mov	dpl,a
   0F1E E4                 3370 	clr	a
   0F1F 34 F0              3371 	addc	a,#(_rxPacket >> 8)
   0F21 F5 83              3372 	mov	dph,a
   0F23 E0                 3373 	movx	a,@dptr
                    09A4   3374 	C$slave_wixel_track.c$475$1$1 ==.
                           3375 ;	apps/slave_wixel_track/slave_wixel_track.c:475: mapped_theta = (int16)(((int32)rawTheta * 360L) / 256L);
   0F24 78 EB              3376 	mov	r0,#__mullong_PARM_2
   0F26 F2                 3377 	movx	@r0,a
   0F27 08                 3378 	inc	r0
   0F28 E4                 3379 	clr	a
   0F29 F2                 3380 	movx	@r0,a
   0F2A 08                 3381 	inc	r0
   0F2B F2                 3382 	movx	@r0,a
   0F2C 08                 3383 	inc	r0
   0F2D F2                 3384 	movx	@r0,a
   0F2E 90 01 68           3385 	mov	dptr,#0x0168
   0F31 E4                 3386 	clr	a
   0F32 F5 F0              3387 	mov	b,a
   0F34 12 1E 60           3388 	lcall	__mullong
   0F37 AC 82              3389 	mov	r4,dpl
   0F39 AD 83              3390 	mov	r5,dph
   0F3B AE F0              3391 	mov	r6,b
   0F3D FF                 3392 	mov	r7,a
   0F3E 78 DA              3393 	mov	r0,#__divslong_PARM_2
   0F40 E4                 3394 	clr	a
   0F41 F2                 3395 	movx	@r0,a
   0F42 08                 3396 	inc	r0
   0F43 74 01              3397 	mov	a,#0x01
   0F45 F2                 3398 	movx	@r0,a
   0F46 08                 3399 	inc	r0
   0F47 E4                 3400 	clr	a
   0F48 F2                 3401 	movx	@r0,a
   0F49 08                 3402 	inc	r0
   0F4A F2                 3403 	movx	@r0,a
   0F4B 8C 82              3404 	mov	dpl,r4
   0F4D 8D 83              3405 	mov	dph,r5
   0F4F 8E F0              3406 	mov	b,r6
   0F51 EF                 3407 	mov	a,r7
   0F52 12 1C 0F           3408 	lcall	__divslong
   0F55 AC 82              3409 	mov	r4,dpl
   0F57 AD 83              3410 	mov	r5,dph
   0F59 AE F0              3411 	mov	r6,b
   0F5B FF                 3412 	mov	r7,a
                    09DC   3413 	C$slave_wixel_track.c$476$1$1 ==.
                           3414 ;	apps/slave_wixel_track/slave_wixel_track.c:476: mapped_theta += orientationOffset;
   0F5C 78 AB              3415 	mov	r0,#_orientationOffset
   0F5E E2                 3416 	movx	a,@r0
   0F5F 2C                 3417 	add	a,r4
   0F60 FC                 3418 	mov	r4,a
   0F61 08                 3419 	inc	r0
   0F62 E2                 3420 	movx	a,@r0
   0F63 3D                 3421 	addc	a,r5
   0F64 FD                 3422 	mov	r5,a
                    09E5   3423 	C$slave_wixel_track.c$478$1$1 ==.
                           3424 ;	apps/slave_wixel_track/slave_wixel_track.c:478: if (mapped_theta > 180)
   0F65 C3                 3425 	clr	c
   0F66 74 B4              3426 	mov	a,#0xB4
   0F68 9C                 3427 	subb	a,r4
   0F69 E4                 3428 	clr	a
   0F6A 64 80              3429 	xrl	a,#0x80
   0F6C 8D F0              3430 	mov	b,r5
   0F6E 63 F0 80           3431 	xrl	b,#0x80
   0F71 95 F0              3432 	subb	a,b
   0F73 50 0D              3433 	jnc	00105$
                    09F5   3434 	C$slave_wixel_track.c$480$2$2 ==.
                           3435 ;	apps/slave_wixel_track/slave_wixel_track.c:480: posTheta = mapped_theta - 360;
   0F75 78 13              3436 	mov	r0,#_posTheta
   0F77 EC                 3437 	mov	a,r4
   0F78 24 98              3438 	add	a,#0x98
   0F7A F2                 3439 	movx	@r0,a
   0F7B ED                 3440 	mov	a,r5
   0F7C 34 FE              3441 	addc	a,#0xFE
   0F7E 08                 3442 	inc	r0
   0F7F F2                 3443 	movx	@r0,a
   0F80 80 1F              3444 	sjmp	00107$
   0F82                    3445 00105$:
                    0A02   3446 	C$slave_wixel_track.c$482$1$1 ==.
                           3447 ;	apps/slave_wixel_track/slave_wixel_track.c:482: else if (mapped_theta < -180)
   0F82 C3                 3448 	clr	c
   0F83 EC                 3449 	mov	a,r4
   0F84 94 4C              3450 	subb	a,#0x4C
   0F86 ED                 3451 	mov	a,r5
   0F87 64 80              3452 	xrl	a,#0x80
   0F89 94 7F              3453 	subb	a,#0x7f
   0F8B 50 0D              3454 	jnc	00102$
                    0A0D   3455 	C$slave_wixel_track.c$484$2$3 ==.
                           3456 ;	apps/slave_wixel_track/slave_wixel_track.c:484: posTheta = mapped_theta + 360;
   0F8D 78 13              3457 	mov	r0,#_posTheta
   0F8F 74 68              3458 	mov	a,#0x68
   0F91 2C                 3459 	add	a,r4
   0F92 F2                 3460 	movx	@r0,a
   0F93 74 01              3461 	mov	a,#0x01
   0F95 3D                 3462 	addc	a,r5
   0F96 08                 3463 	inc	r0
   0F97 F2                 3464 	movx	@r0,a
   0F98 80 07              3465 	sjmp	00107$
   0F9A                    3466 00102$:
                    0A1A   3467 	C$slave_wixel_track.c$488$2$4 ==.
                           3468 ;	apps/slave_wixel_track/slave_wixel_track.c:488: posTheta = mapped_theta;
   0F9A 78 13              3469 	mov	r0,#_posTheta
   0F9C EC                 3470 	mov	a,r4
   0F9D F2                 3471 	movx	@r0,a
   0F9E 08                 3472 	inc	r0
   0F9F ED                 3473 	mov	a,r5
   0FA0 F2                 3474 	movx	@r0,a
   0FA1                    3475 00107$:
                    0A21   3476 	C$slave_wixel_track.c$490$1$1 ==.
                    0A21   3477 	XG$extractPositionData$0$0 ==.
   0FA1 22                 3478 	ret
                           3479 ;------------------------------------------------------------
                           3480 ;Allocation info for local variables in function 'handleCmdStop'
                           3481 ;------------------------------------------------------------
                    0A22   3482 	G$handleCmdStop$0$0 ==.
                    0A22   3483 	C$slave_wixel_track.c$492$1$1 ==.
                           3484 ;	apps/slave_wixel_track/slave_wixel_track.c:492: void handleCmdStop()
                           3485 ;	-----------------------------------------
                           3486 ;	 function handleCmdStop
                           3487 ;	-----------------------------------------
   0FA2                    3488 _handleCmdStop:
                    0A22   3489 	C$slave_wixel_track.c$494$1$1 ==.
                           3490 ;	apps/slave_wixel_track/slave_wixel_track.c:494: currentState = STATE_IDLE;
   0FA2 78 00              3491 	mov	r0,#_currentState
   0FA4 E4                 3492 	clr	a
   0FA5 F2                 3493 	movx	@r0,a
                    0A26   3494 	C$slave_wixel_track.c$495$1$1 ==.
                           3495 ;	apps/slave_wixel_track/slave_wixel_track.c:495: calib_step = 0;
   0FA6 78 B1              3496 	mov	r0,#_calib_step
   0FA8 E4                 3497 	clr	a
   0FA9 F2                 3498 	movx	@r0,a
                    0A2A   3499 	C$slave_wixel_track.c$496$1$1 ==.
                           3500 ;	apps/slave_wixel_track/slave_wixel_track.c:496: waypointCount = 0;
   0FAA 78 93              3501 	mov	r0,#_waypointCount
   0FAC E4                 3502 	clr	a
   0FAD F2                 3503 	movx	@r0,a
                    0A2E   3504 	C$slave_wixel_track.c$497$1$1 ==.
                           3505 ;	apps/slave_wixel_track/slave_wixel_track.c:497: currentWaypointIndex = 0;
   0FAE 78 95              3506 	mov	r0,#_currentWaypointIndex
   0FB0 E4                 3507 	clr	a
   0FB1 F2                 3508 	movx	@r0,a
                    0A32   3509 	C$slave_wixel_track.c$498$1$1 ==.
                           3510 ;	apps/slave_wixel_track/slave_wixel_track.c:498: runSubState = 0;
   0FB2 78 96              3511 	mov	r0,#_runSubState
   0FB4 E4                 3512 	clr	a
   0FB5 F2                 3513 	movx	@r0,a
                    0A36   3514 	C$slave_wixel_track.c$499$1$1 ==.
                           3515 ;	apps/slave_wixel_track/slave_wixel_track.c:499: homeSubState = 0;
   0FB6 78 97              3516 	mov	r0,#_homeSubState
   0FB8 E4                 3517 	clr	a
   0FB9 F2                 3518 	movx	@r0,a
                    0A3A   3519 	C$slave_wixel_track.c$500$1$1 ==.
                           3520 ;	apps/slave_wixel_track/slave_wixel_track.c:500: pwm_left = 0;
   0FBA 78 27              3521 	mov	r0,#_pwm_left
   0FBC E4                 3522 	clr	a
   0FBD F2                 3523 	movx	@r0,a
   0FBE 08                 3524 	inc	r0
   0FBF F2                 3525 	movx	@r0,a
                    0A40   3526 	C$slave_wixel_track.c$501$1$1 ==.
                           3527 ;	apps/slave_wixel_track/slave_wixel_track.c:501: pwm_right = 0;
   0FC0 78 29              3528 	mov	r0,#_pwm_right
   0FC2 E4                 3529 	clr	a
   0FC3 F2                 3530 	movx	@r0,a
   0FC4 08                 3531 	inc	r0
   0FC5 F2                 3532 	movx	@r0,a
                    0A46   3533 	C$slave_wixel_track.c$502$1$1 ==.
                           3534 ;	apps/slave_wixel_track/slave_wixel_track.c:502: stopMotors();
   0FC6 12 0D E2           3535 	lcall	_stopMotors
                    0A49   3536 	C$slave_wixel_track.c$503$1$1 ==.
                    0A49   3537 	XG$handleCmdStop$0$0 ==.
   0FC9 22                 3538 	ret
                           3539 ;------------------------------------------------------------
                           3540 ;Allocation info for local variables in function 'handleCmdGoTo'
                           3541 ;------------------------------------------------------------
                    0A4A   3542 	G$handleCmdGoTo$0$0 ==.
                    0A4A   3543 	C$slave_wixel_track.c$505$1$1 ==.
                           3544 ;	apps/slave_wixel_track/slave_wixel_track.c:505: void handleCmdGoTo(uint8 offset)
                           3545 ;	-----------------------------------------
                           3546 ;	 function handleCmdGoTo
                           3547 ;	-----------------------------------------
   0FCA                    3548 _handleCmdGoTo:
   0FCA AF 82              3549 	mov	r7,dpl
                    0A4C   3550 	C$slave_wixel_track.c$507$1$1 ==.
                           3551 ;	apps/slave_wixel_track/slave_wixel_track.c:507: targetX = (int16)((rxPacket[offset + 7] << 8) | rxPacket[offset + 8]);
   0FCC 74 07              3552 	mov	a,#0x07
   0FCE 2F                 3553 	add	a,r7
   0FCF 24 FD              3554 	add	a,#_rxPacket
   0FD1 F5 82              3555 	mov	dpl,a
   0FD3 E4                 3556 	clr	a
   0FD4 34 F0              3557 	addc	a,#(_rxPacket >> 8)
   0FD6 F5 83              3558 	mov	dph,a
   0FD8 E0                 3559 	movx	a,@dptr
   0FD9 FD                 3560 	mov	r5,a
   0FDA 7E 00              3561 	mov	r6,#0x00
   0FDC 74 08              3562 	mov	a,#0x08
   0FDE 2F                 3563 	add	a,r7
   0FDF 24 FD              3564 	add	a,#_rxPacket
   0FE1 F5 82              3565 	mov	dpl,a
   0FE3 E4                 3566 	clr	a
   0FE4 34 F0              3567 	addc	a,#(_rxPacket >> 8)
   0FE6 F5 83              3568 	mov	dph,a
   0FE8 E0                 3569 	movx	a,@dptr
   0FE9 7B 00              3570 	mov	r3,#0x00
   0FEB 42 06              3571 	orl	ar6,a
   0FED EB                 3572 	mov	a,r3
   0FEE 42 05              3573 	orl	ar5,a
   0FF0 78 1B              3574 	mov	r0,#_targetX
   0FF2 EE                 3575 	mov	a,r6
   0FF3 F2                 3576 	movx	@r0,a
   0FF4 08                 3577 	inc	r0
   0FF5 ED                 3578 	mov	a,r5
   0FF6 F2                 3579 	movx	@r0,a
                    0A77   3580 	C$slave_wixel_track.c$508$1$1 ==.
                           3581 ;	apps/slave_wixel_track/slave_wixel_track.c:508: targetY = (int16)((rxPacket[offset + 9] << 8) | rxPacket[offset + 10]);
   0FF7 74 09              3582 	mov	a,#0x09
   0FF9 2F                 3583 	add	a,r7
   0FFA 24 FD              3584 	add	a,#_rxPacket
   0FFC F5 82              3585 	mov	dpl,a
   0FFE E4                 3586 	clr	a
   0FFF 34 F0              3587 	addc	a,#(_rxPacket >> 8)
   1001 F5 83              3588 	mov	dph,a
   1003 E0                 3589 	movx	a,@dptr
   1004 FB                 3590 	mov	r3,a
   1005 7C 00              3591 	mov	r4,#0x00
   1007 74 0A              3592 	mov	a,#0x0A
   1009 2F                 3593 	add	a,r7
   100A 24 FD              3594 	add	a,#_rxPacket
   100C F5 82              3595 	mov	dpl,a
   100E E4                 3596 	clr	a
   100F 34 F0              3597 	addc	a,#(_rxPacket >> 8)
   1011 F5 83              3598 	mov	dph,a
   1013 E0                 3599 	movx	a,@dptr
   1014 7A 00              3600 	mov	r2,#0x00
   1016 4C                 3601 	orl	a,r4
   1017 FF                 3602 	mov	r7,a
   1018 EA                 3603 	mov	a,r2
   1019 4B                 3604 	orl	a,r3
   101A FC                 3605 	mov	r4,a
   101B 78 1F              3606 	mov	r0,#_targetY
   101D EF                 3607 	mov	a,r7
   101E F2                 3608 	movx	@r0,a
   101F 08                 3609 	inc	r0
   1020 EC                 3610 	mov	a,r4
   1021 F2                 3611 	movx	@r0,a
                    0AA2   3612 	C$slave_wixel_track.c$510$1$1 ==.
                           3613 ;	apps/slave_wixel_track/slave_wixel_track.c:510: if (currentState == STATE_HOME && targetX == lastTargetX && targetY == lastTargetY)
   1022 78 00              3614 	mov	r0,#_currentState
   1024 E2                 3615 	movx	a,@r0
   1025 B4 01 04           3616 	cjne	a,#0x01,00118$
   1028 74 01              3617 	mov	a,#0x01
   102A 80 01              3618 	sjmp	00119$
   102C                    3619 00118$:
   102C E4                 3620 	clr	a
   102D                    3621 00119$:
   102D FB                 3622 	mov	r3,a
   102E 60 21              3623 	jz	00102$
   1030 78 1D              3624 	mov	r0,#_lastTargetX
   1032 E2                 3625 	movx	a,@r0
   1033 B5 06 07           3626 	cjne	a,ar6,00121$
   1036 08                 3627 	inc	r0
   1037 E2                 3628 	movx	a,@r0
   1038 B5 05 02           3629 	cjne	a,ar5,00121$
   103B 80 02              3630 	sjmp	00122$
   103D                    3631 00121$:
   103D 80 12              3632 	sjmp	00102$
   103F                    3633 00122$:
   103F 78 21              3634 	mov	r0,#_lastTargetY
   1041 E2                 3635 	movx	a,@r0
   1042 B5 07 07           3636 	cjne	a,ar7,00123$
   1045 08                 3637 	inc	r0
   1046 E2                 3638 	movx	a,@r0
   1047 B5 04 02           3639 	cjne	a,ar4,00123$
   104A 80 02              3640 	sjmp	00124$
   104C                    3641 00123$:
   104C 80 03              3642 	sjmp	00102$
   104E                    3643 00124$:
                    0ACE   3644 	C$slave_wixel_track.c$512$2$2 ==.
                           3645 ;	apps/slave_wixel_track/slave_wixel_track.c:512: return;
   104E 02 10 E9           3646 	ljmp	00111$
   1051                    3647 00102$:
                    0AD1   3648 	C$slave_wixel_track.c$515$1$1 ==.
                           3649 ;	apps/slave_wixel_track/slave_wixel_track.c:515: if (currentState == STATE_HOME)
   1051 EB                 3650 	mov	a,r3
   1052 60 55              3651 	jz	00109$
                    0AD4   3652 	C$slave_wixel_track.c$517$2$3 ==.
                           3653 ;	apps/slave_wixel_track/slave_wixel_track.c:517: if (targetX != lastTargetX || targetY != lastTargetY)
   1054 78 1D              3654 	mov	r0,#_lastTargetX
   1056 E2                 3655 	movx	a,@r0
   1057 B5 06 07           3656 	cjne	a,ar6,00126$
   105A 08                 3657 	inc	r0
   105B E2                 3658 	movx	a,@r0
   105C B5 05 02           3659 	cjne	a,ar5,00126$
   105F 80 02              3660 	sjmp	00127$
   1061                    3661 00126$:
   1061 80 0D              3662 	sjmp	00105$
   1063                    3663 00127$:
   1063 78 21              3664 	mov	r0,#_lastTargetY
   1065 E2                 3665 	movx	a,@r0
   1066 B5 07 07           3666 	cjne	a,ar7,00128$
   1069 08                 3667 	inc	r0
   106A E2                 3668 	movx	a,@r0
   106B B5 04 02           3669 	cjne	a,ar4,00128$
   106E 80 70              3670 	sjmp	00110$
   1070                    3671 00128$:
   1070                    3672 00105$:
                    0AF0   3673 	C$slave_wixel_track.c$519$3$4 ==.
                           3674 ;	apps/slave_wixel_track/slave_wixel_track.c:519: stateStartTime = (uint32)getMs();
   1070 12 20 8C           3675 	lcall	_getMs
   1073 AC 82              3676 	mov	r4,dpl
   1075 AD 83              3677 	mov	r5,dph
   1077 AE F0              3678 	mov	r6,b
   1079 FF                 3679 	mov	r7,a
   107A 78 23              3680 	mov	r0,#_stateStartTime
   107C EC                 3681 	mov	a,r4
   107D F2                 3682 	movx	@r0,a
   107E 08                 3683 	inc	r0
   107F ED                 3684 	mov	a,r5
   1080 F2                 3685 	movx	@r0,a
   1081 08                 3686 	inc	r0
   1082 EE                 3687 	mov	a,r6
   1083 F2                 3688 	movx	@r0,a
   1084 08                 3689 	inc	r0
   1085 EF                 3690 	mov	a,r7
   1086 F2                 3691 	movx	@r0,a
                    0B07   3692 	C$slave_wixel_track.c$520$3$4 ==.
                           3693 ;	apps/slave_wixel_track/slave_wixel_track.c:520: lastTargetX = targetX;
   1087 78 1B              3694 	mov	r0,#_targetX
   1089 E2                 3695 	movx	a,@r0
   108A FE                 3696 	mov	r6,a
   108B 08                 3697 	inc	r0
   108C E2                 3698 	movx	a,@r0
   108D FF                 3699 	mov	r7,a
   108E 78 1D              3700 	mov	r0,#_lastTargetX
   1090 EE                 3701 	mov	a,r6
   1091 F2                 3702 	movx	@r0,a
   1092 08                 3703 	inc	r0
   1093 EF                 3704 	mov	a,r7
   1094 F2                 3705 	movx	@r0,a
                    0B15   3706 	C$slave_wixel_track.c$521$3$4 ==.
                           3707 ;	apps/slave_wixel_track/slave_wixel_track.c:521: lastTargetY = targetY;
   1095 78 1F              3708 	mov	r0,#_targetY
   1097 E2                 3709 	movx	a,@r0
   1098 FE                 3710 	mov	r6,a
   1099 08                 3711 	inc	r0
   109A E2                 3712 	movx	a,@r0
   109B FF                 3713 	mov	r7,a
   109C 78 21              3714 	mov	r0,#_lastTargetY
   109E EE                 3715 	mov	a,r6
   109F F2                 3716 	movx	@r0,a
   10A0 08                 3717 	inc	r0
   10A1 EF                 3718 	mov	a,r7
   10A2 F2                 3719 	movx	@r0,a
                    0B23   3720 	C$slave_wixel_track.c$522$3$4 ==.
                           3721 ;	apps/slave_wixel_track/slave_wixel_track.c:522: homeSubState = 0;  // Reset to rotation
   10A3 78 97              3722 	mov	r0,#_homeSubState
   10A5 E4                 3723 	clr	a
   10A6 F2                 3724 	movx	@r0,a
   10A7 80 37              3725 	sjmp	00110$
   10A9                    3726 00109$:
                    0B29   3727 	C$slave_wixel_track.c$527$2$5 ==.
                           3728 ;	apps/slave_wixel_track/slave_wixel_track.c:527: stateStartTime = (uint32)getMs();
   10A9 12 20 8C           3729 	lcall	_getMs
   10AC AC 82              3730 	mov	r4,dpl
   10AE AD 83              3731 	mov	r5,dph
   10B0 AE F0              3732 	mov	r6,b
   10B2 FF                 3733 	mov	r7,a
   10B3 78 23              3734 	mov	r0,#_stateStartTime
   10B5 EC                 3735 	mov	a,r4
   10B6 F2                 3736 	movx	@r0,a
   10B7 08                 3737 	inc	r0
   10B8 ED                 3738 	mov	a,r5
   10B9 F2                 3739 	movx	@r0,a
   10BA 08                 3740 	inc	r0
   10BB EE                 3741 	mov	a,r6
   10BC F2                 3742 	movx	@r0,a
   10BD 08                 3743 	inc	r0
   10BE EF                 3744 	mov	a,r7
   10BF F2                 3745 	movx	@r0,a
                    0B40   3746 	C$slave_wixel_track.c$528$2$5 ==.
                           3747 ;	apps/slave_wixel_track/slave_wixel_track.c:528: lastTargetX = targetX;
   10C0 78 1B              3748 	mov	r0,#_targetX
   10C2 E2                 3749 	movx	a,@r0
   10C3 FE                 3750 	mov	r6,a
   10C4 08                 3751 	inc	r0
   10C5 E2                 3752 	movx	a,@r0
   10C6 FF                 3753 	mov	r7,a
   10C7 78 1D              3754 	mov	r0,#_lastTargetX
   10C9 EE                 3755 	mov	a,r6
   10CA F2                 3756 	movx	@r0,a
   10CB 08                 3757 	inc	r0
   10CC EF                 3758 	mov	a,r7
   10CD F2                 3759 	movx	@r0,a
                    0B4E   3760 	C$slave_wixel_track.c$529$2$5 ==.
                           3761 ;	apps/slave_wixel_track/slave_wixel_track.c:529: lastTargetY = targetY;
   10CE 78 1F              3762 	mov	r0,#_targetY
   10D0 E2                 3763 	movx	a,@r0
   10D1 FE                 3764 	mov	r6,a
   10D2 08                 3765 	inc	r0
   10D3 E2                 3766 	movx	a,@r0
   10D4 FF                 3767 	mov	r7,a
   10D5 78 21              3768 	mov	r0,#_lastTargetY
   10D7 EE                 3769 	mov	a,r6
   10D8 F2                 3770 	movx	@r0,a
   10D9 08                 3771 	inc	r0
   10DA EF                 3772 	mov	a,r7
   10DB F2                 3773 	movx	@r0,a
                    0B5C   3774 	C$slave_wixel_track.c$530$2$5 ==.
                           3775 ;	apps/slave_wixel_track/slave_wixel_track.c:530: homeSubState = 0;  // Start with rotation
   10DC 78 97              3776 	mov	r0,#_homeSubState
   10DE E4                 3777 	clr	a
   10DF F2                 3778 	movx	@r0,a
   10E0                    3779 00110$:
                    0B60   3780 	C$slave_wixel_track.c$533$1$1 ==.
                           3781 ;	apps/slave_wixel_track/slave_wixel_track.c:533: currentState = STATE_HOME;
   10E0 78 00              3782 	mov	r0,#_currentState
   10E2 74 01              3783 	mov	a,#0x01
   10E4 F2                 3784 	movx	@r0,a
                    0B65   3785 	C$slave_wixel_track.c$534$1$1 ==.
                           3786 ;	apps/slave_wixel_track/slave_wixel_track.c:534: calib_step = 0;
   10E5 78 B1              3787 	mov	r0,#_calib_step
   10E7 E4                 3788 	clr	a
   10E8 F2                 3789 	movx	@r0,a
   10E9                    3790 00111$:
                    0B69   3791 	C$slave_wixel_track.c$535$1$1 ==.
                    0B69   3792 	XG$handleCmdGoTo$0$0 ==.
   10E9 22                 3793 	ret
                           3794 ;------------------------------------------------------------
                           3795 ;Allocation info for local variables in function 'handleCmdPrep'
                           3796 ;------------------------------------------------------------
                    0B6A   3797 	G$handleCmdPrep$0$0 ==.
                    0B6A   3798 	C$slave_wixel_track.c$537$1$1 ==.
                           3799 ;	apps/slave_wixel_track/slave_wixel_track.c:537: void handleCmdPrep(uint8 offset)
                           3800 ;	-----------------------------------------
                           3801 ;	 function handleCmdPrep
                           3802 ;	-----------------------------------------
   10EA                    3803 _handleCmdPrep:
   10EA AF 82              3804 	mov	r7,dpl
                    0B6C   3805 	C$slave_wixel_track.c$542$1$1 ==.
                           3806 ;	apps/slave_wixel_track/slave_wixel_track.c:542: if (currentState != STATE_IDLE && currentState != STATE_PREP)
   10EC 78 00              3807 	mov	r0,#_currentState
   10EE E2                 3808 	movx	a,@r0
   10EF 60 0B              3809 	jz	00102$
   10F1 78 00              3810 	mov	r0,#_currentState
   10F3 E2                 3811 	movx	a,@r0
   10F4 B4 03 02           3812 	cjne	a,#0x03,00118$
   10F7 80 03              3813 	sjmp	00102$
   10F9                    3814 00118$:
                    0B79   3815 	C$slave_wixel_track.c$544$2$2 ==.
                           3816 ;	apps/slave_wixel_track/slave_wixel_track.c:544: return;
   10F9 02 11 9E           3817 	ljmp	00110$
   10FC                    3818 00102$:
                    0B7C   3819 	C$slave_wixel_track.c$547$1$1 ==.
                           3820 ;	apps/slave_wixel_track/slave_wixel_track.c:547: if (currentState == STATE_IDLE)
   10FC 78 00              3821 	mov	r0,#_currentState
   10FE E2                 3822 	movx	a,@r0
   10FF 70 09              3823 	jnz	00105$
                    0B81   3824 	C$slave_wixel_track.c$550$2$3 ==.
                           3825 ;	apps/slave_wixel_track/slave_wixel_track.c:550: waypointCount = 0;
   1101 78 93              3826 	mov	r0,#_waypointCount
   1103 E4                 3827 	clr	a
   1104 F2                 3828 	movx	@r0,a
                    0B85   3829 	C$slave_wixel_track.c$551$2$3 ==.
                           3830 ;	apps/slave_wixel_track/slave_wixel_track.c:551: currentState = STATE_PREP;
   1105 78 00              3831 	mov	r0,#_currentState
   1107 74 03              3832 	mov	a,#0x03
   1109 F2                 3833 	movx	@r0,a
   110A                    3834 00105$:
                    0B8A   3835 	C$slave_wixel_track.c$556$1$1 ==.
                           3836 ;	apps/slave_wixel_track/slave_wixel_track.c:556: order = rxPacket[offset + 7];
   110A 74 07              3837 	mov	a,#0x07
   110C 2F                 3838 	add	a,r7
   110D 24 FD              3839 	add	a,#_rxPacket
   110F F5 82              3840 	mov	dpl,a
   1111 E4                 3841 	clr	a
   1112 34 F0              3842 	addc	a,#(_rxPacket >> 8)
   1114 F5 83              3843 	mov	dph,a
   1116 E0                 3844 	movx	a,@dptr
   1117 FE                 3845 	mov	r6,a
                    0B98   3846 	C$slave_wixel_track.c$557$1$1 ==.
                           3847 ;	apps/slave_wixel_track/slave_wixel_track.c:557: wp_x = (int16)((rxPacket[offset + 8] << 8) | rxPacket[offset + 9]);
   1118 74 08              3848 	mov	a,#0x08
   111A 2F                 3849 	add	a,r7
   111B 24 FD              3850 	add	a,#_rxPacket
   111D F5 82              3851 	mov	dpl,a
   111F E4                 3852 	clr	a
   1120 34 F0              3853 	addc	a,#(_rxPacket >> 8)
   1122 F5 83              3854 	mov	dph,a
   1124 E0                 3855 	movx	a,@dptr
   1125 FC                 3856 	mov	r4,a
   1126 7D 00              3857 	mov	r5,#0x00
   1128 74 09              3858 	mov	a,#0x09
   112A 2F                 3859 	add	a,r7
   112B 24 FD              3860 	add	a,#_rxPacket
   112D F5 82              3861 	mov	dpl,a
   112F E4                 3862 	clr	a
   1130 34 F0              3863 	addc	a,#(_rxPacket >> 8)
   1132 F5 83              3864 	mov	dph,a
   1134 E0                 3865 	movx	a,@dptr
   1135 FB                 3866 	mov	r3,a
   1136 7A 00              3867 	mov	r2,#0x00
   1138 78 D8              3868 	mov	r0,#_handleCmdPrep_wp_x_1_1
   113A EB                 3869 	mov	a,r3
   113B 4D                 3870 	orl	a,r5
   113C F2                 3871 	movx	@r0,a
   113D EA                 3872 	mov	a,r2
   113E 4C                 3873 	orl	a,r4
   113F 08                 3874 	inc	r0
   1140 F2                 3875 	movx	@r0,a
                    0BC1   3876 	C$slave_wixel_track.c$558$1$1 ==.
                           3877 ;	apps/slave_wixel_track/slave_wixel_track.c:558: wp_y = (int16)((rxPacket[offset + 10] << 8) | rxPacket[offset + 11]);
   1141 74 0A              3878 	mov	a,#0x0A
   1143 2F                 3879 	add	a,r7
   1144 24 FD              3880 	add	a,#_rxPacket
   1146 F5 82              3881 	mov	dpl,a
   1148 E4                 3882 	clr	a
   1149 34 F0              3883 	addc	a,#(_rxPacket >> 8)
   114B F5 83              3884 	mov	dph,a
   114D E0                 3885 	movx	a,@dptr
   114E FA                 3886 	mov	r2,a
   114F 7B 00              3887 	mov	r3,#0x00
   1151 74 0B              3888 	mov	a,#0x0B
   1153 2F                 3889 	add	a,r7
   1154 24 FD              3890 	add	a,#_rxPacket
   1156 F5 82              3891 	mov	dpl,a
   1158 E4                 3892 	clr	a
   1159 34 F0              3893 	addc	a,#(_rxPacket >> 8)
   115B F5 83              3894 	mov	dph,a
   115D E0                 3895 	movx	a,@dptr
   115E FD                 3896 	mov	r5,a
   115F 7F 00              3897 	mov	r7,#0x00
   1161 EB                 3898 	mov	a,r3
   1162 42 05              3899 	orl	ar5,a
   1164 EA                 3900 	mov	a,r2
   1165 42 07              3901 	orl	ar7,a
                    0BE7   3902 	C$slave_wixel_track.c$561$1$1 ==.
                           3903 ;	apps/slave_wixel_track/slave_wixel_track.c:561: if (order < MAX_WAYPOINTS)
   1167 BE 14 00           3904 	cjne	r6,#0x14,00120$
   116A                    3905 00120$:
   116A 50 32              3906 	jnc	00110$
                    0BEC   3907 	C$slave_wixel_track.c$564$2$4 ==.
                           3908 ;	apps/slave_wixel_track/slave_wixel_track.c:564: waypoints[order].order = order;
   116C EE                 3909 	mov	a,r6
   116D 75 F0 05           3910 	mov	b,#0x05
   1170 A4                 3911 	mul	ab
   1171 FC                 3912 	mov	r4,a
   1172 24 2F              3913 	add	a,#_waypoints
   1174 F9                 3914 	mov	r1,a
   1175 EE                 3915 	mov	a,r6
   1176 F3                 3916 	movx	@r1,a
                    0BF7   3917 	C$slave_wixel_track.c$565$2$4 ==.
                           3918 ;	apps/slave_wixel_track/slave_wixel_track.c:565: waypoints[order].x = wp_x;
   1177 EC                 3919 	mov	a,r4
   1178 24 2F              3920 	add	a,#_waypoints
   117A FC                 3921 	mov	r4,a
   117B 04                 3922 	inc	a
   117C F9                 3923 	mov	r1,a
   117D 78 D8              3924 	mov	r0,#_handleCmdPrep_wp_x_1_1
   117F E2                 3925 	movx	a,@r0
   1180 F3                 3926 	movx	@r1,a
   1181 09                 3927 	inc	r1
   1182 08                 3928 	inc	r0
   1183 E2                 3929 	movx	a,@r0
   1184 F3                 3930 	movx	@r1,a
                    0C05   3931 	C$slave_wixel_track.c$566$2$4 ==.
                           3932 ;	apps/slave_wixel_track/slave_wixel_track.c:566: waypoints[order].y = wp_y;
   1185 74 03              3933 	mov	a,#0x03
   1187 2C                 3934 	add	a,r4
   1188 F9                 3935 	mov	r1,a
   1189 ED                 3936 	mov	a,r5
   118A F3                 3937 	movx	@r1,a
   118B 09                 3938 	inc	r1
   118C EF                 3939 	mov	a,r7
   118D F3                 3940 	movx	@r1,a
                    0C0E   3941 	C$slave_wixel_track.c$569$2$4 ==.
                           3942 ;	apps/slave_wixel_track/slave_wixel_track.c:569: if (order >= waypointCount)
   118E 78 93              3943 	mov	r0,#_waypointCount
   1190 C3                 3944 	clr	c
   1191 E2                 3945 	movx	a,@r0
   1192 F5 F0              3946 	mov	b,a
   1194 EE                 3947 	mov	a,r6
   1195 95 F0              3948 	subb	a,b
   1197 40 05              3949 	jc	00110$
                    0C19   3950 	C$slave_wixel_track.c$570$2$4 ==.
                           3951 ;	apps/slave_wixel_track/slave_wixel_track.c:570: waypointCount = order + 1;
   1199 78 93              3952 	mov	r0,#_waypointCount
   119B EE                 3953 	mov	a,r6
   119C 04                 3954 	inc	a
   119D F2                 3955 	movx	@r0,a
   119E                    3956 00110$:
                    0C1E   3957 	C$slave_wixel_track.c$572$1$1 ==.
                    0C1E   3958 	XG$handleCmdPrep$0$0 ==.
   119E 22                 3959 	ret
                           3960 ;------------------------------------------------------------
                           3961 ;Allocation info for local variables in function 'handleCmdRun'
                           3962 ;------------------------------------------------------------
                    0C1F   3963 	G$handleCmdRun$0$0 ==.
                    0C1F   3964 	C$slave_wixel_track.c$574$1$1 ==.
                           3965 ;	apps/slave_wixel_track/slave_wixel_track.c:574: void handleCmdRun()
                           3966 ;	-----------------------------------------
                           3967 ;	 function handleCmdRun
                           3968 ;	-----------------------------------------
   119F                    3969 _handleCmdRun:
                    0C1F   3970 	C$slave_wixel_track.c$576$1$1 ==.
                           3971 ;	apps/slave_wixel_track/slave_wixel_track.c:576: if (currentState != STATE_PREP)
   119F 78 00              3972 	mov	r0,#_currentState
   11A1 E2                 3973 	movx	a,@r0
                    0C22   3974 	C$slave_wixel_track.c$578$2$2 ==.
                           3975 ;	apps/slave_wixel_track/slave_wixel_track.c:578: return;
   11A2 B4 03 29           3976 	cjne	a,#0x03,00105$
                    0C25   3977 	C$slave_wixel_track.c$581$1$1 ==.
                           3978 ;	apps/slave_wixel_track/slave_wixel_track.c:581: if (waypointCount > 0)
   11A5 78 93              3979 	mov	r0,#_waypointCount
   11A7 E2                 3980 	movx	a,@r0
   11A8 60 24              3981 	jz	00105$
                    0C2A   3982 	C$slave_wixel_track.c$583$2$3 ==.
                           3983 ;	apps/slave_wixel_track/slave_wixel_track.c:583: currentState = STATE_RUN;
   11AA 78 00              3984 	mov	r0,#_currentState
   11AC 74 02              3985 	mov	a,#0x02
   11AE F2                 3986 	movx	@r0,a
                    0C2F   3987 	C$slave_wixel_track.c$584$2$3 ==.
                           3988 ;	apps/slave_wixel_track/slave_wixel_track.c:584: currentWaypointIndex = 0;
   11AF 78 95              3989 	mov	r0,#_currentWaypointIndex
   11B1 E4                 3990 	clr	a
   11B2 F2                 3991 	movx	@r0,a
                    0C33   3992 	C$slave_wixel_track.c$585$2$3 ==.
                           3993 ;	apps/slave_wixel_track/slave_wixel_track.c:585: runSubState = 0;  // Start with rotation
   11B3 78 96              3994 	mov	r0,#_runSubState
   11B5 E4                 3995 	clr	a
   11B6 F2                 3996 	movx	@r0,a
                    0C37   3997 	C$slave_wixel_track.c$586$2$3 ==.
                           3998 ;	apps/slave_wixel_track/slave_wixel_track.c:586: stateStartTime = (uint32)getMs();
   11B7 12 20 8C           3999 	lcall	_getMs
   11BA AC 82              4000 	mov	r4,dpl
   11BC AD 83              4001 	mov	r5,dph
   11BE AE F0              4002 	mov	r6,b
   11C0 FF                 4003 	mov	r7,a
   11C1 78 23              4004 	mov	r0,#_stateStartTime
   11C3 EC                 4005 	mov	a,r4
   11C4 F2                 4006 	movx	@r0,a
   11C5 08                 4007 	inc	r0
   11C6 ED                 4008 	mov	a,r5
   11C7 F2                 4009 	movx	@r0,a
   11C8 08                 4010 	inc	r0
   11C9 EE                 4011 	mov	a,r6
   11CA F2                 4012 	movx	@r0,a
   11CB 08                 4013 	inc	r0
   11CC EF                 4014 	mov	a,r7
   11CD F2                 4015 	movx	@r0,a
   11CE                    4016 00105$:
                    0C4E   4017 	C$slave_wixel_track.c$588$2$1 ==.
                    0C4E   4018 	XG$handleCmdRun$0$0 ==.
   11CE 22                 4019 	ret
                           4020 ;------------------------------------------------------------
                           4021 ;Allocation info for local variables in function 'executeManualPwm'
                           4022 ;------------------------------------------------------------
                    0C4F   4023 	G$executeManualPwm$0$0 ==.
                    0C4F   4024 	C$slave_wixel_track.c$590$2$1 ==.
                           4025 ;	apps/slave_wixel_track/slave_wixel_track.c:590: void executeManualPwm()
                           4026 ;	-----------------------------------------
                           4027 ;	 function executeManualPwm
                           4028 ;	-----------------------------------------
   11CF                    4029 _executeManualPwm:
                    0C4F   4030 	C$slave_wixel_track.c$592$1$1 ==.
                           4031 ;	apps/slave_wixel_track/slave_wixel_track.c:592: P1_2 = 0; P1_1 = 0; P1_7 = 1;
   11CF C2 92              4032 	clr	_P1_2
   11D1 C2 91              4033 	clr	_P1_1
   11D3 D2 97              4034 	setb	_P1_7
                    0C55   4035 	C$slave_wixel_track.c$593$1$1 ==.
                           4036 ;	apps/slave_wixel_track/slave_wixel_track.c:593: delayMs(100);
   11D5 90 00 64           4037 	mov	dptr,#0x0064
   11D8 12 20 B8           4038 	lcall	_delayMs
                    0C5B   4039 	C$slave_wixel_track.c$594$1$1 ==.
                           4040 ;	apps/slave_wixel_track/slave_wixel_track.c:594: P1_2 = 1; P1_1 = 1; P1_7 = 1;
   11DB D2 92              4041 	setb	_P1_2
   11DD D2 91              4042 	setb	_P1_1
   11DF D2 97              4043 	setb	_P1_7
                    0C61   4044 	C$slave_wixel_track.c$596$1$1 ==.
                           4045 ;	apps/slave_wixel_track/slave_wixel_track.c:596: pwm_left = manualPwmLeft;
   11E1 78 2B              4046 	mov	r0,#_manualPwmLeft
   11E3 E2                 4047 	movx	a,@r0
   11E4 FE                 4048 	mov	r6,a
   11E5 08                 4049 	inc	r0
   11E6 E2                 4050 	movx	a,@r0
   11E7 FF                 4051 	mov	r7,a
   11E8 78 27              4052 	mov	r0,#_pwm_left
   11EA EE                 4053 	mov	a,r6
   11EB F2                 4054 	movx	@r0,a
   11EC 08                 4055 	inc	r0
   11ED EF                 4056 	mov	a,r7
   11EE F2                 4057 	movx	@r0,a
                    0C6F   4058 	C$slave_wixel_track.c$597$1$1 ==.
                           4059 ;	apps/slave_wixel_track/slave_wixel_track.c:597: pwm_right = manualPwmRight;
   11EF 78 2D              4060 	mov	r0,#_manualPwmRight
   11F1 E2                 4061 	movx	a,@r0
   11F2 FE                 4062 	mov	r6,a
   11F3 08                 4063 	inc	r0
   11F4 E2                 4064 	movx	a,@r0
   11F5 FF                 4065 	mov	r7,a
   11F6 78 29              4066 	mov	r0,#_pwm_right
   11F8 EE                 4067 	mov	a,r6
   11F9 F2                 4068 	movx	@r0,a
   11FA 08                 4069 	inc	r0
   11FB EF                 4070 	mov	a,r7
   11FC F2                 4071 	movx	@r0,a
                    0C7D   4072 	C$slave_wixel_track.c$598$1$1 ==.
                           4073 ;	apps/slave_wixel_track/slave_wixel_track.c:598: setMotorsPWM();
   11FD 12 0D AB           4074 	lcall	_setMotorsPWM
                    0C80   4075 	C$slave_wixel_track.c$599$1$1 ==.
                           4076 ;	apps/slave_wixel_track/slave_wixel_track.c:599: delayMs(2000);
   1200 90 07 D0           4077 	mov	dptr,#0x07D0
   1203 12 20 B8           4078 	lcall	_delayMs
                    0C86   4079 	C$slave_wixel_track.c$601$1$1 ==.
                           4080 ;	apps/slave_wixel_track/slave_wixel_track.c:601: stopMotors();
   1206 12 0D E2           4081 	lcall	_stopMotors
                    0C89   4082 	C$slave_wixel_track.c$602$1$1 ==.
                           4083 ;	apps/slave_wixel_track/slave_wixel_track.c:602: manualPwmLeft = 0;
   1209 78 2B              4084 	mov	r0,#_manualPwmLeft
   120B E4                 4085 	clr	a
   120C F2                 4086 	movx	@r0,a
   120D 08                 4087 	inc	r0
   120E F2                 4088 	movx	@r0,a
                    0C8F   4089 	C$slave_wixel_track.c$603$1$1 ==.
                           4090 ;	apps/slave_wixel_track/slave_wixel_track.c:603: manualPwmRight = 0;
   120F 78 2D              4091 	mov	r0,#_manualPwmRight
   1211 E4                 4092 	clr	a
   1212 F2                 4093 	movx	@r0,a
   1213 08                 4094 	inc	r0
   1214 F2                 4095 	movx	@r0,a
                    0C95   4096 	C$slave_wixel_track.c$605$1$1 ==.
                           4097 ;	apps/slave_wixel_track/slave_wixel_track.c:605: P1_2 = 0; P1_1 = 0; P1_7 = 1;
   1215 C2 92              4098 	clr	_P1_2
   1217 C2 91              4099 	clr	_P1_1
   1219 D2 97              4100 	setb	_P1_7
                    0C9B   4101 	C$slave_wixel_track.c$606$1$1 ==.
                           4102 ;	apps/slave_wixel_track/slave_wixel_track.c:606: delayMs(100);
   121B 90 00 64           4103 	mov	dptr,#0x0064
   121E 12 20 B8           4104 	lcall	_delayMs
                    0CA1   4105 	C$slave_wixel_track.c$607$1$1 ==.
                           4106 ;	apps/slave_wixel_track/slave_wixel_track.c:607: P1_2 = 1; P1_1 = 1; P1_7 = 1;
   1221 D2 92              4107 	setb	_P1_2
   1223 D2 91              4108 	setb	_P1_1
   1225 D2 97              4109 	setb	_P1_7
                    0CA7   4110 	C$slave_wixel_track.c$609$1$1 ==.
                           4111 ;	apps/slave_wixel_track/slave_wixel_track.c:609: pwm_left = 0;
   1227 78 27              4112 	mov	r0,#_pwm_left
   1229 E4                 4113 	clr	a
   122A F2                 4114 	movx	@r0,a
   122B 08                 4115 	inc	r0
   122C F2                 4116 	movx	@r0,a
                    0CAD   4117 	C$slave_wixel_track.c$610$1$1 ==.
                           4118 ;	apps/slave_wixel_track/slave_wixel_track.c:610: pwm_right = 0;
   122D 78 29              4119 	mov	r0,#_pwm_right
   122F E4                 4120 	clr	a
   1230 F2                 4121 	movx	@r0,a
   1231 08                 4122 	inc	r0
   1232 F2                 4123 	movx	@r0,a
                    0CB3   4124 	C$slave_wixel_track.c$611$1$1 ==.
                           4125 ;	apps/slave_wixel_track/slave_wixel_track.c:611: currentState = STATE_IDLE;
   1233 78 00              4126 	mov	r0,#_currentState
   1235 E4                 4127 	clr	a
   1236 F2                 4128 	movx	@r0,a
                    0CB7   4129 	C$slave_wixel_track.c$612$1$1 ==.
                    0CB7   4130 	XG$executeManualPwm$0$0 ==.
   1237 22                 4131 	ret
                           4132 ;------------------------------------------------------------
                           4133 ;Allocation info for local variables in function 'handleCmdAux'
                           4134 ;------------------------------------------------------------
                    0CB8   4135 	G$handleCmdAux$0$0 ==.
                    0CB8   4136 	C$slave_wixel_track.c$614$1$1 ==.
                           4137 ;	apps/slave_wixel_track/slave_wixel_track.c:614: void handleCmdAux(uint8 offset)
                           4138 ;	-----------------------------------------
                           4139 ;	 function handleCmdAux
                           4140 ;	-----------------------------------------
   1238                    4141 _handleCmdAux:
   1238 AF 82              4142 	mov	r7,dpl
                    0CBA   4143 	C$slave_wixel_track.c$616$1$1 ==.
                           4144 ;	apps/slave_wixel_track/slave_wixel_track.c:616: uint8 auxSubCmd = rxPacket[offset + 7];
   123A 74 07              4145 	mov	a,#0x07
   123C 2F                 4146 	add	a,r7
   123D 24 FD              4147 	add	a,#_rxPacket
   123F F5 82              4148 	mov	dpl,a
   1241 E4                 4149 	clr	a
   1242 34 F0              4150 	addc	a,#(_rxPacket >> 8)
   1244 F5 83              4151 	mov	dph,a
   1246 E0                 4152 	movx	a,@dptr
   1247 FE                 4153 	mov	r6,a
                    0CC8   4154 	C$slave_wixel_track.c$617$1$1 ==.
                           4155 ;	apps/slave_wixel_track/slave_wixel_track.c:617: switch(auxSubCmd)
   1248 BE 1F 61           4156 	cjne	r6,#0x1F,00105$
                    0CCB   4157 	C$slave_wixel_track.c$623$2$2 ==.
                           4158 ;	apps/slave_wixel_track/slave_wixel_track.c:623: currentState = STATE_IDLE;
   124B 78 00              4159 	mov	r0,#_currentState
   124D E4                 4160 	clr	a
   124E F2                 4161 	movx	@r0,a
                    0CCF   4162 	C$slave_wixel_track.c$624$2$2 ==.
                           4163 ;	apps/slave_wixel_track/slave_wixel_track.c:624: calib_step = 0;
   124F 78 B1              4164 	mov	r0,#_calib_step
   1251 E4                 4165 	clr	a
   1252 F2                 4166 	movx	@r0,a
                    0CD3   4167 	C$slave_wixel_track.c$625$2$2 ==.
                           4168 ;	apps/slave_wixel_track/slave_wixel_track.c:625: manualPwmLeft = (int16)((rxPacket[offset + 8] << 8) | rxPacket[offset + 9]);
   1253 74 08              4169 	mov	a,#0x08
   1255 2F                 4170 	add	a,r7
   1256 24 FD              4171 	add	a,#_rxPacket
   1258 F5 82              4172 	mov	dpl,a
   125A E4                 4173 	clr	a
   125B 34 F0              4174 	addc	a,#(_rxPacket >> 8)
   125D F5 83              4175 	mov	dph,a
   125F E0                 4176 	movx	a,@dptr
   1260 FD                 4177 	mov	r5,a
   1261 7E 00              4178 	mov	r6,#0x00
   1263 74 09              4179 	mov	a,#0x09
   1265 2F                 4180 	add	a,r7
   1266 24 FD              4181 	add	a,#_rxPacket
   1268 F5 82              4182 	mov	dpl,a
   126A E4                 4183 	clr	a
   126B 34 F0              4184 	addc	a,#(_rxPacket >> 8)
   126D F5 83              4185 	mov	dph,a
   126F E0                 4186 	movx	a,@dptr
   1270 7B 00              4187 	mov	r3,#0x00
   1272 42 06              4188 	orl	ar6,a
   1274 EB                 4189 	mov	a,r3
   1275 42 05              4190 	orl	ar5,a
   1277 78 2B              4191 	mov	r0,#_manualPwmLeft
   1279 EE                 4192 	mov	a,r6
   127A F2                 4193 	movx	@r0,a
   127B 08                 4194 	inc	r0
   127C ED                 4195 	mov	a,r5
   127D F2                 4196 	movx	@r0,a
                    0CFE   4197 	C$slave_wixel_track.c$626$2$2 ==.
                           4198 ;	apps/slave_wixel_track/slave_wixel_track.c:626: manualPwmRight = (int16)((rxPacket[offset + 10] << 8) | rxPacket[offset + 11]);
   127E 74 0A              4199 	mov	a,#0x0A
   1280 2F                 4200 	add	a,r7
   1281 24 FD              4201 	add	a,#_rxPacket
   1283 F5 82              4202 	mov	dpl,a
   1285 E4                 4203 	clr	a
   1286 34 F0              4204 	addc	a,#(_rxPacket >> 8)
   1288 F5 83              4205 	mov	dph,a
   128A E0                 4206 	movx	a,@dptr
   128B FD                 4207 	mov	r5,a
   128C 7E 00              4208 	mov	r6,#0x00
   128E 74 0B              4209 	mov	a,#0x0B
   1290 2F                 4210 	add	a,r7
   1291 24 FD              4211 	add	a,#_rxPacket
   1293 F5 82              4212 	mov	dpl,a
   1295 E4                 4213 	clr	a
   1296 34 F0              4214 	addc	a,#(_rxPacket >> 8)
   1298 F5 83              4215 	mov	dph,a
   129A E0                 4216 	movx	a,@dptr
   129B 7C 00              4217 	mov	r4,#0x00
   129D 42 06              4218 	orl	ar6,a
   129F EC                 4219 	mov	a,r4
   12A0 42 05              4220 	orl	ar5,a
   12A2 78 2D              4221 	mov	r0,#_manualPwmRight
   12A4 EE                 4222 	mov	a,r6
   12A5 F2                 4223 	movx	@r0,a
   12A6 08                 4224 	inc	r0
   12A7 ED                 4225 	mov	a,r5
   12A8 F2                 4226 	movx	@r0,a
                    0D29   4227 	C$slave_wixel_track.c$627$2$2 ==.
                           4228 ;	apps/slave_wixel_track/slave_wixel_track.c:627: executeManualPwm();
   12A9 12 11 CF           4229 	lcall	_executeManualPwm
                    0D2C   4230 	C$slave_wixel_track.c$632$1$1 ==.
                           4231 ;	apps/slave_wixel_track/slave_wixel_track.c:632: }
   12AC                    4232 00105$:
                    0D2C   4233 	C$slave_wixel_track.c$633$1$1 ==.
                    0D2C   4234 	XG$handleCmdAux$0$0 ==.
   12AC 22                 4235 	ret
                           4236 ;------------------------------------------------------------
                           4237 ;Allocation info for local variables in function 'handleCmdCalibrate'
                           4238 ;------------------------------------------------------------
                    0D2D   4239 	G$handleCmdCalibrate$0$0 ==.
                    0D2D   4240 	C$slave_wixel_track.c$635$1$1 ==.
                           4241 ;	apps/slave_wixel_track/slave_wixel_track.c:635: void handleCmdCalibrate()
                           4242 ;	-----------------------------------------
                           4243 ;	 function handleCmdCalibrate
                           4244 ;	-----------------------------------------
   12AD                    4245 _handleCmdCalibrate:
                    0D2D   4246 	C$slave_wixel_track.c$637$1$1 ==.
                           4247 ;	apps/slave_wixel_track/slave_wixel_track.c:637: currentState = STATE_CALIBRATE_VALIDATE;
   12AD 78 00              4248 	mov	r0,#_currentState
   12AF 74 10              4249 	mov	a,#0x10
   12B1 F2                 4250 	movx	@r0,a
                    0D32   4251 	C$slave_wixel_track.c$638$1$1 ==.
                           4252 ;	apps/slave_wixel_track/slave_wixel_track.c:638: updateRgbLeds();
   12B2 12 0E 7A           4253 	lcall	_updateRgbLeds
                    0D35   4254 	C$slave_wixel_track.c$640$1$1 ==.
                           4255 ;	apps/slave_wixel_track/slave_wixel_track.c:640: if (calib_step == 0)
   12B5 78 B1              4256 	mov	r0,#_calib_step
   12B7 E2                 4257 	movx	a,@r0
   12B8 70 6D              4258 	jnz	00107$
                    0D3A   4259 	C$slave_wixel_track.c$642$2$2 ==.
                           4260 ;	apps/slave_wixel_track/slave_wixel_track.c:642: orientationOffset = 0;
   12BA 78 AB              4261 	mov	r0,#_orientationOffset
   12BC E4                 4262 	clr	a
   12BD F2                 4263 	movx	@r0,a
   12BE 08                 4264 	inc	r0
   12BF F2                 4265 	movx	@r0,a
                    0D40   4266 	C$slave_wixel_track.c$643$2$2 ==.
                           4267 ;	apps/slave_wixel_track/slave_wixel_track.c:643: stopMotors();
   12C0 12 0D E2           4268 	lcall	_stopMotors
                    0D43   4269 	C$slave_wixel_track.c$645$2$2 ==.
                           4270 ;	apps/slave_wixel_track/slave_wixel_track.c:645: calData.xa = posX; calData.ya = posY; 
   12C3 78 99              4271 	mov	r0,#_calData
   12C5 79 0F              4272 	mov	r1,#_posX
   12C7 E3                 4273 	movx	a,@r1
   12C8 F2                 4274 	movx	@r0,a
   12C9 08                 4275 	inc	r0
   12CA 09                 4276 	inc	r1
   12CB E3                 4277 	movx	a,@r1
   12CC F2                 4278 	movx	@r0,a
   12CD 78 9B              4279 	mov	r0,#(_calData + 0x0002)
   12CF 79 11              4280 	mov	r1,#_posY
   12D1 E3                 4281 	movx	a,@r1
   12D2 F2                 4282 	movx	@r0,a
   12D3 08                 4283 	inc	r0
   12D4 09                 4284 	inc	r1
   12D5 E3                 4285 	movx	a,@r1
   12D6 F2                 4286 	movx	@r0,a
                    0D57   4287 	C$slave_wixel_track.c$646$2$2 ==.
                           4288 ;	apps/slave_wixel_track/slave_wixel_track.c:646: calData.thetaa = posTheta - orientationOffset;
   12D7 78 13              4289 	mov	r0,#_posTheta
   12D9 79 AB              4290 	mov	r1,#_orientationOffset
   12DB E3                 4291 	movx	a,@r1
   12DC F5 F0              4292 	mov	b,a
   12DE C3                 4293 	clr	c
   12DF E2                 4294 	movx	a,@r0
   12E0 95 F0              4295 	subb	a,b
   12E2 FE                 4296 	mov	r6,a
   12E3 09                 4297 	inc	r1
   12E4 E3                 4298 	movx	a,@r1
   12E5 F5 F0              4299 	mov	b,a
   12E7 08                 4300 	inc	r0
   12E8 E2                 4301 	movx	a,@r0
   12E9 95 F0              4302 	subb	a,b
   12EB FF                 4303 	mov	r7,a
   12EC 78 9D              4304 	mov	r0,#(_calData + 0x0004)
   12EE EE                 4305 	mov	a,r6
   12EF F2                 4306 	movx	@r0,a
   12F0 08                 4307 	inc	r0
   12F1 EF                 4308 	mov	a,r7
   12F2 F2                 4309 	movx	@r0,a
                    0D73   4310 	C$slave_wixel_track.c$648$2$2 ==.
                           4311 ;	apps/slave_wixel_track/slave_wixel_track.c:648: pwm_left = 70;
   12F3 78 27              4312 	mov	r0,#_pwm_left
   12F5 74 46              4313 	mov	a,#0x46
   12F7 F2                 4314 	movx	@r0,a
   12F8 08                 4315 	inc	r0
   12F9 E4                 4316 	clr	a
   12FA F2                 4317 	movx	@r0,a
                    0D7B   4318 	C$slave_wixel_track.c$649$2$2 ==.
                           4319 ;	apps/slave_wixel_track/slave_wixel_track.c:649: pwm_right = 70;
   12FB 78 29              4320 	mov	r0,#_pwm_right
   12FD 74 46              4321 	mov	a,#0x46
   12FF F2                 4322 	movx	@r0,a
   1300 08                 4323 	inc	r0
   1301 E4                 4324 	clr	a
   1302 F2                 4325 	movx	@r0,a
                    0D83   4326 	C$slave_wixel_track.c$650$2$2 ==.
                           4327 ;	apps/slave_wixel_track/slave_wixel_track.c:650: setMotorsPWM();
   1303 12 0D AB           4328 	lcall	_setMotorsPWM
                    0D86   4329 	C$slave_wixel_track.c$651$2$2 ==.
                           4330 ;	apps/slave_wixel_track/slave_wixel_track.c:651: delayMs(3000);
   1306 90 0B B8           4331 	mov	dptr,#0x0BB8
   1309 12 20 B8           4332 	lcall	_delayMs
                    0D8C   4333 	C$slave_wixel_track.c$652$2$2 ==.
                           4334 ;	apps/slave_wixel_track/slave_wixel_track.c:652: stopMotors();
   130C 12 0D E2           4335 	lcall	_stopMotors
                    0D8F   4336 	C$slave_wixel_track.c$653$2$2 ==.
                           4337 ;	apps/slave_wixel_track/slave_wixel_track.c:653: pwm_left = 0;
   130F 78 27              4338 	mov	r0,#_pwm_left
   1311 E4                 4339 	clr	a
   1312 F2                 4340 	movx	@r0,a
   1313 08                 4341 	inc	r0
   1314 F2                 4342 	movx	@r0,a
                    0D95   4343 	C$slave_wixel_track.c$654$2$2 ==.
                           4344 ;	apps/slave_wixel_track/slave_wixel_track.c:654: pwm_right = 0;
   1315 78 29              4345 	mov	r0,#_pwm_right
   1317 E4                 4346 	clr	a
   1318 F2                 4347 	movx	@r0,a
   1319 08                 4348 	inc	r0
   131A F2                 4349 	movx	@r0,a
                    0D9B   4350 	C$slave_wixel_track.c$656$2$2 ==.
                           4351 ;	apps/slave_wixel_track/slave_wixel_track.c:656: calib_step = 1;
   131B 78 B1              4352 	mov	r0,#_calib_step
   131D 74 01              4353 	mov	a,#0x01
   131F F2                 4354 	movx	@r0,a
                    0DA0   4355 	C$slave_wixel_track.c$657$2$2 ==.
                           4356 ;	apps/slave_wixel_track/slave_wixel_track.c:657: currentState = STATE_IDLE;
   1320 78 00              4357 	mov	r0,#_currentState
   1322 E4                 4358 	clr	a
   1323 F2                 4359 	movx	@r0,a
   1324 02 13 D8           4360 	ljmp	00109$
   1327                    4361 00107$:
                    0DA7   4362 	C$slave_wixel_track.c$659$1$1 ==.
                           4363 ;	apps/slave_wixel_track/slave_wixel_track.c:659: else if (calib_step == 1)
   1327 78 B1              4364 	mov	r0,#_calib_step
   1329 E2                 4365 	movx	a,@r0
   132A B4 01 55           4366 	cjne	a,#0x01,00104$
                    0DAD   4367 	C$slave_wixel_track.c$661$2$3 ==.
                           4368 ;	apps/slave_wixel_track/slave_wixel_track.c:661: stopMotors();
   132D 12 0D E2           4369 	lcall	_stopMotors
                    0DB0   4370 	C$slave_wixel_track.c$663$2$3 ==.
                           4371 ;	apps/slave_wixel_track/slave_wixel_track.c:663: calData.xb = posX; calData.yb = posY; calData.thetab = posTheta;
   1330 78 9F              4372 	mov	r0,#(_calData + 0x0006)
   1332 79 0F              4373 	mov	r1,#_posX
   1334 E3                 4374 	movx	a,@r1
   1335 F2                 4375 	movx	@r0,a
   1336 08                 4376 	inc	r0
   1337 09                 4377 	inc	r1
   1338 E3                 4378 	movx	a,@r1
   1339 F2                 4379 	movx	@r0,a
   133A 78 A1              4380 	mov	r0,#(_calData + 0x0008)
   133C 79 11              4381 	mov	r1,#_posY
   133E E3                 4382 	movx	a,@r1
   133F F2                 4383 	movx	@r0,a
   1340 08                 4384 	inc	r0
   1341 09                 4385 	inc	r1
   1342 E3                 4386 	movx	a,@r1
   1343 F2                 4387 	movx	@r0,a
   1344 78 A3              4388 	mov	r0,#(_calData + 0x000a)
   1346 79 13              4389 	mov	r1,#_posTheta
   1348 E3                 4390 	movx	a,@r1
   1349 F2                 4391 	movx	@r0,a
   134A 08                 4392 	inc	r0
   134B 09                 4393 	inc	r1
   134C E3                 4394 	movx	a,@r1
   134D F2                 4395 	movx	@r0,a
                    0DCE   4396 	C$slave_wixel_track.c$665$2$3 ==.
                           4397 ;	apps/slave_wixel_track/slave_wixel_track.c:665: pwm_left = -60;
   134E 78 27              4398 	mov	r0,#_pwm_left
   1350 74 C4              4399 	mov	a,#0xC4
   1352 F2                 4400 	movx	@r0,a
   1353 08                 4401 	inc	r0
   1354 74 FF              4402 	mov	a,#0xFF
   1356 F2                 4403 	movx	@r0,a
                    0DD7   4404 	C$slave_wixel_track.c$666$2$3 ==.
                           4405 ;	apps/slave_wixel_track/slave_wixel_track.c:666: pwm_right = 60;
   1357 78 29              4406 	mov	r0,#_pwm_right
   1359 74 3C              4407 	mov	a,#0x3C
   135B F2                 4408 	movx	@r0,a
   135C 08                 4409 	inc	r0
   135D E4                 4410 	clr	a
   135E F2                 4411 	movx	@r0,a
                    0DDF   4412 	C$slave_wixel_track.c$667$2$3 ==.
                           4413 ;	apps/slave_wixel_track/slave_wixel_track.c:667: setMotorsPWM();
   135F 12 0D AB           4414 	lcall	_setMotorsPWM
                    0DE2   4415 	C$slave_wixel_track.c$668$2$3 ==.
                           4416 ;	apps/slave_wixel_track/slave_wixel_track.c:668: delayMs(2000);
   1362 90 07 D0           4417 	mov	dptr,#0x07D0
   1365 12 20 B8           4418 	lcall	_delayMs
                    0DE8   4419 	C$slave_wixel_track.c$669$2$3 ==.
                           4420 ;	apps/slave_wixel_track/slave_wixel_track.c:669: stopMotors();
   1368 12 0D E2           4421 	lcall	_stopMotors
                    0DEB   4422 	C$slave_wixel_track.c$670$2$3 ==.
                           4423 ;	apps/slave_wixel_track/slave_wixel_track.c:670: pwm_left = 0;
   136B 78 27              4424 	mov	r0,#_pwm_left
   136D E4                 4425 	clr	a
   136E F2                 4426 	movx	@r0,a
   136F 08                 4427 	inc	r0
   1370 F2                 4428 	movx	@r0,a
                    0DF1   4429 	C$slave_wixel_track.c$671$2$3 ==.
                           4430 ;	apps/slave_wixel_track/slave_wixel_track.c:671: pwm_right = 0;
   1371 78 29              4431 	mov	r0,#_pwm_right
   1373 E4                 4432 	clr	a
   1374 F2                 4433 	movx	@r0,a
   1375 08                 4434 	inc	r0
   1376 F2                 4435 	movx	@r0,a
                    0DF7   4436 	C$slave_wixel_track.c$673$2$3 ==.
                           4437 ;	apps/slave_wixel_track/slave_wixel_track.c:673: calib_step = 2;
   1377 78 B1              4438 	mov	r0,#_calib_step
   1379 74 02              4439 	mov	a,#0x02
   137B F2                 4440 	movx	@r0,a
                    0DFC   4441 	C$slave_wixel_track.c$674$2$3 ==.
                           4442 ;	apps/slave_wixel_track/slave_wixel_track.c:674: currentState = STATE_IDLE;
   137C 78 00              4443 	mov	r0,#_currentState
   137E E4                 4444 	clr	a
   137F F2                 4445 	movx	@r0,a
   1380 80 56              4446 	sjmp	00109$
   1382                    4447 00104$:
                    0E02   4448 	C$slave_wixel_track.c$676$1$1 ==.
                           4449 ;	apps/slave_wixel_track/slave_wixel_track.c:676: else if (calib_step == 2)
   1382 78 B1              4450 	mov	r0,#_calib_step
   1384 E2                 4451 	movx	a,@r0
   1385 B4 02 50           4452 	cjne	a,#0x02,00109$
                    0E08   4453 	C$slave_wixel_track.c$678$2$4 ==.
                           4454 ;	apps/slave_wixel_track/slave_wixel_track.c:678: stopMotors();
   1388 12 0D E2           4455 	lcall	_stopMotors
                    0E0B   4456 	C$slave_wixel_track.c$679$2$4 ==.
                           4457 ;	apps/slave_wixel_track/slave_wixel_track.c:679: pwm_left = 0;
   138B 78 27              4458 	mov	r0,#_pwm_left
   138D E4                 4459 	clr	a
   138E F2                 4460 	movx	@r0,a
   138F 08                 4461 	inc	r0
   1390 F2                 4462 	movx	@r0,a
                    0E11   4463 	C$slave_wixel_track.c$680$2$4 ==.
                           4464 ;	apps/slave_wixel_track/slave_wixel_track.c:680: pwm_right = 0;
   1391 78 29              4465 	mov	r0,#_pwm_right
   1393 E4                 4466 	clr	a
   1394 F2                 4467 	movx	@r0,a
   1395 08                 4468 	inc	r0
   1396 F2                 4469 	movx	@r0,a
                    0E17   4470 	C$slave_wixel_track.c$682$2$4 ==.
                           4471 ;	apps/slave_wixel_track/slave_wixel_track.c:682: calData.xc = posX; calData.yc = posY; calData.thetac = posTheta;
   1397 78 A5              4472 	mov	r0,#(_calData + 0x000c)
   1399 79 0F              4473 	mov	r1,#_posX
   139B E3                 4474 	movx	a,@r1
   139C F2                 4475 	movx	@r0,a
   139D 08                 4476 	inc	r0
   139E 09                 4477 	inc	r1
   139F E3                 4478 	movx	a,@r1
   13A0 F2                 4479 	movx	@r0,a
   13A1 78 A7              4480 	mov	r0,#(_calData + 0x000e)
   13A3 79 11              4481 	mov	r1,#_posY
   13A5 E3                 4482 	movx	a,@r1
   13A6 F2                 4483 	movx	@r0,a
   13A7 08                 4484 	inc	r0
   13A8 09                 4485 	inc	r1
   13A9 E3                 4486 	movx	a,@r1
   13AA F2                 4487 	movx	@r0,a
   13AB 78 A9              4488 	mov	r0,#(_calData + 0x0010)
   13AD 79 13              4489 	mov	r1,#_posTheta
   13AF E3                 4490 	movx	a,@r1
   13B0 F2                 4491 	movx	@r0,a
   13B1 08                 4492 	inc	r0
   13B2 09                 4493 	inc	r1
   13B3 E3                 4494 	movx	a,@r1
   13B4 F2                 4495 	movx	@r0,a
                    0E35   4496 	C$slave_wixel_track.c$684$2$4 ==.
                           4497 ;	apps/slave_wixel_track/slave_wixel_track.c:684: calculateAndApplyOffset();
   13B5 12 0A EC           4498 	lcall	_calculateAndApplyOffset
                    0E38   4499 	C$slave_wixel_track.c$686$2$4 ==.
                           4500 ;	apps/slave_wixel_track/slave_wixel_track.c:686: currentState = STATE_CALIBRATE_VALIDATE;
   13B8 78 00              4501 	mov	r0,#_currentState
   13BA 74 10              4502 	mov	a,#0x10
   13BC F2                 4503 	movx	@r0,a
                    0E3D   4504 	C$slave_wixel_track.c$687$2$4 ==.
                           4505 ;	apps/slave_wixel_track/slave_wixel_track.c:687: stateStartTime = (uint32)getMs();
   13BD 12 20 8C           4506 	lcall	_getMs
   13C0 AC 82              4507 	mov	r4,dpl
   13C2 AD 83              4508 	mov	r5,dph
   13C4 AE F0              4509 	mov	r6,b
   13C6 FF                 4510 	mov	r7,a
   13C7 78 23              4511 	mov	r0,#_stateStartTime
   13C9 EC                 4512 	mov	a,r4
   13CA F2                 4513 	movx	@r0,a
   13CB 08                 4514 	inc	r0
   13CC ED                 4515 	mov	a,r5
   13CD F2                 4516 	movx	@r0,a
   13CE 08                 4517 	inc	r0
   13CF EE                 4518 	mov	a,r6
   13D0 F2                 4519 	movx	@r0,a
   13D1 08                 4520 	inc	r0
   13D2 EF                 4521 	mov	a,r7
   13D3 F2                 4522 	movx	@r0,a
                    0E54   4523 	C$slave_wixel_track.c$689$2$4 ==.
                           4524 ;	apps/slave_wixel_track/slave_wixel_track.c:689: calib_step = 0;
   13D4 78 B1              4525 	mov	r0,#_calib_step
   13D6 E4                 4526 	clr	a
   13D7 F2                 4527 	movx	@r0,a
   13D8                    4528 00109$:
                    0E58   4529 	C$slave_wixel_track.c$691$2$1 ==.
                    0E58   4530 	XG$handleCmdCalibrate$0$0 ==.
   13D8 22                 4531 	ret
                           4532 ;------------------------------------------------------------
                           4533 ;Allocation info for local variables in function 'receiveAndProcessPackets'
                           4534 ;------------------------------------------------------------
                    0E59   4535 	G$receiveAndProcessPackets$0$0 ==.
                    0E59   4536 	C$slave_wixel_track.c$693$2$1 ==.
                           4537 ;	apps/slave_wixel_track/slave_wixel_track.c:693: void receiveAndProcessPackets()
                           4538 ;	-----------------------------------------
                           4539 ;	 function receiveAndProcessPackets
                           4540 ;	-----------------------------------------
   13D9                    4541 _receiveAndProcessPackets:
                    0E59   4542 	C$slave_wixel_track.c$699$1$1 ==.
                           4543 ;	apps/slave_wixel_track/slave_wixel_track.c:699: if (RFIF & (1<<4))
   13D9 E5 E9              4544 	mov	a,_RFIF
   13DB 20 E4 03           4545 	jb	acc.4,00140$
   13DE 02 14 95           4546 	ljmp	00128$
   13E1                    4547 00140$:
                    0E61   4548 	C$slave_wixel_track.c$701$2$2 ==.
                           4549 ;	apps/slave_wixel_track/slave_wixel_track.c:701: if (radioCrcPassed())
   13E1 12 21 92           4550 	lcall	_radioCrcPassed
   13E4 40 03              4551 	jc	00141$
   13E6 02 14 88           4552 	ljmp	00125$
   13E9                    4553 00141$:
                    0E69   4554 	C$slave_wixel_track.c$703$3$3 ==.
                           4555 ;	apps/slave_wixel_track/slave_wixel_track.c:703: lastPacketTime = (uint16)getMs();
   13E9 12 20 8C           4556 	lcall	_getMs
   13EC AC 82              4557 	mov	r4,dpl
   13EE AD 83              4558 	mov	r5,dph
   13F0 AE F0              4559 	mov	r6,b
   13F2 FF                 4560 	mov	r7,a
   13F3 78 03              4561 	mov	r0,#_lastPacketTime
   13F5 EC                 4562 	mov	a,r4
   13F6 F2                 4563 	movx	@r0,a
   13F7 08                 4564 	inc	r0
   13F8 ED                 4565 	mov	a,r5
   13F9 F2                 4566 	movx	@r0,a
                    0E7A   4567 	C$slave_wixel_track.c$705$3$3 ==.
                           4568 ;	apps/slave_wixel_track/slave_wixel_track.c:705: if (lastPacketTime != lastPacketTimeCheck)
   13FA 78 01              4569 	mov	r0,#_lastPacketTimeCheck
   13FC E2                 4570 	movx	a,@r0
   13FD B5 04 07           4571 	cjne	a,ar4,00142$
   1400 08                 4572 	inc	r0
   1401 E2                 4573 	movx	a,@r0
   1402 B5 05 02           4574 	cjne	a,ar5,00142$
   1405 80 13              4575 	sjmp	00112$
   1407                    4576 00142$:
                    0E87   4577 	C$slave_wixel_track.c$707$4$4 ==.
                           4578 ;	apps/slave_wixel_track/slave_wixel_track.c:707: rxPulseStart = 1;
   1407 78 0B              4579 	mov	r0,#_rxPulseStart
   1409 74 01              4580 	mov	a,#0x01
   140B F2                 4581 	movx	@r0,a
   140C 08                 4582 	inc	r0
   140D E4                 4583 	clr	a
   140E F2                 4584 	movx	@r0,a
   140F 08                 4585 	inc	r0
   1410 F2                 4586 	movx	@r0,a
   1411 08                 4587 	inc	r0
   1412 F2                 4588 	movx	@r0,a
                    0E93   4589 	C$slave_wixel_track.c$708$4$4 ==.
                           4590 ;	apps/slave_wixel_track/slave_wixel_track.c:708: lastPacketTimeCheck = lastPacketTime;
   1413 78 01              4591 	mov	r0,#_lastPacketTimeCheck
   1415 EC                 4592 	mov	a,r4
   1416 F2                 4593 	movx	@r0,a
   1417 08                 4594 	inc	r0
   1418 ED                 4595 	mov	a,r5
   1419 F2                 4596 	movx	@r0,a
                    0E9A   4597 	C$slave_wixel_track.c$711$3$3 ==.
                           4598 ;	apps/slave_wixel_track/slave_wixel_track.c:711: if (THIS_SLAVE_ADDRESS == 0x01)
   141A                    4599 00112$:
                    0E9A   4600 	C$slave_wixel_track.c$727$3$3 ==.
                           4601 ;	apps/slave_wixel_track/slave_wixel_track.c:727: slaveAddress = rxPacket[packetOffset + 0];
   141A 90 F0 FE           4602 	mov	dptr,#(_rxPacket + 0x0001)
   141D E0                 4603 	movx	a,@dptr
   141E FF                 4604 	mov	r7,a
                    0E9F   4605 	C$slave_wixel_track.c$728$3$3 ==.
                           4606 ;	apps/slave_wixel_track/slave_wixel_track.c:728: cmd = rxPacket[packetOffset + 6];
   141F 90 F1 04           4607 	mov	dptr,#(_rxPacket + 0x0007)
   1422 E0                 4608 	movx	a,@dptr
   1423 FE                 4609 	mov	r6,a
                    0EA4   4610 	C$slave_wixel_track.c$730$3$3 ==.
                           4611 ;	apps/slave_wixel_track/slave_wixel_track.c:730: if (slaveAddress != THIS_SLAVE_ADDRESS)
   1424 BF 01 02           4612 	cjne	r7,#0x01,00143$
   1427 80 0F              4613 	sjmp	00116$
   1429                    4614 00143$:
                    0EA9   4615 	C$slave_wixel_track.c$732$4$6 ==.
                           4616 ;	apps/slave_wixel_track/slave_wixel_track.c:732: RFIF &= ~(1<<4);
   1429 AF E9              4617 	mov	r7,_RFIF
   142B 53 07 EF           4618 	anl	ar7,#0xEF
   142E 8F E9              4619 	mov	_RFIF,r7
                    0EB0   4620 	C$slave_wixel_track.c$733$4$6 ==.
                           4621 ;	apps/slave_wixel_track/slave_wixel_track.c:733: DMAARM |= (1<<DMA_CHANNEL_RADIO);
   1430 43 D6 02           4622 	orl	_DMAARM,#0x02
                    0EB3   4623 	C$slave_wixel_track.c$734$4$6 ==.
                           4624 ;	apps/slave_wixel_track/slave_wixel_track.c:734: RFST = 2;
   1433 75 E1 02           4625 	mov	_RFST,#0x02
                    0EB6   4626 	C$slave_wixel_track.c$735$4$6 ==.
                           4627 ;	apps/slave_wixel_track/slave_wixel_track.c:735: return;
   1436 80 5D              4628 	sjmp	00128$
   1438                    4629 00116$:
                    0EB8   4630 	C$slave_wixel_track.c$738$3$3 ==.
                           4631 ;	apps/slave_wixel_track/slave_wixel_track.c:738: extractPositionData(packetOffset);
   1438 75 82 01           4632 	mov	dpl,#0x01
   143B C0 06              4633 	push	ar6
   143D 12 0E C0           4634 	lcall	_extractPositionData
                    0EC0   4635 	C$slave_wixel_track.c$739$3$3 ==.
                           4636 ;	apps/slave_wixel_track/slave_wixel_track.c:739: filterPosition();
   1440 12 0B 76           4637 	lcall	_filterPosition
   1443 D0 06              4638 	pop	ar6
                    0EC5   4639 	C$slave_wixel_track.c$741$3$3 ==.
                           4640 ;	apps/slave_wixel_track/slave_wixel_track.c:741: switch(cmd)
   1445 BE 10 02           4641 	cjne	r6,#0x10,00144$
   1448 80 19              4642 	sjmp	00117$
   144A                    4643 00144$:
   144A BE 11 02           4644 	cjne	r6,#0x11,00145$
   144D 80 19              4645 	sjmp	00118$
   144F                    4646 00145$:
   144F BE 12 02           4647 	cjne	r6,#0x12,00146$
   1452 80 1C              4648 	sjmp	00119$
   1454                    4649 00146$:
   1454 BE 13 02           4650 	cjne	r6,#0x13,00147$
   1457 80 1F              4651 	sjmp	00120$
   1459                    4652 00147$:
   1459 BE 14 02           4653 	cjne	r6,#0x14,00148$
   145C 80 24              4654 	sjmp	00122$
   145E                    4655 00148$:
                    0EDE   4656 	C$slave_wixel_track.c$743$4$7 ==.
                           4657 ;	apps/slave_wixel_track/slave_wixel_track.c:743: case CMD_STOP:
   145E BE 15 27           4658 	cjne	r6,#0x15,00125$
   1461 80 1A              4659 	sjmp	00121$
   1463                    4660 00117$:
                    0EE3   4661 	C$slave_wixel_track.c$744$4$7 ==.
                           4662 ;	apps/slave_wixel_track/slave_wixel_track.c:744: handleCmdStop();
   1463 12 0F A2           4663 	lcall	_handleCmdStop
                    0EE6   4664 	C$slave_wixel_track.c$745$4$7 ==.
                           4665 ;	apps/slave_wixel_track/slave_wixel_track.c:745: break;
                    0EE6   4666 	C$slave_wixel_track.c$746$4$7 ==.
                           4667 ;	apps/slave_wixel_track/slave_wixel_track.c:746: case CMD_GO_TO:
   1466 80 20              4668 	sjmp	00125$
   1468                    4669 00118$:
                    0EE8   4670 	C$slave_wixel_track.c$747$4$7 ==.
                           4671 ;	apps/slave_wixel_track/slave_wixel_track.c:747: handleCmdGoTo(packetOffset);
   1468 75 82 01           4672 	mov	dpl,#0x01
   146B 12 0F CA           4673 	lcall	_handleCmdGoTo
                    0EEE   4674 	C$slave_wixel_track.c$748$4$7 ==.
                           4675 ;	apps/slave_wixel_track/slave_wixel_track.c:748: break;
                    0EEE   4676 	C$slave_wixel_track.c$749$4$7 ==.
                           4677 ;	apps/slave_wixel_track/slave_wixel_track.c:749: case CMD_PREP:
   146E 80 18              4678 	sjmp	00125$
   1470                    4679 00119$:
                    0EF0   4680 	C$slave_wixel_track.c$750$4$7 ==.
                           4681 ;	apps/slave_wixel_track/slave_wixel_track.c:750: handleCmdPrep(packetOffset);
   1470 75 82 01           4682 	mov	dpl,#0x01
   1473 12 10 EA           4683 	lcall	_handleCmdPrep
                    0EF6   4684 	C$slave_wixel_track.c$751$4$7 ==.
                           4685 ;	apps/slave_wixel_track/slave_wixel_track.c:751: break;
                    0EF6   4686 	C$slave_wixel_track.c$752$4$7 ==.
                           4687 ;	apps/slave_wixel_track/slave_wixel_track.c:752: case CMD_RUN:
   1476 80 10              4688 	sjmp	00125$
   1478                    4689 00120$:
                    0EF8   4690 	C$slave_wixel_track.c$753$4$7 ==.
                           4691 ;	apps/slave_wixel_track/slave_wixel_track.c:753: handleCmdRun();
   1478 12 11 9F           4692 	lcall	_handleCmdRun
                    0EFB   4693 	C$slave_wixel_track.c$754$4$7 ==.
                           4694 ;	apps/slave_wixel_track/slave_wixel_track.c:754: break;
                    0EFB   4695 	C$slave_wixel_track.c$755$4$7 ==.
                           4696 ;	apps/slave_wixel_track/slave_wixel_track.c:755: case CMD_CALIBRATE:
   147B 80 0B              4697 	sjmp	00125$
   147D                    4698 00121$:
                    0EFD   4699 	C$slave_wixel_track.c$756$4$7 ==.
                           4700 ;	apps/slave_wixel_track/slave_wixel_track.c:756: handleCmdCalibrate();
   147D 12 12 AD           4701 	lcall	_handleCmdCalibrate
                    0F00   4702 	C$slave_wixel_track.c$757$4$7 ==.
                           4703 ;	apps/slave_wixel_track/slave_wixel_track.c:757: break;
                    0F00   4704 	C$slave_wixel_track.c$758$4$7 ==.
                           4705 ;	apps/slave_wixel_track/slave_wixel_track.c:758: case CMD_AUX:
   1480 80 06              4706 	sjmp	00125$
   1482                    4707 00122$:
                    0F02   4708 	C$slave_wixel_track.c$759$4$7 ==.
                           4709 ;	apps/slave_wixel_track/slave_wixel_track.c:759: handleCmdAux(packetOffset);
   1482 75 82 01           4710 	mov	dpl,#0x01
   1485 12 12 38           4711 	lcall	_handleCmdAux
                    0F08   4712 	C$slave_wixel_track.c$761$2$2 ==.
                           4713 ;	apps/slave_wixel_track/slave_wixel_track.c:761: }
   1488                    4714 00125$:
                    0F08   4715 	C$slave_wixel_track.c$764$2$2 ==.
                           4716 ;	apps/slave_wixel_track/slave_wixel_track.c:764: RFIF &= ~(1<<4);
   1488 AF E9              4717 	mov	r7,_RFIF
   148A 53 07 EF           4718 	anl	ar7,#0xEF
   148D 8F E9              4719 	mov	_RFIF,r7
                    0F0F   4720 	C$slave_wixel_track.c$765$2$2 ==.
                           4721 ;	apps/slave_wixel_track/slave_wixel_track.c:765: DMAARM |= (1<<DMA_CHANNEL_RADIO);
   148F 43 D6 02           4722 	orl	_DMAARM,#0x02
                    0F12   4723 	C$slave_wixel_track.c$766$2$2 ==.
                           4724 ;	apps/slave_wixel_track/slave_wixel_track.c:766: RFST = 2;
   1492 75 E1 02           4725 	mov	_RFST,#0x02
   1495                    4726 00128$:
                    0F15   4727 	C$slave_wixel_track.c$768$2$1 ==.
                    0F15   4728 	XG$receiveAndProcessPackets$0$0 ==.
   1495 22                 4729 	ret
                           4730 ;------------------------------------------------------------
                           4731 ;Allocation info for local variables in function 'handlePacketTimeout'
                           4732 ;------------------------------------------------------------
                           4733 ;sloc0                     Allocated with name '_handlePacketTimeout_sloc0_1_0'
                           4734 ;------------------------------------------------------------
                    0F16   4735 	G$handlePacketTimeout$0$0 ==.
                    0F16   4736 	C$slave_wixel_track.c$770$2$1 ==.
                           4737 ;	apps/slave_wixel_track/slave_wixel_track.c:770: void handlePacketTimeout()
                           4738 ;	-----------------------------------------
                           4739 ;	 function handlePacketTimeout
                           4740 ;	-----------------------------------------
   1496                    4741 _handlePacketTimeout:
                    0F16   4742 	C$slave_wixel_track.c$772$1$1 ==.
                           4743 ;	apps/slave_wixel_track/slave_wixel_track.c:772: if ((uint16)(getMs() - lastPacketTime) > CONNECTION_TIMEOUT)
   1496 12 20 8C           4744 	lcall	_getMs
   1499 85 82 16           4745 	mov	_handlePacketTimeout_sloc0_1_0,dpl
   149C 85 83 17           4746 	mov	(_handlePacketTimeout_sloc0_1_0 + 1),dph
   149F 85 F0 18           4747 	mov	(_handlePacketTimeout_sloc0_1_0 + 2),b
   14A2 F5 19              4748 	mov	(_handlePacketTimeout_sloc0_1_0 + 3),a
   14A4 78 03              4749 	mov	r0,#_lastPacketTime
   14A6 E2                 4750 	movx	a,@r0
   14A7 FA                 4751 	mov	r2,a
   14A8 08                 4752 	inc	r0
   14A9 E2                 4753 	movx	a,@r0
   14AA FB                 4754 	mov	r3,a
   14AB E4                 4755 	clr	a
   14AC FE                 4756 	mov	r6,a
   14AD FF                 4757 	mov	r7,a
   14AE E5 16              4758 	mov	a,_handlePacketTimeout_sloc0_1_0
   14B0 C3                 4759 	clr	c
   14B1 9A                 4760 	subb	a,r2
   14B2 FA                 4761 	mov	r2,a
   14B3 E5 17              4762 	mov	a,(_handlePacketTimeout_sloc0_1_0 + 1)
   14B5 9B                 4763 	subb	a,r3
   14B6 FB                 4764 	mov	r3,a
   14B7 E5 18              4765 	mov	a,(_handlePacketTimeout_sloc0_1_0 + 2)
   14B9 9E                 4766 	subb	a,r6
   14BA FE                 4767 	mov	r6,a
   14BB E5 19              4768 	mov	a,(_handlePacketTimeout_sloc0_1_0 + 3)
   14BD 9F                 4769 	subb	a,r7
   14BE FF                 4770 	mov	r7,a
   14BF C3                 4771 	clr	c
   14C0 74 B8              4772 	mov	a,#0xB8
   14C2 9A                 4773 	subb	a,r2
   14C3 74 0B              4774 	mov	a,#0x0B
   14C5 9B                 4775 	subb	a,r3
   14C6 50 27              4776 	jnc	00103$
                    0F48   4777 	C$slave_wixel_track.c$774$2$2 ==.
                           4778 ;	apps/slave_wixel_track/slave_wixel_track.c:774: currentState = STATE_IDLE;
   14C8 78 00              4779 	mov	r0,#_currentState
   14CA E4                 4780 	clr	a
   14CB F2                 4781 	movx	@r0,a
                    0F4C   4782 	C$slave_wixel_track.c$775$2$2 ==.
                           4783 ;	apps/slave_wixel_track/slave_wixel_track.c:775: calib_step = 0;
   14CC 78 B1              4784 	mov	r0,#_calib_step
   14CE E4                 4785 	clr	a
   14CF F2                 4786 	movx	@r0,a
                    0F50   4787 	C$slave_wixel_track.c$776$2$2 ==.
                           4788 ;	apps/slave_wixel_track/slave_wixel_track.c:776: waypointCount = 0;
   14D0 78 93              4789 	mov	r0,#_waypointCount
   14D2 E4                 4790 	clr	a
   14D3 F2                 4791 	movx	@r0,a
                    0F54   4792 	C$slave_wixel_track.c$777$2$2 ==.
                           4793 ;	apps/slave_wixel_track/slave_wixel_track.c:777: currentWaypointIndex = 0;
   14D4 78 95              4794 	mov	r0,#_currentWaypointIndex
   14D6 E4                 4795 	clr	a
   14D7 F2                 4796 	movx	@r0,a
                    0F58   4797 	C$slave_wixel_track.c$778$2$2 ==.
                           4798 ;	apps/slave_wixel_track/slave_wixel_track.c:778: runSubState = 0;
   14D8 78 96              4799 	mov	r0,#_runSubState
   14DA E4                 4800 	clr	a
   14DB F2                 4801 	movx	@r0,a
                    0F5C   4802 	C$slave_wixel_track.c$779$2$2 ==.
                           4803 ;	apps/slave_wixel_track/slave_wixel_track.c:779: homeSubState = 0;
   14DC 78 97              4804 	mov	r0,#_homeSubState
   14DE E4                 4805 	clr	a
   14DF F2                 4806 	movx	@r0,a
                    0F60   4807 	C$slave_wixel_track.c$780$2$2 ==.
                           4808 ;	apps/slave_wixel_track/slave_wixel_track.c:780: pwm_left = 0;
   14E0 78 27              4809 	mov	r0,#_pwm_left
   14E2 E4                 4810 	clr	a
   14E3 F2                 4811 	movx	@r0,a
   14E4 08                 4812 	inc	r0
   14E5 F2                 4813 	movx	@r0,a
                    0F66   4814 	C$slave_wixel_track.c$781$2$2 ==.
                           4815 ;	apps/slave_wixel_track/slave_wixel_track.c:781: pwm_right = 0;
   14E6 78 29              4816 	mov	r0,#_pwm_right
   14E8 E4                 4817 	clr	a
   14E9 F2                 4818 	movx	@r0,a
   14EA 08                 4819 	inc	r0
   14EB F2                 4820 	movx	@r0,a
                    0F6C   4821 	C$slave_wixel_track.c$782$2$2 ==.
                           4822 ;	apps/slave_wixel_track/slave_wixel_track.c:782: stopMotors();
   14EC 12 0D E2           4823 	lcall	_stopMotors
   14EF                    4824 00103$:
                    0F6F   4825 	C$slave_wixel_track.c$784$2$1 ==.
                    0F6F   4826 	XG$handlePacketTimeout$0$0 ==.
   14EF 22                 4827 	ret
                           4828 ;------------------------------------------------------------
                           4829 ;Allocation info for local variables in function 'updateHomeState'
                           4830 ;------------------------------------------------------------
                    0F70   4831 	G$updateHomeState$0$0 ==.
                    0F70   4832 	C$slave_wixel_track.c$788$2$1 ==.
                           4833 ;	apps/slave_wixel_track/slave_wixel_track.c:788: void updateHomeState()
                           4834 ;	-----------------------------------------
                           4835 ;	 function updateHomeState
                           4836 ;	-----------------------------------------
   14F0                    4837 _updateHomeState:
                    0F70   4838 	C$slave_wixel_track.c$790$1$1 ==.
                           4839 ;	apps/slave_wixel_track/slave_wixel_track.c:790: uint32 elapsedTime = now - stateStartTime;
   14F0 78 07              4840 	mov	r0,#_now
   14F2 79 23              4841 	mov	r1,#_stateStartTime
   14F4 E3                 4842 	movx	a,@r1
   14F5 F5 F0              4843 	mov	b,a
   14F7 C3                 4844 	clr	c
   14F8 E2                 4845 	movx	a,@r0
   14F9 95 F0              4846 	subb	a,b
   14FB FC                 4847 	mov	r4,a
   14FC 09                 4848 	inc	r1
   14FD E3                 4849 	movx	a,@r1
   14FE F5 F0              4850 	mov	b,a
   1500 08                 4851 	inc	r0
   1501 E2                 4852 	movx	a,@r0
   1502 95 F0              4853 	subb	a,b
   1504 FD                 4854 	mov	r5,a
   1505 09                 4855 	inc	r1
   1506 E3                 4856 	movx	a,@r1
   1507 F5 F0              4857 	mov	b,a
   1509 08                 4858 	inc	r0
   150A E2                 4859 	movx	a,@r0
   150B 95 F0              4860 	subb	a,b
   150D FE                 4861 	mov	r6,a
   150E 09                 4862 	inc	r1
   150F E3                 4863 	movx	a,@r1
   1510 F5 F0              4864 	mov	b,a
   1512 08                 4865 	inc	r0
   1513 E2                 4866 	movx	a,@r0
   1514 95 F0              4867 	subb	a,b
   1516 FF                 4868 	mov	r7,a
                    0F97   4869 	C$slave_wixel_track.c$795$1$1 ==.
                           4870 ;	apps/slave_wixel_track/slave_wixel_track.c:795: if (elapsedTime >= GO_TO_TIMEOUT)
   1517 C3                 4871 	clr	c
   1518 EC                 4872 	mov	a,r4
   1519 94 10              4873 	subb	a,#0x10
   151B ED                 4874 	mov	a,r5
   151C 94 27              4875 	subb	a,#0x27
   151E EE                 4876 	mov	a,r6
   151F 94 00              4877 	subb	a,#0x00
   1521 EF                 4878 	mov	a,r7
   1522 94 00              4879 	subb	a,#0x00
   1524 40 26              4880 	jc	00102$
                    0FA6   4881 	C$slave_wixel_track.c$797$2$2 ==.
                           4882 ;	apps/slave_wixel_track/slave_wixel_track.c:797: currentState = STATE_IDLE;
   1526 78 00              4883 	mov	r0,#_currentState
   1528 E4                 4884 	clr	a
   1529 F2                 4885 	movx	@r0,a
                    0FAA   4886 	C$slave_wixel_track.c$798$2$2 ==.
                           4887 ;	apps/slave_wixel_track/slave_wixel_track.c:798: homeSubState = 0;
   152A 78 97              4888 	mov	r0,#_homeSubState
   152C E4                 4889 	clr	a
   152D F2                 4890 	movx	@r0,a
                    0FAE   4891 	C$slave_wixel_track.c$799$2$2 ==.
                           4892 ;	apps/slave_wixel_track/slave_wixel_track.c:799: pwm_left = 0;
   152E 78 27              4893 	mov	r0,#_pwm_left
   1530 E4                 4894 	clr	a
   1531 F2                 4895 	movx	@r0,a
   1532 08                 4896 	inc	r0
   1533 F2                 4897 	movx	@r0,a
                    0FB4   4898 	C$slave_wixel_track.c$800$2$2 ==.
                           4899 ;	apps/slave_wixel_track/slave_wixel_track.c:800: pwm_right = 0;
   1534 78 29              4900 	mov	r0,#_pwm_right
   1536 E4                 4901 	clr	a
   1537 F2                 4902 	movx	@r0,a
   1538 08                 4903 	inc	r0
   1539 F2                 4904 	movx	@r0,a
                    0FBA   4905 	C$slave_wixel_track.c$801$2$2 ==.
                           4906 ;	apps/slave_wixel_track/slave_wixel_track.c:801: stopMotors();
   153A 12 0D E2           4907 	lcall	_stopMotors
                    0FBD   4908 	C$slave_wixel_track.c$802$2$2 ==.
                           4909 ;	apps/slave_wixel_track/slave_wixel_track.c:802: lastTargetX = 0;
   153D 78 1D              4910 	mov	r0,#_lastTargetX
   153F E4                 4911 	clr	a
   1540 F2                 4912 	movx	@r0,a
   1541 08                 4913 	inc	r0
   1542 F2                 4914 	movx	@r0,a
                    0FC3   4915 	C$slave_wixel_track.c$803$2$2 ==.
                           4916 ;	apps/slave_wixel_track/slave_wixel_track.c:803: lastTargetY = 0;
   1543 78 21              4917 	mov	r0,#_lastTargetY
   1545 E4                 4918 	clr	a
   1546 F2                 4919 	movx	@r0,a
   1547 08                 4920 	inc	r0
   1548 F2                 4921 	movx	@r0,a
                    0FC9   4922 	C$slave_wixel_track.c$804$2$2 ==.
                           4923 ;	apps/slave_wixel_track/slave_wixel_track.c:804: return;
   1549 02 17 5F           4924 	ljmp	00133$
   154C                    4925 00102$:
                    0FCC   4926 	C$slave_wixel_track.c$832$1$1 ==.
                           4927 ;	apps/slave_wixel_track/slave_wixel_track.c:832: if (homeSubState == 0)
   154C 78 97              4928 	mov	r0,#_homeSubState
   154E E2                 4929 	movx	a,@r0
   154F 60 03              4930 	jz	00156$
   1551 02 15 F9           4931 	ljmp	00131$
   1554                    4932 00156$:
                    0FD4   4933 	C$slave_wixel_track.c$835$2$3 ==.
                           4934 ;	apps/slave_wixel_track/slave_wixel_track.c:835: targetHeading = calculateTargetHeading(filteredX, filteredY, targetX, targetY);
   1554 78 17              4935 	mov	r0,#_filteredY
   1556 79 BE              4936 	mov	r1,#_calculateTargetHeading_PARM_2
   1558 E2                 4937 	movx	a,@r0
   1559 F3                 4938 	movx	@r1,a
   155A 08                 4939 	inc	r0
   155B E2                 4940 	movx	a,@r0
   155C 09                 4941 	inc	r1
   155D F3                 4942 	movx	@r1,a
   155E 78 1B              4943 	mov	r0,#_targetX
   1560 79 C0              4944 	mov	r1,#_calculateTargetHeading_PARM_3
   1562 E2                 4945 	movx	a,@r0
   1563 F3                 4946 	movx	@r1,a
   1564 08                 4947 	inc	r0
   1565 E2                 4948 	movx	a,@r0
   1566 09                 4949 	inc	r1
   1567 F3                 4950 	movx	@r1,a
   1568 78 1F              4951 	mov	r0,#_targetY
   156A 79 C2              4952 	mov	r1,#_calculateTargetHeading_PARM_4
   156C E2                 4953 	movx	a,@r0
   156D F3                 4954 	movx	@r1,a
   156E 08                 4955 	inc	r0
   156F E2                 4956 	movx	a,@r0
   1570 09                 4957 	inc	r1
   1571 F3                 4958 	movx	@r1,a
   1572 78 15              4959 	mov	r0,#_filteredX
   1574 E2                 4960 	movx	a,@r0
   1575 F5 82              4961 	mov	dpl,a
   1577 08                 4962 	inc	r0
   1578 E2                 4963 	movx	a,@r0
   1579 F5 83              4964 	mov	dph,a
   157B 12 06 6C           4965 	lcall	_calculateTargetHeading
   157E AE 82              4966 	mov	r6,dpl
   1580 AF 83              4967 	mov	r7,dph
                    1002   4968 	C$slave_wixel_track.c$837$2$3 ==.
                           4969 ;	apps/slave_wixel_track/slave_wixel_track.c:837: headingError = targetHeading - filteredTheta;
   1582 78 19              4970 	mov	r0,#_filteredTheta
   1584 D3                 4971 	setb	c
   1585 E2                 4972 	movx	a,@r0
   1586 9E                 4973 	subb	a,r6
   1587 F4                 4974 	cpl	a
   1588 B3                 4975 	cpl	c
   1589 FC                 4976 	mov	r4,a
   158A B3                 4977 	cpl	c
   158B 08                 4978 	inc	r0
   158C E2                 4979 	movx	a,@r0
   158D 9F                 4980 	subb	a,r7
   158E F4                 4981 	cpl	a
   158F FD                 4982 	mov	r5,a
                    1010   4983 	C$slave_wixel_track.c$838$2$3 ==.
                           4984 ;	apps/slave_wixel_track/slave_wixel_track.c:838: if (headingError > 180)
   1590 C3                 4985 	clr	c
   1591 74 B4              4986 	mov	a,#0xB4
   1593 9C                 4987 	subb	a,r4
   1594 E4                 4988 	clr	a
   1595 64 80              4989 	xrl	a,#0x80
   1597 8D F0              4990 	mov	b,r5
   1599 63 F0 80           4991 	xrl	b,#0x80
   159C 95 F0              4992 	subb	a,b
   159E 50 08              4993 	jnc	00104$
                    1020   4994 	C$slave_wixel_track.c$839$2$3 ==.
                           4995 ;	apps/slave_wixel_track/slave_wixel_track.c:839: headingError -= 360;
   15A0 EC                 4996 	mov	a,r4
   15A1 24 98              4997 	add	a,#0x98
   15A3 FC                 4998 	mov	r4,a
   15A4 ED                 4999 	mov	a,r5
   15A5 34 FE              5000 	addc	a,#0xFE
   15A7 FD                 5001 	mov	r5,a
   15A8                    5002 00104$:
                    1028   5003 	C$slave_wixel_track.c$840$2$3 ==.
                           5004 ;	apps/slave_wixel_track/slave_wixel_track.c:840: if (headingError < -180)
   15A8 C3                 5005 	clr	c
   15A9 EC                 5006 	mov	a,r4
   15AA 94 4C              5007 	subb	a,#0x4C
   15AC ED                 5008 	mov	a,r5
   15AD 64 80              5009 	xrl	a,#0x80
   15AF 94 7F              5010 	subb	a,#0x7f
   15B1 50 08              5011 	jnc	00106$
                    1033   5012 	C$slave_wixel_track.c$841$2$3 ==.
                           5013 ;	apps/slave_wixel_track/slave_wixel_track.c:841: headingError += 360;
   15B3 74 68              5014 	mov	a,#0x68
   15B5 2C                 5015 	add	a,r4
   15B6 FC                 5016 	mov	r4,a
   15B7 74 01              5017 	mov	a,#0x01
   15B9 3D                 5018 	addc	a,r5
   15BA FD                 5019 	mov	r5,a
   15BB                    5020 00106$:
                    103B   5021 	C$slave_wixel_track.c$843$2$3 ==.
                           5022 ;	apps/slave_wixel_track/slave_wixel_track.c:843: abs_error = (headingError >= 0) ? headingError : -headingError;
   15BB ED                 5023 	mov	a,r5
   15BC 33                 5024 	rlc	a
   15BD B3                 5025 	cpl	c
   15BE E4                 5026 	clr	a
   15BF 33                 5027 	rlc	a
   15C0 FB                 5028 	mov	r3,a
   15C1 60 06              5029 	jz	00135$
   15C3 8C 02              5030 	mov	ar2,r4
   15C5 8D 03              5031 	mov	ar3,r5
   15C7 80 07              5032 	sjmp	00136$
   15C9                    5033 00135$:
   15C9 C3                 5034 	clr	c
   15CA E4                 5035 	clr	a
   15CB 9C                 5036 	subb	a,r4
   15CC FA                 5037 	mov	r2,a
   15CD E4                 5038 	clr	a
   15CE 9D                 5039 	subb	a,r5
   15CF FB                 5040 	mov	r3,a
   15D0                    5041 00136$:
                    1050   5042 	C$slave_wixel_track.c$845$2$3 ==.
                           5043 ;	apps/slave_wixel_track/slave_wixel_track.c:845: if (abs_error < HEADING_THRESHOLD)
   15D0 C3                 5044 	clr	c
   15D1 EA                 5045 	mov	a,r2
   15D2 94 05              5046 	subb	a,#0x05
   15D4 EB                 5047 	mov	a,r3
   15D5 64 80              5048 	xrl	a,#0x80
   15D7 94 80              5049 	subb	a,#0x80
   15D9 50 08              5050 	jnc	00108$
                    105B   5051 	C$slave_wixel_track.c$848$3$4 ==.
                           5052 ;	apps/slave_wixel_track/slave_wixel_track.c:848: homeSubState = 1;
   15DB 78 97              5053 	mov	r0,#_homeSubState
   15DD 74 01              5054 	mov	a,#0x01
   15DF F2                 5055 	movx	@r0,a
   15E0 02 17 5F           5056 	ljmp	00133$
   15E3                    5057 00108$:
                    1063   5058 	C$slave_wixel_track.c$852$3$5 ==.
                           5059 ;	apps/slave_wixel_track/slave_wixel_track.c:852: rotationController(filteredTheta, targetHeading);
   15E3 78 D6              5060 	mov	r0,#_rotationController_PARM_2
   15E5 EE                 5061 	mov	a,r6
   15E6 F2                 5062 	movx	@r0,a
   15E7 08                 5063 	inc	r0
   15E8 EF                 5064 	mov	a,r7
   15E9 F2                 5065 	movx	@r0,a
   15EA 78 19              5066 	mov	r0,#_filteredTheta
   15EC E2                 5067 	movx	a,@r0
   15ED F5 82              5068 	mov	dpl,a
   15EF 08                 5069 	inc	r0
   15F0 E2                 5070 	movx	a,@r0
   15F1 F5 83              5071 	mov	dph,a
   15F3 12 0C 45           5072 	lcall	_rotationController
   15F6 02 17 5F           5073 	ljmp	00133$
   15F9                    5074 00131$:
                    1079   5075 	C$slave_wixel_track.c$855$1$1 ==.
                           5076 ;	apps/slave_wixel_track/slave_wixel_track.c:855: else if (homeSubState == 1)
   15F9 78 97              5077 	mov	r0,#_homeSubState
   15FB E2                 5078 	movx	a,@r0
   15FC B4 01 02           5079 	cjne	a,#0x01,00162$
   15FF 80 03              5080 	sjmp	00163$
   1601                    5081 00162$:
   1601 02 17 5F           5082 	ljmp	00133$
   1604                    5083 00163$:
                    1084   5084 	C$slave_wixel_track.c$858$2$6 ==.
                           5085 ;	apps/slave_wixel_track/slave_wixel_track.c:858: if (isWithinThreshold(filteredX, filteredY, targetX, targetY, GOAL_THRESHOLD))
   1604 78 17              5086 	mov	r0,#_filteredY
   1606 79 B2              5087 	mov	r1,#_isWithinThreshold_PARM_2
   1608 E2                 5088 	movx	a,@r0
   1609 F3                 5089 	movx	@r1,a
   160A 08                 5090 	inc	r0
   160B E2                 5091 	movx	a,@r0
   160C 09                 5092 	inc	r1
   160D F3                 5093 	movx	@r1,a
   160E 78 1B              5094 	mov	r0,#_targetX
   1610 79 B4              5095 	mov	r1,#_isWithinThreshold_PARM_3
   1612 E2                 5096 	movx	a,@r0
   1613 F3                 5097 	movx	@r1,a
   1614 08                 5098 	inc	r0
   1615 E2                 5099 	movx	a,@r0
   1616 09                 5100 	inc	r1
   1617 F3                 5101 	movx	@r1,a
   1618 78 1F              5102 	mov	r0,#_targetY
   161A 79 B6              5103 	mov	r1,#_isWithinThreshold_PARM_4
   161C E2                 5104 	movx	a,@r0
   161D F3                 5105 	movx	@r1,a
   161E 08                 5106 	inc	r0
   161F E2                 5107 	movx	a,@r0
   1620 09                 5108 	inc	r1
   1621 F3                 5109 	movx	@r1,a
   1622 78 B8              5110 	mov	r0,#_isWithinThreshold_PARM_5
   1624 74 96              5111 	mov	a,#0x96
   1626 F2                 5112 	movx	@r0,a
   1627 08                 5113 	inc	r0
   1628 E4                 5114 	clr	a
   1629 F2                 5115 	movx	@r0,a
   162A 78 15              5116 	mov	r0,#_filteredX
   162C E2                 5117 	movx	a,@r0
   162D F5 82              5118 	mov	dpl,a
   162F 08                 5119 	inc	r0
   1630 E2                 5120 	movx	a,@r0
   1631 F5 83              5121 	mov	dph,a
   1633 12 05 9A           5122 	lcall	_isWithinThreshold
   1636 E5 82              5123 	mov	a,dpl
   1638 60 26              5124 	jz	00126$
                    10BA   5125 	C$slave_wixel_track.c$861$3$7 ==.
                           5126 ;	apps/slave_wixel_track/slave_wixel_track.c:861: currentState = STATE_IDLE;
   163A 78 00              5127 	mov	r0,#_currentState
   163C E4                 5128 	clr	a
   163D F2                 5129 	movx	@r0,a
                    10BE   5130 	C$slave_wixel_track.c$862$3$7 ==.
                           5131 ;	apps/slave_wixel_track/slave_wixel_track.c:862: homeSubState = 0;
   163E 78 97              5132 	mov	r0,#_homeSubState
   1640 E4                 5133 	clr	a
   1641 F2                 5134 	movx	@r0,a
                    10C2   5135 	C$slave_wixel_track.c$863$3$7 ==.
                           5136 ;	apps/slave_wixel_track/slave_wixel_track.c:863: pwm_left = 0;
   1642 78 27              5137 	mov	r0,#_pwm_left
   1644 E4                 5138 	clr	a
   1645 F2                 5139 	movx	@r0,a
   1646 08                 5140 	inc	r0
   1647 F2                 5141 	movx	@r0,a
                    10C8   5142 	C$slave_wixel_track.c$864$3$7 ==.
                           5143 ;	apps/slave_wixel_track/slave_wixel_track.c:864: pwm_right = 0;
   1648 78 29              5144 	mov	r0,#_pwm_right
   164A E4                 5145 	clr	a
   164B F2                 5146 	movx	@r0,a
   164C 08                 5147 	inc	r0
   164D F2                 5148 	movx	@r0,a
                    10CE   5149 	C$slave_wixel_track.c$865$3$7 ==.
                           5150 ;	apps/slave_wixel_track/slave_wixel_track.c:865: stopMotors();
   164E 12 0D E2           5151 	lcall	_stopMotors
                    10D1   5152 	C$slave_wixel_track.c$866$3$7 ==.
                           5153 ;	apps/slave_wixel_track/slave_wixel_track.c:866: lastTargetX = 0;
   1651 78 1D              5154 	mov	r0,#_lastTargetX
   1653 E4                 5155 	clr	a
   1654 F2                 5156 	movx	@r0,a
   1655 08                 5157 	inc	r0
   1656 F2                 5158 	movx	@r0,a
                    10D7   5159 	C$slave_wixel_track.c$867$3$7 ==.
                           5160 ;	apps/slave_wixel_track/slave_wixel_track.c:867: lastTargetY = 0;
   1657 78 21              5161 	mov	r0,#_lastTargetY
   1659 E4                 5162 	clr	a
   165A F2                 5163 	movx	@r0,a
   165B 08                 5164 	inc	r0
   165C F2                 5165 	movx	@r0,a
   165D 02 17 5F           5166 	ljmp	00133$
   1660                    5167 00126$:
                    10E0   5168 	C$slave_wixel_track.c$872$3$8 ==.
                           5169 ;	apps/slave_wixel_track/slave_wixel_track.c:872: targetHeading = calculateTargetHeading(filteredX, filteredY, targetX, targetY);
   1660 78 17              5170 	mov	r0,#_filteredY
   1662 79 BE              5171 	mov	r1,#_calculateTargetHeading_PARM_2
   1664 E2                 5172 	movx	a,@r0
   1665 F3                 5173 	movx	@r1,a
   1666 08                 5174 	inc	r0
   1667 E2                 5175 	movx	a,@r0
   1668 09                 5176 	inc	r1
   1669 F3                 5177 	movx	@r1,a
   166A 78 1B              5178 	mov	r0,#_targetX
   166C 79 C0              5179 	mov	r1,#_calculateTargetHeading_PARM_3
   166E E2                 5180 	movx	a,@r0
   166F F3                 5181 	movx	@r1,a
   1670 08                 5182 	inc	r0
   1671 E2                 5183 	movx	a,@r0
   1672 09                 5184 	inc	r1
   1673 F3                 5185 	movx	@r1,a
   1674 78 1F              5186 	mov	r0,#_targetY
   1676 79 C2              5187 	mov	r1,#_calculateTargetHeading_PARM_4
   1678 E2                 5188 	movx	a,@r0
   1679 F3                 5189 	movx	@r1,a
   167A 08                 5190 	inc	r0
   167B E2                 5191 	movx	a,@r0
   167C 09                 5192 	inc	r1
   167D F3                 5193 	movx	@r1,a
   167E 78 15              5194 	mov	r0,#_filteredX
   1680 E2                 5195 	movx	a,@r0
   1681 F5 82              5196 	mov	dpl,a
   1683 08                 5197 	inc	r0
   1684 E2                 5198 	movx	a,@r0
   1685 F5 83              5199 	mov	dph,a
   1687 12 06 6C           5200 	lcall	_calculateTargetHeading
   168A AE 82              5201 	mov	r6,dpl
   168C AF 83              5202 	mov	r7,dph
                    110E   5203 	C$slave_wixel_track.c$874$3$8 ==.
                           5204 ;	apps/slave_wixel_track/slave_wixel_track.c:874: headingError = targetHeading - filteredTheta;
   168E 78 19              5205 	mov	r0,#_filteredTheta
   1690 D3                 5206 	setb	c
   1691 E2                 5207 	movx	a,@r0
   1692 9E                 5208 	subb	a,r6
   1693 F4                 5209 	cpl	a
   1694 B3                 5210 	cpl	c
   1695 FC                 5211 	mov	r4,a
   1696 B3                 5212 	cpl	c
   1697 08                 5213 	inc	r0
   1698 E2                 5214 	movx	a,@r0
   1699 9F                 5215 	subb	a,r7
   169A F4                 5216 	cpl	a
   169B FD                 5217 	mov	r5,a
                    111C   5218 	C$slave_wixel_track.c$875$3$8 ==.
                           5219 ;	apps/slave_wixel_track/slave_wixel_track.c:875: if (headingError > 180)
   169C C3                 5220 	clr	c
   169D 74 B4              5221 	mov	a,#0xB4
   169F 9C                 5222 	subb	a,r4
   16A0 E4                 5223 	clr	a
   16A1 64 80              5224 	xrl	a,#0x80
   16A3 8D F0              5225 	mov	b,r5
   16A5 63 F0 80           5226 	xrl	b,#0x80
   16A8 95 F0              5227 	subb	a,b
   16AA 50 08              5228 	jnc	00111$
                    112C   5229 	C$slave_wixel_track.c$876$3$8 ==.
                           5230 ;	apps/slave_wixel_track/slave_wixel_track.c:876: headingError -= 360;
   16AC EC                 5231 	mov	a,r4
   16AD 24 98              5232 	add	a,#0x98
   16AF FC                 5233 	mov	r4,a
   16B0 ED                 5234 	mov	a,r5
   16B1 34 FE              5235 	addc	a,#0xFE
   16B3 FD                 5236 	mov	r5,a
   16B4                    5237 00111$:
                    1134   5238 	C$slave_wixel_track.c$877$3$8 ==.
                           5239 ;	apps/slave_wixel_track/slave_wixel_track.c:877: if (headingError < -180)
   16B4 C3                 5240 	clr	c
   16B5 EC                 5241 	mov	a,r4
   16B6 94 4C              5242 	subb	a,#0x4C
   16B8 ED                 5243 	mov	a,r5
   16B9 64 80              5244 	xrl	a,#0x80
   16BB 94 7F              5245 	subb	a,#0x7f
   16BD 50 08              5246 	jnc	00113$
                    113F   5247 	C$slave_wixel_track.c$878$3$8 ==.
                           5248 ;	apps/slave_wixel_track/slave_wixel_track.c:878: headingError += 360;
   16BF 74 68              5249 	mov	a,#0x68
   16C1 2C                 5250 	add	a,r4
   16C2 FC                 5251 	mov	r4,a
   16C3 74 01              5252 	mov	a,#0x01
   16C5 3D                 5253 	addc	a,r5
   16C6 FD                 5254 	mov	r5,a
   16C7                    5255 00113$:
                    1147   5256 	C$slave_wixel_track.c$880$3$8 ==.
                           5257 ;	apps/slave_wixel_track/slave_wixel_track.c:880: abs_error = (headingError >= 0) ? headingError : -headingError;
   16C7 ED                 5258 	mov	a,r5
   16C8 33                 5259 	rlc	a
   16C9 B3                 5260 	cpl	c
   16CA E4                 5261 	clr	a
   16CB 33                 5262 	rlc	a
   16CC FF                 5263 	mov	r7,a
   16CD 60 06              5264 	jz	00137$
   16CF 8C 06              5265 	mov	ar6,r4
   16D1 8D 07              5266 	mov	ar7,r5
   16D3 80 07              5267 	sjmp	00138$
   16D5                    5268 00137$:
   16D5 C3                 5269 	clr	c
   16D6 E4                 5270 	clr	a
   16D7 9C                 5271 	subb	a,r4
   16D8 FE                 5272 	mov	r6,a
   16D9 E4                 5273 	clr	a
   16DA 9D                 5274 	subb	a,r5
   16DB FF                 5275 	mov	r7,a
   16DC                    5276 00138$:
   16DC 8E 02              5277 	mov	ar2,r6
   16DE 8F 03              5278 	mov	ar3,r7
                    1160   5279 	C$slave_wixel_track.c$883$3$8 ==.
                           5280 ;	apps/slave_wixel_track/slave_wixel_track.c:883: if (abs_error > 45)
   16E0 C3                 5281 	clr	c
   16E1 74 2D              5282 	mov	a,#0x2D
   16E3 9A                 5283 	subb	a,r2
   16E4 E4                 5284 	clr	a
   16E5 64 80              5285 	xrl	a,#0x80
   16E7 8B F0              5286 	mov	b,r3
   16E9 63 F0 80           5287 	xrl	b,#0x80
   16EC 95 F0              5288 	subb	a,b
   16EE 50 12              5289 	jnc	00123$
                    1170   5290 	C$slave_wixel_track.c$885$4$9 ==.
                           5291 ;	apps/slave_wixel_track/slave_wixel_track.c:885: homeSubState = 0;  // Back to rotation phase
   16F0 78 97              5292 	mov	r0,#_homeSubState
   16F2 E4                 5293 	clr	a
   16F3 F2                 5294 	movx	@r0,a
                    1174   5295 	C$slave_wixel_track.c$886$4$9 ==.
                           5296 ;	apps/slave_wixel_track/slave_wixel_track.c:886: pwm_left = 0;
   16F4 78 27              5297 	mov	r0,#_pwm_left
   16F6 E4                 5298 	clr	a
   16F7 F2                 5299 	movx	@r0,a
   16F8 08                 5300 	inc	r0
   16F9 F2                 5301 	movx	@r0,a
                    117A   5302 	C$slave_wixel_track.c$887$4$9 ==.
                           5303 ;	apps/slave_wixel_track/slave_wixel_track.c:887: pwm_right = 0;
   16FA 78 29              5304 	mov	r0,#_pwm_right
   16FC E4                 5305 	clr	a
   16FD F2                 5306 	movx	@r0,a
   16FE 08                 5307 	inc	r0
   16FF F2                 5308 	movx	@r0,a
   1700 80 5D              5309 	sjmp	00133$
   1702                    5310 00123$:
                    1182   5311 	C$slave_wixel_track.c$892$4$10 ==.
                           5312 ;	apps/slave_wixel_track/slave_wixel_track.c:892: int16 steeringAdjust = (headingError * STEERING_KP);
   1702 8C 06              5313 	mov	ar6,r4
   1704 ED                 5314 	mov	a,r5
   1705 CE                 5315 	xch	a,r6
   1706 25 E0              5316 	add	a,acc
   1708 CE                 5317 	xch	a,r6
   1709 33                 5318 	rlc	a
   170A FF                 5319 	mov	r7,a
                    118B   5320 	C$slave_wixel_track.c$895$4$10 ==.
                           5321 ;	apps/slave_wixel_track/slave_wixel_track.c:895: if (steeringAdjust > MAX_STEERING_ADJUST)
   170B C3                 5322 	clr	c
   170C 74 1E              5323 	mov	a,#0x1E
   170E 9E                 5324 	subb	a,r6
   170F E4                 5325 	clr	a
   1710 64 80              5326 	xrl	a,#0x80
   1712 8F F0              5327 	mov	b,r7
   1714 63 F0 80           5328 	xrl	b,#0x80
   1717 95 F0              5329 	subb	a,b
   1719 50 04              5330 	jnc	00115$
                    119B   5331 	C$slave_wixel_track.c$896$4$10 ==.
                           5332 ;	apps/slave_wixel_track/slave_wixel_track.c:896: steeringAdjust = MAX_STEERING_ADJUST;
   171B 7E 1E              5333 	mov	r6,#0x1E
   171D 7F 00              5334 	mov	r7,#0x00
   171F                    5335 00115$:
                    119F   5336 	C$slave_wixel_track.c$897$4$10 ==.
                           5337 ;	apps/slave_wixel_track/slave_wixel_track.c:897: if (steeringAdjust < -MAX_STEERING_ADJUST)
   171F C3                 5338 	clr	c
   1720 EE                 5339 	mov	a,r6
   1721 94 E2              5340 	subb	a,#0xE2
   1723 EF                 5341 	mov	a,r7
   1724 64 80              5342 	xrl	a,#0x80
   1726 94 7F              5343 	subb	a,#0x7f
   1728 50 04              5344 	jnc	00117$
                    11AA   5345 	C$slave_wixel_track.c$898$4$10 ==.
                           5346 ;	apps/slave_wixel_track/slave_wixel_track.c:898: steeringAdjust = -MAX_STEERING_ADJUST;
   172A 7E E2              5347 	mov	r6,#0xE2
   172C 7F FF              5348 	mov	r7,#0xFF
   172E                    5349 00117$:
                    11AE   5350 	C$slave_wixel_track.c$901$4$10 ==.
                           5351 ;	apps/slave_wixel_track/slave_wixel_track.c:901: pwm_left = FORWARD_SPEED_PWM - steeringAdjust;
   172E 74 50              5352 	mov	a,#0x50
   1730 C3                 5353 	clr	c
   1731 9E                 5354 	subb	a,r6
   1732 FC                 5355 	mov	r4,a
   1733 E4                 5356 	clr	a
   1734 9F                 5357 	subb	a,r7
   1735 FD                 5358 	mov	r5,a
   1736 78 27              5359 	mov	r0,#_pwm_left
   1738 EC                 5360 	mov	a,r4
   1739 F2                 5361 	movx	@r0,a
   173A 08                 5362 	inc	r0
   173B ED                 5363 	mov	a,r5
   173C F2                 5364 	movx	@r0,a
                    11BD   5365 	C$slave_wixel_track.c$902$4$10 ==.
                           5366 ;	apps/slave_wixel_track/slave_wixel_track.c:902: pwm_right = FORWARD_SPEED_PWM + steeringAdjust;
   173D 74 50              5367 	mov	a,#0x50
   173F 2E                 5368 	add	a,r6
   1740 FE                 5369 	mov	r6,a
   1741 E4                 5370 	clr	a
   1742 3F                 5371 	addc	a,r7
   1743 FF                 5372 	mov	r7,a
   1744 78 29              5373 	mov	r0,#_pwm_right
   1746 EE                 5374 	mov	a,r6
   1747 F2                 5375 	movx	@r0,a
   1748 08                 5376 	inc	r0
   1749 EF                 5377 	mov	a,r7
   174A F2                 5378 	movx	@r0,a
                    11CB   5379 	C$slave_wixel_track.c$905$4$10 ==.
                           5380 ;	apps/slave_wixel_track/slave_wixel_track.c:905: if (pwm_left < 0) pwm_left = 0;
   174B ED                 5381 	mov	a,r5
   174C 30 E7 06           5382 	jnb	acc.7,00119$
   174F 78 27              5383 	mov	r0,#_pwm_left
   1751 E4                 5384 	clr	a
   1752 F2                 5385 	movx	@r0,a
   1753 08                 5386 	inc	r0
   1754 F2                 5387 	movx	@r0,a
   1755                    5388 00119$:
                    11D5   5389 	C$slave_wixel_track.c$906$4$10 ==.
                           5390 ;	apps/slave_wixel_track/slave_wixel_track.c:906: if (pwm_right < 0) pwm_right = 0;
   1755 EF                 5391 	mov	a,r7
   1756 30 E7 06           5392 	jnb	acc.7,00133$
   1759 78 29              5393 	mov	r0,#_pwm_right
   175B E4                 5394 	clr	a
   175C F2                 5395 	movx	@r0,a
   175D 08                 5396 	inc	r0
   175E F2                 5397 	movx	@r0,a
   175F                    5398 00133$:
                    11DF   5399 	C$slave_wixel_track.c$911$2$1 ==.
                    11DF   5400 	XG$updateHomeState$0$0 ==.
   175F 22                 5401 	ret
                           5402 ;------------------------------------------------------------
                           5403 ;Allocation info for local variables in function 'updateRunState'
                           5404 ;------------------------------------------------------------
                    11E0   5405 	G$updateRunState$0$0 ==.
                    11E0   5406 	C$slave_wixel_track.c$913$2$1 ==.
                           5407 ;	apps/slave_wixel_track/slave_wixel_track.c:913: void updateRunState()
                           5408 ;	-----------------------------------------
                           5409 ;	 function updateRunState
                           5410 ;	-----------------------------------------
   1760                    5411 _updateRunState:
                    11E0   5412 	C$slave_wixel_track.c$915$1$1 ==.
                           5413 ;	apps/slave_wixel_track/slave_wixel_track.c:915: uint32 elapsedTime = now - stateStartTime;
   1760 78 07              5414 	mov	r0,#_now
   1762 79 23              5415 	mov	r1,#_stateStartTime
   1764 E3                 5416 	movx	a,@r1
   1765 F5 F0              5417 	mov	b,a
   1767 C3                 5418 	clr	c
   1768 E2                 5419 	movx	a,@r0
   1769 95 F0              5420 	subb	a,b
   176B FC                 5421 	mov	r4,a
   176C 09                 5422 	inc	r1
   176D E3                 5423 	movx	a,@r1
   176E F5 F0              5424 	mov	b,a
   1770 08                 5425 	inc	r0
   1771 E2                 5426 	movx	a,@r0
   1772 95 F0              5427 	subb	a,b
   1774 FD                 5428 	mov	r5,a
   1775 09                 5429 	inc	r1
   1776 E3                 5430 	movx	a,@r1
   1777 F5 F0              5431 	mov	b,a
   1779 08                 5432 	inc	r0
   177A E2                 5433 	movx	a,@r0
   177B 95 F0              5434 	subb	a,b
   177D FE                 5435 	mov	r6,a
   177E 09                 5436 	inc	r1
   177F E3                 5437 	movx	a,@r1
   1780 F5 F0              5438 	mov	b,a
   1782 08                 5439 	inc	r0
   1783 E2                 5440 	movx	a,@r0
   1784 95 F0              5441 	subb	a,b
   1786 FF                 5442 	mov	r7,a
                    1207   5443 	C$slave_wixel_track.c$920$1$1 ==.
                           5444 ;	apps/slave_wixel_track/slave_wixel_track.c:920: if (elapsedTime >= RUN_TIMEOUT)
   1787 C3                 5445 	clr	c
   1788 EC                 5446 	mov	a,r4
   1789 94 60              5447 	subb	a,#0x60
   178B ED                 5448 	mov	a,r5
   178C 94 EA              5449 	subb	a,#0xEA
   178E EE                 5450 	mov	a,r6
   178F 94 00              5451 	subb	a,#0x00
   1791 EF                 5452 	mov	a,r7
   1792 94 00              5453 	subb	a,#0x00
   1794 40 22              5454 	jc	00102$
                    1216   5455 	C$slave_wixel_track.c$922$2$2 ==.
                           5456 ;	apps/slave_wixel_track/slave_wixel_track.c:922: currentState = STATE_IDLE;
   1796 78 00              5457 	mov	r0,#_currentState
   1798 E4                 5458 	clr	a
   1799 F2                 5459 	movx	@r0,a
                    121A   5460 	C$slave_wixel_track.c$923$2$2 ==.
                           5461 ;	apps/slave_wixel_track/slave_wixel_track.c:923: waypointCount = 0;
   179A 78 93              5462 	mov	r0,#_waypointCount
   179C E4                 5463 	clr	a
   179D F2                 5464 	movx	@r0,a
                    121E   5465 	C$slave_wixel_track.c$924$2$2 ==.
                           5466 ;	apps/slave_wixel_track/slave_wixel_track.c:924: currentWaypointIndex = 0;
   179E 78 95              5467 	mov	r0,#_currentWaypointIndex
   17A0 E4                 5468 	clr	a
   17A1 F2                 5469 	movx	@r0,a
                    1222   5470 	C$slave_wixel_track.c$925$2$2 ==.
                           5471 ;	apps/slave_wixel_track/slave_wixel_track.c:925: runSubState = 0;
   17A2 78 96              5472 	mov	r0,#_runSubState
   17A4 E4                 5473 	clr	a
   17A5 F2                 5474 	movx	@r0,a
                    1226   5475 	C$slave_wixel_track.c$926$2$2 ==.
                           5476 ;	apps/slave_wixel_track/slave_wixel_track.c:926: pwm_left = 0;
   17A6 78 27              5477 	mov	r0,#_pwm_left
   17A8 E4                 5478 	clr	a
   17A9 F2                 5479 	movx	@r0,a
   17AA 08                 5480 	inc	r0
   17AB F2                 5481 	movx	@r0,a
                    122C   5482 	C$slave_wixel_track.c$927$2$2 ==.
                           5483 ;	apps/slave_wixel_track/slave_wixel_track.c:927: pwm_right = 0;
   17AC 78 29              5484 	mov	r0,#_pwm_right
   17AE E4                 5485 	clr	a
   17AF F2                 5486 	movx	@r0,a
   17B0 08                 5487 	inc	r0
   17B1 F2                 5488 	movx	@r0,a
                    1232   5489 	C$slave_wixel_track.c$928$2$2 ==.
                           5490 ;	apps/slave_wixel_track/slave_wixel_track.c:928: stopMotors();
   17B2 12 0D E2           5491 	lcall	_stopMotors
                    1235   5492 	C$slave_wixel_track.c$929$2$2 ==.
                           5493 ;	apps/slave_wixel_track/slave_wixel_track.c:929: return;
   17B5 02 1A 09           5494 	ljmp	00135$
   17B8                    5495 00102$:
                    1238   5496 	C$slave_wixel_track.c$932$1$1 ==.
                           5497 ;	apps/slave_wixel_track/slave_wixel_track.c:932: if (currentWaypointIndex >= waypointCount)
   17B8 78 95              5498 	mov	r0,#_currentWaypointIndex
   17BA 79 93              5499 	mov	r1,#_waypointCount
   17BC C3                 5500 	clr	c
   17BD E3                 5501 	movx	a,@r1
   17BE F5 F0              5502 	mov	b,a
   17C0 E2                 5503 	movx	a,@r0
   17C1 95 F0              5504 	subb	a,b
   17C3 40 22              5505 	jc	00104$
                    1245   5506 	C$slave_wixel_track.c$935$2$3 ==.
                           5507 ;	apps/slave_wixel_track/slave_wixel_track.c:935: currentState = STATE_IDLE;
   17C5 78 00              5508 	mov	r0,#_currentState
   17C7 E4                 5509 	clr	a
   17C8 F2                 5510 	movx	@r0,a
                    1249   5511 	C$slave_wixel_track.c$936$2$3 ==.
                           5512 ;	apps/slave_wixel_track/slave_wixel_track.c:936: waypointCount = 0;
   17C9 78 93              5513 	mov	r0,#_waypointCount
   17CB E4                 5514 	clr	a
   17CC F2                 5515 	movx	@r0,a
                    124D   5516 	C$slave_wixel_track.c$937$2$3 ==.
                           5517 ;	apps/slave_wixel_track/slave_wixel_track.c:937: currentWaypointIndex = 0;
   17CD 78 95              5518 	mov	r0,#_currentWaypointIndex
   17CF E4                 5519 	clr	a
   17D0 F2                 5520 	movx	@r0,a
                    1251   5521 	C$slave_wixel_track.c$938$2$3 ==.
                           5522 ;	apps/slave_wixel_track/slave_wixel_track.c:938: runSubState = 0;
   17D1 78 96              5523 	mov	r0,#_runSubState
   17D3 E4                 5524 	clr	a
   17D4 F2                 5525 	movx	@r0,a
                    1255   5526 	C$slave_wixel_track.c$939$2$3 ==.
                           5527 ;	apps/slave_wixel_track/slave_wixel_track.c:939: pwm_left = 0;
   17D5 78 27              5528 	mov	r0,#_pwm_left
   17D7 E4                 5529 	clr	a
   17D8 F2                 5530 	movx	@r0,a
   17D9 08                 5531 	inc	r0
   17DA F2                 5532 	movx	@r0,a
                    125B   5533 	C$slave_wixel_track.c$940$2$3 ==.
                           5534 ;	apps/slave_wixel_track/slave_wixel_track.c:940: pwm_right = 0;
   17DB 78 29              5535 	mov	r0,#_pwm_right
   17DD E4                 5536 	clr	a
   17DE F2                 5537 	movx	@r0,a
   17DF 08                 5538 	inc	r0
   17E0 F2                 5539 	movx	@r0,a
                    1261   5540 	C$slave_wixel_track.c$941$2$3 ==.
                           5541 ;	apps/slave_wixel_track/slave_wixel_track.c:941: stopMotors();
   17E1 12 0D E2           5542 	lcall	_stopMotors
                    1264   5543 	C$slave_wixel_track.c$942$2$3 ==.
                           5544 ;	apps/slave_wixel_track/slave_wixel_track.c:942: return;
   17E4 02 1A 09           5545 	ljmp	00135$
   17E7                    5546 00104$:
                    1267   5547 	C$slave_wixel_track.c$946$1$1 ==.
                           5548 ;	apps/slave_wixel_track/slave_wixel_track.c:946: targetX = waypoints[currentWaypointIndex].x;
   17E7 78 95              5549 	mov	r0,#_currentWaypointIndex
   17E9 E2                 5550 	movx	a,@r0
   17EA 75 F0 05           5551 	mov	b,#0x05
   17ED A4                 5552 	mul	ab
   17EE 24 2F              5553 	add	a,#_waypoints
   17F0 FF                 5554 	mov	r7,a
   17F1 04                 5555 	inc	a
   17F2 F9                 5556 	mov	r1,a
   17F3 E3                 5557 	movx	a,@r1
   17F4 FD                 5558 	mov	r5,a
   17F5 09                 5559 	inc	r1
   17F6 E3                 5560 	movx	a,@r1
   17F7 FE                 5561 	mov	r6,a
   17F8 78 1B              5562 	mov	r0,#_targetX
   17FA ED                 5563 	mov	a,r5
   17FB F2                 5564 	movx	@r0,a
   17FC 08                 5565 	inc	r0
   17FD EE                 5566 	mov	a,r6
   17FE F2                 5567 	movx	@r0,a
                    127F   5568 	C$slave_wixel_track.c$947$1$1 ==.
                           5569 ;	apps/slave_wixel_track/slave_wixel_track.c:947: targetY = waypoints[currentWaypointIndex].y;
   17FF 74 03              5570 	mov	a,#0x03
   1801 2F                 5571 	add	a,r7
   1802 F9                 5572 	mov	r1,a
   1803 E3                 5573 	movx	a,@r1
   1804 FC                 5574 	mov	r4,a
   1805 09                 5575 	inc	r1
   1806 E3                 5576 	movx	a,@r1
   1807 FF                 5577 	mov	r7,a
   1808 78 1F              5578 	mov	r0,#_targetY
   180A EC                 5579 	mov	a,r4
   180B F2                 5580 	movx	@r0,a
   180C 08                 5581 	inc	r0
   180D EF                 5582 	mov	a,r7
   180E F2                 5583 	movx	@r0,a
                    128F   5584 	C$slave_wixel_track.c$949$1$1 ==.
                           5585 ;	apps/slave_wixel_track/slave_wixel_track.c:949: if (runSubState == 0)
   180F 78 96              5586 	mov	r0,#_runSubState
   1811 E2                 5587 	movx	a,@r0
   1812 60 03              5588 	jz	00160$
   1814 02 18 B6           5589 	ljmp	00133$
   1817                    5590 00160$:
                    1297   5591 	C$slave_wixel_track.c$952$2$4 ==.
                           5592 ;	apps/slave_wixel_track/slave_wixel_track.c:952: targetHeading = calculateTargetHeading(filteredX, filteredY, targetX, targetY);
   1817 78 17              5593 	mov	r0,#_filteredY
   1819 79 BE              5594 	mov	r1,#_calculateTargetHeading_PARM_2
   181B E2                 5595 	movx	a,@r0
   181C F3                 5596 	movx	@r1,a
   181D 08                 5597 	inc	r0
   181E E2                 5598 	movx	a,@r0
   181F 09                 5599 	inc	r1
   1820 F3                 5600 	movx	@r1,a
   1821 78 C0              5601 	mov	r0,#_calculateTargetHeading_PARM_3
   1823 ED                 5602 	mov	a,r5
   1824 F2                 5603 	movx	@r0,a
   1825 08                 5604 	inc	r0
   1826 EE                 5605 	mov	a,r6
   1827 F2                 5606 	movx	@r0,a
   1828 78 C2              5607 	mov	r0,#_calculateTargetHeading_PARM_4
   182A EC                 5608 	mov	a,r4
   182B F2                 5609 	movx	@r0,a
   182C 08                 5610 	inc	r0
   182D EF                 5611 	mov	a,r7
   182E F2                 5612 	movx	@r0,a
   182F 78 15              5613 	mov	r0,#_filteredX
   1831 E2                 5614 	movx	a,@r0
   1832 F5 82              5615 	mov	dpl,a
   1834 08                 5616 	inc	r0
   1835 E2                 5617 	movx	a,@r0
   1836 F5 83              5618 	mov	dph,a
   1838 12 06 6C           5619 	lcall	_calculateTargetHeading
   183B AF 82              5620 	mov	r7,dpl
   183D AE 83              5621 	mov	r6,dph
                    12BF   5622 	C$slave_wixel_track.c$954$2$4 ==.
                           5623 ;	apps/slave_wixel_track/slave_wixel_track.c:954: headingError = targetHeading - filteredTheta;
   183F 78 19              5624 	mov	r0,#_filteredTheta
   1841 D3                 5625 	setb	c
   1842 E2                 5626 	movx	a,@r0
   1843 9F                 5627 	subb	a,r7
   1844 F4                 5628 	cpl	a
   1845 B3                 5629 	cpl	c
   1846 FD                 5630 	mov	r5,a
   1847 B3                 5631 	cpl	c
   1848 08                 5632 	inc	r0
   1849 E2                 5633 	movx	a,@r0
   184A 9E                 5634 	subb	a,r6
   184B F4                 5635 	cpl	a
   184C FC                 5636 	mov	r4,a
                    12CD   5637 	C$slave_wixel_track.c$955$2$4 ==.
                           5638 ;	apps/slave_wixel_track/slave_wixel_track.c:955: if (headingError > 180)
   184D C3                 5639 	clr	c
   184E 74 B4              5640 	mov	a,#0xB4
   1850 9D                 5641 	subb	a,r5
   1851 E4                 5642 	clr	a
   1852 64 80              5643 	xrl	a,#0x80
   1854 8C F0              5644 	mov	b,r4
   1856 63 F0 80           5645 	xrl	b,#0x80
   1859 95 F0              5646 	subb	a,b
   185B 50 08              5647 	jnc	00106$
                    12DD   5648 	C$slave_wixel_track.c$956$2$4 ==.
                           5649 ;	apps/slave_wixel_track/slave_wixel_track.c:956: headingError -= 360;
   185D ED                 5650 	mov	a,r5
   185E 24 98              5651 	add	a,#0x98
   1860 FD                 5652 	mov	r5,a
   1861 EC                 5653 	mov	a,r4
   1862 34 FE              5654 	addc	a,#0xFE
   1864 FC                 5655 	mov	r4,a
   1865                    5656 00106$:
                    12E5   5657 	C$slave_wixel_track.c$957$2$4 ==.
                           5658 ;	apps/slave_wixel_track/slave_wixel_track.c:957: if (headingError < -180)
   1865 C3                 5659 	clr	c
   1866 ED                 5660 	mov	a,r5
   1867 94 4C              5661 	subb	a,#0x4C
   1869 EC                 5662 	mov	a,r4
   186A 64 80              5663 	xrl	a,#0x80
   186C 94 7F              5664 	subb	a,#0x7f
   186E 50 08              5665 	jnc	00108$
                    12F0   5666 	C$slave_wixel_track.c$958$2$4 ==.
                           5667 ;	apps/slave_wixel_track/slave_wixel_track.c:958: headingError += 360;
   1870 74 68              5668 	mov	a,#0x68
   1872 2D                 5669 	add	a,r5
   1873 FD                 5670 	mov	r5,a
   1874 74 01              5671 	mov	a,#0x01
   1876 3C                 5672 	addc	a,r4
   1877 FC                 5673 	mov	r4,a
   1878                    5674 00108$:
                    12F8   5675 	C$slave_wixel_track.c$960$2$4 ==.
                           5676 ;	apps/slave_wixel_track/slave_wixel_track.c:960: abs_error = (headingError >= 0) ? headingError : -headingError;
   1878 EC                 5677 	mov	a,r4
   1879 33                 5678 	rlc	a
   187A B3                 5679 	cpl	c
   187B E4                 5680 	clr	a
   187C 33                 5681 	rlc	a
   187D FB                 5682 	mov	r3,a
   187E 60 06              5683 	jz	00137$
   1880 8D 02              5684 	mov	ar2,r5
   1882 8C 03              5685 	mov	ar3,r4
   1884 80 07              5686 	sjmp	00138$
   1886                    5687 00137$:
   1886 C3                 5688 	clr	c
   1887 E4                 5689 	clr	a
   1888 9D                 5690 	subb	a,r5
   1889 FA                 5691 	mov	r2,a
   188A E4                 5692 	clr	a
   188B 9C                 5693 	subb	a,r4
   188C FB                 5694 	mov	r3,a
   188D                    5695 00138$:
                    130D   5696 	C$slave_wixel_track.c$962$2$4 ==.
                           5697 ;	apps/slave_wixel_track/slave_wixel_track.c:962: if (abs_error < HEADING_THRESHOLD)
   188D C3                 5698 	clr	c
   188E EA                 5699 	mov	a,r2
   188F 94 05              5700 	subb	a,#0x05
   1891 EB                 5701 	mov	a,r3
   1892 64 80              5702 	xrl	a,#0x80
   1894 94 80              5703 	subb	a,#0x80
   1896 50 08              5704 	jnc	00110$
                    1318   5705 	C$slave_wixel_track.c$965$3$5 ==.
                           5706 ;	apps/slave_wixel_track/slave_wixel_track.c:965: runSubState = 1;
   1898 78 96              5707 	mov	r0,#_runSubState
   189A 74 01              5708 	mov	a,#0x01
   189C F2                 5709 	movx	@r0,a
   189D 02 1A 09           5710 	ljmp	00135$
   18A0                    5711 00110$:
                    1320   5712 	C$slave_wixel_track.c$969$3$6 ==.
                           5713 ;	apps/slave_wixel_track/slave_wixel_track.c:969: rotationController(filteredTheta, targetHeading);
   18A0 78 D6              5714 	mov	r0,#_rotationController_PARM_2
   18A2 EF                 5715 	mov	a,r7
   18A3 F2                 5716 	movx	@r0,a
   18A4 08                 5717 	inc	r0
   18A5 EE                 5718 	mov	a,r6
   18A6 F2                 5719 	movx	@r0,a
   18A7 78 19              5720 	mov	r0,#_filteredTheta
   18A9 E2                 5721 	movx	a,@r0
   18AA F5 82              5722 	mov	dpl,a
   18AC 08                 5723 	inc	r0
   18AD E2                 5724 	movx	a,@r0
   18AE F5 83              5725 	mov	dph,a
   18B0 12 0C 45           5726 	lcall	_rotationController
   18B3 02 1A 09           5727 	ljmp	00135$
   18B6                    5728 00133$:
                    1336   5729 	C$slave_wixel_track.c$972$1$1 ==.
                           5730 ;	apps/slave_wixel_track/slave_wixel_track.c:972: else if (runSubState == 1)
   18B6 78 96              5731 	mov	r0,#_runSubState
   18B8 E2                 5732 	movx	a,@r0
   18B9 B4 01 02           5733 	cjne	a,#0x01,00166$
   18BC 80 03              5734 	sjmp	00167$
   18BE                    5735 00166$:
   18BE 02 1A 09           5736 	ljmp	00135$
   18C1                    5737 00167$:
                    1341   5738 	C$slave_wixel_track.c$975$2$7 ==.
                           5739 ;	apps/slave_wixel_track/slave_wixel_track.c:975: if (isWithinThreshold(filteredX, filteredY, targetX, targetY, GOAL_THRESHOLD))
   18C1 78 17              5740 	mov	r0,#_filteredY
   18C3 79 B2              5741 	mov	r1,#_isWithinThreshold_PARM_2
   18C5 E2                 5742 	movx	a,@r0
   18C6 F3                 5743 	movx	@r1,a
   18C7 08                 5744 	inc	r0
   18C8 E2                 5745 	movx	a,@r0
   18C9 09                 5746 	inc	r1
   18CA F3                 5747 	movx	@r1,a
   18CB 78 B4              5748 	mov	r0,#_isWithinThreshold_PARM_3
   18CD ED                 5749 	mov	a,r5
   18CE F2                 5750 	movx	@r0,a
   18CF 08                 5751 	inc	r0
   18D0 EE                 5752 	mov	a,r6
   18D1 F2                 5753 	movx	@r0,a
   18D2 78 B6              5754 	mov	r0,#_isWithinThreshold_PARM_4
   18D4 EC                 5755 	mov	a,r4
   18D5 F2                 5756 	movx	@r0,a
   18D6 08                 5757 	inc	r0
   18D7 EF                 5758 	mov	a,r7
   18D8 F2                 5759 	movx	@r0,a
   18D9 78 B8              5760 	mov	r0,#_isWithinThreshold_PARM_5
   18DB 74 96              5761 	mov	a,#0x96
   18DD F2                 5762 	movx	@r0,a
   18DE 08                 5763 	inc	r0
   18DF E4                 5764 	clr	a
   18E0 F2                 5765 	movx	@r0,a
   18E1 78 15              5766 	mov	r0,#_filteredX
   18E3 E2                 5767 	movx	a,@r0
   18E4 F5 82              5768 	mov	dpl,a
   18E6 08                 5769 	inc	r0
   18E7 E2                 5770 	movx	a,@r0
   18E8 F5 83              5771 	mov	dph,a
   18EA 12 05 9A           5772 	lcall	_isWithinThreshold
   18ED E5 82              5773 	mov	a,dpl
   18EF 60 19              5774 	jz	00128$
                    1371   5775 	C$slave_wixel_track.c$978$3$8 ==.
                           5776 ;	apps/slave_wixel_track/slave_wixel_track.c:978: currentWaypointIndex++;
   18F1 78 95              5777 	mov	r0,#_currentWaypointIndex
   18F3 E2                 5778 	movx	a,@r0
   18F4 24 01              5779 	add	a,#0x01
   18F6 F2                 5780 	movx	@r0,a
                    1377   5781 	C$slave_wixel_track.c$979$3$8 ==.
                           5782 ;	apps/slave_wixel_track/slave_wixel_track.c:979: runSubState = 0;  // Reset to rotation for next waypoint
   18F7 78 96              5783 	mov	r0,#_runSubState
   18F9 E4                 5784 	clr	a
   18FA F2                 5785 	movx	@r0,a
                    137B   5786 	C$slave_wixel_track.c$980$3$8 ==.
                           5787 ;	apps/slave_wixel_track/slave_wixel_track.c:980: pwm_left = 0;
   18FB 78 27              5788 	mov	r0,#_pwm_left
   18FD E4                 5789 	clr	a
   18FE F2                 5790 	movx	@r0,a
   18FF 08                 5791 	inc	r0
   1900 F2                 5792 	movx	@r0,a
                    1381   5793 	C$slave_wixel_track.c$981$3$8 ==.
                           5794 ;	apps/slave_wixel_track/slave_wixel_track.c:981: pwm_right = 0;
   1901 78 29              5795 	mov	r0,#_pwm_right
   1903 E4                 5796 	clr	a
   1904 F2                 5797 	movx	@r0,a
   1905 08                 5798 	inc	r0
   1906 F2                 5799 	movx	@r0,a
   1907 02 1A 09           5800 	ljmp	00135$
   190A                    5801 00128$:
                    138A   5802 	C$slave_wixel_track.c$986$3$9 ==.
                           5803 ;	apps/slave_wixel_track/slave_wixel_track.c:986: targetHeading = calculateTargetHeading(filteredX, filteredY, targetX, targetY);
   190A 78 17              5804 	mov	r0,#_filteredY
   190C 79 BE              5805 	mov	r1,#_calculateTargetHeading_PARM_2
   190E E2                 5806 	movx	a,@r0
   190F F3                 5807 	movx	@r1,a
   1910 08                 5808 	inc	r0
   1911 E2                 5809 	movx	a,@r0
   1912 09                 5810 	inc	r1
   1913 F3                 5811 	movx	@r1,a
   1914 78 1B              5812 	mov	r0,#_targetX
   1916 79 C0              5813 	mov	r1,#_calculateTargetHeading_PARM_3
   1918 E2                 5814 	movx	a,@r0
   1919 F3                 5815 	movx	@r1,a
   191A 08                 5816 	inc	r0
   191B E2                 5817 	movx	a,@r0
   191C 09                 5818 	inc	r1
   191D F3                 5819 	movx	@r1,a
   191E 78 1F              5820 	mov	r0,#_targetY
   1920 79 C2              5821 	mov	r1,#_calculateTargetHeading_PARM_4
   1922 E2                 5822 	movx	a,@r0
   1923 F3                 5823 	movx	@r1,a
   1924 08                 5824 	inc	r0
   1925 E2                 5825 	movx	a,@r0
   1926 09                 5826 	inc	r1
   1927 F3                 5827 	movx	@r1,a
   1928 78 15              5828 	mov	r0,#_filteredX
   192A E2                 5829 	movx	a,@r0
   192B F5 82              5830 	mov	dpl,a
   192D 08                 5831 	inc	r0
   192E E2                 5832 	movx	a,@r0
   192F F5 83              5833 	mov	dph,a
   1931 12 06 6C           5834 	lcall	_calculateTargetHeading
   1934 AF 82              5835 	mov	r7,dpl
   1936 AE 83              5836 	mov	r6,dph
                    13B8   5837 	C$slave_wixel_track.c$988$3$9 ==.
                           5838 ;	apps/slave_wixel_track/slave_wixel_track.c:988: headingError = targetHeading - filteredTheta;
   1938 78 19              5839 	mov	r0,#_filteredTheta
   193A D3                 5840 	setb	c
   193B E2                 5841 	movx	a,@r0
   193C 9F                 5842 	subb	a,r7
   193D F4                 5843 	cpl	a
   193E B3                 5844 	cpl	c
   193F FD                 5845 	mov	r5,a
   1940 B3                 5846 	cpl	c
   1941 08                 5847 	inc	r0
   1942 E2                 5848 	movx	a,@r0
   1943 9E                 5849 	subb	a,r6
   1944 F4                 5850 	cpl	a
   1945 FC                 5851 	mov	r4,a
                    13C6   5852 	C$slave_wixel_track.c$989$3$9 ==.
                           5853 ;	apps/slave_wixel_track/slave_wixel_track.c:989: if (headingError > 180)
   1946 C3                 5854 	clr	c
   1947 74 B4              5855 	mov	a,#0xB4
   1949 9D                 5856 	subb	a,r5
   194A E4                 5857 	clr	a
   194B 64 80              5858 	xrl	a,#0x80
   194D 8C F0              5859 	mov	b,r4
   194F 63 F0 80           5860 	xrl	b,#0x80
   1952 95 F0              5861 	subb	a,b
   1954 50 08              5862 	jnc	00113$
                    13D6   5863 	C$slave_wixel_track.c$990$3$9 ==.
                           5864 ;	apps/slave_wixel_track/slave_wixel_track.c:990: headingError -= 360;
   1956 ED                 5865 	mov	a,r5
   1957 24 98              5866 	add	a,#0x98
   1959 FD                 5867 	mov	r5,a
   195A EC                 5868 	mov	a,r4
   195B 34 FE              5869 	addc	a,#0xFE
   195D FC                 5870 	mov	r4,a
   195E                    5871 00113$:
                    13DE   5872 	C$slave_wixel_track.c$991$3$9 ==.
                           5873 ;	apps/slave_wixel_track/slave_wixel_track.c:991: if (headingError < -180)
   195E C3                 5874 	clr	c
   195F ED                 5875 	mov	a,r5
   1960 94 4C              5876 	subb	a,#0x4C
   1962 EC                 5877 	mov	a,r4
   1963 64 80              5878 	xrl	a,#0x80
   1965 94 7F              5879 	subb	a,#0x7f
   1967 50 08              5880 	jnc	00115$
                    13E9   5881 	C$slave_wixel_track.c$992$3$9 ==.
                           5882 ;	apps/slave_wixel_track/slave_wixel_track.c:992: headingError += 360;
   1969 74 68              5883 	mov	a,#0x68
   196B 2D                 5884 	add	a,r5
   196C FD                 5885 	mov	r5,a
   196D 74 01              5886 	mov	a,#0x01
   196F 3C                 5887 	addc	a,r4
   1970 FC                 5888 	mov	r4,a
   1971                    5889 00115$:
                    13F1   5890 	C$slave_wixel_track.c$994$3$9 ==.
                           5891 ;	apps/slave_wixel_track/slave_wixel_track.c:994: abs_error = (headingError >= 0) ? headingError : -headingError;
   1971 EC                 5892 	mov	a,r4
   1972 33                 5893 	rlc	a
   1973 B3                 5894 	cpl	c
   1974 E4                 5895 	clr	a
   1975 33                 5896 	rlc	a
   1976 FF                 5897 	mov	r7,a
   1977 60 06              5898 	jz	00139$
   1979 8D 06              5899 	mov	ar6,r5
   197B 8C 07              5900 	mov	ar7,r4
   197D 80 07              5901 	sjmp	00140$
   197F                    5902 00139$:
   197F C3                 5903 	clr	c
   1980 E4                 5904 	clr	a
   1981 9D                 5905 	subb	a,r5
   1982 FE                 5906 	mov	r6,a
   1983 E4                 5907 	clr	a
   1984 9C                 5908 	subb	a,r4
   1985 FF                 5909 	mov	r7,a
   1986                    5910 00140$:
   1986 8E 02              5911 	mov	ar2,r6
   1988 8F 03              5912 	mov	ar3,r7
                    140A   5913 	C$slave_wixel_track.c$997$3$9 ==.
                           5914 ;	apps/slave_wixel_track/slave_wixel_track.c:997: if (abs_error > 45)
   198A C3                 5915 	clr	c
   198B 74 2D              5916 	mov	a,#0x2D
   198D 9A                 5917 	subb	a,r2
   198E E4                 5918 	clr	a
   198F 64 80              5919 	xrl	a,#0x80
   1991 8B F0              5920 	mov	b,r3
   1993 63 F0 80           5921 	xrl	b,#0x80
   1996 95 F0              5922 	subb	a,b
   1998 50 12              5923 	jnc	00125$
                    141A   5924 	C$slave_wixel_track.c$999$4$10 ==.
                           5925 ;	apps/slave_wixel_track/slave_wixel_track.c:999: runSubState = 0;  // Back to rotation phase
   199A 78 96              5926 	mov	r0,#_runSubState
   199C E4                 5927 	clr	a
   199D F2                 5928 	movx	@r0,a
                    141E   5929 	C$slave_wixel_track.c$1000$4$10 ==.
                           5930 ;	apps/slave_wixel_track/slave_wixel_track.c:1000: pwm_left = 0;
   199E 78 27              5931 	mov	r0,#_pwm_left
   19A0 E4                 5932 	clr	a
   19A1 F2                 5933 	movx	@r0,a
   19A2 08                 5934 	inc	r0
   19A3 F2                 5935 	movx	@r0,a
                    1424   5936 	C$slave_wixel_track.c$1001$4$10 ==.
                           5937 ;	apps/slave_wixel_track/slave_wixel_track.c:1001: pwm_right = 0;
   19A4 78 29              5938 	mov	r0,#_pwm_right
   19A6 E4                 5939 	clr	a
   19A7 F2                 5940 	movx	@r0,a
   19A8 08                 5941 	inc	r0
   19A9 F2                 5942 	movx	@r0,a
   19AA 80 5D              5943 	sjmp	00135$
   19AC                    5944 00125$:
                    142C   5945 	C$slave_wixel_track.c$1006$4$11 ==.
                           5946 ;	apps/slave_wixel_track/slave_wixel_track.c:1006: int16 steeringAdjust = (headingError * STEERING_KP);
   19AC 8D 06              5947 	mov	ar6,r5
   19AE EC                 5948 	mov	a,r4
   19AF CE                 5949 	xch	a,r6
   19B0 25 E0              5950 	add	a,acc
   19B2 CE                 5951 	xch	a,r6
   19B3 33                 5952 	rlc	a
   19B4 FF                 5953 	mov	r7,a
                    1435   5954 	C$slave_wixel_track.c$1009$4$11 ==.
                           5955 ;	apps/slave_wixel_track/slave_wixel_track.c:1009: if (steeringAdjust > MAX_STEERING_ADJUST)
   19B5 C3                 5956 	clr	c
   19B6 74 1E              5957 	mov	a,#0x1E
   19B8 9E                 5958 	subb	a,r6
   19B9 E4                 5959 	clr	a
   19BA 64 80              5960 	xrl	a,#0x80
   19BC 8F F0              5961 	mov	b,r7
   19BE 63 F0 80           5962 	xrl	b,#0x80
   19C1 95 F0              5963 	subb	a,b
   19C3 50 04              5964 	jnc	00117$
                    1445   5965 	C$slave_wixel_track.c$1010$4$11 ==.
                           5966 ;	apps/slave_wixel_track/slave_wixel_track.c:1010: steeringAdjust = MAX_STEERING_ADJUST;
   19C5 7E 1E              5967 	mov	r6,#0x1E
   19C7 7F 00              5968 	mov	r7,#0x00
   19C9                    5969 00117$:
                    1449   5970 	C$slave_wixel_track.c$1011$4$11 ==.
                           5971 ;	apps/slave_wixel_track/slave_wixel_track.c:1011: if (steeringAdjust < -MAX_STEERING_ADJUST)
   19C9 C3                 5972 	clr	c
   19CA EE                 5973 	mov	a,r6
   19CB 94 E2              5974 	subb	a,#0xE2
   19CD EF                 5975 	mov	a,r7
   19CE 64 80              5976 	xrl	a,#0x80
   19D0 94 7F              5977 	subb	a,#0x7f
   19D2 50 04              5978 	jnc	00119$
                    1454   5979 	C$slave_wixel_track.c$1012$4$11 ==.
                           5980 ;	apps/slave_wixel_track/slave_wixel_track.c:1012: steeringAdjust = -MAX_STEERING_ADJUST;
   19D4 7E E2              5981 	mov	r6,#0xE2
   19D6 7F FF              5982 	mov	r7,#0xFF
   19D8                    5983 00119$:
                    1458   5984 	C$slave_wixel_track.c$1015$4$11 ==.
                           5985 ;	apps/slave_wixel_track/slave_wixel_track.c:1015: pwm_left = FORWARD_SPEED_PWM - steeringAdjust;
   19D8 74 50              5986 	mov	a,#0x50
   19DA C3                 5987 	clr	c
   19DB 9E                 5988 	subb	a,r6
   19DC FC                 5989 	mov	r4,a
   19DD E4                 5990 	clr	a
   19DE 9F                 5991 	subb	a,r7
   19DF FD                 5992 	mov	r5,a
   19E0 78 27              5993 	mov	r0,#_pwm_left
   19E2 EC                 5994 	mov	a,r4
   19E3 F2                 5995 	movx	@r0,a
   19E4 08                 5996 	inc	r0
   19E5 ED                 5997 	mov	a,r5
   19E6 F2                 5998 	movx	@r0,a
                    1467   5999 	C$slave_wixel_track.c$1016$4$11 ==.
                           6000 ;	apps/slave_wixel_track/slave_wixel_track.c:1016: pwm_right = FORWARD_SPEED_PWM + steeringAdjust;
   19E7 74 50              6001 	mov	a,#0x50
   19E9 2E                 6002 	add	a,r6
   19EA FE                 6003 	mov	r6,a
   19EB E4                 6004 	clr	a
   19EC 3F                 6005 	addc	a,r7
   19ED FF                 6006 	mov	r7,a
   19EE 78 29              6007 	mov	r0,#_pwm_right
   19F0 EE                 6008 	mov	a,r6
   19F1 F2                 6009 	movx	@r0,a
   19F2 08                 6010 	inc	r0
   19F3 EF                 6011 	mov	a,r7
   19F4 F2                 6012 	movx	@r0,a
                    1475   6013 	C$slave_wixel_track.c$1019$4$11 ==.
                           6014 ;	apps/slave_wixel_track/slave_wixel_track.c:1019: if (pwm_left < 0) pwm_left = 0;
   19F5 ED                 6015 	mov	a,r5
   19F6 30 E7 06           6016 	jnb	acc.7,00121$
   19F9 78 27              6017 	mov	r0,#_pwm_left
   19FB E4                 6018 	clr	a
   19FC F2                 6019 	movx	@r0,a
   19FD 08                 6020 	inc	r0
   19FE F2                 6021 	movx	@r0,a
   19FF                    6022 00121$:
                    147F   6023 	C$slave_wixel_track.c$1020$4$11 ==.
                           6024 ;	apps/slave_wixel_track/slave_wixel_track.c:1020: if (pwm_right < 0) pwm_right = 0;
   19FF EF                 6025 	mov	a,r7
   1A00 30 E7 06           6026 	jnb	acc.7,00135$
   1A03 78 29              6027 	mov	r0,#_pwm_right
   1A05 E4                 6028 	clr	a
   1A06 F2                 6029 	movx	@r0,a
   1A07 08                 6030 	inc	r0
   1A08 F2                 6031 	movx	@r0,a
   1A09                    6032 00135$:
                    1489   6033 	C$slave_wixel_track.c$1024$2$1 ==.
                    1489   6034 	XG$updateRunState$0$0 ==.
   1A09 22                 6035 	ret
                           6036 ;------------------------------------------------------------
                           6037 ;Allocation info for local variables in function 'updateStateMachine'
                           6038 ;------------------------------------------------------------
                    148A   6039 	G$updateStateMachine$0$0 ==.
                    148A   6040 	C$slave_wixel_track.c$1026$2$1 ==.
                           6041 ;	apps/slave_wixel_track/slave_wixel_track.c:1026: void updateStateMachine()
                           6042 ;	-----------------------------------------
                           6043 ;	 function updateStateMachine
                           6044 ;	-----------------------------------------
   1A0A                    6045 _updateStateMachine:
                    148A   6046 	C$slave_wixel_track.c$1028$1$1 ==.
                           6047 ;	apps/slave_wixel_track/slave_wixel_track.c:1028: switch(currentState)
   1A0A 78 00              6048 	mov	r0,#_currentState
   1A0C E2                 6049 	movx	a,@r0
   1A0D 60 24              6050 	jz	00101$
   1A0F 78 00              6051 	mov	r0,#_currentState
   1A11 E2                 6052 	movx	a,@r0
   1A12 B4 01 02           6053 	cjne	a,#0x01,00124$
   1A15 80 22              6054 	sjmp	00102$
   1A17                    6055 00124$:
   1A17 78 00              6056 	mov	r0,#_currentState
   1A19 E2                 6057 	movx	a,@r0
   1A1A B4 02 02           6058 	cjne	a,#0x02,00125$
   1A1D 80 20              6059 	sjmp	00103$
   1A1F                    6060 00125$:
   1A1F 78 00              6061 	mov	r0,#_currentState
   1A21 E2                 6062 	movx	a,@r0
   1A22 B4 03 03           6063 	cjne	a,#0x03,00126$
   1A25 02 1A F4           6064 	ljmp	00113$
   1A28                    6065 00126$:
   1A28 78 00              6066 	mov	r0,#_currentState
   1A2A E2                 6067 	movx	a,@r0
   1A2B B4 10 02           6068 	cjne	a,#0x10,00127$
   1A2E 80 15              6069 	sjmp	00105$
   1A30                    6070 00127$:
   1A30 02 1A F4           6071 	ljmp	00113$
                    14B3   6072 	C$slave_wixel_track.c$1030$2$2 ==.
                           6073 ;	apps/slave_wixel_track/slave_wixel_track.c:1030: case STATE_IDLE:
   1A33                    6074 00101$:
                    14B3   6075 	C$slave_wixel_track.c$1031$2$2 ==.
                           6076 ;	apps/slave_wixel_track/slave_wixel_track.c:1031: stopMotors();
   1A33 12 0D E2           6077 	lcall	_stopMotors
                    14B6   6078 	C$slave_wixel_track.c$1032$2$2 ==.
                           6079 ;	apps/slave_wixel_track/slave_wixel_track.c:1032: break;
   1A36 02 1A F4           6080 	ljmp	00113$
                    14B9   6081 	C$slave_wixel_track.c$1033$2$2 ==.
                           6082 ;	apps/slave_wixel_track/slave_wixel_track.c:1033: case STATE_HOME:
   1A39                    6083 00102$:
                    14B9   6084 	C$slave_wixel_track.c$1034$2$2 ==.
                           6085 ;	apps/slave_wixel_track/slave_wixel_track.c:1034: updateHomeState();
   1A39 12 14 F0           6086 	lcall	_updateHomeState
                    14BC   6087 	C$slave_wixel_track.c$1035$2$2 ==.
                           6088 ;	apps/slave_wixel_track/slave_wixel_track.c:1035: break;
   1A3C 02 1A F4           6089 	ljmp	00113$
                    14BF   6090 	C$slave_wixel_track.c$1036$2$2 ==.
                           6091 ;	apps/slave_wixel_track/slave_wixel_track.c:1036: case STATE_RUN:
   1A3F                    6092 00103$:
                    14BF   6093 	C$slave_wixel_track.c$1037$2$2 ==.
                           6094 ;	apps/slave_wixel_track/slave_wixel_track.c:1037: updateRunState();
   1A3F 12 17 60           6095 	lcall	_updateRunState
                    14C2   6096 	C$slave_wixel_track.c$1038$2$2 ==.
                           6097 ;	apps/slave_wixel_track/slave_wixel_track.c:1038: break;
   1A42 02 1A F4           6098 	ljmp	00113$
                    14C5   6099 	C$slave_wixel_track.c$1042$2$2 ==.
                           6100 ;	apps/slave_wixel_track/slave_wixel_track.c:1042: case STATE_CALIBRATE_VALIDATE:
   1A45                    6101 00105$:
                    14C5   6102 	C$slave_wixel_track.c$1043$2$2 ==.
                           6103 ;	apps/slave_wixel_track/slave_wixel_track.c:1043: cal_targetHeading = calculateTargetHeading(filteredX, filteredY, 0, 0);
   1A45 78 17              6104 	mov	r0,#_filteredY
   1A47 79 BE              6105 	mov	r1,#_calculateTargetHeading_PARM_2
   1A49 E2                 6106 	movx	a,@r0
   1A4A F3                 6107 	movx	@r1,a
   1A4B 08                 6108 	inc	r0
   1A4C E2                 6109 	movx	a,@r0
   1A4D 09                 6110 	inc	r1
   1A4E F3                 6111 	movx	@r1,a
   1A4F 78 C0              6112 	mov	r0,#_calculateTargetHeading_PARM_3
   1A51 E4                 6113 	clr	a
   1A52 F2                 6114 	movx	@r0,a
   1A53 08                 6115 	inc	r0
   1A54 F2                 6116 	movx	@r0,a
   1A55 78 C2              6117 	mov	r0,#_calculateTargetHeading_PARM_4
   1A57 E4                 6118 	clr	a
   1A58 F2                 6119 	movx	@r0,a
   1A59 08                 6120 	inc	r0
   1A5A F2                 6121 	movx	@r0,a
   1A5B 78 15              6122 	mov	r0,#_filteredX
   1A5D E2                 6123 	movx	a,@r0
   1A5E F5 82              6124 	mov	dpl,a
   1A60 08                 6125 	inc	r0
   1A61 E2                 6126 	movx	a,@r0
   1A62 F5 83              6127 	mov	dph,a
   1A64 12 06 6C           6128 	lcall	_calculateTargetHeading
   1A67 AE 82              6129 	mov	r6,dpl
   1A69 AF 83              6130 	mov	r7,dph
   1A6B 78 AD              6131 	mov	r0,#_cal_targetHeading
   1A6D EE                 6132 	mov	a,r6
   1A6E F2                 6133 	movx	@r0,a
   1A6F 08                 6134 	inc	r0
   1A70 EF                 6135 	mov	a,r7
   1A71 F2                 6136 	movx	@r0,a
                    14F2   6137 	C$slave_wixel_track.c$1044$2$2 ==.
                           6138 ;	apps/slave_wixel_track/slave_wixel_track.c:1044: rotationController(filteredTheta, cal_targetHeading);
   1A72 78 D6              6139 	mov	r0,#_rotationController_PARM_2
   1A74 EE                 6140 	mov	a,r6
   1A75 F2                 6141 	movx	@r0,a
   1A76 08                 6142 	inc	r0
   1A77 EF                 6143 	mov	a,r7
   1A78 F2                 6144 	movx	@r0,a
   1A79 78 19              6145 	mov	r0,#_filteredTheta
   1A7B E2                 6146 	movx	a,@r0
   1A7C F5 82              6147 	mov	dpl,a
   1A7E 08                 6148 	inc	r0
   1A7F E2                 6149 	movx	a,@r0
   1A80 F5 83              6150 	mov	dph,a
   1A82 12 0C 45           6151 	lcall	_rotationController
                    1505   6152 	C$slave_wixel_track.c$1046$2$2 ==.
                           6153 ;	apps/slave_wixel_track/slave_wixel_track.c:1046: cal_headingError = cal_targetHeading - filteredTheta;
   1A85 78 AD              6154 	mov	r0,#_cal_targetHeading
   1A87 79 19              6155 	mov	r1,#_filteredTheta
   1A89 E3                 6156 	movx	a,@r1
   1A8A F5 F0              6157 	mov	b,a
   1A8C C3                 6158 	clr	c
   1A8D E2                 6159 	movx	a,@r0
   1A8E 95 F0              6160 	subb	a,b
   1A90 FE                 6161 	mov	r6,a
   1A91 09                 6162 	inc	r1
   1A92 E3                 6163 	movx	a,@r1
   1A93 F5 F0              6164 	mov	b,a
   1A95 08                 6165 	inc	r0
   1A96 E2                 6166 	movx	a,@r0
   1A97 95 F0              6167 	subb	a,b
   1A99 FF                 6168 	mov	r7,a
   1A9A 78 AF              6169 	mov	r0,#_cal_headingError
   1A9C EE                 6170 	mov	a,r6
   1A9D F2                 6171 	movx	@r0,a
   1A9E 08                 6172 	inc	r0
   1A9F EF                 6173 	mov	a,r7
   1AA0 F2                 6174 	movx	@r0,a
                    1521   6175 	C$slave_wixel_track.c$1047$2$2 ==.
                           6176 ;	apps/slave_wixel_track/slave_wixel_track.c:1047: if (cal_headingError > 180) cal_headingError -= 360;
   1AA1 C3                 6177 	clr	c
   1AA2 74 B4              6178 	mov	a,#0xB4
   1AA4 9E                 6179 	subb	a,r6
   1AA5 E4                 6180 	clr	a
   1AA6 64 80              6181 	xrl	a,#0x80
   1AA8 8F F0              6182 	mov	b,r7
   1AAA 63 F0 80           6183 	xrl	b,#0x80
   1AAD 95 F0              6184 	subb	a,b
   1AAF 50 0B              6185 	jnc	00107$
   1AB1 78 AF              6186 	mov	r0,#_cal_headingError
   1AB3 EE                 6187 	mov	a,r6
   1AB4 24 98              6188 	add	a,#0x98
   1AB6 F2                 6189 	movx	@r0,a
   1AB7 EF                 6190 	mov	a,r7
   1AB8 34 FE              6191 	addc	a,#0xFE
   1ABA 08                 6192 	inc	r0
   1ABB F2                 6193 	movx	@r0,a
   1ABC                    6194 00107$:
                    153C   6195 	C$slave_wixel_track.c$1048$2$2 ==.
                           6196 ;	apps/slave_wixel_track/slave_wixel_track.c:1048: if (cal_headingError < -180) cal_headingError += 360;
   1ABC 78 AF              6197 	mov	r0,#_cal_headingError
   1ABE C3                 6198 	clr	c
   1ABF E2                 6199 	movx	a,@r0
   1AC0 94 4C              6200 	subb	a,#0x4C
   1AC2 08                 6201 	inc	r0
   1AC3 E2                 6202 	movx	a,@r0
   1AC4 64 80              6203 	xrl	a,#0x80
   1AC6 94 7F              6204 	subb	a,#0x7f
   1AC8 50 0B              6205 	jnc	00109$
   1ACA 78 AF              6206 	mov	r0,#_cal_headingError
   1ACC E2                 6207 	movx	a,@r0
   1ACD 24 68              6208 	add	a,#0x68
   1ACF F2                 6209 	movx	@r0,a
   1AD0 08                 6210 	inc	r0
   1AD1 E2                 6211 	movx	a,@r0
   1AD2 34 01              6212 	addc	a,#0x01
   1AD4 F2                 6213 	movx	@r0,a
   1AD5                    6214 00109$:
                    1555   6215 	C$slave_wixel_track.c$1050$2$2 ==.
                           6216 ;	apps/slave_wixel_track/slave_wixel_track.c:1050: if (abs16(cal_headingError) < HEADING_THRESHOLD)
   1AD5 78 AF              6217 	mov	r0,#_cal_headingError
   1AD7 E2                 6218 	movx	a,@r0
   1AD8 F5 82              6219 	mov	dpl,a
   1ADA 08                 6220 	inc	r0
   1ADB E2                 6221 	movx	a,@r0
   1ADC F5 83              6222 	mov	dph,a
   1ADE 12 05 80           6223 	lcall	_abs16
   1AE1 AE 82              6224 	mov	r6,dpl
   1AE3 AF 83              6225 	mov	r7,dph
   1AE5 C3                 6226 	clr	c
   1AE6 EE                 6227 	mov	a,r6
   1AE7 94 05              6228 	subb	a,#0x05
   1AE9 EF                 6229 	mov	a,r7
   1AEA 64 80              6230 	xrl	a,#0x80
   1AEC 94 80              6231 	subb	a,#0x80
   1AEE 50 04              6232 	jnc	00113$
                    1570   6233 	C$slave_wixel_track.c$1052$3$3 ==.
                           6234 ;	apps/slave_wixel_track/slave_wixel_track.c:1052: currentState = STATE_IDLE;
   1AF0 78 00              6235 	mov	r0,#_currentState
   1AF2 E4                 6236 	clr	a
   1AF3 F2                 6237 	movx	@r0,a
                    1574   6238 	C$slave_wixel_track.c$1055$1$1 ==.
                           6239 ;	apps/slave_wixel_track/slave_wixel_track.c:1055: }
   1AF4                    6240 00113$:
                    1574   6241 	C$slave_wixel_track.c$1056$1$1 ==.
                    1574   6242 	XG$updateStateMachine$0$0 ==.
   1AF4 22                 6243 	ret
                           6244 ;------------------------------------------------------------
                           6245 ;Allocation info for local variables in function 'main'
                           6246 ;------------------------------------------------------------
                    1575   6247 	G$main$0$0 ==.
                    1575   6248 	C$slave_wixel_track.c$1060$1$1 ==.
                           6249 ;	apps/slave_wixel_track/slave_wixel_track.c:1060: void main()
                           6250 ;	-----------------------------------------
                           6251 ;	 function main
                           6252 ;	-----------------------------------------
   1AF5                    6253 _main:
                    1575   6254 	C$slave_wixel_track.c$1062$1$1 ==.
                           6255 ;	apps/slave_wixel_track/slave_wixel_track.c:1062: systemInit();
   1AF5 12 1D 85           6256 	lcall	_systemInit
                    1578   6257 	C$slave_wixel_track.c$1063$1$1 ==.
                           6258 ;	apps/slave_wixel_track/slave_wixel_track.c:1063: gpioInit();
   1AF8 12 0E 4E           6259 	lcall	_gpioInit
                    157B   6260 	C$slave_wixel_track.c$1064$1$1 ==.
                           6261 ;	apps/slave_wixel_track/slave_wixel_track.c:1064: timer3Init();
   1AFB 12 0D 91           6262 	lcall	_timer3Init
                    157E   6263 	C$slave_wixel_track.c$1065$1$1 ==.
                           6264 ;	apps/slave_wixel_track/slave_wixel_track.c:1065: radioInit();
   1AFE 12 0D ED           6265 	lcall	_radioInit
                    1581   6266 	C$slave_wixel_track.c$1067$1$1 ==.
                           6267 ;	apps/slave_wixel_track/slave_wixel_track.c:1067: lastPacketTime = (uint16)getMs();
   1B01 12 20 8C           6268 	lcall	_getMs
   1B04 AC 82              6269 	mov	r4,dpl
   1B06 AD 83              6270 	mov	r5,dph
   1B08 78 03              6271 	mov	r0,#_lastPacketTime
   1B0A EC                 6272 	mov	a,r4
   1B0B F2                 6273 	movx	@r0,a
   1B0C 08                 6274 	inc	r0
   1B0D ED                 6275 	mov	a,r5
   1B0E F2                 6276 	movx	@r0,a
                    158F   6277 	C$slave_wixel_track.c$1070$1$1 ==.
                           6278 ;	apps/slave_wixel_track/slave_wixel_track.c:1070: P1_2 = 0; P1_1 = 1; P1_7 = 1; delayMs(300);  // RED
   1B0F C2 92              6279 	clr	_P1_2
   1B11 D2 91              6280 	setb	_P1_1
   1B13 D2 97              6281 	setb	_P1_7
   1B15 90 01 2C           6282 	mov	dptr,#0x012C
   1B18 12 20 B8           6283 	lcall	_delayMs
                    159B   6284 	C$slave_wixel_track.c$1071$1$1 ==.
                           6285 ;	apps/slave_wixel_track/slave_wixel_track.c:1071: P1_2 = 1; P1_1 = 0; P1_7 = 1; delayMs(300);  // GREEN
   1B1B D2 92              6286 	setb	_P1_2
   1B1D C2 91              6287 	clr	_P1_1
   1B1F D2 97              6288 	setb	_P1_7
   1B21 90 01 2C           6289 	mov	dptr,#0x012C
   1B24 12 20 B8           6290 	lcall	_delayMs
                    15A7   6291 	C$slave_wixel_track.c$1072$1$1 ==.
                           6292 ;	apps/slave_wixel_track/slave_wixel_track.c:1072: P1_2 = 1; P1_1 = 1; P1_7 = 0; delayMs(300);  // BLUE
   1B27 D2 92              6293 	setb	_P1_2
   1B29 D2 91              6294 	setb	_P1_1
   1B2B C2 97              6295 	clr	_P1_7
   1B2D 90 01 2C           6296 	mov	dptr,#0x012C
   1B30 12 20 B8           6297 	lcall	_delayMs
                    15B3   6298 	C$slave_wixel_track.c$1073$1$1 ==.
                           6299 ;	apps/slave_wixel_track/slave_wixel_track.c:1073: P1_2 = 0; P1_1 = 1; P1_7 = 0; delayMs(300);  // PURPLE
   1B33 C2 92              6300 	clr	_P1_2
   1B35 D2 91              6301 	setb	_P1_1
   1B37 C2 97              6302 	clr	_P1_7
   1B39 90 01 2C           6303 	mov	dptr,#0x012C
   1B3C 12 20 B8           6304 	lcall	_delayMs
                    15BF   6305 	C$slave_wixel_track.c$1074$1$1 ==.
                           6306 ;	apps/slave_wixel_track/slave_wixel_track.c:1074: P1_2 = 1; P1_1 = 1; P1_7 = 1; delayMs(500);  // OFF
   1B3F D2 92              6307 	setb	_P1_2
   1B41 D2 91              6308 	setb	_P1_1
   1B43 D2 97              6309 	setb	_P1_7
   1B45 90 01 F4           6310 	mov	dptr,#0x01F4
   1B48 12 20 B8           6311 	lcall	_delayMs
                    15CB   6312 	C$slave_wixel_track.c$1076$1$1 ==.
                           6313 ;	apps/slave_wixel_track/slave_wixel_track.c:1076: lastPacketTime = (uint16)getMs();
   1B4B 12 20 8C           6314 	lcall	_getMs
   1B4E AC 82              6315 	mov	r4,dpl
   1B50 AD 83              6316 	mov	r5,dph
   1B52 AE F0              6317 	mov	r6,b
   1B54 FF                 6318 	mov	r7,a
   1B55 78 03              6319 	mov	r0,#_lastPacketTime
   1B57 EC                 6320 	mov	a,r4
   1B58 F2                 6321 	movx	@r0,a
   1B59 08                 6322 	inc	r0
   1B5A ED                 6323 	mov	a,r5
   1B5B F2                 6324 	movx	@r0,a
                    15DC   6325 	C$slave_wixel_track.c$1077$1$1 ==.
                           6326 ;	apps/slave_wixel_track/slave_wixel_track.c:1077: currentState = STATE_IDLE;
   1B5C 78 00              6327 	mov	r0,#_currentState
   1B5E E4                 6328 	clr	a
   1B5F F2                 6329 	movx	@r0,a
                    15E0   6330 	C$slave_wixel_track.c$1080$1$1 ==.
                           6331 ;	apps/slave_wixel_track/slave_wixel_track.c:1080: while(1)
   1B60                    6332 00107$:
                    15E0   6333 	C$slave_wixel_track.c$1082$2$2 ==.
                           6334 ;	apps/slave_wixel_track/slave_wixel_track.c:1082: boardService();
   1B60 12 1D 92           6335 	lcall	_boardService
                    15E3   6336 	C$slave_wixel_track.c$1084$2$2 ==.
                           6337 ;	apps/slave_wixel_track/slave_wixel_track.c:1084: now = (uint32)getMs();
   1B63 12 20 8C           6338 	lcall	_getMs
   1B66 AC 82              6339 	mov	r4,dpl
   1B68 AD 83              6340 	mov	r5,dph
   1B6A AE F0              6341 	mov	r6,b
   1B6C FF                 6342 	mov	r7,a
   1B6D 78 07              6343 	mov	r0,#_now
   1B6F EC                 6344 	mov	a,r4
   1B70 F2                 6345 	movx	@r0,a
   1B71 08                 6346 	inc	r0
   1B72 ED                 6347 	mov	a,r5
   1B73 F2                 6348 	movx	@r0,a
   1B74 08                 6349 	inc	r0
   1B75 EE                 6350 	mov	a,r6
   1B76 F2                 6351 	movx	@r0,a
   1B77 08                 6352 	inc	r0
   1B78 EF                 6353 	mov	a,r7
   1B79 F2                 6354 	movx	@r0,a
                    15FA   6355 	C$slave_wixel_track.c$1087$2$2 ==.
                           6356 ;	apps/slave_wixel_track/slave_wixel_track.c:1087: counter_loop++;
   1B7A 78 05              6357 	mov	r0,#_counter_loop
   1B7C E2                 6358 	movx	a,@r0
   1B7D 24 01              6359 	add	a,#0x01
   1B7F F2                 6360 	movx	@r0,a
   1B80 08                 6361 	inc	r0
   1B81 E2                 6362 	movx	a,@r0
   1B82 34 00              6363 	addc	a,#0x00
   1B84 F2                 6364 	movx	@r0,a
                    1605   6365 	C$slave_wixel_track.c$1088$1$1 ==.
                           6366 ;	apps/slave_wixel_track/slave_wixel_track.c:1088: counter_loop %= 5001;
   1B85 78 F7              6367 	mov	r0,#__moduint_PARM_2
   1B87 74 89              6368 	mov	a,#0x89
   1B89 F2                 6369 	movx	@r0,a
   1B8A 08                 6370 	inc	r0
   1B8B 74 13              6371 	mov	a,#0x13
   1B8D F2                 6372 	movx	@r0,a
   1B8E 78 05              6373 	mov	r0,#_counter_loop
   1B90 E2                 6374 	movx	a,@r0
   1B91 F5 82              6375 	mov	dpl,a
   1B93 08                 6376 	inc	r0
   1B94 E2                 6377 	movx	a,@r0
   1B95 F5 83              6378 	mov	dph,a
   1B97 12 1F DB           6379 	lcall	__moduint
   1B9A E5 82              6380 	mov	a,dpl
   1B9C 85 83 F0           6381 	mov	b,dph
   1B9F 78 05              6382 	mov	r0,#_counter_loop
   1BA1 F2                 6383 	movx	@r0,a
   1BA2 08                 6384 	inc	r0
   1BA3 E5 F0              6385 	mov	a,b
   1BA5 F2                 6386 	movx	@r0,a
                    1626   6387 	C$slave_wixel_track.c$1089$1$1 ==.
                           6388 ;	apps/slave_wixel_track/slave_wixel_track.c:1089: if (counter_loop % 500 == 0)
   1BA6 78 F7              6389 	mov	r0,#__moduint_PARM_2
   1BA8 74 F4              6390 	mov	a,#0xF4
   1BAA F2                 6391 	movx	@r0,a
   1BAB 08                 6392 	inc	r0
   1BAC 74 01              6393 	mov	a,#0x01
   1BAE F2                 6394 	movx	@r0,a
   1BAF 78 05              6395 	mov	r0,#_counter_loop
   1BB1 E2                 6396 	movx	a,@r0
   1BB2 F5 82              6397 	mov	dpl,a
   1BB4 08                 6398 	inc	r0
   1BB5 E2                 6399 	movx	a,@r0
   1BB6 F5 83              6400 	mov	dph,a
   1BB8 12 1F DB           6401 	lcall	__moduint
   1BBB E5 82              6402 	mov	a,dpl
   1BBD 85 83 F0           6403 	mov	b,dph
   1BC0 45 F0              6404 	orl	a,b
   1BC2 70 03              6405 	jnz	00102$
                    1644   6406 	C$slave_wixel_track.c$1090$3$3 ==.
                           6407 ;	apps/slave_wixel_track/slave_wixel_track.c:1090: LED_YELLOW_TOGGLE();
   1BC4 63 FF 04           6408 	xrl	_P2DIR,#0x04
   1BC7                    6409 00102$:
                    1647   6410 	C$slave_wixel_track.c$1093$2$2 ==.
                           6411 ;	apps/slave_wixel_track/slave_wixel_track.c:1093: receiveAndProcessPackets();
   1BC7 12 13 D9           6412 	lcall	_receiveAndProcessPackets
                    164A   6413 	C$slave_wixel_track.c$1096$2$2 ==.
                           6414 ;	apps/slave_wixel_track/slave_wixel_track.c:1096: if (rxPulseStart < 600)
   1BCA 78 0B              6415 	mov	r0,#_rxPulseStart
   1BCC C3                 6416 	clr	c
   1BCD E2                 6417 	movx	a,@r0
   1BCE 94 58              6418 	subb	a,#0x58
   1BD0 08                 6419 	inc	r0
   1BD1 E2                 6420 	movx	a,@r0
   1BD2 94 02              6421 	subb	a,#0x02
   1BD4 08                 6422 	inc	r0
   1BD5 E2                 6423 	movx	a,@r0
   1BD6 94 00              6424 	subb	a,#0x00
   1BD8 08                 6425 	inc	r0
   1BD9 E2                 6426 	movx	a,@r0
   1BDA 94 00              6427 	subb	a,#0x00
   1BDC 50 1A              6428 	jnc	00104$
                    165E   6429 	C$slave_wixel_track.c$1098$4$5 ==.
                           6430 ;	apps/slave_wixel_track/slave_wixel_track.c:1098: LED_RED(1);
   1BDE 43 FF 02           6431 	orl	_P2DIR,#0x02
                    1661   6432 	C$slave_wixel_track.c$1099$3$4 ==.
                           6433 ;	apps/slave_wixel_track/slave_wixel_track.c:1099: rxPulseStart += 1;
   1BE1 78 0B              6434 	mov	r0,#_rxPulseStart
   1BE3 E2                 6435 	movx	a,@r0
   1BE4 24 01              6436 	add	a,#0x01
   1BE6 F2                 6437 	movx	@r0,a
   1BE7 08                 6438 	inc	r0
   1BE8 E2                 6439 	movx	a,@r0
   1BE9 34 00              6440 	addc	a,#0x00
   1BEB F2                 6441 	movx	@r0,a
   1BEC 08                 6442 	inc	r0
   1BED E2                 6443 	movx	a,@r0
   1BEE 34 00              6444 	addc	a,#0x00
   1BF0 F2                 6445 	movx	@r0,a
   1BF1 08                 6446 	inc	r0
   1BF2 E2                 6447 	movx	a,@r0
   1BF3 34 00              6448 	addc	a,#0x00
   1BF5 F2                 6449 	movx	@r0,a
   1BF6 80 07              6450 	sjmp	00105$
   1BF8                    6451 00104$:
                    1678   6452 	C$slave_wixel_track.c$1103$4$7 ==.
                           6453 ;	apps/slave_wixel_track/slave_wixel_track.c:1103: LED_RED(0);
   1BF8 AF FF              6454 	mov	r7,_P2DIR
   1BFA 53 07 FD           6455 	anl	ar7,#0xFD
   1BFD 8F FF              6456 	mov	_P2DIR,r7
   1BFF                    6457 00105$:
                    167F   6458 	C$slave_wixel_track.c$1107$2$2 ==.
                           6459 ;	apps/slave_wixel_track/slave_wixel_track.c:1107: handlePacketTimeout();
   1BFF 12 14 96           6460 	lcall	_handlePacketTimeout
                    1682   6461 	C$slave_wixel_track.c$1108$2$2 ==.
                           6462 ;	apps/slave_wixel_track/slave_wixel_track.c:1108: updateStateMachine();
   1C02 12 1A 0A           6463 	lcall	_updateStateMachine
                    1685   6464 	C$slave_wixel_track.c$1109$2$2 ==.
                           6465 ;	apps/slave_wixel_track/slave_wixel_track.c:1109: updateRgbLeds();
   1C05 12 0E 7A           6466 	lcall	_updateRgbLeds
                    1688   6467 	C$slave_wixel_track.c$1110$2$2 ==.
                           6468 ;	apps/slave_wixel_track/slave_wixel_track.c:1110: setMotorsPWM();
   1C08 12 0D AB           6469 	lcall	_setMotorsPWM
   1C0B 02 1B 60           6470 	ljmp	00107$
                    168E   6471 	C$slave_wixel_track.c$1112$1$1 ==.
                    168E   6472 	XG$main$0$0 ==.
   1C0E 22                 6473 	ret
                           6474 	.area CSEG    (CODE)
                           6475 	.area CONST   (CODE)
                           6476 	.area XINIT   (CODE)
                           6477 	.area CABS    (ABS,CODE)
