;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.1.0 #7066 (Nov 22 2011) (MINGW32)
; This file was generated Thu Oct 23 16:10:48 2025
;--------------------------------------------------------
	.module master_wixel
	.optsdcc -mmcs51 --model-medium
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _preparePacket
	.globl _processBytesFromUsb
	.globl _processSerialByte
	.globl _updateLeds
	.globl _sendRadioPacket
	.globl _radioInit
	.globl _sprintf
	.globl _usbComTxSend
	.globl _usbComTxAvailable
	.globl _usbComRxReceiveByte
	.globl _usbComRxAvailable
	.globl _usbComService
	.globl _usbInit
	.globl _radioRegistersInit
	.globl _getMs
	.globl _boardService
	.globl _systemInit
	.globl _radioTxPulseStart
	.globl _serialRxPulseStart
	.globl _state
	.globl _lastTxTime
	.globl _radioTxPulseActive
	.globl _serialRxPulseActive
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area RSEG    (ABS,DATA)
	.org 0x0000
Fmaster_wixel$P0$0$0 == 0x0080
_P0	=	0x0080
Fmaster_wixel$SP$0$0 == 0x0081
_SP	=	0x0081
Fmaster_wixel$DPL0$0$0 == 0x0082
_DPL0	=	0x0082
Fmaster_wixel$DPH0$0$0 == 0x0083
_DPH0	=	0x0083
Fmaster_wixel$DPL1$0$0 == 0x0084
_DPL1	=	0x0084
Fmaster_wixel$DPH1$0$0 == 0x0085
_DPH1	=	0x0085
Fmaster_wixel$U0CSR$0$0 == 0x0086
_U0CSR	=	0x0086
Fmaster_wixel$PCON$0$0 == 0x0087
_PCON	=	0x0087
Fmaster_wixel$TCON$0$0 == 0x0088
_TCON	=	0x0088
Fmaster_wixel$P0IFG$0$0 == 0x0089
_P0IFG	=	0x0089
Fmaster_wixel$P1IFG$0$0 == 0x008a
_P1IFG	=	0x008a
Fmaster_wixel$P2IFG$0$0 == 0x008b
_P2IFG	=	0x008b
Fmaster_wixel$PICTL$0$0 == 0x008c
_PICTL	=	0x008c
Fmaster_wixel$P1IEN$0$0 == 0x008d
_P1IEN	=	0x008d
Fmaster_wixel$P0INP$0$0 == 0x008f
_P0INP	=	0x008f
Fmaster_wixel$P1$0$0 == 0x0090
_P1	=	0x0090
Fmaster_wixel$RFIM$0$0 == 0x0091
_RFIM	=	0x0091
Fmaster_wixel$DPS$0$0 == 0x0092
_DPS	=	0x0092
Fmaster_wixel$MPAGE$0$0 == 0x0093
_MPAGE	=	0x0093
Fmaster_wixel$ENDIAN$0$0 == 0x0095
_ENDIAN	=	0x0095
Fmaster_wixel$S0CON$0$0 == 0x0098
_S0CON	=	0x0098
Fmaster_wixel$IEN2$0$0 == 0x009a
_IEN2	=	0x009a
Fmaster_wixel$S1CON$0$0 == 0x009b
_S1CON	=	0x009b
Fmaster_wixel$T2CT$0$0 == 0x009c
_T2CT	=	0x009c
Fmaster_wixel$T2PR$0$0 == 0x009d
_T2PR	=	0x009d
Fmaster_wixel$T2CTL$0$0 == 0x009e
_T2CTL	=	0x009e
Fmaster_wixel$P2$0$0 == 0x00a0
_P2	=	0x00a0
Fmaster_wixel$WORIRQ$0$0 == 0x00a1
_WORIRQ	=	0x00a1
Fmaster_wixel$WORCTRL$0$0 == 0x00a2
_WORCTRL	=	0x00a2
Fmaster_wixel$WOREVT0$0$0 == 0x00a3
_WOREVT0	=	0x00a3
Fmaster_wixel$WOREVT1$0$0 == 0x00a4
_WOREVT1	=	0x00a4
Fmaster_wixel$WORTIME0$0$0 == 0x00a5
_WORTIME0	=	0x00a5
Fmaster_wixel$WORTIME1$0$0 == 0x00a6
_WORTIME1	=	0x00a6
Fmaster_wixel$IEN0$0$0 == 0x00a8
_IEN0	=	0x00a8
Fmaster_wixel$IP0$0$0 == 0x00a9
_IP0	=	0x00a9
Fmaster_wixel$FWT$0$0 == 0x00ab
_FWT	=	0x00ab
Fmaster_wixel$FADDRL$0$0 == 0x00ac
_FADDRL	=	0x00ac
Fmaster_wixel$FADDRH$0$0 == 0x00ad
_FADDRH	=	0x00ad
Fmaster_wixel$FCTL$0$0 == 0x00ae
_FCTL	=	0x00ae
Fmaster_wixel$FWDATA$0$0 == 0x00af
_FWDATA	=	0x00af
Fmaster_wixel$ENCDI$0$0 == 0x00b1
_ENCDI	=	0x00b1
Fmaster_wixel$ENCDO$0$0 == 0x00b2
_ENCDO	=	0x00b2
Fmaster_wixel$ENCCS$0$0 == 0x00b3
_ENCCS	=	0x00b3
Fmaster_wixel$ADCCON1$0$0 == 0x00b4
_ADCCON1	=	0x00b4
Fmaster_wixel$ADCCON2$0$0 == 0x00b5
_ADCCON2	=	0x00b5
Fmaster_wixel$ADCCON3$0$0 == 0x00b6
_ADCCON3	=	0x00b6
Fmaster_wixel$IEN1$0$0 == 0x00b8
_IEN1	=	0x00b8
Fmaster_wixel$IP1$0$0 == 0x00b9
_IP1	=	0x00b9
Fmaster_wixel$ADCL$0$0 == 0x00ba
_ADCL	=	0x00ba
Fmaster_wixel$ADCH$0$0 == 0x00bb
_ADCH	=	0x00bb
Fmaster_wixel$RNDL$0$0 == 0x00bc
_RNDL	=	0x00bc
Fmaster_wixel$RNDH$0$0 == 0x00bd
_RNDH	=	0x00bd
Fmaster_wixel$SLEEP$0$0 == 0x00be
_SLEEP	=	0x00be
Fmaster_wixel$IRCON$0$0 == 0x00c0
_IRCON	=	0x00c0
Fmaster_wixel$U0DBUF$0$0 == 0x00c1
_U0DBUF	=	0x00c1
Fmaster_wixel$U0BAUD$0$0 == 0x00c2
_U0BAUD	=	0x00c2
Fmaster_wixel$U0UCR$0$0 == 0x00c4
_U0UCR	=	0x00c4
Fmaster_wixel$U0GCR$0$0 == 0x00c5
_U0GCR	=	0x00c5
Fmaster_wixel$CLKCON$0$0 == 0x00c6
_CLKCON	=	0x00c6
Fmaster_wixel$MEMCTR$0$0 == 0x00c7
_MEMCTR	=	0x00c7
Fmaster_wixel$WDCTL$0$0 == 0x00c9
_WDCTL	=	0x00c9
Fmaster_wixel$T3CNT$0$0 == 0x00ca
_T3CNT	=	0x00ca
Fmaster_wixel$T3CTL$0$0 == 0x00cb
_T3CTL	=	0x00cb
Fmaster_wixel$T3CCTL0$0$0 == 0x00cc
_T3CCTL0	=	0x00cc
Fmaster_wixel$T3CC0$0$0 == 0x00cd
_T3CC0	=	0x00cd
Fmaster_wixel$T3CCTL1$0$0 == 0x00ce
_T3CCTL1	=	0x00ce
Fmaster_wixel$T3CC1$0$0 == 0x00cf
_T3CC1	=	0x00cf
Fmaster_wixel$PSW$0$0 == 0x00d0
_PSW	=	0x00d0
Fmaster_wixel$DMAIRQ$0$0 == 0x00d1
_DMAIRQ	=	0x00d1
Fmaster_wixel$DMA1CFGL$0$0 == 0x00d2
_DMA1CFGL	=	0x00d2
Fmaster_wixel$DMA1CFGH$0$0 == 0x00d3
_DMA1CFGH	=	0x00d3
Fmaster_wixel$DMA0CFGL$0$0 == 0x00d4
_DMA0CFGL	=	0x00d4
Fmaster_wixel$DMA0CFGH$0$0 == 0x00d5
_DMA0CFGH	=	0x00d5
Fmaster_wixel$DMAARM$0$0 == 0x00d6
_DMAARM	=	0x00d6
Fmaster_wixel$DMAREQ$0$0 == 0x00d7
_DMAREQ	=	0x00d7
Fmaster_wixel$TIMIF$0$0 == 0x00d8
_TIMIF	=	0x00d8
Fmaster_wixel$RFD$0$0 == 0x00d9
_RFD	=	0x00d9
Fmaster_wixel$T1CC0L$0$0 == 0x00da
_T1CC0L	=	0x00da
Fmaster_wixel$T1CC0H$0$0 == 0x00db
_T1CC0H	=	0x00db
Fmaster_wixel$T1CC1L$0$0 == 0x00dc
_T1CC1L	=	0x00dc
Fmaster_wixel$T1CC1H$0$0 == 0x00dd
_T1CC1H	=	0x00dd
Fmaster_wixel$T1CC2L$0$0 == 0x00de
_T1CC2L	=	0x00de
Fmaster_wixel$T1CC2H$0$0 == 0x00df
_T1CC2H	=	0x00df
Fmaster_wixel$ACC$0$0 == 0x00e0
_ACC	=	0x00e0
Fmaster_wixel$RFST$0$0 == 0x00e1
_RFST	=	0x00e1
Fmaster_wixel$T1CNTL$0$0 == 0x00e2
_T1CNTL	=	0x00e2
Fmaster_wixel$T1CNTH$0$0 == 0x00e3
_T1CNTH	=	0x00e3
Fmaster_wixel$T1CTL$0$0 == 0x00e4
_T1CTL	=	0x00e4
Fmaster_wixel$T1CCTL0$0$0 == 0x00e5
_T1CCTL0	=	0x00e5
Fmaster_wixel$T1CCTL1$0$0 == 0x00e6
_T1CCTL1	=	0x00e6
Fmaster_wixel$T1CCTL2$0$0 == 0x00e7
_T1CCTL2	=	0x00e7
Fmaster_wixel$IRCON2$0$0 == 0x00e8
_IRCON2	=	0x00e8
Fmaster_wixel$RFIF$0$0 == 0x00e9
_RFIF	=	0x00e9
Fmaster_wixel$T4CNT$0$0 == 0x00ea
_T4CNT	=	0x00ea
Fmaster_wixel$T4CTL$0$0 == 0x00eb
_T4CTL	=	0x00eb
Fmaster_wixel$T4CCTL0$0$0 == 0x00ec
_T4CCTL0	=	0x00ec
Fmaster_wixel$T4CC0$0$0 == 0x00ed
_T4CC0	=	0x00ed
Fmaster_wixel$T4CCTL1$0$0 == 0x00ee
_T4CCTL1	=	0x00ee
Fmaster_wixel$T4CC1$0$0 == 0x00ef
_T4CC1	=	0x00ef
Fmaster_wixel$B$0$0 == 0x00f0
_B	=	0x00f0
Fmaster_wixel$PERCFG$0$0 == 0x00f1
_PERCFG	=	0x00f1
Fmaster_wixel$ADCCFG$0$0 == 0x00f2
_ADCCFG	=	0x00f2
Fmaster_wixel$P0SEL$0$0 == 0x00f3
_P0SEL	=	0x00f3
Fmaster_wixel$P1SEL$0$0 == 0x00f4
_P1SEL	=	0x00f4
Fmaster_wixel$P2SEL$0$0 == 0x00f5
_P2SEL	=	0x00f5
Fmaster_wixel$P1INP$0$0 == 0x00f6
_P1INP	=	0x00f6
Fmaster_wixel$P2INP$0$0 == 0x00f7
_P2INP	=	0x00f7
Fmaster_wixel$U1CSR$0$0 == 0x00f8
_U1CSR	=	0x00f8
Fmaster_wixel$U1DBUF$0$0 == 0x00f9
_U1DBUF	=	0x00f9
Fmaster_wixel$U1BAUD$0$0 == 0x00fa
_U1BAUD	=	0x00fa
Fmaster_wixel$U1UCR$0$0 == 0x00fb
_U1UCR	=	0x00fb
Fmaster_wixel$U1GCR$0$0 == 0x00fc
_U1GCR	=	0x00fc
Fmaster_wixel$P0DIR$0$0 == 0x00fd
_P0DIR	=	0x00fd
Fmaster_wixel$P1DIR$0$0 == 0x00fe
_P1DIR	=	0x00fe
Fmaster_wixel$P2DIR$0$0 == 0x00ff
_P2DIR	=	0x00ff
Fmaster_wixel$DMA0CFG$0$0 == 0xffffd5d4
_DMA0CFG	=	0xffffd5d4
Fmaster_wixel$DMA1CFG$0$0 == 0xffffd3d2
_DMA1CFG	=	0xffffd3d2
Fmaster_wixel$FADDR$0$0 == 0xffffadac
_FADDR	=	0xffffadac
Fmaster_wixel$ADC$0$0 == 0xffffbbba
_ADC	=	0xffffbbba
Fmaster_wixel$T1CC0$0$0 == 0xffffdbda
_T1CC0	=	0xffffdbda
Fmaster_wixel$T1CC1$0$0 == 0xffffdddc
_T1CC1	=	0xffffdddc
Fmaster_wixel$T1CC2$0$0 == 0xffffdfde
_T1CC2	=	0xffffdfde
;--------------------------------------------------------
; special function bits
;--------------------------------------------------------
	.area RSEG    (ABS,DATA)
	.org 0x0000
