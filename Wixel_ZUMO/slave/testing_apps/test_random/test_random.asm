;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.1.0 #7066 (Nov 22 2011) (MINGW32)
; This file was generated Thu Oct 23 16:11:01 2025
;--------------------------------------------------------
	.module test_random
	.optsdcc -mmcs51 --model-medium
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _updateHeartbeatLed
	.globl _timer3Init
	.globl _usbComService
	.globl _usbInit
	.globl _delayMs
	.globl _getMs
	.globl _boardService
	.globl _systemInit
	.globl _i
	.globl _motorState
	.globl _lastMotorActionTime
	.globl _lastRedLedToggle
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area RSEG    (ABS,DATA)
	.org 0x0000
Ftest_random$P0$0$0 == 0x0080
_P0	=	0x0080
Ftest_random$SP$0$0 == 0x0081
_SP	=	0x0081
Ftest_random$DPL0$0$0 == 0x0082
_DPL0	=	0x0082
Ftest_random$DPH0$0$0 == 0x0083
_DPH0	=	0x0083
Ftest_random$DPL1$0$0 == 0x0084
_DPL1	=	0x0084
Ftest_random$DPH1$0$0 == 0x0085
_DPH1	=	0x0085
Ftest_random$U0CSR$0$0 == 0x0086
_U0CSR	=	0x0086
Ftest_random$PCON$0$0 == 0x0087
_PCON	=	0x0087
Ftest_random$TCON$0$0 == 0x0088
_TCON	=	0x0088
Ftest_random$P0IFG$0$0 == 0x0089
_P0IFG	=	0x0089
Ftest_random$P1IFG$0$0 == 0x008a
_P1IFG	=	0x008a
Ftest_random$P2IFG$0$0 == 0x008b
_P2IFG	=	0x008b
Ftest_random$PICTL$0$0 == 0x008c
_PICTL	=	0x008c
Ftest_random$P1IEN$0$0 == 0x008d
_P1IEN	=	0x008d
Ftest_random$P0INP$0$0 == 0x008f
_P0INP	=	0x008f
Ftest_random$P1$0$0 == 0x0090
_P1	=	0x0090
Ftest_random$RFIM$0$0 == 0x0091
_RFIM	=	0x0091
Ftest_random$DPS$0$0 == 0x0092
_DPS	=	0x0092
Ftest_random$MPAGE$0$0 == 0x0093
_MPAGE	=	0x0093
Ftest_random$ENDIAN$0$0 == 0x0095
_ENDIAN	=	0x0095
Ftest_random$S0CON$0$0 == 0x0098
_S0CON	=	0x0098
Ftest_random$IEN2$0$0 == 0x009a
_IEN2	=	0x009a
Ftest_random$S1CON$0$0 == 0x009b
_S1CON	=	0x009b
Ftest_random$T2CT$0$0 == 0x009c
_T2CT	=	0x009c
Ftest_random$T2PR$0$0 == 0x009d
_T2PR	=	0x009d
Ftest_random$T2CTL$0$0 == 0x009e
_T2CTL	=	0x009e
Ftest_random$P2$0$0 == 0x00a0
_P2	=	0x00a0
Ftest_random$WORIRQ$0$0 == 0x00a1
_WORIRQ	=	0x00a1
Ftest_random$WORCTRL$0$0 == 0x00a2
_WORCTRL	=	0x00a2
Ftest_random$WOREVT0$0$0 == 0x00a3
_WOREVT0	=	0x00a3
Ftest_random$WOREVT1$0$0 == 0x00a4
_WOREVT1	=	0x00a4
Ftest_random$WORTIME0$0$0 == 0x00a5
_WORTIME0	=	0x00a5
Ftest_random$WORTIME1$0$0 == 0x00a6
_WORTIME1	=	0x00a6
Ftest_random$IEN0$0$0 == 0x00a8
_IEN0	=	0x00a8
Ftest_random$IP0$0$0 == 0x00a9
_IP0	=	0x00a9
Ftest_random$FWT$0$0 == 0x00ab
_FWT	=	0x00ab
Ftest_random$FADDRL$0$0 == 0x00ac
_FADDRL	=	0x00ac
Ftest_random$FADDRH$0$0 == 0x00ad
_FADDRH	=	0x00ad
Ftest_random$FCTL$0$0 == 0x00ae
_FCTL	=	0x00ae
Ftest_random$FWDATA$0$0 == 0x00af
_FWDATA	=	0x00af
Ftest_random$ENCDI$0$0 == 0x00b1
_ENCDI	=	0x00b1
Ftest_random$ENCDO$0$0 == 0x00b2
_ENCDO	=	0x00b2
Ftest_random$ENCCS$0$0 == 0x00b3
_ENCCS	=	0x00b3
Ftest_random$ADCCON1$0$0 == 0x00b4
_ADCCON1	=	0x00b4
Ftest_random$ADCCON2$0$0 == 0x00b5
_ADCCON2	=	0x00b5
Ftest_random$ADCCON3$0$0 == 0x00b6
_ADCCON3	=	0x00b6
Ftest_random$IEN1$0$0 == 0x00b8
_IEN1	=	0x00b8
Ftest_random$IP1$0$0 == 0x00b9
_IP1	=	0x00b9
Ftest_random$ADCL$0$0 == 0x00ba
_ADCL	=	0x00ba
Ftest_random$ADCH$0$0 == 0x00bb
_ADCH	=	0x00bb
Ftest_random$RNDL$0$0 == 0x00bc
_RNDL	=	0x00bc
Ftest_random$RNDH$0$0 == 0x00bd
_RNDH	=	0x00bd
Ftest_random$SLEEP$0$0 == 0x00be
_SLEEP	=	0x00be
Ftest_random$IRCON$0$0 == 0x00c0
_IRCON	=	0x00c0
Ftest_random$U0DBUF$0$0 == 0x00c1
_U0DBUF	=	0x00c1
Ftest_random$U0BAUD$0$0 == 0x00c2
_U0BAUD	=	0x00c2
Ftest_random$U0UCR$0$0 == 0x00c4
_U0UCR	=	0x00c4
Ftest_random$U0GCR$0$0 == 0x00c5
_U0GCR	=	0x00c5
Ftest_random$CLKCON$0$0 == 0x00c6
_CLKCON	=	0x00c6
Ftest_random$MEMCTR$0$0 == 0x00c7
_MEMCTR	=	0x00c7
Ftest_random$WDCTL$0$0 == 0x00c9
_WDCTL	=	0x00c9
Ftest_random$T3CNT$0$0 == 0x00ca
_T3CNT	=	0x00ca
Ftest_random$T3CTL$0$0 == 0x00cb
_T3CTL	=	0x00cb
Ftest_random$T3CCTL0$0$0 == 0x00cc
_T3CCTL0	=	0x00cc
Ftest_random$T3CC0$0$0 == 0x00cd
_T3CC0	=	0x00cd
Ftest_random$T3CCTL1$0$0 == 0x00ce
_T3CCTL1	=	0x00ce
Ftest_random$T3CC1$0$0 == 0x00cf
_T3CC1	=	0x00cf
Ftest_random$PSW$0$0 == 0x00d0
_PSW	=	0x00d0
Ftest_random$DMAIRQ$0$0 == 0x00d1
_DMAIRQ	=	0x00d1
Ftest_random$DMA1CFGL$0$0 == 0x00d2
_DMA1CFGL	=	0x00d2
Ftest_random$DMA1CFGH$0$0 == 0x00d3
_DMA1CFGH	=	0x00d3
Ftest_random$DMA0CFGL$0$0 == 0x00d4
_DMA0CFGL	=	0x00d4
Ftest_random$DMA0CFGH$0$0 == 0x00d5
_DMA0CFGH	=	0x00d5
Ftest_random$DMAARM$0$0 == 0x00d6
_DMAARM	=	0x00d6
Ftest_random$DMAREQ$0$0 == 0x00d7
_DMAREQ	=	0x00d7
Ftest_random$TIMIF$0$0 == 0x00d8
_TIMIF	=	0x00d8
Ftest_random$RFD$0$0 == 0x00d9
_RFD	=	0x00d9
Ftest_random$T1CC0L$0$0 == 0x00da
_T1CC0L	=	0x00da
Ftest_random$T1CC0H$0$0 == 0x00db
_T1CC0H	=	0x00db
Ftest_random$T1CC1L$0$0 == 0x00dc
_T1CC1L	=	0x00dc
Ftest_random$T1CC1H$0$0 == 0x00dd
_T1CC1H	=	0x00dd
Ftest_random$T1CC2L$0$0 == 0x00de
_T1CC2L	=	0x00de
Ftest_random$T1CC2H$0$0 == 0x00df
_T1CC2H	=	0x00df
Ftest_random$ACC$0$0 == 0x00e0
_ACC	=	0x00e0
Ftest_random$RFST$0$0 == 0x00e1
_RFST	=	0x00e1
Ftest_random$T1CNTL$0$0 == 0x00e2
_T1CNTL	=	0x00e2
Ftest_random$T1CNTH$0$0 == 0x00e3
_T1CNTH	=	0x00e3
Ftest_random$T1CTL$0$0 == 0x00e4
_T1CTL	=	0x00e4
Ftest_random$T1CCTL0$0$0 == 0x00e5
_T1CCTL0	=	0x00e5
Ftest_random$T1CCTL1$0$0 == 0x00e6
_T1CCTL1	=	0x00e6
Ftest_random$T1CCTL2$0$0 == 0x00e7
_T1CCTL2	=	0x00e7
Ftest_random$IRCON2$0$0 == 0x00e8
_IRCON2	=	0x00e8
Ftest_random$RFIF$0$0 == 0x00e9
_RFIF	=	0x00e9
Ftest_random$T4CNT$0$0 == 0x00ea
_T4CNT	=	0x00ea
Ftest_random$T4CTL$0$0 == 0x00eb
_T4CTL	=	0x00eb
Ftest_random$T4CCTL0$0$0 == 0x00ec
_T4CCTL0	=	0x00ec
Ftest_random$T4CC0$0$0 == 0x00ed
_T4CC0	=	0x00ed
Ftest_random$T4CCTL1$0$0 == 0x00ee
_T4CCTL1	=	0x00ee
Ftest_random$T4CC1$0$0 == 0x00ef
_T4CC1	=	0x00ef
Ftest_random$B$0$0 == 0x00f0
_B	=	0x00f0
Ftest_random$PERCFG$0$0 == 0x00f1
_PERCFG	=	0x00f1
Ftest_random$ADCCFG$0$0 == 0x00f2
_ADCCFG	=	0x00f2
Ftest_random$P0SEL$0$0 == 0x00f3
_P0SEL	=	0x00f3
Ftest_random$P1SEL$0$0 == 0x00f4
_P1SEL	=	0x00f4
Ftest_random$P2SEL$0$0 == 0x00f5
_P2SEL	=	0x00f5
Ftest_random$P1INP$0$0 == 0x00f6
_P1INP	=	0x00f6
Ftest_random$P2INP$0$0 == 0x00f7
_P2INP	=	0x00f7
Ftest_random$U1CSR$0$0 == 0x00f8
_U1CSR	=	0x00f8
Ftest_random$U1DBUF$0$0 == 0x00f9
_U1DBUF	=	0x00f9
Ftest_random$U1BAUD$0$0 == 0x00fa
_U1BAUD	=	0x00fa
Ftest_random$U1UCR$0$0 == 0x00fb
_U1UCR	=	0x00fb
Ftest_random$U1GCR$0$0 == 0x00fc
_U1GCR	=	0x00fc
Ftest_random$P0DIR$0$0 == 0x00fd
_P0DIR	=	0x00fd
Ftest_random$P1DIR$0$0 == 0x00fe
_P1DIR	=	0x00fe
Ftest_random$P2DIR$0$0 == 0x00ff
_P2DIR	=	0x00ff
Ftest_random$DMA0CFG$0$0 == 0xffffd5d4
_DMA0CFG	=	0xffffd5d4
Ftest_random$DMA1CFG$0$0 == 0xffffd3d2
_DMA1CFG	=	0xffffd3d2
Ftest_random$FADDR$0$0 == 0xffffadac
_FADDR	=	0xffffadac
Ftest_random$ADC$0$0 == 0xffffbbba
_ADC	=	0xffffbbba
Ftest_random$T1CC0$0$0 == 0xffffdbda
_T1CC0	=	0xffffdbda
Ftest_random$T1CC1$0$0 == 0xffffdddc
_T1CC1	=	0xffffdddc
Ftest_random$T1CC2$0$0 == 0xffffdfde
_T1CC2	=	0xffffdfde
;--------------------------------------------------------
; special function bits
;--------------------------------------------------------
	.area RSEG    (ABS,DATA)
	.org 0x0000
