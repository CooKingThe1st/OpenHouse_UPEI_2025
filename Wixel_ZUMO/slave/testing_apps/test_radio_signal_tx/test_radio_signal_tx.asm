;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.1.0 #7066 (Nov 22 2011) (MINGW32)
; This file was generated Thu Oct 23 16:11:00 2025
;--------------------------------------------------------
	.module test_radio_signal_tx
	.optsdcc -mmcs51 --model-medium
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _param_radio_channel
	.globl _main
	.globl _sendRadioBursts
	.globl _perTestTxInit
	.globl _updateLeds
	.globl _usbComService
	.globl _usbShowStatusWithGreenLed
	.globl _usbInit
	.globl _radioRegistersInit
	.globl _getMs
	.globl _boardService
	.globl _systemInit
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area RSEG    (ABS,DATA)
	.org 0x0000
Ftest_radio_signal_tx$P0$0$0 == 0x0080
_P0	=	0x0080
Ftest_radio_signal_tx$SP$0$0 == 0x0081
_SP	=	0x0081
Ftest_radio_signal_tx$DPL0$0$0 == 0x0082
_DPL0	=	0x0082
Ftest_radio_signal_tx$DPH0$0$0 == 0x0083
_DPH0	=	0x0083
Ftest_radio_signal_tx$DPL1$0$0 == 0x0084
_DPL1	=	0x0084
Ftest_radio_signal_tx$DPH1$0$0 == 0x0085
_DPH1	=	0x0085
Ftest_radio_signal_tx$U0CSR$0$0 == 0x0086
_U0CSR	=	0x0086
Ftest_radio_signal_tx$PCON$0$0 == 0x0087
_PCON	=	0x0087
Ftest_radio_signal_tx$TCON$0$0 == 0x0088
_TCON	=	0x0088
Ftest_radio_signal_tx$P0IFG$0$0 == 0x0089
_P0IFG	=	0x0089
Ftest_radio_signal_tx$P1IFG$0$0 == 0x008a
_P1IFG	=	0x008a
Ftest_radio_signal_tx$P2IFG$0$0 == 0x008b
_P2IFG	=	0x008b
Ftest_radio_signal_tx$PICTL$0$0 == 0x008c
_PICTL	=	0x008c
Ftest_radio_signal_tx$P1IEN$0$0 == 0x008d
_P1IEN	=	0x008d
Ftest_radio_signal_tx$P0INP$0$0 == 0x008f
_P0INP	=	0x008f
Ftest_radio_signal_tx$P1$0$0 == 0x0090
_P1	=	0x0090
Ftest_radio_signal_tx$RFIM$0$0 == 0x0091
_RFIM	=	0x0091
Ftest_radio_signal_tx$DPS$0$0 == 0x0092
_DPS	=	0x0092
Ftest_radio_signal_tx$MPAGE$0$0 == 0x0093
_MPAGE	=	0x0093
Ftest_radio_signal_tx$ENDIAN$0$0 == 0x0095
_ENDIAN	=	0x0095
Ftest_radio_signal_tx$S0CON$0$0 == 0x0098
_S0CON	=	0x0098
Ftest_radio_signal_tx$IEN2$0$0 == 0x009a
_IEN2	=	0x009a
Ftest_radio_signal_tx$S1CON$0$0 == 0x009b
_S1CON	=	0x009b
Ftest_radio_signal_tx$T2CT$0$0 == 0x009c
_T2CT	=	0x009c
Ftest_radio_signal_tx$T2PR$0$0 == 0x009d
_T2PR	=	0x009d
Ftest_radio_signal_tx$T2CTL$0$0 == 0x009e
_T2CTL	=	0x009e
Ftest_radio_signal_tx$P2$0$0 == 0x00a0
_P2	=	0x00a0
Ftest_radio_signal_tx$WORIRQ$0$0 == 0x00a1
_WORIRQ	=	0x00a1
Ftest_radio_signal_tx$WORCTRL$0$0 == 0x00a2
_WORCTRL	=	0x00a2
Ftest_radio_signal_tx$WOREVT0$0$0 == 0x00a3
_WOREVT0	=	0x00a3
Ftest_radio_signal_tx$WOREVT1$0$0 == 0x00a4
_WOREVT1	=	0x00a4
Ftest_radio_signal_tx$WORTIME0$0$0 == 0x00a5
_WORTIME0	=	0x00a5
Ftest_radio_signal_tx$WORTIME1$0$0 == 0x00a6
_WORTIME1	=	0x00a6
Ftest_radio_signal_tx$IEN0$0$0 == 0x00a8
_IEN0	=	0x00a8
Ftest_radio_signal_tx$IP0$0$0 == 0x00a9
_IP0	=	0x00a9
Ftest_radio_signal_tx$FWT$0$0 == 0x00ab
_FWT	=	0x00ab
Ftest_radio_signal_tx$FADDRL$0$0 == 0x00ac
_FADDRL	=	0x00ac
Ftest_radio_signal_tx$FADDRH$0$0 == 0x00ad
_FADDRH	=	0x00ad
Ftest_radio_signal_tx$FCTL$0$0 == 0x00ae
_FCTL	=	0x00ae
Ftest_radio_signal_tx$FWDATA$0$0 == 0x00af
_FWDATA	=	0x00af
Ftest_radio_signal_tx$ENCDI$0$0 == 0x00b1
_ENCDI	=	0x00b1
Ftest_radio_signal_tx$ENCDO$0$0 == 0x00b2
_ENCDO	=	0x00b2
Ftest_radio_signal_tx$ENCCS$0$0 == 0x00b3
_ENCCS	=	0x00b3
Ftest_radio_signal_tx$ADCCON1$0$0 == 0x00b4
_ADCCON1	=	0x00b4
Ftest_radio_signal_tx$ADCCON2$0$0 == 0x00b5
_ADCCON2	=	0x00b5
Ftest_radio_signal_tx$ADCCON3$0$0 == 0x00b6
_ADCCON3	=	0x00b6
Ftest_radio_signal_tx$IEN1$0$0 == 0x00b8
_IEN1	=	0x00b8
Ftest_radio_signal_tx$IP1$0$0 == 0x00b9
_IP1	=	0x00b9
Ftest_radio_signal_tx$ADCL$0$0 == 0x00ba
_ADCL	=	0x00ba
Ftest_radio_signal_tx$ADCH$0$0 == 0x00bb
_ADCH	=	0x00bb
Ftest_radio_signal_tx$RNDL$0$0 == 0x00bc
_RNDL	=	0x00bc
Ftest_radio_signal_tx$RNDH$0$0 == 0x00bd
_RNDH	=	0x00bd
Ftest_radio_signal_tx$SLEEP$0$0 == 0x00be
_SLEEP	=	0x00be
Ftest_radio_signal_tx$IRCON$0$0 == 0x00c0
_IRCON	=	0x00c0
Ftest_radio_signal_tx$U0DBUF$0$0 == 0x00c1
_U0DBUF	=	0x00c1
Ftest_radio_signal_tx$U0BAUD$0$0 == 0x00c2
_U0BAUD	=	0x00c2
Ftest_radio_signal_tx$U0UCR$0$0 == 0x00c4
_U0UCR	=	0x00c4
Ftest_radio_signal_tx$U0GCR$0$0 == 0x00c5
_U0GCR	=	0x00c5
Ftest_radio_signal_tx$CLKCON$0$0 == 0x00c6
_CLKCON	=	0x00c6
Ftest_radio_signal_tx$MEMCTR$0$0 == 0x00c7
_MEMCTR	=	0x00c7
Ftest_radio_signal_tx$WDCTL$0$0 == 0x00c9
_WDCTL	=	0x00c9
Ftest_radio_signal_tx$T3CNT$0$0 == 0x00ca
_T3CNT	=	0x00ca
Ftest_radio_signal_tx$T3CTL$0$0 == 0x00cb
_T3CTL	=	0x00cb
Ftest_radio_signal_tx$T3CCTL0$0$0 == 0x00cc
_T3CCTL0	=	0x00cc
Ftest_radio_signal_tx$T3CC0$0$0 == 0x00cd
_T3CC0	=	0x00cd
Ftest_radio_signal_tx$T3CCTL1$0$0 == 0x00ce
_T3CCTL1	=	0x00ce
Ftest_radio_signal_tx$T3CC1$0$0 == 0x00cf
_T3CC1	=	0x00cf
Ftest_radio_signal_tx$PSW$0$0 == 0x00d0
_PSW	=	0x00d0
Ftest_radio_signal_tx$DMAIRQ$0$0 == 0x00d1
_DMAIRQ	=	0x00d1
Ftest_radio_signal_tx$DMA1CFGL$0$0 == 0x00d2
_DMA1CFGL	=	0x00d2
Ftest_radio_signal_tx$DMA1CFGH$0$0 == 0x00d3
_DMA1CFGH	=	0x00d3
Ftest_radio_signal_tx$DMA0CFGL$0$0 == 0x00d4
_DMA0CFGL	=	0x00d4
Ftest_radio_signal_tx$DMA0CFGH$0$0 == 0x00d5
_DMA0CFGH	=	0x00d5
Ftest_radio_signal_tx$DMAARM$0$0 == 0x00d6
_DMAARM	=	0x00d6
Ftest_radio_signal_tx$DMAREQ$0$0 == 0x00d7
_DMAREQ	=	0x00d7
Ftest_radio_signal_tx$TIMIF$0$0 == 0x00d8
_TIMIF	=	0x00d8
Ftest_radio_signal_tx$RFD$0$0 == 0x00d9
_RFD	=	0x00d9
Ftest_radio_signal_tx$T1CC0L$0$0 == 0x00da
_T1CC0L	=	0x00da
Ftest_radio_signal_tx$T1CC0H$0$0 == 0x00db
_T1CC0H	=	0x00db
Ftest_radio_signal_tx$T1CC1L$0$0 == 0x00dc
_T1CC1L	=	0x00dc
Ftest_radio_signal_tx$T1CC1H$0$0 == 0x00dd
_T1CC1H	=	0x00dd
Ftest_radio_signal_tx$T1CC2L$0$0 == 0x00de
_T1CC2L	=	0x00de
Ftest_radio_signal_tx$T1CC2H$0$0 == 0x00df
_T1CC2H	=	0x00df
Ftest_radio_signal_tx$ACC$0$0 == 0x00e0
_ACC	=	0x00e0
Ftest_radio_signal_tx$RFST$0$0 == 0x00e1
_RFST	=	0x00e1
Ftest_radio_signal_tx$T1CNTL$0$0 == 0x00e2
_T1CNTL	=	0x00e2
Ftest_radio_signal_tx$T1CNTH$0$0 == 0x00e3
_T1CNTH	=	0x00e3
Ftest_radio_signal_tx$T1CTL$0$0 == 0x00e4
_T1CTL	=	0x00e4
Ftest_radio_signal_tx$T1CCTL0$0$0 == 0x00e5
_T1CCTL0	=	0x00e5
Ftest_radio_signal_tx$T1CCTL1$0$0 == 0x00e6
_T1CCTL1	=	0x00e6
Ftest_radio_signal_tx$T1CCTL2$0$0 == 0x00e7
_T1CCTL2	=	0x00e7
Ftest_radio_signal_tx$IRCON2$0$0 == 0x00e8
_IRCON2	=	0x00e8
Ftest_radio_signal_tx$RFIF$0$0 == 0x00e9
_RFIF	=	0x00e9
Ftest_radio_signal_tx$T4CNT$0$0 == 0x00ea
_T4CNT	=	0x00ea
Ftest_radio_signal_tx$T4CTL$0$0 == 0x00eb
_T4CTL	=	0x00eb
Ftest_radio_signal_tx$T4CCTL0$0$0 == 0x00ec
_T4CCTL0	=	0x00ec
Ftest_radio_signal_tx$T4CC0$0$0 == 0x00ed
_T4CC0	=	0x00ed
Ftest_radio_signal_tx$T4CCTL1$0$0 == 0x00ee
_T4CCTL1	=	0x00ee
Ftest_radio_signal_tx$T4CC1$0$0 == 0x00ef
_T4CC1	=	0x00ef
Ftest_radio_signal_tx$B$0$0 == 0x00f0
_B	=	0x00f0
Ftest_radio_signal_tx$PERCFG$0$0 == 0x00f1
_PERCFG	=	0x00f1
Ftest_radio_signal_tx$ADCCFG$0$0 == 0x00f2
_ADCCFG	=	0x00f2
Ftest_radio_signal_tx$P0SEL$0$0 == 0x00f3
_P0SEL	=	0x00f3
Ftest_radio_signal_tx$P1SEL$0$0 == 0x00f4
_P1SEL	=	0x00f4
Ftest_radio_signal_tx$P2SEL$0$0 == 0x00f5
_P2SEL	=	0x00f5
Ftest_radio_signal_tx$P1INP$0$0 == 0x00f6
_P1INP	=	0x00f6
Ftest_radio_signal_tx$P2INP$0$0 == 0x00f7
_P2INP	=	0x00f7
Ftest_radio_signal_tx$U1CSR$0$0 == 0x00f8
_U1CSR	=	0x00f8
Ftest_radio_signal_tx$U1DBUF$0$0 == 0x00f9
_U1DBUF	=	0x00f9
Ftest_radio_signal_tx$U1BAUD$0$0 == 0x00fa
_U1BAUD	=	0x00fa
Ftest_radio_signal_tx$U1UCR$0$0 == 0x00fb
_U1UCR	=	0x00fb
Ftest_radio_signal_tx$U1GCR$0$0 == 0x00fc
_U1GCR	=	0x00fc
Ftest_radio_signal_tx$P0DIR$0$0 == 0x00fd
_P0DIR	=	0x00fd
Ftest_radio_signal_tx$P1DIR$0$0 == 0x00fe
_P1DIR	=	0x00fe
Ftest_radio_signal_tx$P2DIR$0$0 == 0x00ff
_P2DIR	=	0x00ff
Ftest_radio_signal_tx$DMA0CFG$0$0 == 0xffffd5d4
_DMA0CFG	=	0xffffd5d4
Ftest_radio_signal_tx$DMA1CFG$0$0 == 0xffffd3d2
_DMA1CFG	=	0xffffd3d2
Ftest_radio_signal_tx$FADDR$0$0 == 0xffffadac
_FADDR	=	0xffffadac
Ftest_radio_signal_tx$ADC$0$0 == 0xffffbbba
_ADC	=	0xffffbbba
Ftest_radio_signal_tx$T1CC0$0$0 == 0xffffdbda
_T1CC0	=	0xffffdbda
Ftest_radio_signal_tx$T1CC1$0$0 == 0xffffdddc
_T1CC1	=	0xffffdddc
Ftest_radio_signal_tx$T1CC2$0$0 == 0xffffdfde
_T1CC2	=	0xffffdfde
;--------------------------------------------------------
; special function bits
;--------------------------------------------------------
	.area RSEG    (ABS,DATA)
	.org 0x0000