Fmaster_wixel$P0_0$0$0 == 0x0080
_P0_0	=	0x0080
Fmaster_wixel$P0_1$0$0 == 0x0081
_P0_1	=	0x0081
Fmaster_wixel$P0_2$0$0 == 0x0082
_P0_2	=	0x0082
Fmaster_wixel$P0_3$0$0 == 0x0083
_P0_3	=	0x0083
Fmaster_wixel$P0_4$0$0 == 0x0084
_P0_4	=	0x0084
Fmaster_wixel$P0_5$0$0 == 0x0085
_P0_5	=	0x0085
Fmaster_wixel$P0_6$0$0 == 0x0086
_P0_6	=	0x0086
Fmaster_wixel$P0_7$0$0 == 0x0087
_P0_7	=	0x0087
Fmaster_wixel$_TCON_0$0$0 == 0x0088
__TCON_0	=	0x0088
Fmaster_wixel$RFTXRXIF$0$0 == 0x0089
_RFTXRXIF	=	0x0089
Fmaster_wixel$_TCON_2$0$0 == 0x008a
__TCON_2	=	0x008a
Fmaster_wixel$URX0IF$0$0 == 0x008b
_URX0IF	=	0x008b
Fmaster_wixel$_TCON_4$0$0 == 0x008c
__TCON_4	=	0x008c
Fmaster_wixel$ADCIF$0$0 == 0x008d
_ADCIF	=	0x008d
Fmaster_wixel$_TCON_6$0$0 == 0x008e
__TCON_6	=	0x008e
Fmaster_wixel$URX1IF$0$0 == 0x008f
_URX1IF	=	0x008f
Fmaster_wixel$P1_0$0$0 == 0x0090
_P1_0	=	0x0090
Fmaster_wixel$P1_1$0$0 == 0x0091
_P1_1	=	0x0091
Fmaster_wixel$P1_2$0$0 == 0x0092
_P1_2	=	0x0092
Fmaster_wixel$P1_3$0$0 == 0x0093
_P1_3	=	0x0093
Fmaster_wixel$P1_4$0$0 == 0x0094
_P1_4	=	0x0094
Fmaster_wixel$P1_5$0$0 == 0x0095
_P1_5	=	0x0095
Fmaster_wixel$P1_6$0$0 == 0x0096
_P1_6	=	0x0096
Fmaster_wixel$P1_7$0$0 == 0x0097
_P1_7	=	0x0097
Fmaster_wixel$ENCIF_0$0$0 == 0x0098
_ENCIF_0	=	0x0098
Fmaster_wixel$ENCIF_1$0$0 == 0x0099
_ENCIF_1	=	0x0099
Fmaster_wixel$_SOCON2$0$0 == 0x009a
__SOCON2	=	0x009a
Fmaster_wixel$_SOCON3$0$0 == 0x009b
__SOCON3	=	0x009b
Fmaster_wixel$_SOCON4$0$0 == 0x009c
__SOCON4	=	0x009c
Fmaster_wixel$_SOCON5$0$0 == 0x009d
__SOCON5	=	0x009d
Fmaster_wixel$_SOCON6$0$0 == 0x009e
__SOCON6	=	0x009e
Fmaster_wixel$_SOCON7$0$0 == 0x009f
__SOCON7	=	0x009f
Fmaster_wixel$P2_0$0$0 == 0x00a0
_P2_0	=	0x00a0
Fmaster_wixel$P2_1$0$0 == 0x00a1
_P2_1	=	0x00a1
Fmaster_wixel$P2_2$0$0 == 0x00a2
_P2_2	=	0x00a2
Fmaster_wixel$P2_3$0$0 == 0x00a3
_P2_3	=	0x00a3
Fmaster_wixel$P2_4$0$0 == 0x00a4
_P2_4	=	0x00a4
Fmaster_wixel$P2_5$0$0 == 0x00a5
_P2_5	=	0x00a5
Fmaster_wixel$P2_6$0$0 == 0x00a6
_P2_6	=	0x00a6
Fmaster_wixel$P2_7$0$0 == 0x00a7
_P2_7	=	0x00a7
Fmaster_wixel$RFTXRXIE$0$0 == 0x00a8
_RFTXRXIE	=	0x00a8
Fmaster_wixel$ADCIE$0$0 == 0x00a9
_ADCIE	=	0x00a9
Fmaster_wixel$URX0IE$0$0 == 0x00aa
_URX0IE	=	0x00aa
Fmaster_wixel$URX1IE$0$0 == 0x00ab
_URX1IE	=	0x00ab
Fmaster_wixel$ENCIE$0$0 == 0x00ac
_ENCIE	=	0x00ac
Fmaster_wixel$STIE$0$0 == 0x00ad
_STIE	=	0x00ad
Fmaster_wixel$_IEN06$0$0 == 0x00ae
__IEN06	=	0x00ae
Fmaster_wixel$EA$0$0 == 0x00af
_EA	=	0x00af
Fmaster_wixel$DMAIE$0$0 == 0x00b8
_DMAIE	=	0x00b8
Fmaster_wixel$T1IE$0$0 == 0x00b9
_T1IE	=	0x00b9
Fmaster_wixel$T2IE$0$0 == 0x00ba
_T2IE	=	0x00ba
Fmaster_wixel$T3IE$0$0 == 0x00bb
_T3IE	=	0x00bb
Fmaster_wixel$T4IE$0$0 == 0x00bc
_T4IE	=	0x00bc
Fmaster_wixel$P0IE$0$0 == 0x00bd
_P0IE	=	0x00bd
Fmaster_wixel$_IEN16$0$0 == 0x00be
__IEN16	=	0x00be
Fmaster_wixel$_IEN17$0$0 == 0x00bf
__IEN17	=	0x00bf
Fmaster_wixel$DMAIF$0$0 == 0x00c0
_DMAIF	=	0x00c0
Fmaster_wixel$T1IF$0$0 == 0x00c1
_T1IF	=	0x00c1
Fmaster_wixel$T2IF$0$0 == 0x00c2
_T2IF	=	0x00c2
Fmaster_wixel$T3IF$0$0 == 0x00c3
_T3IF	=	0x00c3
Fmaster_wixel$T4IF$0$0 == 0x00c4
_T4IF	=	0x00c4
Fmaster_wixel$P0IF$0$0 == 0x00c5
_P0IF	=	0x00c5
Fmaster_wixel$_IRCON6$0$0 == 0x00c6
__IRCON6	=	0x00c6
Fmaster_wixel$STIF$0$0 == 0x00c7
_STIF	=	0x00c7
Fmaster_wixel$P$0$0 == 0x00d0
_P	=	0x00d0
Fmaster_wixel$F1$0$0 == 0x00d1
_F1	=	0x00d1
Fmaster_wixel$OV$0$0 == 0x00d2
_OV	=	0x00d2
Fmaster_wixel$RS0$0$0 == 0x00d3
_RS0	=	0x00d3
Fmaster_wixel$RS1$0$0 == 0x00d4
_RS1	=	0x00d4
Fmaster_wixel$F0$0$0 == 0x00d5
_F0	=	0x00d5
Fmaster_wixel$AC$0$0 == 0x00d6
_AC	=	0x00d6
Fmaster_wixel$CY$0$0 == 0x00d7
_CY	=	0x00d7
Fmaster_wixel$T3OVFIF$0$0 == 0x00d8
_T3OVFIF	=	0x00d8
Fmaster_wixel$T3CH0IF$0$0 == 0x00d9
_T3CH0IF	=	0x00d9
Fmaster_wixel$T3CH1IF$0$0 == 0x00da
_T3CH1IF	=	0x00da
Fmaster_wixel$T4OVFIF$0$0 == 0x00db
_T4OVFIF	=	0x00db
Fmaster_wixel$T4CH0IF$0$0 == 0x00dc
_T4CH0IF	=	0x00dc
Fmaster_wixel$T4CH1IF$0$0 == 0x00dd
_T4CH1IF	=	0x00dd
Fmaster_wixel$OVFIM$0$0 == 0x00de
_OVFIM	=	0x00de
Fmaster_wixel$_TIMIF7$0$0 == 0x00df
__TIMIF7	=	0x00df
Fmaster_wixel$ACC_0$0$0 == 0x00e0
_ACC_0	=	0x00e0
Fmaster_wixel$ACC_1$0$0 == 0x00e1
_ACC_1	=	0x00e1
Fmaster_wixel$ACC_2$0$0 == 0x00e2
_ACC_2	=	0x00e2
Fmaster_wixel$ACC_3$0$0 == 0x00e3
_ACC_3	=	0x00e3
Fmaster_wixel$ACC_4$0$0 == 0x00e4
_ACC_4	=	0x00e4
Fmaster_wixel$ACC_5$0$0 == 0x00e5
_ACC_5	=	0x00e5
Fmaster_wixel$ACC_6$0$0 == 0x00e6
_ACC_6	=	0x00e6
Fmaster_wixel$ACC_7$0$0 == 0x00e7
_ACC_7	=	0x00e7
Fmaster_wixel$P2IF$0$0 == 0x00e8
_P2IF	=	0x00e8
Fmaster_wixel$UTX0IF$0$0 == 0x00e9
_UTX0IF	=	0x00e9
Fmaster_wixel$UTX1IF$0$0 == 0x00ea
_UTX1IF	=	0x00ea
Fmaster_wixel$P1IF$0$0 == 0x00eb
_P1IF	=	0x00eb
Fmaster_wixel$WDTIF$0$0 == 0x00ec
_WDTIF	=	0x00ec
Fmaster_wixel$_IRCON25$0$0 == 0x00ed
__IRCON25	=	0x00ed
Fmaster_wixel$_IRCON26$0$0 == 0x00ee
__IRCON26	=	0x00ee
Fmaster_wixel$_IRCON27$0$0 == 0x00ef
__IRCON27	=	0x00ef
Fmaster_wixel$B_0$0$0 == 0x00f0
_B_0	=	0x00f0
Fmaster_wixel$B_1$0$0 == 0x00f1
_B_1	=	0x00f1
Fmaster_wixel$B_2$0$0 == 0x00f2
_B_2	=	0x00f2
Fmaster_wixel$B_3$0$0 == 0x00f3
_B_3	=	0x00f3
Fmaster_wixel$B_4$0$0 == 0x00f4
_B_4	=	0x00f4
Fmaster_wixel$B_5$0$0 == 0x00f5
_B_5	=	0x00f5
Fmaster_wixel$B_6$0$0 == 0x00f6
_B_6	=	0x00f6
Fmaster_wixel$B_7$0$0 == 0x00f7
_B_7	=	0x00f7
Fmaster_wixel$U1ACTIVE$0$0 == 0x00f8
_U1ACTIVE	=	0x00f8
Fmaster_wixel$U1TX_BYTE$0$0 == 0x00f9
_U1TX_BYTE	=	0x00f9
Fmaster_wixel$U1RX_BYTE$0$0 == 0x00fa
_U1RX_BYTE	=	0x00fa
Fmaster_wixel$U1ERR$0$0 == 0x00fb
_U1ERR	=	0x00fb
Fmaster_wixel$U1FE$0$0 == 0x00fc
_U1FE	=	0x00fc
Fmaster_wixel$U1SLAVE$0$0 == 0x00fd
_U1SLAVE	=	0x00fd
Fmaster_wixel$U1RE$0$0 == 0x00fe
_U1RE	=	0x00fe
Fmaster_wixel$U1MODE$0$0 == 0x00ff
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
G$lastTxTime$0$0==.
_lastTxTime::
	.ds 4
