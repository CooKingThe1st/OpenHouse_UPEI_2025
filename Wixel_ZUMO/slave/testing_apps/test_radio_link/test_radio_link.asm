;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.1.0 #7066 (Nov 22 2011) (MINGW32)
; This file was generated Thu Oct 23 16:10:57 2025
;--------------------------------------------------------
	.module test_radio_link
	.optsdcc -mmcs51 --model-medium
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _handleCommands
	.globl _radioToUsb
	.globl _nibbleToAscii
	.globl _updateLeds
	.globl _sprintf
	.globl _radioLinkConnected
	.globl _radioLinkRxDoneWithPacket
	.globl _radioLinkRxCurrentPayloadType
	.globl _radioLinkRxCurrentPacket
	.globl _radioLinkTxSendPacket
	.globl _radioLinkTxCurrentPacket
	.globl _radioLinkInit
	.globl _usbComTxSend
	.globl _usbComTxAvailable
	.globl _usbComRxReceiveByte
	.globl _usbComRxAvailable
	.globl _usbComService
	.globl _usbShowStatusWithGreenLed
	.globl _usbInit
	.globl _randomSeedFromAdc
	.globl _boardService
	.globl _systemInit
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area RSEG    (ABS,DATA)
	.org 0x0000
Ftest_radio_link$P0$0$0 == 0x0080
_P0	=	0x0080
Ftest_radio_link$SP$0$0 == 0x0081
_SP	=	0x0081
Ftest_radio_link$DPL0$0$0 == 0x0082
_DPL0	=	0x0082
Ftest_radio_link$DPH0$0$0 == 0x0083
_DPH0	=	0x0083
Ftest_radio_link$DPL1$0$0 == 0x0084
_DPL1	=	0x0084
Ftest_radio_link$DPH1$0$0 == 0x0085
_DPH1	=	0x0085
Ftest_radio_link$U0CSR$0$0 == 0x0086
_U0CSR	=	0x0086
Ftest_radio_link$PCON$0$0 == 0x0087
_PCON	=	0x0087
Ftest_radio_link$TCON$0$0 == 0x0088
_TCON	=	0x0088
Ftest_radio_link$P0IFG$0$0 == 0x0089
_P0IFG	=	0x0089
Ftest_radio_link$P1IFG$0$0 == 0x008a
_P1IFG	=	0x008a
Ftest_radio_link$P2IFG$0$0 == 0x008b
_P2IFG	=	0x008b
Ftest_radio_link$PICTL$0$0 == 0x008c
_PICTL	=	0x008c
Ftest_radio_link$P1IEN$0$0 == 0x008d
_P1IEN	=	0x008d
Ftest_radio_link$P0INP$0$0 == 0x008f
_P0INP	=	0x008f
Ftest_radio_link$P1$0$0 == 0x0090
_P1	=	0x0090
Ftest_radio_link$RFIM$0$0 == 0x0091
_RFIM	=	0x0091
Ftest_radio_link$DPS$0$0 == 0x0092
_DPS	=	0x0092
Ftest_radio_link$MPAGE$0$0 == 0x0093
_MPAGE	=	0x0093
Ftest_radio_link$ENDIAN$0$0 == 0x0095
_ENDIAN	=	0x0095
Ftest_radio_link$S0CON$0$0 == 0x0098
_S0CON	=	0x0098
Ftest_radio_link$IEN2$0$0 == 0x009a
_IEN2	=	0x009a
Ftest_radio_link$S1CON$0$0 == 0x009b
_S1CON	=	0x009b
Ftest_radio_link$T2CT$0$0 == 0x009c
_T2CT	=	0x009c
Ftest_radio_link$T2PR$0$0 == 0x009d
_T2PR	=	0x009d
Ftest_radio_link$T2CTL$0$0 == 0x009e
_T2CTL	=	0x009e
Ftest_radio_link$P2$0$0 == 0x00a0
_P2	=	0x00a0
Ftest_radio_link$WORIRQ$0$0 == 0x00a1
_WORIRQ	=	0x00a1
Ftest_radio_link$WORCTRL$0$0 == 0x00a2
_WORCTRL	=	0x00a2
Ftest_radio_link$WOREVT0$0$0 == 0x00a3
_WOREVT0	=	0x00a3
Ftest_radio_link$WOREVT1$0$0 == 0x00a4
_WOREVT1	=	0x00a4
Ftest_radio_link$WORTIME0$0$0 == 0x00a5
_WORTIME0	=	0x00a5
Ftest_radio_link$WORTIME1$0$0 == 0x00a6
_WORTIME1	=	0x00a6
Ftest_radio_link$IEN0$0$0 == 0x00a8
_IEN0	=	0x00a8
Ftest_radio_link$IP0$0$0 == 0x00a9
_IP0	=	0x00a9
Ftest_radio_link$FWT$0$0 == 0x00ab
_FWT	=	0x00ab
Ftest_radio_link$FADDRL$0$0 == 0x00ac
_FADDRL	=	0x00ac
Ftest_radio_link$FADDRH$0$0 == 0x00ad
_FADDRH	=	0x00ad
Ftest_radio_link$FCTL$0$0 == 0x00ae
_FCTL	=	0x00ae
Ftest_radio_link$FWDATA$0$0 == 0x00af
_FWDATA	=	0x00af
Ftest_radio_link$ENCDI$0$0 == 0x00b1
_ENCDI	=	0x00b1
Ftest_radio_link$ENCDO$0$0 == 0x00b2
_ENCDO	=	0x00b2
Ftest_radio_link$ENCCS$0$0 == 0x00b3
_ENCCS	=	0x00b3
Ftest_radio_link$ADCCON1$0$0 == 0x00b4
_ADCCON1	=	0x00b4
Ftest_radio_link$ADCCON2$0$0 == 0x00b5
_ADCCON2	=	0x00b5
Ftest_radio_link$ADCCON3$0$0 == 0x00b6
_ADCCON3	=	0x00b6
Ftest_radio_link$IEN1$0$0 == 0x00b8
_IEN1	=	0x00b8
Ftest_radio_link$IP1$0$0 == 0x00b9
_IP1	=	0x00b9
Ftest_radio_link$ADCL$0$0 == 0x00ba
_ADCL	=	0x00ba
Ftest_radio_link$ADCH$0$0 == 0x00bb
_ADCH	=	0x00bb
Ftest_radio_link$RNDL$0$0 == 0x00bc
_RNDL	=	0x00bc
Ftest_radio_link$RNDH$0$0 == 0x00bd
_RNDH	=	0x00bd
Ftest_radio_link$SLEEP$0$0 == 0x00be
_SLEEP	=	0x00be
Ftest_radio_link$IRCON$0$0 == 0x00c0
_IRCON	=	0x00c0
Ftest_radio_link$U0DBUF$0$0 == 0x00c1
_U0DBUF	=	0x00c1
Ftest_radio_link$U0BAUD$0$0 == 0x00c2
_U0BAUD	=	0x00c2
Ftest_radio_link$U0UCR$0$0 == 0x00c4
_U0UCR	=	0x00c4
Ftest_radio_link$U0GCR$0$0 == 0x00c5
_U0GCR	=	0x00c5
Ftest_radio_link$CLKCON$0$0 == 0x00c6
_CLKCON	=	0x00c6
Ftest_radio_link$MEMCTR$0$0 == 0x00c7
_MEMCTR	=	0x00c7
Ftest_radio_link$WDCTL$0$0 == 0x00c9
_WDCTL	=	0x00c9
Ftest_radio_link$T3CNT$0$0 == 0x00ca
_T3CNT	=	0x00ca
Ftest_radio_link$T3CTL$0$0 == 0x00cb
_T3CTL	=	0x00cb
Ftest_radio_link$T3CCTL0$0$0 == 0x00cc
_T3CCTL0	=	0x00cc
Ftest_radio_link$T3CC0$0$0 == 0x00cd
_T3CC0	=	0x00cd
Ftest_radio_link$T3CCTL1$0$0 == 0x00ce
_T3CCTL1	=	0x00ce
Ftest_radio_link$T3CC1$0$0 == 0x00cf
_T3CC1	=	0x00cf
Ftest_radio_link$PSW$0$0 == 0x00d0
_PSW	=	0x00d0
Ftest_radio_link$DMAIRQ$0$0 == 0x00d1
_DMAIRQ	=	0x00d1
Ftest_radio_link$DMA1CFGL$0$0 == 0x00d2
_DMA1CFGL	=	0x00d2
Ftest_radio_link$DMA1CFGH$0$0 == 0x00d3
_DMA1CFGH	=	0x00d3
Ftest_radio_link$DMA0CFGL$0$0 == 0x00d4
_DMA0CFGL	=	0x00d4
Ftest_radio_link$DMA0CFGH$0$0 == 0x00d5
_DMA0CFGH	=	0x00d5
Ftest_radio_link$DMAARM$0$0 == 0x00d6
_DMAARM	=	0x00d6
Ftest_radio_link$DMAREQ$0$0 == 0x00d7
_DMAREQ	=	0x00d7
Ftest_radio_link$TIMIF$0$0 == 0x00d8
_TIMIF	=	0x00d8
Ftest_radio_link$RFD$0$0 == 0x00d9
_RFD	=	0x00d9
Ftest_radio_link$T1CC0L$0$0 == 0x00da
_T1CC0L	=	0x00da
Ftest_radio_link$T1CC0H$0$0 == 0x00db
_T1CC0H	=	0x00db
Ftest_radio_link$T1CC1L$0$0 == 0x00dc
_T1CC1L	=	0x00dc
Ftest_radio_link$T1CC1H$0$0 == 0x00dd
_T1CC1H	=	0x00dd
Ftest_radio_link$T1CC2L$0$0 == 0x00de
_T1CC2L	=	0x00de
Ftest_radio_link$T1CC2H$0$0 == 0x00df
_T1CC2H	=	0x00df
Ftest_radio_link$ACC$0$0 == 0x00e0
_ACC	=	0x00e0
Ftest_radio_link$RFST$0$0 == 0x00e1
_RFST	=	0x00e1
Ftest_radio_link$T1CNTL$0$0 == 0x00e2
_T1CNTL	=	0x00e2
Ftest_radio_link$T1CNTH$0$0 == 0x00e3
_T1CNTH	=	0x00e3
Ftest_radio_link$T1CTL$0$0 == 0x00e4
_T1CTL	=	0x00e4
Ftest_radio_link$T1CCTL0$0$0 == 0x00e5
_T1CCTL0	=	0x00e5
Ftest_radio_link$T1CCTL1$0$0 == 0x00e6
_T1CCTL1	=	0x00e6
Ftest_radio_link$T1CCTL2$0$0 == 0x00e7
_T1CCTL2	=	0x00e7
Ftest_radio_link$IRCON2$0$0 == 0x00e8
_IRCON2	=	0x00e8
Ftest_radio_link$RFIF$0$0 == 0x00e9
_RFIF	=	0x00e9
Ftest_radio_link$T4CNT$0$0 == 0x00ea
_T4CNT	=	0x00ea
Ftest_radio_link$T4CTL$0$0 == 0x00eb
_T4CTL	=	0x00eb
Ftest_radio_link$T4CCTL0$0$0 == 0x00ec
_T4CCTL0	=	0x00ec
Ftest_radio_link$T4CC0$0$0 == 0x00ed
_T4CC0	=	0x00ed
Ftest_radio_link$T4CCTL1$0$0 == 0x00ee
_T4CCTL1	=	0x00ee
Ftest_radio_link$T4CC1$0$0 == 0x00ef
_T4CC1	=	0x00ef
Ftest_radio_link$B$0$0 == 0x00f0
_B	=	0x00f0
Ftest_radio_link$PERCFG$0$0 == 0x00f1
_PERCFG	=	0x00f1
Ftest_radio_link$ADCCFG$0$0 == 0x00f2
_ADCCFG	=	0x00f2
Ftest_radio_link$P0SEL$0$0 == 0x00f3
_P0SEL	=	0x00f3
Ftest_radio_link$P1SEL$0$0 == 0x00f4
_P1SEL	=	0x00f4
Ftest_radio_link$P2SEL$0$0 == 0x00f5
_P2SEL	=	0x00f5
Ftest_radio_link$P1INP$0$0 == 0x00f6
_P1INP	=	0x00f6
Ftest_radio_link$P2INP$0$0 == 0x00f7
_P2INP	=	0x00f7
Ftest_radio_link$U1CSR$0$0 == 0x00f8
_U1CSR	=	0x00f8
Ftest_radio_link$U1DBUF$0$0 == 0x00f9
_U1DBUF	=	0x00f9
Ftest_radio_link$U1BAUD$0$0 == 0x00fa
_U1BAUD	=	0x00fa
Ftest_radio_link$U1UCR$0$0 == 0x00fb
_U1UCR	=	0x00fb
Ftest_radio_link$U1GCR$0$0 == 0x00fc
_U1GCR	=	0x00fc
Ftest_radio_link$P0DIR$0$0 == 0x00fd
_P0DIR	=	0x00fd
Ftest_radio_link$P1DIR$0$0 == 0x00fe
_P1DIR	=	0x00fe
Ftest_radio_link$P2DIR$0$0 == 0x00ff
_P2DIR	=	0x00ff
Ftest_radio_link$DMA0CFG$0$0 == 0xffffd5d4
_DMA0CFG	=	0xffffd5d4
Ftest_radio_link$DMA1CFG$0$0 == 0xffffd3d2
_DMA1CFG	=	0xffffd3d2
Ftest_radio_link$FADDR$0$0 == 0xffffadac
_FADDR	=	0xffffadac
Ftest_radio_link$ADC$0$0 == 0xffffbbba
_ADC	=	0xffffbbba
Ftest_radio_link$T1CC0$0$0 == 0xffffdbda
_T1CC0	=	0xffffdbda
Ftest_radio_link$T1CC1$0$0 == 0xffffdddc
_T1CC1	=	0xffffdddc
Ftest_radio_link$T1CC2$0$0 == 0xffffdfde
_T1CC2	=	0xffffdfde
;--------------------------------------------------------
; special function bits
;--------------------------------------------------------
	.area RSEG    (ABS,DATA)
	.org 0x0000