Ftest_random$P0_0$0$0 == 0x0080
_P0_0	=	0x0080
Ftest_random$P0_1$0$0 == 0x0081
_P0_1	=	0x0081
Ftest_random$P0_2$0$0 == 0x0082
_P0_2	=	0x0082
Ftest_random$P0_3$0$0 == 0x0083
_P0_3	=	0x0083
Ftest_random$P0_4$0$0 == 0x0084
_P0_4	=	0x0084
Ftest_random$P0_5$0$0 == 0x0085
_P0_5	=	0x0085
Ftest_random$P0_6$0$0 == 0x0086
_P0_6	=	0x0086
Ftest_random$P0_7$0$0 == 0x0087
_P0_7	=	0x0087
Ftest_random$_TCON_0$0$0 == 0x0088
__TCON_0	=	0x0088
Ftest_random$RFTXRXIF$0$0 == 0x0089
_RFTXRXIF	=	0x0089
Ftest_random$_TCON_2$0$0 == 0x008a
__TCON_2	=	0x008a
Ftest_random$URX0IF$0$0 == 0x008b
_URX0IF	=	0x008b
Ftest_random$_TCON_4$0$0 == 0x008c
__TCON_4	=	0x008c
Ftest_random$ADCIF$0$0 == 0x008d
_ADCIF	=	0x008d
Ftest_random$_TCON_6$0$0 == 0x008e
__TCON_6	=	0x008e
Ftest_random$URX1IF$0$0 == 0x008f
_URX1IF	=	0x008f
Ftest_random$P1_0$0$0 == 0x0090
_P1_0	=	0x0090
Ftest_random$P1_1$0$0 == 0x0091
_P1_1	=	0x0091
Ftest_random$P1_2$0$0 == 0x0092
_P1_2	=	0x0092
Ftest_random$P1_3$0$0 == 0x0093
_P1_3	=	0x0093
Ftest_random$P1_4$0$0 == 0x0094
_P1_4	=	0x0094
Ftest_random$P1_5$0$0 == 0x0095
_P1_5	=	0x0095
Ftest_random$P1_6$0$0 == 0x0096
_P1_6	=	0x0096
Ftest_random$P1_7$0$0 == 0x0097
_P1_7	=	0x0097
Ftest_random$ENCIF_0$0$0 == 0x0098
_ENCIF_0	=	0x0098
Ftest_random$ENCIF_1$0$0 == 0x0099
_ENCIF_1	=	0x0099
Ftest_random$_SOCON2$0$0 == 0x009a
__SOCON2	=	0x009a
Ftest_random$_SOCON3$0$0 == 0x009b
__SOCON3	=	0x009b
Ftest_random$_SOCON4$0$0 == 0x009c
__SOCON4	=	0x009c
Ftest_random$_SOCON5$0$0 == 0x009d
__SOCON5	=	0x009d
Ftest_random$_SOCON6$0$0 == 0x009e
__SOCON6	=	0x009e
Ftest_random$_SOCON7$0$0 == 0x009f
__SOCON7	=	0x009f
Ftest_random$P2_0$0$0 == 0x00a0
_P2_0	=	0x00a0
Ftest_random$P2_1$0$0 == 0x00a1
_P2_1	=	0x00a1
Ftest_random$P2_2$0$0 == 0x00a2
_P2_2	=	0x00a2
Ftest_random$P2_3$0$0 == 0x00a3
_P2_3	=	0x00a3
Ftest_random$P2_4$0$0 == 0x00a4
_P2_4	=	0x00a4
Ftest_random$P2_5$0$0 == 0x00a5
_P2_5	=	0x00a5
Ftest_random$P2_6$0$0 == 0x00a6
_P2_6	=	0x00a6
Ftest_random$P2_7$0$0 == 0x00a7
_P2_7	=	0x00a7
Ftest_random$RFTXRXIE$0$0 == 0x00a8
_RFTXRXIE	=	0x00a8
Ftest_random$ADCIE$0$0 == 0x00a9
_ADCIE	=	0x00a9
Ftest_random$URX0IE$0$0 == 0x00aa
_URX0IE	=	0x00aa
Ftest_random$URX1IE$0$0 == 0x00ab
_URX1IE	=	0x00ab
Ftest_random$ENCIE$0$0 == 0x00ac
_ENCIE	=	0x00ac
Ftest_random$STIE$0$0 == 0x00ad
_STIE	=	0x00ad
Ftest_random$_IEN06$0$0 == 0x00ae
__IEN06	=	0x00ae
Ftest_random$EA$0$0 == 0x00af
_EA	=	0x00af
Ftest_random$DMAIE$0$0 == 0x00b8
_DMAIE	=	0x00b8
Ftest_random$T1IE$0$0 == 0x00b9
_T1IE	=	0x00b9
Ftest_random$T2IE$0$0 == 0x00ba
_T2IE	=	0x00ba
Ftest_random$T3IE$0$0 == 0x00bb
_T3IE	=	0x00bb
Ftest_random$T4IE$0$0 == 0x00bc
_T4IE	=	0x00bc
Ftest_random$P0IE$0$0 == 0x00bd
_P0IE	=	0x00bd
Ftest_random$_IEN16$0$0 == 0x00be
__IEN16	=	0x00be
Ftest_random$_IEN17$0$0 == 0x00bf
__IEN17	=	0x00bf
Ftest_random$DMAIF$0$0 == 0x00c0
_DMAIF	=	0x00c0
Ftest_random$T1IF$0$0 == 0x00c1
_T1IF	=	0x00c1
Ftest_random$T2IF$0$0 == 0x00c2
_T2IF	=	0x00c2
Ftest_random$T3IF$0$0 == 0x00c3
_T3IF	=	0x00c3
Ftest_random$T4IF$0$0 == 0x00c4
_T4IF	=	0x00c4
Ftest_random$P0IF$0$0 == 0x00c5
_P0IF	=	0x00c5
Ftest_random$_IRCON6$0$0 == 0x00c6
__IRCON6	=	0x00c6
Ftest_random$STIF$0$0 == 0x00c7
_STIF	=	0x00c7
Ftest_random$P$0$0 == 0x00d0
_P	=	0x00d0
Ftest_random$F1$0$0 == 0x00d1
_F1	=	0x00d1
Ftest_random$OV$0$0 == 0x00d2
_OV	=	0x00d2
Ftest_random$RS0$0$0 == 0x00d3
_RS0	=	0x00d3
Ftest_random$RS1$0$0 == 0x00d4
_RS1	=	0x00d4
Ftest_random$F0$0$0 == 0x00d5
_F0	=	0x00d5
Ftest_random$AC$0$0 == 0x00d6
_AC	=	0x00d6
Ftest_random$CY$0$0 == 0x00d7
_CY	=	0x00d7
Ftest_random$T3OVFIF$0$0 == 0x00d8
_T3OVFIF	=	0x00d8
Ftest_random$T3CH0IF$0$0 == 0x00d9
_T3CH0IF	=	0x00d9
Ftest_random$T3CH1IF$0$0 == 0x00da
_T3CH1IF	=	0x00da
Ftest_random$T4OVFIF$0$0 == 0x00db
_T4OVFIF	=	0x00db
Ftest_random$T4CH0IF$0$0 == 0x00dc
_T4CH0IF	=	0x00dc
Ftest_random$T4CH1IF$0$0 == 0x00dd
_T4CH1IF	=	0x00dd
Ftest_random$OVFIM$0$0 == 0x00de
_OVFIM	=	0x00de
Ftest_random$_TIMIF7$0$0 == 0x00df
__TIMIF7	=	0x00df
Ftest_random$ACC_0$0$0 == 0x00e0
_ACC_0	=	0x00e0
Ftest_random$ACC_1$0$0 == 0x00e1
_ACC_1	=	0x00e1
Ftest_random$ACC_2$0$0 == 0x00e2
_ACC_2	=	0x00e2
Ftest_random$ACC_3$0$0 == 0x00e3
_ACC_3	=	0x00e3
Ftest_random$ACC_4$0$0 == 0x00e4
_ACC_4	=	0x00e4
Ftest_random$ACC_5$0$0 == 0x00e5
_ACC_5	=	0x00e5
Ftest_random$ACC_6$0$0 == 0x00e6
_ACC_6	=	0x00e6
Ftest_random$ACC_7$0$0 == 0x00e7
_ACC_7	=	0x00e7
Ftest_random$P2IF$0$0 == 0x00e8
_P2IF	=	0x00e8
Ftest_random$UTX0IF$0$0 == 0x00e9
_UTX0IF	=	0x00e9
Ftest_random$UTX1IF$0$0 == 0x00ea
_UTX1IF	=	0x00ea
Ftest_random$P1IF$0$0 == 0x00eb
_P1IF	=	0x00eb
Ftest_random$WDTIF$0$0 == 0x00ec
_WDTIF	=	0x00ec
Ftest_random$_IRCON25$0$0 == 0x00ed
__IRCON25	=	0x00ed
Ftest_random$_IRCON26$0$0 == 0x00ee
__IRCON26	=	0x00ee
Ftest_random$_IRCON27$0$0 == 0x00ef
__IRCON27	=	0x00ef
Ftest_random$B_0$0$0 == 0x00f0
_B_0	=	0x00f0
Ftest_random$B_1$0$0 == 0x00f1
_B_1	=	0x00f1
Ftest_random$B_2$0$0 == 0x00f2
_B_2	=	0x00f2
Ftest_random$B_3$0$0 == 0x00f3
_B_3	=	0x00f3
Ftest_random$B_4$0$0 == 0x00f4
_B_4	=	0x00f4
Ftest_random$B_5$0$0 == 0x00f5
_B_5	=	0x00f5
Ftest_random$B_6$0$0 == 0x00f6
_B_6	=	0x00f6
Ftest_random$B_7$0$0 == 0x00f7
_B_7	=	0x00f7
Ftest_random$U1ACTIVE$0$0 == 0x00f8
_U1ACTIVE	=	0x00f8
Ftest_random$U1TX_BYTE$0$0 == 0x00f9
_U1TX_BYTE	=	0x00f9
Ftest_random$U1RX_BYTE$0$0 == 0x00fa
_U1RX_BYTE	=	0x00fa
Ftest_random$U1ERR$0$0 == 0x00fb
_U1ERR	=	0x00fb
Ftest_random$U1FE$0$0 == 0x00fc
_U1FE	=	0x00fc
Ftest_random$U1SLAVE$0$0 == 0x00fd
_U1SLAVE	=	0x00fd
Ftest_random$U1RE$0$0 == 0x00fe
_U1RE	=	0x00fe
Ftest_random$U1MODE$0$0 == 0x00ff
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
G$lastRedLedToggle$0$0==.
_lastRedLedToggle::
	.ds 4