G$state$0$0==.
_state::
	.ds 1
G$serialRxPulseStart$0$0==.
_serialRxPulseStart::
	.ds 2
G$radioTxPulseStart$0$0==.
_radioTxPulseStart::
	.ds 2
;--------------------------------------------------------
; external ram data
;--------------------------------------------------------
	.area XSEG    (XDATA)
Fmaster_wixel$SYNC1$0$0 == 0xdf00
_SYNC1	=	0xdf00
Fmaster_wixel$SYNC0$0$0 == 0xdf01
_SYNC0	=	0xdf01
Fmaster_wixel$PKTLEN$0$0 == 0xdf02
_PKTLEN	=	0xdf02
Fmaster_wixel$PKTCTRL1$0$0 == 0xdf03
_PKTCTRL1	=	0xdf03
Fmaster_wixel$PKTCTRL0$0$0 == 0xdf04
_PKTCTRL0	=	0xdf04
Fmaster_wixel$ADDR$0$0 == 0xdf05
_ADDR	=	0xdf05
Fmaster_wixel$CHANNR$0$0 == 0xdf06
_CHANNR	=	0xdf06
Fmaster_wixel$FSCTRL1$0$0 == 0xdf07
_FSCTRL1	=	0xdf07
Fmaster_wixel$FSCTRL0$0$0 == 0xdf08
_FSCTRL0	=	0xdf08
Fmaster_wixel$FREQ2$0$0 == 0xdf09
_FREQ2	=	0xdf09
Fmaster_wixel$FREQ1$0$0 == 0xdf0a
_FREQ1	=	0xdf0a
Fmaster_wixel$FREQ0$0$0 == 0xdf0b
_FREQ0	=	0xdf0b
Fmaster_wixel$MDMCFG4$0$0 == 0xdf0c
_MDMCFG4	=	0xdf0c
Fmaster_wixel$MDMCFG3$0$0 == 0xdf0d
_MDMCFG3	=	0xdf0d
Fmaster_wixel$MDMCFG2$0$0 == 0xdf0e
_MDMCFG2	=	0xdf0e
Fmaster_wixel$MDMCFG1$0$0 == 0xdf0f
_MDMCFG1	=	0xdf0f
Fmaster_wixel$MDMCFG0$0$0 == 0xdf10
_MDMCFG0	=	0xdf10
Fmaster_wixel$DEVIATN$0$0 == 0xdf11
_DEVIATN	=	0xdf11
Fmaster_wixel$MCSM2$0$0 == 0xdf12
_MCSM2	=	0xdf12
Fmaster_wixel$MCSM1$0$0 == 0xdf13
_MCSM1	=	0xdf13
Fmaster_wixel$MCSM0$0$0 == 0xdf14
_MCSM0	=	0xdf14
Fmaster_wixel$FOCCFG$0$0 == 0xdf15
_FOCCFG	=	0xdf15
Fmaster_wixel$BSCFG$0$0 == 0xdf16
_BSCFG	=	0xdf16
Fmaster_wixel$AGCCTRL2$0$0 == 0xdf17
_AGCCTRL2	=	0xdf17
Fmaster_wixel$AGCCTRL1$0$0 == 0xdf18
_AGCCTRL1	=	0xdf18
Fmaster_wixel$AGCCTRL0$0$0 == 0xdf19
_AGCCTRL0	=	0xdf19
Fmaster_wixel$FREND1$0$0 == 0xdf1a
_FREND1	=	0xdf1a
Fmaster_wixel$FREND0$0$0 == 0xdf1b
_FREND0	=	0xdf1b
Fmaster_wixel$FSCAL3$0$0 == 0xdf1c
_FSCAL3	=	0xdf1c
Fmaster_wixel$FSCAL2$0$0 == 0xdf1d
_FSCAL2	=	0xdf1d
Fmaster_wixel$FSCAL1$0$0 == 0xdf1e
_FSCAL1	=	0xdf1e
Fmaster_wixel$FSCAL0$0$0 == 0xdf1f
_FSCAL0	=	0xdf1f
Fmaster_wixel$TEST2$0$0 == 0xdf23
_TEST2	=	0xdf23
Fmaster_wixel$TEST1$0$0 == 0xdf24
_TEST1	=	0xdf24
Fmaster_wixel$TEST0$0$0 == 0xdf25
_TEST0	=	0xdf25
Fmaster_wixel$PA_TABLE0$0$0 == 0xdf2e
_PA_TABLE0	=	0xdf2e
Fmaster_wixel$IOCFG2$0$0 == 0xdf2f
_IOCFG2	=	0xdf2f
Fmaster_wixel$IOCFG1$0$0 == 0xdf30
_IOCFG1	=	0xdf30
Fmaster_wixel$IOCFG0$0$0 == 0xdf31
_IOCFG0	=	0xdf31
Fmaster_wixel$PARTNUM$0$0 == 0xdf36
_PARTNUM	=	0xdf36
Fmaster_wixel$VERSION$0$0 == 0xdf37
_VERSION	=	0xdf37
Fmaster_wixel$FREQEST$0$0 == 0xdf38
_FREQEST	=	0xdf38
Fmaster_wixel$LQI$0$0 == 0xdf39
_LQI	=	0xdf39
Fmaster_wixel$RSSI$0$0 == 0xdf3a
_RSSI	=	0xdf3a
Fmaster_wixel$MARCSTATE$0$0 == 0xdf3b
_MARCSTATE	=	0xdf3b
Fmaster_wixel$PKTSTATUS$0$0 == 0xdf3c
_PKTSTATUS	=	0xdf3c
Fmaster_wixel$VCO_VC_DAC$0$0 == 0xdf3d
_VCO_VC_DAC	=	0xdf3d
Fmaster_wixel$I2SCFG0$0$0 == 0xdf40
_I2SCFG0	=	0xdf40
Fmaster_wixel$I2SCFG1$0$0 == 0xdf41
_I2SCFG1	=	0xdf41
Fmaster_wixel$I2SDATL$0$0 == 0xdf42
_I2SDATL	=	0xdf42
Fmaster_wixel$I2SDATH$0$0 == 0xdf43
_I2SDATH	=	0xdf43
Fmaster_wixel$I2SWCNT$0$0 == 0xdf44
_I2SWCNT	=	0xdf44
Fmaster_wixel$I2SSTAT$0$0 == 0xdf45
_I2SSTAT	=	0xdf45
Fmaster_wixel$I2SCLKF0$0$0 == 0xdf46
_I2SCLKF0	=	0xdf46
Fmaster_wixel$I2SCLKF1$0$0 == 0xdf47
_I2SCLKF1	=	0xdf47
Fmaster_wixel$I2SCLKF2$0$0 == 0xdf48
_I2SCLKF2	=	0xdf48
Fmaster_wixel$USBADDR$0$0 == 0xde00
_USBADDR	=	0xde00
Fmaster_wixel$USBPOW$0$0 == 0xde01
_USBPOW	=	0xde01
Fmaster_wixel$USBIIF$0$0 == 0xde02
_USBIIF	=	0xde02
Fmaster_wixel$USBOIF$0$0 == 0xde04
_USBOIF	=	0xde04
Fmaster_wixel$USBCIF$0$0 == 0xde06
_USBCIF	=	0xde06
Fmaster_wixel$USBIIE$0$0 == 0xde07
_USBIIE	=	0xde07
Fmaster_wixel$USBOIE$0$0 == 0xde09
_USBOIE	=	0xde09
Fmaster_wixel$USBCIE$0$0 == 0xde0b
_USBCIE	=	0xde0b
Fmaster_wixel$USBFRML$0$0 == 0xde0c
_USBFRML	=	0xde0c
Fmaster_wixel$USBFRMH$0$0 == 0xde0d
_USBFRMH	=	0xde0d
Fmaster_wixel$USBINDEX$0$0 == 0xde0e
_USBINDEX	=	0xde0e
Fmaster_wixel$USBMAXI$0$0 == 0xde10
_USBMAXI	=	0xde10
Fmaster_wixel$USBCSIL$0$0 == 0xde11
_USBCSIL	=	0xde11
Fmaster_wixel$USBCSIH$0$0 == 0xde12
_USBCSIH	=	0xde12
Fmaster_wixel$USBMAXO$0$0 == 0xde13
_USBMAXO	=	0xde13
Fmaster_wixel$USBCSOL$0$0 == 0xde14
_USBCSOL	=	0xde14
Fmaster_wixel$USBCSOH$0$0 == 0xde15
_USBCSOH	=	0xde15
Fmaster_wixel$USBCNTL$0$0 == 0xde16
_USBCNTL	=	0xde16
Fmaster_wixel$USBCNTH$0$0 == 0xde17
_USBCNTH	=	0xde17
Fmaster_wixel$USBF0$0$0 == 0xde20
_USBF0	=	0xde20
Fmaster_wixel$USBF1$0$0 == 0xde22
_USBF1	=	0xde22
Fmaster_wixel$USBF2$0$0 == 0xde24
_USBF2	=	0xde24
Fmaster_wixel$USBF3$0$0 == 0xde26
_USBF3	=	0xde26
Fmaster_wixel$USBF4$0$0 == 0xde28
_USBF4	=	0xde28
Fmaster_wixel$USBF5$0$0 == 0xde2a
_USBF5	=	0xde2a
Fmaster_wixel$txPacket$0$0==.
_txPacket:
	.ds 17
