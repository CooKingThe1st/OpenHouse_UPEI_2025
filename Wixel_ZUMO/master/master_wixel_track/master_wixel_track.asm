;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.1.0 #7066 (Nov 22 2011) (MINGW32)
; This file was generated Fri Oct 24 22:20:40 2025
;--------------------------------------------------------
	.module master_wixel_track
	.optsdcc -mmcs51 --model-medium
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _initSystems
	.globl _processBytesFromUsb
	.globl _handleSerialTimeout
	.globl _processSerialPacket
	.globl _updateLeds
	.globl _sendRadioPacket
	.globl _radioInit
	.globl _failSafeBootloader
	.globl _sprintf
	.globl _usbComTxSend
	.globl _usbComRxReceiveByte
	.globl _usbComRxAvailable
	.globl _usbComService
	.globl _usbInit
	.globl _radioRegistersInit
	.globl _delayMs
	.globl _getMs
	.globl _boardService
	.globl _systemInit
	.globl _theta
	.globl _posY
	.globl _posX
	.globl _fsi
	.globl _responseLength
	.globl _radioTxPulseStart
	.globl _serialRxPulseStart
	.globl _lastHeartbeatTime
	.globl _lastRadioTxTime
	.globl _lastSerialRxTime
	.globl _slaveAddresses
	.globl _serialBufferIndex
	.globl _radioTxPulseActive
	.globl _serialRxPulseActive
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area RSEG    (ABS,DATA)
	.org 0x0000
Fmaster_wixel_track$P0$0$0 == 0x0080
_P0	=	0x0080
Fmaster_wixel_track$SP$0$0 == 0x0081
_SP	=	0x0081
Fmaster_wixel_track$DPL0$0$0 == 0x0082
_DPL0	=	0x0082
Fmaster_wixel_track$DPH0$0$0 == 0x0083
_DPH0	=	0x0083
Fmaster_wixel_track$DPL1$0$0 == 0x0084
_DPL1	=	0x0084
Fmaster_wixel_track$DPH1$0$0 == 0x0085
_DPH1	=	0x0085
Fmaster_wixel_track$U0CSR$0$0 == 0x0086
_U0CSR	=	0x0086
Fmaster_wixel_track$PCON$0$0 == 0x0087
_PCON	=	0x0087
Fmaster_wixel_track$TCON$0$0 == 0x0088
_TCON	=	0x0088
Fmaster_wixel_track$P0IFG$0$0 == 0x0089
_P0IFG	=	0x0089
Fmaster_wixel_track$P1IFG$0$0 == 0x008a
_P1IFG	=	0x008a
Fmaster_wixel_track$P2IFG$0$0 == 0x008b
_P2IFG	=	0x008b
Fmaster_wixel_track$PICTL$0$0 == 0x008c
_PICTL	=	0x008c
Fmaster_wixel_track$P1IEN$0$0 == 0x008d
_P1IEN	=	0x008d
Fmaster_wixel_track$P0INP$0$0 == 0x008f
_P0INP	=	0x008f
Fmaster_wixel_track$P1$0$0 == 0x0090
_P1	=	0x0090
Fmaster_wixel_track$RFIM$0$0 == 0x0091
_RFIM	=	0x0091
Fmaster_wixel_track$DPS$0$0 == 0x0092
_DPS	=	0x0092
Fmaster_wixel_track$MPAGE$0$0 == 0x0093
_MPAGE	=	0x0093
Fmaster_wixel_track$ENDIAN$0$0 == 0x0095
_ENDIAN	=	0x0095
Fmaster_wixel_track$S0CON$0$0 == 0x0098
_S0CON	=	0x0098
Fmaster_wixel_track$IEN2$0$0 == 0x009a
_IEN2	=	0x009a
Fmaster_wixel_track$S1CON$0$0 == 0x009b
_S1CON	=	0x009b
Fmaster_wixel_track$T2CT$0$0 == 0x009c
_T2CT	=	0x009c
Fmaster_wixel_track$T2PR$0$0 == 0x009d
_T2PR	=	0x009d
Fmaster_wixel_track$T2CTL$0$0 == 0x009e
_T2CTL	=	0x009e
Fmaster_wixel_track$P2$0$0 == 0x00a0
_P2	=	0x00a0
Fmaster_wixel_track$WORIRQ$0$0 == 0x00a1
_WORIRQ	=	0x00a1
Fmaster_wixel_track$WORCTRL$0$0 == 0x00a2
_WORCTRL	=	0x00a2
Fmaster_wixel_track$WOREVT0$0$0 == 0x00a3
_WOREVT0	=	0x00a3
Fmaster_wixel_track$WOREVT1$0$0 == 0x00a4
_WOREVT1	=	0x00a4
Fmaster_wixel_track$WORTIME0$0$0 == 0x00a5
_WORTIME0	=	0x00a5
Fmaster_wixel_track$WORTIME1$0$0 == 0x00a6
_WORTIME1	=	0x00a6
Fmaster_wixel_track$IEN0$0$0 == 0x00a8
_IEN0	=	0x00a8
Fmaster_wixel_track$IP0$0$0 == 0x00a9
_IP0	=	0x00a9
Fmaster_wixel_track$FWT$0$0 == 0x00ab
_FWT	=	0x00ab
Fmaster_wixel_track$FADDRL$0$0 == 0x00ac
_FADDRL	=	0x00ac
Fmaster_wixel_track$FADDRH$0$0 == 0x00ad
_FADDRH	=	0x00ad
Fmaster_wixel_track$FCTL$0$0 == 0x00ae
_FCTL	=	0x00ae
Fmaster_wixel_track$FWDATA$0$0 == 0x00af
_FWDATA	=	0x00af
Fmaster_wixel_track$ENCDI$0$0 == 0x00b1
_ENCDI	=	0x00b1
Fmaster_wixel_track$ENCDO$0$0 == 0x00b2
_ENCDO	=	0x00b2
Fmaster_wixel_track$ENCCS$0$0 == 0x00b3
_ENCCS	=	0x00b3
Fmaster_wixel_track$ADCCON1$0$0 == 0x00b4
_ADCCON1	=	0x00b4
Fmaster_wixel_track$ADCCON2$0$0 == 0x00b5
_ADCCON2	=	0x00b5
Fmaster_wixel_track$ADCCON3$0$0 == 0x00b6
_ADCCON3	=	0x00b6
Fmaster_wixel_track$IEN1$0$0 == 0x00b8
_IEN1	=	0x00b8
Fmaster_wixel_track$IP1$0$0 == 0x00b9
_IP1	=	0x00b9
Fmaster_wixel_track$ADCL$0$0 == 0x00ba
_ADCL	=	0x00ba
Fmaster_wixel_track$ADCH$0$0 == 0x00bb
_ADCH	=	0x00bb
Fmaster_wixel_track$RNDL$0$0 == 0x00bc
_RNDL	=	0x00bc
Fmaster_wixel_track$RNDH$0$0 == 0x00bd
_RNDH	=	0x00bd
Fmaster_wixel_track$SLEEP$0$0 == 0x00be
_SLEEP	=	0x00be
Fmaster_wixel_track$IRCON$0$0 == 0x00c0
_IRCON	=	0x00c0
Fmaster_wixel_track$U0DBUF$0$0 == 0x00c1
_U0DBUF	=	0x00c1
Fmaster_wixel_track$U0BAUD$0$0 == 0x00c2
_U0BAUD	=	0x00c2
Fmaster_wixel_track$U0UCR$0$0 == 0x00c4
_U0UCR	=	0x00c4
Fmaster_wixel_track$U0GCR$0$0 == 0x00c5
_U0GCR	=	0x00c5
Fmaster_wixel_track$CLKCON$0$0 == 0x00c6
_CLKCON	=	0x00c6
Fmaster_wixel_track$MEMCTR$0$0 == 0x00c7
_MEMCTR	=	0x00c7
Fmaster_wixel_track$WDCTL$0$0 == 0x00c9
_WDCTL	=	0x00c9
Fmaster_wixel_track$T3CNT$0$0 == 0x00ca
_T3CNT	=	0x00ca
Fmaster_wixel_track$T3CTL$0$0 == 0x00cb
_T3CTL	=	0x00cb
Fmaster_wixel_track$T3CCTL0$0$0 == 0x00cc
_T3CCTL0	=	0x00cc
Fmaster_wixel_track$T3CC0$0$0 == 0x00cd
_T3CC0	=	0x00cd
Fmaster_wixel_track$T3CCTL1$0$0 == 0x00ce
_T3CCTL1	=	0x00ce
Fmaster_wixel_track$T3CC1$0$0 == 0x00cf
_T3CC1	=	0x00cf
Fmaster_wixel_track$PSW$0$0 == 0x00d0
_PSW	=	0x00d0
Fmaster_wixel_track$DMAIRQ$0$0 == 0x00d1
_DMAIRQ	=	0x00d1
Fmaster_wixel_track$DMA1CFGL$0$0 == 0x00d2
_DMA1CFGL	=	0x00d2
Fmaster_wixel_track$DMA1CFGH$0$0 == 0x00d3
_DMA1CFGH	=	0x00d3
Fmaster_wixel_track$DMA0CFGL$0$0 == 0x00d4
_DMA0CFGL	=	0x00d4
Fmaster_wixel_track$DMA0CFGH$0$0 == 0x00d5
_DMA0CFGH	=	0x00d5
Fmaster_wixel_track$DMAARM$0$0 == 0x00d6
_DMAARM	=	0x00d6
Fmaster_wixel_track$DMAREQ$0$0 == 0x00d7
_DMAREQ	=	0x00d7
Fmaster_wixel_track$TIMIF$0$0 == 0x00d8
_TIMIF	=	0x00d8
Fmaster_wixel_track$RFD$0$0 == 0x00d9
_RFD	=	0x00d9
Fmaster_wixel_track$T1CC0L$0$0 == 0x00da
_T1CC0L	=	0x00da
Fmaster_wixel_track$T1CC0H$0$0 == 0x00db
_T1CC0H	=	0x00db
Fmaster_wixel_track$T1CC1L$0$0 == 0x00dc
_T1CC1L	=	0x00dc
Fmaster_wixel_track$T1CC1H$0$0 == 0x00dd
_T1CC1H	=	0x00dd
Fmaster_wixel_track$T1CC2L$0$0 == 0x00de
_T1CC2L	=	0x00de
Fmaster_wixel_track$T1CC2H$0$0 == 0x00df
_T1CC2H	=	0x00df
Fmaster_wixel_track$ACC$0$0 == 0x00e0
_ACC	=	0x00e0
Fmaster_wixel_track$RFST$0$0 == 0x00e1
_RFST	=	0x00e1
Fmaster_wixel_track$T1CNTL$0$0 == 0x00e2
_T1CNTL	=	0x00e2
Fmaster_wixel_track$T1CNTH$0$0 == 0x00e3
_T1CNTH	=	0x00e3
Fmaster_wixel_track$T1CTL$0$0 == 0x00e4
_T1CTL	=	0x00e4
Fmaster_wixel_track$T1CCTL0$0$0 == 0x00e5
_T1CCTL0	=	0x00e5
Fmaster_wixel_track$T1CCTL1$0$0 == 0x00e6
_T1CCTL1	=	0x00e6
Fmaster_wixel_track$T1CCTL2$0$0 == 0x00e7
_T1CCTL2	=	0x00e7
Fmaster_wixel_track$IRCON2$0$0 == 0x00e8
_IRCON2	=	0x00e8
Fmaster_wixel_track$RFIF$0$0 == 0x00e9
_RFIF	=	0x00e9
Fmaster_wixel_track$T4CNT$0$0 == 0x00ea
_T4CNT	=	0x00ea
Fmaster_wixel_track$T4CTL$0$0 == 0x00eb
_T4CTL	=	0x00eb
Fmaster_wixel_track$T4CCTL0$0$0 == 0x00ec
_T4CCTL0	=	0x00ec
Fmaster_wixel_track$T4CC0$0$0 == 0x00ed
_T4CC0	=	0x00ed
Fmaster_wixel_track$T4CCTL1$0$0 == 0x00ee
_T4CCTL1	=	0x00ee
Fmaster_wixel_track$T4CC1$0$0 == 0x00ef
_T4CC1	=	0x00ef
Fmaster_wixel_track$B$0$0 == 0x00f0
_B	=	0x00f0
Fmaster_wixel_track$PERCFG$0$0 == 0x00f1
_PERCFG	=	0x00f1
Fmaster_wixel_track$ADCCFG$0$0 == 0x00f2
_ADCCFG	=	0x00f2
Fmaster_wixel_track$P0SEL$0$0 == 0x00f3
_P0SEL	=	0x00f3
Fmaster_wixel_track$P1SEL$0$0 == 0x00f4
_P1SEL	=	0x00f4
Fmaster_wixel_track$P2SEL$0$0 == 0x00f5
_P2SEL	=	0x00f5
Fmaster_wixel_track$P1INP$0$0 == 0x00f6
_P1INP	=	0x00f6
Fmaster_wixel_track$P2INP$0$0 == 0x00f7
_P2INP	=	0x00f7
Fmaster_wixel_track$U1CSR$0$0 == 0x00f8
_U1CSR	=	0x00f8
Fmaster_wixel_track$U1DBUF$0$0 == 0x00f9
_U1DBUF	=	0x00f9
Fmaster_wixel_track$U1BAUD$0$0 == 0x00fa
_U1BAUD	=	0x00fa
Fmaster_wixel_track$U1UCR$0$0 == 0x00fb
_U1UCR	=	0x00fb
Fmaster_wixel_track$U1GCR$0$0 == 0x00fc
_U1GCR	=	0x00fc
Fmaster_wixel_track$P0DIR$0$0 == 0x00fd
_P0DIR	=	0x00fd
Fmaster_wixel_track$P1DIR$0$0 == 0x00fe
_P1DIR	=	0x00fe
Fmaster_wixel_track$P2DIR$0$0 == 0x00ff
_P2DIR	=	0x00ff
Fmaster_wixel_track$DMA0CFG$0$0 == 0xffffd5d4
_DMA0CFG	=	0xffffd5d4
Fmaster_wixel_track$DMA1CFG$0$0 == 0xffffd3d2
_DMA1CFG	=	0xffffd3d2
Fmaster_wixel_track$FADDR$0$0 == 0xffffadac
_FADDR	=	0xffffadac
Fmaster_wixel_track$ADC$0$0 == 0xffffbbba
_ADC	=	0xffffbbba
Fmaster_wixel_track$T1CC0$0$0 == 0xffffdbda
_T1CC0	=	0xffffdbda
Fmaster_wixel_track$T1CC1$0$0 == 0xffffdddc
_T1CC1	=	0xffffdddc
Fmaster_wixel_track$T1CC2$0$0 == 0xffffdfde
_T1CC2	=	0xffffdfde
;--------------------------------------------------------
; special function bits
;--------------------------------------------------------
	.area RSEG    (ABS,DATA)
	.org 0x0000