G$lastMotorActionTime$0$0==.
_lastMotorActionTime::
	.ds 4
G$motorState$0$0==.
_motorState::
	.ds 1
G$i$0$0==.
_i::
	.ds 1
;--------------------------------------------------------
; external ram data
;--------------------------------------------------------
	.area XSEG    (XDATA)
Ftest_random$SYNC1$0$0 == 0xdf00
_SYNC1	=	0xdf00
Ftest_random$SYNC0$0$0 == 0xdf01
_SYNC0	=	0xdf01
Ftest_random$PKTLEN$0$0 == 0xdf02
_PKTLEN	=	0xdf02
Ftest_random$PKTCTRL1$0$0 == 0xdf03
_PKTCTRL1	=	0xdf03
Ftest_random$PKTCTRL0$0$0 == 0xdf04
_PKTCTRL0	=	0xdf04
Ftest_random$ADDR$0$0 == 0xdf05
_ADDR	=	0xdf05
Ftest_random$CHANNR$0$0 == 0xdf06
_CHANNR	=	0xdf06
Ftest_random$FSCTRL1$0$0 == 0xdf07
_FSCTRL1	=	0xdf07
Ftest_random$FSCTRL0$0$0 == 0xdf08
_FSCTRL0	=	0xdf08
Ftest_random$FREQ2$0$0 == 0xdf09
_FREQ2	=	0xdf09
Ftest_random$FREQ1$0$0 == 0xdf0a
_FREQ1	=	0xdf0a
Ftest_random$FREQ0$0$0 == 0xdf0b
_FREQ0	=	0xdf0b
Ftest_random$MDMCFG4$0$0 == 0xdf0c
_MDMCFG4	=	0xdf0c
Ftest_random$MDMCFG3$0$0 == 0xdf0d
_MDMCFG3	=	0xdf0d
Ftest_random$MDMCFG2$0$0 == 0xdf0e
_MDMCFG2	=	0xdf0e
Ftest_random$MDMCFG1$0$0 == 0xdf0f
_MDMCFG1	=	0xdf0f
Ftest_random$MDMCFG0$0$0 == 0xdf10
_MDMCFG0	=	0xdf10
Ftest_random$DEVIATN$0$0 == 0xdf11
_DEVIATN	=	0xdf11
Ftest_random$MCSM2$0$0 == 0xdf12
_MCSM2	=	0xdf12
Ftest_random$MCSM1$0$0 == 0xdf13
_MCSM1	=	0xdf13
Ftest_random$MCSM0$0$0 == 0xdf14
_MCSM0	=	0xdf14
Ftest_random$FOCCFG$0$0 == 0xdf15
_FOCCFG	=	0xdf15
Ftest_random$BSCFG$0$0 == 0xdf16
_BSCFG	=	0xdf16
Ftest_random$AGCCTRL2$0$0 == 0xdf17
_AGCCTRL2	=	0xdf17
Ftest_random$AGCCTRL1$0$0 == 0xdf18
_AGCCTRL1	=	0xdf18
Ftest_random$AGCCTRL0$0$0 == 0xdf19
_AGCCTRL0	=	0xdf19
Ftest_random$FREND1$0$0 == 0xdf1a
_FREND1	=	0xdf1a
Ftest_random$FREND0$0$0 == 0xdf1b
_FREND0	=	0xdf1b
Ftest_random$FSCAL3$0$0 == 0xdf1c
_FSCAL3	=	0xdf1c
Ftest_random$FSCAL2$0$0 == 0xdf1d
_FSCAL2	=	0xdf1d
Ftest_random$FSCAL1$0$0 == 0xdf1e
_FSCAL1	=	0xdf1e
Ftest_random$FSCAL0$0$0 == 0xdf1f
_FSCAL0	=	0xdf1f
Ftest_random$TEST2$0$0 == 0xdf23
_TEST2	=	0xdf23
Ftest_random$TEST1$0$0 == 0xdf24
_TEST1	=	0xdf24
Ftest_random$TEST0$0$0 == 0xdf25
_TEST0	=	0xdf25
Ftest_random$PA_TABLE0$0$0 == 0xdf2e
_PA_TABLE0	=	0xdf2e
Ftest_random$IOCFG2$0$0 == 0xdf2f
_IOCFG2	=	0xdf2f
Ftest_random$IOCFG1$0$0 == 0xdf30
_IOCFG1	=	0xdf30
Ftest_random$IOCFG0$0$0 == 0xdf31
_IOCFG0	=	0xdf31
Ftest_random$PARTNUM$0$0 == 0xdf36
_PARTNUM	=	0xdf36
Ftest_random$VERSION$0$0 == 0xdf37
_VERSION	=	0xdf37
Ftest_random$FREQEST$0$0 == 0xdf38
_FREQEST	=	0xdf38
Ftest_random$LQI$0$0 == 0xdf39
_LQI	=	0xdf39
Ftest_random$RSSI$0$0 == 0xdf3a
_RSSI	=	0xdf3a
Ftest_random$MARCSTATE$0$0 == 0xdf3b
_MARCSTATE	=	0xdf3b
Ftest_random$PKTSTATUS$0$0 == 0xdf3c
_PKTSTATUS	=	0xdf3c
Ftest_random$VCO_VC_DAC$0$0 == 0xdf3d
_VCO_VC_DAC	=	0xdf3d
Ftest_random$I2SCFG0$0$0 == 0xdf40
_I2SCFG0	=	0xdf40
Ftest_random$I2SCFG1$0$0 == 0xdf41
_I2SCFG1	=	0xdf41
Ftest_random$I2SDATL$0$0 == 0xdf42
_I2SDATL	=	0xdf42
Ftest_random$I2SDATH$0$0 == 0xdf43
_I2SDATH	=	0xdf43
Ftest_random$I2SWCNT$0$0 == 0xdf44
_I2SWCNT	=	0xdf44
Ftest_random$I2SSTAT$0$0 == 0xdf45
_I2SSTAT	=	0xdf45
Ftest_random$I2SCLKF0$0$0 == 0xdf46
_I2SCLKF0	=	0xdf46
Ftest_random$I2SCLKF1$0$0 == 0xdf47
_I2SCLKF1	=	0xdf47
Ftest_random$I2SCLKF2$0$0 == 0xdf48
_I2SCLKF2	=	0xdf48
Ftest_random$USBADDR$0$0 == 0xde00
_USBADDR	=	0xde00
Ftest_random$USBPOW$0$0 == 0xde01
_USBPOW	=	0xde01
Ftest_random$USBIIF$0$0 == 0xde02
_USBIIF	=	0xde02
Ftest_random$USBOIF$0$0 == 0xde04
_USBOIF	=	0xde04
Ftest_random$USBCIF$0$0 == 0xde06
_USBCIF	=	0xde06
Ftest_random$USBIIE$0$0 == 0xde07
_USBIIE	=	0xde07
Ftest_random$USBOIE$0$0 == 0xde09
_USBOIE	=	0xde09
Ftest_random$USBCIE$0$0 == 0xde0b
_USBCIE	=	0xde0b
Ftest_random$USBFRML$0$0 == 0xde0c
_USBFRML	=	0xde0c
Ftest_random$USBFRMH$0$0 == 0xde0d
_USBFRMH	=	0xde0d
Ftest_random$USBINDEX$0$0 == 0xde0e
_USBINDEX	=	0xde0e
Ftest_random$USBMAXI$0$0 == 0xde10
_USBMAXI	=	0xde10
Ftest_random$USBCSIL$0$0 == 0xde11
_USBCSIL	=	0xde11
Ftest_random$USBCSIH$0$0 == 0xde12
_USBCSIH	=	0xde12
Ftest_random$USBMAXO$0$0 == 0xde13
_USBMAXO	=	0xde13
Ftest_random$USBCSOL$0$0 == 0xde14
_USBCSOL	=	0xde14
Ftest_random$USBCSOH$0$0 == 0xde15
_USBCSOH	=	0xde15
Ftest_random$USBCNTL$0$0 == 0xde16
_USBCNTL	=	0xde16
Ftest_random$USBCNTH$0$0 == 0xde17
_USBCNTH	=	0xde17
Ftest_random$USBF0$0$0 == 0xde20
_USBF0	=	0xde20
Ftest_random$USBF1$0$0 == 0xde22
_USBF1	=	0xde22
Ftest_random$USBF2$0$0 == 0xde24
_USBF2	=	0xde24
Ftest_random$USBF3$0$0 == 0xde26
_USBF3	=	0xde26
Ftest_random$USBF4$0$0 == 0xde28
_USBF4	=	0xde28
Ftest_random$USBF5$0$0 == 0xde2a
_USBF5	=	0xde2a
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
	C$test_random.c$30$1$1 ==.