Fmaster_wixel$serialResponse$0$0==.
_serialResponse:
	.ds 32
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
	C$master_wixel.c$60$1$1 ==.
;	apps/master_wixel/master_wixel.c:60: BIT serialRxPulseActive = 0;
	clr	_serialRxPulseActive
	G$main$0$0 ==.
	C$master_wixel.c$63$1$1 ==.
;	apps/master_wixel/master_wixel.c:63: BIT radioTxPulseActive = 0;
	clr	_radioTxPulseActive
	G$main$0$0 ==.
	C$master_wixel.c$61$1$1 ==.
;	apps/master_wixel/master_wixel.c:61: uint16 serialRxPulseStart = 0;
	mov	r0,#_serialRxPulseStart
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	G$main$0$0 ==.
	C$master_wixel.c$64$1$1 ==.
;	apps/master_wixel/master_wixel.c:64: uint16 radioTxPulseStart = 0;
	mov	r0,#_radioTxPulseStart
	clr	a
	movx	@r0,a
	inc	r0
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
;Allocation info for local variables in function 'radioInit'
;------------------------------------------------------------
	G$radioInit$0$0 ==.
	C$master_wixel.c$69$0$0 ==.
;	apps/master_wixel/master_wixel.c:69: void radioInit()
;	-----------------------------------------
;	 function radioInit
;	-----------------------------------------
_radioInit:
	ar7 = 0x07
	ar6 = 0x06
	ar5 = 0x05
	ar4 = 0x04
	ar3 = 0x03
	ar2 = 0x02
	ar1 = 0x01
	ar0 = 0x00
	C$master_wixel.c$71$1$1 ==.
