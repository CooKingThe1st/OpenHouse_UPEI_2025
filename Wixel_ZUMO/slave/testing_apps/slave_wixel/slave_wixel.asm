;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.1.0 #7066 (Nov 22 2011) (MINGW32)
; This file was generated Thu Oct 23 21:29:43 2025
;--------------------------------------------------------
	.module slave_wixel
	.optsdcc -mmcs51 --model-medium
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _handlePacketTimeout
	.globl _receiveAndProcessPackets
	.globl _updateStatusLeds
	.globl _updateMotor
	.globl _updateRgbLeds
	.globl _gpioInit
	.globl _failSafeBootloader
	.globl _radioInit
	.globl _timer3Init
	.globl _radioCrcPassed
	.globl _radioRegistersInit
	.globl _delayMs
	.globl _getMs
	.globl _boardService
	.globl _systemInit
	.globl ___fsi__
	.globl _dataReceivedTime
	.globl _lastPacketTime
	.globl _ledBlue
	.globl _ledGreen
	.globl _ledRed
	.globl _dataReceivedFlag
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area RSEG    (ABS,DATA)
	.org 0x0000
Fslave_wixel$P0$0$0 == 0x0080
_P0	=	0x0080
Fslave_wixel$SP$0$0 == 0x0081
_SP	=	0x0081
Fslave_wixel$DPL0$0$0 == 0x0082
_DPL0	=	0x0082
Fslave_wixel$DPH0$0$0 == 0x0083
_DPH0	=	0x0083
Fslave_wixel$DPL1$0$0 == 0x0084
_DPL1	=	0x0084
Fslave_wixel$DPH1$0$0 == 0x0085
_DPH1	=	0x0085
Fslave_wixel$U0CSR$0$0 == 0x0086
_U0CSR	=	0x0086
Fslave_wixel$PCON$0$0 == 0x0087
_PCON	=	0x0087
Fslave_wixel$TCON$0$0 == 0x0088
_TCON	=	0x0088
Fslave_wixel$P0IFG$0$0 == 0x0089
_P0IFG	=	0x0089
Fslave_wixel$P1IFG$0$0 == 0x008a
_P1IFG	=	0x008a
Fslave_wixel$P2IFG$0$0 == 0x008b
_P2IFG	=	0x008b
Fslave_wixel$PICTL$0$0 == 0x008c
_PICTL	=	0x008c
Fslave_wixel$P1IEN$0$0 == 0x008d
_P1IEN	=	0x008d
Fslave_wixel$P0INP$0$0 == 0x008f
_P0INP	=	0x008f
Fslave_wixel$P1$0$0 == 0x0090
_P1	=	0x0090
Fslave_wixel$RFIM$0$0 == 0x0091
_RFIM	=	0x0091
Fslave_wixel$DPS$0$0 == 0x0092
_DPS	=	0x0092
Fslave_wixel$MPAGE$0$0 == 0x0093
_MPAGE	=	0x0093
Fslave_wixel$ENDIAN$0$0 == 0x0095
_ENDIAN	=	0x0095
Fslave_wixel$S0CON$0$0 == 0x0098
_S0CON	=	0x0098
Fslave_wixel$IEN2$0$0 == 0x009a
_IEN2	=	0x009a
Fslave_wixel$S1CON$0$0 == 0x009b
_S1CON	=	0x009b
Fslave_wixel$T2CT$0$0 == 0x009c
_T2CT	=	0x009c
Fslave_wixel$T2PR$0$0 == 0x009d
_T2PR	=	0x009d
Fslave_wixel$T2CTL$0$0 == 0x009e
_T2CTL	=	0x009e
Fslave_wixel$P2$0$0 == 0x00a0
_P2	=	0x00a0
Fslave_wixel$WORIRQ$0$0 == 0x00a1
_WORIRQ	=	0x00a1
Fslave_wixel$WORCTRL$0$0 == 0x00a2
_WORCTRL	=	0x00a2
Fslave_wixel$WOREVT0$0$0 == 0x00a3
_WOREVT0	=	0x00a3
Fslave_wixel$WOREVT1$0$0 == 0x00a4
_WOREVT1	=	0x00a4
Fslave_wixel$WORTIME0$0$0 == 0x00a5
_WORTIME0	=	0x00a5
Fslave_wixel$WORTIME1$0$0 == 0x00a6
_WORTIME1	=	0x00a6
Fslave_wixel$IEN0$0$0 == 0x00a8
_IEN0	=	0x00a8
Fslave_wixel$IP0$0$0 == 0x00a9
_IP0	=	0x00a9
Fslave_wixel$FWT$0$0 == 0x00ab
_FWT	=	0x00ab
Fslave_wixel$FADDRL$0$0 == 0x00ac
_FADDRL	=	0x00ac
Fslave_wixel$FADDRH$0$0 == 0x00ad
_FADDRH	=	0x00ad
Fslave_wixel$FCTL$0$0 == 0x00ae
_FCTL	=	0x00ae
Fslave_wixel$FWDATA$0$0 == 0x00af
_FWDATA	=	0x00af
Fslave_wixel$ENCDI$0$0 == 0x00b1
_ENCDI	=	0x00b1
Fslave_wixel$ENCDO$0$0 == 0x00b2
_ENCDO	=	0x00b2
Fslave_wixel$ENCCS$0$0 == 0x00b3
_ENCCS	=	0x00b3
Fslave_wixel$ADCCON1$0$0 == 0x00b4
_ADCCON1	=	0x00b4
Fslave_wixel$ADCCON2$0$0 == 0x00b5
_ADCCON2	=	0x00b5
Fslave_wixel$ADCCON3$0$0 == 0x00b6
_ADCCON3	=	0x00b6
Fslave_wixel$IEN1$0$0 == 0x00b8
_IEN1	=	0x00b8
Fslave_wixel$IP1$0$0 == 0x00b9
_IP1	=	0x00b9
Fslave_wixel$ADCL$0$0 == 0x00ba
_ADCL	=	0x00ba
Fslave_wixel$ADCH$0$0 == 0x00bb
_ADCH	=	0x00bb
Fslave_wixel$RNDL$0$0 == 0x00bc
_RNDL	=	0x00bc
Fslave_wixel$RNDH$0$0 == 0x00bd
_RNDH	=	0x00bd
Fslave_wixel$SLEEP$0$0 == 0x00be
_SLEEP	=	0x00be
Fslave_wixel$IRCON$0$0 == 0x00c0
_IRCON	=	0x00c0
Fslave_wixel$U0DBUF$0$0 == 0x00c1
_U0DBUF	=	0x00c1
Fslave_wixel$U0BAUD$0$0 == 0x00c2
_U0BAUD	=	0x00c2
Fslave_wixel$U0UCR$0$0 == 0x00c4
_U0UCR	=	0x00c4
Fslave_wixel$U0GCR$0$0 == 0x00c5
_U0GCR	=	0x00c5
Fslave_wixel$CLKCON$0$0 == 0x00c6
_CLKCON	=	0x00c6
Fslave_wixel$MEMCTR$0$0 == 0x00c7
_MEMCTR	=	0x00c7
Fslave_wixel$WDCTL$0$0 == 0x00c9
_WDCTL	=	0x00c9
Fslave_wixel$T3CNT$0$0 == 0x00ca
_T3CNT	=	0x00ca
Fslave_wixel$T3CTL$0$0 == 0x00cb
_T3CTL	=	0x00cb
Fslave_wixel$T3CCTL0$0$0 == 0x00cc
_T3CCTL0	=	0x00cc
Fslave_wixel$T3CC0$0$0 == 0x00cd
_T3CC0	=	0x00cd
Fslave_wixel$T3CCTL1$0$0 == 0x00ce
_T3CCTL1	=	0x00ce
Fslave_wixel$T3CC1$0$0 == 0x00cf
_T3CC1	=	0x00cf
Fslave_wixel$PSW$0$0 == 0x00d0
_PSW	=	0x00d0
Fslave_wixel$DMAIRQ$0$0 == 0x00d1
_DMAIRQ	=	0x00d1
Fslave_wixel$DMA1CFGL$0$0 == 0x00d2
_DMA1CFGL	=	0x00d2
Fslave_wixel$DMA1CFGH$0$0 == 0x00d3
_DMA1CFGH	=	0x00d3
Fslave_wixel$DMA0CFGL$0$0 == 0x00d4
_DMA0CFGL	=	0x00d4
Fslave_wixel$DMA0CFGH$0$0 == 0x00d5
_DMA0CFGH	=	0x00d5
Fslave_wixel$DMAARM$0$0 == 0x00d6
_DMAARM	=	0x00d6
Fslave_wixel$DMAREQ$0$0 == 0x00d7
_DMAREQ	=	0x00d7
Fslave_wixel$TIMIF$0$0 == 0x00d8
_TIMIF	=	0x00d8
Fslave_wixel$RFD$0$0 == 0x00d9
_RFD	=	0x00d9
Fslave_wixel$T1CC0L$0$0 == 0x00da
_T1CC0L	=	0x00da
Fslave_wixel$T1CC0H$0$0 == 0x00db
_T1CC0H	=	0x00db
Fslave_wixel$T1CC1L$0$0 == 0x00dc
_T1CC1L	=	0x00dc
Fslave_wixel$T1CC1H$0$0 == 0x00dd
_T1CC1H	=	0x00dd
Fslave_wixel$T1CC2L$0$0 == 0x00de
_T1CC2L	=	0x00de
Fslave_wixel$T1CC2H$0$0 == 0x00df
_T1CC2H	=	0x00df
Fslave_wixel$ACC$0$0 == 0x00e0
_ACC	=	0x00e0
Fslave_wixel$RFST$0$0 == 0x00e1
_RFST	=	0x00e1
Fslave_wixel$T1CNTL$0$0 == 0x00e2
_T1CNTL	=	0x00e2
Fslave_wixel$T1CNTH$0$0 == 0x00e3
_T1CNTH	=	0x00e3
Fslave_wixel$T1CTL$0$0 == 0x00e4
_T1CTL	=	0x00e4
Fslave_wixel$T1CCTL0$0$0 == 0x00e5
_T1CCTL0	=	0x00e5
Fslave_wixel$T1CCTL1$0$0 == 0x00e6
_T1CCTL1	=	0x00e6
Fslave_wixel$T1CCTL2$0$0 == 0x00e7
_T1CCTL2	=	0x00e7
Fslave_wixel$IRCON2$0$0 == 0x00e8
_IRCON2	=	0x00e8
Fslave_wixel$RFIF$0$0 == 0x00e9
_RFIF	=	0x00e9
Fslave_wixel$T4CNT$0$0 == 0x00ea
_T4CNT	=	0x00ea
Fslave_wixel$T4CTL$0$0 == 0x00eb
_T4CTL	=	0x00eb
Fslave_wixel$T4CCTL0$0$0 == 0x00ec
_T4CCTL0	=	0x00ec
Fslave_wixel$T4CC0$0$0 == 0x00ed
_T4CC0	=	0x00ed
Fslave_wixel$T4CCTL1$0$0 == 0x00ee
_T4CCTL1	=	0x00ee
Fslave_wixel$T4CC1$0$0 == 0x00ef
_T4CC1	=	0x00ef
Fslave_wixel$B$0$0 == 0x00f0
_B	=	0x00f0
Fslave_wixel$PERCFG$0$0 == 0x00f1
_PERCFG	=	0x00f1
Fslave_wixel$ADCCFG$0$0 == 0x00f2
_ADCCFG	=	0x00f2
Fslave_wixel$P0SEL$0$0 == 0x00f3
_P0SEL	=	0x00f3
Fslave_wixel$P1SEL$0$0 == 0x00f4
_P1SEL	=	0x00f4
Fslave_wixel$P2SEL$0$0 == 0x00f5
_P2SEL	=	0x00f5
Fslave_wixel$P1INP$0$0 == 0x00f6
_P1INP	=	0x00f6
Fslave_wixel$P2INP$0$0 == 0x00f7
_P2INP	=	0x00f7
Fslave_wixel$U1CSR$0$0 == 0x00f8
_U1CSR	=	0x00f8
Fslave_wixel$U1DBUF$0$0 == 0x00f9
_U1DBUF	=	0x00f9
Fslave_wixel$U1BAUD$0$0 == 0x00fa
_U1BAUD	=	0x00fa
Fslave_wixel$U1UCR$0$0 == 0x00fb
_U1UCR	=	0x00fb
Fslave_wixel$U1GCR$0$0 == 0x00fc
_U1GCR	=	0x00fc
Fslave_wixel$P0DIR$0$0 == 0x00fd
_P0DIR	=	0x00fd
Fslave_wixel$P1DIR$0$0 == 0x00fe
_P1DIR	=	0x00fe
Fslave_wixel$P2DIR$0$0 == 0x00ff
_P2DIR	=	0x00ff
Fslave_wixel$DMA0CFG$0$0 == 0xffffd5d4
_DMA0CFG	=	0xffffd5d4
Fslave_wixel$DMA1CFG$0$0 == 0xffffd3d2
_DMA1CFG	=	0xffffd3d2
Fslave_wixel$FADDR$0$0 == 0xffffadac
_FADDR	=	0xffffadac
Fslave_wixel$ADC$0$0 == 0xffffbbba
_ADC	=	0xffffbbba
Fslave_wixel$T1CC0$0$0 == 0xffffdbda
_T1CC0	=	0xffffdbda
Fslave_wixel$T1CC1$0$0 == 0xffffdddc
_T1CC1	=	0xffffdddc
Fslave_wixel$T1CC2$0$0 == 0xffffdfde
_T1CC2	=	0xffffdfde
;--------------------------------------------------------
; special function bits
;--------------------------------------------------------
	.area RSEG    (ABS,DATA)
	.org 0x0000