Ftest_radio_signal_tx$P0_0$0$0 == 0x0080
_P0_0	=	0x0080
Ftest_radio_signal_tx$P0_1$0$0 == 0x0081
_P0_1	=	0x0081
Ftest_radio_signal_tx$P0_2$0$0 == 0x0082
_P0_2	=	0x0082
Ftest_radio_signal_tx$P0_3$0$0 == 0x0083
_P0_3	=	0x0083
Ftest_radio_signal_tx$P0_4$0$0 == 0x0084
_P0_4	=	0x0084
Ftest_radio_signal_tx$P0_5$0$0 == 0x0085
_P0_5	=	0x0085
Ftest_radio_signal_tx$P0_6$0$0 == 0x0086
_P0_6	=	0x0086
Ftest_radio_signal_tx$P0_7$0$0 == 0x0087
_P0_7	=	0x0087
Ftest_radio_signal_tx$_TCON_0$0$0 == 0x0088
__TCON_0	=	0x0088
Ftest_radio_signal_tx$RFTXRXIF$0$0 == 0x0089
_RFTXRXIF	=	0x0089
Ftest_radio_signal_tx$_TCON_2$0$0 == 0x008a
__TCON_2	=	0x008a
Ftest_radio_signal_tx$URX0IF$0$0 == 0x008b
_URX0IF	=	0x008b
Ftest_radio_signal_tx$_TCON_4$0$0 == 0x008c
__TCON_4	=	0x008c
Ftest_radio_signal_tx$ADCIF$0$0 == 0x008d
_ADCIF	=	0x008d
Ftest_radio_signal_tx$_TCON_6$0$0 == 0x008e
__TCON_6	=	0x008e
Ftest_radio_signal_tx$URX1IF$0$0 == 0x008f
_URX1IF	=	0x008f
Ftest_radio_signal_tx$P1_0$0$0 == 0x0090
_P1_0	=	0x0090
Ftest_radio_signal_tx$P1_1$0$0 == 0x0091
_P1_1	=	0x0091
Ftest_radio_signal_tx$P1_2$0$0 == 0x0092
_P1_2	=	0x0092
Ftest_radio_signal_tx$P1_3$0$0 == 0x0093
_P1_3	=	0x0093
Ftest_radio_signal_tx$P1_4$0$0 == 0x0094
_P1_4	=	0x0094
Ftest_radio_signal_tx$P1_5$0$0 == 0x0095
_P1_5	=	0x0095
Ftest_radio_signal_tx$P1_6$0$0 == 0x0096
_P1_6	=	0x0096
Ftest_radio_signal_tx$P1_7$0$0 == 0x0097
_P1_7	=	0x0097
Ftest_radio_signal_tx$ENCIF_0$0$0 == 0x0098
_ENCIF_0	=	0x0098
Ftest_radio_signal_tx$ENCIF_1$0$0 == 0x0099
_ENCIF_1	=	0x0099
Ftest_radio_signal_tx$_SOCON2$0$0 == 0x009a
__SOCON2	=	0x009a
Ftest_radio_signal_tx$_SOCON3$0$0 == 0x009b
__SOCON3	=	0x009b
Ftest_radio_signal_tx$_SOCON4$0$0 == 0x009c
__SOCON4	=	0x009c
Ftest_radio_signal_tx$_SOCON5$0$0 == 0x009d
__SOCON5	=	0x009d
Ftest_radio_signal_tx$_SOCON6$0$0 == 0x009e
__SOCON6	=	0x009e
Ftest_radio_signal_tx$_SOCON7$0$0 == 0x009f
__SOCON7	=	0x009f
Ftest_radio_signal_tx$P2_0$0$0 == 0x00a0
_P2_0	=	0x00a0
Ftest_radio_signal_tx$P2_1$0$0 == 0x00a1
_P2_1	=	0x00a1
Ftest_radio_signal_tx$P2_2$0$0 == 0x00a2
_P2_2	=	0x00a2
Ftest_radio_signal_tx$P2_3$0$0 == 0x00a3
_P2_3	=	0x00a3
Ftest_radio_signal_tx$P2_4$0$0 == 0x00a4
_P2_4	=	0x00a4
Ftest_radio_signal_tx$P2_5$0$0 == 0x00a5
_P2_5	=	0x00a5
Ftest_radio_signal_tx$P2_6$0$0 == 0x00a6
_P2_6	=	0x00a6
Ftest_radio_signal_tx$P2_7$0$0 == 0x00a7
_P2_7	=	0x00a7
Ftest_radio_signal_tx$RFTXRXIE$0$0 == 0x00a8
_RFTXRXIE	=	0x00a8
Ftest_radio_signal_tx$ADCIE$0$0 == 0x00a9
_ADCIE	=	0x00a9
Ftest_radio_signal_tx$URX0IE$0$0 == 0x00aa
_URX0IE	=	0x00aa
Ftest_radio_signal_tx$URX1IE$0$0 == 0x00ab
_URX1IE	=	0x00ab
Ftest_radio_signal_tx$ENCIE$0$0 == 0x00ac
_ENCIE	=	0x00ac
Ftest_radio_signal_tx$STIE$0$0 == 0x00ad
_STIE	=	0x00ad
Ftest_radio_signal_tx$_IEN06$0$0 == 0x00ae
__IEN06	=	0x00ae
Ftest_radio_signal_tx$EA$0$0 == 0x00af
_EA	=	0x00af
Ftest_radio_signal_tx$DMAIE$0$0 == 0x00b8
_DMAIE	=	0x00b8
Ftest_radio_signal_tx$T1IE$0$0 == 0x00b9
_T1IE	=	0x00b9
Ftest_radio_signal_tx$T2IE$0$0 == 0x00ba
_T2IE	=	0x00ba
Ftest_radio_signal_tx$T3IE$0$0 == 0x00bb
_T3IE	=	0x00bb
Ftest_radio_signal_tx$T4IE$0$0 == 0x00bc
_T4IE	=	0x00bc
Ftest_radio_signal_tx$P0IE$0$0 == 0x00bd
_P0IE	=	0x00bd
Ftest_radio_signal_tx$_IEN16$0$0 == 0x00be
__IEN16	=	0x00be
Ftest_radio_signal_tx$_IEN17$0$0 == 0x00bf
__IEN17	=	0x00bf
Ftest_radio_signal_tx$DMAIF$0$0 == 0x00c0
_DMAIF	=	0x00c0
Ftest_radio_signal_tx$T1IF$0$0 == 0x00c1
_T1IF	=	0x00c1
Ftest_radio_signal_tx$T2IF$0$0 == 0x00c2
_T2IF	=	0x00c2
Ftest_radio_signal_tx$T3IF$0$0 == 0x00c3
_T3IF	=	0x00c3
Ftest_radio_signal_tx$T4IF$0$0 == 0x00c4
_T4IF	=	0x00c4
Ftest_radio_signal_tx$P0IF$0$0 == 0x00c5
_P0IF	=	0x00c5
Ftest_radio_signal_tx$_IRCON6$0$0 == 0x00c6
__IRCON6	=	0x00c6
Ftest_radio_signal_tx$STIF$0$0 == 0x00c7
_STIF	=	0x00c7
Ftest_radio_signal_tx$P$0$0 == 0x00d0
_P	=	0x00d0
Ftest_radio_signal_tx$F1$0$0 == 0x00d1
_F1	=	0x00d1
Ftest_radio_signal_tx$OV$0$0 == 0x00d2
_OV	=	0x00d2
Ftest_radio_signal_tx$RS0$0$0 == 0x00d3
_RS0	=	0x00d3
Ftest_radio_signal_tx$RS1$0$0 == 0x00d4
_RS1	=	0x00d4
Ftest_radio_signal_tx$F0$0$0 == 0x00d5
_F0	=	0x00d5
Ftest_radio_signal_tx$AC$0$0 == 0x00d6
_AC	=	0x00d6
Ftest_radio_signal_tx$CY$0$0 == 0x00d7
_CY	=	0x00d7
Ftest_radio_signal_tx$T3OVFIF$0$0 == 0x00d8
_T3OVFIF	=	0x00d8
Ftest_radio_signal_tx$T3CH0IF$0$0 == 0x00d9
_T3CH0IF	=	0x00d9
Ftest_radio_signal_tx$T3CH1IF$0$0 == 0x00da
_T3CH1IF	=	0x00da
Ftest_radio_signal_tx$T4OVFIF$0$0 == 0x00db
_T4OVFIF	=	0x00db
Ftest_radio_signal_tx$T4CH0IF$0$0 == 0x00dc
_T4CH0IF	=	0x00dc
Ftest_radio_signal_tx$T4CH1IF$0$0 == 0x00dd
_T4CH1IF	=	0x00dd
Ftest_radio_signal_tx$OVFIM$0$0 == 0x00de
_OVFIM	=	0x00de
Ftest_radio_signal_tx$_TIMIF7$0$0 == 0x00df
__TIMIF7	=	0x00df
Ftest_radio_signal_tx$ACC_0$0$0 == 0x00e0
_ACC_0	=	0x00e0
Ftest_radio_signal_tx$ACC_1$0$0 == 0x00e1
_ACC_1	=	0x00e1
Ftest_radio_signal_tx$ACC_2$0$0 == 0x00e2
_ACC_2	=	0x00e2
Ftest_radio_signal_tx$ACC_3$0$0 == 0x00e3
_ACC_3	=	0x00e3
Ftest_radio_signal_tx$ACC_4$0$0 == 0x00e4
_ACC_4	=	0x00e4
Ftest_radio_signal_tx$ACC_5$0$0 == 0x00e5
_ACC_5	=	0x00e5
Ftest_radio_signal_tx$ACC_6$0$0 == 0x00e6
_ACC_6	=	0x00e6
Ftest_radio_signal_tx$ACC_7$0$0 == 0x00e7
_ACC_7	=	0x00e7
Ftest_radio_signal_tx$P2IF$0$0 == 0x00e8
_P2IF	=	0x00e8
Ftest_radio_signal_tx$UTX0IF$0$0 == 0x00e9
_UTX0IF	=	0x00e9
Ftest_radio_signal_tx$UTX1IF$0$0 == 0x00ea
_UTX1IF	=	0x00ea
Ftest_radio_signal_tx$P1IF$0$0 == 0x00eb
_P1IF	=	0x00eb
Ftest_radio_signal_tx$WDTIF$0$0 == 0x00ec
_WDTIF	=	0x00ec
Ftest_radio_signal_tx$_IRCON25$0$0 == 0x00ed
__IRCON25	=	0x00ed
Ftest_radio_signal_tx$_IRCON26$0$0 == 0x00ee
__IRCON26	=	0x00ee
Ftest_radio_signal_tx$_IRCON27$0$0 == 0x00ef
__IRCON27	=	0x00ef
Ftest_radio_signal_tx$B_0$0$0 == 0x00f0
_B_0	=	0x00f0
Ftest_radio_signal_tx$B_1$0$0 == 0x00f1
_B_1	=	0x00f1
Ftest_radio_signal_tx$B_2$0$0 == 0x00f2
_B_2	=	0x00f2
Ftest_radio_signal_tx$B_3$0$0 == 0x00f3
_B_3	=	0x00f3
Ftest_radio_signal_tx$B_4$0$0 == 0x00f4
_B_4	=	0x00f4
Ftest_radio_signal_tx$B_5$0$0 == 0x00f5
_B_5	=	0x00f5
Ftest_radio_signal_tx$B_6$0$0 == 0x00f6
_B_6	=	0x00f6
Ftest_radio_signal_tx$B_7$0$0 == 0x00f7
_B_7	=	0x00f7
Ftest_radio_signal_tx$U1ACTIVE$0$0 == 0x00f8
_U1ACTIVE	=	0x00f8
Ftest_radio_signal_tx$U1TX_BYTE$0$0 == 0x00f9
_U1TX_BYTE	=	0x00f9
Ftest_radio_signal_tx$U1RX_BYTE$0$0 == 0x00fa
_U1RX_BYTE	=	0x00fa
Ftest_radio_signal_tx$U1ERR$0$0 == 0x00fb
_U1ERR	=	0x00fb
Ftest_radio_signal_tx$U1FE$0$0 == 0x00fc
_U1FE	=	0x00fc
Ftest_radio_signal_tx$U1SLAVE$0$0 == 0x00fd
_U1SLAVE	=	0x00fd
Ftest_radio_signal_tx$U1RE$0$0 == 0x00fe
_U1RE	=	0x00fe
Ftest_radio_signal_tx$U1MODE$0$0 == 0x00ff
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
;--------------------------------------------------------
; paged external ram data
;--------------------------------------------------------
	.area PSEG    (PAG,XDATA)
