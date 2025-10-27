;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.1.0 #7066 (Nov 22 2011) (MINGW32)
; This file was generated Sun Oct 26 20:56:14 2025
;--------------------------------------------------------
	.module slave_wixel_track
	.optsdcc -mmcs51 --model-medium
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _updateStateMachine
	.globl _updateRunState
	.globl _updateHomeState
	.globl _handlePacketTimeout
	.globl _receiveAndProcessPackets
	.globl _handleCmdCalibrate
	.globl _handleCmdAux
	.globl _executeManualPwm
	.globl _handleCmdRun
	.globl _handleCmdPrep
	.globl _handleCmdGoTo
	.globl _handleCmdStop
	.globl _extractPositionData
	.globl _updateRgbLeds
	.globl _gpioInit
	.globl _radioInit
	.globl _stopMotors
	.globl _setMotorsPWM
	.globl _timer3Init
	.globl _rotationController
	.globl _filterPosition
	.globl _calculateAndApplyOffset
	.globl _calculateTargetHeading
	.globl _isWithinThreshold
	.globl _abs16
	.globl _radioCrcPassed
	.globl _radioRegistersInit
	.globl _delayMs
	.globl _getMs
	.globl _boardService
	.globl _systemInit
	.globl _rotationController_PARM_2
	.globl _calculateTargetHeading_PARM_4
	.globl _calculateTargetHeading_PARM_3
	.globl _calculateTargetHeading_PARM_2
	.globl _isWithinThreshold_PARM_5
	.globl _isWithinThreshold_PARM_4
	.globl _isWithinThreshold_PARM_3
	.globl _isWithinThreshold_PARM_2
	.globl _calib_step
	.globl _cal_headingError
	.globl _cal_targetHeading
	.globl _orientationOffset
	.globl _i
	.globl _homeSubState
	.globl _runSubState
	.globl _currentWaypointIndex
	.globl _waypointInputIndex
	.globl _waypointCount
	.globl _waypoints
	.globl _manualPwmRight
	.globl _manualPwmLeft
	.globl _pwm_right
	.globl _pwm_left
	.globl _stateStartTime
	.globl _lastTargetY
	.globl _targetY
	.globl _lastTargetX
	.globl _targetX
	.globl _filteredTheta
	.globl _filteredY
	.globl _filteredX
	.globl _posTheta
	.globl _posY
	.globl _posX
	.globl _rxPulseStart
	.globl _now
	.globl _counter_loop
	.globl _lastPacketTime
	.globl _lastPacketTimeCheck
	.globl _currentState
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area RSEG    (ABS,DATA)
	.org 0x0000
Fslave_wixel_track$P0$0$0 == 0x0080
_P0	=	0x0080
Fslave_wixel_track$SP$0$0 == 0x0081
_SP	=	0x0081
Fslave_wixel_track$DPL0$0$0 == 0x0082
_DPL0	=	0x0082
Fslave_wixel_track$DPH0$0$0 == 0x0083
_DPH0	=	0x0083
Fslave_wixel_track$DPL1$0$0 == 0x0084
_DPL1	=	0x0084
Fslave_wixel_track$DPH1$0$0 == 0x0085
_DPH1	=	0x0085
Fslave_wixel_track$U0CSR$0$0 == 0x0086
_U0CSR	=	0x0086
Fslave_wixel_track$PCON$0$0 == 0x0087
_PCON	=	0x0087
Fslave_wixel_track$TCON$0$0 == 0x0088
_TCON	=	0x0088
Fslave_wixel_track$P0IFG$0$0 == 0x0089
_P0IFG	=	0x0089
Fslave_wixel_track$P1IFG$0$0 == 0x008a
_P1IFG	=	0x008a
Fslave_wixel_track$P2IFG$0$0 == 0x008b
_P2IFG	=	0x008b
Fslave_wixel_track$PICTL$0$0 == 0x008c
_PICTL	=	0x008c
Fslave_wixel_track$P1IEN$0$0 == 0x008d
_P1IEN	=	0x008d
Fslave_wixel_track$P0INP$0$0 == 0x008f
_P0INP	=	0x008f
Fslave_wixel_track$P1$0$0 == 0x0090
_P1	=	0x0090
Fslave_wixel_track$RFIM$0$0 == 0x0091
_RFIM	=	0x0091
Fslave_wixel_track$DPS$0$0 == 0x0092
_DPS	=	0x0092
Fslave_wixel_track$MPAGE$0$0 == 0x0093
_MPAGE	=	0x0093
Fslave_wixel_track$ENDIAN$0$0 == 0x0095
_ENDIAN	=	0x0095
Fslave_wixel_track$S0CON$0$0 == 0x0098
_S0CON	=	0x0098
Fslave_wixel_track$IEN2$0$0 == 0x009a
_IEN2	=	0x009a
Fslave_wixel_track$S1CON$0$0 == 0x009b
_S1CON	=	0x009b
Fslave_wixel_track$T2CT$0$0 == 0x009c
_T2CT	=	0x009c
Fslave_wixel_track$T2PR$0$0 == 0x009d
_T2PR	=	0x009d
Fslave_wixel_track$T2CTL$0$0 == 0x009e
_T2CTL	=	0x009e
Fslave_wixel_track$P2$0$0 == 0x00a0
_P2	=	0x00a0
Fslave_wixel_track$WORIRQ$0$0 == 0x00a1
_WORIRQ	=	0x00a1
Fslave_wixel_track$WORCTRL$0$0 == 0x00a2
_WORCTRL	=	0x00a2
Fslave_wixel_track$WOREVT0$0$0 == 0x00a3
_WOREVT0	=	0x00a3
Fslave_wixel_track$WOREVT1$0$0 == 0x00a4
_WOREVT1	=	0x00a4
Fslave_wixel_track$WORTIME0$0$0 == 0x00a5
_WORTIME0	=	0x00a5
Fslave_wixel_track$WORTIME1$0$0 == 0x00a6
_WORTIME1	=	0x00a6
Fslave_wixel_track$IEN0$0$0 == 0x00a8
_IEN0	=	0x00a8
Fslave_wixel_track$IP0$0$0 == 0x00a9
_IP0	=	0x00a9
Fslave_wixel_track$FWT$0$0 == 0x00ab
_FWT	=	0x00ab
Fslave_wixel_track$FADDRL$0$0 == 0x00ac
_FADDRL	=	0x00ac
Fslave_wixel_track$FADDRH$0$0 == 0x00ad
_FADDRH	=	0x00ad
Fslave_wixel_track$FCTL$0$0 == 0x00ae
_FCTL	=	0x00ae
Fslave_wixel_track$FWDATA$0$0 == 0x00af
_FWDATA	=	0x00af
Fslave_wixel_track$ENCDI$0$0 == 0x00b1
_ENCDI	=	0x00b1
Fslave_wixel_track$ENCDO$0$0 == 0x00b2
_ENCDO	=	0x00b2
Fslave_wixel_track$ENCCS$0$0 == 0x00b3
_ENCCS	=	0x00b3
Fslave_wixel_track$ADCCON1$0$0 == 0x00b4
_ADCCON1	=	0x00b4
Fslave_wixel_track$ADCCON2$0$0 == 0x00b5
_ADCCON2	=	0x00b5
Fslave_wixel_track$ADCCON3$0$0 == 0x00b6
_ADCCON3	=	0x00b6
Fslave_wixel_track$IEN1$0$0 == 0x00b8
_IEN1	=	0x00b8
Fslave_wixel_track$IP1$0$0 == 0x00b9
_IP1	=	0x00b9
Fslave_wixel_track$ADCL$0$0 == 0x00ba
_ADCL	=	0x00ba
Fslave_wixel_track$ADCH$0$0 == 0x00bb
_ADCH	=	0x00bb
Fslave_wixel_track$RNDL$0$0 == 0x00bc
_RNDL	=	0x00bc
Fslave_wixel_track$RNDH$0$0 == 0x00bd
_RNDH	=	0x00bd
Fslave_wixel_track$SLEEP$0$0 == 0x00be
_SLEEP	=	0x00be
Fslave_wixel_track$IRCON$0$0 == 0x00c0
_IRCON	=	0x00c0
Fslave_wixel_track$U0DBUF$0$0 == 0x00c1
_U0DBUF	=	0x00c1
Fslave_wixel_track$U0BAUD$0$0 == 0x00c2
_U0BAUD	=	0x00c2
Fslave_wixel_track$U0UCR$0$0 == 0x00c4
_U0UCR	=	0x00c4
Fslave_wixel_track$U0GCR$0$0 == 0x00c5
_U0GCR	=	0x00c5
Fslave_wixel_track$CLKCON$0$0 == 0x00c6
_CLKCON	=	0x00c6
Fslave_wixel_track$MEMCTR$0$0 == 0x00c7
_MEMCTR	=	0x00c7
Fslave_wixel_track$WDCTL$0$0 == 0x00c9
_WDCTL	=	0x00c9
Fslave_wixel_track$T3CNT$0$0 == 0x00ca
_T3CNT	=	0x00ca
Fslave_wixel_track$T3CTL$0$0 == 0x00cb
_T3CTL	=	0x00cb
Fslave_wixel_track$T3CCTL0$0$0 == 0x00cc
_T3CCTL0	=	0x00cc
Fslave_wixel_track$T3CC0$0$0 == 0x00cd
_T3CC0	=	0x00cd
Fslave_wixel_track$T3CCTL1$0$0 == 0x00ce
_T3CCTL1	=	0x00ce
Fslave_wixel_track$T3CC1$0$0 == 0x00cf
_T3CC1	=	0x00cf
Fslave_wixel_track$PSW$0$0 == 0x00d0
_PSW	=	0x00d0
Fslave_wixel_track$DMAIRQ$0$0 == 0x00d1
_DMAIRQ	=	0x00d1
Fslave_wixel_track$DMA1CFGL$0$0 == 0x00d2
_DMA1CFGL	=	0x00d2
Fslave_wixel_track$DMA1CFGH$0$0 == 0x00d3
_DMA1CFGH	=	0x00d3
Fslave_wixel_track$DMA0CFGL$0$0 == 0x00d4
_DMA0CFGL	=	0x00d4
Fslave_wixel_track$DMA0CFGH$0$0 == 0x00d5
_DMA0CFGH	=	0x00d5
Fslave_wixel_track$DMAARM$0$0 == 0x00d6
_DMAARM	=	0x00d6
Fslave_wixel_track$DMAREQ$0$0 == 0x00d7
_DMAREQ	=	0x00d7
Fslave_wixel_track$TIMIF$0$0 == 0x00d8
_TIMIF	=	0x00d8
Fslave_wixel_track$RFD$0$0 == 0x00d9
_RFD	=	0x00d9
Fslave_wixel_track$T1CC0L$0$0 == 0x00da
_T1CC0L	=	0x00da
Fslave_wixel_track$T1CC0H$0$0 == 0x00db
_T1CC0H	=	0x00db
Fslave_wixel_track$T1CC1L$0$0 == 0x00dc
_T1CC1L	=	0x00dc
Fslave_wixel_track$T1CC1H$0$0 == 0x00dd
_T1CC1H	=	0x00dd
Fslave_wixel_track$T1CC2L$0$0 == 0x00de
_T1CC2L	=	0x00de
Fslave_wixel_track$T1CC2H$0$0 == 0x00df
_T1CC2H	=	0x00df
Fslave_wixel_track$ACC$0$0 == 0x00e0
_ACC	=	0x00e0
Fslave_wixel_track$RFST$0$0 == 0x00e1
_RFST	=	0x00e1
Fslave_wixel_track$T1CNTL$0$0 == 0x00e2
_T1CNTL	=	0x00e2
Fslave_wixel_track$T1CNTH$0$0 == 0x00e3
_T1CNTH	=	0x00e3
Fslave_wixel_track$T1CTL$0$0 == 0x00e4
_T1CTL	=	0x00e4
Fslave_wixel_track$T1CCTL0$0$0 == 0x00e5
_T1CCTL0	=	0x00e5
Fslave_wixel_track$T1CCTL1$0$0 == 0x00e6
_T1CCTL1	=	0x00e6
Fslave_wixel_track$T1CCTL2$0$0 == 0x00e7
_T1CCTL2	=	0x00e7
Fslave_wixel_track$IRCON2$0$0 == 0x00e8
_IRCON2	=	0x00e8
Fslave_wixel_track$RFIF$0$0 == 0x00e9
_RFIF	=	0x00e9
Fslave_wixel_track$T4CNT$0$0 == 0x00ea
_T4CNT	=	0x00ea
Fslave_wixel_track$T4CTL$0$0 == 0x00eb
_T4CTL	=	0x00eb
Fslave_wixel_track$T4CCTL0$0$0 == 0x00ec
_T4CCTL0	=	0x00ec
Fslave_wixel_track$T4CC0$0$0 == 0x00ed
_T4CC0	=	0x00ed
Fslave_wixel_track$T4CCTL1$0$0 == 0x00ee
_T4CCTL1	=	0x00ee
Fslave_wixel_track$T4CC1$0$0 == 0x00ef
_T4CC1	=	0x00ef
Fslave_wixel_track$B$0$0 == 0x00f0
_B	=	0x00f0
Fslave_wixel_track$PERCFG$0$0 == 0x00f1
_PERCFG	=	0x00f1
Fslave_wixel_track$ADCCFG$0$0 == 0x00f2
_ADCCFG	=	0x00f2
Fslave_wixel_track$P0SEL$0$0 == 0x00f3
_P0SEL	=	0x00f3
Fslave_wixel_track$P1SEL$0$0 == 0x00f4
_P1SEL	=	0x00f4
Fslave_wixel_track$P2SEL$0$0 == 0x00f5
_P2SEL	=	0x00f5
Fslave_wixel_track$P1INP$0$0 == 0x00f6
_P1INP	=	0x00f6
Fslave_wixel_track$P2INP$0$0 == 0x00f7
_P2INP	=	0x00f7
Fslave_wixel_track$U1CSR$0$0 == 0x00f8
_U1CSR	=	0x00f8
Fslave_wixel_track$U1DBUF$0$0 == 0x00f9
_U1DBUF	=	0x00f9
Fslave_wixel_track$U1BAUD$0$0 == 0x00fa
_U1BAUD	=	0x00fa
Fslave_wixel_track$U1UCR$0$0 == 0x00fb
_U1UCR	=	0x00fb
Fslave_wixel_track$U1GCR$0$0 == 0x00fc
_U1GCR	=	0x00fc
Fslave_wixel_track$P0DIR$0$0 == 0x00fd
_P0DIR	=	0x00fd
Fslave_wixel_track$P1DIR$0$0 == 0x00fe
_P1DIR	=	0x00fe
Fslave_wixel_track$P2DIR$0$0 == 0x00ff
_P2DIR	=	0x00ff
Fslave_wixel_track$DMA0CFG$0$0 == 0xffffd5d4
_DMA0CFG	=	0xffffd5d4
Fslave_wixel_track$DMA1CFG$0$0 == 0xffffd3d2
_DMA1CFG	=	0xffffd3d2
Fslave_wixel_track$FADDR$0$0 == 0xffffadac
_FADDR	=	0xffffadac
Fslave_wixel_track$ADC$0$0 == 0xffffbbba
_ADC	=	0xffffbbba
Fslave_wixel_track$T1CC0$0$0 == 0xffffdbda
_T1CC0	=	0xffffdbda
Fslave_wixel_track$T1CC1$0$0 == 0xffffdddc
_T1CC1	=	0xffffdddc
Fslave_wixel_track$T1CC2$0$0 == 0xffffdfde
_T1CC2	=	0xffffdfde
;--------------------------------------------------------
; special function bits
;--------------------------------------------------------
	.area RSEG    (ABS,DATA)
	.org 0x0000
Fslave_wixel_track$P0_0$0$0 == 0x0080
_P0_0	=	0x0080
Fslave_wixel_track$P0_1$0$0 == 0x0081
_P0_1	=	0x0081
Fslave_wixel_track$P0_2$0$0 == 0x0082
_P0_2	=	0x0082
Fslave_wixel_track$P0_3$0$0 == 0x0083
_P0_3	=	0x0083
Fslave_wixel_track$P0_4$0$0 == 0x0084
_P0_4	=	0x0084
Fslave_wixel_track$P0_5$0$0 == 0x0085
_P0_5	=	0x0085
Fslave_wixel_track$P0_6$0$0 == 0x0086
_P0_6	=	0x0086
Fslave_wixel_track$P0_7$0$0 == 0x0087
_P0_7	=	0x0087
Fslave_wixel_track$_TCON_0$0$0 == 0x0088
__TCON_0	=	0x0088
Fslave_wixel_track$RFTXRXIF$0$0 == 0x0089
_RFTXRXIF	=	0x0089
Fslave_wixel_track$_TCON_2$0$0 == 0x008a
__TCON_2	=	0x008a
Fslave_wixel_track$URX0IF$0$0 == 0x008b
_URX0IF	=	0x008b
Fslave_wixel_track$_TCON_4$0$0 == 0x008c
__TCON_4	=	0x008c
Fslave_wixel_track$ADCIF$0$0 == 0x008d
_ADCIF	=	0x008d
Fslave_wixel_track$_TCON_6$0$0 == 0x008e
__TCON_6	=	0x008e
Fslave_wixel_track$URX1IF$0$0 == 0x008f
_URX1IF	=	0x008f
Fslave_wixel_track$P1_0$0$0 == 0x0090
_P1_0	=	0x0090
Fslave_wixel_track$P1_1$0$0 == 0x0091
_P1_1	=	0x0091
Fslave_wixel_track$P1_2$0$0 == 0x0092
_P1_2	=	0x0092
Fslave_wixel_track$P1_3$0$0 == 0x0093
_P1_3	=	0x0093
Fslave_wixel_track$P1_4$0$0 == 0x0094
_P1_4	=	0x0094
Fslave_wixel_track$P1_5$0$0 == 0x0095
_P1_5	=	0x0095
Fslave_wixel_track$P1_6$0$0 == 0x0096
_P1_6	=	0x0096
Fslave_wixel_track$P1_7$0$0 == 0x0097
_P1_7	=	0x0097
Fslave_wixel_track$ENCIF_0$0$0 == 0x0098
_ENCIF_0	=	0x0098
Fslave_wixel_track$ENCIF_1$0$0 == 0x0099
_ENCIF_1	=	0x0099
Fslave_wixel_track$_SOCON2$0$0 == 0x009a
__SOCON2	=	0x009a
Fslave_wixel_track$_SOCON3$0$0 == 0x009b
__SOCON3	=	0x009b
Fslave_wixel_track$_SOCON4$0$0 == 0x009c
__SOCON4	=	0x009c
Fslave_wixel_track$_SOCON5$0$0 == 0x009d
__SOCON5	=	0x009d
Fslave_wixel_track$_SOCON6$0$0 == 0x009e
__SOCON6	=	0x009e
Fslave_wixel_track$_SOCON7$0$0 == 0x009f
__SOCON7	=	0x009f
Fslave_wixel_track$P2_0$0$0 == 0x00a0
_P2_0	=	0x00a0
Fslave_wixel_track$P2_1$0$0 == 0x00a1
_P2_1	=	0x00a1
Fslave_wixel_track$P2_2$0$0 == 0x00a2
_P2_2	=	0x00a2
Fslave_wixel_track$P2_3$0$0 == 0x00a3
_P2_3	=	0x00a3
Fslave_wixel_track$P2_4$0$0 == 0x00a4
_P2_4	=	0x00a4
Fslave_wixel_track$P2_5$0$0 == 0x00a5
_P2_5	=	0x00a5
Fslave_wixel_track$P2_6$0$0 == 0x00a6
_P2_6	=	0x00a6
Fslave_wixel_track$P2_7$0$0 == 0x00a7
_P2_7	=	0x00a7
Fslave_wixel_track$RFTXRXIE$0$0 == 0x00a8
_RFTXRXIE	=	0x00a8
Fslave_wixel_track$ADCIE$0$0 == 0x00a9
_ADCIE	=	0x00a9
Fslave_wixel_track$URX0IE$0$0 == 0x00aa
_URX0IE	=	0x00aa
Fslave_wixel_track$URX1IE$0$0 == 0x00ab
_URX1IE	=	0x00ab
Fslave_wixel_track$ENCIE$0$0 == 0x00ac
_ENCIE	=	0x00ac
Fslave_wixel_track$STIE$0$0 == 0x00ad
_STIE	=	0x00ad
Fslave_wixel_track$_IEN06$0$0 == 0x00ae
__IEN06	=	0x00ae
Fslave_wixel_track$EA$0$0 == 0x00af
_EA	=	0x00af
Fslave_wixel_track$DMAIE$0$0 == 0x00b8
_DMAIE	=	0x00b8
Fslave_wixel_track$T1IE$0$0 == 0x00b9
_T1IE	=	0x00b9
Fslave_wixel_track$T2IE$0$0 == 0x00ba
_T2IE	=	0x00ba
Fslave_wixel_track$T3IE$0$0 == 0x00bb
_T3IE	=	0x00bb
Fslave_wixel_track$T4IE$0$0 == 0x00bc
_T4IE	=	0x00bc
Fslave_wixel_track$P0IE$0$0 == 0x00bd
_P0IE	=	0x00bd
Fslave_wixel_track$_IEN16$0$0 == 0x00be
__IEN16	=	0x00be
Fslave_wixel_track$_IEN17$0$0 == 0x00bf
__IEN17	=	0x00bf
Fslave_wixel_track$DMAIF$0$0 == 0x00c0
_DMAIF	=	0x00c0
Fslave_wixel_track$T1IF$0$0 == 0x00c1
_T1IF	=	0x00c1
Fslave_wixel_track$T2IF$0$0 == 0x00c2
_T2IF	=	0x00c2
Fslave_wixel_track$T3IF$0$0 == 0x00c3
_T3IF	=	0x00c3
Fslave_wixel_track$T4IF$0$0 == 0x00c4
_T4IF	=	0x00c4
Fslave_wixel_track$P0IF$0$0 == 0x00c5
_P0IF	=	0x00c5
Fslave_wixel_track$_IRCON6$0$0 == 0x00c6
__IRCON6	=	0x00c6
Fslave_wixel_track$STIF$0$0 == 0x00c7
_STIF	=	0x00c7
Fslave_wixel_track$P$0$0 == 0x00d0
_P	=	0x00d0
Fslave_wixel_track$F1$0$0 == 0x00d1
_F1	=	0x00d1
Fslave_wixel_track$OV$0$0 == 0x00d2
_OV	=	0x00d2
Fslave_wixel_track$RS0$0$0 == 0x00d3
_RS0	=	0x00d3
Fslave_wixel_track$RS1$0$0 == 0x00d4
_RS1	=	0x00d4
Fslave_wixel_track$F0$0$0 == 0x00d5
_F0	=	0x00d5
Fslave_wixel_track$AC$0$0 == 0x00d6
_AC	=	0x00d6
Fslave_wixel_track$CY$0$0 == 0x00d7
_CY	=	0x00d7
Fslave_wixel_track$T3OVFIF$0$0 == 0x00d8
_T3OVFIF	=	0x00d8
Fslave_wixel_track$T3CH0IF$0$0 == 0x00d9
_T3CH0IF	=	0x00d9
Fslave_wixel_track$T3CH1IF$0$0 == 0x00da
_T3CH1IF	=	0x00da
Fslave_wixel_track$T4OVFIF$0$0 == 0x00db
_T4OVFIF	=	0x00db
Fslave_wixel_track$T4CH0IF$0$0 == 0x00dc
_T4CH0IF	=	0x00dc
Fslave_wixel_track$T4CH1IF$0$0 == 0x00dd
_T4CH1IF	=	0x00dd
Fslave_wixel_track$OVFIM$0$0 == 0x00de
_OVFIM	=	0x00de
Fslave_wixel_track$_TIMIF7$0$0 == 0x00df
__TIMIF7	=	0x00df
Fslave_wixel_track$ACC_0$0$0 == 0x00e0
_ACC_0	=	0x00e0
Fslave_wixel_track$ACC_1$0$0 == 0x00e1
_ACC_1	=	0x00e1
Fslave_wixel_track$ACC_2$0$0 == 0x00e2
_ACC_2	=	0x00e2
Fslave_wixel_track$ACC_3$0$0 == 0x00e3
_ACC_3	=	0x00e3
Fslave_wixel_track$ACC_4$0$0 == 0x00e4
_ACC_4	=	0x00e4
Fslave_wixel_track$ACC_5$0$0 == 0x00e5
_ACC_5	=	0x00e5
Fslave_wixel_track$ACC_6$0$0 == 0x00e6
_ACC_6	=	0x00e6
Fslave_wixel_track$ACC_7$0$0 == 0x00e7
_ACC_7	=	0x00e7
Fslave_wixel_track$P2IF$0$0 == 0x00e8
_P2IF	=	0x00e8
Fslave_wixel_track$UTX0IF$0$0 == 0x00e9
_UTX0IF	=	0x00e9
Fslave_wixel_track$UTX1IF$0$0 == 0x00ea
_UTX1IF	=	0x00ea
Fslave_wixel_track$P1IF$0$0 == 0x00eb
_P1IF	=	0x00eb
Fslave_wixel_track$WDTIF$0$0 == 0x00ec
_WDTIF	=	0x00ec
Fslave_wixel_track$_IRCON25$0$0 == 0x00ed
__IRCON25	=	0x00ed
Fslave_wixel_track$_IRCON26$0$0 == 0x00ee
__IRCON26	=	0x00ee
Fslave_wixel_track$_IRCON27$0$0 == 0x00ef
__IRCON27	=	0x00ef
Fslave_wixel_track$B_0$0$0 == 0x00f0
_B_0	=	0x00f0
Fslave_wixel_track$B_1$0$0 == 0x00f1
_B_1	=	0x00f1
Fslave_wixel_track$B_2$0$0 == 0x00f2
_B_2	=	0x00f2
Fslave_wixel_track$B_3$0$0 == 0x00f3
_B_3	=	0x00f3
Fslave_wixel_track$B_4$0$0 == 0x00f4
_B_4	=	0x00f4
Fslave_wixel_track$B_5$0$0 == 0x00f5
_B_5	=	0x00f5
Fslave_wixel_track$B_6$0$0 == 0x00f6
_B_6	=	0x00f6
Fslave_wixel_track$B_7$0$0 == 0x00f7
_B_7	=	0x00f7
Fslave_wixel_track$U1ACTIVE$0$0 == 0x00f8
_U1ACTIVE	=	0x00f8
Fslave_wixel_track$U1TX_BYTE$0$0 == 0x00f9
_U1TX_BYTE	=	0x00f9
Fslave_wixel_track$U1RX_BYTE$0$0 == 0x00fa
_U1RX_BYTE	=	0x00fa
Fslave_wixel_track$U1ERR$0$0 == 0x00fb
_U1ERR	=	0x00fb
Fslave_wixel_track$U1FE$0$0 == 0x00fc
_U1FE	=	0x00fc
Fslave_wixel_track$U1SLAVE$0$0 == 0x00fd
_U1SLAVE	=	0x00fd
Fslave_wixel_track$U1RE$0$0 == 0x00fe
_U1RE	=	0x00fe
Fslave_wixel_track$U1MODE$0$0 == 0x00ff
_U1MODE	=	0x00ff
;--------------------------------------------------------
; overlayable register banks
;--------------------------------------------------------
	.area REG_BANK_0	(REL,OVR,DATA)
	.ds 8