Fslave_wixel$P0_0$0$0 == 0x0080
_P0_0	=	0x0080
Fslave_wixel$P0_1$0$0 == 0x0081
_P0_1	=	0x0081
Fslave_wixel$P0_2$0$0 == 0x0082
_P0_2	=	0x0082
Fslave_wixel$P0_3$0$0 == 0x0083
_P0_3	=	0x0083
Fslave_wixel$P0_4$0$0 == 0x0084
_P0_4	=	0x0084
Fslave_wixel$P0_5$0$0 == 0x0085
_P0_5	=	0x0085
Fslave_wixel$P0_6$0$0 == 0x0086
_P0_6	=	0x0086
Fslave_wixel$P0_7$0$0 == 0x0087
_P0_7	=	0x0087
Fslave_wixel$_TCON_0$0$0 == 0x0088
__TCON_0	=	0x0088
Fslave_wixel$RFTXRXIF$0$0 == 0x0089
_RFTXRXIF	=	0x0089
Fslave_wixel$_TCON_2$0$0 == 0x008a
__TCON_2	=	0x008a
Fslave_wixel$URX0IF$0$0 == 0x008b
_URX0IF	=	0x008b
Fslave_wixel$_TCON_4$0$0 == 0x008c
__TCON_4	=	0x008c
Fslave_wixel$ADCIF$0$0 == 0x008d
_ADCIF	=	0x008d
Fslave_wixel$_TCON_6$0$0 == 0x008e
__TCON_6	=	0x008e
Fslave_wixel$URX1IF$0$0 == 0x008f
_URX1IF	=	0x008f
Fslave_wixel$P1_0$0$0 == 0x0090
_P1_0	=	0x0090
Fslave_wixel$P1_1$0$0 == 0x0091
_P1_1	=	0x0091
Fslave_wixel$P1_2$0$0 == 0x0092
_P1_2	=	0x0092
Fslave_wixel$P1_3$0$0 == 0x0093
_P1_3	=	0x0093
Fslave_wixel$P1_4$0$0 == 0x0094
_P1_4	=	0x0094
Fslave_wixel$P1_5$0$0 == 0x0095
_P1_5	=	0x0095
Fslave_wixel$P1_6$0$0 == 0x0096
_P1_6	=	0x0096
Fslave_wixel$P1_7$0$0 == 0x0097
_P1_7	=	0x0097
Fslave_wixel$ENCIF_0$0$0 == 0x0098
_ENCIF_0	=	0x0098
Fslave_wixel$ENCIF_1$0$0 == 0x0099
_ENCIF_1	=	0x0099
Fslave_wixel$_SOCON2$0$0 == 0x009a
__SOCON2	=	0x009a
Fslave_wixel$_SOCON3$0$0 == 0x009b
__SOCON3	=	0x009b
Fslave_wixel$_SOCON4$0$0 == 0x009c
__SOCON4	=	0x009c
Fslave_wixel$_SOCON5$0$0 == 0x009d
__SOCON5	=	0x009d
Fslave_wixel$_SOCON6$0$0 == 0x009e
__SOCON6	=	0x009e
Fslave_wixel$_SOCON7$0$0 == 0x009f
__SOCON7	=	0x009f
Fslave_wixel$P2_0$0$0 == 0x00a0
_P2_0	=	0x00a0
Fslave_wixel$P2_1$0$0 == 0x00a1
_P2_1	=	0x00a1
Fslave_wixel$P2_2$0$0 == 0x00a2
_P2_2	=	0x00a2
Fslave_wixel$P2_3$0$0 == 0x00a3
_P2_3	=	0x00a3
Fslave_wixel$P2_4$0$0 == 0x00a4
_P2_4	=	0x00a4
Fslave_wixel$P2_5$0$0 == 0x00a5
_P2_5	=	0x00a5
Fslave_wixel$P2_6$0$0 == 0x00a6
_P2_6	=	0x00a6
Fslave_wixel$P2_7$0$0 == 0x00a7
_P2_7	=	0x00a7
Fslave_wixel$RFTXRXIE$0$0 == 0x00a8
_RFTXRXIE	=	0x00a8
Fslave_wixel$ADCIE$0$0 == 0x00a9
_ADCIE	=	0x00a9
Fslave_wixel$URX0IE$0$0 == 0x00aa
_URX0IE	=	0x00aa
Fslave_wixel$URX1IE$0$0 == 0x00ab
_URX1IE	=	0x00ab
Fslave_wixel$ENCIE$0$0 == 0x00ac
_ENCIE	=	0x00ac
Fslave_wixel$STIE$0$0 == 0x00ad
_STIE	=	0x00ad
Fslave_wixel$_IEN06$0$0 == 0x00ae
__IEN06	=	0x00ae
Fslave_wixel$EA$0$0 == 0x00af
_EA	=	0x00af
Fslave_wixel$DMAIE$0$0 == 0x00b8
_DMAIE	=	0x00b8
Fslave_wixel$T1IE$0$0 == 0x00b9
_T1IE	=	0x00b9
Fslave_wixel$T2IE$0$0 == 0x00ba
_T2IE	=	0x00ba
Fslave_wixel$T3IE$0$0 == 0x00bb
_T3IE	=	0x00bb
Fslave_wixel$T4IE$0$0 == 0x00bc
_T4IE	=	0x00bc
Fslave_wixel$P0IE$0$0 == 0x00bd
_P0IE	=	0x00bd
Fslave_wixel$_IEN16$0$0 == 0x00be
__IEN16	=	0x00be
Fslave_wixel$_IEN17$0$0 == 0x00bf
__IEN17	=	0x00bf
Fslave_wixel$DMAIF$0$0 == 0x00c0
_DMAIF	=	0x00c0
Fslave_wixel$T1IF$0$0 == 0x00c1
_T1IF	=	0x00c1
Fslave_wixel$T2IF$0$0 == 0x00c2
_T2IF	=	0x00c2
Fslave_wixel$T3IF$0$0 == 0x00c3
_T3IF	=	0x00c3
Fslave_wixel$T4IF$0$0 == 0x00c4
_T4IF	=	0x00c4
Fslave_wixel$P0IF$0$0 == 0x00c5
_P0IF	=	0x00c5
Fslave_wixel$_IRCON6$0$0 == 0x00c6
__IRCON6	=	0x00c6
Fslave_wixel$STIF$0$0 == 0x00c7
_STIF	=	0x00c7
Fslave_wixel$P$0$0 == 0x00d0
_P	=	0x00d0
Fslave_wixel$F1$0$0 == 0x00d1
_F1	=	0x00d1
Fslave_wixel$OV$0$0 == 0x00d2
_OV	=	0x00d2
Fslave_wixel$RS0$0$0 == 0x00d3
_RS0	=	0x00d3
Fslave_wixel$RS1$0$0 == 0x00d4
_RS1	=	0x00d4
Fslave_wixel$F0$0$0 == 0x00d5
_F0	=	0x00d5
Fslave_wixel$AC$0$0 == 0x00d6
_AC	=	0x00d6
Fslave_wixel$CY$0$0 == 0x00d7
_CY	=	0x00d7
Fslave_wixel$T3OVFIF$0$0 == 0x00d8
_T3OVFIF	=	0x00d8
Fslave_wixel$T3CH0IF$0$0 == 0x00d9
_T3CH0IF	=	0x00d9
Fslave_wixel$T3CH1IF$0$0 == 0x00da
_T3CH1IF	=	0x00da
Fslave_wixel$T4OVFIF$0$0 == 0x00db
_T4OVFIF	=	0x00db
Fslave_wixel$T4CH0IF$0$0 == 0x00dc
_T4CH0IF	=	0x00dc
Fslave_wixel$T4CH1IF$0$0 == 0x00dd
_T4CH1IF	=	0x00dd
Fslave_wixel$OVFIM$0$0 == 0x00de
_OVFIM	=	0x00de
Fslave_wixel$_TIMIF7$0$0 == 0x00df
__TIMIF7	=	0x00df
Fslave_wixel$ACC_0$0$0 == 0x00e0
_ACC_0	=	0x00e0
Fslave_wixel$ACC_1$0$0 == 0x00e1
_ACC_1	=	0x00e1
Fslave_wixel$ACC_2$0$0 == 0x00e2
_ACC_2	=	0x00e2
Fslave_wixel$ACC_3$0$0 == 0x00e3
_ACC_3	=	0x00e3
Fslave_wixel$ACC_4$0$0 == 0x00e4
_ACC_4	=	0x00e4
Fslave_wixel$ACC_5$0$0 == 0x00e5
_ACC_5	=	0x00e5
Fslave_wixel$ACC_6$0$0 == 0x00e6
_ACC_6	=	0x00e6
Fslave_wixel$ACC_7$0$0 == 0x00e7
_ACC_7	=	0x00e7
Fslave_wixel$P2IF$0$0 == 0x00e8
_P2IF	=	0x00e8
Fslave_wixel$UTX0IF$0$0 == 0x00e9
_UTX0IF	=	0x00e9
Fslave_wixel$UTX1IF$0$0 == 0x00ea
_UTX1IF	=	0x00ea
Fslave_wixel$P1IF$0$0 == 0x00eb
_P1IF	=	0x00eb
Fslave_wixel$WDTIF$0$0 == 0x00ec
_WDTIF	=	0x00ec
Fslave_wixel$_IRCON25$0$0 == 0x00ed
__IRCON25	=	0x00ed
Fslave_wixel$_IRCON26$0$0 == 0x00ee
__IRCON26	=	0x00ee
Fslave_wixel$_IRCON27$0$0 == 0x00ef
__IRCON27	=	0x00ef
Fslave_wixel$B_0$0$0 == 0x00f0
_B_0	=	0x00f0
Fslave_wixel$B_1$0$0 == 0x00f1
_B_1	=	0x00f1
Fslave_wixel$B_2$0$0 == 0x00f2
_B_2	=	0x00f2
Fslave_wixel$B_3$0$0 == 0x00f3
_B_3	=	0x00f3
Fslave_wixel$B_4$0$0 == 0x00f4
_B_4	=	0x00f4
Fslave_wixel$B_5$0$0 == 0x00f5
_B_5	=	0x00f5
Fslave_wixel$B_6$0$0 == 0x00f6
_B_6	=	0x00f6
Fslave_wixel$B_7$0$0 == 0x00f7
_B_7	=	0x00f7
Fslave_wixel$U1ACTIVE$0$0 == 0x00f8
_U1ACTIVE	=	0x00f8
Fslave_wixel$U1TX_BYTE$0$0 == 0x00f9
_U1TX_BYTE	=	0x00f9
Fslave_wixel$U1RX_BYTE$0$0 == 0x00fa
_U1RX_BYTE	=	0x00fa
Fslave_wixel$U1ERR$0$0 == 0x00fb
_U1ERR	=	0x00fb
Fslave_wixel$U1FE$0$0 == 0x00fc
_U1FE	=	0x00fc
Fslave_wixel$U1SLAVE$0$0 == 0x00fd
_U1SLAVE	=	0x00fd
Fslave_wixel$U1RE$0$0 == 0x00fe
_U1RE	=	0x00fe
Fslave_wixel$U1MODE$0$0 == 0x00ff
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
Lslave_wixel.handlePacketTimeout$sloc0$1$0==.
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
G$dataReceivedFlag$0$0==.
_dataReceivedFlag::
	.ds 1