;	apps/master_wixel/master_wixel.c:71: radioRegistersInit();
	lcall	_radioRegistersInit
	C$master_wixel.c$73$1$1 ==.
;	apps/master_wixel/master_wixel.c:73: CHANNR = 128;
	mov	dptr,#_CHANNR
	mov	a,#0x80
	movx	@dptr,a
	C$master_wixel.c$74$1$1 ==.
;	apps/master_wixel/master_wixel.c:74: PKTLEN = RADIO_PACKET_SIZE;
	mov	dptr,#_PKTLEN
	mov	a,#0x10
	movx	@dptr,a
	C$master_wixel.c$75$1$1 ==.
;	apps/master_wixel/master_wixel.c:75: MCSM0 = 0x14;
	mov	dptr,#_MCSM0
	mov	a,#0x14
	movx	@dptr,a
	C$master_wixel.c$76$1$1 ==.
;	apps/master_wixel/master_wixel.c:76: MCSM1 = 0x00;
	mov	dptr,#_MCSM1
	clr	a
	movx	@dptr,a
	C$master_wixel.c$77$1$1 ==.
;	apps/master_wixel/master_wixel.c:77: IOCFG2 = 0b011011;
	mov	dptr,#_IOCFG2
	mov	a,#0x1B
	movx	@dptr,a
	C$master_wixel.c$80$1$1 ==.
;	apps/master_wixel/master_wixel.c:80: dmaConfig.radio.DC6 = 19;
	mov	dptr,#(_dmaConfig + 0x0006)
	mov	a,#0x13
	movx	@dptr,a
	C$master_wixel.c$81$1$1 ==.
;	apps/master_wixel/master_wixel.c:81: dmaConfig.radio.SRCADDRH = (unsigned int)txPacket >> 8;
	mov	r6,#_txPacket
	mov	r7,#(_txPacket >> 8)
	mov	ar6,r7
	mov	dptr,#_dmaConfig
	mov	a,r6
	movx	@dptr,a
	C$master_wixel.c$82$1$1 ==.
;	apps/master_wixel/master_wixel.c:82: dmaConfig.radio.SRCADDRL = (unsigned int)txPacket;
	mov	r6,#_txPacket
	mov	r7,#(_txPacket >> 8)
	mov	dptr,#(_dmaConfig + 0x0001)
	mov	a,r6
	movx	@dptr,a
	C$master_wixel.c$83$1$1 ==.
;	apps/master_wixel/master_wixel.c:83: dmaConfig.radio.DESTADDRH = XDATA_SFR_ADDRESS(RFD) >> 8;
	mov	r6,#_RFD
	mov	r7,#0x00
	mov	a,#0xDF
	add	a,r7
	mov	r6,a
	mov	dptr,#(_dmaConfig + 0x0002)
	mov	a,r6
	movx	@dptr,a
	C$master_wixel.c$84$1$1 ==.
;	apps/master_wixel/master_wixel.c:84: dmaConfig.radio.DESTADDRL = XDATA_SFR_ADDRESS(RFD);
	mov	r6,#_RFD
	mov	dptr,#(_dmaConfig + 0x0003)
	mov	a,r6
	movx	@dptr,a
	C$master_wixel.c$85$1$1 ==.
;	apps/master_wixel/master_wixel.c:85: dmaConfig.radio.LENL = 1 + RADIO_PACKET_SIZE;
	mov	dptr,#(_dmaConfig + 0x0005)
	mov	a,#0x11
	movx	@dptr,a
	C$master_wixel.c$86$1$1 ==.
;	apps/master_wixel/master_wixel.c:86: dmaConfig.radio.VLEN_LENH = 0b00100000;
	mov	dptr,#(_dmaConfig + 0x0004)
	mov	a,#0x20
	movx	@dptr,a
	C$master_wixel.c$87$1$1 ==.
;	apps/master_wixel/master_wixel.c:87: dmaConfig.radio.DC7 = 0x40;
	mov	dptr,#(_dmaConfig + 0x0007)
	mov	a,#0x40
	movx	@dptr,a
	C$master_wixel.c$89$1$1 ==.
;	apps/master_wixel/master_wixel.c:89: txPacket[0] = RADIO_PACKET_SIZE;
	mov	dptr,#_txPacket
	mov	a,#0x10
	movx	@dptr,a
	C$master_wixel.c$91$1$1 ==.
;	apps/master_wixel/master_wixel.c:91: RFST = 4;  // Switch to IDLE
	mov	_RFST,#0x04
	C$master_wixel.c$92$1$1 ==.
	XG$radioInit$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'sendRadioPacket'
;------------------------------------------------------------
	G$sendRadioPacket$0$0 ==.
	C$master_wixel.c$97$1$1 ==.
;	apps/master_wixel/master_wixel.c:97: void sendRadioPacket()
;	-----------------------------------------
;	 function sendRadioPacket
;	-----------------------------------------
_sendRadioPacket:
	C$master_wixel.c$99$1$1 ==.
;	apps/master_wixel/master_wixel.c:99: if (MARCSTATE == 1)  // Radio must be in IDLE state
	mov	dptr,#_MARCSTATE
	movx	a,@dptr
	mov	r7,a
	cjne	r7,#0x01,00103$
	C$master_wixel.c$101$2$2 ==.
;	apps/master_wixel/master_wixel.c:101: RFIF &= ~(1<<4);
	mov	r7,_RFIF
	anl	ar7,#0xEF
	mov	_RFIF,r7
	C$master_wixel.c$102$2$2 ==.
;	apps/master_wixel/master_wixel.c:102: DMAARM |= (1<<DMA_CHANNEL_RADIO);
	orl	_DMAARM,#0x02
	C$master_wixel.c$103$2$2 ==.
;	apps/master_wixel/master_wixel.c:103: RFST = 3;  // Switch to TX
	mov	_RFST,#0x03
	C$master_wixel.c$106$2$2 ==.
;	apps/master_wixel/master_wixel.c:106: radioTxPulseActive = 1;
	setb	_radioTxPulseActive
	C$master_wixel.c$107$2$2 ==.
;	apps/master_wixel/master_wixel.c:107: radioTxPulseStart = (uint16)getMs();
	lcall	_getMs
	mov	r4,dpl
	mov	r5,dph
	mov	r6,b
	mov	r7,a
	mov	r0,#_radioTxPulseStart
	mov	a,r4
	movx	@r0,a
	inc	r0
	mov	a,r5
	movx	@r0,a
00103$:
	C$master_wixel.c$109$2$1 ==.
	XG$sendRadioPacket$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'updateLeds'
;------------------------------------------------------------
	G$updateLeds$0$0 ==.
	C$master_wixel.c$114$2$1 ==.
;	apps/master_wixel/master_wixel.c:114: void updateLeds()
;	-----------------------------------------
;	 function updateLeds
;	-----------------------------------------
_updateLeds:
	C$master_wixel.c$116$1$1 ==.
;	apps/master_wixel/master_wixel.c:116: uint16 now = (uint16)getMs();
	lcall	_getMs
	mov	r4,dpl
	mov	r5,dph
	mov	r6,b
	mov	r7,a
	C$master_wixel.c$119$1$1 ==.
;	apps/master_wixel/master_wixel.c:119: if (serialRxPulseActive)
	jnb	_serialRxPulseActive,00105$
	C$master_wixel.c$121$2$2 ==.
;	apps/master_wixel/master_wixel.c:121: if ((uint16)(now - serialRxPulseStart) < SERIAL_RX_PULSE)
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
	C$master_wixel.c$123$4$4 ==.
;	apps/master_wixel/master_wixel.c:123: LED_RED(1);
	orl	_P2DIR,#0x02
	sjmp	00106$
00102$:
	C$master_wixel.c$127$4$6 ==.
;	apps/master_wixel/master_wixel.c:127: LED_RED(0);
	mov	r7,_P2DIR
	anl	ar7,#0xFD
	mov	_P2DIR,r7
	C$master_wixel.c$128$3$5 ==.
;	apps/master_wixel/master_wixel.c:128: serialRxPulseActive = 0;
	clr	_serialRxPulseActive
	sjmp	00106$
00105$:
	C$master_wixel.c$133$3$8 ==.
;	apps/master_wixel/master_wixel.c:133: LED_RED(0);
	mov	r7,_P2DIR
	anl	ar7,#0xFD
	mov	_P2DIR,r7
00106$:
	C$master_wixel.c$137$1$1 ==.
;	apps/master_wixel/master_wixel.c:137: if (radioTxPulseActive)
	jnb	_radioTxPulseActive,00111$
	C$master_wixel.c$139$2$9 ==.