;--------------------------------------------------------
; internal ram data
;--------------------------------------------------------
	.area DSEG    (DATA)
Lslave_wixel_track.isWithinThreshold$sloc0$1$0==.
_isWithinThreshold_sloc0_1_0:
	.ds 4
Lslave_wixel_track.calculateTargetHeading$sloc0$1$0==.
_calculateTargetHeading_sloc0_1_0:
	.ds 4
Lslave_wixel_track.calculateAndApplyOffset$sloc0$1$0==.
_calculateAndApplyOffset_sloc0_1_0:
	.ds 2
Lslave_wixel_track.filterPosition$sloc0$1$0==.
_filterPosition_sloc0_1_0:
	.ds 4
Lslave_wixel_track.handlePacketTimeout$sloc0$1$0==.
_handlePacketTimeout_sloc0_1_0:
	.ds 4
;--------------------------------------------------------
; overlayable items in internal ram 
;--------------------------------------------------------
	.area OSEG    (OVR,DATA)
;--------------------------------------------------------
; Stack segment in internal ram 
;--------------------------------------------------------
	.area	SSEG	(DATA)
__start__stack:
	.ds	1

;--------------------------------------------------------
; indirectly addressable internal ram data
;--------------------------------------------------------
	.area ISEG    (DATA)
;--------------------------------------------------------
; absolute internal ram data
;--------------------------------------------------------
	.area IABS    (ABS,DATA)
	.area IABS    (ABS,DATA)
;--------------------------------------------------------
; bit data
;--------------------------------------------------------
	.area BSEG    (BIT)
;--------------------------------------------------------
; paged external ram data
;--------------------------------------------------------
	.area PSEG    (PAG,XDATA)
G$currentState$0$0==.
_currentState::
	.ds 1
G$lastPacketTimeCheck$0$0==.
_lastPacketTimeCheck::
	.ds 2
G$lastPacketTime$0$0==.
_lastPacketTime::
	.ds 2
G$counter_loop$0$0==.
_counter_loop::
	.ds 2
G$now$0$0==.
_now::
	.ds 4
G$rxPulseStart$0$0==.
_rxPulseStart::
	.ds 4
G$posX$0$0==.
_posX::
	.ds 2
G$posY$0$0==.
_posY::
	.ds 2
G$posTheta$0$0==.
_posTheta::
	.ds 2
G$filteredX$0$0==.
_filteredX::
	.ds 2
G$filteredY$0$0==.
_filteredY::
	.ds 2
G$filteredTheta$0$0==.
_filteredTheta::
	.ds 2
G$targetX$0$0==.
_targetX::
	.ds 2
G$lastTargetX$0$0==.
_lastTargetX::
	.ds 2
G$targetY$0$0==.
_targetY::
	.ds 2
G$lastTargetY$0$0==.
_lastTargetY::
	.ds 2
G$stateStartTime$0$0==.
_stateStartTime::
	.ds 4
G$pwm_left$0$0==.
_pwm_left::
	.ds 2
G$pwm_right$0$0==.
_pwm_right::
	.ds 2
G$manualPwmLeft$0$0==.
_manualPwmLeft::
	.ds 2
G$manualPwmRight$0$0==.
_manualPwmRight::
	.ds 2
G$waypoints$0$0==.
_waypoints::
	.ds 100
G$waypointCount$0$0==.
_waypointCount::
	.ds 1
G$waypointInputIndex$0$0==.
_waypointInputIndex::
	.ds 1
G$currentWaypointIndex$0$0==.
_currentWaypointIndex::
	.ds 1
G$runSubState$0$0==.
_runSubState::
	.ds 1
G$homeSubState$0$0==.
_homeSubState::
	.ds 1
G$i$0$0==.
_i::
	.ds 1
Fslave_wixel_track$calData$0$0==.
_calData:
	.ds 18
G$orientationOffset$0$0==.
_orientationOffset::
	.ds 2
G$cal_targetHeading$0$0==.
_cal_targetHeading::
	.ds 2
G$cal_headingError$0$0==.
_cal_headingError::
	.ds 2
G$calib_step$0$0==.
_calib_step::
	.ds 1
Lslave_wixel_track.isWithinThreshold$currentY$1$1==.
_isWithinThreshold_PARM_2:
	.ds 2
Lslave_wixel_track.isWithinThreshold$targetX$1$1==.
_isWithinThreshold_PARM_3:
	.ds 2
Lslave_wixel_track.isWithinThreshold$targetY$1$1==.
_isWithinThreshold_PARM_4:
	.ds 2
Lslave_wixel_track.isWithinThreshold$threshold$1$1==.
_isWithinThreshold_PARM_5:
	.ds 2
Lslave_wixel_track.isWithinThreshold$distSquared$1$1==.
_isWithinThreshold_distSquared_1_1:
	.ds 4
Lslave_wixel_track.calculateTargetHeading$currentY$1$1==.
_calculateTargetHeading_PARM_2:
	.ds 2
Lslave_wixel_track.calculateTargetHeading$goalX$1$1==.
_calculateTargetHeading_PARM_3:
	.ds 2
Lslave_wixel_track.calculateTargetHeading$goalY$1$1==.
_calculateTargetHeading_PARM_4:
	.ds 2
Lslave_wixel_track.calculateTargetHeading$dx$1$1==.
_calculateTargetHeading_dx_1_1:
	.ds 4
Lslave_wixel_track.calculateTargetHeading$absX$1$1==.
_calculateTargetHeading_absX_1_1:
	.ds 4
Lslave_wixel_track.calculateTargetHeading$absY$1$1==.
_calculateTargetHeading_absY_1_1:
	.ds 4
Lslave_wixel_track.calculateTargetHeading$angle$1$1==.
_calculateTargetHeading_angle_1_1:
	.ds 2
Lslave_wixel_track.calculateTargetHeading$ratio$1$1==.
_calculateTargetHeading_ratio_1_1:
	.ds 4
Lslave_wixel_track.rotationController$targetHeading$1$1==.
_rotationController_PARM_2:
	.ds 2
Lslave_wixel_track.handleCmdPrep$wp_x$1$1==.
_handleCmdPrep_wp_x_1_1:
	.ds 2
;--------------------------------------------------------
; external ram data
;--------------------------------------------------------
	.area XSEG    (XDATA)
Fslave_wixel_track$SYNC1$0$0 == 0xdf00
_SYNC1	=	0xdf00
Fslave_wixel_track$SYNC0$0$0 == 0xdf01
_SYNC0	=	0xdf01
Fslave_wixel_track$PKTLEN$0$0 == 0xdf02
_PKTLEN	=	0xdf02
Fslave_wixel_track$PKTCTRL1$0$0 == 0xdf03
_PKTCTRL1	=	0xdf03
Fslave_wixel_track$PKTCTRL0$0$0 == 0xdf04
_PKTCTRL0	=	0xdf04
Fslave_wixel_track$ADDR$0$0 == 0xdf05
_ADDR	=	0xdf05
Fslave_wixel_track$CHANNR$0$0 == 0xdf06
_CHANNR	=	0xdf06
Fslave_wixel_track$FSCTRL1$0$0 == 0xdf07
_FSCTRL1	=	0xdf07
Fslave_wixel_track$FSCTRL0$0$0 == 0xdf08
_FSCTRL0	=	0xdf08
Fslave_wixel_track$FREQ2$0$0 == 0xdf09
_FREQ2	=	0xdf09
Fslave_wixel_track$FREQ1$0$0 == 0xdf0a
_FREQ1	=	0xdf0a
Fslave_wixel_track$FREQ0$0$0 == 0xdf0b
_FREQ0	=	0xdf0b
Fslave_wixel_track$MDMCFG4$0$0 == 0xdf0c
_MDMCFG4	=	0xdf0c
Fslave_wixel_track$MDMCFG3$0$0 == 0xdf0d
_MDMCFG3	=	0xdf0d
Fslave_wixel_track$MDMCFG2$0$0 == 0xdf0e
_MDMCFG2	=	0xdf0e
Fslave_wixel_track$MDMCFG1$0$0 == 0xdf0f
_MDMCFG1	=	0xdf0f
Fslave_wixel_track$MDMCFG0$0$0 == 0xdf10
_MDMCFG0	=	0xdf10
Fslave_wixel_track$DEVIATN$0$0 == 0xdf11
_DEVIATN	=	0xdf11
Fslave_wixel_track$MCSM2$0$0 == 0xdf12
_MCSM2	=	0xdf12
Fslave_wixel_track$MCSM1$0$0 == 0xdf13
_MCSM1	=	0xdf13
Fslave_wixel_track$MCSM0$0$0 == 0xdf14
_MCSM0	=	0xdf14
Fslave_wixel_track$FOCCFG$0$0 == 0xdf15
_FOCCFG	=	0xdf15
Fslave_wixel_track$BSCFG$0$0 == 0xdf16
_BSCFG	=	0xdf16
Fslave_wixel_track$AGCCTRL2$0$0 == 0xdf17
_AGCCTRL2	=	0xdf17
Fslave_wixel_track$AGCCTRL1$0$0 == 0xdf18
_AGCCTRL1	=	0xdf18
Fslave_wixel_track$AGCCTRL0$0$0 == 0xdf19
_AGCCTRL0	=	0xdf19
Fslave_wixel_track$FREND1$0$0 == 0xdf1a
_FREND1	=	0xdf1a
Fslave_wixel_track$FREND0$0$0 == 0xdf1b
_FREND0	=	0xdf1b
Fslave_wixel_track$FSCAL3$0$0 == 0xdf1c
_FSCAL3	=	0xdf1c
Fslave_wixel_track$FSCAL2$0$0 == 0xdf1d
_FSCAL2	=	0xdf1d
Fslave_wixel_track$FSCAL1$0$0 == 0xdf1e
_FSCAL1	=	0xdf1e
Fslave_wixel_track$FSCAL0$0$0 == 0xdf1f
_FSCAL0	=	0xdf1f
Fslave_wixel_track$TEST2$0$0 == 0xdf23
_TEST2	=	0xdf23
Fslave_wixel_track$TEST1$0$0 == 0xdf24
_TEST1	=	0xdf24
Fslave_wixel_track$TEST0$0$0 == 0xdf25
_TEST0	=	0xdf25
Fslave_wixel_track$PA_TABLE0$0$0 == 0xdf2e
_PA_TABLE0	=	0xdf2e
Fslave_wixel_track$IOCFG2$0$0 == 0xdf2f
_IOCFG2	=	0xdf2f
Fslave_wixel_track$IOCFG1$0$0 == 0xdf30
_IOCFG1	=	0xdf30
Fslave_wixel_track$IOCFG0$0$0 == 0xdf31
_IOCFG0	=	0xdf31
Fslave_wixel_track$PARTNUM$0$0 == 0xdf36
_PARTNUM	=	0xdf36
Fslave_wixel_track$VERSION$0$0 == 0xdf37
_VERSION	=	0xdf37
Fslave_wixel_track$FREQEST$0$0 == 0xdf38
_FREQEST	=	0xdf38
Fslave_wixel_track$LQI$0$0 == 0xdf39
_LQI	=	0xdf39
Fslave_wixel_track$RSSI$0$0 == 0xdf3a
_RSSI	=	0xdf3a
Fslave_wixel_track$MARCSTATE$0$0 == 0xdf3b
_MARCSTATE	=	0xdf3b
Fslave_wixel_track$PKTSTATUS$0$0 == 0xdf3c
_PKTSTATUS	=	0xdf3c
Fslave_wixel_track$VCO_VC_DAC$0$0 == 0xdf3d
_VCO_VC_DAC	=	0xdf3d
Fslave_wixel_track$I2SCFG0$0$0 == 0xdf40
_I2SCFG0	=	0xdf40
Fslave_wixel_track$I2SCFG1$0$0 == 0xdf41
_I2SCFG1	=	0xdf41
Fslave_wixel_track$I2SDATL$0$0 == 0xdf42
_I2SDATL	=	0xdf42
Fslave_wixel_track$I2SDATH$0$0 == 0xdf43
_I2SDATH	=	0xdf43
Fslave_wixel_track$I2SWCNT$0$0 == 0xdf44
_I2SWCNT	=	0xdf44
Fslave_wixel_track$I2SSTAT$0$0 == 0xdf45
_I2SSTAT	=	0xdf45
Fslave_wixel_track$I2SCLKF0$0$0 == 0xdf46
_I2SCLKF0	=	0xdf46
Fslave_wixel_track$I2SCLKF1$0$0 == 0xdf47
_I2SCLKF1	=	0xdf47
Fslave_wixel_track$I2SCLKF2$0$0 == 0xdf48
_I2SCLKF2	=	0xdf48
Fslave_wixel_track$USBADDR$0$0 == 0xde00
_USBADDR	=	0xde00
Fslave_wixel_track$USBPOW$0$0 == 0xde01
_USBPOW	=	0xde01
Fslave_wixel_track$USBIIF$0$0 == 0xde02
_USBIIF	=	0xde02
Fslave_wixel_track$USBOIF$0$0 == 0xde04
_USBOIF	=	0xde04
Fslave_wixel_track$USBCIF$0$0 == 0xde06
_USBCIF	=	0xde06
Fslave_wixel_track$USBIIE$0$0 == 0xde07
_USBIIE	=	0xde07
Fslave_wixel_track$USBOIE$0$0 == 0xde09
_USBOIE	=	0xde09
Fslave_wixel_track$USBCIE$0$0 == 0xde0b
_USBCIE	=	0xde0b
Fslave_wixel_track$USBFRML$0$0 == 0xde0c
_USBFRML	=	0xde0c
Fslave_wixel_track$USBFRMH$0$0 == 0xde0d
_USBFRMH	=	0xde0d
Fslave_wixel_track$USBINDEX$0$0 == 0xde0e
_USBINDEX	=	0xde0e
Fslave_wixel_track$USBMAXI$0$0 == 0xde10
_USBMAXI	=	0xde10
Fslave_wixel_track$USBCSIL$0$0 == 0xde11
_USBCSIL	=	0xde11
Fslave_wixel_track$USBCSIH$0$0 == 0xde12
_USBCSIH	=	0xde12
Fslave_wixel_track$USBMAXO$0$0 == 0xde13
_USBMAXO	=	0xde13
Fslave_wixel_track$USBCSOL$0$0 == 0xde14
_USBCSOL	=	0xde14
Fslave_wixel_track$USBCSOH$0$0 == 0xde15
_USBCSOH	=	0xde15
Fslave_wixel_track$USBCNTL$0$0 == 0xde16
_USBCNTL	=	0xde16
Fslave_wixel_track$USBCNTH$0$0 == 0xde17
_USBCNTH	=	0xde17
Fslave_wixel_track$USBF0$0$0 == 0xde20
_USBF0	=	0xde20
Fslave_wixel_track$USBF1$0$0 == 0xde22
_USBF1	=	0xde22
Fslave_wixel_track$USBF2$0$0 == 0xde24
_USBF2	=	0xde24
Fslave_wixel_track$USBF3$0$0 == 0xde26
_USBF3	=	0xde26
Fslave_wixel_track$USBF4$0$0 == 0xde28
_USBF4	=	0xde28
Fslave_wixel_track$USBF5$0$0 == 0xde2a
_USBF5	=	0xde2a
Fslave_wixel_track$rxPacket$0$0==.
_rxPacket:
	.ds 67
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area XABS    (ABS,XDATA)
;--------------------------------------------------------
; external initialized ram data
;--------------------------------------------------------
	.area XISEG   (XDATA)
	.area HOME    (CODE)
	.area GSINIT0 (CODE)
	.area GSINIT1 (CODE)
	.area GSINIT2 (CODE)
	.area GSINIT3 (CODE)
	.area GSINIT4 (CODE)
	.area GSINIT5 (CODE)
	.area GSINIT  (CODE)
	.area GSFINAL (CODE)
	.area CSEG    (CODE)
;--------------------------------------------------------
; interrupt vector 
;--------------------------------------------------------
	.area HOME    (CODE)
__interrupt_vect:
	ljmp	__sdcc_gsinit_startup
	reti
	.ds	7
	reti
	.ds	7
	reti
	.ds	7
	reti
	.ds	7
	reti
	.ds	7
	reti
	.ds	7
	reti
	.ds	7
	reti
	.ds	7
	reti
	.ds	7
	reti
	.ds	7
	reti
	.ds	7
	reti
	.ds	7
	ljmp	_ISR_T4
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area HOME    (CODE)
	.area GSINIT  (CODE)
	.area GSFINAL (CODE)
	.area GSINIT  (CODE)
	.globl __sdcc_gsinit_startup
	.globl __sdcc_program_startup
	.globl __start__stack
	.globl __mcs51_genXINIT
	.globl __mcs51_genXRAMCLEAR
	.globl __mcs51_genRAMCLEAR
	G$main$0$0 ==.
	C$slave_wixel_track.c$111$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:111: uint8 currentState = STATE_IDLE;
	mov	r0,#_currentState
	clr	a
	movx	@r0,a
	G$main$0$0 ==.
	C$slave_wixel_track.c$114$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:114: uint16 lastPacketTimeCheck = 0;
	mov	r0,#_lastPacketTimeCheck
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	G$main$0$0 ==.
	C$slave_wixel_track.c$115$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:115: uint16 lastPacketTime = 0;
	mov	r0,#_lastPacketTime
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	G$main$0$0 ==.
	C$slave_wixel_track.c$116$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:116: uint16 counter_loop = 0;
	mov	r0,#_counter_loop
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	G$main$0$0 ==.
	C$slave_wixel_track.c$117$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:117: uint32 now = 0;
	mov	r0,#_now
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	inc	r0
	movx	@r0,a
	inc	r0
	movx	@r0,a
	G$main$0$0 ==.
	C$slave_wixel_track.c$118$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:118: uint32 rxPulseStart = 1;
	mov	r0,#_rxPulseStart
	mov	a,#0x01
	movx	@r0,a
	inc	r0
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	inc	r0
	movx	@r0,a
	G$main$0$0 ==.
	C$slave_wixel_track.c$121$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:121: int16 posX = 0;
	mov	r0,#_posX
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	G$main$0$0 ==.
	C$slave_wixel_track.c$122$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:122: int16 posY = 0;
	mov	r0,#_posY
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	G$main$0$0 ==.
	C$slave_wixel_track.c$123$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:123: int16 posTheta = 0;
	mov	r0,#_posTheta
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	G$main$0$0 ==.
	C$slave_wixel_track.c$126$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:126: int16 filteredX = 0;
	mov	r0,#_filteredX
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	G$main$0$0 ==.
	C$slave_wixel_track.c$127$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:127: int16 filteredY = 0;
	mov	r0,#_filteredY
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	G$main$0$0 ==.
	C$slave_wixel_track.c$128$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:128: int16 filteredTheta = 0;
	mov	r0,#_filteredTheta
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	G$main$0$0 ==.
	C$slave_wixel_track.c$131$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:131: int16 targetX = 0;
	mov	r0,#_targetX
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	G$main$0$0 ==.
	C$slave_wixel_track.c$132$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:132: int16 lastTargetX = 0;
	mov	r0,#_lastTargetX
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	G$main$0$0 ==.
	C$slave_wixel_track.c$133$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:133: int16 targetY = 0;
	mov	r0,#_targetY
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	G$main$0$0 ==.
	C$slave_wixel_track.c$134$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:134: int16 lastTargetY = 0;
	mov	r0,#_lastTargetY
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	G$main$0$0 ==.
	C$slave_wixel_track.c$137$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:137: uint32 stateStartTime = 0;
	mov	r0,#_stateStartTime
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	inc	r0
	movx	@r0,a
	inc	r0
	movx	@r0,a
	G$main$0$0 ==.
	C$slave_wixel_track.c$140$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:140: int16 pwm_left = 0;
	mov	r0,#_pwm_left
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	G$main$0$0 ==.
	C$slave_wixel_track.c$141$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:141: int16 pwm_right = 0;
	mov	r0,#_pwm_right
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	G$main$0$0 ==.
	C$slave_wixel_track.c$144$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:144: int16 manualPwmLeft = 0;
	mov	r0,#_manualPwmLeft
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	G$main$0$0 ==.
	C$slave_wixel_track.c$145$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:145: int16 manualPwmRight = 0;
	mov	r0,#_manualPwmRight
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	G$main$0$0 ==.
	C$slave_wixel_track.c$156$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:156: uint8 waypointCount = 0;
	mov	r0,#_waypointCount
	clr	a
	movx	@r0,a
	G$main$0$0 ==.
	C$slave_wixel_track.c$157$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:157: uint8 waypointInputIndex = 0;
	mov	r0,#_waypointInputIndex
	clr	a
	movx	@r0,a
	G$main$0$0 ==.
	C$slave_wixel_track.c$158$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:158: uint8 currentWaypointIndex = 0;
	mov	r0,#_currentWaypointIndex
	clr	a
	movx	@r0,a
	G$main$0$0 ==.
	C$slave_wixel_track.c$161$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:161: uint8 runSubState = 0;
	mov	r0,#_runSubState
	clr	a
	movx	@r0,a
	G$main$0$0 ==.
	C$slave_wixel_track.c$164$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:164: uint8 homeSubState = 0;
	mov	r0,#_homeSubState
	clr	a
	movx	@r0,a
	G$main$0$0 ==.
	C$slave_wixel_track.c$177$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:177: int16 orientationOffset = 0;  // degrees
	mov	r0,#_orientationOffset
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	G$main$0$0 ==.
	C$slave_wixel_track.c$178$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:178: int16 cal_targetHeading = 0;
	mov	r0,#_cal_targetHeading
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	G$main$0$0 ==.
	C$slave_wixel_track.c$179$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:179: int16 cal_headingError = 0;
	mov	r0,#_cal_headingError
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	G$main$0$0 ==.
	C$slave_wixel_track.c$180$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:180: uint8 calib_step = 0;
	mov	r0,#_calib_step
	clr	a
	movx	@r0,a
	.area GSFINAL (CODE)
	ljmp	__sdcc_program_startup
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area HOME    (CODE)
	.area HOME    (CODE)
__sdcc_program_startup:
	lcall	_main