Lslave_wixel.updateRgbLeds$sloc0$1$0==.
_updateRgbLeds_sloc0_1_0:
	.ds 1
Lslave_wixel.updateMotor$isGreen$1$1==.
_updateMotor_isGreen_1_1:
	.ds 1
Lslave_wixel.updateMotor$isBlue$1$1==.
_updateMotor_isBlue_1_1:
	.ds 1
Lslave_wixel.updateMotor$isRed$1$1==.
_updateMotor_isRed_1_1:
	.ds 1
Lslave_wixel.updateMotor$sloc0$1$0==.
_updateMotor_sloc0_1_0:
	.ds 1
Lslave_wixel.updateStatusLeds$isConnected$1$1==.
_updateStatusLeds_isConnected_1_1:
	.ds 1
Lslave_wixel.updateStatusLeds$sloc0$1$0==.
_updateStatusLeds_sloc0_1_0:
	.ds 1
;--------------------------------------------------------
; paged external ram data
;--------------------------------------------------------
	.area PSEG    (PAG,XDATA)
G$ledRed$0$0==.
_ledRed::
	.ds 1
G$ledGreen$0$0==.
_ledGreen::
	.ds 1
G$ledBlue$0$0==.
_ledBlue::
	.ds 1
G$lastPacketTime$0$0==.
_lastPacketTime::
	.ds 2