Ftest_radio_link$P0_0$0$0 == 0x0080
_P0_0	=	0x0080
Ftest_radio_link$P0_1$0$0 == 0x0081
_P0_1	=	0x0081
Ftest_radio_link$P0_2$0$0 == 0x0082
_P0_2	=	0x0082
Ftest_radio_link$P0_3$0$0 == 0x0083
_P0_3	=	0x0083
Ftest_radio_link$P0_4$0$0 == 0x0084
_P0_4	=	0x0084
Ftest_radio_link$P0_5$0$0 == 0x0085
_P0_5	=	0x0085
Ftest_radio_link$P0_6$0$0 == 0x0086
_P0_6	=	0x0086
Ftest_radio_link$P0_7$0$0 == 0x0087
_P0_7	=	0x0087
Ftest_radio_link$_TCON_0$0$0 == 0x0088
__TCON_0	=	0x0088
Ftest_radio_link$RFTXRXIF$0$0 == 0x0089
_RFTXRXIF	=	0x0089
Ftest_radio_link$_TCON_2$0$0 == 0x008a
__TCON_2	=	0x008a
Ftest_radio_link$URX0IF$0$0 == 0x008b
_URX0IF	=	0x008b
Ftest_radio_link$_TCON_4$0$0 == 0x008c
__TCON_4	=	0x008c
Ftest_radio_link$ADCIF$0$0 == 0x008d
_ADCIF	=	0x008d
Ftest_radio_link$_TCON_6$0$0 == 0x008e
__TCON_6	=	0x008e
Ftest_radio_link$URX1IF$0$0 == 0x008f
_URX1IF	=	0x008f
Ftest_radio_link$P1_0$0$0 == 0x0090
_P1_0	=	0x0090
Ftest_radio_link$P1_1$0$0 == 0x0091
_P1_1	=	0x0091
Ftest_radio_link$P1_2$0$0 == 0x0092
_P1_2	=	0x0092
Ftest_radio_link$P1_3$0$0 == 0x0093
_P1_3	=	0x0093
Ftest_radio_link$P1_4$0$0 == 0x0094
_P1_4	=	0x0094
Ftest_radio_link$P1_5$0$0 == 0x0095
_P1_5	=	0x0095
Ftest_radio_link$P1_6$0$0 == 0x0096
_P1_6	=	0x0096
Ftest_radio_link$P1_7$0$0 == 0x0097
_P1_7	=	0x0097
Ftest_radio_link$ENCIF_0$0$0 == 0x0098
_ENCIF_0	=	0x0098
Ftest_radio_link$ENCIF_1$0$0 == 0x0099
_ENCIF_1	=	0x0099
Ftest_radio_link$_SOCON2$0$0 == 0x009a
__SOCON2	=	0x009a
Ftest_radio_link$_SOCON3$0$0 == 0x009b
__SOCON3	=	0x009b
Ftest_radio_link$_SOCON4$0$0 == 0x009c
__SOCON4	=	0x009c
Ftest_radio_link$_SOCON5$0$0 == 0x009d
__SOCON5	=	0x009d
Ftest_radio_link$_SOCON6$0$0 == 0x009e
__SOCON6	=	0x009e
Ftest_radio_link$_SOCON7$0$0 == 0x009f
__SOCON7	=	0x009f
Ftest_radio_link$P2_0$0$0 == 0x00a0
_P2_0	=	0x00a0
Ftest_radio_link$P2_1$0$0 == 0x00a1
_P2_1	=	0x00a1
Ftest_radio_link$P2_2$0$0 == 0x00a2
_P2_2	=	0x00a2
Ftest_radio_link$P2_3$0$0 == 0x00a3
_P2_3	=	0x00a3
Ftest_radio_link$P2_4$0$0 == 0x00a4
_P2_4	=	0x00a4
Ftest_radio_link$P2_5$0$0 == 0x00a5
_P2_5	=	0x00a5
Ftest_radio_link$P2_6$0$0 == 0x00a6
_P2_6	=	0x00a6
Ftest_radio_link$P2_7$0$0 == 0x00a7
_P2_7	=	0x00a7
Ftest_radio_link$RFTXRXIE$0$0 == 0x00a8
_RFTXRXIE	=	0x00a8
Ftest_radio_link$ADCIE$0$0 == 0x00a9
_ADCIE	=	0x00a9
Ftest_radio_link$URX0IE$0$0 == 0x00aa
_URX0IE	=	0x00aa
Ftest_radio_link$URX1IE$0$0 == 0x00ab
_URX1IE	=	0x00ab
Ftest_radio_link$ENCIE$0$0 == 0x00ac
_ENCIE	=	0x00ac
Ftest_radio_link$STIE$0$0 == 0x00ad
_STIE	=	0x00ad
Ftest_radio_link$_IEN06$0$0 == 0x00ae
__IEN06	=	0x00ae
Ftest_radio_link$EA$0$0 == 0x00af
_EA	=	0x00af
Ftest_radio_link$DMAIE$0$0 == 0x00b8
_DMAIE	=	0x00b8
Ftest_radio_link$T1IE$0$0 == 0x00b9
_T1IE	=	0x00b9
Ftest_radio_link$T2IE$0$0 == 0x00ba
_T2IE	=	0x00ba
Ftest_radio_link$T3IE$0$0 == 0x00bb
_T3IE	=	0x00bb
Ftest_radio_link$T4IE$0$0 == 0x00bc
_T4IE	=	0x00bc
Ftest_radio_link$P0IE$0$0 == 0x00bd
_P0IE	=	0x00bd
Ftest_radio_link$_IEN16$0$0 == 0x00be
__IEN16	=	0x00be
Ftest_radio_link$_IEN17$0$0 == 0x00bf
__IEN17	=	0x00bf
Ftest_radio_link$DMAIF$0$0 == 0x00c0
_DMAIF	=	0x00c0
Ftest_radio_link$T1IF$0$0 == 0x00c1
_T1IF	=	0x00c1
Ftest_radio_link$T2IF$0$0 == 0x00c2
_T2IF	=	0x00c2
Ftest_radio_link$T3IF$0$0 == 0x00c3
_T3IF	=	0x00c3
Ftest_radio_link$T4IF$0$0 == 0x00c4
_T4IF	=	0x00c4
Ftest_radio_link$P0IF$0$0 == 0x00c5
_P0IF	=	0x00c5
Ftest_radio_link$_IRCON6$0$0 == 0x00c6
__IRCON6	=	0x00c6
Ftest_radio_link$STIF$0$0 == 0x00c7
_STIF	=	0x00c7
Ftest_radio_link$P$0$0 == 0x00d0
_P	=	0x00d0
Ftest_radio_link$F1$0$0 == 0x00d1
_F1	=	0x00d1
Ftest_radio_link$OV$0$0 == 0x00d2
_OV	=	0x00d2
Ftest_radio_link$RS0$0$0 == 0x00d3
_RS0	=	0x00d3
Ftest_radio_link$RS1$0$0 == 0x00d4
_RS1	=	0x00d4
Ftest_radio_link$F0$0$0 == 0x00d5
_F0	=	0x00d5
Ftest_radio_link$AC$0$0 == 0x00d6
_AC	=	0x00d6
Ftest_radio_link$CY$0$0 == 0x00d7
_CY	=	0x00d7
Ftest_radio_link$T3OVFIF$0$0 == 0x00d8
_T3OVFIF	=	0x00d8
Ftest_radio_link$T3CH0IF$0$0 == 0x00d9
_T3CH0IF	=	0x00d9
Ftest_radio_link$T3CH1IF$0$0 == 0x00da
_T3CH1IF	=	0x00da
Ftest_radio_link$T4OVFIF$0$0 == 0x00db
_T4OVFIF	=	0x00db
Ftest_radio_link$T4CH0IF$0$0 == 0x00dc
_T4CH0IF	=	0x00dc
Ftest_radio_link$T4CH1IF$0$0 == 0x00dd
_T4CH1IF	=	0x00dd
Ftest_radio_link$OVFIM$0$0 == 0x00de
_OVFIM	=	0x00de
Ftest_radio_link$_TIMIF7$0$0 == 0x00df
__TIMIF7	=	0x00df
Ftest_radio_link$ACC_0$0$0 == 0x00e0
_ACC_0	=	0x00e0
Ftest_radio_link$ACC_1$0$0 == 0x00e1
_ACC_1	=	0x00e1
Ftest_radio_link$ACC_2$0$0 == 0x00e2
_ACC_2	=	0x00e2
Ftest_radio_link$ACC_3$0$0 == 0x00e3
_ACC_3	=	0x00e3
Ftest_radio_link$ACC_4$0$0 == 0x00e4
_ACC_4	=	0x00e4
Ftest_radio_link$ACC_5$0$0 == 0x00e5
_ACC_5	=	0x00e5
Ftest_radio_link$ACC_6$0$0 == 0x00e6
_ACC_6	=	0x00e6
Ftest_radio_link$ACC_7$0$0 == 0x00e7
_ACC_7	=	0x00e7
Ftest_radio_link$P2IF$0$0 == 0x00e8
_P2IF	=	0x00e8
Ftest_radio_link$UTX0IF$0$0 == 0x00e9
_UTX0IF	=	0x00e9
Ftest_radio_link$UTX1IF$0$0 == 0x00ea
_UTX1IF	=	0x00ea
Ftest_radio_link$P1IF$0$0 == 0x00eb
_P1IF	=	0x00eb
Ftest_radio_link$WDTIF$0$0 == 0x00ec
_WDTIF	=	0x00ec
Ftest_radio_link$_IRCON25$0$0 == 0x00ed
__IRCON25	=	0x00ed
Ftest_radio_link$_IRCON26$0$0 == 0x00ee
__IRCON26	=	0x00ee
Ftest_radio_link$_IRCON27$0$0 == 0x00ef
__IRCON27	=	0x00ef
Ftest_radio_link$B_0$0$0 == 0x00f0
_B_0	=	0x00f0
Ftest_radio_link$B_1$0$0 == 0x00f1
_B_1	=	0x00f1
Ftest_radio_link$B_2$0$0 == 0x00f2
_B_2	=	0x00f2
Ftest_radio_link$B_3$0$0 == 0x00f3
_B_3	=	0x00f3
Ftest_radio_link$B_4$0$0 == 0x00f4
_B_4	=	0x00f4
Ftest_radio_link$B_5$0$0 == 0x00f5
_B_5	=	0x00f5
Ftest_radio_link$B_6$0$0 == 0x00f6
_B_6	=	0x00f6
Ftest_radio_link$B_7$0$0 == 0x00f7
_B_7	=	0x00f7
Ftest_radio_link$U1ACTIVE$0$0 == 0x00f8
_U1ACTIVE	=	0x00f8
Ftest_radio_link$U1TX_BYTE$0$0 == 0x00f9
_U1TX_BYTE	=	0x00f9
Ftest_radio_link$U1RX_BYTE$0$0 == 0x00fa
_U1RX_BYTE	=	0x00fa
Ftest_radio_link$U1ERR$0$0 == 0x00fb
_U1ERR	=	0x00fb
Ftest_radio_link$U1FE$0$0 == 0x00fc
_U1FE	=	0x00fc
Ftest_radio_link$U1SLAVE$0$0 == 0x00fd
_U1SLAVE	=	0x00fd
Ftest_radio_link$U1RE$0$0 == 0x00fe
_U1RE	=	0x00fe
Ftest_radio_link$U1MODE$0$0 == 0x00ff
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
Ltest_radio_link.handleCommands$sloc0$1$0==.
_handleCommands_sloc0_1_0:
	.ds 2