;	apps/test_random/test_random.c:30: uint32 lastRedLedToggle = 0;
	mov	r0,#_lastRedLedToggle
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	inc	r0
	movx	@r0,a
	inc	r0
	movx	@r0,a
	G$main$0$0 ==.
	C$test_random.c$31$1$1 ==.
;	apps/test_random/test_random.c:31: uint32 lastMotorActionTime = 0;
	mov	r0,#_lastMotorActionTime
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	inc	r0
	movx	@r0,a
	inc	r0
	movx	@r0,a
	G$main$0$0 ==.
	C$test_random.c$32$1$1 ==.
;	apps/test_random/test_random.c:32: uint8 motorState = 0; // 0=Stop, 1=Forward, 2=Stop, 3=Reverse
	mov	r0,#_motorState
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
;Allocation info for local variables in function 'timer3Init'
;------------------------------------------------------------
	G$timer3Init$0$0 ==.
	C$test_random.c$37$0$0 ==.
;	apps/test_random/test_random.c:37: void timer3Init()
;	-----------------------------------------
;	 function timer3Init
;	-----------------------------------------
_timer3Init:
	ar7 = 0x07
	ar6 = 0x06
	ar5 = 0x05
	ar4 = 0x04
	ar3 = 0x03
	ar2 = 0x02
	ar1 = 0x01
	ar0 = 0x00
	C$test_random.c$39$1$1 ==.