G$dataReceivedTime$0$0==.
_dataReceivedTime::
	.ds 2
G$__fsi__$0$0==.
___fsi__::
	.ds 1
;--------------------------------------------------------
; external ram data
;--------------------------------------------------------
	.area XSEG    (XDATA)
Fslave_wixel$SYNC1$0$0 == 0xdf00
_SYNC1	=	0xdf00
Fslave_wixel$SYNC0$0$0 == 0xdf01
_SYNC0	=	0xdf01
Fslave_wixel$PKTLEN$0$0 == 0xdf02
_PKTLEN	=	0xdf02
Fslave_wixel$PKTCTRL1$0$0 == 0xdf03
_PKTCTRL1	=	0xdf03
Fslave_wixel$PKTCTRL0$0$0 == 0xdf04
_PKTCTRL0	=	0xdf04
Fslave_wixel$ADDR$0$0 == 0xdf05
_ADDR	=	0xdf05
Fslave_wixel$CHANNR$0$0 == 0xdf06
_CHANNR	=	0xdf06
Fslave_wixel$FSCTRL1$0$0 == 0xdf07
_FSCTRL1	=	0xdf07
Fslave_wixel$FSCTRL0$0$0 == 0xdf08
_FSCTRL0	=	0xdf08
Fslave_wixel$FREQ2$0$0 == 0xdf09
_FREQ2	=	0xdf09
Fslave_wixel$FREQ1$0$0 == 0xdf0a
_FREQ1	=	0xdf0a
Fslave_wixel$FREQ0$0$0 == 0xdf0b
_FREQ0	=	0xdf0b
Fslave_wixel$MDMCFG4$0$0 == 0xdf0c
_MDMCFG4	=	0xdf0c
Fslave_wixel$MDMCFG3$0$0 == 0xdf0d
_MDMCFG3	=	0xdf0d
Fslave_wixel$MDMCFG2$0$0 == 0xdf0e
_MDMCFG2	=	0xdf0e
Fslave_wixel$MDMCFG1$0$0 == 0xdf0f
_MDMCFG1	=	0xdf0f
Fslave_wixel$MDMCFG0$0$0 == 0xdf10
_MDMCFG0	=	0xdf10
Fslave_wixel$DEVIATN$0$0 == 0xdf11
_DEVIATN	=	0xdf11
Fslave_wixel$MCSM2$0$0 == 0xdf12
_MCSM2	=	0xdf12
Fslave_wixel$MCSM1$0$0 == 0xdf13
_MCSM1	=	0xdf13
Fslave_wixel$MCSM0$0$0 == 0xdf14
_MCSM0	=	0xdf14
Fslave_wixel$FOCCFG$0$0 == 0xdf15
_FOCCFG	=	0xdf15
Fslave_wixel$BSCFG$0$0 == 0xdf16
_BSCFG	=	0xdf16
Fslave_wixel$AGCCTRL2$0$0 == 0xdf17
_AGCCTRL2	=	0xdf17
Fslave_wixel$AGCCTRL1$0$0 == 0xdf18
_AGCCTRL1	=	0xdf18
Fslave_wixel$AGCCTRL0$0$0 == 0xdf19
_AGCCTRL0	=	0xdf19
Fslave_wixel$FREND1$0$0 == 0xdf1a
_FREND1	=	0xdf1a
Fslave_wixel$FREND0$0$0 == 0xdf1b
_FREND0	=	0xdf1b
Fslave_wixel$FSCAL3$0$0 == 0xdf1c
_FSCAL3	=	0xdf1c
Fslave_wixel$FSCAL2$0$0 == 0xdf1d
_FSCAL2	=	0xdf1d
Fslave_wixel$FSCAL1$0$0 == 0xdf1e
_FSCAL1	=	0xdf1e
Fslave_wixel$FSCAL0$0$0 == 0xdf1f
_FSCAL0	=	0xdf1f
Fslave_wixel$TEST2$0$0 == 0xdf23
_TEST2	=	0xdf23
Fslave_wixel$TEST1$0$0 == 0xdf24
_TEST1	=	0xdf24
Fslave_wixel$TEST0$0$0 == 0xdf25
_TEST0	=	0xdf25
Fslave_wixel$PA_TABLE0$0$0 == 0xdf2e
_PA_TABLE0	=	0xdf2e
Fslave_wixel$IOCFG2$0$0 == 0xdf2f
_IOCFG2	=	0xdf2f
Fslave_wixel$IOCFG1$0$0 == 0xdf30
_IOCFG1	=	0xdf30
Fslave_wixel$IOCFG0$0$0 == 0xdf31
_IOCFG0	=	0xdf31
Fslave_wixel$PARTNUM$0$0 == 0xdf36
_PARTNUM	=	0xdf36
Fslave_wixel$VERSION$0$0 == 0xdf37
_VERSION	=	0xdf37
Fslave_wixel$FREQEST$0$0 == 0xdf38
_FREQEST	=	0xdf38
Fslave_wixel$LQI$0$0 == 0xdf39
_LQI	=	0xdf39
Fslave_wixel$RSSI$0$0 == 0xdf3a
_RSSI	=	0xdf3a
Fslave_wixel$MARCSTATE$0$0 == 0xdf3b
_MARCSTATE	=	0xdf3b
Fslave_wixel$PKTSTATUS$0$0 == 0xdf3c
_PKTSTATUS	=	0xdf3c
Fslave_wixel$VCO_VC_DAC$0$0 == 0xdf3d
_VCO_VC_DAC	=	0xdf3d
Fslave_wixel$I2SCFG0$0$0 == 0xdf40
_I2SCFG0	=	0xdf40
Fslave_wixel$I2SCFG1$0$0 == 0xdf41
_I2SCFG1	=	0xdf41
Fslave_wixel$I2SDATL$0$0 == 0xdf42
_I2SDATL	=	0xdf42
Fslave_wixel$I2SDATH$0$0 == 0xdf43
_I2SDATH	=	0xdf43
Fslave_wixel$I2SWCNT$0$0 == 0xdf44
_I2SWCNT	=	0xdf44
Fslave_wixel$I2SSTAT$0$0 == 0xdf45
_I2SSTAT	=	0xdf45
Fslave_wixel$I2SCLKF0$0$0 == 0xdf46
_I2SCLKF0	=	0xdf46
Fslave_wixel$I2SCLKF1$0$0 == 0xdf47
_I2SCLKF1	=	0xdf47
Fslave_wixel$I2SCLKF2$0$0 == 0xdf48
_I2SCLKF2	=	0xdf48
Fslave_wixel$USBADDR$0$0 == 0xde00
_USBADDR	=	0xde00
Fslave_wixel$USBPOW$0$0 == 0xde01
_USBPOW	=	0xde01
Fslave_wixel$USBIIF$0$0 == 0xde02
_USBIIF	=	0xde02
Fslave_wixel$USBOIF$0$0 == 0xde04
_USBOIF	=	0xde04
Fslave_wixel$USBCIF$0$0 == 0xde06
_USBCIF	=	0xde06
Fslave_wixel$USBIIE$0$0 == 0xde07
_USBIIE	=	0xde07
Fslave_wixel$USBOIE$0$0 == 0xde09
_USBOIE	=	0xde09
Fslave_wixel$USBCIE$0$0 == 0xde0b
_USBCIE	=	0xde0b
Fslave_wixel$USBFRML$0$0 == 0xde0c
_USBFRML	=	0xde0c
Fslave_wixel$USBFRMH$0$0 == 0xde0d
_USBFRMH	=	0xde0d
Fslave_wixel$USBINDEX$0$0 == 0xde0e
_USBINDEX	=	0xde0e
Fslave_wixel$USBMAXI$0$0 == 0xde10
_USBMAXI	=	0xde10
Fslave_wixel$USBCSIL$0$0 == 0xde11
_USBCSIL	=	0xde11
Fslave_wixel$USBCSIH$0$0 == 0xde12
_USBCSIH	=	0xde12
Fslave_wixel$USBMAXO$0$0 == 0xde13
_USBMAXO	=	0xde13
Fslave_wixel$USBCSOL$0$0 == 0xde14
_USBCSOL	=	0xde14
Fslave_wixel$USBCSOH$0$0 == 0xde15
_USBCSOH	=	0xde15
Fslave_wixel$USBCNTL$0$0 == 0xde16
_USBCNTL	=	0xde16
Fslave_wixel$USBCNTH$0$0 == 0xde17
_USBCNTH	=	0xde17
Fslave_wixel$USBF0$0$0 == 0xde20
_USBF0	=	0xde20
Fslave_wixel$USBF1$0$0 == 0xde22
_USBF1	=	0xde22
Fslave_wixel$USBF2$0$0 == 0xde24
_USBF2	=	0xde24
Fslave_wixel$USBF3$0$0 == 0xde26
_USBF3	=	0xde26
Fslave_wixel$USBF4$0$0 == 0xde28
_USBF4	=	0xde28
Fslave_wixel$USBF5$0$0 == 0xde2a
_USBF5	=	0xde2a
Fslave_wixel$rxPacket$0$0==.
_rxPacket:
	.ds 19
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
	C$slave_wixel.c$72$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:72: BIT dataReceivedFlag = 0;
	clr	_dataReceivedFlag
	G$main$0$0 ==.
	C$slave_wixel.c$64$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:64: uint8 ledRed = 0;
	mov	r0,#_ledRed
	clr	a
	movx	@r0,a
	G$main$0$0 ==.
	C$slave_wixel.c$65$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:65: uint8 ledGreen = 0;
	mov	r0,#_ledGreen
	clr	a
	movx	@r0,a
	G$main$0$0 ==.
	C$slave_wixel.c$66$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:66: uint8 ledBlue = 0;
	mov	r0,#_ledBlue
	clr	a
	movx	@r0,a
	G$main$0$0 ==.
	C$slave_wixel.c$69$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:69: uint16 lastPacketTime = 0;
	mov	r0,#_lastPacketTime
	clr	a
	movx	@r0,a
	inc	r0
	movx	@r0,a
	G$main$0$0 ==.
	C$slave_wixel.c$73$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:73: uint16 dataReceivedTime = 0;
	mov	r0,#_dataReceivedTime
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
;Allocation info for local variables in function 'timer3Init'
;------------------------------------------------------------
	G$timer3Init$0$0 ==.
	C$slave_wixel.c$78$0$0 ==.