Fmaster_wixel_track$P0_0$0$0 == 0x0080
_P0_0	=	0x0080
Fmaster_wixel_track$P0_1$0$0 == 0x0081
_P0_1	=	0x0081
Fmaster_wixel_track$P0_2$0$0 == 0x0082
_P0_2	=	0x0082
Fmaster_wixel_track$P0_3$0$0 == 0x0083
_P0_3	=	0x0083
Fmaster_wixel_track$P0_4$0$0 == 0x0084
_P0_4	=	0x0084
Fmaster_wixel_track$P0_5$0$0 == 0x0085
_P0_5	=	0x0085
Fmaster_wixel_track$P0_6$0$0 == 0x0086
_P0_6	=	0x0086
Fmaster_wixel_track$P0_7$0$0 == 0x0087
_P0_7	=	0x0087
Fmaster_wixel_track$_TCON_0$0$0 == 0x0088
__TCON_0	=	0x0088
Fmaster_wixel_track$RFTXRXIF$0$0 == 0x0089
_RFTXRXIF	=	0x0089
Fmaster_wixel_track$_TCON_2$0$0 == 0x008a
__TCON_2	=	0x008a
Fmaster_wixel_track$URX0IF$0$0 == 0x008b
_URX0IF	=	0x008b
Fmaster_wixel_track$_TCON_4$0$0 == 0x008c
__TCON_4	=	0x008c
Fmaster_wixel_track$ADCIF$0$0 == 0x008d
_ADCIF	=	0x008d
Fmaster_wixel_track$_TCON_6$0$0 == 0x008e
__TCON_6	=	0x008e
Fmaster_wixel_track$URX1IF$0$0 == 0x008f
_URX1IF	=	0x008f
Fmaster_wixel_track$P1_0$0$0 == 0x0090
_P1_0	=	0x0090
Fmaster_wixel_track$P1_1$0$0 == 0x0091
_P1_1	=	0x0091
Fmaster_wixel_track$P1_2$0$0 == 0x0092
_P1_2	=	0x0092
Fmaster_wixel_track$P1_3$0$0 == 0x0093
_P1_3	=	0x0093
Fmaster_wixel_track$P1_4$0$0 == 0x0094
_P1_4	=	0x0094
Fmaster_wixel_track$P1_5$0$0 == 0x0095
_P1_5	=	0x0095
Fmaster_wixel_track$P1_6$0$0 == 0x0096
_P1_6	=	0x0096
Fmaster_wixel_track$P1_7$0$0 == 0x0097
_P1_7	=	0x0097
Fmaster_wixel_track$ENCIF_0$0$0 == 0x0098
_ENCIF_0	=	0x0098
Fmaster_wixel_track$ENCIF_1$0$0 == 0x0099
_ENCIF_1	=	0x0099
Fmaster_wixel_track$_SOCON2$0$0 == 0x009a
__SOCON2	=	0x009a
Fmaster_wixel_track$_SOCON3$0$0 == 0x009b
__SOCON3	=	0x009b
Fmaster_wixel_track$_SOCON4$0$0 == 0x009c
__SOCON4	=	0x009c
Fmaster_wixel_track$_SOCON5$0$0 == 0x009d
__SOCON5	=	0x009d
Fmaster_wixel_track$_SOCON6$0$0 == 0x009e
__SOCON6	=	0x009e
Fmaster_wixel_track$_SOCON7$0$0 == 0x009f
__SOCON7	=	0x009f
Fmaster_wixel_track$P2_0$0$0 == 0x00a0
_P2_0	=	0x00a0
Fmaster_wixel_track$P2_1$0$0 == 0x00a1
_P2_1	=	0x00a1
Fmaster_wixel_track$P2_2$0$0 == 0x00a2
_P2_2	=	0x00a2
Fmaster_wixel_track$P2_3$0$0 == 0x00a3
_P2_3	=	0x00a3
Fmaster_wixel_track$P2_4$0$0 == 0x00a4
_P2_4	=	0x00a4
Fmaster_wixel_track$P2_5$0$0 == 0x00a5
_P2_5	=	0x00a5
Fmaster_wixel_track$P2_6$0$0 == 0x00a6
_P2_6	=	0x00a6
Fmaster_wixel_track$P2_7$0$0 == 0x00a7
_P2_7	=	0x00a7
Fmaster_wixel_track$RFTXRXIE$0$0 == 0x00a8
_RFTXRXIE	=	0x00a8
Fmaster_wixel_track$ADCIE$0$0 == 0x00a9
_ADCIE	=	0x00a9
Fmaster_wixel_track$URX0IE$0$0 == 0x00aa
_URX0IE	=	0x00aa
Fmaster_wixel_track$URX1IE$0$0 == 0x00ab
_URX1IE	=	0x00ab
Fmaster_wixel_track$ENCIE$0$0 == 0x00ac
_ENCIE	=	0x00ac
Fmaster_wixel_track$STIE$0$0 == 0x00ad
_STIE	=	0x00ad
Fmaster_wixel_track$_IEN06$0$0 == 0x00ae
__IEN06	=	0x00ae
Fmaster_wixel_track$EA$0$0 == 0x00af
_EA	=	0x00af
Fmaster_wixel_track$DMAIE$0$0 == 0x00b8
_DMAIE	=	0x00b8
Fmaster_wixel_track$T1IE$0$0 == 0x00b9
_T1IE	=	0x00b9
Fmaster_wixel_track$T2IE$0$0 == 0x00ba
_T2IE	=	0x00ba
Fmaster_wixel_track$T3IE$0$0 == 0x00bb
_T3IE	=	0x00bb
Fmaster_wixel_track$T4IE$0$0 == 0x00bc
_T4IE	=	0x00bc
Fmaster_wixel_track$P0IE$0$0 == 0x00bd
_P0IE	=	0x00bd
Fmaster_wixel_track$_IEN16$0$0 == 0x00be
__IEN16	=	0x00be
Fmaster_wixel_track$_IEN17$0$0 == 0x00bf
__IEN17	=	0x00bf
Fmaster_wixel_track$DMAIF$0$0 == 0x00c0
_DMAIF	=	0x00c0
Fmaster_wixel_track$T1IF$0$0 == 0x00c1
_T1IF	=	0x00c1
Fmaster_wixel_track$T2IF$0$0 == 0x00c2
_T2IF	=	0x00c2
Fmaster_wixel_track$T3IF$0$0 == 0x00c3
_T3IF	=	0x00c3
Fmaster_wixel_track$T4IF$0$0 == 0x00c4
_T4IF	=	0x00c4
Fmaster_wixel_track$P0IF$0$0 == 0x00c5
_P0IF	=	0x00c5
Fmaster_wixel_track$_IRCON6$0$0 == 0x00c6
__IRCON6	=	0x00c6
Fmaster_wixel_track$STIF$0$0 == 0x00c7
_STIF	=	0x00c7
Fmaster_wixel_track$P$0$0 == 0x00d0
_P	=	0x00d0
Fmaster_wixel_track$F1$0$0 == 0x00d1
_F1	=	0x00d1
Fmaster_wixel_track$OV$0$0 == 0x00d2
_OV	=	0x00d2
Fmaster_wixel_track$RS0$0$0 == 0x00d3
_RS0	=	0x00d3
Fmaster_wixel_track$RS1$0$0 == 0x00d4
_RS1	=	0x00d4
Fmaster_wixel_track$F0$0$0 == 0x00d5
_F0	=	0x00d5
Fmaster_wixel_track$AC$0$0 == 0x00d6
_AC	=	0x00d6
Fmaster_wixel_track$CY$0$0 == 0x00d7
_CY	=	0x00d7
Fmaster_wixel_track$T3OVFIF$0$0 == 0x00d8
_T3OVFIF	=	0x00d8
Fmaster_wixel_track$T3CH0IF$0$0 == 0x00d9
_T3CH0IF	=	0x00d9
Fmaster_wixel_track$T3CH1IF$0$0 == 0x00da
_T3CH1IF	=	0x00da
Fmaster_wixel_track$T4OVFIF$0$0 == 0x00db
_T4OVFIF	=	0x00db
Fmaster_wixel_track$T4CH0IF$0$0 == 0x00dc
_T4CH0IF	=	0x00dc
Fmaster_wixel_track$T4CH1IF$0$0 == 0x00dd
_T4CH1IF	=	0x00dd
Fmaster_wixel_track$OVFIM$0$0 == 0x00de
_OVFIM	=	0x00de
Fmaster_wixel_track$_TIMIF7$0$0 == 0x00df
__TIMIF7	=	0x00df
Fmaster_wixel_track$ACC_0$0$0 == 0x00e0
_ACC_0	=	0x00e0
Fmaster_wixel_track$ACC_1$0$0 == 0x00e1
_ACC_1	=	0x00e1
Fmaster_wixel_track$ACC_2$0$0 == 0x00e2
_ACC_2	=	0x00e2
Fmaster_wixel_track$ACC_3$0$0 == 0x00e3
_ACC_3	=	0x00e3
Fmaster_wixel_track$ACC_4$0$0 == 0x00e4
_ACC_4	=	0x00e4
Fmaster_wixel_track$ACC_5$0$0 == 0x00e5
_ACC_5	=	0x00e5
Fmaster_wixel_track$ACC_6$0$0 == 0x00e6
_ACC_6	=	0x00e6
Fmaster_wixel_track$ACC_7$0$0 == 0x00e7
_ACC_7	=	0x00e7
Fmaster_wixel_track$P2IF$0$0 == 0x00e8
_P2IF	=	0x00e8
Fmaster_wixel_track$UTX0IF$0$0 == 0x00e9
_UTX0IF	=	0x00e9
Fmaster_wixel_track$UTX1IF$0$0 == 0x00ea
_UTX1IF	=	0x00ea
Fmaster_wixel_track$P1IF$0$0 == 0x00eb
_P1IF	=	0x00eb
Fmaster_wixel_track$WDTIF$0$0 == 0x00ec
_WDTIF	=	0x00ec
Fmaster_wixel_track$_IRCON25$0$0 == 0x00ed
__IRCON25	=	0x00ed
Fmaster_wixel_track$_IRCON26$0$0 == 0x00ee
__IRCON26	=	0x00ee
Fmaster_wixel_track$_IRCON27$0$0 == 0x00ef
__IRCON27	=	0x00ef
Fmaster_wixel_track$B_0$0$0 == 0x00f0
_B_0	=	0x00f0
Fmaster_wixel_track$B_1$0$0 == 0x00f1
_B_1	=	0x00f1
Fmaster_wixel_track$B_2$0$0 == 0x00f2
_B_2	=	0x00f2
Fmaster_wixel_track$B_3$0$0 == 0x00f3
_B_3	=	0x00f3
Fmaster_wixel_track$B_4$0$0 == 0x00f4
_B_4	=	0x00f4
Fmaster_wixel_track$B_5$0$0 == 0x00f5
_B_5	=	0x00f5
Fmaster_wixel_track$B_6$0$0 == 0x00f6
_B_6	=	0x00f6
Fmaster_wixel_track$B_7$0$0 == 0x00f7
_B_7	=	0x00f7
Fmaster_wixel_track$U1ACTIVE$0$0 == 0x00f8
_U1ACTIVE	=	0x00f8
Fmaster_wixel_track$U1TX_BYTE$0$0 == 0x00f9
_U1TX_BYTE	=	0x00f9
Fmaster_wixel_track$U1RX_BYTE$0$0 == 0x00fa
_U1RX_BYTE	=	0x00fa
Fmaster_wixel_track$U1ERR$0$0 == 0x00fb
_U1ERR	=	0x00fb
Fmaster_wixel_track$U1FE$0$0 == 0x00fc
_U1FE	=	0x00fc
Fmaster_wixel_track$U1SLAVE$0$0 == 0x00fd
_U1SLAVE	=	0x00fd
Fmaster_wixel_track$U1RE$0$0 == 0x00fe
_U1RE	=	0x00fe
Fmaster_wixel_track$U1MODE$0$0 == 0x00ff
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
Lmaster_wixel_track.updateLeds$sloc0$1$0==.
_updateLeds_sloc0_1_0:
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
G$serialRxPulseActive$0$0==.
_serialRxPulseActive::
	.ds 1