Ftest_radio_signal_tx$currentBurstId$0$0==.
_currentBurstId:
	.ds 1
Ftest_radio_signal_tx$packetsSent$0$0==.
_packetsSent:
	.ds 1
Ftest_radio_signal_tx$lastBurst$0$0==.
_lastBurst:
	.ds 2
;--------------------------------------------------------
; external ram data
;--------------------------------------------------------
	.area XSEG    (XDATA)
Ftest_radio_signal_tx$SYNC1$0$0 == 0xdf00
_SYNC1	=	0xdf00
Ftest_radio_signal_tx$SYNC0$0$0 == 0xdf01
_SYNC0	=	0xdf01
Ftest_radio_signal_tx$PKTLEN$0$0 == 0xdf02
_PKTLEN	=	0xdf02
Ftest_radio_signal_tx$PKTCTRL1$0$0 == 0xdf03
_PKTCTRL1	=	0xdf03
Ftest_radio_signal_tx$PKTCTRL0$0$0 == 0xdf04
_PKTCTRL0	=	0xdf04
Ftest_radio_signal_tx$ADDR$0$0 == 0xdf05
_ADDR	=	0xdf05
Ftest_radio_signal_tx$CHANNR$0$0 == 0xdf06
_CHANNR	=	0xdf06
Ftest_radio_signal_tx$FSCTRL1$0$0 == 0xdf07
_FSCTRL1	=	0xdf07
Ftest_radio_signal_tx$FSCTRL0$0$0 == 0xdf08
_FSCTRL0	=	0xdf08
Ftest_radio_signal_tx$FREQ2$0$0 == 0xdf09
_FREQ2	=	0xdf09
Ftest_radio_signal_tx$FREQ1$0$0 == 0xdf0a
_FREQ1	=	0xdf0a
Ftest_radio_signal_tx$FREQ0$0$0 == 0xdf0b
_FREQ0	=	0xdf0b
Ftest_radio_signal_tx$MDMCFG4$0$0 == 0xdf0c
_MDMCFG4	=	0xdf0c
Ftest_radio_signal_tx$MDMCFG3$0$0 == 0xdf0d
_MDMCFG3	=	0xdf0d
Ftest_radio_signal_tx$MDMCFG2$0$0 == 0xdf0e
_MDMCFG2	=	0xdf0e
Ftest_radio_signal_tx$MDMCFG1$0$0 == 0xdf0f
_MDMCFG1	=	0xdf0f
Ftest_radio_signal_tx$MDMCFG0$0$0 == 0xdf10
_MDMCFG0	=	0xdf10
Ftest_radio_signal_tx$DEVIATN$0$0 == 0xdf11
_DEVIATN	=	0xdf11
Ftest_radio_signal_tx$MCSM2$0$0 == 0xdf12
_MCSM2	=	0xdf12
Ftest_radio_signal_tx$MCSM1$0$0 == 0xdf13
_MCSM1	=	0xdf13
Ftest_radio_signal_tx$MCSM0$0$0 == 0xdf14
_MCSM0	=	0xdf14
Ftest_radio_signal_tx$FOCCFG$0$0 == 0xdf15
_FOCCFG	=	0xdf15
Ftest_radio_signal_tx$BSCFG$0$0 == 0xdf16
_BSCFG	=	0xdf16
Ftest_radio_signal_tx$AGCCTRL2$0$0 == 0xdf17
_AGCCTRL2	=	0xdf17
Ftest_radio_signal_tx$AGCCTRL1$0$0 == 0xdf18
_AGCCTRL1	=	0xdf18
Ftest_radio_signal_tx$AGCCTRL0$0$0 == 0xdf19
_AGCCTRL0	=	0xdf19
Ftest_radio_signal_tx$FREND1$0$0 == 0xdf1a
_FREND1	=	0xdf1a
Ftest_radio_signal_tx$FREND0$0$0 == 0xdf1b
_FREND0	=	0xdf1b
Ftest_radio_signal_tx$FSCAL3$0$0 == 0xdf1c
_FSCAL3	=	0xdf1c
Ftest_radio_signal_tx$FSCAL2$0$0 == 0xdf1d
_FSCAL2	=	0xdf1d
Ftest_radio_signal_tx$FSCAL1$0$0 == 0xdf1e
_FSCAL1	=	0xdf1e
Ftest_radio_signal_tx$FSCAL0$0$0 == 0xdf1f
_FSCAL0	=	0xdf1f
Ftest_radio_signal_tx$TEST2$0$0 == 0xdf23
_TEST2	=	0xdf23
Ftest_radio_signal_tx$TEST1$0$0 == 0xdf24
_TEST1	=	0xdf24
Ftest_radio_signal_tx$TEST0$0$0 == 0xdf25
_TEST0	=	0xdf25
Ftest_radio_signal_tx$PA_TABLE0$0$0 == 0xdf2e
_PA_TABLE0	=	0xdf2e
Ftest_radio_signal_tx$IOCFG2$0$0 == 0xdf2f
_IOCFG2	=	0xdf2f
Ftest_radio_signal_tx$IOCFG1$0$0 == 0xdf30
_IOCFG1	=	0xdf30
Ftest_radio_signal_tx$IOCFG0$0$0 == 0xdf31
_IOCFG0	=	0xdf31
Ftest_radio_signal_tx$PARTNUM$0$0 == 0xdf36
_PARTNUM	=	0xdf36
Ftest_radio_signal_tx$VERSION$0$0 == 0xdf37
_VERSION	=	0xdf37
Ftest_radio_signal_tx$FREQEST$0$0 == 0xdf38
_FREQEST	=	0xdf38
Ftest_radio_signal_tx$LQI$0$0 == 0xdf39
_LQI	=	0xdf39
Ftest_radio_signal_tx$RSSI$0$0 == 0xdf3a
_RSSI	=	0xdf3a
Ftest_radio_signal_tx$MARCSTATE$0$0 == 0xdf3b
_MARCSTATE	=	0xdf3b
Ftest_radio_signal_tx$PKTSTATUS$0$0 == 0xdf3c
_PKTSTATUS	=	0xdf3c
Ftest_radio_signal_tx$VCO_VC_DAC$0$0 == 0xdf3d
_VCO_VC_DAC	=	0xdf3d
Ftest_radio_signal_tx$I2SCFG0$0$0 == 0xdf40
_I2SCFG0	=	0xdf40
Ftest_radio_signal_tx$I2SCFG1$0$0 == 0xdf41
_I2SCFG1	=	0xdf41
Ftest_radio_signal_tx$I2SDATL$0$0 == 0xdf42
_I2SDATL	=	0xdf42
Ftest_radio_signal_tx$I2SDATH$0$0 == 0xdf43
_I2SDATH	=	0xdf43
Ftest_radio_signal_tx$I2SWCNT$0$0 == 0xdf44
_I2SWCNT	=	0xdf44
Ftest_radio_signal_tx$I2SSTAT$0$0 == 0xdf45
_I2SSTAT	=	0xdf45
Ftest_radio_signal_tx$I2SCLKF0$0$0 == 0xdf46
_I2SCLKF0	=	0xdf46
Ftest_radio_signal_tx$I2SCLKF1$0$0 == 0xdf47
_I2SCLKF1	=	0xdf47
Ftest_radio_signal_tx$I2SCLKF2$0$0 == 0xdf48
_I2SCLKF2	=	0xdf48
Ftest_radio_signal_tx$USBADDR$0$0 == 0xde00
_USBADDR	=	0xde00
Ftest_radio_signal_tx$USBPOW$0$0 == 0xde01
_USBPOW	=	0xde01
Ftest_radio_signal_tx$USBIIF$0$0 == 0xde02
_USBIIF	=	0xde02
Ftest_radio_signal_tx$USBOIF$0$0 == 0xde04
_USBOIF	=	0xde04
Ftest_radio_signal_tx$USBCIF$0$0 == 0xde06
_USBCIF	=	0xde06
Ftest_radio_signal_tx$USBIIE$0$0 == 0xde07
_USBIIE	=	0xde07
Ftest_radio_signal_tx$USBOIE$0$0 == 0xde09
_USBOIE	=	0xde09
Ftest_radio_signal_tx$USBCIE$0$0 == 0xde0b
_USBCIE	=	0xde0b
Ftest_radio_signal_tx$USBFRML$0$0 == 0xde0c
_USBFRML	=	0xde0c
Ftest_radio_signal_tx$USBFRMH$0$0 == 0xde0d
_USBFRMH	=	0xde0d
Ftest_radio_signal_tx$USBINDEX$0$0 == 0xde0e
_USBINDEX	=	0xde0e
Ftest_radio_signal_tx$USBMAXI$0$0 == 0xde10
_USBMAXI	=	0xde10
Ftest_radio_signal_tx$USBCSIL$0$0 == 0xde11
_USBCSIL	=	0xde11
Ftest_radio_signal_tx$USBCSIH$0$0 == 0xde12
_USBCSIH	=	0xde12
Ftest_radio_signal_tx$USBMAXO$0$0 == 0xde13
_USBMAXO	=	0xde13
Ftest_radio_signal_tx$USBCSOL$0$0 == 0xde14
_USBCSOL	=	0xde14
Ftest_radio_signal_tx$USBCSOH$0$0 == 0xde15
_USBCSOH	=	0xde15
Ftest_radio_signal_tx$USBCNTL$0$0 == 0xde16
_USBCNTL	=	0xde16
Ftest_radio_signal_tx$USBCNTH$0$0 == 0xde17
_USBCNTH	=	0xde17
Ftest_radio_signal_tx$USBF0$0$0 == 0xde20
_USBF0	=	0xde20
Ftest_radio_signal_tx$USBF1$0$0 == 0xde22
_USBF1	=	0xde22
Ftest_radio_signal_tx$USBF2$0$0 == 0xde24
_USBF2	=	0xde24
Ftest_radio_signal_tx$USBF3$0$0 == 0xde26
_USBF3	=	0xde26
Ftest_radio_signal_tx$USBF4$0$0 == 0xde28
_USBF4	=	0xde28
Ftest_radio_signal_tx$USBF5$0$0 == 0xde2a
_USBF5	=	0xde2a
Ftest_radio_signal_tx$packet$0$0==.
_packet:
	.ds 17
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
	C$test_radio_signal_tx.c$20$1$1 ==.