;	return from main will lock up
	sjmp .
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area CSEG    (CODE)
;------------------------------------------------------------
;Allocation info for local variables in function 'abs16'
;------------------------------------------------------------
	G$abs16$0$0 ==.
	C$slave_wixel_track.c$184$0$0 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:184: int16 abs16(int16 val)
;	-----------------------------------------
;	 function abs16
;	-----------------------------------------
_abs16:
	ar7 = 0x07
	ar6 = 0x06
	ar5 = 0x05
	ar4 = 0x04
	ar3 = 0x03
	ar2 = 0x02
	ar1 = 0x01
	ar0 = 0x00
	mov	r6,dpl
	C$slave_wixel_track.c$186$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:186: return (val < 0) ? -val : val;
	mov	a,dph
	mov	r7,a
	jnb	acc.7,00103$
	clr	c
	clr	a
	subb	a,r6
	mov	r4,a
	clr	a
	subb	a,r7
	mov	r5,a
	sjmp	00104$
00103$:
	mov	ar4,r6
	mov	ar5,r7
00104$:
	mov	dpl,r4
	mov	dph,r5
	C$slave_wixel_track.c$187$1$1 ==.
	XG$abs16$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'isWithinThreshold'
;------------------------------------------------------------
;sloc0                     Allocated with name '_isWithinThreshold_sloc0_1_0'
;------------------------------------------------------------
	G$isWithinThreshold$0$0 ==.
	C$slave_wixel_track.c$192$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:192: uint8 isWithinThreshold(int16 currentX, int16 currentY, int16 targetX, int16 targetY, int16 threshold)
;	-----------------------------------------
;	 function isWithinThreshold
;	-----------------------------------------
_isWithinThreshold:
	mov	r6,dpl
	mov	r7,dph
	C$slave_wixel_track.c$194$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:194: int16 dx = targetX - currentX;
	mov	r0,#_isWithinThreshold_PARM_3
	movx	a,@r0
	clr	c
	subb	a,r6
	mov	r6,a
	inc	r0
	movx	a,@r0
	subb	a,r7
	mov	r7,a
	C$slave_wixel_track.c$195$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:195: int16 dy = targetY - currentY;
	mov	r0,#_isWithinThreshold_PARM_4
	mov	r1,#_isWithinThreshold_PARM_2
	movx	a,@r1
	mov	b,a
	clr	c
	movx	a,@r0
	subb	a,b
	mov	r4,a
	inc	r1
	movx	a,@r1
	mov	b,a
	inc	r0
	movx	a,@r0
	subb	a,b
	mov	r5,a
	C$slave_wixel_track.c$196$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:196: int32 distSquared = (int32)dx * dx + (int32)dy * dy;
	mov	a,r7
	rlc	a
	subb	a,acc
	mov	r3,a
	mov	r2,a
	mov	r0,#__mullong_PARM_2
	mov	a,r6
	movx	@r0,a
	inc	r0
	mov	a,r7
	movx	@r0,a
	inc	r0
	mov	a,r3
	movx	@r0,a
	inc	r0
	mov	a,r2
	movx	@r0,a
	mov	dpl,r6
	mov	dph,r7
	mov	b,r3
	mov	a,r2
	push	ar5
	push	ar4
	lcall	__mullong
	mov	_isWithinThreshold_sloc0_1_0,dpl
	mov	(_isWithinThreshold_sloc0_1_0 + 1),dph
	mov	(_isWithinThreshold_sloc0_1_0 + 2),b
	mov	(_isWithinThreshold_sloc0_1_0 + 3),a
	pop	ar4
	pop	ar5
	mov	a,r5
	rlc	a
	subb	a,acc
	mov	r6,a
	mov	r7,a
	mov	r0,#__mullong_PARM_2
	mov	a,r4
	movx	@r0,a
	inc	r0
	mov	a,r5
	movx	@r0,a
	inc	r0
	mov	a,r6
	movx	@r0,a
	inc	r0
	mov	a,r7
	movx	@r0,a
	mov	dpl,r4
	mov	dph,r5
	mov	b,r6
	mov	a,r7
	lcall	__mullong
	mov	r4,dpl
	mov	r5,dph
	mov	r6,b
	mov	r7,a
	mov	r0,#_isWithinThreshold_distSquared_1_1
	mov	a,r4
	add	a,_isWithinThreshold_sloc0_1_0
	movx	@r0,a
	mov	a,r5
	addc	a,(_isWithinThreshold_sloc0_1_0 + 1)
	inc	r0
	movx	@r0,a
	mov	a,r6
	addc	a,(_isWithinThreshold_sloc0_1_0 + 2)
	inc	r0
	movx	@r0,a
	mov	a,r7
	addc	a,(_isWithinThreshold_sloc0_1_0 + 3)
	inc	r0
	movx	@r0,a
	C$slave_wixel_track.c$197$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:197: int32 thresholdSquared = (int32)threshold * threshold;
	mov	r0,#_isWithinThreshold_PARM_5
	movx	a,@r0
	mov	r2,a
	inc	r0
	movx	a,@r0
	mov	r3,a
	movx	a,@r0
	rlc	a
	subb	a,acc
	mov	r6,a
	mov	r7,a
	mov	r0,#__mullong_PARM_2
	mov	a,r2
	movx	@r0,a
	inc	r0
	mov	a,r3
	movx	@r0,a
	inc	r0
	mov	a,r6
	movx	@r0,a
	inc	r0
	mov	a,r7
	movx	@r0,a
	mov	dpl,r2
	mov	dph,r3
	mov	b,r6
	mov	a,r7
	lcall	__mullong
	mov	r4,dpl
	mov	r5,dph
	mov	r6,b
	mov	r7,a
	C$slave_wixel_track.c$199$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:199: return (distSquared < thresholdSquared);
	mov	r0,#_isWithinThreshold_distSquared_1_1
	clr	c
	movx	a,@r0
	subb	a,r4
	inc	r0
	movx	a,@r0
	subb	a,r5
	inc	r0
	movx	a,@r0
	subb	a,r6
	inc	r0
	movx	a,@r0
	xrl	a,#0x80
	mov	b,r7
	xrl	b,#0x80
	subb	a,b
	clr	a
	rlc	a
	C$slave_wixel_track.c$200$1$1 ==.
	XG$isWithinThreshold$0$0 ==.
	mov	dpl,a
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'calculateTargetHeading'
;------------------------------------------------------------
;sloc0                     Allocated with name '_calculateTargetHeading_sloc0_1_0'
;------------------------------------------------------------
	G$calculateTargetHeading$0$0 ==.
	C$slave_wixel_track.c$204$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:204: int16 calculateTargetHeading(int16 currentX, int16 currentY, int16 goalX, int16 goalY)
;	-----------------------------------------
;	 function calculateTargetHeading
;	-----------------------------------------
_calculateTargetHeading:
	mov	r6,dpl
	mov	r7,dph
	C$slave_wixel_track.c$211$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:211: dx = (int32)goalX - (int32)currentX;
	mov	r0,#_calculateTargetHeading_PARM_3
	movx	a,@r0
	mov	_calculateTargetHeading_sloc0_1_0,a
	inc	r0
	movx	a,@r0
	mov	(_calculateTargetHeading_sloc0_1_0 + 1),a
	movx	a,@r0
	rlc	a
	subb	a,acc
	mov	(_calculateTargetHeading_sloc0_1_0 + 2),a
	mov	(_calculateTargetHeading_sloc0_1_0 + 3),a
	mov	ar4,r6
	mov	a,r7
	mov	r5,a
	rlc	a
	subb	a,acc
	mov	r6,a
	mov	r7,a
	mov	r0,#_calculateTargetHeading_dx_1_1
	mov	a,_calculateTargetHeading_sloc0_1_0
	clr	c
	subb	a,r4
	movx	@r0,a
	mov	a,(_calculateTargetHeading_sloc0_1_0 + 1)
	subb	a,r5
	inc	r0
	movx	@r0,a
	mov	a,(_calculateTargetHeading_sloc0_1_0 + 2)
	subb	a,r6
	inc	r0
	movx	@r0,a
	mov	a,(_calculateTargetHeading_sloc0_1_0 + 3)
	subb	a,r7
	inc	r0
	movx	@r0,a
	C$slave_wixel_track.c$212$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:212: dy = (int32)goalY - (int32)currentY;
	mov	r0,#_calculateTargetHeading_PARM_4
	movx	a,@r0
	mov	_calculateTargetHeading_sloc0_1_0,a
	inc	r0
	movx	a,@r0
	mov	(_calculateTargetHeading_sloc0_1_0 + 1),a
	movx	a,@r0
	rlc	a
	subb	a,acc
	mov	(_calculateTargetHeading_sloc0_1_0 + 2),a
	mov	(_calculateTargetHeading_sloc0_1_0 + 3),a
	mov	r0,#_calculateTargetHeading_PARM_2
	movx	a,@r0
	mov	r4,a
	inc	r0
	movx	a,@r0
	mov	r5,a
	movx	a,@r0
	rlc	a
	subb	a,acc
	mov	r6,a
	mov	r7,a
	mov	a,_calculateTargetHeading_sloc0_1_0
	clr	c
	subb	a,r4
	mov	r4,a
	mov	a,(_calculateTargetHeading_sloc0_1_0 + 1)
	subb	a,r5
	mov	r5,a
	mov	a,(_calculateTargetHeading_sloc0_1_0 + 2)
	subb	a,r6
	mov	r6,a
	mov	a,(_calculateTargetHeading_sloc0_1_0 + 3)
	subb	a,r7
	mov	r7,a
	C$slave_wixel_track.c$214$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:214: if (dx == 0 && dy == 0)
	mov	r0,#_calculateTargetHeading_dx_1_1
	movx	a,@r0
	mov	b,a
	inc	r0
	movx	a,@r0
	orl	b,a
	inc	r0
	movx	a,@r0
	orl	b,a
	inc	r0
	movx	a,@r0
	orl	a,b
	jnz	00102$
	mov	a,r4
	orl	a,r5
	orl	a,r6
	orl	a,r7
	jnz	00102$
	C$slave_wixel_track.c$215$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:215: return 0;
	mov	dptr,#0x0000
	ljmp	00123$
00102$:
	C$slave_wixel_track.c$217$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:217: if (dx == 0)
	mov	r0,#_calculateTargetHeading_dx_1_1
	movx	a,@r0
	mov	b,a
	inc	r0
	movx	a,@r0
	orl	b,a
	inc	r0
	movx	a,@r0
	orl	b,a
	inc	r0
	movx	a,@r0
	orl	a,b
	jnz	00105$
	C$slave_wixel_track.c$218$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:218: return (dy > 0) ? 90 : -90;
	clr	c
	clr	a
	subb	a,r4
	clr	a
	subb	a,r5
	clr	a
	subb	a,r6
	clr	a
	xrl	a,#0x80
	mov	b,r7
	xrl	b,#0x80
	subb	a,b
	jnc	00125$
	mov	r3,#0x5A
	sjmp	00126$
00125$:
	mov	r3,#0xA6
00126$:
	mov	a,r3
	rlc	a
	subb	a,acc
	mov	r2,a
	mov	dpl,r3
	mov	dph,r2
	ljmp	00123$
00105$:
	C$slave_wixel_track.c$220$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:220: if (dy == 0)
	mov	a,r4
	orl	a,r5
	orl	a,r6
	orl	a,r7
	jnz	00107$
	C$slave_wixel_track.c$221$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:221: return (dx > 0) ? 0 : 180;
	mov	r0,#_calculateTargetHeading_dx_1_1
	clr	c
	movx	a,@r0
	mov	b,a
	clr	a
	subb	a,b
	inc	r0
	movx	a,@r0
	mov	b,a
	clr	a
	subb	a,b
	inc	r0
	movx	a,@r0
	mov	b,a
	clr	a
	subb	a,b
	inc	r0
	movx	a,@r0
	mov	b,a
	clr	a
	xrl	a,#0x80
	xrl	b,#0x80
	subb	a,b
	jnc	00127$
	mov	r3,#0x00
	sjmp	00128$
00127$:
	mov	r3,#0xB4
00128$:
	mov	r2,#0x00
	mov	dpl,r3
	mov	dph,r2
	ljmp	00123$
00107$:
	C$slave_wixel_track.c$223$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:223: absX = (dx > 0) ? dx : -dx;
	mov	r0,#_calculateTargetHeading_dx_1_1
	clr	c
	movx	a,@r0
	mov	b,a
	clr	a
	subb	a,b
	inc	r0
	movx	a,@r0
	mov	b,a
	clr	a
	subb	a,b
	inc	r0
	movx	a,@r0
	mov	b,a
	clr	a
	subb	a,b
	inc	r0
	movx	a,@r0
	mov	b,a
	clr	a
	xrl	a,#0x80
	xrl	b,#0x80
	subb	a,b
	jnc	00129$
	mov	r0,#_calculateTargetHeading_dx_1_1
	mov	r1,#_calculateTargetHeading_absX_1_1
	movx	a,@r0
	movx	@r1,a
	inc	r0
	movx	a,@r0
	inc	r1
	movx	@r1,a
	inc	r0
	movx	a,@r0
	inc	r1
	movx	@r1,a
	inc	r0
	movx	a,@r0
	inc	r1
	movx	@r1,a
	sjmp	00130$
00129$:
	mov	r0,#_calculateTargetHeading_dx_1_1
	mov	r1,#_calculateTargetHeading_absX_1_1
	movx	a,@r0
	setb	c
	cpl	a
	addc	a,#0x00
	movx	@r1,a
	inc	r0
	movx	a,@r0
	cpl	a
	addc	a,#0x00
	inc	r1
	movx	@r1,a
	inc	r0
	movx	a,@r0
	cpl	a
	addc	a,#0x00
	inc	r1
	movx	@r1,a
	inc	r0
	movx	a,@r0
	cpl	a
	addc	a,#0x00
	inc	r1
	movx	@r1,a
00130$:
	mov	r0,#_calculateTargetHeading_absX_1_1
	C$slave_wixel_track.c$224$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:224: absY = (dy > 0) ? dy : -dy;
	clr	c
	clr	a
	subb	a,r4
	clr	a
	subb	a,r5
	clr	a
	subb	a,r6
	clr	a
	xrl	a,#0x80
	mov	b,r7
	xrl	b,#0x80
	subb	a,b
	jnc	00131$
	mov	r0,#_calculateTargetHeading_absY_1_1
	mov	a,r4
	movx	@r0,a
	inc	r0
	mov	a,r5
	movx	@r0,a
	inc	r0
	mov	a,r6
	movx	@r0,a
	inc	r0
	mov	a,r7
	movx	@r0,a
	sjmp	00132$
00131$:
	mov	r0,#_calculateTargetHeading_absY_1_1
	clr	c
	clr	a
	subb	a,r4
	movx	@r0,a
	clr	a
	subb	a,r5
	inc	r0
	movx	@r0,a
	clr	a
	subb	a,r6
	inc	r0
	movx	@r0,a
	clr	a
	subb	a,r7
	inc	r0
	movx	@r0,a
00132$:
	C$slave_wixel_track.c$226$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:226: if (absX > absY)
	mov	r0,#_calculateTargetHeading_absX_1_1
	mov	r1,#_calculateTargetHeading_absY_1_1
	clr	c
	movx	a,@r0
	mov	b,a
	movx	a,@r1
	subb	a,b
	inc	r0
	movx	a,@r0
	mov	b,a
	inc	r1
	movx	a,@r1
	subb	a,b
	inc	r0
	movx	a,@r0
	mov	b,a
	inc	r1
	movx	a,@r1
	subb	a,b
	inc	r0
	movx	a,@r0
	mov	b,a
	inc	r1
	movx	a,@r1
	xrl	a,#0x80
	xrl	b,#0x80
	subb	a,b
	jc	00156$
	ljmp	00109$
00156$:
	C$slave_wixel_track.c$228$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:228: ratio = (absY * 1000L) / absX;
	push	ar4
	push	ar5
	push	ar6
	push	ar7
	mov	r0,#_calculateTargetHeading_absY_1_1
	mov	r1,#__mullong_PARM_2
	movx	a,@r0
	movx	@r1,a
	inc	r0
	movx	a,@r0
	inc	r1
	movx	@r1,a
	inc	r0
	movx	a,@r0
	inc	r1
	movx	@r1,a
	inc	r0
	movx	a,@r0
	inc	r1
	movx	@r1,a
	mov	dptr,#0x03E8
	clr	a
	mov	b,a
	push	ar5
	push	ar4
	lcall	__mullong
	mov	r2,dpl
	mov	r3,dph
	mov	r6,b
	mov	r7,a
	pop	ar4
	pop	ar5
	mov	r0,#_calculateTargetHeading_absX_1_1
	mov	r1,#__divslong_PARM_2
	movx	a,@r0
	movx	@r1,a
	inc	r0
	movx	a,@r0
	inc	r1
	movx	@r1,a
	inc	r0
	movx	a,@r0
	inc	r1
	movx	@r1,a
	inc	r0
	movx	a,@r0
	inc	r1
	movx	@r1,a
	mov	dpl,r2
	mov	dph,r3
	mov	b,r6
	mov	a,r7
	push	ar7
	push	ar6
	push	ar5
	push	ar4
	lcall	__divslong
	mov	r0,#_calculateTargetHeading_ratio_1_1
	push	acc
	mov	a,dpl
	movx	@r0,a
	inc	r0
	mov	a,dph
	movx	@r0,a
	inc	r0
	mov	a,b
	movx	@r0,a
	pop	acc
	inc	r0
	movx	@r0,a
	C$slave_wixel_track.c$229$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:229: angle = (int16)((57300L * ratio) / (1000000L + (280L * ratio * ratio) / 1000L));
	mov	r0,#_calculateTargetHeading_ratio_1_1
	mov	r1,#__mullong_PARM_2
	movx	a,@r0
	movx	@r1,a
	inc	r0
	movx	a,@r0
	inc	r1
	movx	@r1,a
	inc	r0
	movx	a,@r0
	inc	r1
	movx	@r1,a
	inc	r0
	movx	a,@r0
	inc	r1
	movx	@r1,a
	mov	dptr,#0xDFD4
	clr	a
	mov	b,a
	lcall	__mullong
	mov	_calculateTargetHeading_sloc0_1_0,dpl
	mov	(_calculateTargetHeading_sloc0_1_0 + 1),dph
	mov	(_calculateTargetHeading_sloc0_1_0 + 2),b
	mov	(_calculateTargetHeading_sloc0_1_0 + 3),a
	pop	ar4
	pop	ar5
	pop	ar6
	pop	ar7
	mov	r0,#_calculateTargetHeading_ratio_1_1
	mov	r1,#__mullong_PARM_2
	movx	a,@r0
	movx	@r1,a
	inc	r0
	movx	a,@r0
	inc	r1
	movx	@r1,a
	inc	r0
	movx	a,@r0
	inc	r1
	movx	@r1,a
	inc	r0
	movx	a,@r0
	inc	r1
	movx	@r1,a
	mov	dptr,#0x0118
	clr	a
	mov	b,a
	push	ar5
	push	ar4
	lcall	__mullong
	mov	r2,dpl
	mov	r3,dph
	mov	r6,b
	mov	r7,a
	pop	ar4
	pop	ar5
	mov	r0,#_calculateTargetHeading_ratio_1_1
	mov	r1,#__mullong_PARM_2
	movx	a,@r0
	movx	@r1,a
	inc	r0
	movx	a,@r0
	inc	r1
	movx	@r1,a
	inc	r0
	movx	a,@r0
	inc	r1
	movx	@r1,a
	inc	r0
	movx	a,@r0
	inc	r1
	movx	@r1,a
	mov	dpl,r2
	mov	dph,r3
	mov	b,r6
	mov	a,r7
	lcall	__mullong
	mov	r4,dpl
	mov	r5,dph
	mov	r6,b
	mov	r7,a
	mov	r0,#__divslong_PARM_2
	mov	a,#0xE8
	movx	@r0,a
	inc	r0
	mov	a,#0x03
	movx	@r0,a
	inc	r0
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	mov	dpl,r4
	mov	dph,r5
	mov	b,r6
	mov	a,r7
	lcall	__divslong
	mov	r4,dpl
	mov	r5,dph
	mov	r6,b
	mov	r7,a
	mov	r0,#__divslong_PARM_2
	mov	a,#0x40
	add	a,r4
	movx	@r0,a
	mov	a,#0x42
	addc	a,r5
	inc	r0
	movx	@r0,a
	mov	a,#0x0F
	addc	a,r6
	inc	r0
	movx	@r0,a
	clr	a
	addc	a,r7
	inc	r0
	movx	@r0,a
	mov	dpl,_calculateTargetHeading_sloc0_1_0
	mov	dph,(_calculateTargetHeading_sloc0_1_0 + 1)
	mov	b,(_calculateTargetHeading_sloc0_1_0 + 2)
	mov	a,(_calculateTargetHeading_sloc0_1_0 + 3)
	lcall	__divslong
	mov	r4,dpl
	mov	r5,dph
	mov	r0,#_calculateTargetHeading_angle_1_1
	mov	a,r4
	movx	@r0,a
	inc	r0
	mov	a,r5
	movx	@r0,a
	pop	ar7
	pop	ar6
	pop	ar5
	pop	ar4
	ljmp	00110$
00109$:
	C$slave_wixel_track.c$233$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:233: ratio = (absX * 1000L) / absY;
	push	ar4
	push	ar5
	push	ar6
	push	ar7
	mov	r0,#_calculateTargetHeading_absX_1_1
	mov	r1,#__mullong_PARM_2
	movx	a,@r0
	movx	@r1,a
	inc	r0
	movx	a,@r0
	inc	r1
	movx	@r1,a
	inc	r0
	movx	a,@r0
	inc	r1
	movx	@r1,a
	inc	r0
	movx	a,@r0
	inc	r1
	movx	@r1,a
	mov	dptr,#0x03E8
	clr	a
	mov	b,a
	push	ar5
	push	ar4
	lcall	__mullong
	mov	r2,dpl
	mov	r3,dph
	mov	r6,b
	mov	r7,a
	pop	ar4
	pop	ar5
	mov	r0,#_calculateTargetHeading_absY_1_1
	mov	r1,#__divslong_PARM_2
	movx	a,@r0
	movx	@r1,a
	inc	r0
	movx	a,@r0
	inc	r1
	movx	@r1,a
	inc	r0
	movx	a,@r0
	inc	r1
	movx	@r1,a
	inc	r0
	movx	a,@r0
	inc	r1
	movx	@r1,a
	mov	dpl,r2
	mov	dph,r3
	mov	b,r6
	mov	a,r7
	push	ar7
	push	ar6
	push	ar5
	push	ar4
	lcall	__divslong
	mov	r0,#_calculateTargetHeading_ratio_1_1
	push	acc
	mov	a,dpl
	movx	@r0,a
	inc	r0
	mov	a,dph
	movx	@r0,a
	inc	r0
	mov	a,b
	movx	@r0,a
	pop	acc
	inc	r0
	movx	@r0,a
	C$slave_wixel_track.c$234$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:234: angle = 90 - (int16)((57300L * ratio) / (1000000L + (280L * ratio * ratio) / 1000L));
	mov	r0,#_calculateTargetHeading_ratio_1_1
	mov	r1,#__mullong_PARM_2
	movx	a,@r0
	movx	@r1,a
	inc	r0
	movx	a,@r0
	inc	r1
	movx	@r1,a
	inc	r0
	movx	a,@r0
	inc	r1
	movx	@r1,a
	inc	r0
	movx	a,@r0
	inc	r1
	movx	@r1,a
	mov	dptr,#0xDFD4
	clr	a
	mov	b,a
	lcall	__mullong
	mov	_calculateTargetHeading_sloc0_1_0,dpl
	mov	(_calculateTargetHeading_sloc0_1_0 + 1),dph
	mov	(_calculateTargetHeading_sloc0_1_0 + 2),b
	mov	(_calculateTargetHeading_sloc0_1_0 + 3),a
	pop	ar4
	pop	ar5
	pop	ar6
	pop	ar7
	mov	r0,#_calculateTargetHeading_ratio_1_1
	mov	r1,#__mullong_PARM_2
	movx	a,@r0
	movx	@r1,a
	inc	r0
	movx	a,@r0
	inc	r1
	movx	@r1,a
	inc	r0
	movx	a,@r0
	inc	r1
	movx	@r1,a
	inc	r0
	movx	a,@r0
	inc	r1
	movx	@r1,a
	mov	dptr,#0x0118
	clr	a
	mov	b,a
	push	ar5
	push	ar4
	lcall	__mullong
	mov	r2,dpl
	mov	r3,dph
	mov	r6,b
	mov	r7,a
	pop	ar4
	pop	ar5
	mov	r0,#_calculateTargetHeading_ratio_1_1
	mov	r1,#__mullong_PARM_2
	movx	a,@r0
	movx	@r1,a
	inc	r0
	movx	a,@r0
	inc	r1
	movx	@r1,a
	inc	r0
	movx	a,@r0
	inc	r1
	movx	@r1,a
	inc	r0
	movx	a,@r0
	inc	r1
	movx	@r1,a
	mov	dpl,r2
	mov	dph,r3
	mov	b,r6
	mov	a,r7
	lcall	__mullong
	mov	r4,dpl
	mov	r5,dph
	mov	r6,b
	mov	r7,a
	mov	r0,#__divslong_PARM_2
	mov	a,#0xE8
	movx	@r0,a
	inc	r0
	mov	a,#0x03
	movx	@r0,a
	inc	r0
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	mov	dpl,r4
	mov	dph,r5
	mov	b,r6
	mov	a,r7
	lcall	__divslong
	mov	r4,dpl
	mov	r5,dph
	mov	r6,b
	mov	r7,a
	mov	r0,#__divslong_PARM_2
	mov	a,#0x40
	add	a,r4
	movx	@r0,a
	mov	a,#0x42
	addc	a,r5
	inc	r0
	movx	@r0,a
	mov	a,#0x0F
	addc	a,r6
	inc	r0
	movx	@r0,a
	clr	a
	addc	a,r7
	inc	r0
	movx	@r0,a
	mov	dpl,_calculateTargetHeading_sloc0_1_0
	mov	dph,(_calculateTargetHeading_sloc0_1_0 + 1)
	mov	b,(_calculateTargetHeading_sloc0_1_0 + 2)
	mov	a,(_calculateTargetHeading_sloc0_1_0 + 3)
	lcall	__divslong
	mov	r4,dpl
	mov	r5,dph
	mov	r0,#_calculateTargetHeading_angle_1_1
	mov	a,#0x5A
	clr	c
	subb	a,r4
	movx	@r0,a
	clr	a
	subb	a,r5
	inc	r0
	movx	@r0,a
	C$slave_wixel_track.c$244$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:244: return -angle;
	pop	ar7
	pop	ar6
	pop	ar5
	pop	ar4
	C$slave_wixel_track.c$234$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:234: angle = 90 - (int16)((57300L * ratio) / (1000000L + (280L * ratio * ratio) / 1000L));