;	apps/test_random/test_random.c:39: T3CTL = 0b01110000;   // Prescaler 1:8, frequency = 11.7 kHz
	mov	_T3CTL,#0x70
	C$test_random.c$40$1$1 ==.
;	apps/test_random/test_random.c:40: T3CC0 = T3CC1 = 0;    // Set duty cycles to zero
	mov	_T3CC1,#0x00
	mov	_T3CC0,#0x00
	C$test_random.c$41$1$1 ==.
;	apps/test_random/test_random.c:41: T3CCTL0 = T3CCTL1 = 0b00100100;
	mov	_T3CCTL1,#0x24
	mov	_T3CCTL0,#0x24
	C$test_random.c$42$1$1 ==.
;	apps/test_random/test_random.c:42: PERCFG &= ~(1<<5);
	mov	r7,_PERCFG
	anl	ar7,#0xDF
	mov	_PERCFG,r7
	C$test_random.c$43$1$1 ==.
;	apps/test_random/test_random.c:43: P1SEL |= (1<<3) | (1<<4);
	orl	_P1SEL,#0x18
	C$test_random.c$44$1$1 ==.
	XG$timer3Init$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'updateHeartbeatLed'
;------------------------------------------------------------
	G$updateHeartbeatLed$0$0 ==.
	C$test_random.c$49$1$1 ==.