;	apps/test_radio_signal_tx/test_radio_signal_tx.c:20: static uint8 currentBurstId = 0;
	mov	r0,#_currentBurstId
	clr	a
	movx	@r0,a
	G$main$0$0 ==.
	C$test_radio_signal_tx.c$21$1$1 ==.
;	apps/test_radio_signal_tx/test_radio_signal_tx.c:21: static uint8 packetsSent = 0;
	mov	r0,#_packetsSent
	clr	a
	movx	@r0,a
	G$main$0$0 ==.
	C$test_radio_signal_tx.c$22$1$1 ==.
;	apps/test_radio_signal_tx/test_radio_signal_tx.c:22: static uint16 lastBurst = 0;
	mov	r0,#_lastBurst
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
;Allocation info for local variables in function 'updateLeds'
;------------------------------------------------------------
	G$updateLeds$0$0 ==.
	C$test_radio_signal_tx.c$24$0$0 ==.
;	apps/test_radio_signal_tx/test_radio_signal_tx.c:24: void updateLeds()
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
	C$test_radio_signal_tx.c$26$1$1 ==.
;	apps/test_radio_signal_tx/test_radio_signal_tx.c:26: usbShowStatusWithGreenLed();
	lcall	_usbShowStatusWithGreenLed
	C$test_radio_signal_tx.c$28$2$2 ==.