00110$:
	C$slave_wixel_track.c$237$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:237: if (dx >= 0 && dy >= 0)
	mov	r0,#(_calculateTargetHeading_dx_1_1 + 3)
	movx	a,@r0
	rlc	a
	clr	a
	rlc	a
	mov	r3,a
	jnz	00120$
	mov	a,r7
	jb	acc.7,00120$
	C$slave_wixel_track.c$238$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:238: return angle;
	mov	r0,#_calculateTargetHeading_angle_1_1
	movx	a,@r0
	mov	dpl,a
	inc	r0
	movx	a,@r0
	mov	dph,a
	sjmp	00123$
00120$:
	C$slave_wixel_track.c$239$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:239: else if (dx < 0 && dy >= 0)
	mov	a,r3
	jz	00116$
	mov	a,r7
	jb	acc.7,00116$
	C$slave_wixel_track.c$240$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:240: return 180 - angle;
	mov	r0,#_calculateTargetHeading_angle_1_1
	setb	c
	movx	a,@r0
	subb	a,#0xB4
	cpl	a
	cpl	c
	mov	dpl,a
	cpl	c
	inc	r0
	movx	a,@r0
	subb	a,#0x00
	cpl	a
	mov	dph,a
	sjmp	00123$
00116$:
	C$slave_wixel_track.c$241$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:241: else if (dx < 0 && dy < 0)
	mov	a,r3
	jz	00112$
	mov	a,r7
	jnb	acc.7,00112$
	C$slave_wixel_track.c$242$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:242: return angle - 180;
	mov	r0,#_calculateTargetHeading_angle_1_1
	movx	a,@r0
	add	a,#0x4C
	mov	dpl,a
	inc	r0
	movx	a,@r0
	addc	a,#0xFF
	mov	dph,a
	sjmp	00123$
00112$:
	C$slave_wixel_track.c$244$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:244: return -angle;
	mov	r0,#_calculateTargetHeading_angle_1_1
	movx	a,@r0
	setb	c
	cpl	a
	addc	a,#0x00
	mov	dpl,a
	inc	r0
	movx	a,@r0
	cpl	a
	addc	a,#0x00
	mov	dph,a
00123$:
	C$slave_wixel_track.c$245$1$1 ==.
	XG$calculateTargetHeading$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'calculateAndApplyOffset'
;------------------------------------------------------------
;sloc0                     Allocated with name '_calculateAndApplyOffset_sloc0_1_0'
;------------------------------------------------------------
	G$calculateAndApplyOffset$0$0 ==.
	C$slave_wixel_track.c$247$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:247: void calculateAndApplyOffset()
;	-----------------------------------------
;	 function calculateAndApplyOffset
;	-----------------------------------------
_calculateAndApplyOffset:
	C$slave_wixel_track.c$250$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:250: actualHeading = calculateTargetHeading(calData.xa, calData.ya, calData.xb, calData.yb);
	mov	r0,#_calData
	movx	a,@r0
	mov	r6,a
	inc	r0
	movx	a,@r0
	mov	r7,a
	mov	r0,#(_calData + 0x0002)
	movx	a,@r0
	mov	r4,a
	inc	r0
	movx	a,@r0
	mov	r5,a
	mov	r0,#(_calData + 0x0006)
	movx	a,@r0
	mov	_calculateAndApplyOffset_sloc0_1_0,a
	inc	r0
	movx	a,@r0
	mov	(_calculateAndApplyOffset_sloc0_1_0 + 1),a
	mov	r0,#(_calData + 0x0008)
	movx	a,@r0
	mov	r2,a
	inc	r0
	movx	a,@r0
	mov	r3,a
	mov	r0,#_calculateTargetHeading_PARM_2
	mov	a,r4
	movx	@r0,a
	inc	r0
	mov	a,r5
	movx	@r0,a
	mov	r0,#_calculateTargetHeading_PARM_3
	mov	a,_calculateAndApplyOffset_sloc0_1_0
	movx	@r0,a
	inc	r0
	mov	a,(_calculateAndApplyOffset_sloc0_1_0 + 1)
	movx	@r0,a
	mov	r0,#_calculateTargetHeading_PARM_4
	mov	a,r2
	movx	@r0,a
	inc	r0
	mov	a,r3
	movx	@r0,a
	mov	dpl,r6
	mov	dph,r7
	lcall	_calculateTargetHeading
	mov	r6,dpl
	mov	r7,dph
	C$slave_wixel_track.c$251$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:251: reportedHeading = calData.thetaa;
	mov	r0,#(_calData + 0x0004)
	movx	a,@r0
	mov	r4,a
	inc	r0
	movx	a,@r0
	mov	r5,a
	C$slave_wixel_track.c$252$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:252: orientationOffset = actualHeading - reportedHeading;
	mov	a,r6
	clr	c
	subb	a,r4
	mov	r6,a
	mov	a,r7
	subb	a,r5
	mov	r7,a
	mov	r0,#_orientationOffset
	mov	a,r6
	movx	@r0,a
	inc	r0
	mov	a,r7
	movx	@r0,a
	C$slave_wixel_track.c$254$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:254: if (orientationOffset > 180) { orientationOffset -= 360; }
	clr	c
	mov	a,#0xB4
	subb	a,r6
	clr	a
	xrl	a,#0x80
	mov	b,r7
	xrl	b,#0x80
	subb	a,b
	jnc	00102$
	mov	r0,#_orientationOffset
	mov	a,r6
	add	a,#0x98
	movx	@r0,a
	mov	a,r7
	addc	a,#0xFE
	inc	r0
	movx	@r0,a
00102$:
	C$slave_wixel_track.c$255$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:255: if (orientationOffset < -180) { orientationOffset += 360; }
	mov	r0,#_orientationOffset
	clr	c
	movx	a,@r0
	subb	a,#0x4C
	inc	r0
	movx	a,@r0
	xrl	a,#0x80
	subb	a,#0x7f
	jnc	00105$
	mov	r0,#_orientationOffset
	movx	a,@r0
	add	a,#0x68
	movx	@r0,a
	inc	r0
	movx	a,@r0
	addc	a,#0x01
	movx	@r0,a
00105$:
	C$slave_wixel_track.c$256$2$1 ==.
	XG$calculateAndApplyOffset$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'filterPosition'
;------------------------------------------------------------
;sloc0                     Allocated with name '_filterPosition_sloc0_1_0'
;------------------------------------------------------------
	G$filterPosition$0$0 ==.
	C$slave_wixel_track.c$258$2$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:258: void filterPosition()
;	-----------------------------------------
;	 function filterPosition
;	-----------------------------------------
_filterPosition:
	C$slave_wixel_track.c$264$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:264: dx = posX - filteredX;
	mov	r0,#_posX
	mov	r1,#_filteredX
	movx	a,@r1
	mov	b,a
	clr	c
	movx	a,@r0
	subb	a,b
	mov	r6,a
	inc	r1
	movx	a,@r1
	mov	b,a
	inc	r0
	movx	a,@r0
	subb	a,b
	mov	r7,a
	C$slave_wixel_track.c$265$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:265: dy = posY - filteredY;
	mov	r0,#_posY
	mov	r1,#_filteredY
	movx	a,@r1
	mov	b,a
	clr	c
	movx	a,@r0
	subb	a,b
	mov	r4,a
	inc	r1
	movx	a,@r1
	mov	b,a
	inc	r0
	movx	a,@r0
	subb	a,b
	mov	r5,a
	C$slave_wixel_track.c$266$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:266: distSquared = (int32)dx * dx + (int32)dy * dy;
	mov	a,r7
	rlc	a
	subb	a,acc
	mov	r3,a
	mov	r2,a
	mov	r0,#__mullong_PARM_2
	mov	a,r6
	movx	@r0,a
	inc	r0
	mov	a,r7
	movx	@r0,a
	inc	r0
	mov	a,r3
	movx	@r0,a
	inc	r0
	mov	a,r2
	movx	@r0,a
	mov	dpl,r6
	mov	dph,r7
	mov	b,r3
	mov	a,r2
	push	ar5
	push	ar4
	lcall	__mullong
	mov	_filterPosition_sloc0_1_0,dpl
	mov	(_filterPosition_sloc0_1_0 + 1),dph
	mov	(_filterPosition_sloc0_1_0 + 2),b
	mov	(_filterPosition_sloc0_1_0 + 3),a
	pop	ar4
	pop	ar5
	mov	a,r5
	rlc	a
	subb	a,acc
	mov	r6,a
	mov	r7,a
	mov	r0,#__mullong_PARM_2
	mov	a,r4
	movx	@r0,a
	inc	r0
	mov	a,r5
	movx	@r0,a
	inc	r0
	mov	a,r6
	movx	@r0,a
	inc	r0
	mov	a,r7
	movx	@r0,a
	mov	dpl,r4
	mov	dph,r5
	mov	b,r6
	mov	a,r7
	lcall	__mullong
	mov	r4,dpl
	mov	r5,dph
	mov	r6,b
	mov	r7,a
	mov	a,r4
	add	a,_filterPosition_sloc0_1_0
	mov	r4,a
	mov	a,r5
	addc	a,(_filterPosition_sloc0_1_0 + 1)
	mov	r5,a
	mov	a,r6
	addc	a,(_filterPosition_sloc0_1_0 + 2)
	mov	r6,a
	mov	a,r7
	addc	a,(_filterPosition_sloc0_1_0 + 3)
	mov	r7,a
	C$slave_wixel_track.c$268$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:268: if (distSquared > (int32)POSITION_JUMP_THRESHOLD * POSITION_JUMP_THRESHOLD)
	clr	c
	mov	a,#0x90
	subb	a,r4
	mov	a,#0xD0
	subb	a,r5
	mov	a,#0x03
	subb	a,r6
	clr	a
	xrl	a,#0x80
	mov	b,r7
	xrl	b,#0x80
	subb	a,b
	clr	a
	rlc	a
	C$slave_wixel_track.c$279$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:279: filteredX = posX;
	mov	r0,#_posX
	movx	a,@r0
	mov	r6,a
	inc	r0
	movx	a,@r0
	mov	r7,a
	mov	r0,#_filteredX
	mov	a,r6
	movx	@r0,a
	inc	r0
	mov	a,r7
	movx	@r0,a
	C$slave_wixel_track.c$280$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:280: filteredY = posY;
	mov	r0,#_posY
	movx	a,@r0
	mov	r6,a
	inc	r0
	movx	a,@r0
	mov	r7,a
	mov	r0,#_filteredY
	mov	a,r6
	movx	@r0,a
	inc	r0
	mov	a,r7
	movx	@r0,a
	C$slave_wixel_track.c$281$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:281: filteredTheta = posTheta;
	mov	r0,#_posTheta
	movx	a,@r0
	mov	r6,a
	inc	r0
	movx	a,@r0
	mov	r7,a
	mov	r0,#_filteredTheta
	mov	a,r6
	movx	@r0,a
	inc	r0
	mov	a,r7
	movx	@r0,a
	C$slave_wixel_track.c$282$1$1 ==.
	XG$filterPosition$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'rotationController'
;------------------------------------------------------------
	G$rotationController$0$0 ==.
	C$slave_wixel_track.c$284$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:284: void rotationController(int16 currentHeading, int16 targetHeading)
;	-----------------------------------------
;	 function rotationController
;	-----------------------------------------
_rotationController:
	mov	r6,dpl
	mov	r7,dph
	C$slave_wixel_track.c$291$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:291: error = targetHeading - currentHeading;
	mov	r0,#_rotationController_PARM_2
	movx	a,@r0
	clr	c
	subb	a,r6
	mov	r6,a
	inc	r0
	movx	a,@r0
	subb	a,r7
	mov	r7,a
	C$slave_wixel_track.c$293$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:293: if (error > 180)
	clr	c
	mov	a,#0xB4
	subb	a,r6
	clr	a
	xrl	a,#0x80
	mov	b,r7
	xrl	b,#0x80
	subb	a,b
	jnc	00102$
	C$slave_wixel_track.c$294$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:294: error -= 360;
	mov	a,r6
	add	a,#0x98
	mov	r6,a
	mov	a,r7
	addc	a,#0xFE
	mov	r7,a
00102$:
	C$slave_wixel_track.c$295$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:295: if (error < -180)
	clr	c
	mov	a,r6
	subb	a,#0x4C
	mov	a,r7
	xrl	a,#0x80
	subb	a,#0x7f
	jnc	00104$
	C$slave_wixel_track.c$296$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:296: error += 360;
	mov	a,#0x68
	add	a,r6
	mov	r6,a
	mov	a,#0x01
	addc	a,r7
	mov	r7,a
00104$:
	C$slave_wixel_track.c$298$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:298: abs_error = (error >= 0) ? error : -error;
	mov	a,r7
	rlc	a
	cpl	c
	clr	a
	rlc	a
	mov	r5,a
	jz	00125$
	mov	ar4,r6
	mov	ar5,r7
	sjmp	00126$
00125$:
	clr	c
	clr	a
	subb	a,r6
	mov	r4,a
	clr	a
	subb	a,r7
	mov	r5,a
00126$:
	C$slave_wixel_track.c$300$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:300: if (abs_error < HEADING_THRESHOLD)
	clr	c
	mov	a,r4
	subb	a,#0x05
	mov	a,r5
	xrl	a,#0x80
	subb	a,#0x80
	jnc	00106$
	C$slave_wixel_track.c$302$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:302: pwm_left = 0;
	mov	r0,#_pwm_left
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	C$slave_wixel_track.c$303$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:303: pwm_right = 0;
	mov	r0,#_pwm_right
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	C$slave_wixel_track.c$304$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:304: return;
	ljmp	00123$
00106$:
	C$slave_wixel_track.c$307$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:307: pwm_raw = ((int32)error * ROTATION_KP_NUM) / ROTATION_KP_DEN;
	mov	r0,#__mullong_PARM_2
	mov	a,r6
	movx	@r0,a
	inc	r0
	mov	a,r7
	movx	@r0,a
	mov	a,r7
	rlc	a
	subb	a,acc
	inc	r0
	movx	@r0,a
	inc	r0
	movx	@r0,a
	mov	dptr,#(0x03&0x00ff)
	clr	a
	mov	b,a
	lcall	__mullong
	mov	r4,dpl
	mov	r5,dph
	mov	r6,b
	mov	r7,a
	mov	r0,#__divslong_PARM_2
	mov	a,#0x02
	movx	@r0,a
	inc	r0
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	inc	r0
	movx	@r0,a
	mov	dpl,r4
	mov	dph,r5
	mov	b,r6
	mov	a,r7
	lcall	__divslong
	mov	r4,dpl
	mov	r5,dph
	mov	r6,b
	mov	r7,a
	C$slave_wixel_track.c$309$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:309: if (pwm_raw > MAX_ROTATION_PWM)
	clr	c
	mov	a,#0x64
	subb	a,r4
	clr	a
	subb	a,r5
	clr	a
	subb	a,r6
	clr	a
	xrl	a,#0x80
	mov	b,r7
	xrl	b,#0x80
	subb	a,b
	jnc	00111$
	C$slave_wixel_track.c$310$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:310: pwm = MAX_ROTATION_PWM;
	mov	r2,#0x64
	mov	r3,#0x00
	sjmp	00112$
00111$:
	C$slave_wixel_track.c$311$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:311: else if (pwm_raw < -MAX_ROTATION_PWM)
	clr	c
	mov	a,r4
	subb	a,#0x9C
	mov	a,r5
	subb	a,#0xFF
	mov	a,r6
	subb	a,#0xFF
	mov	a,r7
	xrl	a,#0x80
	subb	a,#0x7f
	jnc	00108$
	C$slave_wixel_track.c$312$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:312: pwm = -MAX_ROTATION_PWM;
	mov	r2,#0x9C
	mov	r3,#0xFF
	sjmp	00112$
00108$:
	C$slave_wixel_track.c$314$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:314: pwm = (int16)pwm_raw;
	mov	ar2,r4
	mov	ar3,r5
00112$:
	C$slave_wixel_track.c$316$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:316: if (pwm > 0 && pwm < MIN_ROTATION_PWM)
	clr	c
	clr	a
	subb	a,r2
	clr	a
	xrl	a,#0x80
	mov	b,r3
	xrl	b,#0x80
	subb	a,b
	jnc	00117$
	clr	c
	mov	a,r2
	subb	a,#0x32
	mov	a,r3
	xrl	a,#0x80
	subb	a,#0x80
	jnc	00117$
	C$slave_wixel_track.c$317$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:317: pwm = MIN_ROTATION_PWM;
	mov	r2,#0x32
	mov	r3,#0x00
	sjmp	00118$
00117$:
	C$slave_wixel_track.c$318$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:318: else if (pwm < 0 && pwm > -MIN_ROTATION_PWM)
	mov	a,r3
	jnb	acc.7,00118$
	clr	c
	mov	a,#0xCE
	subb	a,r2
	mov	a,#(0xFF ^ 0x80)
	mov	b,r3
	xrl	b,#0x80
	subb	a,b
	jnc	00118$
	C$slave_wixel_track.c$319$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:319: pwm = -MIN_ROTATION_PWM;
	mov	r2,#0xCE
	mov	r3,#0xFF
00118$:
	C$slave_wixel_track.c$321$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:321: if (pwm > 0)
	clr	c
	clr	a
	subb	a,r2
	clr	a
	xrl	a,#0x80
	mov	b,r3
	xrl	b,#0x80
	subb	a,b
	jnc	00121$
	C$slave_wixel_track.c$323$2$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:323: pwm_left = -pwm;
	clr	c
	clr	a
	subb	a,r2
	mov	r6,a
	clr	a
	subb	a,r3
	mov	r7,a
	mov	r0,#_pwm_left
	mov	a,r6
	movx	@r0,a
	inc	r0
	mov	a,r7
	movx	@r0,a
	C$slave_wixel_track.c$324$2$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:324: pwm_right = pwm;
	mov	r0,#_pwm_right
	mov	a,r2
	movx	@r0,a
	inc	r0
	mov	a,r3
	movx	@r0,a
	sjmp	00123$
00121$:
	C$slave_wixel_track.c$328$2$4 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:328: pwm_left = -pwm;
	clr	c
	clr	a
	subb	a,r2
	mov	r6,a
	clr	a
	subb	a,r3
	mov	r7,a
	mov	r0,#_pwm_left
	mov	a,r6
	movx	@r0,a
	inc	r0
	mov	a,r7
	movx	@r0,a
	C$slave_wixel_track.c$329$2$4 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:329: pwm_right = pwm;
	mov	r0,#_pwm_right
	mov	a,r2
	movx	@r0,a
	inc	r0
	mov	a,r3
	movx	@r0,a
00123$:
	C$slave_wixel_track.c$331$1$1 ==.
	XG$rotationController$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'timer3Init'
;------------------------------------------------------------
	G$timer3Init$0$0 ==.
	C$slave_wixel_track.c$335$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:335: void timer3Init()
;	-----------------------------------------
;	 function timer3Init
;	-----------------------------------------
_timer3Init:
	C$slave_wixel_track.c$337$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:337: T3CTL = 0b01110000;
	mov	_T3CTL,#0x70
	C$slave_wixel_track.c$338$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:338: T3CC0 = T3CC1 = 0;
	mov	_T3CC1,#0x00
	mov	_T3CC0,#0x00
	C$slave_wixel_track.c$339$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:339: T3CCTL0 = T3CCTL1 = 0b00100100;
	mov	_T3CCTL1,#0x24
	mov	_T3CCTL0,#0x24
	C$slave_wixel_track.c$340$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:340: PERCFG &= ~(1<<5);
	mov	r7,_PERCFG
	anl	ar7,#0xDF
	mov	_PERCFG,r7
	C$slave_wixel_track.c$341$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:341: P1SEL |= (1<<R_PWM_PIN) | (1<<L_PWM_PIN);
	orl	_P1SEL,#0x18
	C$slave_wixel_track.c$342$1$1 ==.
	XG$timer3Init$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'setMotorsPWM'
;------------------------------------------------------------
	G$setMotorsPWM$0$0 ==.
	C$slave_wixel_track.c$344$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:344: void setMotorsPWM()
;	-----------------------------------------
;	 function setMotorsPWM
;	-----------------------------------------
_setMotorsPWM:
	C$slave_wixel_track.c$346$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:346: if (pwm_left >= 0)
	mov	r0,#(_pwm_left + 1)
	movx	a,@r0
	jb	acc.7,00102$
	C$slave_wixel_track.c$348$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:348: T3CC1 = pwm_left;
	mov	r0,#_pwm_left
	movx	a,@r0
	mov	_T3CC1,a
	C$slave_wixel_track.c$349$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:349: P1_6 = 0;
	clr	_P1_6
	sjmp	00103$
00102$:
	C$slave_wixel_track.c$353$2$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:353: T3CC1 = -pwm_left;
	mov	r0,#_pwm_left
	movx	a,@r0
	mov	r7,a
	clr	c
	clr	a
	subb	a,r7
	mov	r7,a
	mov	_T3CC1,r7
	C$slave_wixel_track.c$354$2$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:354: P1_6 = 1;
	setb	_P1_6
00103$:
	C$slave_wixel_track.c$357$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:357: if (pwm_right >= 0)
	mov	r0,#(_pwm_right + 1)
	movx	a,@r0
	jb	acc.7,00105$
	C$slave_wixel_track.c$359$2$4 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:359: T3CC0 = pwm_right;
	mov	r0,#_pwm_right
	movx	a,@r0
	mov	_T3CC0,a
	C$slave_wixel_track.c$360$2$4 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:360: P1_5 = 0;
	clr	_P1_5
	sjmp	00107$
00105$:
	C$slave_wixel_track.c$364$2$5 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:364: T3CC0 = -pwm_right;
	mov	r0,#_pwm_right
	movx	a,@r0
	mov	r7,a
	clr	c
	clr	a
	subb	a,r7
	mov	r7,a
	mov	_T3CC0,r7
	C$slave_wixel_track.c$365$2$5 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:365: P1_5 = 1;
	setb	_P1_5
00107$:
	C$slave_wixel_track.c$367$1$1 ==.
	XG$setMotorsPWM$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'stopMotors'
;------------------------------------------------------------
	G$stopMotors$0$0 ==.
	C$slave_wixel_track.c$369$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:369: void stopMotors()