Ltest_radio_link.handleCommands$sloc1$1$0==.
_handleCommands_sloc1_1_0:
	.ds 2
Ltest_radio_link.handleCommands$sloc2$1$0==.
_handleCommands_sloc2_1_0:
	.ds 2
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
Ltest_radio_link.radioToUsb$length$1$1==.
_radioToUsb_length_1_1:
	.ds 1
Ltest_radio_link.radioToUsb$i$1$1==.
_radioToUsb_i_1_1:
	.ds 1
Ltest_radio_link.handleCommands$payloadType$1$1==.
_handleCommands_payloadType_1_1:
	.ds 1
Ltest_radio_link.handleCommands$packet$3$4==.
_handleCommands_packet_3_4:
	.ds 2
;--------------------------------------------------------
; external ram data
;--------------------------------------------------------
	.area XSEG    (XDATA)
Ftest_radio_link$SYNC1$0$0 == 0xdf00
_SYNC1	=	0xdf00
Ftest_radio_link$SYNC0$0$0 == 0xdf01
_SYNC0	=	0xdf01
Ftest_radio_link$PKTLEN$0$0 == 0xdf02
_PKTLEN	=	0xdf02
Ftest_radio_link$PKTCTRL1$0$0 == 0xdf03
_PKTCTRL1	=	0xdf03
Ftest_radio_link$PKTCTRL0$0$0 == 0xdf04
_PKTCTRL0	=	0xdf04
Ftest_radio_link$ADDR$0$0 == 0xdf05
_ADDR	=	0xdf05
Ftest_radio_link$CHANNR$0$0 == 0xdf06
_CHANNR	=	0xdf06
Ftest_radio_link$FSCTRL1$0$0 == 0xdf07
_FSCTRL1	=	0xdf07
Ftest_radio_link$FSCTRL0$0$0 == 0xdf08
_FSCTRL0	=	0xdf08
Ftest_radio_link$FREQ2$0$0 == 0xdf09
_FREQ2	=	0xdf09
Ftest_radio_link$FREQ1$0$0 == 0xdf0a
_FREQ1	=	0xdf0a
Ftest_radio_link$FREQ0$0$0 == 0xdf0b
_FREQ0	=	0xdf0b
Ftest_radio_link$MDMCFG4$0$0 == 0xdf0c
_MDMCFG4	=	0xdf0c
Ftest_radio_link$MDMCFG3$0$0 == 0xdf0d
_MDMCFG3	=	0xdf0d
Ftest_radio_link$MDMCFG2$0$0 == 0xdf0e
_MDMCFG2	=	0xdf0e
Ftest_radio_link$MDMCFG1$0$0 == 0xdf0f
_MDMCFG1	=	0xdf0f
Ftest_radio_link$MDMCFG0$0$0 == 0xdf10
_MDMCFG0	=	0xdf10
Ftest_radio_link$DEVIATN$0$0 == 0xdf11
_DEVIATN	=	0xdf11
Ftest_radio_link$MCSM2$0$0 == 0xdf12
_MCSM2	=	0xdf12
Ftest_radio_link$MCSM1$0$0 == 0xdf13
_MCSM1	=	0xdf13
Ftest_radio_link$MCSM0$0$0 == 0xdf14
_MCSM0	=	0xdf14
Ftest_radio_link$FOCCFG$0$0 == 0xdf15
_FOCCFG	=	0xdf15
Ftest_radio_link$BSCFG$0$0 == 0xdf16
_BSCFG	=	0xdf16
Ftest_radio_link$AGCCTRL2$0$0 == 0xdf17
_AGCCTRL2	=	0xdf17
Ftest_radio_link$AGCCTRL1$0$0 == 0xdf18
_AGCCTRL1	=	0xdf18
Ftest_radio_link$AGCCTRL0$0$0 == 0xdf19
_AGCCTRL0	=	0xdf19
Ftest_radio_link$FREND1$0$0 == 0xdf1a
_FREND1	=	0xdf1a
Ftest_radio_link$FREND0$0$0 == 0xdf1b
_FREND0	=	0xdf1b
Ftest_radio_link$FSCAL3$0$0 == 0xdf1c
_FSCAL3	=	0xdf1c
Ftest_radio_link$FSCAL2$0$0 == 0xdf1d
_FSCAL2	=	0xdf1d
Ftest_radio_link$FSCAL1$0$0 == 0xdf1e
_FSCAL1	=	0xdf1e
Ftest_radio_link$FSCAL0$0$0 == 0xdf1f
_FSCAL0	=	0xdf1f
Ftest_radio_link$TEST2$0$0 == 0xdf23
_TEST2	=	0xdf23
Ftest_radio_link$TEST1$0$0 == 0xdf24
_TEST1	=	0xdf24
Ftest_radio_link$TEST0$0$0 == 0xdf25
_TEST0	=	0xdf25
Ftest_radio_link$PA_TABLE0$0$0 == 0xdf2e
_PA_TABLE0	=	0xdf2e
Ftest_radio_link$IOCFG2$0$0 == 0xdf2f
_IOCFG2	=	0xdf2f
Ftest_radio_link$IOCFG1$0$0 == 0xdf30
_IOCFG1	=	0xdf30
Ftest_radio_link$IOCFG0$0$0 == 0xdf31
_IOCFG0	=	0xdf31
Ftest_radio_link$PARTNUM$0$0 == 0xdf36
_PARTNUM	=	0xdf36
Ftest_radio_link$VERSION$0$0 == 0xdf37
_VERSION	=	0xdf37
Ftest_radio_link$FREQEST$0$0 == 0xdf38
_FREQEST	=	0xdf38
Ftest_radio_link$LQI$0$0 == 0xdf39
_LQI	=	0xdf39
Ftest_radio_link$RSSI$0$0 == 0xdf3a
_RSSI	=	0xdf3a
Ftest_radio_link$MARCSTATE$0$0 == 0xdf3b
_MARCSTATE	=	0xdf3b
Ftest_radio_link$PKTSTATUS$0$0 == 0xdf3c
_PKTSTATUS	=	0xdf3c
Ftest_radio_link$VCO_VC_DAC$0$0 == 0xdf3d
_VCO_VC_DAC	=	0xdf3d
Ftest_radio_link$I2SCFG0$0$0 == 0xdf40
_I2SCFG0	=	0xdf40
Ftest_radio_link$I2SCFG1$0$0 == 0xdf41
_I2SCFG1	=	0xdf41
Ftest_radio_link$I2SDATL$0$0 == 0xdf42
_I2SDATL	=	0xdf42
Ftest_radio_link$I2SDATH$0$0 == 0xdf43
_I2SDATH	=	0xdf43
Ftest_radio_link$I2SWCNT$0$0 == 0xdf44
_I2SWCNT	=	0xdf44
Ftest_radio_link$I2SSTAT$0$0 == 0xdf45
_I2SSTAT	=	0xdf45
Ftest_radio_link$I2SCLKF0$0$0 == 0xdf46
_I2SCLKF0	=	0xdf46
Ftest_radio_link$I2SCLKF1$0$0 == 0xdf47
_I2SCLKF1	=	0xdf47
Ftest_radio_link$I2SCLKF2$0$0 == 0xdf48
_I2SCLKF2	=	0xdf48
Ftest_radio_link$USBADDR$0$0 == 0xde00
_USBADDR	=	0xde00
Ftest_radio_link$USBPOW$0$0 == 0xde01
_USBPOW	=	0xde01
Ftest_radio_link$USBIIF$0$0 == 0xde02
_USBIIF	=	0xde02
Ftest_radio_link$USBOIF$0$0 == 0xde04
_USBOIF	=	0xde04
Ftest_radio_link$USBCIF$0$0 == 0xde06
_USBCIF	=	0xde06
Ftest_radio_link$USBIIE$0$0 == 0xde07
_USBIIE	=	0xde07
Ftest_radio_link$USBOIE$0$0 == 0xde09
_USBOIE	=	0xde09
Ftest_radio_link$USBCIE$0$0 == 0xde0b
_USBCIE	=	0xde0b
Ftest_radio_link$USBFRML$0$0 == 0xde0c
_USBFRML	=	0xde0c
Ftest_radio_link$USBFRMH$0$0 == 0xde0d
_USBFRMH	=	0xde0d
Ftest_radio_link$USBINDEX$0$0 == 0xde0e
_USBINDEX	=	0xde0e
Ftest_radio_link$USBMAXI$0$0 == 0xde10
_USBMAXI	=	0xde10
Ftest_radio_link$USBCSIL$0$0 == 0xde11
_USBCSIL	=	0xde11
Ftest_radio_link$USBCSIH$0$0 == 0xde12
_USBCSIH	=	0xde12
Ftest_radio_link$USBMAXO$0$0 == 0xde13
_USBMAXO	=	0xde13
Ftest_radio_link$USBCSOL$0$0 == 0xde14
_USBCSOL	=	0xde14
Ftest_radio_link$USBCSOH$0$0 == 0xde15
_USBCSOH	=	0xde15
Ftest_radio_link$USBCNTL$0$0 == 0xde16
_USBCNTL	=	0xde16
Ftest_radio_link$USBCNTH$0$0 == 0xde17
_USBCNTH	=	0xde17
Ftest_radio_link$USBF0$0$0 == 0xde20
_USBF0	=	0xde20
Ftest_radio_link$USBF1$0$0 == 0xde22
_USBF1	=	0xde22
Ftest_radio_link$USBF2$0$0 == 0xde24
_USBF2	=	0xde24
Ftest_radio_link$USBF3$0$0 == 0xde26
_USBF3	=	0xde26
Ftest_radio_link$USBF4$0$0 == 0xde28
_USBF4	=	0xde28
Ftest_radio_link$USBF5$0$0 == 0xde2a
_USBF5	=	0xde2a
Ltest_radio_link.radioToUsb$buffer$1$1==.
_radioToUsb_buffer_1_1:
	.ds 128