;	apps/test_radio_signal_tx/test_radio_signal_tx.c:28: LED_YELLOW(0);
	mov	r7,_P2DIR
	anl	ar7,#0xFB
	mov	_P2DIR,r7
	C$test_radio_signal_tx.c$31$2$3 ==.
;	apps/test_radio_signal_tx/test_radio_signal_tx.c:31: LED_RED((uint16)(packetsSent < 100));
	mov	r0,#_packetsSent
	movx	a,@r0
	cjne	a,#0x64,00106$
00106$:
	clr	a
	rlc	a
	mov	r7,a
	rlc	a
	subb	a,acc
	mov	r6,a
	orl	a,r7
	jz	00103$
	orl	_P2DIR,#0x02
	sjmp	00101$
00103$:
	mov	r7,_P2DIR
	anl	ar7,#0xFD
	mov	_P2DIR,r7
00101$:
	C$test_radio_signal_tx.c$32$2$3 ==.
	XG$updateLeds$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'perTestTxInit'
;------------------------------------------------------------
	G$perTestTxInit$0$0 ==.
	C$test_radio_signal_tx.c$34$2$3 ==.
;	apps/test_radio_signal_tx/test_radio_signal_tx.c:34: void perTestTxInit()
;	-----------------------------------------
;	 function perTestTxInit
;	-----------------------------------------
_perTestTxInit:
	C$test_radio_signal_tx.c$38$1$1 ==.