;	-----------------------------------------
;	 function stopMotors
;	-----------------------------------------
_stopMotors:
	C$slave_wixel_track.c$371$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:371: T3CC0 = 0;
	mov	_T3CC0,#0x00
	C$slave_wixel_track.c$372$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:372: T3CC1 = 0;
	mov	_T3CC1,#0x00
	C$slave_wixel_track.c$373$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:373: P1_5 = 0;
	clr	_P1_5
	C$slave_wixel_track.c$374$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:374: P1_6 = 0;
	clr	_P1_6
	C$slave_wixel_track.c$375$1$1 ==.
	XG$stopMotors$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'radioInit'
;------------------------------------------------------------
	G$radioInit$0$0 ==.
	C$slave_wixel_track.c$379$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:379: void radioInit()
;	-----------------------------------------
;	 function radioInit
;	-----------------------------------------
_radioInit:
	C$slave_wixel_track.c$381$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:381: radioRegistersInit();
	lcall	_radioRegistersInit
	C$slave_wixel_track.c$382$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:382: CHANNR = 128;
	mov	dptr,#_CHANNR
	mov	a,#0x80
	movx	@dptr,a
	C$slave_wixel_track.c$383$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:383: PKTLEN = RADIO_PACKET_SIZE;
	mov	dptr,#_PKTLEN
	mov	a,#0x40
	movx	@dptr,a
	C$slave_wixel_track.c$384$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:384: MCSM0 = 0x14;
	mov	dptr,#_MCSM0
	mov	a,#0x14
	movx	@dptr,a
	C$slave_wixel_track.c$385$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:385: MCSM1 = 0x00;
	mov	dptr,#_MCSM1
	clr	a
	movx	@dptr,a
	C$slave_wixel_track.c$386$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:386: dmaConfig.radio.DC6 = 19;
	mov	dptr,#(_dmaConfig + 0x0006)
	mov	a,#0x13
	movx	@dptr,a
	C$slave_wixel_track.c$387$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:387: dmaConfig.radio.SRCADDRH = XDATA_SFR_ADDRESS(RFD) >> 8;
	mov	r6,#_RFD
	mov	r7,#0x00
	mov	a,#0xDF
	add	a,r7
	mov	r6,a
	mov	dptr,#_dmaConfig
	mov	a,r6
	movx	@dptr,a
	C$slave_wixel_track.c$388$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:388: dmaConfig.radio.SRCADDRL = XDATA_SFR_ADDRESS(RFD);
	mov	r6,#_RFD
	mov	dptr,#(_dmaConfig + 0x0001)
	mov	a,r6
	movx	@dptr,a
	C$slave_wixel_track.c$389$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:389: dmaConfig.radio.DESTADDRH = (unsigned int)rxPacket >> 8;
	mov	r6,#_rxPacket
	mov	r7,#(_rxPacket >> 8)
	mov	ar6,r7
	mov	dptr,#(_dmaConfig + 0x0002)
	mov	a,r6
	movx	@dptr,a
	C$slave_wixel_track.c$390$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:390: dmaConfig.radio.DESTADDRL = (unsigned int)rxPacket;
	mov	r6,#_rxPacket
	mov	r7,#(_rxPacket >> 8)
	mov	dptr,#(_dmaConfig + 0x0003)
	mov	a,r6
	movx	@dptr,a
	C$slave_wixel_track.c$391$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:391: dmaConfig.radio.LENL = 1 + RADIO_PACKET_SIZE + 2;
	mov	dptr,#(_dmaConfig + 0x0005)
	mov	a,#0x43
	movx	@dptr,a
	C$slave_wixel_track.c$392$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:392: dmaConfig.radio.VLEN_LENH = 0b10000000;
	mov	dptr,#(_dmaConfig + 0x0004)
	mov	a,#0x80
	movx	@dptr,a
	C$slave_wixel_track.c$393$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:393: dmaConfig.radio.DC7 = 0x10;
	mov	dptr,#(_dmaConfig + 0x0007)
	mov	a,#0x10
	movx	@dptr,a
	C$slave_wixel_track.c$394$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:394: DMAARM |= (1<<DMA_CHANNEL_RADIO);
	orl	_DMAARM,#0x02
	C$slave_wixel_track.c$395$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:395: RFST = 2;
	mov	_RFST,#0x02
	C$slave_wixel_track.c$396$1$1 ==.
	XG$radioInit$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'gpioInit'
;------------------------------------------------------------
	G$gpioInit$0$0 ==.
	C$slave_wixel_track.c$398$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:398: void gpioInit()
;	-----------------------------------------
;	 function gpioInit
;	-----------------------------------------
_gpioInit:
	C$slave_wixel_track.c$400$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:400: P1SEL = 0x00;
	mov	_P1SEL,#0x00
	C$slave_wixel_track.c$401$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:401: P1DIR = 0x00;
	mov	_P1DIR,#0x00
	C$slave_wixel_track.c$402$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:402: P1 = 0x00;
	mov	_P1,#0x00
	C$slave_wixel_track.c$403$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:403: T1CTL = 0x00;
	mov	_T1CTL,#0x00
	C$slave_wixel_track.c$404$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:404: T3CTL = 0x00;
	mov	_T3CTL,#0x00
	C$slave_wixel_track.c$405$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:405: T4CTL = 0x00;
	mov	_T4CTL,#0x00
	C$slave_wixel_track.c$406$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:406: P1DIR |= (1 << LED_RED_PIN) | (1 << LED_GREEN_PIN) | (1 << LED_BLUE_PIN);
	orl	_P1DIR,#0x86
	C$slave_wixel_track.c$407$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:407: P1DIR |= (1 << R_DIR_PIN) | (1 << L_DIR_PIN);
	orl	_P1DIR,#0x60
	C$slave_wixel_track.c$408$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:408: P1SEL = 0x00;
	mov	_P1SEL,#0x00
	C$slave_wixel_track.c$409$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:409: P1_1 = 1;
	setb	_P1_1
	C$slave_wixel_track.c$410$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:410: P1_2 = 1;
	setb	_P1_2
	C$slave_wixel_track.c$411$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:411: P1_7 = 1;
	setb	_P1_7
	C$slave_wixel_track.c$412$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:412: T3CC0 = 0;
	mov	_T3CC0,#0x00
	C$slave_wixel_track.c$413$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:413: T3CC1 = 0;
	mov	_T3CC1,#0x00
	C$slave_wixel_track.c$414$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:414: P1_5 = 0;
	clr	_P1_5
	C$slave_wixel_track.c$415$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:415: P1_6 = 0;
	clr	_P1_6
	C$slave_wixel_track.c$416$1$1 ==.
	XG$gpioInit$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'updateRgbLeds'
;------------------------------------------------------------
	G$updateRgbLeds$0$0 ==.
	C$slave_wixel_track.c$420$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:420: void updateRgbLeds()
;	-----------------------------------------
;	 function updateRgbLeds
;	-----------------------------------------
_updateRgbLeds:
	C$slave_wixel_track.c$422$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:422: if (currentState == STATE_CALIBRATE_VALIDATE)
	mov	r0,#_currentState
	movx	a,@r0
	cjne	a,#0x10,00113$
	C$slave_wixel_track.c$425$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:425: P1_2 = 0;
	clr	_P1_2
	C$slave_wixel_track.c$426$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:426: P1_1 = 0;
	clr	_P1_1
	C$slave_wixel_track.c$427$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:427: P1_7 = 1;
	setb	_P1_7
	sjmp	00115$
00113$:
	C$slave_wixel_track.c$429$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:429: else if (currentState == STATE_HOME)
	mov	r0,#_currentState
	movx	a,@r0
	cjne	a,#0x01,00110$
	C$slave_wixel_track.c$432$2$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:432: P1_2 = 1;
	setb	_P1_2
	C$slave_wixel_track.c$433$2$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:433: P1_1 = 1;
	setb	_P1_1
	C$slave_wixel_track.c$434$2$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:434: P1_7 = 0;
	clr	_P1_7
	sjmp	00115$
00110$:
	C$slave_wixel_track.c$436$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:436: else if (currentState == STATE_RUN)
	mov	r0,#_currentState
	movx	a,@r0
	cjne	a,#0x02,00107$
	C$slave_wixel_track.c$439$2$4 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:439: P1_2 = 1;
	setb	_P1_2
	C$slave_wixel_track.c$440$2$4 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:440: P1_1 = 0;
	clr	_P1_1
	C$slave_wixel_track.c$441$2$4 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:441: P1_7 = 1;
	setb	_P1_7
	C$slave_wixel_track.c$443$2$4 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:443: if (currentWaypointIndex == 0){
	mov	r0,#_currentWaypointIndex
	movx	a,@r0
	jnz	00115$
	C$slave_wixel_track.c$445$3$5 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:445: P1_7 = 0;
	clr	_P1_7
	sjmp	00115$
00107$:
	C$slave_wixel_track.c$448$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:448: else if (currentState == STATE_PREP)
	mov	r0,#_currentState
	movx	a,@r0
	cjne	a,#0x03,00104$
	C$slave_wixel_track.c$451$2$6 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:451: P1_2 = 0;
	clr	_P1_2
	C$slave_wixel_track.c$452$2$6 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:452: P1_1 = 1;
	setb	_P1_1
	C$slave_wixel_track.c$453$2$6 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:453: P1_7 = 0;
	clr	_P1_7
	sjmp	00115$
00104$:
	C$slave_wixel_track.c$458$2$7 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:458: P1_2 = 0;
	clr	_P1_2
	C$slave_wixel_track.c$459$2$7 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:459: P1_1 = 1;
	setb	_P1_1
	C$slave_wixel_track.c$460$2$7 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:460: P1_7 = 1;
	setb	_P1_7
00115$:
	C$slave_wixel_track.c$462$1$1 ==.
	XG$updateRgbLeds$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'extractPositionData'
;------------------------------------------------------------
	G$extractPositionData$0$0 ==.
	C$slave_wixel_track.c$466$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:466: void extractPositionData(uint8 offset)
;	-----------------------------------------
;	 function extractPositionData
;	-----------------------------------------
_extractPositionData:
	C$slave_wixel_track.c$471$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:471: posX = (int16)((rxPacket[offset + 1] << 8) | rxPacket[offset + 2]);
	mov	a,dpl
	mov	r7,a
	inc	a
	add	a,#_rxPacket
	mov	dpl,a
	clr	a
	addc	a,#(_rxPacket >> 8)
	mov	dph,a
	movx	a,@dptr
	mov	r5,a
	mov	r6,#0x00
	mov	a,#0x02
	add	a,r7
	add	a,#_rxPacket
	mov	dpl,a
	clr	a
	addc	a,#(_rxPacket >> 8)
	mov	dph,a
	movx	a,@dptr
	mov	r3,#0x00
	orl	ar6,a
	mov	a,r3
	orl	ar5,a
	mov	r0,#_posX
	mov	a,r6
	movx	@r0,a
	inc	r0
	mov	a,r5
	movx	@r0,a
	C$slave_wixel_track.c$472$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:472: posY = (int16)((rxPacket[offset + 3] << 8) | rxPacket[offset + 4]);
	mov	a,#0x03
	add	a,r7
	add	a,#_rxPacket
	mov	dpl,a
	clr	a
	addc	a,#(_rxPacket >> 8)
	mov	dph,a
	movx	a,@dptr
	mov	r5,a
	mov	r6,#0x00
	mov	a,#0x04
	add	a,r7
	add	a,#_rxPacket
	mov	dpl,a
	clr	a
	addc	a,#(_rxPacket >> 8)
	mov	dph,a
	movx	a,@dptr
	mov	r3,#0x00
	orl	ar6,a
	mov	a,r3
	orl	ar5,a
	mov	r0,#_posY
	mov	a,r6
	movx	@r0,a
	inc	r0
	mov	a,r5
	movx	@r0,a
	C$slave_wixel_track.c$473$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:473: rawTheta = rxPacket[offset + 5]; 
	mov	a,#0x05
	add	a,r7
	add	a,#_rxPacket
	mov	dpl,a
	clr	a
	addc	a,#(_rxPacket >> 8)
	mov	dph,a
	movx	a,@dptr
	C$slave_wixel_track.c$475$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:475: mapped_theta = (int16)(((int32)rawTheta * 360L) / 256L);
	mov	r0,#__mullong_PARM_2
	movx	@r0,a
	inc	r0
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	inc	r0
	movx	@r0,a
	mov	dptr,#0x0168
	clr	a
	mov	b,a
	lcall	__mullong
	mov	r4,dpl
	mov	r5,dph
	mov	r6,b
	mov	r7,a
	mov	r0,#__divslong_PARM_2
	clr	a
	movx	@r0,a
	inc	r0
	mov	a,#0x01
	movx	@r0,a
	inc	r0
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	mov	dpl,r4
	mov	dph,r5
	mov	b,r6
	mov	a,r7
	lcall	__divslong
	mov	r4,dpl
	mov	r5,dph
	mov	r6,b
	mov	r7,a
	C$slave_wixel_track.c$476$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:476: mapped_theta += orientationOffset;
	mov	r0,#_orientationOffset
	movx	a,@r0
	add	a,r4
	mov	r4,a
	inc	r0
	movx	a,@r0
	addc	a,r5
	mov	r5,a
	C$slave_wixel_track.c$478$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:478: if (mapped_theta > 180)
	clr	c
	mov	a,#0xB4
	subb	a,r4
	clr	a
	xrl	a,#0x80
	mov	b,r5
	xrl	b,#0x80
	subb	a,b
	jnc	00105$
	C$slave_wixel_track.c$480$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:480: posTheta = mapped_theta - 360;
	mov	r0,#_posTheta
	mov	a,r4
	add	a,#0x98
	movx	@r0,a
	mov	a,r5
	addc	a,#0xFE
	inc	r0
	movx	@r0,a
	sjmp	00107$
00105$:
	C$slave_wixel_track.c$482$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:482: else if (mapped_theta < -180)
	clr	c
	mov	a,r4
	subb	a,#0x4C
	mov	a,r5
	xrl	a,#0x80
	subb	a,#0x7f
	jnc	00102$
	C$slave_wixel_track.c$484$2$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:484: posTheta = mapped_theta + 360;
	mov	r0,#_posTheta
	mov	a,#0x68
	add	a,r4
	movx	@r0,a
	mov	a,#0x01
	addc	a,r5
	inc	r0
	movx	@r0,a
	sjmp	00107$
00102$:
	C$slave_wixel_track.c$488$2$4 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:488: posTheta = mapped_theta;
	mov	r0,#_posTheta
	mov	a,r4
	movx	@r0,a
	inc	r0
	mov	a,r5
	movx	@r0,a
00107$:
	C$slave_wixel_track.c$490$1$1 ==.
	XG$extractPositionData$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'handleCmdStop'
;------------------------------------------------------------
	G$handleCmdStop$0$0 ==.
	C$slave_wixel_track.c$492$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:492: void handleCmdStop()
;	-----------------------------------------
;	 function handleCmdStop
;	-----------------------------------------
_handleCmdStop:
	C$slave_wixel_track.c$494$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:494: currentState = STATE_IDLE;
	mov	r0,#_currentState
	clr	a
	movx	@r0,a
	C$slave_wixel_track.c$495$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:495: calib_step = 0;
	mov	r0,#_calib_step
	clr	a
	movx	@r0,a
	C$slave_wixel_track.c$496$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:496: waypointCount = 0;
	mov	r0,#_waypointCount
	clr	a
	movx	@r0,a
	C$slave_wixel_track.c$497$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:497: currentWaypointIndex = 0;
	mov	r0,#_currentWaypointIndex
	clr	a
	movx	@r0,a
	C$slave_wixel_track.c$498$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:498: runSubState = 0;
	mov	r0,#_runSubState
	clr	a
	movx	@r0,a
	C$slave_wixel_track.c$499$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:499: homeSubState = 0;
	mov	r0,#_homeSubState
	clr	a
	movx	@r0,a
	C$slave_wixel_track.c$500$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:500: pwm_left = 0;
	mov	r0,#_pwm_left
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	C$slave_wixel_track.c$501$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:501: pwm_right = 0;
	mov	r0,#_pwm_right
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	C$slave_wixel_track.c$502$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:502: stopMotors();
	lcall	_stopMotors
	C$slave_wixel_track.c$503$1$1 ==.
	XG$handleCmdStop$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'handleCmdGoTo'
;------------------------------------------------------------
	G$handleCmdGoTo$0$0 ==.
	C$slave_wixel_track.c$505$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:505: void handleCmdGoTo(uint8 offset)
;	-----------------------------------------
;	 function handleCmdGoTo
;	-----------------------------------------
_handleCmdGoTo:
	mov	r7,dpl
	C$slave_wixel_track.c$507$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:507: targetX = (int16)((rxPacket[offset + 7] << 8) | rxPacket[offset + 8]);
	mov	a,#0x07
	add	a,r7
	add	a,#_rxPacket
	mov	dpl,a
	clr	a
	addc	a,#(_rxPacket >> 8)
	mov	dph,a
	movx	a,@dptr
	mov	r5,a
	mov	r6,#0x00
	mov	a,#0x08
	add	a,r7
	add	a,#_rxPacket
	mov	dpl,a
	clr	a
	addc	a,#(_rxPacket >> 8)
	mov	dph,a
	movx	a,@dptr
	mov	r3,#0x00
	orl	ar6,a
	mov	a,r3
	orl	ar5,a
	mov	r0,#_targetX
	mov	a,r6
	movx	@r0,a
	inc	r0
	mov	a,r5
	movx	@r0,a
	C$slave_wixel_track.c$508$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:508: targetY = (int16)((rxPacket[offset + 9] << 8) | rxPacket[offset + 10]);
	mov	a,#0x09
	add	a,r7
	add	a,#_rxPacket
	mov	dpl,a
	clr	a
	addc	a,#(_rxPacket >> 8)
	mov	dph,a
	movx	a,@dptr
	mov	r3,a
	mov	r4,#0x00
	mov	a,#0x0A
	add	a,r7
	add	a,#_rxPacket
	mov	dpl,a
	clr	a
	addc	a,#(_rxPacket >> 8)
	mov	dph,a
	movx	a,@dptr
	mov	r2,#0x00
	orl	a,r4
	mov	r7,a
	mov	a,r2
	orl	a,r3
	mov	r4,a
	mov	r0,#_targetY
	mov	a,r7
	movx	@r0,a
	inc	r0
	mov	a,r4
	movx	@r0,a
	C$slave_wixel_track.c$510$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:510: if (currentState == STATE_HOME && targetX == lastTargetX && targetY == lastTargetY)
	mov	r0,#_currentState
	movx	a,@r0
	cjne	a,#0x01,00118$
	mov	a,#0x01
	sjmp	00119$
00118$:
	clr	a
00119$:
	mov	r3,a
	jz	00102$
	mov	r0,#_lastTargetX
	movx	a,@r0
	cjne	a,ar6,00121$
	inc	r0
	movx	a,@r0
	cjne	a,ar5,00121$
	sjmp	00122$
00121$:
	sjmp	00102$
00122$:
	mov	r0,#_lastTargetY
	movx	a,@r0
	cjne	a,ar7,00123$
	inc	r0
	movx	a,@r0
	cjne	a,ar4,00123$
	sjmp	00124$
00123$:
	sjmp	00102$
00124$:
	C$slave_wixel_track.c$512$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:512: return;
	ljmp	00111$
00102$:
	C$slave_wixel_track.c$515$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:515: if (currentState == STATE_HOME)
	mov	a,r3
	jz	00109$
	C$slave_wixel_track.c$517$2$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:517: if (targetX != lastTargetX || targetY != lastTargetY)
	mov	r0,#_lastTargetX
	movx	a,@r0
	cjne	a,ar6,00126$
	inc	r0
	movx	a,@r0
	cjne	a,ar5,00126$
	sjmp	00127$
00126$:
	sjmp	00105$
00127$:
	mov	r0,#_lastTargetY
	movx	a,@r0
	cjne	a,ar7,00128$
	inc	r0
	movx	a,@r0
	cjne	a,ar4,00128$
	sjmp	00110$
00128$:
00105$:
	C$slave_wixel_track.c$519$3$4 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:519: stateStartTime = (uint32)getMs();
	lcall	_getMs
	mov	r4,dpl
	mov	r5,dph
	mov	r6,b
	mov	r7,a
	mov	r0,#_stateStartTime
	mov	a,r4
	movx	@r0,a
	inc	r0
	mov	a,r5
	movx	@r0,a
	inc	r0
	mov	a,r6
	movx	@r0,a
	inc	r0
	mov	a,r7
	movx	@r0,a
	C$slave_wixel_track.c$520$3$4 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:520: lastTargetX = targetX;
	mov	r0,#_targetX
	movx	a,@r0
	mov	r6,a
	inc	r0
	movx	a,@r0
	mov	r7,a
	mov	r0,#_lastTargetX
	mov	a,r6
	movx	@r0,a
	inc	r0
	mov	a,r7
	movx	@r0,a
	C$slave_wixel_track.c$521$3$4 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:521: lastTargetY = targetY;
	mov	r0,#_targetY
	movx	a,@r0
	mov	r6,a
	inc	r0
	movx	a,@r0
	mov	r7,a
	mov	r0,#_lastTargetY
	mov	a,r6
	movx	@r0,a
	inc	r0
	mov	a,r7
	movx	@r0,a
	C$slave_wixel_track.c$522$3$4 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:522: homeSubState = 0;  // Reset to rotation
	mov	r0,#_homeSubState
	clr	a
	movx	@r0,a
	sjmp	00110$
00109$:
	C$slave_wixel_track.c$527$2$5 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:527: stateStartTime = (uint32)getMs();
	lcall	_getMs
	mov	r4,dpl
	mov	r5,dph
	mov	r6,b
	mov	r7,a
	mov	r0,#_stateStartTime
	mov	a,r4
	movx	@r0,a
	inc	r0
	mov	a,r5
	movx	@r0,a
	inc	r0
	mov	a,r6
	movx	@r0,a
	inc	r0
	mov	a,r7
	movx	@r0,a
	C$slave_wixel_track.c$528$2$5 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:528: lastTargetX = targetX;
	mov	r0,#_targetX
	movx	a,@r0
	mov	r6,a
	inc	r0
	movx	a,@r0
	mov	r7,a
	mov	r0,#_lastTargetX
	mov	a,r6
	movx	@r0,a
	inc	r0
	mov	a,r7
	movx	@r0,a
	C$slave_wixel_track.c$529$2$5 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:529: lastTargetY = targetY;
	mov	r0,#_targetY
	movx	a,@r0
	mov	r6,a
	inc	r0
	movx	a,@r0
	mov	r7,a
	mov	r0,#_lastTargetY
	mov	a,r6
	movx	@r0,a
	inc	r0
	mov	a,r7
	movx	@r0,a
	C$slave_wixel_track.c$530$2$5 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:530: homeSubState = 0;  // Start with rotation
	mov	r0,#_homeSubState
	clr	a
	movx	@r0,a
00110$:
	C$slave_wixel_track.c$533$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:533: currentState = STATE_HOME;
	mov	r0,#_currentState
	mov	a,#0x01
	movx	@r0,a
	C$slave_wixel_track.c$534$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:534: calib_step = 0;
	mov	r0,#_calib_step
	clr	a
	movx	@r0,a
00111$:
	C$slave_wixel_track.c$535$1$1 ==.
	XG$handleCmdGoTo$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'handleCmdPrep'
;------------------------------------------------------------
	G$handleCmdPrep$0$0 ==.
	C$slave_wixel_track.c$537$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:537: void handleCmdPrep(uint8 offset)
;	-----------------------------------------
;	 function handleCmdPrep
;	-----------------------------------------
_handleCmdPrep:
	mov	r7,dpl
	C$slave_wixel_track.c$542$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:542: if (currentState != STATE_IDLE && currentState != STATE_PREP)
	mov	r0,#_currentState
	movx	a,@r0
	jz	00102$
	mov	r0,#_currentState
	movx	a,@r0
	cjne	a,#0x03,00118$
	sjmp	00102$
00118$:
	C$slave_wixel_track.c$544$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:544: return;
	ljmp	00110$
00102$:
	C$slave_wixel_track.c$547$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:547: if (currentState == STATE_IDLE)
	mov	r0,#_currentState
	movx	a,@r0
	jnz	00105$
	C$slave_wixel_track.c$550$2$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:550: waypointCount = 0;
	mov	r0,#_waypointCount
	clr	a
	movx	@r0,a
	C$slave_wixel_track.c$551$2$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:551: currentState = STATE_PREP;
	mov	r0,#_currentState
	mov	a,#0x03
	movx	@r0,a
00105$:
	C$slave_wixel_track.c$556$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:556: order = rxPacket[offset + 7];
	mov	a,#0x07
	add	a,r7
	add	a,#_rxPacket
	mov	dpl,a
	clr	a
	addc	a,#(_rxPacket >> 8)
	mov	dph,a
	movx	a,@dptr
	mov	r6,a
	C$slave_wixel_track.c$557$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:557: wp_x = (int16)((rxPacket[offset + 8] << 8) | rxPacket[offset + 9]);
	mov	a,#0x08
	add	a,r7
	add	a,#_rxPacket
	mov	dpl,a
	clr	a
	addc	a,#(_rxPacket >> 8)
	mov	dph,a
	movx	a,@dptr
	mov	r4,a
	mov	r5,#0x00
	mov	a,#0x09
	add	a,r7
	add	a,#_rxPacket
	mov	dpl,a
	clr	a
	addc	a,#(_rxPacket >> 8)
	mov	dph,a
	movx	a,@dptr
	mov	r3,a
	mov	r2,#0x00
	mov	r0,#_handleCmdPrep_wp_x_1_1
	mov	a,r3
	orl	a,r5
	movx	@r0,a
	mov	a,r2
	orl	a,r4
	inc	r0
	movx	@r0,a
	C$slave_wixel_track.c$558$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:558: wp_y = (int16)((rxPacket[offset + 10] << 8) | rxPacket[offset + 11]);
	mov	a,#0x0A
	add	a,r7
	add	a,#_rxPacket
	mov	dpl,a
	clr	a
	addc	a,#(_rxPacket >> 8)
	mov	dph,a
	movx	a,@dptr
	mov	r2,a
	mov	r3,#0x00
	mov	a,#0x0B
	add	a,r7
	add	a,#_rxPacket
	mov	dpl,a
	clr	a
	addc	a,#(_rxPacket >> 8)
	mov	dph,a
	movx	a,@dptr
	mov	r5,a
	mov	r7,#0x00
	mov	a,r3
	orl	ar5,a
	mov	a,r2
	orl	ar7,a
	C$slave_wixel_track.c$561$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:561: if (order < MAX_WAYPOINTS)
	cjne	r6,#0x14,00120$
00120$:
	jnc	00110$
	C$slave_wixel_track.c$564$2$4 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:564: waypoints[order].order = order;
	mov	a,r6
	mov	b,#0x05
	mul	ab
	mov	r4,a
	add	a,#_waypoints
	mov	r1,a
	mov	a,r6
	movx	@r1,a
	C$slave_wixel_track.c$565$2$4 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:565: waypoints[order].x = wp_x;
	mov	a,r4
	add	a,#_waypoints
	mov	r4,a
	inc	a
	mov	r1,a
	mov	r0,#_handleCmdPrep_wp_x_1_1
	movx	a,@r0
	movx	@r1,a
	inc	r1
	inc	r0
	movx	a,@r0
	movx	@r1,a
	C$slave_wixel_track.c$566$2$4 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:566: waypoints[order].y = wp_y;
	mov	a,#0x03
	add	a,r4
	mov	r1,a
	mov	a,r5
	movx	@r1,a
	inc	r1
	mov	a,r7
	movx	@r1,a
	C$slave_wixel_track.c$569$2$4 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:569: if (order >= waypointCount)
	mov	r0,#_waypointCount
	clr	c
	movx	a,@r0
	mov	b,a
	mov	a,r6
	subb	a,b
	jc	00110$
	C$slave_wixel_track.c$570$2$4 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:570: waypointCount = order + 1;
	mov	r0,#_waypointCount
	mov	a,r6
	inc	a
	movx	@r0,a
00110$:
	C$slave_wixel_track.c$572$1$1 ==.
	XG$handleCmdPrep$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'handleCmdRun'
;------------------------------------------------------------
	G$handleCmdRun$0$0 ==.
	C$slave_wixel_track.c$574$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:574: void handleCmdRun()
;	-----------------------------------------
;	 function handleCmdRun
;	-----------------------------------------
_handleCmdRun:
	C$slave_wixel_track.c$576$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:576: if (currentState != STATE_PREP)
	mov	r0,#_currentState
	movx	a,@r0
	C$slave_wixel_track.c$578$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:578: return;
	cjne	a,#0x03,00105$
	C$slave_wixel_track.c$581$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:581: if (waypointCount > 0)
	mov	r0,#_waypointCount
	movx	a,@r0
	jz	00105$
	C$slave_wixel_track.c$583$2$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:583: currentState = STATE_RUN;
	mov	r0,#_currentState
	mov	a,#0x02
	movx	@r0,a
	C$slave_wixel_track.c$584$2$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:584: currentWaypointIndex = 0;
	mov	r0,#_currentWaypointIndex
	clr	a
	movx	@r0,a
	C$slave_wixel_track.c$585$2$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:585: runSubState = 0;  // Start with rotation
	mov	r0,#_runSubState
	clr	a
	movx	@r0,a
	C$slave_wixel_track.c$586$2$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:586: stateStartTime = (uint32)getMs();
	lcall	_getMs
	mov	r4,dpl
	mov	r5,dph
	mov	r6,b
	mov	r7,a
	mov	r0,#_stateStartTime
	mov	a,r4
	movx	@r0,a
	inc	r0
	mov	a,r5
	movx	@r0,a
	inc	r0
	mov	a,r6
	movx	@r0,a
	inc	r0
	mov	a,r7
	movx	@r0,a
00105$:
	C$slave_wixel_track.c$588$2$1 ==.
	XG$handleCmdRun$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'executeManualPwm'
;------------------------------------------------------------
	G$executeManualPwm$0$0 ==.
	C$slave_wixel_track.c$590$2$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:590: void executeManualPwm()
;	-----------------------------------------
;	 function executeManualPwm
;	-----------------------------------------
_executeManualPwm:
	C$slave_wixel_track.c$592$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:592: P1_2 = 0; P1_1 = 0; P1_7 = 1;
	clr	_P1_2
	clr	_P1_1
	setb	_P1_7
	C$slave_wixel_track.c$593$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:593: delayMs(100);
	mov	dptr,#0x0064
	lcall	_delayMs
	C$slave_wixel_track.c$594$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:594: P1_2 = 1; P1_1 = 1; P1_7 = 1;
	setb	_P1_2
	setb	_P1_1
	setb	_P1_7
	C$slave_wixel_track.c$596$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:596: pwm_left = manualPwmLeft;
	mov	r0,#_manualPwmLeft
	movx	a,@r0
	mov	r6,a
	inc	r0
	movx	a,@r0
	mov	r7,a
	mov	r0,#_pwm_left
	mov	a,r6
	movx	@r0,a
	inc	r0
	mov	a,r7
	movx	@r0,a
	C$slave_wixel_track.c$597$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:597: pwm_right = manualPwmRight;
	mov	r0,#_manualPwmRight
	movx	a,@r0
	mov	r6,a
	inc	r0
	movx	a,@r0
	mov	r7,a
	mov	r0,#_pwm_right
	mov	a,r6
	movx	@r0,a
	inc	r0
	mov	a,r7
	movx	@r0,a
	C$slave_wixel_track.c$598$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:598: setMotorsPWM();
	lcall	_setMotorsPWM
	C$slave_wixel_track.c$599$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:599: delayMs(2000);
	mov	dptr,#0x07D0
	lcall	_delayMs
	C$slave_wixel_track.c$601$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:601: stopMotors();
	lcall	_stopMotors
	C$slave_wixel_track.c$602$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:602: manualPwmLeft = 0;
	mov	r0,#_manualPwmLeft
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	C$slave_wixel_track.c$603$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:603: manualPwmRight = 0;
	mov	r0,#_manualPwmRight
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	C$slave_wixel_track.c$605$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:605: P1_2 = 0; P1_1 = 0; P1_7 = 1;
	clr	_P1_2
	clr	_P1_1
	setb	_P1_7
	C$slave_wixel_track.c$606$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:606: delayMs(100);
	mov	dptr,#0x0064
	lcall	_delayMs
	C$slave_wixel_track.c$607$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:607: P1_2 = 1; P1_1 = 1; P1_7 = 1;
	setb	_P1_2
	setb	_P1_1
	setb	_P1_7
	C$slave_wixel_track.c$609$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:609: pwm_left = 0;
	mov	r0,#_pwm_left
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	C$slave_wixel_track.c$610$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:610: pwm_right = 0;
	mov	r0,#_pwm_right
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	C$slave_wixel_track.c$611$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:611: currentState = STATE_IDLE;
	mov	r0,#_currentState
	clr	a
	movx	@r0,a
	C$slave_wixel_track.c$612$1$1 ==.
	XG$executeManualPwm$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'handleCmdAux'
;------------------------------------------------------------
	G$handleCmdAux$0$0 ==.
	C$slave_wixel_track.c$614$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:614: void handleCmdAux(uint8 offset)
;	-----------------------------------------
;	 function handleCmdAux
;	-----------------------------------------
_handleCmdAux:
	mov	r7,dpl
	C$slave_wixel_track.c$616$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:616: uint8 auxSubCmd = rxPacket[offset + 7];
	mov	a,#0x07
	add	a,r7
	add	a,#_rxPacket
	mov	dpl,a
	clr	a
	addc	a,#(_rxPacket >> 8)
	mov	dph,a
	movx	a,@dptr
	mov	r6,a
	C$slave_wixel_track.c$617$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:617: switch(auxSubCmd)
	cjne	r6,#0x1F,00105$
	C$slave_wixel_track.c$623$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:623: currentState = STATE_IDLE;
	mov	r0,#_currentState
	clr	a
	movx	@r0,a
	C$slave_wixel_track.c$624$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:624: calib_step = 0;
	mov	r0,#_calib_step
	clr	a
	movx	@r0,a
	C$slave_wixel_track.c$625$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:625: manualPwmLeft = (int16)((rxPacket[offset + 8] << 8) | rxPacket[offset + 9]);
	mov	a,#0x08
	add	a,r7
	add	a,#_rxPacket
	mov	dpl,a
	clr	a
	addc	a,#(_rxPacket >> 8)
	mov	dph,a
	movx	a,@dptr
	mov	r5,a
	mov	r6,#0x00
	mov	a,#0x09
	add	a,r7
	add	a,#_rxPacket
	mov	dpl,a
	clr	a
	addc	a,#(_rxPacket >> 8)
	mov	dph,a
	movx	a,@dptr
	mov	r3,#0x00
	orl	ar6,a
	mov	a,r3
	orl	ar5,a
	mov	r0,#_manualPwmLeft
	mov	a,r6
	movx	@r0,a
	inc	r0
	mov	a,r5
	movx	@r0,a
	C$slave_wixel_track.c$626$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:626: manualPwmRight = (int16)((rxPacket[offset + 10] << 8) | rxPacket[offset + 11]);
	mov	a,#0x0A
	add	a,r7
	add	a,#_rxPacket
	mov	dpl,a
	clr	a
	addc	a,#(_rxPacket >> 8)
	mov	dph,a
	movx	a,@dptr
	mov	r5,a
	mov	r6,#0x00
	mov	a,#0x0B
	add	a,r7
	add	a,#_rxPacket
	mov	dpl,a
	clr	a
	addc	a,#(_rxPacket >> 8)
	mov	dph,a
	movx	a,@dptr
	mov	r4,#0x00
	orl	ar6,a
	mov	a,r4
	orl	ar5,a
	mov	r0,#_manualPwmRight
	mov	a,r6
	movx	@r0,a
	inc	r0
	mov	a,r5
	movx	@r0,a
	C$slave_wixel_track.c$627$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:627: executeManualPwm();
	lcall	_executeManualPwm
	C$slave_wixel_track.c$632$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:632: }