Ltest_radio_link.handleCommands$txNotAvailable$1$1==.
_handleCommands_txNotAvailable_1_1:
	.ds 20
Ltest_radio_link.handleCommands$response$1$1==.
_handleCommands_response_1_1:
	.ds 128
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
	.ds	5
	reti
	.ds	7
	reti
	.ds	7
	reti
	.ds	7
	ljmp	_ISR_RF
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
;------------------------------------------------------------
;Allocation info for local variables in function 'handleCommands'
;------------------------------------------------------------
;sloc0                     Allocated with name '_handleCommands_sloc0_1_0'
;sloc1                     Allocated with name '_handleCommands_sloc1_1_0'
;sloc2                     Allocated with name '_handleCommands_sloc2_1_0'
;txNotAvailable            Allocated with name '_handleCommands_txNotAvailable_1_1'
;response                  Allocated with name '_handleCommands_response_1_1'
;------------------------------------------------------------
	G$handleCommands$0$0 ==.
	C$test_radio_link.c$84$1$1 ==.
;	apps/test_radio_link/test_radio_link.c:84: static uint8 payloadType = 0;
	mov	r0,#_handleCommands_payloadType_1_1
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
;Allocation info for local variables in function 'updateLeds'
;------------------------------------------------------------
	G$updateLeds$0$0 ==.
	C$test_radio_link.c$21$0$0 ==.