G$radioTxPulseActive$0$0==.
_radioTxPulseActive::
	.ds 1
;--------------------------------------------------------
; paged external ram data
;--------------------------------------------------------
	.area PSEG    (PAG,XDATA)
G$serialBufferIndex$0$0==.
_serialBufferIndex::
	.ds 1
G$slaveAddresses$0$0==.
_slaveAddresses::
	.ds 4
G$lastSerialRxTime$0$0==.
_lastSerialRxTime::
	.ds 4
G$lastRadioTxTime$0$0==.
_lastRadioTxTime::
	.ds 4
G$lastHeartbeatTime$0$0==.
_lastHeartbeatTime::
	.ds 4
G$serialRxPulseStart$0$0==.
_serialRxPulseStart::
	.ds 2
G$radioTxPulseStart$0$0==.
_radioTxPulseStart::
	.ds 2
G$responseLength$0$0==.
_responseLength::
	.ds 1
G$fsi$0$0==.
_fsi::
	.ds 1
G$posX$0$0==.
_posX::
	.ds 2
G$posY$0$0==.
_posY::
	.ds 2
G$theta$0$0==.
_theta::
	.ds 1
Lmaster_wixel_track.processSerialPacket$data3$1$1==.
_processSerialPacket_data3_1_1:
	.ds 2
Lmaster_wixel_track.processSerialPacket$data4$1$1==.
_processSerialPacket_data4_1_1:
	.ds 2
Lmaster_wixel_track.processSerialPacket$posX$1$1==.
_processSerialPacket_posX_1_1:
	.ds 2
Lmaster_wixel_track.processSerialPacket$cmdStr$1$1==.
_processSerialPacket_cmdStr_1_1:
	.ds 16
;--------------------------------------------------------
; external ram data
;--------------------------------------------------------
	.area XSEG    (XDATA)
Fmaster_wixel_track$SYNC1$0$0 == 0xdf00
_SYNC1	=	0xdf00
Fmaster_wixel_track$SYNC0$0$0 == 0xdf01
_SYNC0	=	0xdf01
Fmaster_wixel_track$PKTLEN$0$0 == 0xdf02
_PKTLEN	=	0xdf02
Fmaster_wixel_track$PKTCTRL1$0$0 == 0xdf03
_PKTCTRL1	=	0xdf03
Fmaster_wixel_track$PKTCTRL0$0$0 == 0xdf04
_PKTCTRL0	=	0xdf04
Fmaster_wixel_track$ADDR$0$0 == 0xdf05
_ADDR	=	0xdf05
Fmaster_wixel_track$CHANNR$0$0 == 0xdf06
_CHANNR	=	0xdf06
Fmaster_wixel_track$FSCTRL1$0$0 == 0xdf07
_FSCTRL1	=	0xdf07
Fmaster_wixel_track$FSCTRL0$0$0 == 0xdf08
_FSCTRL0	=	0xdf08
Fmaster_wixel_track$FREQ2$0$0 == 0xdf09
_FREQ2	=	0xdf09
Fmaster_wixel_track$FREQ1$0$0 == 0xdf0a
_FREQ1	=	0xdf0a
Fmaster_wixel_track$FREQ0$0$0 == 0xdf0b
_FREQ0	=	0xdf0b
Fmaster_wixel_track$MDMCFG4$0$0 == 0xdf0c
_MDMCFG4	=	0xdf0c
Fmaster_wixel_track$MDMCFG3$0$0 == 0xdf0d
_MDMCFG3	=	0xdf0d
Fmaster_wixel_track$MDMCFG2$0$0 == 0xdf0e
_MDMCFG2	=	0xdf0e
Fmaster_wixel_track$MDMCFG1$0$0 == 0xdf0f
_MDMCFG1	=	0xdf0f
Fmaster_wixel_track$MDMCFG0$0$0 == 0xdf10
_MDMCFG0	=	0xdf10
Fmaster_wixel_track$DEVIATN$0$0 == 0xdf11
_DEVIATN	=	0xdf11
Fmaster_wixel_track$MCSM2$0$0 == 0xdf12
_MCSM2	=	0xdf12
Fmaster_wixel_track$MCSM1$0$0 == 0xdf13
_MCSM1	=	0xdf13
Fmaster_wixel_track$MCSM0$0$0 == 0xdf14
_MCSM0	=	0xdf14
Fmaster_wixel_track$FOCCFG$0$0 == 0xdf15
_FOCCFG	=	0xdf15
Fmaster_wixel_track$BSCFG$0$0 == 0xdf16
_BSCFG	=	0xdf16
Fmaster_wixel_track$AGCCTRL2$0$0 == 0xdf17
_AGCCTRL2	=	0xdf17
Fmaster_wixel_track$AGCCTRL1$0$0 == 0xdf18
_AGCCTRL1	=	0xdf18
Fmaster_wixel_track$AGCCTRL0$0$0 == 0xdf19
_AGCCTRL0	=	0xdf19
Fmaster_wixel_track$FREND1$0$0 == 0xdf1a
_FREND1	=	0xdf1a
Fmaster_wixel_track$FREND0$0$0 == 0xdf1b
_FREND0	=	0xdf1b
Fmaster_wixel_track$FSCAL3$0$0 == 0xdf1c
_FSCAL3	=	0xdf1c
Fmaster_wixel_track$FSCAL2$0$0 == 0xdf1d
_FSCAL2	=	0xdf1d
Fmaster_wixel_track$FSCAL1$0$0 == 0xdf1e
_FSCAL1	=	0xdf1e
Fmaster_wixel_track$FSCAL0$0$0 == 0xdf1f
_FSCAL0	=	0xdf1f
Fmaster_wixel_track$TEST2$0$0 == 0xdf23
_TEST2	=	0xdf23
Fmaster_wixel_track$TEST1$0$0 == 0xdf24
_TEST1	=	0xdf24
Fmaster_wixel_track$TEST0$0$0 == 0xdf25
_TEST0	=	0xdf25
Fmaster_wixel_track$PA_TABLE0$0$0 == 0xdf2e
_PA_TABLE0	=	0xdf2e
Fmaster_wixel_track$IOCFG2$0$0 == 0xdf2f
_IOCFG2	=	0xdf2f
Fmaster_wixel_track$IOCFG1$0$0 == 0xdf30
_IOCFG1	=	0xdf30
Fmaster_wixel_track$IOCFG0$0$0 == 0xdf31
_IOCFG0	=	0xdf31
Fmaster_wixel_track$PARTNUM$0$0 == 0xdf36
_PARTNUM	=	0xdf36
Fmaster_wixel_track$VERSION$0$0 == 0xdf37
_VERSION	=	0xdf37
Fmaster_wixel_track$FREQEST$0$0 == 0xdf38
_FREQEST	=	0xdf38
Fmaster_wixel_track$LQI$0$0 == 0xdf39
_LQI	=	0xdf39
Fmaster_wixel_track$RSSI$0$0 == 0xdf3a
_RSSI	=	0xdf3a
Fmaster_wixel_track$MARCSTATE$0$0 == 0xdf3b
_MARCSTATE	=	0xdf3b
Fmaster_wixel_track$PKTSTATUS$0$0 == 0xdf3c
_PKTSTATUS	=	0xdf3c
Fmaster_wixel_track$VCO_VC_DAC$0$0 == 0xdf3d
_VCO_VC_DAC	=	0xdf3d
Fmaster_wixel_track$I2SCFG0$0$0 == 0xdf40
_I2SCFG0	=	0xdf40
Fmaster_wixel_track$I2SCFG1$0$0 == 0xdf41
_I2SCFG1	=	0xdf41
Fmaster_wixel_track$I2SDATL$0$0 == 0xdf42
_I2SDATL	=	0xdf42
Fmaster_wixel_track$I2SDATH$0$0 == 0xdf43
_I2SDATH	=	0xdf43
Fmaster_wixel_track$I2SWCNT$0$0 == 0xdf44
_I2SWCNT	=	0xdf44
Fmaster_wixel_track$I2SSTAT$0$0 == 0xdf45
_I2SSTAT	=	0xdf45
Fmaster_wixel_track$I2SCLKF0$0$0 == 0xdf46
_I2SCLKF0	=	0xdf46
Fmaster_wixel_track$I2SCLKF1$0$0 == 0xdf47
_I2SCLKF1	=	0xdf47
Fmaster_wixel_track$I2SCLKF2$0$0 == 0xdf48
_I2SCLKF2	=	0xdf48
Fmaster_wixel_track$USBADDR$0$0 == 0xde00
_USBADDR	=	0xde00
Fmaster_wixel_track$USBPOW$0$0 == 0xde01
_USBPOW	=	0xde01
Fmaster_wixel_track$USBIIF$0$0 == 0xde02
_USBIIF	=	0xde02
Fmaster_wixel_track$USBOIF$0$0 == 0xde04
_USBOIF	=	0xde04
Fmaster_wixel_track$USBCIF$0$0 == 0xde06
_USBCIF	=	0xde06
Fmaster_wixel_track$USBIIE$0$0 == 0xde07
_USBIIE	=	0xde07
Fmaster_wixel_track$USBOIE$0$0 == 0xde09
_USBOIE	=	0xde09
Fmaster_wixel_track$USBCIE$0$0 == 0xde0b
_USBCIE	=	0xde0b
Fmaster_wixel_track$USBFRML$0$0 == 0xde0c
_USBFRML	=	0xde0c
Fmaster_wixel_track$USBFRMH$0$0 == 0xde0d
_USBFRMH	=	0xde0d
Fmaster_wixel_track$USBINDEX$0$0 == 0xde0e
_USBINDEX	=	0xde0e
Fmaster_wixel_track$USBMAXI$0$0 == 0xde10
_USBMAXI	=	0xde10
Fmaster_wixel_track$USBCSIL$0$0 == 0xde11
_USBCSIL	=	0xde11
Fmaster_wixel_track$USBCSIH$0$0 == 0xde12
_USBCSIH	=	0xde12
Fmaster_wixel_track$USBMAXO$0$0 == 0xde13
_USBMAXO	=	0xde13
Fmaster_wixel_track$USBCSOL$0$0 == 0xde14
_USBCSOL	=	0xde14
Fmaster_wixel_track$USBCSOH$0$0 == 0xde15
_USBCSOH	=	0xde15
Fmaster_wixel_track$USBCNTL$0$0 == 0xde16
_USBCNTL	=	0xde16
Fmaster_wixel_track$USBCNTH$0$0 == 0xde17
_USBCNTH	=	0xde17
Fmaster_wixel_track$USBF0$0$0 == 0xde20
_USBF0	=	0xde20
Fmaster_wixel_track$USBF1$0$0 == 0xde22
_USBF1	=	0xde22
Fmaster_wixel_track$USBF2$0$0 == 0xde24
_USBF2	=	0xde24
Fmaster_wixel_track$USBF3$0$0 == 0xde26
_USBF3	=	0xde26
Fmaster_wixel_track$USBF4$0$0 == 0xde28
_USBF4	=	0xde28
Fmaster_wixel_track$USBF5$0$0 == 0xde2a
_USBF5	=	0xde2a
Fmaster_wixel_track$txPacket$0$0==.
_txPacket:
	.ds 65