00105$:
	C$slave_wixel_track.c$633$1$1 ==.
	XG$handleCmdAux$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'handleCmdCalibrate'
;------------------------------------------------------------
	G$handleCmdCalibrate$0$0 ==.
	C$slave_wixel_track.c$635$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:635: void handleCmdCalibrate()
;	-----------------------------------------
;	 function handleCmdCalibrate
;	-----------------------------------------
_handleCmdCalibrate:
	C$slave_wixel_track.c$637$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:637: currentState = STATE_CALIBRATE_VALIDATE;
	mov	r0,#_currentState
	mov	a,#0x10
	movx	@r0,a
	C$slave_wixel_track.c$638$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:638: updateRgbLeds();
	lcall	_updateRgbLeds
	C$slave_wixel_track.c$640$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:640: if (calib_step == 0)
	mov	r0,#_calib_step
	movx	a,@r0
	jnz	00107$
	C$slave_wixel_track.c$642$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:642: orientationOffset = 0;
	mov	r0,#_orientationOffset
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	C$slave_wixel_track.c$643$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:643: stopMotors();
	lcall	_stopMotors
	C$slave_wixel_track.c$645$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:645: calData.xa = posX; calData.ya = posY; 
	mov	r0,#_calData
	mov	r1,#_posX
	movx	a,@r1
	movx	@r0,a
	inc	r0
	inc	r1
	movx	a,@r1
	movx	@r0,a
	mov	r0,#(_calData + 0x0002)
	mov	r1,#_posY
	movx	a,@r1
	movx	@r0,a
	inc	r0
	inc	r1
	movx	a,@r1
	movx	@r0,a
	C$slave_wixel_track.c$646$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:646: calData.thetaa = posTheta - orientationOffset;
	mov	r0,#_posTheta
	mov	r1,#_orientationOffset
	movx	a,@r1
	mov	b,a
	clr	c
	movx	a,@r0
	subb	a,b
	mov	r6,a
	inc	r1
	movx	a,@r1
	mov	b,a
	inc	r0
	movx	a,@r0
	subb	a,b
	mov	r7,a
	mov	r0,#(_calData + 0x0004)
	mov	a,r6
	movx	@r0,a
	inc	r0
	mov	a,r7
	movx	@r0,a
	C$slave_wixel_track.c$648$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:648: pwm_left = 70;
	mov	r0,#_pwm_left
	mov	a,#0x46
	movx	@r0,a
	inc	r0
	clr	a
	movx	@r0,a
	C$slave_wixel_track.c$649$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:649: pwm_right = 70;
	mov	r0,#_pwm_right
	mov	a,#0x46
	movx	@r0,a
	inc	r0
	clr	a
	movx	@r0,a
	C$slave_wixel_track.c$650$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:650: setMotorsPWM();
	lcall	_setMotorsPWM
	C$slave_wixel_track.c$651$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:651: delayMs(3000);
	mov	dptr,#0x0BB8
	lcall	_delayMs
	C$slave_wixel_track.c$652$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:652: stopMotors();
	lcall	_stopMotors
	C$slave_wixel_track.c$653$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:653: pwm_left = 0;
	mov	r0,#_pwm_left
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	C$slave_wixel_track.c$654$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:654: pwm_right = 0;
	mov	r0,#_pwm_right
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	C$slave_wixel_track.c$656$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:656: calib_step = 1;
	mov	r0,#_calib_step
	mov	a,#0x01
	movx	@r0,a
	C$slave_wixel_track.c$657$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:657: currentState = STATE_IDLE;
	mov	r0,#_currentState
	clr	a
	movx	@r0,a
	ljmp	00109$
00107$:
	C$slave_wixel_track.c$659$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:659: else if (calib_step == 1)
	mov	r0,#_calib_step
	movx	a,@r0
	cjne	a,#0x01,00104$
	C$slave_wixel_track.c$661$2$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:661: stopMotors();
	lcall	_stopMotors
	C$slave_wixel_track.c$663$2$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:663: calData.xb = posX; calData.yb = posY; calData.thetab = posTheta;
	mov	r0,#(_calData + 0x0006)
	mov	r1,#_posX
	movx	a,@r1
	movx	@r0,a
	inc	r0
	inc	r1
	movx	a,@r1
	movx	@r0,a
	mov	r0,#(_calData + 0x0008)
	mov	r1,#_posY
	movx	a,@r1
	movx	@r0,a
	inc	r0
	inc	r1
	movx	a,@r1
	movx	@r0,a
	mov	r0,#(_calData + 0x000a)
	mov	r1,#_posTheta
	movx	a,@r1
	movx	@r0,a
	inc	r0
	inc	r1
	movx	a,@r1
	movx	@r0,a
	C$slave_wixel_track.c$665$2$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:665: pwm_left = -60;
	mov	r0,#_pwm_left
	mov	a,#0xC4
	movx	@r0,a
	inc	r0
	mov	a,#0xFF
	movx	@r0,a
	C$slave_wixel_track.c$666$2$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:666: pwm_right = 60;
	mov	r0,#_pwm_right
	mov	a,#0x3C
	movx	@r0,a
	inc	r0
	clr	a
	movx	@r0,a
	C$slave_wixel_track.c$667$2$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:667: setMotorsPWM();
	lcall	_setMotorsPWM
	C$slave_wixel_track.c$668$2$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:668: delayMs(2000);
	mov	dptr,#0x07D0
	lcall	_delayMs
	C$slave_wixel_track.c$669$2$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:669: stopMotors();
	lcall	_stopMotors
	C$slave_wixel_track.c$670$2$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:670: pwm_left = 0;
	mov	r0,#_pwm_left
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	C$slave_wixel_track.c$671$2$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:671: pwm_right = 0;
	mov	r0,#_pwm_right
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	C$slave_wixel_track.c$673$2$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:673: calib_step = 2;
	mov	r0,#_calib_step
	mov	a,#0x02
	movx	@r0,a
	C$slave_wixel_track.c$674$2$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:674: currentState = STATE_IDLE;
	mov	r0,#_currentState
	clr	a
	movx	@r0,a
	sjmp	00109$
00104$:
	C$slave_wixel_track.c$676$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:676: else if (calib_step == 2)
	mov	r0,#_calib_step
	movx	a,@r0
	cjne	a,#0x02,00109$
	C$slave_wixel_track.c$678$2$4 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:678: stopMotors();
	lcall	_stopMotors
	C$slave_wixel_track.c$679$2$4 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:679: pwm_left = 0;
	mov	r0,#_pwm_left
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	C$slave_wixel_track.c$680$2$4 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:680: pwm_right = 0;
	mov	r0,#_pwm_right
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	C$slave_wixel_track.c$682$2$4 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:682: calData.xc = posX; calData.yc = posY; calData.thetac = posTheta;
	mov	r0,#(_calData + 0x000c)
	mov	r1,#_posX
	movx	a,@r1
	movx	@r0,a
	inc	r0
	inc	r1
	movx	a,@r1
	movx	@r0,a
	mov	r0,#(_calData + 0x000e)
	mov	r1,#_posY
	movx	a,@r1
	movx	@r0,a
	inc	r0
	inc	r1
	movx	a,@r1
	movx	@r0,a
	mov	r0,#(_calData + 0x0010)
	mov	r1,#_posTheta
	movx	a,@r1
	movx	@r0,a
	inc	r0
	inc	r1
	movx	a,@r1
	movx	@r0,a
	C$slave_wixel_track.c$684$2$4 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:684: calculateAndApplyOffset();
	lcall	_calculateAndApplyOffset
	C$slave_wixel_track.c$686$2$4 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:686: currentState = STATE_CALIBRATE_VALIDATE;
	mov	r0,#_currentState
	mov	a,#0x10
	movx	@r0,a
	C$slave_wixel_track.c$687$2$4 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:687: stateStartTime = (uint32)getMs();
	lcall	_getMs
	mov	r4,dpl
	mov	r5,dph
	mov	r6,b
	mov	r7,a
	mov	r0,#_stateStartTime
	mov	a,r4
	movx	@r0,a
	inc	r0
	mov	a,r5
	movx	@r0,a
	inc	r0
	mov	a,r6
	movx	@r0,a
	inc	r0
	mov	a,r7
	movx	@r0,a
	C$slave_wixel_track.c$689$2$4 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:689: calib_step = 0;
	mov	r0,#_calib_step
	clr	a
	movx	@r0,a
00109$:
	C$slave_wixel_track.c$691$2$1 ==.
	XG$handleCmdCalibrate$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'receiveAndProcessPackets'
;------------------------------------------------------------
	G$receiveAndProcessPackets$0$0 ==.
	C$slave_wixel_track.c$693$2$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:693: void receiveAndProcessPackets()
;	-----------------------------------------
;	 function receiveAndProcessPackets
;	-----------------------------------------
_receiveAndProcessPackets:
	C$slave_wixel_track.c$699$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:699: if (RFIF & (1<<4))
	mov	a,_RFIF
	jb	acc.4,00140$
	ljmp	00128$
00140$:
	C$slave_wixel_track.c$701$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:701: if (radioCrcPassed())
	lcall	_radioCrcPassed
	jc	00141$
	ljmp	00125$
00141$:
	C$slave_wixel_track.c$703$3$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:703: lastPacketTime = (uint16)getMs();
	lcall	_getMs
	mov	r4,dpl
	mov	r5,dph
	mov	r6,b
	mov	r7,a
	mov	r0,#_lastPacketTime
	mov	a,r4
	movx	@r0,a
	inc	r0
	mov	a,r5
	movx	@r0,a
	C$slave_wixel_track.c$705$3$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:705: if (lastPacketTime != lastPacketTimeCheck)
	mov	r0,#_lastPacketTimeCheck
	movx	a,@r0
	cjne	a,ar4,00142$
	inc	r0
	movx	a,@r0
	cjne	a,ar5,00142$
	sjmp	00112$
00142$:
	C$slave_wixel_track.c$707$4$4 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:707: rxPulseStart = 1;
	mov	r0,#_rxPulseStart
	mov	a,#0x01
	movx	@r0,a
	inc	r0
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	inc	r0
	movx	@r0,a
	C$slave_wixel_track.c$708$4$4 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:708: lastPacketTimeCheck = lastPacketTime;
	mov	r0,#_lastPacketTimeCheck
	mov	a,r4
	movx	@r0,a
	inc	r0
	mov	a,r5
	movx	@r0,a
	C$slave_wixel_track.c$711$3$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:711: if (THIS_SLAVE_ADDRESS == 0x01)
00112$:
	C$slave_wixel_track.c$727$3$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:727: slaveAddress = rxPacket[packetOffset + 0];
	mov	dptr,#(_rxPacket + 0x0001)
	movx	a,@dptr
	mov	r7,a
	C$slave_wixel_track.c$728$3$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:728: cmd = rxPacket[packetOffset + 6];
	mov	dptr,#(_rxPacket + 0x0007)
	movx	a,@dptr
	mov	r6,a
	C$slave_wixel_track.c$730$3$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:730: if (slaveAddress != THIS_SLAVE_ADDRESS)
	cjne	r7,#0x01,00143$
	sjmp	00116$
00143$:
	C$slave_wixel_track.c$732$4$6 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:732: RFIF &= ~(1<<4);
	mov	r7,_RFIF
	anl	ar7,#0xEF
	mov	_RFIF,r7
	C$slave_wixel_track.c$733$4$6 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:733: DMAARM |= (1<<DMA_CHANNEL_RADIO);
	orl	_DMAARM,#0x02
	C$slave_wixel_track.c$734$4$6 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:734: RFST = 2;
	mov	_RFST,#0x02
	C$slave_wixel_track.c$735$4$6 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:735: return;
	sjmp	00128$
00116$:
	C$slave_wixel_track.c$738$3$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:738: extractPositionData(packetOffset);
	mov	dpl,#0x01
	push	ar6
	lcall	_extractPositionData
	C$slave_wixel_track.c$739$3$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:739: filterPosition();
	lcall	_filterPosition
	pop	ar6
	C$slave_wixel_track.c$741$3$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:741: switch(cmd)
	cjne	r6,#0x10,00144$
	sjmp	00117$
00144$:
	cjne	r6,#0x11,00145$
	sjmp	00118$
00145$:
	cjne	r6,#0x12,00146$
	sjmp	00119$
00146$:
	cjne	r6,#0x13,00147$
	sjmp	00120$
00147$:
	cjne	r6,#0x14,00148$
	sjmp	00122$
00148$:
	C$slave_wixel_track.c$743$4$7 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:743: case CMD_STOP:
	cjne	r6,#0x15,00125$
	sjmp	00121$
00117$:
	C$slave_wixel_track.c$744$4$7 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:744: handleCmdStop();
	lcall	_handleCmdStop
	C$slave_wixel_track.c$745$4$7 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:745: break;
	C$slave_wixel_track.c$746$4$7 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:746: case CMD_GO_TO:
	sjmp	00125$
00118$:
	C$slave_wixel_track.c$747$4$7 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:747: handleCmdGoTo(packetOffset);
	mov	dpl,#0x01
	lcall	_handleCmdGoTo
	C$slave_wixel_track.c$748$4$7 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:748: break;
	C$slave_wixel_track.c$749$4$7 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:749: case CMD_PREP:
	sjmp	00125$
00119$:
	C$slave_wixel_track.c$750$4$7 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:750: handleCmdPrep(packetOffset);
	mov	dpl,#0x01
	lcall	_handleCmdPrep
	C$slave_wixel_track.c$751$4$7 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:751: break;
	C$slave_wixel_track.c$752$4$7 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:752: case CMD_RUN:
	sjmp	00125$