;	apps/test_radio_link/test_radio_link.c:21: void updateLeds()
;	-----------------------------------------
;	 function updateLeds
;	-----------------------------------------
_updateLeds:
	ar7 = 0x07
	ar6 = 0x06
	ar5 = 0x05
	ar4 = 0x04
	ar3 = 0x03
	ar2 = 0x02
	ar1 = 0x01
	ar0 = 0x00
	C$test_radio_link.c$23$1$1 ==.
;	apps/test_radio_link/test_radio_link.c:23: usbShowStatusWithGreenLed();
	lcall	_usbShowStatusWithGreenLed
	C$test_radio_link.c$25$1$1 ==.
;	apps/test_radio_link/test_radio_link.c:25: if (MARCSTATE == 0x11)
	mov	dptr,#_MARCSTATE
	movx	a,@dptr
	mov	r7,a
	cjne	r7,#0x11,00102$
	C$test_radio_link.c$27$3$3 ==.
;	apps/test_radio_link/test_radio_link.c:27: LED_RED(1);
	orl	_P2DIR,#0x02
	sjmp	00103$
00102$:
	C$test_radio_link.c$31$3$5 ==.
;	apps/test_radio_link/test_radio_link.c:31: LED_RED(0);
	mov	r7,_P2DIR
	anl	ar7,#0xFD
	mov	_P2DIR,r7
00103$:
	C$test_radio_link.c$34$2$6 ==.
;	apps/test_radio_link/test_radio_link.c:34: LED_YELLOW(radioLinkConnected());
	lcall	_radioLinkConnected
	jnc	00106$
	orl	_P2DIR,#0x04
	sjmp	00104$
00106$:
	mov	r7,_P2DIR
	anl	ar7,#0xFB
	mov	_P2DIR,r7
00104$:
	C$test_radio_link.c$35$2$6 ==.
	XG$updateLeds$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'nibbleToAscii'
;------------------------------------------------------------
	G$nibbleToAscii$0$0 ==.
	C$test_radio_link.c$37$2$6 ==.
;	apps/test_radio_link/test_radio_link.c:37: uint8 nibbleToAscii(uint8 nibble)
;	-----------------------------------------
;	 function nibbleToAscii
;	-----------------------------------------
_nibbleToAscii:
	C$test_radio_link.c$39$1$1 ==.
;	apps/test_radio_link/test_radio_link.c:39: nibble &= 0xF;
	C$test_radio_link.c$40$1$1 ==.
;	apps/test_radio_link/test_radio_link.c:40: if (nibble <= 0x9){ return '0' + nibble; }
	mov	a,dpl
	anl	a,#0x0F
	mov	r7,a
	add	a,#0xff - 0x09
	jc	00102$
	mov	ar6,r7
	mov	a,#0x30
	add	a,r6
	mov	r6,a
	mov	dpl,a
	sjmp	00104$
00102$:
	C$test_radio_link.c$41$2$3 ==.
;	apps/test_radio_link/test_radio_link.c:41: else{ return 'A' + (nibble - 0xA); }
	mov	a,#0x37
	add	a,r7
	C$test_radio_link.c$42$1$1 ==.
	XG$nibbleToAscii$0$0 ==.
	mov	dpl,a
00104$:
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'radioToUsb'
;------------------------------------------------------------
;buffer                    Allocated with name '_radioToUsb_buffer_1_1'
;------------------------------------------------------------
	G$radioToUsb$0$0 ==.
	C$test_radio_link.c$44$1$1 ==.
;	apps/test_radio_link/test_radio_link.c:44: void radioToUsb()
;	-----------------------------------------
;	 function radioToUsb
;	-----------------------------------------
_radioToUsb:
	C$test_radio_link.c$52$1$1 ==.
;	apps/test_radio_link/test_radio_link.c:52: if ((packet = radioLinkRxCurrentPacket()) && usbComTxAvailable() >= packet[0]*2 + 30)
	lcall	_radioLinkRxCurrentPacket
	mov	r6,dpl
	mov	r7,dph
	mov	ar4,r6
	mov	ar5,r7
	mov	a,r6
	orl	a,r7
	jnz	00120$
	ljmp	00102$
00120$:
	push	ar5
	push	ar4
	lcall	_usbComTxAvailable
	mov	r7,dpl
	pop	ar4
	pop	ar5
	mov	dpl,r4
	mov	dph,r5
	movx	a,@dptr
	mov	b,#0x02
	mul	ab
	add	a,#0x1E
	mov	r3,a
	clr	a
	addc	a,b
	mov	r6,a
	mov	r2,#0x00
	clr	c
	mov	a,r7
	subb	a,r3
	mov	a,r2
	xrl	a,#0x80
	mov	b,r6
	xrl	b,#0x80
	subb	a,b
	jnc	00121$
	ljmp	00102$