;	apps/slave_wixel/slave_wixel.c:78: void timer3Init()
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
	C$slave_wixel.c$80$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:80: T3CTL = 0b01110000;      // Prescaler 1:8, frequency = 11.7 kHz (matches alpha.c)
	mov	_T3CTL,#0x70
	C$slave_wixel.c$81$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:81: T3CC0 = T3CC1 = 0;       // Set duty cycles to zero
	mov	_T3CC1,#0x00
	mov	_T3CC0,#0x00
	C$slave_wixel.c$82$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:82: T3CCTL0 = T3CCTL1 = 0b00100100;    // Compare mode
	mov	_T3CCTL1,#0x24
	mov	_T3CCTL0,#0x24
	C$slave_wixel.c$83$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:83: PERCFG &= ~(1<<5);       // Alternate location (matches alpha.c)
	mov	r7,_PERCFG
	anl	ar7,#0xDF
	mov	_PERCFG,r7
	C$slave_wixel.c$84$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:84: P1SEL |= (1<<R_PWM_PIN) | (1<<L_PWM_PIN);  // P1_3 and P1_4 as PWM
	orl	_P1SEL,#0x18
	C$slave_wixel.c$85$1$1 ==.
	XG$timer3Init$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'radioInit'
;------------------------------------------------------------
	G$radioInit$0$0 ==.
	C$slave_wixel.c$90$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:90: void radioInit()
;	-----------------------------------------
;	 function radioInit
;	-----------------------------------------
_radioInit:
	C$slave_wixel.c$92$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:92: radioRegistersInit();
	lcall	_radioRegistersInit
	C$slave_wixel.c$94$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:94: CHANNR = 128;
	mov	dptr,#_CHANNR
	mov	a,#0x80
	movx	@dptr,a
	C$slave_wixel.c$95$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:95: PKTLEN = RADIO_PACKET_SIZE;
	mov	dptr,#_PKTLEN
	mov	a,#0x10
	movx	@dptr,a
	C$slave_wixel.c$97$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:97: MCSM0 = 0x14;
	mov	dptr,#_MCSM0
	mov	a,#0x14
	movx	@dptr,a
	C$slave_wixel.c$98$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:98: MCSM1 = 0x00;
	mov	dptr,#_MCSM1
	clr	a
	movx	@dptr,a
	C$slave_wixel.c$100$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:100: dmaConfig.radio.DC6 = 19;
	mov	dptr,#(_dmaConfig + 0x0006)
	mov	a,#0x13
	movx	@dptr,a
	C$slave_wixel.c$102$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:102: dmaConfig.radio.SRCADDRH = XDATA_SFR_ADDRESS(RFD) >> 8;
	mov	r6,#_RFD
	mov	r7,#0x00
	mov	a,#0xDF
	add	a,r7
	mov	r6,a
	mov	dptr,#_dmaConfig
	mov	a,r6
	movx	@dptr,a
	C$slave_wixel.c$103$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:103: dmaConfig.radio.SRCADDRL = XDATA_SFR_ADDRESS(RFD);
	mov	r6,#_RFD
	mov	dptr,#(_dmaConfig + 0x0001)
	mov	a,r6
	movx	@dptr,a
	C$slave_wixel.c$104$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:104: dmaConfig.radio.DESTADDRH = (unsigned int)rxPacket >> 8;
	mov	r6,#_rxPacket
	mov	r7,#(_rxPacket >> 8)
	mov	ar6,r7
	mov	dptr,#(_dmaConfig + 0x0002)
	mov	a,r6
	movx	@dptr,a
	C$slave_wixel.c$105$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:105: dmaConfig.radio.DESTADDRL = (unsigned int)rxPacket;
	mov	r6,#_rxPacket
	mov	r7,#(_rxPacket >> 8)
	mov	dptr,#(_dmaConfig + 0x0003)
	mov	a,r6
	movx	@dptr,a
	C$slave_wixel.c$106$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:106: dmaConfig.radio.LENL = 1 + PKTLEN + 2;
	mov	dptr,#_PKTLEN
	movx	a,@dptr
	mov	r7,a
	inc	r7
	inc	r7
	inc	r7
	mov	dptr,#(_dmaConfig + 0x0005)
	mov	a,r7
	movx	@dptr,a
	C$slave_wixel.c$107$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:107: dmaConfig.radio.VLEN_LENH = 0b10000000;
	mov	dptr,#(_dmaConfig + 0x0004)
	mov	a,#0x80
	movx	@dptr,a
	C$slave_wixel.c$108$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:108: dmaConfig.radio.DC7 = 0x10;
	mov	dptr,#(_dmaConfig + 0x0007)
	mov	a,#0x10
	movx	@dptr,a
	C$slave_wixel.c$110$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:110: DMAARM |= (1<<DMA_CHANNEL_RADIO);
	orl	_DMAARM,#0x02
	C$slave_wixel.c$111$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:111: RFST = 2;
	mov	_RFST,#0x02
	C$slave_wixel.c$112$1$1 ==.
	XG$radioInit$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'failSafeBootloader'