00120$:
	C$slave_wixel_track.c$753$4$7 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:753: handleCmdRun();
	lcall	_handleCmdRun
	C$slave_wixel_track.c$754$4$7 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:754: break;
	C$slave_wixel_track.c$755$4$7 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:755: case CMD_CALIBRATE:
	sjmp	00125$
00121$:
	C$slave_wixel_track.c$756$4$7 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:756: handleCmdCalibrate();
	lcall	_handleCmdCalibrate
	C$slave_wixel_track.c$757$4$7 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:757: break;
	C$slave_wixel_track.c$758$4$7 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:758: case CMD_AUX:
	sjmp	00125$
00122$:
	C$slave_wixel_track.c$759$4$7 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:759: handleCmdAux(packetOffset);
	mov	dpl,#0x01
	lcall	_handleCmdAux
	C$slave_wixel_track.c$761$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:761: }
00125$:
	C$slave_wixel_track.c$764$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:764: RFIF &= ~(1<<4);
	mov	r7,_RFIF
	anl	ar7,#0xEF
	mov	_RFIF,r7
	C$slave_wixel_track.c$765$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:765: DMAARM |= (1<<DMA_CHANNEL_RADIO);
	orl	_DMAARM,#0x02
	C$slave_wixel_track.c$766$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:766: RFST = 2;
	mov	_RFST,#0x02
00128$:
	C$slave_wixel_track.c$768$2$1 ==.
	XG$receiveAndProcessPackets$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'handlePacketTimeout'
;------------------------------------------------------------
;sloc0                     Allocated with name '_handlePacketTimeout_sloc0_1_0'
;------------------------------------------------------------
	G$handlePacketTimeout$0$0 ==.
	C$slave_wixel_track.c$770$2$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:770: void handlePacketTimeout()
;	-----------------------------------------
;	 function handlePacketTimeout
;	-----------------------------------------
_handlePacketTimeout:
	C$slave_wixel_track.c$772$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:772: if ((uint16)(getMs() - lastPacketTime) > CONNECTION_TIMEOUT)
	lcall	_getMs
	mov	_handlePacketTimeout_sloc0_1_0,dpl
	mov	(_handlePacketTimeout_sloc0_1_0 + 1),dph
	mov	(_handlePacketTimeout_sloc0_1_0 + 2),b
	mov	(_handlePacketTimeout_sloc0_1_0 + 3),a
	mov	r0,#_lastPacketTime
	movx	a,@r0
	mov	r2,a
	inc	r0
	movx	a,@r0
	mov	r3,a
	clr	a
	mov	r6,a
	mov	r7,a
	mov	a,_handlePacketTimeout_sloc0_1_0
	clr	c
	subb	a,r2
	mov	r2,a
	mov	a,(_handlePacketTimeout_sloc0_1_0 + 1)
	subb	a,r3
	mov	r3,a
	mov	a,(_handlePacketTimeout_sloc0_1_0 + 2)
	subb	a,r6
	mov	r6,a
	mov	a,(_handlePacketTimeout_sloc0_1_0 + 3)
	subb	a,r7
	mov	r7,a
	clr	c
	mov	a,#0xB8
	subb	a,r2
	mov	a,#0x0B
	subb	a,r3
	jnc	00103$
	C$slave_wixel_track.c$774$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:774: currentState = STATE_IDLE;
	mov	r0,#_currentState
	clr	a
	movx	@r0,a
	C$slave_wixel_track.c$775$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:775: calib_step = 0;
	mov	r0,#_calib_step
	clr	a
	movx	@r0,a
	C$slave_wixel_track.c$776$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:776: waypointCount = 0;
	mov	r0,#_waypointCount
	clr	a
	movx	@r0,a
	C$slave_wixel_track.c$777$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:777: currentWaypointIndex = 0;
	mov	r0,#_currentWaypointIndex
	clr	a
	movx	@r0,a
	C$slave_wixel_track.c$778$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:778: runSubState = 0;
	mov	r0,#_runSubState
	clr	a
	movx	@r0,a
	C$slave_wixel_track.c$779$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:779: homeSubState = 0;
	mov	r0,#_homeSubState
	clr	a
	movx	@r0,a
	C$slave_wixel_track.c$780$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:780: pwm_left = 0;
	mov	r0,#_pwm_left
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	C$slave_wixel_track.c$781$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:781: pwm_right = 0;
	mov	r0,#_pwm_right
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	C$slave_wixel_track.c$782$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:782: stopMotors();
	lcall	_stopMotors
00103$:
	C$slave_wixel_track.c$784$2$1 ==.
	XG$handlePacketTimeout$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'updateHomeState'
;------------------------------------------------------------
	G$updateHomeState$0$0 ==.
	C$slave_wixel_track.c$788$2$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:788: void updateHomeState()
;	-----------------------------------------
;	 function updateHomeState
;	-----------------------------------------
_updateHomeState:
	C$slave_wixel_track.c$790$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:790: uint32 elapsedTime = now - stateStartTime;
	mov	r0,#_now
	mov	r1,#_stateStartTime
	movx	a,@r1
	mov	b,a
	clr	c
	movx	a,@r0
	subb	a,b
	mov	r4,a
	inc	r1
	movx	a,@r1
	mov	b,a
	inc	r0
	movx	a,@r0
	subb	a,b
	mov	r5,a
	inc	r1
	movx	a,@r1
	mov	b,a
	inc	r0
	movx	a,@r0
	subb	a,b
	mov	r6,a
	inc	r1
	movx	a,@r1
	mov	b,a
	inc	r0
	movx	a,@r0
	subb	a,b
	mov	r7,a
	C$slave_wixel_track.c$795$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:795: if (elapsedTime >= GO_TO_TIMEOUT)
	clr	c
	mov	a,r4
	subb	a,#0x10
	mov	a,r5
	subb	a,#0x27
	mov	a,r6
	subb	a,#0x00
	mov	a,r7
	subb	a,#0x00
	jc	00102$
	C$slave_wixel_track.c$797$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:797: currentState = STATE_IDLE;
	mov	r0,#_currentState
	clr	a
	movx	@r0,a
	C$slave_wixel_track.c$798$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:798: homeSubState = 0;
	mov	r0,#_homeSubState
	clr	a
	movx	@r0,a
	C$slave_wixel_track.c$799$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:799: pwm_left = 0;
	mov	r0,#_pwm_left
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	C$slave_wixel_track.c$800$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:800: pwm_right = 0;
	mov	r0,#_pwm_right
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	C$slave_wixel_track.c$801$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:801: stopMotors();
	lcall	_stopMotors
	C$slave_wixel_track.c$802$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:802: lastTargetX = 0;
	mov	r0,#_lastTargetX
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	C$slave_wixel_track.c$803$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:803: lastTargetY = 0;
	mov	r0,#_lastTargetY
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	C$slave_wixel_track.c$804$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:804: return;
	ljmp	00133$
00102$:
	C$slave_wixel_track.c$832$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:832: if (homeSubState == 0)
	mov	r0,#_homeSubState
	movx	a,@r0
	jz	00156$
	ljmp	00131$
00156$:
	C$slave_wixel_track.c$835$2$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:835: targetHeading = calculateTargetHeading(filteredX, filteredY, targetX, targetY);
	mov	r0,#_filteredY
	mov	r1,#_calculateTargetHeading_PARM_2
	movx	a,@r0
	movx	@r1,a
	inc	r0
	movx	a,@r0
	inc	r1
	movx	@r1,a
	mov	r0,#_targetX
	mov	r1,#_calculateTargetHeading_PARM_3
	movx	a,@r0
	movx	@r1,a
	inc	r0
	movx	a,@r0
	inc	r1
	movx	@r1,a
	mov	r0,#_targetY
	mov	r1,#_calculateTargetHeading_PARM_4
	movx	a,@r0
	movx	@r1,a
	inc	r0
	movx	a,@r0
	inc	r1
	movx	@r1,a
	mov	r0,#_filteredX
	movx	a,@r0
	mov	dpl,a
	inc	r0
	movx	a,@r0
	mov	dph,a
	lcall	_calculateTargetHeading
	mov	r6,dpl
	mov	r7,dph
	C$slave_wixel_track.c$837$2$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:837: headingError = targetHeading - filteredTheta;
	mov	r0,#_filteredTheta
	setb	c
	movx	a,@r0
	subb	a,r6
	cpl	a
	cpl	c
	mov	r4,a
	cpl	c
	inc	r0
	movx	a,@r0
	subb	a,r7
	cpl	a
	mov	r5,a
	C$slave_wixel_track.c$838$2$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:838: if (headingError > 180)
	clr	c
	mov	a,#0xB4
	subb	a,r4
	clr	a
	xrl	a,#0x80
	mov	b,r5
	xrl	b,#0x80
	subb	a,b
	jnc	00104$
	C$slave_wixel_track.c$839$2$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:839: headingError -= 360;
	mov	a,r4
	add	a,#0x98
	mov	r4,a
	mov	a,r5
	addc	a,#0xFE
	mov	r5,a
00104$:
	C$slave_wixel_track.c$840$2$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:840: if (headingError < -180)
	clr	c
	mov	a,r4
	subb	a,#0x4C
	mov	a,r5
	xrl	a,#0x80
	subb	a,#0x7f
	jnc	00106$
	C$slave_wixel_track.c$841$2$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:841: headingError += 360;
	mov	a,#0x68
	add	a,r4
	mov	r4,a
	mov	a,#0x01
	addc	a,r5
	mov	r5,a
00106$:
	C$slave_wixel_track.c$843$2$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:843: abs_error = (headingError >= 0) ? headingError : -headingError;
	mov	a,r5
	rlc	a
	cpl	c
	clr	a
	rlc	a
	mov	r3,a
	jz	00135$
	mov	ar2,r4
	mov	ar3,r5
	sjmp	00136$
00135$:
	clr	c
	clr	a
	subb	a,r4
	mov	r2,a
	clr	a
	subb	a,r5
	mov	r3,a
00136$:
	C$slave_wixel_track.c$845$2$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:845: if (abs_error < HEADING_THRESHOLD)
	clr	c
	mov	a,r2
	subb	a,#0x05
	mov	a,r3
	xrl	a,#0x80
	subb	a,#0x80
	jnc	00108$
	C$slave_wixel_track.c$848$3$4 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:848: homeSubState = 1;
	mov	r0,#_homeSubState
	mov	a,#0x01
	movx	@r0,a
	ljmp	00133$
00108$:
	C$slave_wixel_track.c$852$3$5 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:852: rotationController(filteredTheta, targetHeading);
	mov	r0,#_rotationController_PARM_2
	mov	a,r6
	movx	@r0,a
	inc	r0
	mov	a,r7
	movx	@r0,a
	mov	r0,#_filteredTheta
	movx	a,@r0
	mov	dpl,a
	inc	r0
	movx	a,@r0
	mov	dph,a
	lcall	_rotationController
	ljmp	00133$
00131$:
	C$slave_wixel_track.c$855$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:855: else if (homeSubState == 1)
	mov	r0,#_homeSubState
	movx	a,@r0
	cjne	a,#0x01,00162$
	sjmp	00163$
00162$:
	ljmp	00133$
00163$:
	C$slave_wixel_track.c$858$2$6 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:858: if (isWithinThreshold(filteredX, filteredY, targetX, targetY, GOAL_THRESHOLD))
	mov	r0,#_filteredY
	mov	r1,#_isWithinThreshold_PARM_2
	movx	a,@r0
	movx	@r1,a
	inc	r0
	movx	a,@r0
	inc	r1
	movx	@r1,a
	mov	r0,#_targetX
	mov	r1,#_isWithinThreshold_PARM_3
	movx	a,@r0
	movx	@r1,a
	inc	r0
	movx	a,@r0
	inc	r1
	movx	@r1,a
	mov	r0,#_targetY
	mov	r1,#_isWithinThreshold_PARM_4
	movx	a,@r0
	movx	@r1,a
	inc	r0
	movx	a,@r0
	inc	r1
	movx	@r1,a
	mov	r0,#_isWithinThreshold_PARM_5
	mov	a,#0x96
	movx	@r0,a
	inc	r0
	clr	a
	movx	@r0,a
	mov	r0,#_filteredX
	movx	a,@r0
	mov	dpl,a
	inc	r0
	movx	a,@r0
	mov	dph,a
	lcall	_isWithinThreshold
	mov	a,dpl
	jz	00126$
	C$slave_wixel_track.c$861$3$7 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:861: currentState = STATE_IDLE;
	mov	r0,#_currentState
	clr	a
	movx	@r0,a
	C$slave_wixel_track.c$862$3$7 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:862: homeSubState = 0;
	mov	r0,#_homeSubState
	clr	a
	movx	@r0,a
	C$slave_wixel_track.c$863$3$7 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:863: pwm_left = 0;
	mov	r0,#_pwm_left
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	C$slave_wixel_track.c$864$3$7 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:864: pwm_right = 0;
	mov	r0,#_pwm_right
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	C$slave_wixel_track.c$865$3$7 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:865: stopMotors();
	lcall	_stopMotors
	C$slave_wixel_track.c$866$3$7 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:866: lastTargetX = 0;
	mov	r0,#_lastTargetX
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	C$slave_wixel_track.c$867$3$7 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:867: lastTargetY = 0;
	mov	r0,#_lastTargetY
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	ljmp	00133$
00126$:
	C$slave_wixel_track.c$872$3$8 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:872: targetHeading = calculateTargetHeading(filteredX, filteredY, targetX, targetY);
	mov	r0,#_filteredY
	mov	r1,#_calculateTargetHeading_PARM_2
	movx	a,@r0
	movx	@r1,a
	inc	r0
	movx	a,@r0
	inc	r1
	movx	@r1,a
	mov	r0,#_targetX
	mov	r1,#_calculateTargetHeading_PARM_3
	movx	a,@r0
	movx	@r1,a
	inc	r0
	movx	a,@r0
	inc	r1
	movx	@r1,a
	mov	r0,#_targetY
	mov	r1,#_calculateTargetHeading_PARM_4
	movx	a,@r0
	movx	@r1,a
	inc	r0
	movx	a,@r0
	inc	r1
	movx	@r1,a
	mov	r0,#_filteredX
	movx	a,@r0
	mov	dpl,a
	inc	r0
	movx	a,@r0
	mov	dph,a
	lcall	_calculateTargetHeading
	mov	r6,dpl
	mov	r7,dph
	C$slave_wixel_track.c$874$3$8 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:874: headingError = targetHeading - filteredTheta;
	mov	r0,#_filteredTheta
	setb	c
	movx	a,@r0
	subb	a,r6
	cpl	a
	cpl	c
	mov	r4,a
	cpl	c
	inc	r0
	movx	a,@r0
	subb	a,r7
	cpl	a
	mov	r5,a
	C$slave_wixel_track.c$875$3$8 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:875: if (headingError > 180)
	clr	c
	mov	a,#0xB4
	subb	a,r4
	clr	a
	xrl	a,#0x80
	mov	b,r5
	xrl	b,#0x80
	subb	a,b
	jnc	00111$
	C$slave_wixel_track.c$876$3$8 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:876: headingError -= 360;
	mov	a,r4
	add	a,#0x98
	mov	r4,a
	mov	a,r5
	addc	a,#0xFE
	mov	r5,a
00111$:
	C$slave_wixel_track.c$877$3$8 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:877: if (headingError < -180)
	clr	c
	mov	a,r4
	subb	a,#0x4C
	mov	a,r5
	xrl	a,#0x80
	subb	a,#0x7f
	jnc	00113$
	C$slave_wixel_track.c$878$3$8 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:878: headingError += 360;
	mov	a,#0x68
	add	a,r4
	mov	r4,a
	mov	a,#0x01
	addc	a,r5
	mov	r5,a
00113$:
	C$slave_wixel_track.c$880$3$8 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:880: abs_error = (headingError >= 0) ? headingError : -headingError;
	mov	a,r5
	rlc	a
	cpl	c
	clr	a
	rlc	a
	mov	r7,a
	jz	00137$
	mov	ar6,r4
	mov	ar7,r5
	sjmp	00138$
00137$:
	clr	c
	clr	a
	subb	a,r4
	mov	r6,a
	clr	a
	subb	a,r5
	mov	r7,a
00138$:
	mov	ar2,r6
	mov	ar3,r7
	C$slave_wixel_track.c$883$3$8 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:883: if (abs_error > 45)
	clr	c
	mov	a,#0x2D
	subb	a,r2
	clr	a
	xrl	a,#0x80
	mov	b,r3
	xrl	b,#0x80
	subb	a,b
	jnc	00123$
	C$slave_wixel_track.c$885$4$9 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:885: homeSubState = 0;  // Back to rotation phase
	mov	r0,#_homeSubState
	clr	a
	movx	@r0,a
	C$slave_wixel_track.c$886$4$9 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:886: pwm_left = 0;
	mov	r0,#_pwm_left
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	C$slave_wixel_track.c$887$4$9 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:887: pwm_right = 0;
	mov	r0,#_pwm_right
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	sjmp	00133$
00123$:
	C$slave_wixel_track.c$892$4$10 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:892: int16 steeringAdjust = (headingError * STEERING_KP);
	mov	ar6,r4
	mov	a,r5
	xch	a,r6
	add	a,acc
	xch	a,r6
	rlc	a
	mov	r7,a
	C$slave_wixel_track.c$895$4$10 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:895: if (steeringAdjust > MAX_STEERING_ADJUST)
	clr	c
	mov	a,#0x1E
	subb	a,r6
	clr	a
	xrl	a,#0x80
	mov	b,r7
	xrl	b,#0x80
	subb	a,b
	jnc	00115$
	C$slave_wixel_track.c$896$4$10 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:896: steeringAdjust = MAX_STEERING_ADJUST;
	mov	r6,#0x1E
	mov	r7,#0x00
00115$:
	C$slave_wixel_track.c$897$4$10 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:897: if (steeringAdjust < -MAX_STEERING_ADJUST)
	clr	c
	mov	a,r6
	subb	a,#0xE2
	mov	a,r7
	xrl	a,#0x80
	subb	a,#0x7f
	jnc	00117$
	C$slave_wixel_track.c$898$4$10 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:898: steeringAdjust = -MAX_STEERING_ADJUST;
	mov	r6,#0xE2
	mov	r7,#0xFF
00117$:
	C$slave_wixel_track.c$901$4$10 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:901: pwm_left = FORWARD_SPEED_PWM - steeringAdjust;
	mov	a,#0x50
	clr	c
	subb	a,r6
	mov	r4,a
	clr	a
	subb	a,r7
	mov	r5,a
	mov	r0,#_pwm_left
	mov	a,r4
	movx	@r0,a
	inc	r0
	mov	a,r5
	movx	@r0,a
	C$slave_wixel_track.c$902$4$10 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:902: pwm_right = FORWARD_SPEED_PWM + steeringAdjust;
	mov	a,#0x50
	add	a,r6
	mov	r6,a
	clr	a
	addc	a,r7
	mov	r7,a
	mov	r0,#_pwm_right
	mov	a,r6
	movx	@r0,a
	inc	r0
	mov	a,r7
	movx	@r0,a
	C$slave_wixel_track.c$905$4$10 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:905: if (pwm_left < 0) pwm_left = 0;
	mov	a,r5
	jnb	acc.7,00119$
	mov	r0,#_pwm_left
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
00119$:
	C$slave_wixel_track.c$906$4$10 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:906: if (pwm_right < 0) pwm_right = 0;
	mov	a,r7
	jnb	acc.7,00133$
	mov	r0,#_pwm_right
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
00133$:
	C$slave_wixel_track.c$911$2$1 ==.
	XG$updateHomeState$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'updateRunState'
;------------------------------------------------------------
	G$updateRunState$0$0 ==.
	C$slave_wixel_track.c$913$2$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:913: void updateRunState()
;	-----------------------------------------
;	 function updateRunState
;	-----------------------------------------
_updateRunState:
	C$slave_wixel_track.c$915$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:915: uint32 elapsedTime = now - stateStartTime;
	mov	r0,#_now
	mov	r1,#_stateStartTime
	movx	a,@r1
	mov	b,a
	clr	c
	movx	a,@r0
	subb	a,b
	mov	r4,a
	inc	r1
	movx	a,@r1
	mov	b,a
	inc	r0
	movx	a,@r0
	subb	a,b
	mov	r5,a
	inc	r1
	movx	a,@r1
	mov	b,a
	inc	r0
	movx	a,@r0
	subb	a,b
	mov	r6,a
	inc	r1
	movx	a,@r1
	mov	b,a
	inc	r0
	movx	a,@r0
	subb	a,b
	mov	r7,a
	C$slave_wixel_track.c$920$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:920: if (elapsedTime >= RUN_TIMEOUT)
	clr	c
	mov	a,r4
	subb	a,#0x60
	mov	a,r5
	subb	a,#0xEA
	mov	a,r6
	subb	a,#0x00
	mov	a,r7
	subb	a,#0x00
	jc	00102$
	C$slave_wixel_track.c$922$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:922: currentState = STATE_IDLE;
	mov	r0,#_currentState
	clr	a
	movx	@r0,a
	C$slave_wixel_track.c$923$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:923: waypointCount = 0;
	mov	r0,#_waypointCount
	clr	a
	movx	@r0,a
	C$slave_wixel_track.c$924$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:924: currentWaypointIndex = 0;
	mov	r0,#_currentWaypointIndex
	clr	a
	movx	@r0,a
	C$slave_wixel_track.c$925$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:925: runSubState = 0;
	mov	r0,#_runSubState
	clr	a
	movx	@r0,a
	C$slave_wixel_track.c$926$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:926: pwm_left = 0;
	mov	r0,#_pwm_left
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	C$slave_wixel_track.c$927$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:927: pwm_right = 0;
	mov	r0,#_pwm_right
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	C$slave_wixel_track.c$928$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:928: stopMotors();
	lcall	_stopMotors
	C$slave_wixel_track.c$929$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:929: return;
	ljmp	00135$
00102$:
	C$slave_wixel_track.c$932$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:932: if (currentWaypointIndex >= waypointCount)
	mov	r0,#_currentWaypointIndex
	mov	r1,#_waypointCount
	clr	c
	movx	a,@r1
	mov	b,a
	movx	a,@r0
	subb	a,b
	jc	00104$
	C$slave_wixel_track.c$935$2$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:935: currentState = STATE_IDLE;
	mov	r0,#_currentState
	clr	a
	movx	@r0,a
	C$slave_wixel_track.c$936$2$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:936: waypointCount = 0;
	mov	r0,#_waypointCount
	clr	a
	movx	@r0,a
	C$slave_wixel_track.c$937$2$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:937: currentWaypointIndex = 0;
	mov	r0,#_currentWaypointIndex
	clr	a
	movx	@r0,a
	C$slave_wixel_track.c$938$2$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:938: runSubState = 0;
	mov	r0,#_runSubState
	clr	a
	movx	@r0,a
	C$slave_wixel_track.c$939$2$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:939: pwm_left = 0;
	mov	r0,#_pwm_left
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	C$slave_wixel_track.c$940$2$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:940: pwm_right = 0;
	mov	r0,#_pwm_right
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	C$slave_wixel_track.c$941$2$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:941: stopMotors();
	lcall	_stopMotors
	C$slave_wixel_track.c$942$2$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:942: return;
	ljmp	00135$
00104$:
	C$slave_wixel_track.c$946$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:946: targetX = waypoints[currentWaypointIndex].x;
	mov	r0,#_currentWaypointIndex
	movx	a,@r0
	mov	b,#0x05
	mul	ab
	add	a,#_waypoints
	mov	r7,a
	inc	a
	mov	r1,a
	movx	a,@r1
	mov	r5,a
	inc	r1
	movx	a,@r1
	mov	r6,a
	mov	r0,#_targetX
	mov	a,r5
	movx	@r0,a
	inc	r0
	mov	a,r6
	movx	@r0,a
	C$slave_wixel_track.c$947$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:947: targetY = waypoints[currentWaypointIndex].y;
	mov	a,#0x03
	add	a,r7
	mov	r1,a
	movx	a,@r1
	mov	r4,a
	inc	r1
	movx	a,@r1
	mov	r7,a
	mov	r0,#_targetY
	mov	a,r4
	movx	@r0,a
	inc	r0
	mov	a,r7
	movx	@r0,a
	C$slave_wixel_track.c$949$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:949: if (runSubState == 0)
	mov	r0,#_runSubState
	movx	a,@r0
	jz	00160$
	ljmp	00133$