;	apps/master_wixel/master_wixel.c:139: if ((uint16)(now - radioTxPulseStart) < RADIO_TX_PULSE)
	mov	r0,#_radioTxPulseStart
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
	mov	r5,a
	clr	c
	mov	a,r4
	subb	a,#0x64
	mov	a,r5
	subb	a,#0x00
	jnc	00108$
	C$master_wixel.c$141$4$11 ==.
;	apps/master_wixel/master_wixel.c:141: LED_GREEN(1);
	orl	_P2DIR,#0x10
	sjmp	00112$
00108$:
	C$master_wixel.c$145$4$13 ==.
;	apps/master_wixel/master_wixel.c:145: LED_GREEN(0);
	mov	r7,_P2DIR
	anl	ar7,#0xEF
	mov	_P2DIR,r7
	C$master_wixel.c$146$3$12 ==.
;	apps/master_wixel/master_wixel.c:146: radioTxPulseActive = 0;
	clr	_radioTxPulseActive
	sjmp	00112$
00111$:
	C$master_wixel.c$151$3$15 ==.
;	apps/master_wixel/master_wixel.c:151: LED_GREEN(0);
	mov	r7,_P2DIR
	anl	ar7,#0xEF
	mov	_P2DIR,r7
00112$:
	C$master_wixel.c$155$2$16 ==.
;	apps/master_wixel/master_wixel.c:155: LED_YELLOW_TOGGLE();
	xrl	_P2DIR,#0x04
	C$master_wixel.c$156$2$16 ==.
	XG$updateLeds$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'processSerialByte'
;------------------------------------------------------------
	G$processSerialByte$0$0 ==.
	C$master_wixel.c$162$2$16 ==.
;	apps/master_wixel/master_wixel.c:162: void processSerialByte(uint8 byteReceived)
;	-----------------------------------------
;	 function processSerialByte
;	-----------------------------------------
_processSerialByte:
	mov	r7,dpl
	C$master_wixel.c$167$1$1 ==.
;	apps/master_wixel/master_wixel.c:167: if (byteReceived >= '0' && byteReceived <= '9')
	cjne	r7,#0x30,00109$
00109$:
	jc	00102$
	mov	a,r7
	add	a,#0xff - 0x39
	jc	00102$
	C$master_wixel.c$169$2$2 ==.
;	apps/master_wixel/master_wixel.c:169: state = (byteReceived - '0') % 4;
	mov	ar5,r7
	mov	r6,#0x00
	mov	a,r5
	add	a,#0xD0
	mov	dpl,a
	mov	a,r6
	addc	a,#0xFF
	mov	dph,a
	mov	r0,#__modsint_PARM_2
	mov	a,#0x04
	movx	@r0,a
	inc	r0
	clr	a
	movx	@r0,a
	lcall	__modsint
	mov	r5,dpl
	mov	r6,dph
	mov	r0,#_state
	mov	a,r5
	movx	@r0,a
	sjmp	00103$
00102$:
	C$master_wixel.c$174$2$3 ==.
;	apps/master_wixel/master_wixel.c:174: state = byteReceived % 4;
	mov	r0,#_state
	mov	a,#0x03
	anl	a,r7
	movx	@r0,a
00103$:
	C$master_wixel.c$178$1$1 ==.
;	apps/master_wixel/master_wixel.c:178: responseLength = sprintf(serialResponse, "State=%d\r\n", state);
	mov	r0,#_state
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
	mov	r0,#_usbComTxSend_PARM_2
	mov	a,r6
	movx	@r0,a
	C$master_wixel.c$179$1$1 ==.
;	apps/master_wixel/master_wixel.c:179: usbComTxSend(serialResponse, responseLength);
	mov	dptr,#_serialResponse
	lcall	_usbComTxSend
	C$master_wixel.c$182$1$1 ==.
;	apps/master_wixel/master_wixel.c:182: serialRxPulseActive = 1;
	setb	_serialRxPulseActive
	C$master_wixel.c$183$1$1 ==.
;	apps/master_wixel/master_wixel.c:183: serialRxPulseStart = (uint16)getMs();
	lcall	_getMs
	mov	r4,dpl
	mov	r5,dph
	mov	r0,#_serialRxPulseStart
	mov	a,r4
	movx	@r0,a
	inc	r0
	mov	a,r5
	movx	@r0,a
	C$master_wixel.c$184$1$1 ==.
	XG$processSerialByte$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'processBytesFromUsb'
;------------------------------------------------------------
	G$processBytesFromUsb$0$0 ==.
	C$master_wixel.c$189$1$1 ==.
;	apps/master_wixel/master_wixel.c:189: void processBytesFromUsb()
;	-----------------------------------------
;	 function processBytesFromUsb
;	-----------------------------------------
_processBytesFromUsb:
	C$master_wixel.c$191$1$1 ==.
;	apps/master_wixel/master_wixel.c:191: uint8 bytesAvailable = usbComRxAvailable();
	lcall	_usbComRxAvailable
	mov	r7,dpl
	C$master_wixel.c$192$1$1 ==.
;	apps/master_wixel/master_wixel.c:192: while(bytesAvailable && usbComTxAvailable() >= 32)
00102$:
	mov	a,r7
	jz	00105$
	push	ar7
	lcall	_usbComTxAvailable
	mov	r6,dpl
	pop	ar7
	cjne	r6,#0x20,00112$
00112$:
	jc	00105$
	C$master_wixel.c$194$2$2 ==.
;	apps/master_wixel/master_wixel.c:194: processSerialByte(usbComRxReceiveByte());
	push	ar7
	lcall	_usbComRxReceiveByte
	lcall	_processSerialByte
	pop	ar7
	C$master_wixel.c$195$2$2 ==.
;	apps/master_wixel/master_wixel.c:195: bytesAvailable--;
	dec	r7
	sjmp	00102$
00105$:
	C$master_wixel.c$197$1$1 ==.
	XG$processBytesFromUsb$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'preparePacket'
;------------------------------------------------------------
	G$preparePacket$0$0 ==.
	C$master_wixel.c$202$1$1 ==.
;	apps/master_wixel/master_wixel.c:202: void preparePacket()
;	-----------------------------------------
;	 function preparePacket
;	-----------------------------------------
_preparePacket:
	C$master_wixel.c$204$1$1 ==.
;	apps/master_wixel/master_wixel.c:204: switch(state)
	mov	r0,#_state
	clr	c
	movx	a,@r0
	mov	b,a
	mov	a,#0x03
	subb	a,b
	jnc	00109$
	ljmp	00106$
00109$:
	mov	r0,#_state
	movx	a,@r0
	mov	b,#0x03
	mul	ab
	mov	dptr,#00110$
	jmp	@a+dptr
00110$:
	ljmp	00101$
	ljmp	00102$
	ljmp	00103$
	ljmp	00104$
	C$master_wixel.c$206$2$2 ==.
;	apps/master_wixel/master_wixel.c:206: case STATE_RED_GREEN:
00101$:
	C$master_wixel.c$208$2$2 ==.
;	apps/master_wixel/master_wixel.c:208: txPacket[1]  = SLAVE_1_ADDRESS;
	mov	dptr,#(_txPacket + 0x0001)
	mov	a,#0x01
	movx	@dptr,a
	C$master_wixel.c$209$2$2 ==.
;	apps/master_wixel/master_wixel.c:209: txPacket[2]  = 0x00;
	mov	dptr,#(_txPacket + 0x0002)
	C$master_wixel.c$210$2$2 ==.
;	apps/master_wixel/master_wixel.c:210: txPacket[3]  = 0x00;
	clr	a
	movx	@dptr,a
	mov	dptr,#(_txPacket + 0x0003)
	movx	@dptr,a
	C$master_wixel.c$211$2$2 ==.
;	apps/master_wixel/master_wixel.c:211: txPacket[4]  = CMD_SET_LED;
	mov	dptr,#(_txPacket + 0x0004)
	mov	a,#0x01
	movx	@dptr,a
	C$master_wixel.c$212$2$2 ==.
;	apps/master_wixel/master_wixel.c:212: txPacket[5]  = 255;
	mov	dptr,#(_txPacket + 0x0005)
	mov	a,#0xFF
	movx	@dptr,a
	C$master_wixel.c$213$2$2 ==.
;	apps/master_wixel/master_wixel.c:213: txPacket[6]  = 0;
	mov	dptr,#(_txPacket + 0x0006)
	C$master_wixel.c$214$2$2 ==.
;	apps/master_wixel/master_wixel.c:214: txPacket[7]  = 0;
	clr	a
	movx	@dptr,a
	mov	dptr,#(_txPacket + 0x0007)
	movx	@dptr,a
	C$master_wixel.c$215$2$2 ==.
;	apps/master_wixel/master_wixel.c:215: txPacket[8]  = MESSAGE_DELIMITER;
	mov	dptr,#(_txPacket + 0x0008)
	mov	a,#0xFF
	movx	@dptr,a
	C$master_wixel.c$217$2$2 ==.
;	apps/master_wixel/master_wixel.c:217: txPacket[9]  = SLAVE_2_ADDRESS;
	mov	dptr,#(_txPacket + 0x0009)
	mov	a,#0x02
	movx	@dptr,a
	C$master_wixel.c$218$2$2 ==.