00121$:
	C$test_radio_link.c$54$2$2 ==.
;	apps/test_radio_link/test_radio_link.c:54: length = sprintf(buffer, "RX: %2d ", radioLinkRxCurrentPayloadType());
	push	ar5
	push	ar4
	lcall	_radioLinkRxCurrentPayloadType
	mov	r7,dpl
	mov	r6,#0x00
	push	ar7
	push	ar6
	mov	a,#__str_1
	push	acc
	mov	a,#(__str_1 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	mov	a,#_radioToUsb_buffer_1_1
	push	acc
	mov	a,#(_radioToUsb_buffer_1_1 >> 8)
	push	acc
	clr	a
	push	acc
	lcall	_sprintf
	mov	r6,dpl
	mov	r7,dph
	mov	a,sp
	add	a,#0xf8
	mov	sp,a
	pop	ar4
	pop	ar5
	mov	r0,#_radioToUsb_length_1_1
	mov	a,r6
	movx	@r0,a
	C$test_radio_link.c$55$2$1 ==.
;	apps/test_radio_link/test_radio_link.c:55: for (i = 0; i < packet[0]; i++)
	mov	r0,#_radioToUsb_i_1_1
	clr	a
	movx	@r0,a
00107$:
	mov	dpl,r4
	mov	dph,r5
	movx	a,@dptr
	mov	r3,a
	mov	r0,#_radioToUsb_i_1_1
	clr	c
	movx	a,@r0
	subb	a,r3
	jc	00122$
	ljmp	00110$
00122$:
	C$test_radio_link.c$57$3$3 ==.
;	apps/test_radio_link/test_radio_link.c:57: buffer[length++] = nibbleToAscii(packet[1+i] >> 4);
	mov	r0,#_radioToUsb_length_1_1
	movx	a,@r0
	mov	r3,a
	mov	r0,#_radioToUsb_length_1_1
	movx	a,@r0
	add	a,#0x01
	movx	@r0,a
	mov	a,r3
	add	a,#_radioToUsb_buffer_1_1
	mov	r3,a
	clr	a
	addc	a,#(_radioToUsb_buffer_1_1 >> 8)
	mov	r2,a
	mov	r0,#_radioToUsb_i_1_1
	movx	a,@r0
	mov	r6,a
	mov	r7,#0x00
	inc	r6
	cjne	r6,#0x00,00123$
	inc	r7
00123$:
	mov	a,r6
	add	a,r4
	mov	r6,a
	mov	a,r7
	addc	a,r5
	mov	r7,a
	push	ar4
	push	ar5
	mov	dpl,r6
	mov	dph,r7
	movx	a,@dptr
	swap	a
	anl	a,#0x0F
	mov	dpl,a
	push	ar7
	push	ar6
	push	ar4
	push	ar3
	push	ar2
	lcall	_nibbleToAscii
	mov	r5,dpl
	pop	ar2
	pop	ar3
	pop	ar4
	pop	ar6
	pop	ar7
	mov	dpl,r3
	mov	dph,r2
	mov	a,r5
	movx	@dptr,a
	C$test_radio_link.c$58$3$3 ==.
;	apps/test_radio_link/test_radio_link.c:58: buffer[length++] = nibbleToAscii(packet[1+i]);
	mov	r0,#_radioToUsb_length_1_1
	movx	a,@r0
	mov	r5,a
	mov	r0,#_radioToUsb_length_1_1
	movx	a,@r0
	add	a,#0x01
	movx	@r0,a
	mov	a,r5
	add	a,#_radioToUsb_buffer_1_1
	mov	r5,a
	clr	a
	addc	a,#(_radioToUsb_buffer_1_1 >> 8)
	mov	r4,a
	mov	dpl,r6
	mov	dph,r7
	movx	a,@dptr
	mov	dpl,a
	push	ar5
	push	ar4
	lcall	_nibbleToAscii
	mov	r7,dpl
	pop	ar4
	pop	ar5
	mov	dpl,r5
	mov	dph,r4
	mov	a,r7
	movx	@dptr,a
	C$test_radio_link.c$55$2$2 ==.
;	apps/test_radio_link/test_radio_link.c:55: for (i = 0; i < packet[0]; i++)
	mov	r0,#_radioToUsb_i_1_1
	movx	a,@r0
	add	a,#0x01
	movx	@r0,a
	pop	ar5
	pop	ar4
	ljmp	00107$
00110$:
	C$test_radio_link.c$61$2$2 ==.
;	apps/test_radio_link/test_radio_link.c:61: buffer[length++] = '\r';
	mov	r0,#_radioToUsb_length_1_1
	movx	a,@r0
	mov	r7,a
	mov	r0,#_radioToUsb_length_1_1
	movx	a,@r0
	add	a,#0x01
	movx	@r0,a
	mov	a,r7
	add	a,#_radioToUsb_buffer_1_1
	mov	dpl,a
	clr	a
	addc	a,#(_radioToUsb_buffer_1_1 >> 8)
	mov	dph,a
	mov	a,#0x0D
	movx	@dptr,a
	C$test_radio_link.c$62$2$2 ==.
;	apps/test_radio_link/test_radio_link.c:62: buffer[length++] = '\n';
	mov	r0,#_radioToUsb_length_1_1
	movx	a,@r0
	mov	r7,a
	mov	r0,#_radioToUsb_length_1_1
	movx	a,@r0
	add	a,#0x01
	movx	@r0,a
	mov	a,r7
	add	a,#_radioToUsb_buffer_1_1
	mov	dpl,a
	clr	a
	addc	a,#(_radioToUsb_buffer_1_1 >> 8)
	mov	dph,a
	mov	a,#0x0A
	movx	@dptr,a
	C$test_radio_link.c$64$2$2 ==.
;	apps/test_radio_link/test_radio_link.c:64: radioLinkRxDoneWithPacket();
	lcall	_radioLinkRxDoneWithPacket
	C$test_radio_link.c$65$2$2 ==.
;	apps/test_radio_link/test_radio_link.c:65: usbComTxSend(buffer, length);
	mov	r0,#_radioToUsb_length_1_1
	mov	r1,#_usbComTxSend_PARM_2
	movx	a,@r0
	movx	@r1,a
	mov	dptr,#_radioToUsb_buffer_1_1
	lcall	_usbComTxSend
00102$:
	C$test_radio_link.c$71$1$1 ==.
;	apps/test_radio_link/test_radio_link.c:71: if (radioLinkResetPacketReceived && usbComTxAvailable() >= sizeof(resetString)-1)
	jnb	_radioLinkResetPacketReceived,00111$
	lcall	_usbComTxAvailable
	mov	r7,dpl
	cjne	r7,#0x0B,00125$
00125$:
	jc	00111$
	C$test_radio_link.c$73$2$4 ==.
;	apps/test_radio_link/test_radio_link.c:73: radioLinkResetPacketReceived = 0;
	clr	_radioLinkResetPacketReceived
	C$test_radio_link.c$74$2$4 ==.
;	apps/test_radio_link/test_radio_link.c:74: usbComTxSend((uint8 XDATA *)resetString, sizeof(resetString)-1);
	mov	dptr,#_radioToUsb_resetString_1_1
	mov	r0,#_usbComTxSend_PARM_2
	mov	a,#0x0B
	movx	@r0,a
	lcall	_usbComTxSend
00111$:
	C$test_radio_link.c$77$2$1 ==.
	XG$radioToUsb$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'handleCommands'
;------------------------------------------------------------
;sloc0                     Allocated with name '_handleCommands_sloc0_1_0'
;sloc1                     Allocated with name '_handleCommands_sloc1_1_0'
;sloc2                     Allocated with name '_handleCommands_sloc2_1_0'
;txNotAvailable            Allocated with name '_handleCommands_txNotAvailable_1_1'
;response                  Allocated with name '_handleCommands_response_1_1'
;------------------------------------------------------------
	G$handleCommands$0$0 ==.
	C$test_radio_link.c$79$2$1 ==.
;	apps/test_radio_link/test_radio_link.c:79: void handleCommands()
;	-----------------------------------------
;	 function handleCommands
;	-----------------------------------------
_handleCommands:
	C$test_radio_link.c$81$1$1 ==.