00160$:
	C$slave_wixel_track.c$952$2$4 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:952: targetHeading = calculateTargetHeading(filteredX, filteredY, targetX, targetY);
	mov	r0,#_filteredY
	mov	r1,#_calculateTargetHeading_PARM_2
	movx	a,@r0
	movx	@r1,a
	inc	r0
	movx	a,@r0
	inc	r1
	movx	@r1,a
	mov	r0,#_calculateTargetHeading_PARM_3
	mov	a,r5
	movx	@r0,a
	inc	r0
	mov	a,r6
	movx	@r0,a
	mov	r0,#_calculateTargetHeading_PARM_4
	mov	a,r4
	movx	@r0,a
	inc	r0
	mov	a,r7
	movx	@r0,a
	mov	r0,#_filteredX
	movx	a,@r0
	mov	dpl,a
	inc	r0
	movx	a,@r0
	mov	dph,a
	lcall	_calculateTargetHeading
	mov	r7,dpl
	mov	r6,dph
	C$slave_wixel_track.c$954$2$4 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:954: headingError = targetHeading - filteredTheta;
	mov	r0,#_filteredTheta
	setb	c
	movx	a,@r0
	subb	a,r7
	cpl	a
	cpl	c
	mov	r5,a
	cpl	c
	inc	r0
	movx	a,@r0
	subb	a,r6
	cpl	a
	mov	r4,a
	C$slave_wixel_track.c$955$2$4 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:955: if (headingError > 180)
	clr	c
	mov	a,#0xB4
	subb	a,r5
	clr	a
	xrl	a,#0x80
	mov	b,r4
	xrl	b,#0x80
	subb	a,b
	jnc	00106$
	C$slave_wixel_track.c$956$2$4 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:956: headingError -= 360;
	mov	a,r5
	add	a,#0x98
	mov	r5,a
	mov	a,r4
	addc	a,#0xFE
	mov	r4,a
00106$:
	C$slave_wixel_track.c$957$2$4 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:957: if (headingError < -180)
	clr	c
	mov	a,r5
	subb	a,#0x4C
	mov	a,r4
	xrl	a,#0x80
	subb	a,#0x7f
	jnc	00108$
	C$slave_wixel_track.c$958$2$4 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:958: headingError += 360;
	mov	a,#0x68
	add	a,r5
	mov	r5,a
	mov	a,#0x01
	addc	a,r4
	mov	r4,a
00108$:
	C$slave_wixel_track.c$960$2$4 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:960: abs_error = (headingError >= 0) ? headingError : -headingError;
	mov	a,r4
	rlc	a
	cpl	c
	clr	a
	rlc	a
	mov	r3,a
	jz	00137$
	mov	ar2,r5
	mov	ar3,r4
	sjmp	00138$
00137$:
	clr	c
	clr	a
	subb	a,r5
	mov	r2,a
	clr	a
	subb	a,r4
	mov	r3,a
00138$:
	C$slave_wixel_track.c$962$2$4 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:962: if (abs_error < HEADING_THRESHOLD)
	clr	c
	mov	a,r2
	subb	a,#0x05
	mov	a,r3
	xrl	a,#0x80
	subb	a,#0x80
	jnc	00110$
	C$slave_wixel_track.c$965$3$5 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:965: runSubState = 1;
	mov	r0,#_runSubState
	mov	a,#0x01
	movx	@r0,a
	ljmp	00135$
00110$:
	C$slave_wixel_track.c$969$3$6 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:969: rotationController(filteredTheta, targetHeading);
	mov	r0,#_rotationController_PARM_2
	mov	a,r7
	movx	@r0,a
	inc	r0
	mov	a,r6
	movx	@r0,a
	mov	r0,#_filteredTheta
	movx	a,@r0
	mov	dpl,a
	inc	r0
	movx	a,@r0
	mov	dph,a
	lcall	_rotationController
	ljmp	00135$
00133$:
	C$slave_wixel_track.c$972$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:972: else if (runSubState == 1)
	mov	r0,#_runSubState
	movx	a,@r0
	cjne	a,#0x01,00166$
	sjmp	00167$
00166$:
	ljmp	00135$
00167$:
	C$slave_wixel_track.c$975$2$7 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:975: if (isWithinThreshold(filteredX, filteredY, targetX, targetY, GOAL_THRESHOLD))
	mov	r0,#_filteredY
	mov	r1,#_isWithinThreshold_PARM_2
	movx	a,@r0
	movx	@r1,a
	inc	r0
	movx	a,@r0
	inc	r1
	movx	@r1,a
	mov	r0,#_isWithinThreshold_PARM_3
	mov	a,r5
	movx	@r0,a
	inc	r0
	mov	a,r6
	movx	@r0,a
	mov	r0,#_isWithinThreshold_PARM_4
	mov	a,r4
	movx	@r0,a
	inc	r0
	mov	a,r7
	movx	@r0,a
	mov	r0,#_isWithinThreshold_PARM_5
	mov	a,#0x96
	movx	@r0,a
	inc	r0
	clr	a
	movx	@r0,a
	mov	r0,#_filteredX
	movx	a,@r0
	mov	dpl,a
	inc	r0
	movx	a,@r0
	mov	dph,a
	lcall	_isWithinThreshold
	mov	a,dpl
	jz	00128$
	C$slave_wixel_track.c$978$3$8 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:978: currentWaypointIndex++;
	mov	r0,#_currentWaypointIndex
	movx	a,@r0
	add	a,#0x01
	movx	@r0,a
	C$slave_wixel_track.c$979$3$8 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:979: runSubState = 0;  // Reset to rotation for next waypoint
	mov	r0,#_runSubState
	clr	a
	movx	@r0,a
	C$slave_wixel_track.c$980$3$8 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:980: pwm_left = 0;
	mov	r0,#_pwm_left
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	C$slave_wixel_track.c$981$3$8 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:981: pwm_right = 0;
	mov	r0,#_pwm_right
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	ljmp	00135$
00128$:
	C$slave_wixel_track.c$986$3$9 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:986: targetHeading = calculateTargetHeading(filteredX, filteredY, targetX, targetY);
	mov	r0,#_filteredY
	mov	r1,#_calculateTargetHeading_PARM_2
	movx	a,@r0
	movx	@r1,a
	inc	r0
	movx	a,@r0
	inc	r1
	movx	@r1,a
	mov	r0,#_targetX
	mov	r1,#_calculateTargetHeading_PARM_3
	movx	a,@r0
	movx	@r1,a
	inc	r0
	movx	a,@r0
	inc	r1
	movx	@r1,a
	mov	r0,#_targetY
	mov	r1,#_calculateTargetHeading_PARM_4
	movx	a,@r0
	movx	@r1,a
	inc	r0
	movx	a,@r0
	inc	r1
	movx	@r1,a
	mov	r0,#_filteredX
	movx	a,@r0
	mov	dpl,a
	inc	r0
	movx	a,@r0
	mov	dph,a
	lcall	_calculateTargetHeading
	mov	r7,dpl
	mov	r6,dph
	C$slave_wixel_track.c$988$3$9 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:988: headingError = targetHeading - filteredTheta;
	mov	r0,#_filteredTheta
	setb	c
	movx	a,@r0
	subb	a,r7
	cpl	a
	cpl	c
	mov	r5,a
	cpl	c
	inc	r0
	movx	a,@r0
	subb	a,r6
	cpl	a
	mov	r4,a
	C$slave_wixel_track.c$989$3$9 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:989: if (headingError > 180)
	clr	c
	mov	a,#0xB4
	subb	a,r5
	clr	a
	xrl	a,#0x80
	mov	b,r4
	xrl	b,#0x80
	subb	a,b
	jnc	00113$
	C$slave_wixel_track.c$990$3$9 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:990: headingError -= 360;
	mov	a,r5
	add	a,#0x98
	mov	r5,a
	mov	a,r4
	addc	a,#0xFE
	mov	r4,a
00113$:
	C$slave_wixel_track.c$991$3$9 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:991: if (headingError < -180)
	clr	c
	mov	a,r5
	subb	a,#0x4C
	mov	a,r4
	xrl	a,#0x80
	subb	a,#0x7f
	jnc	00115$
	C$slave_wixel_track.c$992$3$9 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:992: headingError += 360;
	mov	a,#0x68
	add	a,r5
	mov	r5,a
	mov	a,#0x01
	addc	a,r4
	mov	r4,a
00115$:
	C$slave_wixel_track.c$994$3$9 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:994: abs_error = (headingError >= 0) ? headingError : -headingError;
	mov	a,r4
	rlc	a
	cpl	c
	clr	a
	rlc	a
	mov	r7,a
	jz	00139$
	mov	ar6,r5
	mov	ar7,r4
	sjmp	00140$
00139$:
	clr	c
	clr	a
	subb	a,r5
	mov	r6,a
	clr	a
	subb	a,r4
	mov	r7,a
00140$:
	mov	ar2,r6
	mov	ar3,r7
	C$slave_wixel_track.c$997$3$9 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:997: if (abs_error > 45)
	clr	c
	mov	a,#0x2D
	subb	a,r2
	clr	a
	xrl	a,#0x80
	mov	b,r3
	xrl	b,#0x80
	subb	a,b
	jnc	00125$
	C$slave_wixel_track.c$999$4$10 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:999: runSubState = 0;  // Back to rotation phase
	mov	r0,#_runSubState
	clr	a
	movx	@r0,a
	C$slave_wixel_track.c$1000$4$10 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1000: pwm_left = 0;
	mov	r0,#_pwm_left
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	C$slave_wixel_track.c$1001$4$10 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1001: pwm_right = 0;
	mov	r0,#_pwm_right
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	sjmp	00135$
00125$:
	C$slave_wixel_track.c$1006$4$11 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1006: int16 steeringAdjust = (headingError * STEERING_KP);
	mov	ar6,r5
	mov	a,r4
	xch	a,r6
	add	a,acc
	xch	a,r6
	rlc	a
	mov	r7,a
	C$slave_wixel_track.c$1009$4$11 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1009: if (steeringAdjust > MAX_STEERING_ADJUST)
	clr	c
	mov	a,#0x1E
	subb	a,r6
	clr	a
	xrl	a,#0x80
	mov	b,r7
	xrl	b,#0x80
	subb	a,b
	jnc	00117$
	C$slave_wixel_track.c$1010$4$11 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1010: steeringAdjust = MAX_STEERING_ADJUST;
	mov	r6,#0x1E
	mov	r7,#0x00
00117$:
	C$slave_wixel_track.c$1011$4$11 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1011: if (steeringAdjust < -MAX_STEERING_ADJUST)
	clr	c
	mov	a,r6
	subb	a,#0xE2
	mov	a,r7
	xrl	a,#0x80
	subb	a,#0x7f
	jnc	00119$
	C$slave_wixel_track.c$1012$4$11 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1012: steeringAdjust = -MAX_STEERING_ADJUST;
	mov	r6,#0xE2
	mov	r7,#0xFF
00119$:
	C$slave_wixel_track.c$1015$4$11 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1015: pwm_left = FORWARD_SPEED_PWM - steeringAdjust;
	mov	a,#0x50
	clr	c
	subb	a,r6
	mov	r4,a
	clr	a
	subb	a,r7
	mov	r5,a
	mov	r0,#_pwm_left
	mov	a,r4
	movx	@r0,a
	inc	r0
	mov	a,r5
	movx	@r0,a
	C$slave_wixel_track.c$1016$4$11 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1016: pwm_right = FORWARD_SPEED_PWM + steeringAdjust;
	mov	a,#0x50
	add	a,r6
	mov	r6,a
	clr	a
	addc	a,r7
	mov	r7,a
	mov	r0,#_pwm_right
	mov	a,r6
	movx	@r0,a
	inc	r0
	mov	a,r7
	movx	@r0,a
	C$slave_wixel_track.c$1019$4$11 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1019: if (pwm_left < 0) pwm_left = 0;
	mov	a,r5
	jnb	acc.7,00121$
	mov	r0,#_pwm_left
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
00121$:
	C$slave_wixel_track.c$1020$4$11 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1020: if (pwm_right < 0) pwm_right = 0;
	mov	a,r7
	jnb	acc.7,00135$
	mov	r0,#_pwm_right
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
00135$:
	C$slave_wixel_track.c$1024$2$1 ==.
	XG$updateRunState$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'updateStateMachine'
;------------------------------------------------------------
	G$updateStateMachine$0$0 ==.
	C$slave_wixel_track.c$1026$2$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1026: void updateStateMachine()
;	-----------------------------------------
;	 function updateStateMachine
;	-----------------------------------------
_updateStateMachine:
	C$slave_wixel_track.c$1028$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1028: switch(currentState)
	mov	r0,#_currentState
	movx	a,@r0
	jz	00101$
	mov	r0,#_currentState
	movx	a,@r0
	cjne	a,#0x01,00124$
	sjmp	00102$
00124$:
	mov	r0,#_currentState
	movx	a,@r0
	cjne	a,#0x02,00125$
	sjmp	00103$
00125$:
	mov	r0,#_currentState
	movx	a,@r0
	cjne	a,#0x03,00126$
	ljmp	00113$
00126$:
	mov	r0,#_currentState
	movx	a,@r0
	cjne	a,#0x10,00127$
	sjmp	00105$
00127$:
	ljmp	00113$
	C$slave_wixel_track.c$1030$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1030: case STATE_IDLE:
00101$:
	C$slave_wixel_track.c$1031$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1031: stopMotors();
	lcall	_stopMotors
	C$slave_wixel_track.c$1032$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1032: break;
	ljmp	00113$
	C$slave_wixel_track.c$1033$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1033: case STATE_HOME:
00102$:
	C$slave_wixel_track.c$1034$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1034: updateHomeState();
	lcall	_updateHomeState
	C$slave_wixel_track.c$1035$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1035: break;
	ljmp	00113$
	C$slave_wixel_track.c$1036$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1036: case STATE_RUN:
00103$:
	C$slave_wixel_track.c$1037$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1037: updateRunState();
	lcall	_updateRunState
	C$slave_wixel_track.c$1038$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1038: break;
	ljmp	00113$
	C$slave_wixel_track.c$1042$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1042: case STATE_CALIBRATE_VALIDATE:
00105$:
	C$slave_wixel_track.c$1043$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1043: cal_targetHeading = calculateTargetHeading(filteredX, filteredY, 0, 0);
	mov	r0,#_filteredY
	mov	r1,#_calculateTargetHeading_PARM_2
	movx	a,@r0
	movx	@r1,a
	inc	r0
	movx	a,@r0
	inc	r1
	movx	@r1,a
	mov	r0,#_calculateTargetHeading_PARM_3
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	mov	r0,#_calculateTargetHeading_PARM_4
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	mov	r0,#_filteredX
	movx	a,@r0
	mov	dpl,a
	inc	r0
	movx	a,@r0
	mov	dph,a
	lcall	_calculateTargetHeading
	mov	r6,dpl
	mov	r7,dph
	mov	r0,#_cal_targetHeading
	mov	a,r6
	movx	@r0,a
	inc	r0
	mov	a,r7
	movx	@r0,a
	C$slave_wixel_track.c$1044$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1044: rotationController(filteredTheta, cal_targetHeading);
	mov	r0,#_rotationController_PARM_2
	mov	a,r6
	movx	@r0,a
	inc	r0
	mov	a,r7
	movx	@r0,a
	mov	r0,#_filteredTheta
	movx	a,@r0
	mov	dpl,a
	inc	r0
	movx	a,@r0
	mov	dph,a
	lcall	_rotationController
	C$slave_wixel_track.c$1046$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1046: cal_headingError = cal_targetHeading - filteredTheta;
	mov	r0,#_cal_targetHeading
	mov	r1,#_filteredTheta
	movx	a,@r1
	mov	b,a
	clr	c
	movx	a,@r0
	subb	a,b
	mov	r6,a
	inc	r1
	movx	a,@r1
	mov	b,a
	inc	r0
	movx	a,@r0
	subb	a,b
	mov	r7,a
	mov	r0,#_cal_headingError
	mov	a,r6
	movx	@r0,a
	inc	r0
	mov	a,r7
	movx	@r0,a
	C$slave_wixel_track.c$1047$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1047: if (cal_headingError > 180) cal_headingError -= 360;
	clr	c
	mov	a,#0xB4
	subb	a,r6
	clr	a
	xrl	a,#0x80
	mov	b,r7
	xrl	b,#0x80
	subb	a,b
	jnc	00107$
	mov	r0,#_cal_headingError
	mov	a,r6
	add	a,#0x98
	movx	@r0,a
	mov	a,r7
	addc	a,#0xFE
	inc	r0
	movx	@r0,a
00107$:
	C$slave_wixel_track.c$1048$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1048: if (cal_headingError < -180) cal_headingError += 360;
	mov	r0,#_cal_headingError
	clr	c
	movx	a,@r0
	subb	a,#0x4C
	inc	r0
	movx	a,@r0
	xrl	a,#0x80
	subb	a,#0x7f
	jnc	00109$
	mov	r0,#_cal_headingError
	movx	a,@r0
	add	a,#0x68
	movx	@r0,a
	inc	r0
	movx	a,@r0
	addc	a,#0x01
	movx	@r0,a
00109$:
	C$slave_wixel_track.c$1050$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1050: if (abs16(cal_headingError) < HEADING_THRESHOLD)
	mov	r0,#_cal_headingError
	movx	a,@r0
	mov	dpl,a
	inc	r0
	movx	a,@r0
	mov	dph,a
	lcall	_abs16
	mov	r6,dpl
	mov	r7,dph
	clr	c
	mov	a,r6
	subb	a,#0x05
	mov	a,r7
	xrl	a,#0x80
	subb	a,#0x80
	jnc	00113$
	C$slave_wixel_track.c$1052$3$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1052: currentState = STATE_IDLE;
	mov	r0,#_currentState
	clr	a
	movx	@r0,a
	C$slave_wixel_track.c$1055$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1055: }
00113$:
	C$slave_wixel_track.c$1056$1$1 ==.
	XG$updateStateMachine$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'main'
;------------------------------------------------------------
	G$main$0$0 ==.
	C$slave_wixel_track.c$1060$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1060: void main()
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
	C$slave_wixel_track.c$1062$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1062: systemInit();
	lcall	_systemInit
	C$slave_wixel_track.c$1063$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1063: gpioInit();
	lcall	_gpioInit
	C$slave_wixel_track.c$1064$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1064: timer3Init();
	lcall	_timer3Init
	C$slave_wixel_track.c$1065$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1065: radioInit();
	lcall	_radioInit
	C$slave_wixel_track.c$1067$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1067: lastPacketTime = (uint16)getMs();
	lcall	_getMs
	mov	r4,dpl
	mov	r5,dph
	mov	r0,#_lastPacketTime
	mov	a,r4
	movx	@r0,a
	inc	r0
	mov	a,r5
	movx	@r0,a
	C$slave_wixel_track.c$1070$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1070: P1_2 = 0; P1_1 = 1; P1_7 = 1; delayMs(300);  // RED
	clr	_P1_2
	setb	_P1_1
	setb	_P1_7
	mov	dptr,#0x012C
	lcall	_delayMs
	C$slave_wixel_track.c$1071$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1071: P1_2 = 1; P1_1 = 0; P1_7 = 1; delayMs(300);  // GREEN
	setb	_P1_2
	clr	_P1_1
	setb	_P1_7
	mov	dptr,#0x012C
	lcall	_delayMs
	C$slave_wixel_track.c$1072$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1072: P1_2 = 1; P1_1 = 1; P1_7 = 0; delayMs(300);  // BLUE
	setb	_P1_2
	setb	_P1_1
	clr	_P1_7
	mov	dptr,#0x012C
	lcall	_delayMs
	C$slave_wixel_track.c$1073$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1073: P1_2 = 0; P1_1 = 1; P1_7 = 0; delayMs(300);  // PURPLE
	clr	_P1_2
	setb	_P1_1
	clr	_P1_7
	mov	dptr,#0x012C
	lcall	_delayMs
	C$slave_wixel_track.c$1074$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1074: P1_2 = 1; P1_1 = 1; P1_7 = 1; delayMs(500);  // OFF
	setb	_P1_2
	setb	_P1_1
	setb	_P1_7
	mov	dptr,#0x01F4
	lcall	_delayMs
	C$slave_wixel_track.c$1076$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1076: lastPacketTime = (uint16)getMs();
	lcall	_getMs
	mov	r4,dpl
	mov	r5,dph
	mov	r6,b
	mov	r7,a
	mov	r0,#_lastPacketTime
	mov	a,r4
	movx	@r0,a
	inc	r0
	mov	a,r5
	movx	@r0,a
	C$slave_wixel_track.c$1077$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1077: currentState = STATE_IDLE;
	mov	r0,#_currentState
	clr	a
	movx	@r0,a
	C$slave_wixel_track.c$1080$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1080: while(1)
00107$:
	C$slave_wixel_track.c$1082$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1082: boardService();
	lcall	_boardService
	C$slave_wixel_track.c$1084$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1084: now = (uint32)getMs();
	lcall	_getMs
	mov	r4,dpl
	mov	r5,dph
	mov	r6,b
	mov	r7,a
	mov	r0,#_now
	mov	a,r4
	movx	@r0,a
	inc	r0
	mov	a,r5
	movx	@r0,a
	inc	r0
	mov	a,r6
	movx	@r0,a
	inc	r0
	mov	a,r7
	movx	@r0,a
	C$slave_wixel_track.c$1087$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1087: counter_loop++;
	mov	r0,#_counter_loop
	movx	a,@r0
	add	a,#0x01
	movx	@r0,a
	inc	r0
	movx	a,@r0
	addc	a,#0x00
	movx	@r0,a
	C$slave_wixel_track.c$1088$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1088: counter_loop %= 5001;
	mov	r0,#__moduint_PARM_2
	mov	a,#0x89
	movx	@r0,a
	inc	r0
	mov	a,#0x13
	movx	@r0,a
	mov	r0,#_counter_loop
	movx	a,@r0
	mov	dpl,a
	inc	r0
	movx	a,@r0
	mov	dph,a
	lcall	__moduint
	mov	a,dpl
	mov	b,dph
	mov	r0,#_counter_loop
	movx	@r0,a
	inc	r0
	mov	a,b
	movx	@r0,a
	C$slave_wixel_track.c$1089$1$1 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1089: if (counter_loop % 500 == 0)
	mov	r0,#__moduint_PARM_2
	mov	a,#0xF4
	movx	@r0,a
	inc	r0
	mov	a,#0x01
	movx	@r0,a
	mov	r0,#_counter_loop
	movx	a,@r0
	mov	dpl,a
	inc	r0
	movx	a,@r0
	mov	dph,a
	lcall	__moduint
	mov	a,dpl
	mov	b,dph
	orl	a,b
	jnz	00102$
	C$slave_wixel_track.c$1090$3$3 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1090: LED_YELLOW_TOGGLE();
	xrl	_P2DIR,#0x04
00102$:
	C$slave_wixel_track.c$1093$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1093: receiveAndProcessPackets();
	lcall	_receiveAndProcessPackets
	C$slave_wixel_track.c$1096$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1096: if (rxPulseStart < 600)
	mov	r0,#_rxPulseStart
	clr	c
	movx	a,@r0
	subb	a,#0x58
	inc	r0
	movx	a,@r0
	subb	a,#0x02
	inc	r0
	movx	a,@r0
	subb	a,#0x00
	inc	r0
	movx	a,@r0
	subb	a,#0x00
	jnc	00104$
	C$slave_wixel_track.c$1098$4$5 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1098: LED_RED(1);
	orl	_P2DIR,#0x02
	C$slave_wixel_track.c$1099$3$4 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1099: rxPulseStart += 1;
	mov	r0,#_rxPulseStart
	movx	a,@r0
	add	a,#0x01
	movx	@r0,a
	inc	r0
	movx	a,@r0
	addc	a,#0x00
	movx	@r0,a
	inc	r0
	movx	a,@r0
	addc	a,#0x00
	movx	@r0,a
	inc	r0
	movx	a,@r0
	addc	a,#0x00
	movx	@r0,a
	sjmp	00105$
00104$:
	C$slave_wixel_track.c$1103$4$7 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1103: LED_RED(0);
	mov	r7,_P2DIR
	anl	ar7,#0xFD
	mov	_P2DIR,r7
00105$:
	C$slave_wixel_track.c$1107$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1107: handlePacketTimeout();
	lcall	_handlePacketTimeout
	C$slave_wixel_track.c$1108$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1108: updateStateMachine();
	lcall	_updateStateMachine
	C$slave_wixel_track.c$1109$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1109: updateRgbLeds();
	lcall	_updateRgbLeds
	C$slave_wixel_track.c$1110$2$2 ==.
;	apps/slave_wixel_track/slave_wixel_track.c:1110: setMotorsPWM();
	lcall	_setMotorsPWM
	ljmp	00107$
	C$slave_wixel_track.c$1112$1$1 ==.
	XG$main$0$0 ==.
	ret
	.area CSEG    (CODE)
	.area CONST   (CODE)
	.area XINIT   (CODE)
	.area CABS    (ABS,CODE)