Fmaster_wixel_track$serialBuffer$0$0==.
_serialBuffer:
	.ds 100
Fmaster_wixel_track$serialResponse$0$0==.
_serialResponse:
	.ds 64
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
	C$master_wixel_track.c$74$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:74: BIT serialRxPulseActive = 0;
	clr	_serialRxPulseActive
	G$main$0$0 ==.
	C$master_wixel_track.c$76$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:76: BIT radioTxPulseActive = 0;
	clr	_radioTxPulseActive
	G$main$0$0 ==.
	C$master_wixel_track.c$60$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:60: uint8 serialBufferIndex = 0;
	mov	r0,#_serialBufferIndex
	clr	a
	movx	@r0,a
	G$main$0$0 ==.
	C$master_wixel_track.c$66$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:66: uint8 slaveAddresses[NUM_SLAVES] = {SLAVE_1_ADDRESS, SLAVE_2_ADDRESS, SLAVE_3_ADDRESS, SLAVE_4_ADDRESS};
	mov	r0,#_slaveAddresses
	mov	a,#0x01
	movx	@r0,a
	mov	r0,#(_slaveAddresses + 0x0001)
	mov	a,#0x02
	movx	@r0,a
	mov	r0,#(_slaveAddresses + 0x0002)
	mov	a,#0x03
	movx	@r0,a
	mov	r0,#(_slaveAddresses + 0x0003)
	mov	a,#0x04
	movx	@r0,a
	G$main$0$0 ==.
	C$master_wixel_track.c$69$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:69: uint32 lastSerialRxTime = 0;
	mov	r0,#_lastSerialRxTime
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	inc	r0
	movx	@r0,a
	inc	r0
	movx	@r0,a
	G$main$0$0 ==.
	C$master_wixel_track.c$70$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:70: uint32 lastRadioTxTime = 0;
	mov	r0,#_lastRadioTxTime
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	inc	r0
	movx	@r0,a
	inc	r0
	movx	@r0,a
	G$main$0$0 ==.
	C$master_wixel_track.c$71$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:71: uint32 lastHeartbeatTime = 0;
	mov	r0,#_lastHeartbeatTime
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	inc	r0
	movx	@r0,a
	inc	r0
	movx	@r0,a
	G$main$0$0 ==.
	C$master_wixel_track.c$75$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:75: uint16 serialRxPulseStart = 0;
	mov	r0,#_serialRxPulseStart
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	G$main$0$0 ==.
	C$master_wixel_track.c$77$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:77: uint16 radioTxPulseStart = 0;
	mov	r0,#_radioTxPulseStart
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	G$main$0$0 ==.
	C$master_wixel_track.c$85$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:85: int16 posX = 0;
	mov	r0,#_posX
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	G$main$0$0 ==.
	C$master_wixel_track.c$86$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:86: int16 posY = 0;
	mov	r0,#_posY
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	G$main$0$0 ==.
	C$master_wixel_track.c$87$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:87: int8 theta = 0;
	mov	r0,#_theta
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
;Allocation info for local variables in function 'failSafeBootloader'
;------------------------------------------------------------
	G$failSafeBootloader$0$0 ==.
	C$master_wixel_track.c$90$0$0 ==.
;	apps/master_wixel_track/master_wixel_track.c:90: void failSafeBootloader()
;	-----------------------------------------
;	 function failSafeBootloader
;	-----------------------------------------
_failSafeBootloader:
	ar7 = 0x07
	ar6 = 0x06
	ar5 = 0x05
	ar4 = 0x04
	ar3 = 0x03
	ar2 = 0x02
	ar1 = 0x01
	ar0 = 0x00
	C$master_wixel_track.c$92$2$2 ==.
;	apps/master_wixel_track/master_wixel_track.c:92: LED_YELLOW(0);
	mov	r7,_P2DIR
	anl	ar7,#0xFB
	mov	_P2DIR,r7
	C$master_wixel_track.c$93$2$3 ==.
;	apps/master_wixel_track/master_wixel_track.c:93: LED_YELLOW_TOGGLE();
	xrl	_P2DIR,#0x04
	C$master_wixel_track.c$94$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:94: delayMs(200);
	mov	dptr,#0x00C8
	lcall	_delayMs
	C$master_wixel_track.c$96$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:96: for(fsi = 0; fsi < 20; fsi++)
	mov	r0,#_fsi
	clr	a
	movx	@r0,a
00101$:
	mov	r0,#_fsi
	movx	a,@r0
	cjne	a,#0x14,00109$
00109$:
	jnc	00104$
	C$master_wixel_track.c$98$3$5 ==.
;	apps/master_wixel_track/master_wixel_track.c:98: LED_YELLOW_TOGGLE();
	xrl	_P2DIR,#0x04
	C$master_wixel_track.c$99$2$4 ==.
;	apps/master_wixel_track/master_wixel_track.c:99: boardService();
	lcall	_boardService
	C$master_wixel_track.c$100$2$4 ==.
;	apps/master_wixel_track/master_wixel_track.c:100: delayMs(100);
	mov	dptr,#0x0064
	lcall	_delayMs
	C$master_wixel_track.c$96$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:96: for(fsi = 0; fsi < 20; fsi++)
	mov	r0,#_fsi
	movx	a,@r0
	add	a,#0x01
	movx	@r0,a
	sjmp	00101$
00104$:
	C$master_wixel_track.c$103$2$6 ==.
;	apps/master_wixel_track/master_wixel_track.c:103: LED_YELLOW(0);
	mov	r7,_P2DIR
	anl	ar7,#0xFB
	mov	_P2DIR,r7
	C$master_wixel_track.c$104$2$6 ==.
	XG$failSafeBootloader$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'radioInit'
;------------------------------------------------------------
	G$radioInit$0$0 ==.
	C$master_wixel_track.c$106$2$6 ==.
;	apps/master_wixel_track/master_wixel_track.c:106: void radioInit()
;	-----------------------------------------
;	 function radioInit
;	-----------------------------------------
_radioInit:
	C$master_wixel_track.c$108$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:108: radioRegistersInit();
	lcall	_radioRegistersInit
	C$master_wixel_track.c$110$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:110: CHANNR = 128;
	mov	dptr,#_CHANNR
	mov	a,#0x80
	movx	@dptr,a
	C$master_wixel_track.c$111$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:111: PKTLEN = RADIO_PACKET_SIZE;     // HARDCODED: 64 bytes for 4 slaves
	mov	dptr,#_PKTLEN
	mov	a,#0x40
	movx	@dptr,a
	C$master_wixel_track.c$113$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:113: MCSM0 = 0x14;
	mov	dptr,#_MCSM0
	mov	a,#0x14
	movx	@dptr,a
	C$master_wixel_track.c$114$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:114: MCSM1 = 0x00;
	mov	dptr,#_MCSM1
	clr	a
	movx	@dptr,a
	C$master_wixel_track.c$115$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:115: IOCFG2 = 0b011011;
	mov	dptr,#_IOCFG2
	mov	a,#0x1B
	movx	@dptr,a
	C$master_wixel_track.c$118$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:118: dmaConfig.radio.DC6 = 19;
	mov	dptr,#(_dmaConfig + 0x0006)
	mov	a,#0x13
	movx	@dptr,a
	C$master_wixel_track.c$119$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:119: dmaConfig.radio.SRCADDRH = (unsigned int)txPacket >> 8;
	mov	r6,#_txPacket
	mov	r7,#(_txPacket >> 8)
	mov	ar6,r7
	mov	dptr,#_dmaConfig
	mov	a,r6
	movx	@dptr,a
	C$master_wixel_track.c$120$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:120: dmaConfig.radio.SRCADDRL = (unsigned int)txPacket;
	mov	r6,#_txPacket
	mov	r7,#(_txPacket >> 8)
	mov	dptr,#(_dmaConfig + 0x0001)
	mov	a,r6
	movx	@dptr,a
	C$master_wixel_track.c$121$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:121: dmaConfig.radio.DESTADDRH = XDATA_SFR_ADDRESS(RFD) >> 8;
	mov	r6,#_RFD
	mov	r7,#0x00
	mov	a,#0xDF
	add	a,r7
	mov	r6,a
	mov	dptr,#(_dmaConfig + 0x0002)
	mov	a,r6
	movx	@dptr,a
	C$master_wixel_track.c$122$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:122: dmaConfig.radio.DESTADDRL = XDATA_SFR_ADDRESS(RFD);
	mov	r6,#_RFD
	mov	dptr,#(_dmaConfig + 0x0003)
	mov	a,r6
	movx	@dptr,a
	C$master_wixel_track.c$123$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:123: dmaConfig.radio.LENL = 1 + RADIO_PACKET_SIZE;
	mov	dptr,#(_dmaConfig + 0x0005)
	mov	a,#0x41
	movx	@dptr,a
	C$master_wixel_track.c$124$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:124: dmaConfig.radio.VLEN_LENH = 0b00100000;
	mov	dptr,#(_dmaConfig + 0x0004)
	mov	a,#0x20
	movx	@dptr,a
	C$master_wixel_track.c$125$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:125: dmaConfig.radio.DC7 = 0x40;
	mov	dptr,#(_dmaConfig + 0x0007)
	mov	a,#0x40
	movx	@dptr,a
	C$master_wixel_track.c$127$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:127: txPacket[0] = RADIO_PACKET_SIZE;
	mov	dptr,#_txPacket
	mov	a,#0x40
	movx	@dptr,a
	C$master_wixel_track.c$129$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:129: RFST = 4;
	mov	_RFST,#0x04
	C$master_wixel_track.c$130$1$1 ==.
	XG$radioInit$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'sendRadioPacket'