;	apps/test_radio_signal_tx/test_radio_signal_tx.c:38: radioRegistersInit();
	lcall	_radioRegistersInit
	C$test_radio_signal_tx.c$40$1$1 ==.
;	apps/test_radio_signal_tx/test_radio_signal_tx.c:40: CHANNR = param_radio_channel;
	mov	dptr,#_param_radio_channel
	clr	a
	movc	a,@a+dptr
	mov	r4,a
	mov	a,#0x01
	movc	a,@a+dptr
	mov	r5,a
	mov	a,#0x02
	movc	a,@a+dptr
	mov	a,#0x03
	movc	a,@a+dptr
	mov	dptr,#_CHANNR
	mov	a,r4
	movx	@dptr,a
	C$test_radio_signal_tx.c$42$1$1 ==.
;	apps/test_radio_signal_tx/test_radio_signal_tx.c:42: PKTLEN = RADIO_PACKET_SIZE;
	mov	dptr,#_PKTLEN
	mov	a,#0x10
	movx	@dptr,a
	C$test_radio_signal_tx.c$44$1$1 ==.
;	apps/test_radio_signal_tx/test_radio_signal_tx.c:44: MCSM0 = 0x14;    // Auto-calibrate when going from idle to RX or TX.
	mov	dptr,#_MCSM0
	mov	a,#0x14
	movx	@dptr,a
	C$test_radio_signal_tx.c$45$1$1 ==.