;	apps/test_radio_link/test_radio_link.c:81: uint8 XDATA txNotAvailable[] = "TX not available!\r\n";
	mov	dptr,#_handleCommands_txNotAvailable_1_1
	mov	a,#0x54
	movx	@dptr,a
	mov	dptr,#(_handleCommands_txNotAvailable_1_1 + 0x0001)
	mov	a,#0x58
	movx	@dptr,a
	mov	dptr,#(_handleCommands_txNotAvailable_1_1 + 0x0002)
	mov	a,#0x20
	movx	@dptr,a
	mov	dptr,#(_handleCommands_txNotAvailable_1_1 + 0x0003)
	mov	a,#0x6E
	movx	@dptr,a
	mov	dptr,#(_handleCommands_txNotAvailable_1_1 + 0x0004)
	mov	a,#0x6F
	movx	@dptr,a
	mov	dptr,#(_handleCommands_txNotAvailable_1_1 + 0x0005)
	mov	a,#0x74
	movx	@dptr,a
	mov	dptr,#(_handleCommands_txNotAvailable_1_1 + 0x0006)
	mov	a,#0x20
	movx	@dptr,a
	mov	dptr,#(_handleCommands_txNotAvailable_1_1 + 0x0007)
	mov	a,#0x61
	movx	@dptr,a
	mov	dptr,#(_handleCommands_txNotAvailable_1_1 + 0x0008)
	mov	a,#0x76
	movx	@dptr,a
	mov	dptr,#(_handleCommands_txNotAvailable_1_1 + 0x0009)
	mov	a,#0x61
	movx	@dptr,a
	mov	dptr,#(_handleCommands_txNotAvailable_1_1 + 0x000a)
	mov	a,#0x69
	movx	@dptr,a
	mov	dptr,#(_handleCommands_txNotAvailable_1_1 + 0x000b)
	mov	a,#0x6C
	movx	@dptr,a
	mov	dptr,#(_handleCommands_txNotAvailable_1_1 + 0x000c)
	mov	a,#0x61
	movx	@dptr,a
	mov	dptr,#(_handleCommands_txNotAvailable_1_1 + 0x000d)
	mov	a,#0x62
	movx	@dptr,a
	mov	dptr,#(_handleCommands_txNotAvailable_1_1 + 0x000e)
	mov	a,#0x6C
	movx	@dptr,a
	mov	dptr,#(_handleCommands_txNotAvailable_1_1 + 0x000f)
	mov	a,#0x65
	movx	@dptr,a
	mov	dptr,#(_handleCommands_txNotAvailable_1_1 + 0x0010)
	mov	a,#0x21
	movx	@dptr,a
	mov	dptr,#(_handleCommands_txNotAvailable_1_1 + 0x0011)
	mov	a,#0x0D
	movx	@dptr,a
	mov	dptr,#(_handleCommands_txNotAvailable_1_1 + 0x0012)
	mov	a,#0x0A
	movx	@dptr,a
	mov	dptr,#(_handleCommands_txNotAvailable_1_1 + 0x0013)
	clr	a
	movx	@dptr,a
	C$test_radio_link.c$86$1$1 ==.
;	apps/test_radio_link/test_radio_link.c:86: if (usbComRxAvailable() && usbComTxAvailable() >= 50)
	lcall	_usbComRxAvailable
	mov	a,dpl
	jnz	00125$
	ljmp	00116$
00125$:
	lcall	_usbComTxAvailable
	mov	r7,dpl
	cjne	r7,#0x32,00126$
00126$:
	jnc	00127$
	ljmp	00116$
00127$:
	C$test_radio_link.c$88$2$2 ==.
;	apps/test_radio_link/test_radio_link.c:88: uint8 byte = usbComRxReceiveByte();
	lcall	_usbComRxReceiveByte
	mov	r5,dpl
	C$test_radio_link.c$89$2$2 ==.
;	apps/test_radio_link/test_radio_link.c:89: if (byte == (uint8)'?')
	cjne	r5,#0x3F,00111$
	C$test_radio_link.c$93$3$3 ==.
;	apps/test_radio_link/test_radio_link.c:93: radioLinkTxMainLoopIndex, radioLinkTxInterruptIndex, MARCSTATE);
	mov	dptr,#_MARCSTATE
	movx	a,@dptr
	mov	r6,a
	mov	r5,#0x00
	mov	_handleCommands_sloc0_1_0,_radioLinkTxInterruptIndex
	mov	(_handleCommands_sloc0_1_0 + 1),#0x00
	mov	_handleCommands_sloc1_1_0,_radioLinkTxMainLoopIndex
	mov	(_handleCommands_sloc1_1_0 + 1),#0x00
	C$test_radio_link.c$92$3$3 ==.
;	apps/test_radio_link/test_radio_link.c:92: radioLinkRxMainLoopIndex, radioLinkRxInterruptIndex,
	mov	_handleCommands_sloc2_1_0,_radioLinkRxInterruptIndex
	mov	(_handleCommands_sloc2_1_0 + 1),#0x00
	mov	r2,_radioLinkRxMainLoopIndex
	mov	r4,#0x00
	C$test_radio_link.c$91$3$3 ==.