;------------------------------------------------------------
	G$sendRadioPacket$0$0 ==.
	C$master_wixel_track.c$134$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:134: void sendRadioPacket()
;	-----------------------------------------
;	 function sendRadioPacket
;	-----------------------------------------
_sendRadioPacket:
	C$master_wixel_track.c$136$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:136: if (MARCSTATE == 1)
	mov	dptr,#_MARCSTATE
	movx	a,@dptr
	mov	r7,a
	cjne	r7,#0x01,00103$
	C$master_wixel_track.c$138$2$2 ==.
;	apps/master_wixel_track/master_wixel_track.c:138: RFIF &= ~(1<<4);
	mov	r7,_RFIF
	anl	ar7,#0xEF
	mov	_RFIF,r7
	C$master_wixel_track.c$139$2$2 ==.
;	apps/master_wixel_track/master_wixel_track.c:139: DMAARM |= (1<<DMA_CHANNEL_RADIO);
	orl	_DMAARM,#0x02
	C$master_wixel_track.c$140$2$2 ==.
;	apps/master_wixel_track/master_wixel_track.c:140: RFST = 3;
	mov	_RFST,#0x03
	C$master_wixel_track.c$142$2$2 ==.
;	apps/master_wixel_track/master_wixel_track.c:142: radioTxPulseActive = 1;
	setb	_radioTxPulseActive
	C$master_wixel_track.c$143$2$2 ==.
;	apps/master_wixel_track/master_wixel_track.c:143: radioTxPulseStart = (uint16)getMs();
	lcall	_getMs
	mov	r4,dpl
	mov	r5,dph
	mov	r0,#_radioTxPulseStart
	mov	a,r4
	movx	@r0,a
	inc	r0
	mov	a,r5
	movx	@r0,a
	C$master_wixel_track.c$145$2$2 ==.
;	apps/master_wixel_track/master_wixel_track.c:145: lastRadioTxTime = getMs();
	lcall	_getMs
	mov	r4,dpl
	mov	r5,dph
	mov	r6,b
	mov	r7,a
	mov	r0,#_lastRadioTxTime
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
00103$:
	C$master_wixel_track.c$147$2$1 ==.
	XG$sendRadioPacket$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'updateLeds'
;------------------------------------------------------------
;sloc0                     Allocated with name '_updateLeds_sloc0_1_0'
;------------------------------------------------------------
	G$updateLeds$0$0 ==.
	C$master_wixel_track.c$151$2$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:151: void updateLeds()
;	-----------------------------------------
;	 function updateLeds
;	-----------------------------------------
_updateLeds:
	C$master_wixel_track.c$153$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:153: uint16 now = (uint16)getMs();
	lcall	_getMs
	mov	r4,dpl
	mov	r5,dph
	mov	r6,b
	mov	r7,a
	C$master_wixel_track.c$156$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:156: if (serialRxPulseActive)
	jnb	_serialRxPulseActive,00105$
	C$master_wixel_track.c$158$2$2 ==.
;	apps/master_wixel_track/master_wixel_track.c:158: if ((uint16)(now - serialRxPulseStart) < SERIAL_RX_PULSE)
	mov	r0,#_serialRxPulseStart
	setb	c
	movx	a,@r0
	subb	a,r4
	cpl	a
	cpl	c
	mov	r6,a
	cpl	c
	inc	r0
	movx	a,@r0
	subb	a,r5
	cpl	a
	mov	r7,a
	clr	c
	mov	a,r6
	subb	a,#0x64
	mov	a,r7
	subb	a,#0x00
	jnc	00102$
	C$master_wixel_track.c$160$4$4 ==.
;	apps/master_wixel_track/master_wixel_track.c:160: LED_RED(1);
	orl	_P2DIR,#0x02
	sjmp	00106$
00102$:
	C$master_wixel_track.c$164$4$6 ==.
;	apps/master_wixel_track/master_wixel_track.c:164: LED_RED(0);
	mov	r7,_P2DIR
	anl	ar7,#0xFD
	mov	_P2DIR,r7
	C$master_wixel_track.c$165$3$5 ==.
;	apps/master_wixel_track/master_wixel_track.c:165: serialRxPulseActive = 0;
	clr	_serialRxPulseActive
	sjmp	00106$
00105$:
	C$master_wixel_track.c$170$3$8 ==.
;	apps/master_wixel_track/master_wixel_track.c:170: LED_RED(0);
	mov	r7,_P2DIR
	anl	ar7,#0xFD
	mov	_P2DIR,r7
00106$:
	C$master_wixel_track.c$174$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:174: if (radioTxPulseActive)
	jnb	_radioTxPulseActive,00111$
	C$master_wixel_track.c$176$2$9 ==.
;	apps/master_wixel_track/master_wixel_track.c:176: if ((uint16)(now - radioTxPulseStart) < RADIO_TX_PULSE)
	mov	r0,#_radioTxPulseStart
	setb	c
	movx	a,@r0
	subb	a,r4
	cpl	a
	cpl	c
	mov	r6,a
	cpl	c
	inc	r0
	movx	a,@r0
	subb	a,r5
	cpl	a
	mov	r7,a
	clr	c
	mov	a,r6
	subb	a,#0x64
	mov	a,r7
	subb	a,#0x00
	jnc	00108$
	C$master_wixel_track.c$178$4$11 ==.
;	apps/master_wixel_track/master_wixel_track.c:178: LED_GREEN(1);
	orl	_P2DIR,#0x10
	sjmp	00112$
00108$:
	C$master_wixel_track.c$182$4$13 ==.
;	apps/master_wixel_track/master_wixel_track.c:182: LED_GREEN(0);
	mov	r7,_P2DIR
	anl	ar7,#0xEF
	mov	_P2DIR,r7
	C$master_wixel_track.c$183$3$12 ==.
;	apps/master_wixel_track/master_wixel_track.c:183: radioTxPulseActive = 0;
	clr	_radioTxPulseActive
	sjmp	00112$
00111$:
	C$master_wixel_track.c$188$3$15 ==.
;	apps/master_wixel_track/master_wixel_track.c:188: LED_GREEN(0);
	mov	r7,_P2DIR
	anl	ar7,#0xEF
	mov	_P2DIR,r7
00112$:
	C$master_wixel_track.c$192$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:192: if ((uint16)(now - lastHeartbeatTime) >= HEARTBEAT_PERIOD)
	mov	_updateLeds_sloc0_1_0,r4
	mov	(_updateLeds_sloc0_1_0 + 1),r5
	mov	(_updateLeds_sloc0_1_0 + 2),#0x00
	mov	(_updateLeds_sloc0_1_0 + 3),#0x00
	mov	r0,#_lastHeartbeatTime
	setb	c
	movx	a,@r0
	subb	a,_updateLeds_sloc0_1_0
	cpl	a
	cpl	c
	mov	r2,a
	cpl	c
	inc	r0
	movx	a,@r0
	subb	a,(_updateLeds_sloc0_1_0 + 1)
	cpl	a
	cpl	c
	mov	r3,a
	cpl	c
	inc	r0
	movx	a,@r0
	subb	a,(_updateLeds_sloc0_1_0 + 2)
	cpl	a
	cpl	c
	mov	r6,a
	cpl	c
	inc	r0
	movx	a,@r0
	subb	a,(_updateLeds_sloc0_1_0 + 3)
	cpl	a
	mov	r7,a
	clr	c
	mov	a,r2
	subb	a,#0xF4
	mov	a,r3
	subb	a,#0x01
	jc	00115$
	C$master_wixel_track.c$194$3$17 ==.
;	apps/master_wixel_track/master_wixel_track.c:194: LED_YELLOW_TOGGLE();
	xrl	_P2DIR,#0x04
	C$master_wixel_track.c$195$2$16 ==.
;	apps/master_wixel_track/master_wixel_track.c:195: lastHeartbeatTime = now;
	mov	r0,#_lastHeartbeatTime
	mov	a,_updateLeds_sloc0_1_0
	movx	@r0,a
	inc	r0
	mov	a,(_updateLeds_sloc0_1_0 + 1)
	movx	@r0,a
	inc	r0
	mov	a,(_updateLeds_sloc0_1_0 + 2)
	movx	@r0,a
	inc	r0
	mov	a,(_updateLeds_sloc0_1_0 + 3)
	movx	@r0,a
00115$:
	C$master_wixel_track.c$197$2$1 ==.
	XG$updateLeds$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'processSerialPacket'
;------------------------------------------------------------
	G$processSerialPacket$0$0 ==.
	C$master_wixel_track.c$200$2$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:200: void processSerialPacket()
;	-----------------------------------------
;	 function processSerialPacket
;	-----------------------------------------
_processSerialPacket:
	C$master_wixel_track.c$215$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:215: responseLength = 0;
	mov	r0,#_responseLength
	clr	a
	movx	@r0,a
	C$master_wixel_track.c$218$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:218: if (serialBufferIndex != RADIO_PACKET_SIZE)
	mov	r0,#_serialBufferIndex
	movx	a,@r0
	cjne	a,#0x40,00139$
	sjmp	00102$
00139$:
	C$master_wixel_track.c$220$2$2 ==.
;	apps/master_wixel_track/master_wixel_track.c:220: responseLength = sprintf((char*)serialResponse, "ERROR: Expected 64 bytes, got %d\r\n", serialBufferIndex);
	mov	r0,#_serialBufferIndex
	movx	a,@r0
	mov	r6,a
	mov	r7,#0x00
	push	ar6
	push	ar7
	mov	a,#__str_0
	push	acc
	mov	a,#(__str_0 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	mov	a,#_serialResponse
	push	acc
	mov	a,#(_serialResponse >> 8)
	push	acc
	clr	a
	push	acc
	lcall	_sprintf
	mov	r6,dpl
	mov	a,sp
	add	a,#0xf8
	mov	sp,a
	mov	r0,#_responseLength
	mov	a,r6
	movx	@r0,a
	C$master_wixel_track.c$221$2$2 ==.
;	apps/master_wixel_track/master_wixel_track.c:221: usbComTxSend(serialResponse, responseLength);
	mov	r0,#_usbComTxSend_PARM_2
	mov	a,r6
	movx	@r0,a
	mov	dptr,#_serialResponse
	lcall	_usbComTxSend
	C$master_wixel_track.c$222$2$2 ==.
;	apps/master_wixel_track/master_wixel_track.c:222: return;
	ljmp	00124$
00102$:
	C$master_wixel_track.c$226$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:226: for (slaveIndex = 0; slaveIndex < NUM_SLAVES; slaveIndex++)
	mov	r7,#0x00
	mov	r6,#0x00
00116$:
	cjne	r6,#0x04,00140$
00140$:
	jnc	00119$
	C$master_wixel_track.c$228$2$3 ==.
;	apps/master_wixel_track/master_wixel_track.c:228: uint8 serialOffset = slaveIndex * BYTES_PER_SLAVE;
	mov	a,r6
	swap	a
	anl	a,#0xF0
	C$master_wixel_track.c$230$2$3 ==.