;	apps/test_radio_signal_tx/test_radio_signal_tx.c:45: MCSM1 = 0x00;    // Disable CCA.  After RX, go to IDLE.  After TX, go to IDLE.
	mov	dptr,#_MCSM1
	clr	a
	movx	@dptr,a
	C$test_radio_signal_tx.c$48$1$1 ==.
;	apps/test_radio_signal_tx/test_radio_signal_tx.c:48: IOCFG2 = 0b011011; // put out a PA_PD signal on P1_7 (active low when the radio is in TX mode)
	mov	dptr,#_IOCFG2
	mov	a,#0x1B
	movx	@dptr,a
	C$test_radio_signal_tx.c$50$1$1 ==.
;	apps/test_radio_signal_tx/test_radio_signal_tx.c:50: dmaConfig.radio.DC6 = 19; // WORDSIZE = 0, TMODE = 0, TRIG = 19
	mov	dptr,#(_dmaConfig + 0x0006)
	mov	a,#0x13
	movx	@dptr,a
	C$test_radio_signal_tx.c$52$1$1 ==.
;	apps/test_radio_signal_tx/test_radio_signal_tx.c:52: dmaConfig.radio.SRCADDRH = (unsigned int)packet >> 8;
	mov	r6,#_packet
	mov	r7,#(_packet >> 8)
	mov	ar6,r7
	mov	dptr,#_dmaConfig
	mov	a,r6
	movx	@dptr,a
	C$test_radio_signal_tx.c$53$1$1 ==.
;	apps/test_radio_signal_tx/test_radio_signal_tx.c:53: dmaConfig.radio.SRCADDRL = (unsigned int)packet;
	mov	r6,#_packet
	mov	r7,#(_packet >> 8)
	mov	dptr,#(_dmaConfig + 0x0001)
	mov	a,r6
	movx	@dptr,a
	C$test_radio_signal_tx.c$54$1$1 ==.
;	apps/test_radio_signal_tx/test_radio_signal_tx.c:54: dmaConfig.radio.DESTADDRH = XDATA_SFR_ADDRESS(RFD) >> 8;
	mov	r6,#_RFD
	mov	r7,#0x00
	mov	a,#0xDF
	add	a,r7
	mov	r6,a
	mov	dptr,#(_dmaConfig + 0x0002)
	mov	a,r6
	movx	@dptr,a
	C$test_radio_signal_tx.c$55$1$1 ==.
;	apps/test_radio_signal_tx/test_radio_signal_tx.c:55: dmaConfig.radio.DESTADDRL = XDATA_SFR_ADDRESS(RFD);
	mov	r6,#_RFD
	mov	dptr,#(_dmaConfig + 0x0003)
	mov	a,r6
	movx	@dptr,a
	C$test_radio_signal_tx.c$56$1$1 ==.
;	apps/test_radio_signal_tx/test_radio_signal_tx.c:56: dmaConfig.radio.LENL = 1 + RADIO_PACKET_SIZE;
	mov	dptr,#(_dmaConfig + 0x0005)
	mov	a,#0x11
	movx	@dptr,a
	C$test_radio_signal_tx.c$57$1$1 ==.
;	apps/test_radio_signal_tx/test_radio_signal_tx.c:57: dmaConfig.radio.VLEN_LENH = 0b00100000; // Transfer length is FirstByte+1
	mov	dptr,#(_dmaConfig + 0x0004)
	mov	a,#0x20
	movx	@dptr,a
	C$test_radio_signal_tx.c$58$1$1 ==.
;	apps/test_radio_signal_tx/test_radio_signal_tx.c:58: dmaConfig.radio.DC7 = 0x40; // SRCINC = 1, DESTINC = 0, IRQMASK = 0, M8 = 0, PRIORITY = 0
	mov	dptr,#(_dmaConfig + 0x0007)
	mov	a,#0x40
	movx	@dptr,a
	C$test_radio_signal_tx.c$60$1$1 ==.
;	apps/test_radio_signal_tx/test_radio_signal_tx.c:60: for(i = 1; i < sizeof(packet); i++)
	mov	r7,#0x01
00101$:
	cjne	r7,#0x11,00110$
00110$:
	jnc	00104$
	C$test_radio_signal_tx.c$62$2$2 ==.
;	apps/test_radio_signal_tx/test_radio_signal_tx.c:62: packet[i] = 'A' + i;
	mov	a,r7
	add	a,#_packet
	mov	dpl,a
	clr	a
	addc	a,#(_packet >> 8)
	mov	dph,a
	mov	ar6,r7
	mov	a,#0x41
	add	a,r6
	mov	r6,a
	movx	@dptr,a
	C$test_radio_signal_tx.c$60$1$1 ==.
;	apps/test_radio_signal_tx/test_radio_signal_tx.c:60: for(i = 1; i < sizeof(packet); i++)
	inc	r7
	sjmp	00101$
00104$:
	C$test_radio_signal_tx.c$64$1$1 ==.
;	apps/test_radio_signal_tx/test_radio_signal_tx.c:64: packet[0] = RADIO_PACKET_SIZE;
	mov	dptr,#_packet
	mov	a,#0x10
	movx	@dptr,a
	C$test_radio_signal_tx.c$66$1$1 ==.