;	apps/test_random/test_random.c:49: void updateHeartbeatLed()
;	-----------------------------------------
;	 function updateHeartbeatLed
;	-----------------------------------------
_updateHeartbeatLed:
	C$test_random.c$52$1$1 ==.
;	apps/test_random/test_random.c:52: if (getMs() - lastRedLedToggle >= 500)
	lcall	_getMs
	mov	r4,dpl
	mov	r5,dph
	mov	r6,b
	mov	r7,a
	mov	r0,#_lastRedLedToggle
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
	subb	a,#0xF4
	mov	a,r5
	subb	a,#0x01
	mov	a,r6
	subb	a,#0x00
	mov	a,r7
	subb	a,#0x00
	jc	00103$
	C$test_random.c$54$3$3 ==.
;	apps/test_random/test_random.c:54: LED_RED_TOGGLE();
	xrl	_P2DIR,#0x02
	C$test_random.c$55$2$2 ==.
;	apps/test_random/test_random.c:55: lastRedLedToggle = getMs();
	lcall	_getMs
	mov	r4,dpl
	mov	r5,dph
	mov	r6,b
	mov	r7,a
	mov	r0,#_lastRedLedToggle
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
	C$test_random.c$57$2$1 ==.
	XG$updateHeartbeatLed$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'main'