;	apps/master_wixel_track/master_wixel_track.c:230: if (serialBuffer[serialOffset + BYTES_PER_SLAVE - 1] != MESSAGE_DELIMITER)
	add	a,#0x0F
	add	a,#_serialBuffer
	mov	dpl,a
	clr	a
	addc	a,#(_serialBuffer >> 8)
	mov	dph,a
	movx	a,@dptr
	mov	r5,a
	cjne	r5,#0xFF,00142$
	sjmp	00118$
00142$:
	C$master_wixel_track.c$232$3$4 ==.
;	apps/master_wixel_track/master_wixel_track.c:232: responseLength = sprintf((char*)serialResponse, "ERROR: Invalid delimiter for slave %d\r\n", slaveIndex + 1);
	mov	ar4,r7
	mov	r5,#0x00
	inc	r4
	cjne	r4,#0x00,00143$
	inc	r5
00143$:
	push	ar4
	push	ar5
	mov	a,#__str_1
	push	acc
	mov	a,#(__str_1 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	mov	a,#_serialResponse
	push	acc
	mov	a,#(_serialResponse >> 8)
	push	acc
	clr	a
	push	acc
	lcall	_sprintf
	mov	r4,dpl
	mov	a,sp
	add	a,#0xf8
	mov	sp,a
	mov	r0,#_responseLength
	mov	a,r4
	movx	@r0,a
	C$master_wixel_track.c$233$3$4 ==.
;	apps/master_wixel_track/master_wixel_track.c:233: usbComTxSend(serialResponse, responseLength);
	mov	r0,#_usbComTxSend_PARM_2
	mov	a,r4
	movx	@r0,a
	mov	dptr,#_serialResponse
	lcall	_usbComTxSend
	C$master_wixel_track.c$234$3$4 ==.
;	apps/master_wixel_track/master_wixel_track.c:234: return;
	ljmp	00124$
00118$:
	C$master_wixel_track.c$226$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:226: for (slaveIndex = 0; slaveIndex < NUM_SLAVES; slaveIndex++)
	inc	r6
	mov	ar7,r6
	sjmp	00116$
00119$:
	C$master_wixel_track.c$239$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:239: for (i = 0; i < RADIO_PACKET_SIZE; i++)
	mov	r7,#0x00
00120$:
	cjne	r7,#0x40,00144$
00144$:
	jnc	00123$
	C$master_wixel_track.c$241$2$5 ==.
;	apps/master_wixel_track/master_wixel_track.c:241: txPacket[1 + i] = serialBuffer[i];
	mov	a,r7
	inc	a
	mov	r6,a
	add	a,#_txPacket
	mov	r4,a
	clr	a
	addc	a,#(_txPacket >> 8)
	mov	r5,a
	mov	a,r7
	add	a,#_serialBuffer
	mov	dpl,a
	clr	a
	addc	a,#(_serialBuffer >> 8)
	mov	dph,a
	movx	a,@dptr
	mov	r3,a
	mov	dpl,r4
	mov	dph,r5
	movx	@dptr,a
	C$master_wixel_track.c$239$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:239: for (i = 0; i < RADIO_PACKET_SIZE; i++)
	mov	ar7,r6
	sjmp	00120$
00123$:
	C$master_wixel_track.c$245$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:245: sendRadioPacket();
	lcall	_sendRadioPacket
	C$master_wixel_track.c$248$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:248: serialRxPulseActive = 1;
	setb	_serialRxPulseActive
	C$master_wixel_track.c$249$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:249: serialRxPulseStart = (uint16)getMs();
	lcall	_getMs
	mov	r4,dpl
	mov	r5,dph
	mov	r0,#_serialRxPulseStart
	mov	a,r4
	movx	@r0,a
	inc	r0
	mov	a,r5
	movx	@r0,a
	C$master_wixel_track.c$251$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:251: lastSerialRxTime = getMs();
	lcall	_getMs
	mov	r4,dpl
	mov	r5,dph
	mov	r6,b
	mov	r7,a
	mov	r0,#_lastSerialRxTime
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
	C$master_wixel_track.c$256$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:256: posX = (int16)((serialBuffer[1] << 8) | serialBuffer[2]);
	mov	dptr,#(_serialBuffer + 0x0001)
	movx	a,@dptr
	mov	r6,a
	mov	r7,#0x00
	mov	dptr,#(_serialBuffer + 0x0002)
	movx	a,@dptr
	mov	r5,a
	mov	r4,#0x00
	mov	r0,#_processSerialPacket_posX_1_1
	mov	a,r5
	orl	a,r7
	movx	@r0,a
	mov	a,r4
	orl	a,r6
	inc	r0
	movx	@r0,a
	C$master_wixel_track.c$257$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:257: posY = (int16)((serialBuffer[3] << 8) | serialBuffer[4]);
	mov	dptr,#(_serialBuffer + 0x0003)
	movx	a,@dptr
	mov	r4,a
	mov	r5,#0x00
	mov	dptr,#(_serialBuffer + 0x0004)
	movx	a,@dptr
	mov	r2,#0x00
	orl	ar5,a
	mov	a,r2
	orl	ar4,a
	C$master_wixel_track.c$258$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:258: theta = (int8)(serialBuffer[5]);
	mov	dptr,#(_serialBuffer + 0x0005)
	movx	a,@dptr
	mov	r3,a
	mov	r0,#_theta
	movx	@r0,a
	C$master_wixel_track.c$261$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:261: if (serialBuffer[6] != CMD_AUX)
	mov	dptr,#(_serialBuffer + 0x0006)
	movx	a,@dptr
	mov	r2,a
	cjne	r2,#0x14,00146$
	ljmp	00114$
00146$:
	C$master_wixel_track.c$263$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:263: cmd = serialBuffer[6];
	push	ar5
	push	ar4
	C$master_wixel_track.c$264$2$6 ==.
;	apps/master_wixel_track/master_wixel_track.c:264: data3 = (int16)((serialBuffer[7] << 8) | serialBuffer[8]);
	mov	dptr,#(_serialBuffer + 0x0007)
	movx	a,@dptr
	mov	r4,a
	mov	r5,#0x00
	mov	dptr,#(_serialBuffer + 0x0008)
	movx	a,@dptr
	mov	r7,a
	mov	r6,#0x00
	mov	r0,#_processSerialPacket_data3_1_1
	mov	a,r7
	orl	a,r5
	movx	@r0,a
	mov	a,r6
	orl	a,r4
	inc	r0
	movx	@r0,a
	C$master_wixel_track.c$265$2$6 ==.
;	apps/master_wixel_track/master_wixel_track.c:265: data4 = (int16)((serialBuffer[9] << 8) | serialBuffer[10]);
	mov	dptr,#(_serialBuffer + 0x0009)
	movx	a,@dptr
	mov	r6,a
	mov	r7,#0x00
	mov	dptr,#(_serialBuffer + 0x000a)
	movx	a,@dptr
	mov	r5,a
	mov	r4,#0x00
	mov	r0,#_processSerialPacket_data4_1_1
	mov	a,r5
	orl	a,r7
	movx	@r0,a
	mov	a,r4
	orl	a,r6
	inc	r0
	movx	@r0,a
	C$master_wixel_track.c$268$2$6 ==.
;	apps/master_wixel_track/master_wixel_track.c:268: switch(cmd)
	cjne	r2,#0x10,00147$
	pop	ar4
	pop	ar5
	sjmp	00105$
00147$:
	pop	ar4
	pop	ar5
	cjne	r2,#0x11,00148$
	sjmp	00106$
00148$:
	cjne	r2,#0x12,00149$
	sjmp	00107$
00149$:
	cjne	r2,#0x13,00150$
	ljmp	00108$
00150$:
	cjne	r2,#0x14,00151$
	ljmp	00109$
00151$:
	cjne	r2,#0x15,00152$
	ljmp	00110$
00152$:
	ljmp	00111$
	C$master_wixel_track.c$270$3$7 ==.
;	apps/master_wixel_track/master_wixel_track.c:270: case CMD_STOP:
00105$:
	C$master_wixel_track.c$271$3$7 ==.
;	apps/master_wixel_track/master_wixel_track.c:271: sprintf(cmdStr, "STOP");
	push	ar5
	push	ar4
	mov	a,#__str_2
	push	acc
	mov	a,#(__str_2 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	mov	a,#_processSerialPacket_cmdStr_1_1
	push	acc
	mov	a,#(_processSerialPacket_cmdStr_1_1 >> 8)
	push	acc
	mov	a,#0x60
	push	acc
	lcall	_sprintf
	mov	a,sp
	add	a,#0xfa
	mov	sp,a
	pop	ar4
	pop	ar5
	C$master_wixel_track.c$272$3$7 ==.
;	apps/master_wixel_track/master_wixel_track.c:272: break;
	ljmp	00112$
	C$master_wixel_track.c$273$3$7 ==.
;	apps/master_wixel_track/master_wixel_track.c:273: case CMD_GO_TO:
00106$:
	C$master_wixel_track.c$274$3$7 ==.
;	apps/master_wixel_track/master_wixel_track.c:274: sprintf(cmdStr, "GO_TO");
	push	ar5
	push	ar4
	mov	a,#__str_3
	push	acc
	mov	a,#(__str_3 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	mov	a,#_processSerialPacket_cmdStr_1_1
	push	acc
	mov	a,#(_processSerialPacket_cmdStr_1_1 >> 8)
	push	acc
	mov	a,#0x60
	push	acc
	lcall	_sprintf
	mov	a,sp
	add	a,#0xfa
	mov	sp,a
	pop	ar4
	pop	ar5
	C$master_wixel_track.c$275$3$7 ==.
;	apps/master_wixel_track/master_wixel_track.c:275: break;
	ljmp	00112$
	C$master_wixel_track.c$276$3$7 ==.
;	apps/master_wixel_track/master_wixel_track.c:276: case CMD_PREP:
00107$:
	C$master_wixel_track.c$277$3$7 ==.
;	apps/master_wixel_track/master_wixel_track.c:277: sprintf(cmdStr, "PREP");
	push	ar5
	push	ar4
	mov	a,#__str_4
	push	acc
	mov	a,#(__str_4 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	mov	a,#_processSerialPacket_cmdStr_1_1
	push	acc
	mov	a,#(_processSerialPacket_cmdStr_1_1 >> 8)
	push	acc
	mov	a,#0x60
	push	acc
	lcall	_sprintf
	mov	a,sp
	add	a,#0xfa
	mov	sp,a
	pop	ar4
	pop	ar5
	C$master_wixel_track.c$278$3$7 ==.
;	apps/master_wixel_track/master_wixel_track.c:278: break;
	ljmp	00112$
	C$master_wixel_track.c$279$3$7 ==.
;	apps/master_wixel_track/master_wixel_track.c:279: case CMD_RUN:
00108$:
	C$master_wixel_track.c$280$3$7 ==.
;	apps/master_wixel_track/master_wixel_track.c:280: sprintf(cmdStr, "RUN");
	push	ar5
	push	ar4
	mov	a,#__str_5
	push	acc
	mov	a,#(__str_5 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	mov	a,#_processSerialPacket_cmdStr_1_1
	push	acc
	mov	a,#(_processSerialPacket_cmdStr_1_1 >> 8)
	push	acc
	mov	a,#0x60
	push	acc
	lcall	_sprintf
	mov	a,sp
	add	a,#0xfa
	mov	sp,a
	pop	ar4
	pop	ar5
	C$master_wixel_track.c$281$3$7 ==.
;	apps/master_wixel_track/master_wixel_track.c:281: break;
	ljmp	00112$
	C$master_wixel_track.c$282$3$7 ==.
;	apps/master_wixel_track/master_wixel_track.c:282: case CMD_AUX:
00109$:
	C$master_wixel_track.c$283$3$7 ==.