;	apps/master_wixel/master_wixel.c:218: txPacket[10] = 0x00;
	mov	dptr,#(_txPacket + 0x000a)
	C$master_wixel.c$219$2$2 ==.
;	apps/master_wixel/master_wixel.c:219: txPacket[11] = 0x00;
	clr	a
	movx	@dptr,a
	mov	dptr,#(_txPacket + 0x000b)
	movx	@dptr,a
	C$master_wixel.c$220$2$2 ==.
;	apps/master_wixel/master_wixel.c:220: txPacket[12] = CMD_SET_LED;
	mov	dptr,#(_txPacket + 0x000c)
	mov	a,#0x01
	movx	@dptr,a
	C$master_wixel.c$221$2$2 ==.
;	apps/master_wixel/master_wixel.c:221: txPacket[13] = 0;
	mov	dptr,#(_txPacket + 0x000d)
	clr	a
	movx	@dptr,a
	C$master_wixel.c$222$2$2 ==.
;	apps/master_wixel/master_wixel.c:222: txPacket[14] = 255;
	mov	dptr,#(_txPacket + 0x000e)
	mov	a,#0xFF
	movx	@dptr,a
	C$master_wixel.c$223$2$2 ==.
;	apps/master_wixel/master_wixel.c:223: txPacket[15] = 0;
	mov	dptr,#(_txPacket + 0x000f)
	clr	a
	movx	@dptr,a
	C$master_wixel.c$224$2$2 ==.
;	apps/master_wixel/master_wixel.c:224: txPacket[16] = MESSAGE_DELIMITER;
	mov	dptr,#(_txPacket + 0x0010)
	mov	a,#0xFF
	movx	@dptr,a
	C$master_wixel.c$225$2$2 ==.
;	apps/master_wixel/master_wixel.c:225: break;
	ljmp	00106$
	C$master_wixel.c$227$2$2 ==.
;	apps/master_wixel/master_wixel.c:227: case STATE_OFF_1:
00102$:
	C$master_wixel.c$229$2$2 ==.
;	apps/master_wixel/master_wixel.c:229: txPacket[1]  = SLAVE_1_ADDRESS;
	mov	dptr,#(_txPacket + 0x0001)
	mov	a,#0x01
	movx	@dptr,a
	C$master_wixel.c$230$2$2 ==.
;	apps/master_wixel/master_wixel.c:230: txPacket[2]  = 0x00;
	mov	dptr,#(_txPacket + 0x0002)
	C$master_wixel.c$231$2$2 ==.
;	apps/master_wixel/master_wixel.c:231: txPacket[3]  = 0x00;
	clr	a
	movx	@dptr,a
	mov	dptr,#(_txPacket + 0x0003)
	movx	@dptr,a
	C$master_wixel.c$232$2$2 ==.
;	apps/master_wixel/master_wixel.c:232: txPacket[4]  = CMD_SET_LED;
	mov	dptr,#(_txPacket + 0x0004)
	mov	a,#0x01
	movx	@dptr,a
	C$master_wixel.c$233$2$2 ==.
;	apps/master_wixel/master_wixel.c:233: txPacket[5]  = 0;
	mov	dptr,#(_txPacket + 0x0005)
	C$master_wixel.c$234$2$2 ==.
;	apps/master_wixel/master_wixel.c:234: txPacket[6]  = 0;
	C$master_wixel.c$235$2$2 ==.
;	apps/master_wixel/master_wixel.c:235: txPacket[7]  = 0;
	clr	a
	movx	@dptr,a
	mov	dptr,#(_txPacket + 0x0006)
	movx	@dptr,a
	mov	dptr,#(_txPacket + 0x0007)
	movx	@dptr,a
	C$master_wixel.c$236$2$2 ==.
;	apps/master_wixel/master_wixel.c:236: txPacket[8]  = MESSAGE_DELIMITER;
	mov	dptr,#(_txPacket + 0x0008)
	mov	a,#0xFF
	movx	@dptr,a
	C$master_wixel.c$238$2$2 ==.
;	apps/master_wixel/master_wixel.c:238: txPacket[9]  = SLAVE_2_ADDRESS;
	mov	dptr,#(_txPacket + 0x0009)
	mov	a,#0x02
	movx	@dptr,a
	C$master_wixel.c$239$2$2 ==.
;	apps/master_wixel/master_wixel.c:239: txPacket[10] = 0x00;
	mov	dptr,#(_txPacket + 0x000a)
	C$master_wixel.c$240$2$2 ==.
;	apps/master_wixel/master_wixel.c:240: txPacket[11] = 0x00;
	clr	a
	movx	@dptr,a
	mov	dptr,#(_txPacket + 0x000b)
	movx	@dptr,a
	C$master_wixel.c$241$2$2 ==.
;	apps/master_wixel/master_wixel.c:241: txPacket[12] = CMD_SET_LED;
	mov	dptr,#(_txPacket + 0x000c)
	mov	a,#0x01
	movx	@dptr,a
	C$master_wixel.c$242$2$2 ==.
;	apps/master_wixel/master_wixel.c:242: txPacket[13] = 0;
	mov	dptr,#(_txPacket + 0x000d)
	C$master_wixel.c$243$2$2 ==.
;	apps/master_wixel/master_wixel.c:243: txPacket[14] = 0;
	C$master_wixel.c$244$2$2 ==.
;	apps/master_wixel/master_wixel.c:244: txPacket[15] = 0;
	clr	a
	movx	@dptr,a
	mov	dptr,#(_txPacket + 0x000e)
	movx	@dptr,a
	mov	dptr,#(_txPacket + 0x000f)
	movx	@dptr,a
	C$master_wixel.c$245$2$2 ==.
;	apps/master_wixel/master_wixel.c:245: txPacket[16] = MESSAGE_DELIMITER;
	mov	dptr,#(_txPacket + 0x0010)
	mov	a,#0xFF
	movx	@dptr,a
	C$master_wixel.c$246$2$2 ==.
;	apps/master_wixel/master_wixel.c:246: break;
	ljmp	00106$
	C$master_wixel.c$248$2$2 ==.
;	apps/master_wixel/master_wixel.c:248: case STATE_BLUE_YELLOW:
00103$:
	C$master_wixel.c$250$2$2 ==.
;	apps/master_wixel/master_wixel.c:250: txPacket[1]  = SLAVE_1_ADDRESS;
	mov	dptr,#(_txPacket + 0x0001)
	mov	a,#0x01
	movx	@dptr,a
	C$master_wixel.c$251$2$2 ==.
;	apps/master_wixel/master_wixel.c:251: txPacket[2]  = 0x00;
	mov	dptr,#(_txPacket + 0x0002)
	C$master_wixel.c$252$2$2 ==.
;	apps/master_wixel/master_wixel.c:252: txPacket[3]  = 0x00;
	clr	a
	movx	@dptr,a
	mov	dptr,#(_txPacket + 0x0003)
	movx	@dptr,a
	C$master_wixel.c$253$2$2 ==.
;	apps/master_wixel/master_wixel.c:253: txPacket[4]  = CMD_SET_LED;
	mov	dptr,#(_txPacket + 0x0004)
	mov	a,#0x01
	movx	@dptr,a
	C$master_wixel.c$254$2$2 ==.
;	apps/master_wixel/master_wixel.c:254: txPacket[5]  = 0;
	mov	dptr,#(_txPacket + 0x0005)
	C$master_wixel.c$255$2$2 ==.
;	apps/master_wixel/master_wixel.c:255: txPacket[6]  = 0;
	clr	a
	movx	@dptr,a
	mov	dptr,#(_txPacket + 0x0006)
	movx	@dptr,a
	C$master_wixel.c$256$2$2 ==.
;	apps/master_wixel/master_wixel.c:256: txPacket[7]  = 255;
	mov	dptr,#(_txPacket + 0x0007)
	mov	a,#0xFF
	movx	@dptr,a
	C$master_wixel.c$257$2$2 ==.
;	apps/master_wixel/master_wixel.c:257: txPacket[8]  = MESSAGE_DELIMITER;
	mov	dptr,#(_txPacket + 0x0008)
	mov	a,#0xFF
	movx	@dptr,a
	C$master_wixel.c$259$2$2 ==.
;	apps/master_wixel/master_wixel.c:259: txPacket[9]  = SLAVE_2_ADDRESS;
	mov	dptr,#(_txPacket + 0x0009)
	mov	a,#0x02
	movx	@dptr,a
	C$master_wixel.c$260$2$2 ==.
;	apps/master_wixel/master_wixel.c:260: txPacket[10] = 0x00;
	mov	dptr,#(_txPacket + 0x000a)
	C$master_wixel.c$261$2$2 ==.
;	apps/master_wixel/master_wixel.c:261: txPacket[11] = 0x00;
	clr	a
	movx	@dptr,a
	mov	dptr,#(_txPacket + 0x000b)
	movx	@dptr,a
	C$master_wixel.c$262$2$2 ==.