;------------------------------------------------------------
	G$failSafeBootloader$0$0 ==.
	C$slave_wixel.c$120$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:120: void failSafeBootloader(){
;	-----------------------------------------
;	 function failSafeBootloader
;	-----------------------------------------
_failSafeBootloader:
	C$slave_wixel.c$123$2$2 ==.
;	apps/slave_wixel/slave_wixel.c:123: LED_RED(0);
	mov	r7,_P2DIR
	anl	ar7,#0xFD
	mov	_P2DIR,r7
	C$slave_wixel.c$124$2$3 ==.
;	apps/slave_wixel/slave_wixel.c:124: LED_RED_TOGGLE();
	xrl	_P2DIR,#0x02
	C$slave_wixel.c$126$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:126: delayMs(200);
	mov	dptr,#0x00C8
	lcall	_delayMs
	C$slave_wixel.c$129$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:129: for(__fsi__ = 0; __fsi__ < 70; __fsi__++) {
	mov	r0,#___fsi__
	clr	a
	movx	@r0,a
00101$:
	mov	r0,#___fsi__
	movx	a,@r0
	cjne	a,#0x46,00109$
00109$:
	jnc	00104$
	C$slave_wixel.c$130$3$5 ==.
;	apps/slave_wixel/slave_wixel.c:130: LED_RED_TOGGLE();
	xrl	_P2DIR,#0x02
	C$slave_wixel.c$131$2$4 ==.
;	apps/slave_wixel/slave_wixel.c:131: boardService();
	lcall	_boardService
	C$slave_wixel.c$132$2$4 ==.
;	apps/slave_wixel/slave_wixel.c:132: usbComService();
	lcall	_usbComService
	C$slave_wixel.c$133$2$4 ==.
;	apps/slave_wixel/slave_wixel.c:133: delayMs(100);
	mov	dptr,#0x0064
	lcall	_delayMs
	C$slave_wixel.c$129$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:129: for(__fsi__ = 0; __fsi__ < 70; __fsi__++) {
	mov	r0,#___fsi__
	movx	a,@r0
	add	a,#0x01
	movx	@r0,a
	sjmp	00101$
00104$:
	C$slave_wixel.c$137$2$6 ==.
;	apps/slave_wixel/slave_wixel.c:137: LED_RED(0);
	mov	r7,_P2DIR
	anl	ar7,#0xFD
	mov	_P2DIR,r7
	C$slave_wixel.c$138$2$6 ==.
	XG$failSafeBootloader$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'gpioInit'
;------------------------------------------------------------
	G$gpioInit$0$0 ==.
	C$slave_wixel.c$140$2$6 ==.
;	apps/slave_wixel/slave_wixel.c:140: void gpioInit()
;	-----------------------------------------
;	 function gpioInit
;	-----------------------------------------
_gpioInit:
	C$slave_wixel.c$142$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:142: failSafeBootloader();
	lcall	_failSafeBootloader
	C$slave_wixel.c$144$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:144: P1SEL = 0x00;     // Force ALL P1 pins to GPIO mode
	mov	_P1SEL,#0x00
	C$slave_wixel.c$145$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:145: P1DIR = 0x00;     // Start with all inputs
	mov	_P1DIR,#0x00
	C$slave_wixel.c$146$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:146: P1 = 0x00;        // Clear all output values
	mov	_P1,#0x00
	C$slave_wixel.c$149$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:149: T1CTL = 0x00;
	mov	_T1CTL,#0x00
	C$slave_wixel.c$150$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:150: T3CTL = 0x00;
	mov	_T3CTL,#0x00
	C$slave_wixel.c$151$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:151: T4CTL = 0x00;
	mov	_T4CTL,#0x00
	C$slave_wixel.c$154$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:154: P1DIR |= (1 << LED_RED_PIN) | (1 << LED_GREEN_PIN) | (1 << LED_BLUE_PIN);  // RGB pins
	orl	_P1DIR,#0x86
	C$slave_wixel.c$155$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:155: P1DIR |= (1 << R_DIR_PIN) | (1 << L_DIR_PIN);  // Motor direction pins (both wheels)
	orl	_P1DIR,#0x60
	C$slave_wixel.c$158$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:158: P1SEL = 0x00;
	mov	_P1SEL,#0x00
	C$slave_wixel.c$161$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:161: P1_1 = 1;
	setb	_P1_1
	C$slave_wixel.c$162$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:162: P1_2 = 1;
	setb	_P1_2
	C$slave_wixel.c$163$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:163: P1_7 = 1;
	setb	_P1_7
	C$slave_wixel.c$166$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:166: T3CC0 = 0;
	mov	_T3CC0,#0x00
	C$slave_wixel.c$167$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:167: T3CC1 = 0;
	mov	_T3CC1,#0x00
	C$slave_wixel.c$168$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:168: P1_5 = 0;
	clr	_P1_5
	C$slave_wixel.c$169$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:169: P1_6 = 0;
	clr	_P1_6
	C$slave_wixel.c$170$1$1 ==.
	XG$gpioInit$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'updateRgbLeds'
;------------------------------------------------------------
	G$updateRgbLeds$0$0 ==.
	C$slave_wixel.c$175$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:175: void updateRgbLeds()
;	-----------------------------------------
;	 function updateRgbLeds
;	-----------------------------------------
_updateRgbLeds:
	C$slave_wixel.c$177$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:177: P1_1 = (ledRed > 127) ? 0 : 1;
	mov	r0,#_ledRed
	clr	c
	movx	a,@r0
	mov	b,a
	mov	a,#0x7F
	subb	a,b
	cpl	c
	mov	_updateRgbLeds_sloc0_1_0,c
	mov	_P1_1,c
	C$slave_wixel.c$178$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:178: P1_2 = (ledGreen > 127) ? 0 : 1;
	mov	r0,#_ledGreen
	clr	c
	movx	a,@r0
	mov	b,a
	mov	a,#0x7F
	subb	a,b
	cpl	c
	mov	_updateRgbLeds_sloc0_1_0,c
	mov	_P1_2,c
	C$slave_wixel.c$179$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:179: P1_7 = (ledBlue > 127) ? 0 : 1;
	mov	r0,#_ledBlue
	clr	c
	movx	a,@r0
	mov	b,a
	mov	a,#0x7F
	subb	a,b
	cpl	c
	mov	_updateRgbLeds_sloc0_1_0,c
	mov	_P1_7,c
	C$slave_wixel.c$180$1$1 ==.
	XG$updateRgbLeds$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'updateMotor'
;------------------------------------------------------------
	G$updateMotor$0$0 ==.
	C$slave_wixel.c$188$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:188: void updateMotor()
;	-----------------------------------------
;	 function updateMotor
;	-----------------------------------------
_updateMotor:
	C$slave_wixel.c$190$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:190: BIT isGreen = (ledGreen > 127);
	mov	r0,#_ledGreen
	clr	c
	movx	a,@r0
	mov	b,a
	mov	a,#0x7F
	subb	a,b
	mov  _updateMotor_sloc0_1_0,c
	mov	_updateMotor_isGreen_1_1,c
	C$slave_wixel.c$191$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:191: BIT isBlue = (ledBlue > 127);
	mov	r0,#_ledBlue
	clr	c
	movx	a,@r0
	mov	b,a
	mov	a,#0x7F
	subb	a,b
	mov  _updateMotor_sloc0_1_0,c
	mov	_updateMotor_isBlue_1_1,c
	C$slave_wixel.c$192$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:192: BIT isRed = (ledRed > 127);
	mov	r0,#_ledRed
	clr	c
	movx	a,@r0
	mov	b,a
	mov	a,#0x7F
	subb	a,b
	mov  _updateMotor_sloc0_1_0,c
	mov	_updateMotor_isRed_1_1,c
	C$slave_wixel.c$194$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:194: if (isGreen || isBlue)
	jb	_updateMotor_isGreen_1_1,00104$
	jnb	_updateMotor_isBlue_1_1,00105$
00104$:
	C$slave_wixel.c$197$2$2 ==.
;	apps/slave_wixel/slave_wixel.c:197: P1_5 = 0;  // Right motor forward
	clr	_P1_5
	C$slave_wixel.c$198$2$2 ==.
;	apps/slave_wixel/slave_wixel.c:198: P1_6 = 0;  // Left motor forward
	clr	_P1_6
	C$slave_wixel.c$199$2$2 ==.
;	apps/slave_wixel/slave_wixel.c:199: T3CC0 = MOTOR_SPEED;  // Right motor PWM
	mov	_T3CC0,#0x64
	C$slave_wixel.c$200$2$2 ==.
;	apps/slave_wixel/slave_wixel.c:200: T3CC1 = MOTOR_SPEED;  // Left motor PWM
	mov	_T3CC1,#0x64
	sjmp	00108$
00105$:
	C$slave_wixel.c$202$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:202: else if (isRed)
	jnb	_updateMotor_isRed_1_1,00102$
	C$slave_wixel.c$205$2$3 ==.
;	apps/slave_wixel/slave_wixel.c:205: P1_5 = 1;  // Right motor reverse
	setb	_P1_5
	C$slave_wixel.c$206$2$3 ==.
;	apps/slave_wixel/slave_wixel.c:206: P1_6 = 1;  // Left motor reverse
	setb	_P1_6
	C$slave_wixel.c$207$2$3 ==.
;	apps/slave_wixel/slave_wixel.c:207: T3CC0 = MOTOR_SPEED;  // Right motor PWM
	mov	_T3CC0,#0x64
	C$slave_wixel.c$208$2$3 ==.
;	apps/slave_wixel/slave_wixel.c:208: T3CC1 = MOTOR_SPEED;  // Left motor PWM
	mov	_T3CC1,#0x64
	sjmp	00108$
00102$:
	C$slave_wixel.c$213$2$4 ==.
;	apps/slave_wixel/slave_wixel.c:213: T3CC0 = 0;
	mov	_T3CC0,#0x00
	C$slave_wixel.c$214$2$4 ==.
;	apps/slave_wixel/slave_wixel.c:214: T3CC1 = 0;
	mov	_T3CC1,#0x00
	C$slave_wixel.c$215$2$4 ==.
;	apps/slave_wixel/slave_wixel.c:215: P1_5 = 0;
	clr	_P1_5
	C$slave_wixel.c$216$2$4 ==.
;	apps/slave_wixel/slave_wixel.c:216: P1_6 = 0;
	clr	_P1_6
00108$:
	C$slave_wixel.c$218$1$1 ==.
	XG$updateMotor$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'updateStatusLeds'
;------------------------------------------------------------
	G$updateStatusLeds$0$0 ==.
	C$slave_wixel.c$223$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:223: void updateStatusLeds()
;	-----------------------------------------
;	 function updateStatusLeds
;	-----------------------------------------
_updateStatusLeds:
	C$slave_wixel.c$225$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:225: uint16 now = (uint16)getMs();
	lcall	_getMs
	mov	r4,dpl
	mov	r5,dph
	C$slave_wixel.c$226$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:226: BIT isConnected = ((uint16)(now - lastPacketTime) < CONNECTION_TIMEOUT);
	mov	r0,#_lastPacketTime
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
	subb	a,#0xD0
	mov	a,r7
	subb	a,#0x07
	mov  _updateStatusLeds_sloc0_1_0,c
	C$slave_wixel.c$229$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:229: if (isConnected)
	mov	_updateStatusLeds_isConnected_1_1,c
	jnc	00102$
	C$slave_wixel.c$231$3$3 ==.
;	apps/slave_wixel/slave_wixel.c:231: LED_RED(1);
	orl	_P2DIR,#0x02
	sjmp	00103$
00102$:
	C$slave_wixel.c$235$3$5 ==.
;	apps/slave_wixel/slave_wixel.c:235: LED_RED(0);
	mov	r7,_P2DIR
	anl	ar7,#0xFD
	mov	_P2DIR,r7
00103$:
	C$slave_wixel.c$239$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:239: if (dataReceivedFlag)
	jnb	_dataReceivedFlag,00108$
	C$slave_wixel.c$241$2$6 ==.
;	apps/slave_wixel/slave_wixel.c:241: if ((uint16)(now - dataReceivedTime) < YELLOW_LED_PULSE)
	mov	r0,#_dataReceivedTime
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
	jnc	00105$
	C$slave_wixel.c$243$4$8 ==.
;	apps/slave_wixel/slave_wixel.c:243: LED_YELLOW(1);
	orl	_P2DIR,#0x04
	sjmp	00110$
00105$:
	C$slave_wixel.c$247$4$10 ==.
;	apps/slave_wixel/slave_wixel.c:247: LED_YELLOW(0);
	mov	r7,_P2DIR
	anl	ar7,#0xFB
	mov	_P2DIR,r7
	C$slave_wixel.c$248$3$9 ==.
;	apps/slave_wixel/slave_wixel.c:248: dataReceivedFlag = 0;
	clr	_dataReceivedFlag
	sjmp	00110$
00108$:
	C$slave_wixel.c$253$3$12 ==.
;	apps/slave_wixel/slave_wixel.c:253: LED_YELLOW(0);
	mov	r7,_P2DIR
	anl	ar7,#0xFB
	mov	_P2DIR,r7
00110$:
	C$slave_wixel.c$255$1$1 ==.
	XG$updateStatusLeds$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'receiveAndProcessPackets'
;------------------------------------------------------------
	G$receiveAndProcessPackets$0$0 ==.
	C$slave_wixel.c$260$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:260: void receiveAndProcessPackets()
;	-----------------------------------------
;	 function receiveAndProcessPackets
;	-----------------------------------------
_receiveAndProcessPackets:
	C$slave_wixel.c$262$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:262: if (RFIF & (1<<4))
	mov	a,_RFIF
	jnb	acc.4,00111$
	C$slave_wixel.c$264$2$2 ==.
;	apps/slave_wixel/slave_wixel.c:264: if (radioCrcPassed())
	lcall	_radioCrcPassed
	jnc	00108$
	C$slave_wixel.c$274$4$4 ==.
;	apps/slave_wixel/slave_wixel.c:274: slaveAddress = rxPacket[1];
	mov	dptr,#(_rxPacket + 0x0001)
	movx	a,@dptr
	mov	r7,a
	C$slave_wixel.c$275$4$4 ==.
;	apps/slave_wixel/slave_wixel.c:275: slaveCmd = rxPacket[4];
	mov	dptr,#(_rxPacket + 0x0004)
	movx	a,@dptr
	mov	r6,a
	C$slave_wixel.c$276$4$4 ==.
;	apps/slave_wixel/slave_wixel.c:276: slaveRed = rxPacket[5];
	mov	dptr,#(_rxPacket + 0x0005)
	movx	a,@dptr
	mov	r5,a
	C$slave_wixel.c$277$4$4 ==.
;	apps/slave_wixel/slave_wixel.c:277: slaveGreen = rxPacket[6];
	mov	dptr,#(_rxPacket + 0x0006)
	movx	a,@dptr
	mov	r4,a
	C$slave_wixel.c$278$4$4 ==.
;	apps/slave_wixel/slave_wixel.c:278: slaveBlue = rxPacket[7];
	mov	dptr,#(_rxPacket + 0x0007)
	movx	a,@dptr
	mov	r3,a
	C$slave_wixel.c$289$3$3 ==.
;	apps/slave_wixel/slave_wixel.c:289: if (slaveAddress == THIS_SLAVE_ADDRESS && slaveCmd == CMD_SET_LED)
	cjne	r7,#0x01,00108$
	cjne	r6,#0x01,00108$
	C$slave_wixel.c$291$4$6 ==.
;	apps/slave_wixel/slave_wixel.c:291: ledRed = slaveRed;
	mov	r0,#_ledRed
	mov	a,r5
	movx	@r0,a
	C$slave_wixel.c$292$4$6 ==.
;	apps/slave_wixel/slave_wixel.c:292: ledGreen = slaveGreen;
	mov	r0,#_ledGreen
	mov	a,r4
	movx	@r0,a
	C$slave_wixel.c$293$4$6 ==.
;	apps/slave_wixel/slave_wixel.c:293: ledBlue = slaveBlue;
	mov	r0,#_ledBlue
	mov	a,r3
	movx	@r0,a
	C$slave_wixel.c$294$4$6 ==.
;	apps/slave_wixel/slave_wixel.c:294: lastPacketTime = (uint16)getMs();
	lcall	_getMs
	mov	r4,dpl
	mov	r5,dph
	mov	r0,#_lastPacketTime
	mov	a,r4
	movx	@r0,a
	inc	r0
	mov	a,r5
	movx	@r0,a
	C$slave_wixel.c$296$4$6 ==.
;	apps/slave_wixel/slave_wixel.c:296: dataReceivedFlag = 1;
	setb	_dataReceivedFlag
	C$slave_wixel.c$297$4$6 ==.
;	apps/slave_wixel/slave_wixel.c:297: dataReceivedTime = (uint16)getMs();
	lcall	_getMs
	mov	r4,dpl
	mov	r5,dph
	mov	r6,b
	mov	r7,a
	mov	r0,#_dataReceivedTime
	mov	a,r4
	movx	@r0,a
	inc	r0
	mov	a,r5
	movx	@r0,a
00108$:
	C$slave_wixel.c$301$2$2 ==.
;	apps/slave_wixel/slave_wixel.c:301: RFIF &= ~(1<<4);
	mov	r7,_RFIF
	anl	ar7,#0xEF
	mov	_RFIF,r7
	C$slave_wixel.c$302$2$2 ==.
;	apps/slave_wixel/slave_wixel.c:302: DMAARM |= (1<<DMA_CHANNEL_RADIO);
	orl	_DMAARM,#0x02
	C$slave_wixel.c$303$2$2 ==.
;	apps/slave_wixel/slave_wixel.c:303: RFST = 2;
	mov	_RFST,#0x02
00111$:
	C$slave_wixel.c$305$2$1 ==.
	XG$receiveAndProcessPackets$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'handlePacketTimeout'
;------------------------------------------------------------
;sloc0                     Allocated with name '_handlePacketTimeout_sloc0_1_0'
;------------------------------------------------------------
	G$handlePacketTimeout$0$0 ==.
	C$slave_wixel.c$310$2$1 ==.
;	apps/slave_wixel/slave_wixel.c:310: void handlePacketTimeout()
;	-----------------------------------------
;	 function handlePacketTimeout
;	-----------------------------------------
_handlePacketTimeout:
	C$slave_wixel.c$312$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:312: if ((uint16)(getMs() - lastPacketTime) > CONNECTION_TIMEOUT)
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
	mov	a,#0xD0
	subb	a,r2
	mov	a,#0x07
	subb	a,r3
	jnc	00103$
	C$slave_wixel.c$314$2$2 ==.
;	apps/slave_wixel/slave_wixel.c:314: ledRed = 0;
	mov	r0,#_ledRed
	clr	a
	movx	@r0,a
	C$slave_wixel.c$315$2$2 ==.
;	apps/slave_wixel/slave_wixel.c:315: ledGreen = 0;
	mov	r0,#_ledGreen
	clr	a
	movx	@r0,a
	C$slave_wixel.c$316$2$2 ==.
;	apps/slave_wixel/slave_wixel.c:316: ledBlue = 0;
	mov	r0,#_ledBlue
	clr	a
	movx	@r0,a
00103$:
	C$slave_wixel.c$318$2$1 ==.
	XG$handlePacketTimeout$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'main'
;------------------------------------------------------------
	G$main$0$0 ==.
	C$slave_wixel.c$323$2$1 ==.
;	apps/slave_wixel/slave_wixel.c:323: void main()
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
	C$slave_wixel.c$325$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:325: systemInit();
	lcall	_systemInit
	C$slave_wixel.c$326$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:326: radioInit();
	lcall	_radioInit
	C$slave_wixel.c$327$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:327: gpioInit();
	lcall	_gpioInit
	C$slave_wixel.c$329$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:329: lastPacketTime = (uint16)getMs();
	lcall	_getMs
	mov	r4,dpl
	mov	r5,dph
	mov	r0,#_lastPacketTime
	mov	a,r4
	movx	@r0,a
	inc	r0
	mov	a,r5
	movx	@r0,a
	C$slave_wixel.c$332$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:332: P1_1 = 0;  // Red on
	clr	_P1_1
	C$slave_wixel.c$333$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:333: P1_2 = 1;
	setb	_P1_2
	C$slave_wixel.c$334$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:334: P1_7 = 1;
	setb	_P1_7
	C$slave_wixel.c$335$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:335: delayMs(500);
	mov	dptr,#0x01F4
	lcall	_delayMs
	C$slave_wixel.c$337$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:337: P1_1 = 1;
	setb	_P1_1
	C$slave_wixel.c$338$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:338: P1_2 = 0;  // Green on
	clr	_P1_2
	C$slave_wixel.c$339$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:339: P1_7 = 1;
	setb	_P1_7
	C$slave_wixel.c$340$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:340: delayMs(500);
	mov	dptr,#0x01F4
	lcall	_delayMs
	C$slave_wixel.c$342$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:342: P1_1 = 1;
	setb	_P1_1
	C$slave_wixel.c$343$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:343: P1_2 = 1;
	setb	_P1_2
	C$slave_wixel.c$344$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:344: P1_7 = 0;  // Blue on
	clr	_P1_7
	C$slave_wixel.c$345$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:345: delayMs(500);
	mov	dptr,#0x01F4
	lcall	_delayMs
	C$slave_wixel.c$347$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:347: P1_1 = 0;
	clr	_P1_1
	C$slave_wixel.c$348$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:348: P1_2 = 0;
	clr	_P1_2
	C$slave_wixel.c$349$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:349: P1_7 = 0;  // All on
	clr	_P1_7
	C$slave_wixel.c$350$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:350: delayMs(500);
	mov	dptr,#0x01F4
	lcall	_delayMs
	C$slave_wixel.c$352$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:352: P1_1 = 1;
	setb	_P1_1
	C$slave_wixel.c$353$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:353: P1_2 = 1;
	setb	_P1_2
	C$slave_wixel.c$354$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:354: P1_7 = 1;  // All off
	setb	_P1_7
	C$slave_wixel.c$355$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:355: delayMs(500);
	mov	dptr,#0x01F4
	lcall	_delayMs
	C$slave_wixel.c$357$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:357: lastPacketTime = (uint16)getMs();
	lcall	_getMs
	mov	r4,dpl
	mov	r5,dph
	mov	r0,#_lastPacketTime
	mov	a,r4
	movx	@r0,a
	inc	r0
	mov	a,r5
	movx	@r0,a
	C$slave_wixel.c$360$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:360: timer3Init();
	lcall	_timer3Init
	C$slave_wixel.c$362$1$1 ==.
;	apps/slave_wixel/slave_wixel.c:362: while(1)
00102$:
	C$slave_wixel.c$364$2$2 ==.
;	apps/slave_wixel/slave_wixel.c:364: boardService();
	lcall	_boardService
	C$slave_wixel.c$365$2$2 ==.
;	apps/slave_wixel/slave_wixel.c:365: receiveAndProcessPackets();
	lcall	_receiveAndProcessPackets
	C$slave_wixel.c$366$2$2 ==.
;	apps/slave_wixel/slave_wixel.c:366: handlePacketTimeout();
	lcall	_handlePacketTimeout
	C$slave_wixel.c$367$2$2 ==.
;	apps/slave_wixel/slave_wixel.c:367: updateRgbLeds();
	lcall	_updateRgbLeds
	C$slave_wixel.c$368$2$2 ==.
;	apps/slave_wixel/slave_wixel.c:368: updateMotor();
	lcall	_updateMotor
	C$slave_wixel.c$369$2$2 ==.
;	apps/slave_wixel/slave_wixel.c:369: updateStatusLeds();
	lcall	_updateStatusLeds
	sjmp	00102$
	C$slave_wixel.c$371$1$1 ==.
	XG$main$0$0 ==.
	ret
	.area CSEG    (CODE)
	.area CONST   (CODE)
	.area XINIT   (CODE)
	.area CABS    (ABS,CODE)