;	apps/master_wixel_track/master_wixel_track.c:283: sprintf(cmdStr, "AUX");
	push	ar5
	push	ar4
	mov	a,#__str_6
	push	acc
	mov	a,#(__str_6 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	mov	a,#_processSerialPacket_cmdStr_1_1
	push	acc
	mov	a,#(_processSerialPacket_cmdStr_1_1 >> 8)
	push	acc
	mov	a,#0x60
	push	acc
	lcall	_sprintf
	mov	a,sp
	add	a,#0xfa
	mov	sp,a
	pop	ar4
	pop	ar5
	C$master_wixel_track.c$284$3$7 ==.
;	apps/master_wixel_track/master_wixel_track.c:284: break;
	C$master_wixel_track.c$285$3$7 ==.
;	apps/master_wixel_track/master_wixel_track.c:285: case CMD_CALIBRATE:
	sjmp	00112$
00110$:
	C$master_wixel_track.c$286$3$7 ==.
;	apps/master_wixel_track/master_wixel_track.c:286: sprintf(cmdStr, "CALIBRATE");
	push	ar5
	push	ar4
	mov	a,#__str_7
	push	acc
	mov	a,#(__str_7 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	mov	a,#_processSerialPacket_cmdStr_1_1
	push	acc
	mov	a,#(_processSerialPacket_cmdStr_1_1 >> 8)
	push	acc
	mov	a,#0x60
	push	acc
	lcall	_sprintf
	mov	a,sp
	add	a,#0xfa
	mov	sp,a
	pop	ar4
	pop	ar5
	C$master_wixel_track.c$287$3$7 ==.
;	apps/master_wixel_track/master_wixel_track.c:287: break;
	C$master_wixel_track.c$288$3$7 ==.
;	apps/master_wixel_track/master_wixel_track.c:288: default:
	sjmp	00112$
00111$:
	C$master_wixel_track.c$289$3$7 ==.
;	apps/master_wixel_track/master_wixel_track.c:289: sprintf(cmdStr, "UNKNOWN");
	push	ar5
	push	ar4
	mov	a,#__str_8
	push	acc
	mov	a,#(__str_8 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	mov	a,#_processSerialPacket_cmdStr_1_1
	push	acc
	mov	a,#(_processSerialPacket_cmdStr_1_1 >> 8)
	push	acc
	mov	a,#0x60
	push	acc
	lcall	_sprintf
	mov	a,sp
	add	a,#0xfa
	mov	sp,a
	pop	ar4
	pop	ar5
	C$master_wixel_track.c$290$2$6 ==.
;	apps/master_wixel_track/master_wixel_track.c:290: }
00112$:
	C$master_wixel_track.c$298$2$6 ==.
;	apps/master_wixel_track/master_wixel_track.c:298: cmdStr,
	C$master_wixel_track.c$297$2$6 ==.
;	apps/master_wixel_track/master_wixel_track.c:297: theta,
	mov	r0,#_theta
	movx	a,@r0
	mov	r6,a
	movx	a,@r0
	rlc	a
	subb	a,acc
	mov	r7,a
	C$master_wixel_track.c$294$2$6 ==.
;	apps/master_wixel_track/master_wixel_track.c:294: "Slave 1 Pos: (%d, %d, %d) CMD %s %d, %d, etc\r\n",
	C$master_wixel_track.c$293$2$6 ==.
;	apps/master_wixel_track/master_wixel_track.c:293: responseLength = sprintf((char*)serialResponse, 
	mov	r0,#_processSerialPacket_data4_1_1
	movx	a,@r0
	push	acc
	inc	r0
	movx	a,@r0
	push	acc
	mov	r0,#_processSerialPacket_data3_1_1
	movx	a,@r0
	push	acc
	inc	r0
	movx	a,@r0
	push	acc
	mov	a,#_processSerialPacket_cmdStr_1_1
	push	acc
	mov	a,#(_processSerialPacket_cmdStr_1_1 >> 8)
	push	acc
	mov	a,#0x60
	push	acc
	push	ar6
	push	ar7
	push	ar5
	push	ar4
	mov	r0,#_processSerialPacket_posX_1_1
	movx	a,@r0
	push	acc
	inc	r0
	movx	a,@r0
	push	acc
	mov	a,#__str_9
	push	acc
	mov	a,#(__str_9 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	mov	a,#_serialResponse
	push	acc
	mov	a,#(_serialResponse >> 8)
	push	acc
	clr	a
	push	acc
	lcall	_sprintf
	mov	r6,dpl
	mov	a,sp
	add	a,#0xed
	mov	sp,a
	mov	r0,#_responseLength
	mov	a,r6
	movx	@r0,a
	C$master_wixel_track.c$300$2$6 ==.
;	apps/master_wixel_track/master_wixel_track.c:300: usbComTxSend(serialResponse, responseLength);
	mov	r0,#_usbComTxSend_PARM_2
	mov	a,r6
	movx	@r0,a
	mov	dptr,#_serialResponse
	lcall	_usbComTxSend
	sjmp	00124$
00114$:
	C$master_wixel_track.c$311$2$8 ==.
;	apps/master_wixel_track/master_wixel_track.c:311: theta);
	mov	a,r3
	rlc	a
	subb	a,acc
	mov	r7,a
	C$master_wixel_track.c$308$2$8 ==.
;	apps/master_wixel_track/master_wixel_track.c:308: "AUX: Slave 1 Pos: (%d, %d, %d)\r\n",
	C$master_wixel_track.c$307$2$8 ==.