;	apps/master_wixel/master_wixel.c:262: txPacket[12] = CMD_SET_LED;
	mov	dptr,#(_txPacket + 0x000c)
	mov	a,#0x01
	movx	@dptr,a
	C$master_wixel.c$263$2$2 ==.
;	apps/master_wixel/master_wixel.c:263: txPacket[13] = 255;
	mov	dptr,#(_txPacket + 0x000d)
	mov	a,#0xFF
	movx	@dptr,a
	C$master_wixel.c$264$2$2 ==.
;	apps/master_wixel/master_wixel.c:264: txPacket[14] = 255;
	mov	dptr,#(_txPacket + 0x000e)
	mov	a,#0xFF
	movx	@dptr,a
	C$master_wixel.c$265$2$2 ==.
;	apps/master_wixel/master_wixel.c:265: txPacket[15] = 0;
	mov	dptr,#(_txPacket + 0x000f)
	clr	a
	movx	@dptr,a
	C$master_wixel.c$266$2$2 ==.
;	apps/master_wixel/master_wixel.c:266: txPacket[16] = MESSAGE_DELIMITER;
	mov	dptr,#(_txPacket + 0x0010)
	mov	a,#0xFF
	movx	@dptr,a
	C$master_wixel.c$267$2$2 ==.
;	apps/master_wixel/master_wixel.c:267: break;
	C$master_wixel.c$269$2$2 ==.
;	apps/master_wixel/master_wixel.c:269: case STATE_OFF_2:
	sjmp	00106$
00104$:
	C$master_wixel.c$271$2$2 ==.
;	apps/master_wixel/master_wixel.c:271: txPacket[1]  = SLAVE_1_ADDRESS;
	mov	dptr,#(_txPacket + 0x0001)
	mov	a,#0x01
	movx	@dptr,a
	C$master_wixel.c$272$2$2 ==.
;	apps/master_wixel/master_wixel.c:272: txPacket[2]  = 0x00;
	mov	dptr,#(_txPacket + 0x0002)
	C$master_wixel.c$273$2$2 ==.
;	apps/master_wixel/master_wixel.c:273: txPacket[3]  = 0x00;
	clr	a
	movx	@dptr,a
	mov	dptr,#(_txPacket + 0x0003)
	movx	@dptr,a
	C$master_wixel.c$274$2$2 ==.
;	apps/master_wixel/master_wixel.c:274: txPacket[4]  = CMD_SET_LED;
	mov	dptr,#(_txPacket + 0x0004)
	mov	a,#0x01
	movx	@dptr,a
	C$master_wixel.c$275$2$2 ==.
;	apps/master_wixel/master_wixel.c:275: txPacket[5]  = 0;
	mov	dptr,#(_txPacket + 0x0005)
	C$master_wixel.c$276$2$2 ==.
;	apps/master_wixel/master_wixel.c:276: txPacket[6]  = 0;
	C$master_wixel.c$277$2$2 ==.
;	apps/master_wixel/master_wixel.c:277: txPacket[7]  = 0;
	clr	a
	movx	@dptr,a
	mov	dptr,#(_txPacket + 0x0006)
	movx	@dptr,a
	mov	dptr,#(_txPacket + 0x0007)
	movx	@dptr,a
	C$master_wixel.c$278$2$2 ==.
;	apps/master_wixel/master_wixel.c:278: txPacket[8]  = MESSAGE_DELIMITER;
	mov	dptr,#(_txPacket + 0x0008)
	mov	a,#0xFF
	movx	@dptr,a
	C$master_wixel.c$280$2$2 ==.
;	apps/master_wixel/master_wixel.c:280: txPacket[9]  = SLAVE_2_ADDRESS;
	mov	dptr,#(_txPacket + 0x0009)
	mov	a,#0x02
	movx	@dptr,a
	C$master_wixel.c$281$2$2 ==.
;	apps/master_wixel/master_wixel.c:281: txPacket[10] = 0x00;
	mov	dptr,#(_txPacket + 0x000a)
	C$master_wixel.c$282$2$2 ==.
;	apps/master_wixel/master_wixel.c:282: txPacket[11] = 0x00;
	clr	a
	movx	@dptr,a
	mov	dptr,#(_txPacket + 0x000b)
	movx	@dptr,a
	C$master_wixel.c$283$2$2 ==.
;	apps/master_wixel/master_wixel.c:283: txPacket[12] = CMD_SET_LED;
	mov	dptr,#(_txPacket + 0x000c)
	mov	a,#0x01
	movx	@dptr,a
	C$master_wixel.c$284$2$2 ==.
;	apps/master_wixel/master_wixel.c:284: txPacket[13] = 0;
	mov	dptr,#(_txPacket + 0x000d)
	C$master_wixel.c$285$2$2 ==.
;	apps/master_wixel/master_wixel.c:285: txPacket[14] = 0;
	C$master_wixel.c$286$2$2 ==.
;	apps/master_wixel/master_wixel.c:286: txPacket[15] = 0;
	clr	a
	movx	@dptr,a
	mov	dptr,#(_txPacket + 0x000e)
	movx	@dptr,a
	mov	dptr,#(_txPacket + 0x000f)
	movx	@dptr,a
	C$master_wixel.c$287$2$2 ==.
;	apps/master_wixel/master_wixel.c:287: txPacket[16] = MESSAGE_DELIMITER;
	mov	dptr,#(_txPacket + 0x0010)
	mov	a,#0xFF
	movx	@dptr,a
	C$master_wixel.c$289$1$1 ==.
;	apps/master_wixel/master_wixel.c:289: }
00106$:
	C$master_wixel.c$290$1$1 ==.
	XG$preparePacket$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'main'
;------------------------------------------------------------
	G$main$0$0 ==.
	C$master_wixel.c$295$1$1 ==.
;	apps/master_wixel/master_wixel.c:295: void main()
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
	C$master_wixel.c$297$1$1 ==.
;	apps/master_wixel/master_wixel.c:297: systemInit();
	lcall	_systemInit
	C$master_wixel.c$298$1$1 ==.
;	apps/master_wixel/master_wixel.c:298: usbInit();
	lcall	_usbInit
	C$master_wixel.c$299$1$1 ==.
;	apps/master_wixel/master_wixel.c:299: radioInit();
	lcall	_radioInit
	C$master_wixel.c$301$1$1 ==.
;	apps/master_wixel/master_wixel.c:301: state = STATE_RED_GREEN;
	mov	r0,#_state
	clr	a
	movx	@r0,a
	C$master_wixel.c$302$1$1 ==.
;	apps/master_wixel/master_wixel.c:302: lastTxTime = getMs();
	lcall	_getMs
	mov	r4,dpl
	mov	r5,dph
	mov	r6,b
	mov	r7,a
	mov	r0,#_lastTxTime
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
	C$master_wixel.c$304$1$1 ==.
;	apps/master_wixel/master_wixel.c:304: while(1)
00104$:
	C$master_wixel.c$306$2$2 ==.
;	apps/master_wixel/master_wixel.c:306: boardService();
	lcall	_boardService
	C$master_wixel.c$307$2$2 ==.
;	apps/master_wixel/master_wixel.c:307: usbComService();
	lcall	_usbComService
	C$master_wixel.c$310$2$2 ==.
;	apps/master_wixel/master_wixel.c:310: processBytesFromUsb();
	lcall	_processBytesFromUsb
	C$master_wixel.c$313$2$2 ==.
;	apps/master_wixel/master_wixel.c:313: updateLeds();
	lcall	_updateLeds
	C$master_wixel.c$316$2$2 ==.
;	apps/master_wixel/master_wixel.c:316: if (getMs() - lastTxTime >= PACKET_INTERVAL)
	lcall	_getMs
	mov	r4,dpl
	mov	r5,dph
	mov	r6,b
	mov	r7,a
	mov	r0,#_lastTxTime
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
	clr	c
	mov	a,r4
	subb	a,#0xE8
	mov	a,r5
	subb	a,#0x03
	mov	a,r6
	subb	a,#0x00
	mov	a,r7
	subb	a,#0x00
	jc	00104$
	C$master_wixel.c$318$3$3 ==.
;	apps/master_wixel/master_wixel.c:318: lastTxTime = getMs();
	lcall	_getMs
	mov	r4,dpl
	mov	r5,dph
	mov	r6,b
	mov	r7,a
	mov	r0,#_lastTxTime
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
	C$master_wixel.c$319$3$3 ==.
;	apps/master_wixel/master_wixel.c:319: preparePacket();
	lcall	_preparePacket
	C$master_wixel.c$320$3$3 ==.
;	apps/master_wixel/master_wixel.c:320: sendRadioPacket();
	lcall	_sendRadioPacket
	sjmp	00104$
	C$master_wixel.c$323$1$1 ==.
	XG$main$0$0 ==.
	ret
	.area CSEG    (CODE)
	.area CONST   (CODE)
Fmaster_wixel$_str_0$0$0 == .
__str_0:
	.ascii "State=%d"
	.db 0x0D
	.db 0x0A
	.db 0x00
	.area XINIT   (CODE)
	.area CABS    (ABS,CODE)