;	apps/test_radio_link/test_radio_link.c:91: responseLength = sprintf(response, "? RX=%d/%d, TX=%d/%d, M=%02x\r\n",
	push	ar6
	push	ar5
	push	_handleCommands_sloc0_1_0
	push	(_handleCommands_sloc0_1_0 + 1)
	push	_handleCommands_sloc1_1_0
	push	(_handleCommands_sloc1_1_0 + 1)
	push	_handleCommands_sloc2_1_0
	push	(_handleCommands_sloc2_1_0 + 1)
	push	ar2
	push	ar4
	mov	a,#__str_3
	push	acc
	mov	a,#(__str_3 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	mov	a,#_handleCommands_response_1_1
	push	acc
	mov	a,#(_handleCommands_response_1_1 >> 8)
	push	acc
	clr	a
	push	acc
	lcall	_sprintf
	mov	r5,dpl
	mov	a,sp
	add	a,#0xf0
	mov	sp,a
	C$test_radio_link.c$94$3$3 ==.
;	apps/test_radio_link/test_radio_link.c:94: usbComTxSend(response, responseLength);
	mov	r0,#_usbComTxSend_PARM_2
	mov	a,r5
	movx	@r0,a
	mov	dptr,#_handleCommands_response_1_1
	lcall	_usbComTxSend
	ljmp	00116$
00111$:
	C$test_radio_link.c$96$2$2 ==.
;	apps/test_radio_link/test_radio_link.c:96: else if (byte >= (uint8)'a' && byte <= (uint8)'g')
	cjne	r5,#0x61,00130$
00130$:
	jnc	00131$
	ljmp	00116$
00131$:
	mov	a,r5
	add	a,#0xff - 0x67
	jnc	00132$
	ljmp	00116$
00132$:
	C$test_radio_link.c$98$3$4 ==.
;	apps/test_radio_link/test_radio_link.c:98: uint8 XDATA * packet = radioLinkTxCurrentPacket();
	push	ar5
	lcall	_radioLinkTxCurrentPacket
	mov	r0,#_handleCommands_packet_3_4
	mov	a,dpl
	movx	@r0,a
	inc	r0
	mov	a,dph
	movx	@r0,a
	pop	ar5
	C$test_radio_link.c$99$3$4 ==.
;	apps/test_radio_link/test_radio_link.c:99: if (packet == 0)
	mov	r0,#_handleCommands_packet_3_4
	movx	a,@r0
	mov	b,a
	inc	r0
	movx	a,@r0
	orl	a,b
	jnz	00105$
	C$test_radio_link.c$101$4$5 ==.
;	apps/test_radio_link/test_radio_link.c:101: usbComTxSend(txNotAvailable, sizeof(txNotAvailable));
	mov	r0,#_usbComTxSend_PARM_2
	mov	a,#0x14
	movx	@r0,a
	mov	dptr,#_handleCommands_txNotAvailable_1_1
	lcall	_usbComTxSend
	ljmp	00116$
00105$:
	C$test_radio_link.c$105$4$6 ==.
;	apps/test_radio_link/test_radio_link.c:105: packet[0] = 3; // Packet length
	mov	r0,#_handleCommands_packet_3_4
	movx	a,@r0
	mov	dpl,a
	inc	r0
	movx	a,@r0
	mov	dph,a
	mov	a,#0x03
	movx	@dptr,a
	C$test_radio_link.c$106$4$6 ==.
;	apps/test_radio_link/test_radio_link.c:106: packet[1] = byte;
	mov	r0,#_handleCommands_packet_3_4
	movx	a,@r0
	add	a,#0x01
	mov	r3,a
	inc	r0
	movx	a,@r0
	addc	a,#0x00
	mov	r4,a
	mov	dpl,r3
	mov	dph,r4
	mov	a,r5
	movx	@dptr,a
	C$test_radio_link.c$107$4$6 ==.
;	apps/test_radio_link/test_radio_link.c:107: packet[2] = byte + 1;
	mov	r0,#_handleCommands_packet_3_4
	movx	a,@r0
	add	a,#0x02
	mov	r2,a
	inc	r0
	movx	a,@r0
	addc	a,#0x00
	mov	r7,a
	mov	a,r5
	inc	a
	mov	dpl,r2
	mov	dph,r7
	movx	@dptr,a
	C$test_radio_link.c$108$4$6 ==.
;	apps/test_radio_link/test_radio_link.c:108: packet[3] = byte + 2;
	mov	r0,#_handleCommands_packet_3_4
	movx	a,@r0
	add	a,#0x03
	mov	_handleCommands_sloc2_1_0,a
	inc	r0
	movx	a,@r0
	addc	a,#0x00
	mov	(_handleCommands_sloc2_1_0 + 1),a
	mov	a,#0x02
	add	a,r5
	mov	dpl,_handleCommands_sloc2_1_0
	mov	dph,(_handleCommands_sloc2_1_0 + 1)
	movx	@dptr,a
	C$test_radio_link.c$109$4$6 ==.
;	apps/test_radio_link/test_radio_link.c:109: radioLinkTxSendPacket(payloadType);
	mov	r0,#_handleCommands_payloadType_1_1
	movx	a,@r0
	mov	dpl,a
	push	ar7
	push	ar4
	push	ar3
	push	ar2
	lcall	_radioLinkTxSendPacket
	pop	ar2
	pop	ar3
	pop	ar4
	pop	ar7
	C$test_radio_link.c$110$4$6 ==.
;	apps/test_radio_link/test_radio_link.c:110: responseLength = sprintf(response, "TX: %2d %02x%02x%02x\r\n", payloadType, packet[1], packet[2], packet[3]);
	mov	dpl,_handleCommands_sloc2_1_0
	mov	dph,(_handleCommands_sloc2_1_0 + 1)
	movx	a,@dptr
	mov	r6,a
	mov	r5,#0x00
	mov	dpl,r2
	mov	dph,r7
	movx	a,@dptr
	mov	r2,a
	mov	r7,#0x00
	mov	dpl,r3
	mov	dph,r4
	movx	a,@dptr
	mov	r3,a
	mov	_handleCommands_sloc2_1_0,r3
	mov	(_handleCommands_sloc2_1_0 + 1),#0x00
	mov	r0,#_handleCommands_payloadType_1_1
	movx	a,@r0
	mov	r3,a
	mov	r4,#0x00
	push	ar6
	push	ar5
	push	ar2
	push	ar7
	push	_handleCommands_sloc2_1_0
	push	(_handleCommands_sloc2_1_0 + 1)
	push	ar3
	push	ar4
	mov	a,#__str_4
	push	acc
	mov	a,#(__str_4 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	mov	a,#_handleCommands_response_1_1
	push	acc
	mov	a,#(_handleCommands_response_1_1 >> 8)
	push	acc
	clr	a
	push	acc
	lcall	_sprintf
	mov	r6,dpl
	mov	a,sp
	add	a,#0xf2
	mov	sp,a
	mov	r0,#_usbComTxSend_PARM_2
	mov	a,r6
	movx	@r0,a
	C$test_radio_link.c$111$4$6 ==.
;	apps/test_radio_link/test_radio_link.c:111: usbComTxSend(response, responseLength);
	mov	dptr,#_handleCommands_response_1_1
	lcall	_usbComTxSend
	C$test_radio_link.c$112$4$6 ==.
;	apps/test_radio_link/test_radio_link.c:112: if (payloadType == RADIO_LINK_MAX_PAYLOAD_TYPE)
	mov	r0,#_handleCommands_payloadType_1_1
	movx	a,@r0
	cjne	a,#0x0F,00102$
	C$test_radio_link.c$114$5$7 ==.
;	apps/test_radio_link/test_radio_link.c:114: payloadType = 0;
	mov	r0,#_handleCommands_payloadType_1_1
	clr	a
	movx	@r0,a
	sjmp	00116$
00102$:
	C$test_radio_link.c$118$5$8 ==.
;	apps/test_radio_link/test_radio_link.c:118: payloadType++;
	mov	r0,#_handleCommands_payloadType_1_1
	movx	a,@r0
	add	a,#0x01
	movx	@r0,a
00116$:
	C$test_radio_link.c$123$1$1 ==.
	XG$handleCommands$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'main'
;------------------------------------------------------------
	G$main$0$0 ==.
	C$test_radio_link.c$125$1$1 ==.
;	apps/test_radio_link/test_radio_link.c:125: void main()
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
	C$test_radio_link.c$127$1$1 ==.
;	apps/test_radio_link/test_radio_link.c:127: systemInit();
	lcall	_systemInit
	C$test_radio_link.c$128$1$1 ==.
;	apps/test_radio_link/test_radio_link.c:128: usbInit();
	lcall	_usbInit
	C$test_radio_link.c$130$1$1 ==.
;	apps/test_radio_link/test_radio_link.c:130: radioLinkInit();
	lcall	_radioLinkInit
	C$test_radio_link.c$131$1$1 ==.
;	apps/test_radio_link/test_radio_link.c:131: randomSeedFromAdc();
	lcall	_randomSeedFromAdc
	C$test_radio_link.c$134$1$1 ==.
;	apps/test_radio_link/test_radio_link.c:134: P1DIR |= (1<<6) | (1<<7);
	orl	_P1DIR,#0xC0
	C$test_radio_link.c$135$1$1 ==.
;	apps/test_radio_link/test_radio_link.c:135: IOCFG1 = 0b001000; // P1_6 = Preamble Quality Reached
	mov	dptr,#_IOCFG1
	mov	a,#0x08
	movx	@dptr,a
	C$test_radio_link.c$136$1$1 ==.
;	apps/test_radio_link/test_radio_link.c:136: IOCFG2 = 0b011011; // P1_7 = PA_PD (TX mode)
	mov	dptr,#_IOCFG2
	mov	a,#0x1B
	movx	@dptr,a
	C$test_radio_link.c$138$1$1 ==.
;	apps/test_radio_link/test_radio_link.c:138: while(1)
00102$:
	C$test_radio_link.c$140$2$2 ==.
;	apps/test_radio_link/test_radio_link.c:140: boardService();
	lcall	_boardService
	C$test_radio_link.c$141$2$2 ==.
;	apps/test_radio_link/test_radio_link.c:141: updateLeds();
	lcall	_updateLeds
	C$test_radio_link.c$142$2$2 ==.
;	apps/test_radio_link/test_radio_link.c:142: radioToUsb();
	lcall	_radioToUsb
	C$test_radio_link.c$143$2$2 ==.
;	apps/test_radio_link/test_radio_link.c:143: handleCommands();
	lcall	_handleCommands
	C$test_radio_link.c$144$2$2 ==.
;	apps/test_radio_link/test_radio_link.c:144: usbComService();
	lcall	_usbComService
	sjmp	00102$
	C$test_radio_link.c$146$1$1 ==.
	XG$main$0$0 ==.
	ret
	.area CSEG    (CODE)
	.area CONST   (CODE)
Ltest_radio_link.radioToUsb$resetString$1$1 == .
_radioToUsb_resetString_1_1:
	.ascii "RX: RESET"
	.db 0x0D
	.db 0x0A
	.db 0x00
Ftest_radio_link$_str_1$0$0 == .
__str_1:
	.ascii "RX: %2d "
	.db 0x00
Ftest_radio_link$_str_3$0$0 == .
__str_3:
	.ascii "? RX=%d/%d, TX=%d/%d, M=%02x"
	.db 0x0D
	.db 0x0A
	.db 0x00
Ftest_radio_link$_str_4$0$0 == .
__str_4:
	.ascii "TX: %2d %02x%02x%02x"
	.db 0x0D
	.db 0x0A
	.db 0x00
	.area XINIT   (CODE)
	.area CABS    (ABS,CODE)