;	apps/master_wixel_track/master_wixel_track.c:307: responseLength = sprintf((char*)serialResponse, 
	push	ar3
	push	ar7
	push	ar5
	push	ar4
	mov	r0,#_processSerialPacket_posX_1_1
	movx	a,@r0
	push	acc
	inc	r0
	movx	a,@r0
	push	acc
	mov	a,#__str_10
	push	acc
	mov	a,#(__str_10 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	mov	a,#_serialResponse
	push	acc
	mov	a,#(_serialResponse >> 8)
	push	acc
	clr	a
	push	acc
	lcall	_sprintf
	mov	r6,dpl
	mov	a,sp
	add	a,#0xf4
	mov	sp,a
	mov	r0,#_responseLength
	mov	a,r6
	movx	@r0,a
	C$master_wixel_track.c$312$2$8 ==.
;	apps/master_wixel_track/master_wixel_track.c:312: usbComTxSend(serialResponse, responseLength);
	mov	r0,#_usbComTxSend_PARM_2
	mov	a,r6
	movx	@r0,a
	mov	dptr,#_serialResponse
	lcall	_usbComTxSend
00124$:
	C$master_wixel_track.c$314$1$1 ==.
	XG$processSerialPacket$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'handleSerialTimeout'
;------------------------------------------------------------
	G$handleSerialTimeout$0$0 ==.
	C$master_wixel_track.c$317$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:317: void handleSerialTimeout()
;	-----------------------------------------
;	 function handleSerialTimeout
;	-----------------------------------------
_handleSerialTimeout:
	C$master_wixel_track.c$319$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:319: uint32 timeSinceLastRx = getMs() - lastSerialRxTime;
	lcall	_getMs
	mov	r4,dpl
	mov	r5,dph
	mov	r6,b
	mov	r7,a
	mov	r0,#_lastSerialRxTime
	setb	c
	movx	a,@r0
	subb	a,r4
	cpl	a
	cpl	c
	mov	r4,a
	cpl	c
	inc	r0
	movx	a,@r0
	subb	a,r5
	cpl	a
	cpl	c
	mov	r5,a
	cpl	c
	inc	r0
	movx	a,@r0
	subb	a,r6
	cpl	a
	cpl	c
	mov	r6,a
	cpl	c
	inc	r0
	movx	a,@r0
	subb	a,r7
	cpl	a
	mov	r7,a
	C$master_wixel_track.c$321$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:321: if (timeSinceLastRx >= SERIAL_RX_TIMEOUT)
	clr	c
	mov	a,r4
	subb	a,#0x60
	mov	a,r5
	subb	a,#0xEA
	mov	a,r6
	subb	a,#0x00
	mov	a,r7
	subb	a,#0x00
	jnc	00120$
	ljmp	00111$
00120$:
	C$master_wixel_track.c$328$3$3 ==.
;	apps/master_wixel_track/master_wixel_track.c:328: for (slaveIndex = 0; slaveIndex < NUM_SLAVES; slaveIndex++)
	mov	r7,#0x00
00107$:
	cjne	r7,#0x04,00121$
00121$:
	jc	00122$
	ljmp	00110$
00122$:
	C$master_wixel_track.c$330$3$3 ==.
;	apps/master_wixel_track/master_wixel_track.c:330: txOffset = 1 + (slaveIndex * BYTES_PER_SLAVE);
	mov	a,r7
	swap	a
	anl	a,#0xF0
	mov	r6,a
	inc	r6
	C$master_wixel_track.c$332$3$3 ==.
;	apps/master_wixel_track/master_wixel_track.c:332: txPacket[txOffset + 0] = slaveAddresses[slaveIndex];  // ADD
	mov	a,r6
	add	a,#_txPacket
	mov	dpl,a
	clr	a
	addc	a,#(_txPacket >> 8)
	mov	dph,a
	mov	a,r7
	add	a,#_slaveAddresses
	mov	r1,a
	movx	a,@r1
	movx	@dptr,a
	C$master_wixel_track.c$333$3$3 ==.
;	apps/master_wixel_track/master_wixel_track.c:333: txPacket[txOffset + 1] = 0x00;  // X high
	mov	a,r6
	inc	a
	add	a,#_txPacket
	mov	dpl,a
	clr	a
	addc	a,#(_txPacket >> 8)
	mov	dph,a
	clr	a
	movx	@dptr,a
	C$master_wixel_track.c$334$3$3 ==.
;	apps/master_wixel_track/master_wixel_track.c:334: txPacket[txOffset + 2] = 0x00;  // X low
	mov	a,#0x02
	add	a,r6
	add	a,#_txPacket
	mov	dpl,a
	clr	a
	addc	a,#(_txPacket >> 8)
	mov	dph,a
	clr	a
	movx	@dptr,a
	C$master_wixel_track.c$335$3$3 ==.
;	apps/master_wixel_track/master_wixel_track.c:335: txPacket[txOffset + 3] = 0x00;  // Y high
	mov	a,#0x03
	add	a,r6
	add	a,#_txPacket
	mov	dpl,a
	clr	a
	addc	a,#(_txPacket >> 8)
	mov	dph,a
	clr	a
	movx	@dptr,a
	C$master_wixel_track.c$336$3$3 ==.
;	apps/master_wixel_track/master_wixel_track.c:336: txPacket[txOffset + 4] = 0x00;  // Y low
	mov	a,#0x04
	add	a,r6
	add	a,#_txPacket
	mov	dpl,a
	clr	a
	addc	a,#(_txPacket >> 8)
	mov	dph,a
	clr	a
	movx	@dptr,a
	C$master_wixel_track.c$337$3$3 ==.
;	apps/master_wixel_track/master_wixel_track.c:337: txPacket[txOffset + 5] = 0x00;  // Theta
	mov	a,#0x05
	add	a,r6
	add	a,#_txPacket
	mov	dpl,a
	clr	a
	addc	a,#(_txPacket >> 8)
	mov	dph,a
	clr	a
	movx	@dptr,a
	C$master_wixel_track.c$338$3$3 ==.
;	apps/master_wixel_track/master_wixel_track.c:338: txPacket[txOffset + 6] = CMD_STOP;  // Command
	mov	a,#0x06
	add	a,r6
	add	a,#_txPacket
	mov	dpl,a
	clr	a
	addc	a,#(_txPacket >> 8)
	mov	dph,a
	mov	a,#0x10
	movx	@dptr,a
	C$master_wixel_track.c$340$2$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:340: for (i = 7; i < 15; i++)
	mov	r5,#0x07
00103$:
	cjne	r5,#0x0F,00123$
00123$:
	jnc	00106$
	C$master_wixel_track.c$342$4$4 ==.
;	apps/master_wixel_track/master_wixel_track.c:342: txPacket[txOffset + i] = 0x00;  // Data3-Data13
	mov	a,r5
	add	a,r6
	add	a,#_txPacket
	mov	dpl,a
	clr	a
	addc	a,#(_txPacket >> 8)
	mov	dph,a
	clr	a
	movx	@dptr,a
	C$master_wixel_track.c$340$3$3 ==.
;	apps/master_wixel_track/master_wixel_track.c:340: for (i = 7; i < 15; i++)
	inc	r5
	sjmp	00103$
00106$:
	C$master_wixel_track.c$345$3$3 ==.
;	apps/master_wixel_track/master_wixel_track.c:345: txPacket[txOffset + 15] = MESSAGE_DELIMITER;
	mov	a,#0x0F
	add	a,r6
	add	a,#_txPacket
	mov	dpl,a
	clr	a
	addc	a,#(_txPacket >> 8)
	mov	dph,a
	mov	a,#0xFF
	movx	@dptr,a
	C$master_wixel_track.c$328$2$2 ==.
;	apps/master_wixel_track/master_wixel_track.c:328: for (slaveIndex = 0; slaveIndex < NUM_SLAVES; slaveIndex++)
	inc	r7
	ljmp	00107$
00110$:
	C$master_wixel_track.c$348$2$2 ==.
;	apps/master_wixel_track/master_wixel_track.c:348: sendRadioPacket();
	lcall	_sendRadioPacket
	C$master_wixel_track.c$350$2$2 ==.
;	apps/master_wixel_track/master_wixel_track.c:350: responseLength = sprintf((char*)serialResponse, "[TIMEOUT] No serial data for 60s, sent STOP to all slaves\r\n");
	mov	a,#__str_11
	push	acc
	mov	a,#(__str_11 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	mov	a,#_serialResponse
	push	acc
	mov	a,#(_serialResponse >> 8)
	push	acc
	clr	a
	push	acc
	lcall	_sprintf
	mov	r6,dpl
	mov	a,sp
	add	a,#0xfa
	mov	sp,a
	mov	r0,#_responseLength
	mov	a,r6
	movx	@r0,a
	C$master_wixel_track.c$351$2$2 ==.
;	apps/master_wixel_track/master_wixel_track.c:351: usbComTxSend(serialResponse, responseLength);
	mov	r0,#_usbComTxSend_PARM_2
	mov	a,r6
	movx	@r0,a
	mov	dptr,#_serialResponse
	lcall	_usbComTxSend
	C$master_wixel_track.c$353$2$2 ==.
;	apps/master_wixel_track/master_wixel_track.c:353: lastSerialRxTime = getMs();
	lcall	_getMs
	mov	r4,dpl
	mov	r5,dph
	mov	r6,b
	mov	r7,a
	mov	r0,#_lastSerialRxTime
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
00111$:
	C$master_wixel_track.c$355$2$1 ==.
	XG$handleSerialTimeout$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'processBytesFromUsb'
;------------------------------------------------------------
	G$processBytesFromUsb$0$0 ==.
	C$master_wixel_track.c$357$2$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:357: void processBytesFromUsb()
;	-----------------------------------------
;	 function processBytesFromUsb
;	-----------------------------------------
_processBytesFromUsb:
	C$master_wixel_track.c$361$2$2 ==.
;	apps/master_wixel_track/master_wixel_track.c:361: while (usbComRxAvailable() && serialBufferIndex < 100)
00104$:
	lcall	_usbComRxAvailable
	mov	a,dpl
	jz	00107$
	mov	r0,#_serialBufferIndex
	movx	a,@r0
	cjne	a,#0x64,00114$
00114$:
	jnc	00107$
	C$master_wixel_track.c$363$2$2 ==.
;	apps/master_wixel_track/master_wixel_track.c:363: byteReceived = usbComRxReceiveByte();
	lcall	_usbComRxReceiveByte
	mov	r7,dpl
	C$master_wixel_track.c$365$2$2 ==.
;	apps/master_wixel_track/master_wixel_track.c:365: serialBuffer[serialBufferIndex] = byteReceived;
	mov	r0,#_serialBufferIndex
	movx	a,@r0
	add	a,#_serialBuffer
	mov	dpl,a
	clr	a
	addc	a,#(_serialBuffer >> 8)
	mov	dph,a
	mov	a,r7
	movx	@dptr,a
	C$master_wixel_track.c$366$2$2 ==.
;	apps/master_wixel_track/master_wixel_track.c:366: serialBufferIndex++;
	mov	r0,#_serialBufferIndex
	movx	a,@r0
	add	a,#0x01
	movx	@r0,a
	C$master_wixel_track.c$369$2$2 ==.
;	apps/master_wixel_track/master_wixel_track.c:369: if (serialBufferIndex >= RADIO_PACKET_SIZE)
	mov	r0,#_serialBufferIndex
	movx	a,@r0
	cjne	a,#0x40,00116$
00116$:
	jc	00104$
	C$master_wixel_track.c$371$3$3 ==.
;	apps/master_wixel_track/master_wixel_track.c:371: processSerialPacket();
	lcall	_processSerialPacket
	C$master_wixel_track.c$372$3$3 ==.
;	apps/master_wixel_track/master_wixel_track.c:372: serialBufferIndex = 0;
	mov	r0,#_serialBufferIndex
	clr	a
	movx	@r0,a
	sjmp	00104$
00107$:
	C$master_wixel_track.c$375$1$1 ==.
	XG$processBytesFromUsb$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'initSystems'
;------------------------------------------------------------
	G$initSystems$0$0 ==.
	C$master_wixel_track.c$379$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:379: void initSystems()
;	-----------------------------------------
;	 function initSystems
;	-----------------------------------------
_initSystems:
	C$master_wixel_track.c$381$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:381: failSafeBootloader();
	lcall	_failSafeBootloader
	C$master_wixel_track.c$382$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:382: systemInit();
	lcall	_systemInit
	C$master_wixel_track.c$383$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:383: usbInit();
	lcall	_usbInit
	C$master_wixel_track.c$384$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:384: radioInit();
	lcall	_radioInit
	C$master_wixel_track.c$386$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:386: lastSerialRxTime = getMs();
	lcall	_getMs
	mov	r4,dpl
	mov	r5,dph
	mov	r6,b
	mov	r7,a
	mov	r0,#_lastSerialRxTime
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
	C$master_wixel_track.c$387$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:387: lastRadioTxTime = getMs();
	lcall	_getMs
	mov	r4,dpl
	mov	r5,dph
	mov	r6,b
	mov	r7,a
	mov	r0,#_lastRadioTxTime
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
	C$master_wixel_track.c$388$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:388: lastHeartbeatTime = getMs();
	lcall	_getMs
	mov	r4,dpl
	mov	r5,dph
	mov	r6,b
	mov	r7,a
	mov	r0,#_lastHeartbeatTime
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
	C$master_wixel_track.c$390$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:390: responseLength = sprintf((char*)serialResponse, "Master Wixel Ready - 4 SLAVES HARDCODED (PKTLEN=%d)\r\n", PKTLEN);
	mov	dptr,#_PKTLEN
	movx	a,@dptr
	mov	r7,a
	mov	r6,#0x00
	push	ar7
	push	ar6
	mov	a,#__str_12
	push	acc
	mov	a,#(__str_12 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	mov	a,#_serialResponse
	push	acc
	mov	a,#(_serialResponse >> 8)
	push	acc
	clr	a
	push	acc
	lcall	_sprintf
	mov	r6,dpl
	mov	a,sp
	add	a,#0xf8
	mov	sp,a
	mov	r0,#_responseLength
	mov	a,r6
	movx	@r0,a
	C$master_wixel_track.c$391$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:391: usbComTxSend(serialResponse, responseLength);
	mov	r0,#_usbComTxSend_PARM_2
	mov	a,r6
	movx	@r0,a
	mov	dptr,#_serialResponse
	lcall	_usbComTxSend
	C$master_wixel_track.c$392$1$1 ==.
	XG$initSystems$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'main'
;------------------------------------------------------------
	G$main$0$0 ==.
	C$master_wixel_track.c$394$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:394: void main()
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
	C$master_wixel_track.c$396$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:396: initSystems();
	lcall	_initSystems
	C$master_wixel_track.c$398$1$1 ==.
;	apps/master_wixel_track/master_wixel_track.c:398: while(1)
00102$:
	C$master_wixel_track.c$400$2$2 ==.
;	apps/master_wixel_track/master_wixel_track.c:400: boardService();
	lcall	_boardService
	C$master_wixel_track.c$401$2$2 ==.
;	apps/master_wixel_track/master_wixel_track.c:401: usbComService();
	lcall	_usbComService
	C$master_wixel_track.c$403$2$2 ==.
;	apps/master_wixel_track/master_wixel_track.c:403: processBytesFromUsb();
	lcall	_processBytesFromUsb
	C$master_wixel_track.c$404$2$2 ==.
;	apps/master_wixel_track/master_wixel_track.c:404: handleSerialTimeout();
	lcall	_handleSerialTimeout
	C$master_wixel_track.c$405$2$2 ==.
;	apps/master_wixel_track/master_wixel_track.c:405: updateLeds();
	lcall	_updateLeds
	sjmp	00102$
	C$master_wixel_track.c$407$1$1 ==.
	XG$main$0$0 ==.
	ret
	.area CSEG    (CODE)
	.area CONST   (CODE)
Fmaster_wixel_track$_str_0$0$0 == .
__str_0:
	.ascii "ERROR: Expected 64 bytes, got %d"
	.db 0x0D
	.db 0x0A
	.db 0x00
Fmaster_wixel_track$_str_1$0$0 == .
__str_1:
	.ascii "ERROR: Invalid delimiter for slave %d"
	.db 0x0D
	.db 0x0A
	.db 0x00
Fmaster_wixel_track$_str_2$0$0 == .
__str_2:
	.ascii "STOP"
	.db 0x00
Fmaster_wixel_track$_str_3$0$0 == .
__str_3:
	.ascii "GO_TO"
	.db 0x00
Fmaster_wixel_track$_str_4$0$0 == .
__str_4:
	.ascii "PREP"
	.db 0x00
Fmaster_wixel_track$_str_5$0$0 == .
__str_5:
	.ascii "RUN"
	.db 0x00
Fmaster_wixel_track$_str_6$0$0 == .
__str_6:
	.ascii "AUX"
	.db 0x00
Fmaster_wixel_track$_str_7$0$0 == .
__str_7:
	.ascii "CALIBRATE"
	.db 0x00
Fmaster_wixel_track$_str_8$0$0 == .
__str_8:
	.ascii "UNKNOWN"
	.db 0x00
Fmaster_wixel_track$_str_9$0$0 == .
__str_9:
	.ascii "Slave 1 Pos: (%d, %d, %d) CMD %s %d, %d, etc"
	.db 0x0D
	.db 0x0A
	.db 0x00
Fmaster_wixel_track$_str_10$0$0 == .
__str_10:
	.ascii "AUX: Slave 1 Pos: (%d, %d, %d)"
	.db 0x0D
	.db 0x0A
	.db 0x00
Fmaster_wixel_track$_str_11$0$0 == .
__str_11:
	.ascii "[TIMEOUT] No serial data for 60s, sent STOP to all slaves"
	.db 0x0D
	.db 0x0A
	.db 0x00
Fmaster_wixel_track$_str_12$0$0 == .
__str_12:
	.ascii "Master Wixel Ready - 4 SLAVES HARDCODED (PKTLEN=%d)"
	.db 0x0D
	.db 0x0A
	.db 0x00
	.area XINIT   (CODE)
	.area CABS    (ABS,CODE)