;	apps/test_radio_signal_tx/test_radio_signal_tx.c:66: RFST = 4;  // Switch radio to Idle mode.
	mov	_RFST,#0x04
	C$test_radio_signal_tx.c$67$1$1 ==.
	XG$perTestTxInit$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'sendRadioBursts'
;------------------------------------------------------------
	G$sendRadioBursts$0$0 ==.
	C$test_radio_signal_tx.c$69$1$1 ==.
;	apps/test_radio_signal_tx/test_radio_signal_tx.c:69: void sendRadioBursts()
;	-----------------------------------------
;	 function sendRadioBursts
;	-----------------------------------------
_sendRadioBursts:
	C$test_radio_signal_tx.c$71$1$1 ==.
;	apps/test_radio_signal_tx/test_radio_signal_tx.c:71: uint16 time = (uint16)getMs();
	lcall	_getMs
	mov	r4,dpl
	mov	r5,dph
	C$test_radio_signal_tx.c$73$1$1 ==.
;	apps/test_radio_signal_tx/test_radio_signal_tx.c:73: if ((uint16)(time - lastBurst) > 1000)
	mov	r0,#_lastBurst
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
	mov	a,#0xE8
	subb	a,r6
	mov	a,#0x03
	subb	a,r7
	jnc	00102$
	C$test_radio_signal_tx.c$75$2$2 ==.
;	apps/test_radio_signal_tx/test_radio_signal_tx.c:75: lastBurst = time;
	mov	r0,#_lastBurst
	mov	a,r4
	movx	@r0,a
	inc	r0
	mov	a,r5
	movx	@r0,a
	C$test_radio_signal_tx.c$77$2$2 ==.
;	apps/test_radio_signal_tx/test_radio_signal_tx.c:77: currentBurstId++;
	mov	r0,#_currentBurstId
	movx	a,@r0
	add	a,#0x01
	movx	@r0,a
	C$test_radio_signal_tx.c$78$2$2 ==.
;	apps/test_radio_signal_tx/test_radio_signal_tx.c:78: packetsSent = 0;
	mov	r0,#_packetsSent
	clr	a
	movx	@r0,a
00102$:
	C$test_radio_signal_tx.c$81$1$1 ==.
;	apps/test_radio_signal_tx/test_radio_signal_tx.c:81: if (packetsSent < 100 && (MARCSTATE == 1))
	mov	r0,#_packetsSent
	movx	a,@r0
	cjne	a,#0x64,00112$
00112$:
	jnc	00106$
	mov	dptr,#_MARCSTATE
	movx	a,@dptr
	mov	r7,a
	cjne	r7,#0x01,00106$
	C$test_radio_signal_tx.c$83$2$3 ==.
;	apps/test_radio_signal_tx/test_radio_signal_tx.c:83: packet[1] = packetsSent & 1;
	mov	r0,#_packetsSent
	movx	a,@r0
	anl	a,#0x01
	mov	dptr,#(_packet + 0x0001)
	movx	@dptr,a
	C$test_radio_signal_tx.c$84$2$3 ==.
;	apps/test_radio_signal_tx/test_radio_signal_tx.c:84: packet[2] = currentBurstId;
	mov	dptr,#(_packet + 0x0002)
	mov	r0,#_currentBurstId
	movx	a,@r0
	movx	@dptr,a
	C$test_radio_signal_tx.c$85$2$3 ==.
;	apps/test_radio_signal_tx/test_radio_signal_tx.c:85: packet[3] = packetsSent;
	mov	dptr,#(_packet + 0x0003)
	mov	r0,#_packetsSent
	movx	a,@r0
	movx	@dptr,a
	C$test_radio_signal_tx.c$86$2$3 ==.
;	apps/test_radio_signal_tx/test_radio_signal_tx.c:86: packetsSent++;
	mov	r0,#_packetsSent
	movx	a,@r0
	add	a,#0x01
	movx	@r0,a
	C$test_radio_signal_tx.c$88$2$3 ==.
;	apps/test_radio_signal_tx/test_radio_signal_tx.c:88: RFIF &= ~(1<<4);                   // Clear IRQ_DONE
	mov	r7,_RFIF
	anl	ar7,#0xEF
	mov	_RFIF,r7
	C$test_radio_signal_tx.c$89$2$3 ==.
;	apps/test_radio_signal_tx/test_radio_signal_tx.c:89: DMAARM |= (1<<DMA_CHANNEL_RADIO);  // Arm DMA channel
	orl	_DMAARM,#0x02
	C$test_radio_signal_tx.c$90$2$3 ==.
;	apps/test_radio_signal_tx/test_radio_signal_tx.c:90: RFST = 3;                          // Switch radio to TX
	mov	_RFST,#0x03
00106$:
	C$test_radio_signal_tx.c$93$2$1 ==.
	XG$sendRadioBursts$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'main'
;------------------------------------------------------------
	G$main$0$0 ==.
	C$test_radio_signal_tx.c$95$2$1 ==.
;	apps/test_radio_signal_tx/test_radio_signal_tx.c:95: void main()
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
	C$test_radio_signal_tx.c$97$1$1 ==.
;	apps/test_radio_signal_tx/test_radio_signal_tx.c:97: systemInit();
	lcall	_systemInit
	C$test_radio_signal_tx.c$98$1$1 ==.
;	apps/test_radio_signal_tx/test_radio_signal_tx.c:98: usbInit();
	lcall	_usbInit
	C$test_radio_signal_tx.c$99$1$1 ==.
;	apps/test_radio_signal_tx/test_radio_signal_tx.c:99: perTestTxInit();
	lcall	_perTestTxInit
	C$test_radio_signal_tx.c$101$1$1 ==.
;	apps/test_radio_signal_tx/test_radio_signal_tx.c:101: while(1)
00102$:
	C$test_radio_signal_tx.c$103$2$2 ==.
;	apps/test_radio_signal_tx/test_radio_signal_tx.c:103: boardService();
	lcall	_boardService
	C$test_radio_signal_tx.c$104$2$2 ==.
;	apps/test_radio_signal_tx/test_radio_signal_tx.c:104: updateLeds();
	lcall	_updateLeds
	C$test_radio_signal_tx.c$105$2$2 ==.
;	apps/test_radio_signal_tx/test_radio_signal_tx.c:105: usbComService();
	lcall	_usbComService
	C$test_radio_signal_tx.c$106$2$2 ==.
;	apps/test_radio_signal_tx/test_radio_signal_tx.c:106: sendRadioBursts();
	lcall	_sendRadioBursts
	sjmp	00102$
	C$test_radio_signal_tx.c$108$1$1 ==.
	XG$main$0$0 ==.
	ret
	.area CSEG    (CODE)
	.area CONST   (CODE)
G$param_radio_channel$0$0 == .
_param_radio_channel:
	.byte #0x80,#0x00,#0x00,#0x00	;  128
	.area XINIT   (CODE)
	.area CABS    (ABS,CODE)