;------------------------------------------------------------
	G$main$0$0 ==.
	C$test_random.c$112$2$1 ==.
;	apps/test_random/test_random.c:112: void main()
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
	C$test_random.c$114$1$1 ==.
;	apps/test_random/test_random.c:114: systemInit();
	lcall	_systemInit
	C$test_random.c$115$1$1 ==.
;	apps/test_random/test_random.c:115: usbInit();
	lcall	_usbInit
	C$test_random.c$120$2$2 ==.
;	apps/test_random/test_random.c:120: LED_RED(0);
	mov	r7,_P2DIR
	anl	ar7,#0xFD
	mov	_P2DIR,r7
	C$test_random.c$121$2$3 ==.
;	apps/test_random/test_random.c:121: LED_RED_TOGGLE();
	xrl	_P2DIR,#0x02
	C$test_random.c$123$1$1 ==.
;	apps/test_random/test_random.c:123: delayMs(200);
	mov	dptr,#0x00C8
	lcall	_delayMs
	C$test_random.c$126$1$1 ==.
;	apps/test_random/test_random.c:126: for(i = 0; i < 70; i++) {
	mov	r0,#_i
	clr	a
	movx	@r0,a
00104$:
	mov	r0,#_i
	movx	a,@r0
	cjne	a,#0x46,00113$
00113$:
	jnc	00107$
	C$test_random.c$127$3$5 ==.
;	apps/test_random/test_random.c:127: LED_RED_TOGGLE();
	xrl	_P2DIR,#0x02
	C$test_random.c$128$2$4 ==.
;	apps/test_random/test_random.c:128: boardService();
	lcall	_boardService
	C$test_random.c$129$2$4 ==.
;	apps/test_random/test_random.c:129: usbComService();
	lcall	_usbComService
	C$test_random.c$130$2$4 ==.
;	apps/test_random/test_random.c:130: delayMs(100);
	mov	dptr,#0x0064
	lcall	_delayMs
	C$test_random.c$126$1$1 ==.
;	apps/test_random/test_random.c:126: for(i = 0; i < 70; i++) {
	mov	r0,#_i
	movx	a,@r0
	add	a,#0x01
	movx	@r0,a
	sjmp	00104$
00107$:
	C$test_random.c$134$2$6 ==.
;	apps/test_random/test_random.c:134: LED_RED(0);
	mov	r7,_P2DIR
	anl	ar7,#0xFD
	mov	_P2DIR,r7
	C$test_random.c$140$1$1 ==.
;	apps/test_random/test_random.c:140: P1SEL = 0x00;     // Force ALL P1 pins to GPIO mode
	mov	_P1SEL,#0x00
	C$test_random.c$141$1$1 ==.
;	apps/test_random/test_random.c:141: P1DIR = 0x00;     // Start with all inputs
	mov	_P1DIR,#0x00
	C$test_random.c$142$1$1 ==.
;	apps/test_random/test_random.c:142: P1 = 0x00;        // Clear all output values
	mov	_P1,#0x00
	C$test_random.c$145$1$1 ==.
;	apps/test_random/test_random.c:145: T1CTL = 0x00;
	mov	_T1CTL,#0x00
	C$test_random.c$146$1$1 ==.
;	apps/test_random/test_random.c:146: T3CTL = 0x00;
	mov	_T3CTL,#0x00
	C$test_random.c$147$1$1 ==.
;	apps/test_random/test_random.c:147: T4CTL = 0x00;
	mov	_T4CTL,#0x00
	C$test_random.c$152$1$1 ==.
;	apps/test_random/test_random.c:152: P1DIR |= (1 << 1) | (1 << 2) | (1 << 7);  // RGB pins as outputs
	orl	_P1DIR,#0x86
	C$test_random.c$153$1$1 ==.
;	apps/test_random/test_random.c:153: P1DIR |= (1 << 5);  // Motor direction as output
	orl	_P1DIR,#0x20
	C$test_random.c$156$1$1 ==.
;	apps/test_random/test_random.c:156: P1SEL = 0x00;
	mov	_P1SEL,#0x00
	C$test_random.c$161$1$1 ==.
;	apps/test_random/test_random.c:161: P1 = 0xFF;
	mov	_P1,#0xFF
	C$test_random.c$162$1$1 ==.
;	apps/test_random/test_random.c:162: delayMs(1000);
	mov	dptr,#0x03E8
	lcall	_delayMs
	C$test_random.c$165$1$1 ==.
;	apps/test_random/test_random.c:165: P1 = 0b11111101;  // Only bit 1 is 0
	mov	_P1,#0xFD
	C$test_random.c$166$1$1 ==.
;	apps/test_random/test_random.c:166: delayMs(1000);
	mov	dptr,#0x03E8
	lcall	_delayMs
	C$test_random.c$169$1$1 ==.
;	apps/test_random/test_random.c:169: P1 = 0b11111011;  // Only bit 2 is 0
	mov	_P1,#0xFB
	C$test_random.c$170$1$1 ==.
;	apps/test_random/test_random.c:170: delayMs(1000);
	mov	dptr,#0x03E8
	lcall	_delayMs
	C$test_random.c$173$1$1 ==.
;	apps/test_random/test_random.c:173: P1 = 0b01111111;  // Only bit 7 is 0
	mov	_P1,#0x7F
	C$test_random.c$174$1$1 ==.
;	apps/test_random/test_random.c:174: delayMs(1000);
	mov	dptr,#0x03E8
	lcall	_delayMs
	C$test_random.c$177$1$1 ==.
;	apps/test_random/test_random.c:177: P1 = 0xFF;
	mov	_P1,#0xFF
	C$test_random.c$178$1$1 ==.
;	apps/test_random/test_random.c:178: delayMs(500);
	mov	dptr,#0x01F4
	lcall	_delayMs
	C$test_random.c$181$1$1 ==.
;	apps/test_random/test_random.c:181: timer3Init();
	lcall	_timer3Init
	C$test_random.c$186$1$1 ==.
;	apps/test_random/test_random.c:186: P1 = 0b11011111;  // Bit 5 = 0 (direction), RGB bits high (off)
	mov	_P1,#0xDF
	C$test_random.c$187$1$1 ==.
;	apps/test_random/test_random.c:187: T3CC0 = MOTOR_SPEED;
	mov	_T3CC0,#0x96
	C$test_random.c$188$1$1 ==.
;	apps/test_random/test_random.c:188: delayMs(2000);
	mov	dptr,#0x07D0
	lcall	_delayMs
	C$test_random.c$191$1$1 ==.
;	apps/test_random/test_random.c:191: T3CC0 = 0;
	mov	_T3CC0,#0x00
	C$test_random.c$192$1$1 ==.
;	apps/test_random/test_random.c:192: delayMs(1000);
	mov	dptr,#0x03E8
	lcall	_delayMs
	C$test_random.c$195$1$1 ==.
;	apps/test_random/test_random.c:195: P1 = 0b11111111;  // Bit 5 = 1 (direction), RGB bits high (off)
	mov	_P1,#0xFF
	C$test_random.c$196$1$1 ==.
;	apps/test_random/test_random.c:196: T3CC0 = MOTOR_SPEED;
	mov	_T3CC0,#0x96
	C$test_random.c$197$1$1 ==.
;	apps/test_random/test_random.c:197: delayMs(2000);
	mov	dptr,#0x07D0
	lcall	_delayMs
	C$test_random.c$200$1$1 ==.
;	apps/test_random/test_random.c:200: T3CC0 = 0;
	mov	_T3CC0,#0x00
	C$test_random.c$202$1$1 ==.
;	apps/test_random/test_random.c:202: while(1)
00102$:
	C$test_random.c$204$2$7 ==.
;	apps/test_random/test_random.c:204: boardService();
	lcall	_boardService
	C$test_random.c$205$2$7 ==.
;	apps/test_random/test_random.c:205: usbComService();
	lcall	_usbComService
	C$test_random.c$206$2$7 ==.
;	apps/test_random/test_random.c:206: delayMs(100);
	mov	dptr,#0x0064
	lcall	_delayMs
	sjmp	00102$
	C$test_random.c$208$1$1 ==.
	XG$main$0$0 ==.
	ret
	.area CSEG    (CODE)
	.area CONST   (CODE)
	.area XINIT   (CODE)
	.area CABS    (ABS,CODE)
