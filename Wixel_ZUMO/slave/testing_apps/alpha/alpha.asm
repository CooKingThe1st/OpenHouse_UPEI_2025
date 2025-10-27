;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.1.0 #7066 (Nov 22 2011) (MINGW32)
; This file was generated Thu Oct 23 16:10:43 2025
;--------------------------------------------------------
	.module alpha
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
	.globl _currentTime
	.globl _motorState
	.globl _lastMotorActionTime
	.globl _lastRedLedToggle
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area RSEG    (ABS,DATA)
	.org 0x0000
Falpha$P0$0$0 == 0x0080
_P0	=	0x0080
Falpha$SP$0$0 == 0x0081
_SP	=	0x0081
Falpha$DPL0$0$0 == 0x0082
_DPL0	=	0x0082
Falpha$DPH0$0$0 == 0x0083
_DPH0	=	0x0083
Falpha$DPL1$0$0 == 0x0084
_DPL1	=	0x0084
Falpha$DPH1$0$0 == 0x0085
_DPH1	=	0x0085
Falpha$U0CSR$0$0 == 0x0086
_U0CSR	=	0x0086
Falpha$PCON$0$0 == 0x0087
_PCON	=	0x0087
Falpha$TCON$0$0 == 0x0088
_TCON	=	0x0088
Falpha$P0IFG$0$0 == 0x0089
_P0IFG	=	0x0089
Falpha$P1IFG$0$0 == 0x008a
_P1IFG	=	0x008a
Falpha$P2IFG$0$0 == 0x008b
_P2IFG	=	0x008b
Falpha$PICTL$0$0 == 0x008c
_PICTL	=	0x008c
Falpha$P1IEN$0$0 == 0x008d
_P1IEN	=	0x008d
Falpha$P0INP$0$0 == 0x008f
_P0INP	=	0x008f
Falpha$P1$0$0 == 0x0090
_P1	=	0x0090
Falpha$RFIM$0$0 == 0x0091
_RFIM	=	0x0091
Falpha$DPS$0$0 == 0x0092
_DPS	=	0x0092
Falpha$MPAGE$0$0 == 0x0093
_MPAGE	=	0x0093
Falpha$ENDIAN$0$0 == 0x0095
_ENDIAN	=	0x0095
Falpha$S0CON$0$0 == 0x0098
_S0CON	=	0x0098
Falpha$IEN2$0$0 == 0x009a
_IEN2	=	0x009a
Falpha$S1CON$0$0 == 0x009b
_S1CON	=	0x009b
Falpha$T2CT$0$0 == 0x009c
_T2CT	=	0x009c
Falpha$T2PR$0$0 == 0x009d
_T2PR	=	0x009d
Falpha$T2CTL$0$0 == 0x009e
_T2CTL	=	0x009e
Falpha$P2$0$0 == 0x00a0
_P2	=	0x00a0
Falpha$WORIRQ$0$0 == 0x00a1
_WORIRQ	=	0x00a1
Falpha$WORCTRL$0$0 == 0x00a2
_WORCTRL	=	0x00a2
Falpha$WOREVT0$0$0 == 0x00a3
_WOREVT0	=	0x00a3
Falpha$WOREVT1$0$0 == 0x00a4
_WOREVT1	=	0x00a4
Falpha$WORTIME0$0$0 == 0x00a5
_WORTIME0	=	0x00a5
Falpha$WORTIME1$0$0 == 0x00a6
_WORTIME1	=	0x00a6
Falpha$IEN0$0$0 == 0x00a8
_IEN0	=	0x00a8
Falpha$IP0$0$0 == 0x00a9
_IP0	=	0x00a9
Falpha$FWT$0$0 == 0x00ab
_FWT	=	0x00ab
Falpha$FADDRL$0$0 == 0x00ac
_FADDRL	=	0x00ac
Falpha$FADDRH$0$0 == 0x00ad
_FADDRH	=	0x00ad
Falpha$FCTL$0$0 == 0x00ae
_FCTL	=	0x00ae
Falpha$FWDATA$0$0 == 0x00af
_FWDATA	=	0x00af
Falpha$ENCDI$0$0 == 0x00b1
_ENCDI	=	0x00b1
Falpha$ENCDO$0$0 == 0x00b2
_ENCDO	=	0x00b2
Falpha$ENCCS$0$0 == 0x00b3
_ENCCS	=	0x00b3
Falpha$ADCCON1$0$0 == 0x00b4
_ADCCON1	=	0x00b4
Falpha$ADCCON2$0$0 == 0x00b5
_ADCCON2	=	0x00b5
Falpha$ADCCON3$0$0 == 0x00b6
_ADCCON3	=	0x00b6
Falpha$IEN1$0$0 == 0x00b8
_IEN1	=	0x00b8
Falpha$IP1$0$0 == 0x00b9
_IP1	=	0x00b9
Falpha$ADCL$0$0 == 0x00ba
_ADCL	=	0x00ba
Falpha$ADCH$0$0 == 0x00bb
_ADCH	=	0x00bb
Falpha$RNDL$0$0 == 0x00bc
_RNDL	=	0x00bc
Falpha$RNDH$0$0 == 0x00bd
_RNDH	=	0x00bd
Falpha$SLEEP$0$0 == 0x00be
_SLEEP	=	0x00be
Falpha$IRCON$0$0 == 0x00c0
_IRCON	=	0x00c0
Falpha$U0DBUF$0$0 == 0x00c1
_U0DBUF	=	0x00c1
Falpha$U0BAUD$0$0 == 0x00c2
_U0BAUD	=	0x00c2
Falpha$U0UCR$0$0 == 0x00c4
_U0UCR	=	0x00c4
Falpha$U0GCR$0$0 == 0x00c5
_U0GCR	=	0x00c5
Falpha$CLKCON$0$0 == 0x00c6
_CLKCON	=	0x00c6
Falpha$MEMCTR$0$0 == 0x00c7
_MEMCTR	=	0x00c7
Falpha$WDCTL$0$0 == 0x00c9
_WDCTL	=	0x00c9
Falpha$T3CNT$0$0 == 0x00ca
_T3CNT	=	0x00ca
Falpha$T3CTL$0$0 == 0x00cb
_T3CTL	=	0x00cb
Falpha$T3CCTL0$0$0 == 0x00cc
_T3CCTL0	=	0x00cc
Falpha$T3CC0$0$0 == 0x00cd
_T3CC0	=	0x00cd
Falpha$T3CCTL1$0$0 == 0x00ce
_T3CCTL1	=	0x00ce
Falpha$T3CC1$0$0 == 0x00cf
_T3CC1	=	0x00cf
Falpha$PSW$0$0 == 0x00d0
_PSW	=	0x00d0
Falpha$DMAIRQ$0$0 == 0x00d1
_DMAIRQ	=	0x00d1
Falpha$DMA1CFGL$0$0 == 0x00d2
_DMA1CFGL	=	0x00d2
Falpha$DMA1CFGH$0$0 == 0x00d3
_DMA1CFGH	=	0x00d3
Falpha$DMA0CFGL$0$0 == 0x00d4
_DMA0CFGL	=	0x00d4
Falpha$DMA0CFGH$0$0 == 0x00d5
_DMA0CFGH	=	0x00d5
Falpha$DMAARM$0$0 == 0x00d6
_DMAARM	=	0x00d6
Falpha$DMAREQ$0$0 == 0x00d7
_DMAREQ	=	0x00d7
Falpha$TIMIF$0$0 == 0x00d8
_TIMIF	=	0x00d8
Falpha$RFD$0$0 == 0x00d9
_RFD	=	0x00d9
Falpha$T1CC0L$0$0 == 0x00da
_T1CC0L	=	0x00da
Falpha$T1CC0H$0$0 == 0x00db
_T1CC0H	=	0x00db
Falpha$T1CC1L$0$0 == 0x00dc
_T1CC1L	=	0x00dc
Falpha$T1CC1H$0$0 == 0x00dd
_T1CC1H	=	0x00dd
Falpha$T1CC2L$0$0 == 0x00de
_T1CC2L	=	0x00de
Falpha$T1CC2H$0$0 == 0x00df
_T1CC2H	=	0x00df
Falpha$ACC$0$0 == 0x00e0
_ACC	=	0x00e0
Falpha$RFST$0$0 == 0x00e1
_RFST	=	0x00e1
Falpha$T1CNTL$0$0 == 0x00e2
_T1CNTL	=	0x00e2
Falpha$T1CNTH$0$0 == 0x00e3
_T1CNTH	=	0x00e3
Falpha$T1CTL$0$0 == 0x00e4
_T1CTL	=	0x00e4
Falpha$T1CCTL0$0$0 == 0x00e5
_T1CCTL0	=	0x00e5
Falpha$T1CCTL1$0$0 == 0x00e6
_T1CCTL1	=	0x00e6
Falpha$T1CCTL2$0$0 == 0x00e7
_T1CCTL2	=	0x00e7
Falpha$IRCON2$0$0 == 0x00e8
_IRCON2	=	0x00e8
Falpha$RFIF$0$0 == 0x00e9
_RFIF	=	0x00e9
Falpha$T4CNT$0$0 == 0x00ea
_T4CNT	=	0x00ea
Falpha$T4CTL$0$0 == 0x00eb
_T4CTL	=	0x00eb
Falpha$T4CCTL0$0$0 == 0x00ec
_T4CCTL0	=	0x00ec
Falpha$T4CC0$0$0 == 0x00ed
_T4CC0	=	0x00ed
Falpha$T4CCTL1$0$0 == 0x00ee
_T4CCTL1	=	0x00ee
Falpha$T4CC1$0$0 == 0x00ef
_T4CC1	=	0x00ef
Falpha$B$0$0 == 0x00f0
_B	=	0x00f0
Falpha$PERCFG$0$0 == 0x00f1
_PERCFG	=	0x00f1
Falpha$ADCCFG$0$0 == 0x00f2
_ADCCFG	=	0x00f2
Falpha$P0SEL$0$0 == 0x00f3
_P0SEL	=	0x00f3
Falpha$P1SEL$0$0 == 0x00f4
_P1SEL	=	0x00f4
Falpha$P2SEL$0$0 == 0x00f5
_P2SEL	=	0x00f5
Falpha$P1INP$0$0 == 0x00f6
_P1INP	=	0x00f6
Falpha$P2INP$0$0 == 0x00f7
_P2INP	=	0x00f7
Falpha$U1CSR$0$0 == 0x00f8
_U1CSR	=	0x00f8
Falpha$U1DBUF$0$0 == 0x00f9
_U1DBUF	=	0x00f9
Falpha$U1BAUD$0$0 == 0x00fa
_U1BAUD	=	0x00fa
Falpha$U1UCR$0$0 == 0x00fb
_U1UCR	=	0x00fb
Falpha$U1GCR$0$0 == 0x00fc
_U1GCR	=	0x00fc
Falpha$P0DIR$0$0 == 0x00fd
_P0DIR	=	0x00fd
Falpha$P1DIR$0$0 == 0x00fe
_P1DIR	=	0x00fe
Falpha$P2DIR$0$0 == 0x00ff
_P2DIR	=	0x00ff
Falpha$DMA0CFG$0$0 == 0xffffd5d4
_DMA0CFG	=	0xffffd5d4
Falpha$DMA1CFG$0$0 == 0xffffd3d2
_DMA1CFG	=	0xffffd3d2
Falpha$FADDR$0$0 == 0xffffadac
_FADDR	=	0xffffadac
Falpha$ADC$0$0 == 0xffffbbba
_ADC	=	0xffffbbba
Falpha$T1CC0$0$0 == 0xffffdbda
_T1CC0	=	0xffffdbda
Falpha$T1CC1$0$0 == 0xffffdddc
_T1CC1	=	0xffffdddc
Falpha$T1CC2$0$0 == 0xffffdfde
_T1CC2	=	0xffffdfde
;--------------------------------------------------------
; special function bits
;--------------------------------------------------------
	.area RSEG    (ABS,DATA)
	.org 0x0000
Falpha$P0_0$0$0 == 0x0080
_P0_0	=	0x0080
Falpha$P0_1$0$0 == 0x0081
_P0_1	=	0x0081
Falpha$P0_2$0$0 == 0x0082
_P0_2	=	0x0082
Falpha$P0_3$0$0 == 0x0083
_P0_3	=	0x0083
Falpha$P0_4$0$0 == 0x0084
_P0_4	=	0x0084
Falpha$P0_5$0$0 == 0x0085
_P0_5	=	0x0085
Falpha$P0_6$0$0 == 0x0086
_P0_6	=	0x0086
Falpha$P0_7$0$0 == 0x0087
_P0_7	=	0x0087
Falpha$_TCON_0$0$0 == 0x0088
__TCON_0	=	0x0088
Falpha$RFTXRXIF$0$0 == 0x0089
_RFTXRXIF	=	0x0089
Falpha$_TCON_2$0$0 == 0x008a
__TCON_2	=	0x008a
Falpha$URX0IF$0$0 == 0x008b
_URX0IF	=	0x008b
Falpha$_TCON_4$0$0 == 0x008c
__TCON_4	=	0x008c
Falpha$ADCIF$0$0 == 0x008d
_ADCIF	=	0x008d
Falpha$_TCON_6$0$0 == 0x008e
__TCON_6	=	0x008e
Falpha$URX1IF$0$0 == 0x008f
_URX1IF	=	0x008f
Falpha$P1_0$0$0 == 0x0090
_P1_0	=	0x0090
Falpha$P1_1$0$0 == 0x0091
_P1_1	=	0x0091
Falpha$P1_2$0$0 == 0x0092
_P1_2	=	0x0092
Falpha$P1_3$0$0 == 0x0093
_P1_3	=	0x0093
Falpha$P1_4$0$0 == 0x0094
_P1_4	=	0x0094
Falpha$P1_5$0$0 == 0x0095
_P1_5	=	0x0095
Falpha$P1_6$0$0 == 0x0096
_P1_6	=	0x0096
Falpha$P1_7$0$0 == 0x0097
_P1_7	=	0x0097
Falpha$ENCIF_0$0$0 == 0x0098
_ENCIF_0	=	0x0098
Falpha$ENCIF_1$0$0 == 0x0099
_ENCIF_1	=	0x0099
Falpha$_SOCON2$0$0 == 0x009a
__SOCON2	=	0x009a
Falpha$_SOCON3$0$0 == 0x009b
__SOCON3	=	0x009b
Falpha$_SOCON4$0$0 == 0x009c
__SOCON4	=	0x009c
Falpha$_SOCON5$0$0 == 0x009d
__SOCON5	=	0x009d
Falpha$_SOCON6$0$0 == 0x009e
__SOCON6	=	0x009e
Falpha$_SOCON7$0$0 == 0x009f
__SOCON7	=	0x009f
Falpha$P2_0$0$0 == 0x00a0
_P2_0	=	0x00a0
Falpha$P2_1$0$0 == 0x00a1
_P2_1	=	0x00a1
Falpha$P2_2$0$0 == 0x00a2
_P2_2	=	0x00a2
Falpha$P2_3$0$0 == 0x00a3
_P2_3	=	0x00a3
Falpha$P2_4$0$0 == 0x00a4
_P2_4	=	0x00a4
Falpha$P2_5$0$0 == 0x00a5
_P2_5	=	0x00a5
Falpha$P2_6$0$0 == 0x00a6
_P2_6	=	0x00a6
Falpha$P2_7$0$0 == 0x00a7
_P2_7	=	0x00a7
Falpha$RFTXRXIE$0$0 == 0x00a8
_RFTXRXIE	=	0x00a8
Falpha$ADCIE$0$0 == 0x00a9
_ADCIE	=	0x00a9
Falpha$URX0IE$0$0 == 0x00aa
_URX0IE	=	0x00aa
Falpha$URX1IE$0$0 == 0x00ab
_URX1IE	=	0x00ab
Falpha$ENCIE$0$0 == 0x00ac
_ENCIE	=	0x00ac
Falpha$STIE$0$0 == 0x00ad
_STIE	=	0x00ad
Falpha$_IEN06$0$0 == 0x00ae
__IEN06	=	0x00ae
Falpha$EA$0$0 == 0x00af
_EA	=	0x00af
Falpha$DMAIE$0$0 == 0x00b8
_DMAIE	=	0x00b8
Falpha$T1IE$0$0 == 0x00b9
_T1IE	=	0x00b9
Falpha$T2IE$0$0 == 0x00ba
_T2IE	=	0x00ba
Falpha$T3IE$0$0 == 0x00bb
_T3IE	=	0x00bb
Falpha$T4IE$0$0 == 0x00bc
_T4IE	=	0x00bc
Falpha$P0IE$0$0 == 0x00bd
_P0IE	=	0x00bd
Falpha$_IEN16$0$0 == 0x00be
__IEN16	=	0x00be
Falpha$_IEN17$0$0 == 0x00bf
__IEN17	=	0x00bf
Falpha$DMAIF$0$0 == 0x00c0
_DMAIF	=	0x00c0
Falpha$T1IF$0$0 == 0x00c1
_T1IF	=	0x00c1
Falpha$T2IF$0$0 == 0x00c2
_T2IF	=	0x00c2
Falpha$T3IF$0$0 == 0x00c3
_T3IF	=	0x00c3
Falpha$T4IF$0$0 == 0x00c4
_T4IF	=	0x00c4
Falpha$P0IF$0$0 == 0x00c5
_P0IF	=	0x00c5
Falpha$_IRCON6$0$0 == 0x00c6
__IRCON6	=	0x00c6
Falpha$STIF$0$0 == 0x00c7
_STIF	=	0x00c7
Falpha$P$0$0 == 0x00d0
_P	=	0x00d0
Falpha$F1$0$0 == 0x00d1
_F1	=	0x00d1
Falpha$OV$0$0 == 0x00d2
_OV	=	0x00d2
Falpha$RS0$0$0 == 0x00d3
_RS0	=	0x00d3
Falpha$RS1$0$0 == 0x00d4
_RS1	=	0x00d4
Falpha$F0$0$0 == 0x00d5
_F0	=	0x00d5
Falpha$AC$0$0 == 0x00d6
_AC	=	0x00d6
Falpha$CY$0$0 == 0x00d7
_CY	=	0x00d7
Falpha$T3OVFIF$0$0 == 0x00d8
_T3OVFIF	=	0x00d8
Falpha$T3CH0IF$0$0 == 0x00d9
_T3CH0IF	=	0x00d9
Falpha$T3CH1IF$0$0 == 0x00da
_T3CH1IF	=	0x00da
Falpha$T4OVFIF$0$0 == 0x00db
_T4OVFIF	=	0x00db
Falpha$T4CH0IF$0$0 == 0x00dc
_T4CH0IF	=	0x00dc
Falpha$T4CH1IF$0$0 == 0x00dd
_T4CH1IF	=	0x00dd
Falpha$OVFIM$0$0 == 0x00de
_OVFIM	=	0x00de
Falpha$_TIMIF7$0$0 == 0x00df
__TIMIF7	=	0x00df
Falpha$ACC_0$0$0 == 0x00e0
_ACC_0	=	0x00e0
Falpha$ACC_1$0$0 == 0x00e1
_ACC_1	=	0x00e1
Falpha$ACC_2$0$0 == 0x00e2
_ACC_2	=	0x00e2
Falpha$ACC_3$0$0 == 0x00e3
_ACC_3	=	0x00e3
Falpha$ACC_4$0$0 == 0x00e4
_ACC_4	=	0x00e4
Falpha$ACC_5$0$0 == 0x00e5
_ACC_5	=	0x00e5
Falpha$ACC_6$0$0 == 0x00e6
_ACC_6	=	0x00e6
Falpha$ACC_7$0$0 == 0x00e7
_ACC_7	=	0x00e7
Falpha$P2IF$0$0 == 0x00e8
_P2IF	=	0x00e8
Falpha$UTX0IF$0$0 == 0x00e9
_UTX0IF	=	0x00e9
Falpha$UTX1IF$0$0 == 0x00ea
_UTX1IF	=	0x00ea
Falpha$P1IF$0$0 == 0x00eb
_P1IF	=	0x00eb
Falpha$WDTIF$0$0 == 0x00ec
_WDTIF	=	0x00ec
Falpha$_IRCON25$0$0 == 0x00ed
__IRCON25	=	0x00ed
Falpha$_IRCON26$0$0 == 0x00ee
__IRCON26	=	0x00ee
Falpha$_IRCON27$0$0 == 0x00ef
__IRCON27	=	0x00ef
Falpha$B_0$0$0 == 0x00f0
_B_0	=	0x00f0
Falpha$B_1$0$0 == 0x00f1
_B_1	=	0x00f1
Falpha$B_2$0$0 == 0x00f2
_B_2	=	0x00f2
Falpha$B_3$0$0 == 0x00f3
_B_3	=	0x00f3
Falpha$B_4$0$0 == 0x00f4
_B_4	=	0x00f4
Falpha$B_5$0$0 == 0x00f5
_B_5	=	0x00f5
Falpha$B_6$0$0 == 0x00f6
_B_6	=	0x00f6
Falpha$B_7$0$0 == 0x00f7
_B_7	=	0x00f7
Falpha$U1ACTIVE$0$0 == 0x00f8
_U1ACTIVE	=	0x00f8
Falpha$U1TX_BYTE$0$0 == 0x00f9
_U1TX_BYTE	=	0x00f9
Falpha$U1RX_BYTE$0$0 == 0x00fa
_U1RX_BYTE	=	0x00fa
Falpha$U1ERR$0$0 == 0x00fb
_U1ERR	=	0x00fb
Falpha$U1FE$0$0 == 0x00fc
_U1FE	=	0x00fc
Falpha$U1SLAVE$0$0 == 0x00fd
_U1SLAVE	=	0x00fd
Falpha$U1RE$0$0 == 0x00fe
_U1RE	=	0x00fe
Falpha$U1MODE$0$0 == 0x00ff
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
G$currentTime$0$0==.
_currentTime::
	.ds 4
G$i$0$0==.
_i::
	.ds 1
;--------------------------------------------------------
; external ram data
;--------------------------------------------------------
	.area XSEG    (XDATA)
Falpha$SYNC1$0$0 == 0xdf00
_SYNC1	=	0xdf00
Falpha$SYNC0$0$0 == 0xdf01
_SYNC0	=	0xdf01
Falpha$PKTLEN$0$0 == 0xdf02
_PKTLEN	=	0xdf02
Falpha$PKTCTRL1$0$0 == 0xdf03
_PKTCTRL1	=	0xdf03
Falpha$PKTCTRL0$0$0 == 0xdf04
_PKTCTRL0	=	0xdf04
Falpha$ADDR$0$0 == 0xdf05
_ADDR	=	0xdf05
Falpha$CHANNR$0$0 == 0xdf06
_CHANNR	=	0xdf06
Falpha$FSCTRL1$0$0 == 0xdf07
_FSCTRL1	=	0xdf07
Falpha$FSCTRL0$0$0 == 0xdf08
_FSCTRL0	=	0xdf08
Falpha$FREQ2$0$0 == 0xdf09
_FREQ2	=	0xdf09
Falpha$FREQ1$0$0 == 0xdf0a
_FREQ1	=	0xdf0a
Falpha$FREQ0$0$0 == 0xdf0b
_FREQ0	=	0xdf0b
Falpha$MDMCFG4$0$0 == 0xdf0c
_MDMCFG4	=	0xdf0c
Falpha$MDMCFG3$0$0 == 0xdf0d
_MDMCFG3	=	0xdf0d
Falpha$MDMCFG2$0$0 == 0xdf0e
_MDMCFG2	=	0xdf0e
Falpha$MDMCFG1$0$0 == 0xdf0f
_MDMCFG1	=	0xdf0f
Falpha$MDMCFG0$0$0 == 0xdf10
_MDMCFG0	=	0xdf10
Falpha$DEVIATN$0$0 == 0xdf11
_DEVIATN	=	0xdf11
Falpha$MCSM2$0$0 == 0xdf12
_MCSM2	=	0xdf12
Falpha$MCSM1$0$0 == 0xdf13
_MCSM1	=	0xdf13
Falpha$MCSM0$0$0 == 0xdf14
_MCSM0	=	0xdf14
Falpha$FOCCFG$0$0 == 0xdf15
_FOCCFG	=	0xdf15
Falpha$BSCFG$0$0 == 0xdf16
_BSCFG	=	0xdf16
Falpha$AGCCTRL2$0$0 == 0xdf17
_AGCCTRL2	=	0xdf17
Falpha$AGCCTRL1$0$0 == 0xdf18
_AGCCTRL1	=	0xdf18
Falpha$AGCCTRL0$0$0 == 0xdf19
_AGCCTRL0	=	0xdf19
Falpha$FREND1$0$0 == 0xdf1a
_FREND1	=	0xdf1a
Falpha$FREND0$0$0 == 0xdf1b
_FREND0	=	0xdf1b
Falpha$FSCAL3$0$0 == 0xdf1c
_FSCAL3	=	0xdf1c
Falpha$FSCAL2$0$0 == 0xdf1d
_FSCAL2	=	0xdf1d
Falpha$FSCAL1$0$0 == 0xdf1e
_FSCAL1	=	0xdf1e
Falpha$FSCAL0$0$0 == 0xdf1f
_FSCAL0	=	0xdf1f
Falpha$TEST2$0$0 == 0xdf23
_TEST2	=	0xdf23
Falpha$TEST1$0$0 == 0xdf24
_TEST1	=	0xdf24
Falpha$TEST0$0$0 == 0xdf25
_TEST0	=	0xdf25
Falpha$PA_TABLE0$0$0 == 0xdf2e
_PA_TABLE0	=	0xdf2e
Falpha$IOCFG2$0$0 == 0xdf2f
_IOCFG2	=	0xdf2f
Falpha$IOCFG1$0$0 == 0xdf30
_IOCFG1	=	0xdf30
Falpha$IOCFG0$0$0 == 0xdf31
_IOCFG0	=	0xdf31
Falpha$PARTNUM$0$0 == 0xdf36
_PARTNUM	=	0xdf36
Falpha$VERSION$0$0 == 0xdf37
_VERSION	=	0xdf37
Falpha$FREQEST$0$0 == 0xdf38
_FREQEST	=	0xdf38
Falpha$LQI$0$0 == 0xdf39
_LQI	=	0xdf39
Falpha$RSSI$0$0 == 0xdf3a
_RSSI	=	0xdf3a
Falpha$MARCSTATE$0$0 == 0xdf3b
_MARCSTATE	=	0xdf3b
Falpha$PKTSTATUS$0$0 == 0xdf3c
_PKTSTATUS	=	0xdf3c
Falpha$VCO_VC_DAC$0$0 == 0xdf3d
_VCO_VC_DAC	=	0xdf3d
Falpha$I2SCFG0$0$0 == 0xdf40
_I2SCFG0	=	0xdf40
Falpha$I2SCFG1$0$0 == 0xdf41
_I2SCFG1	=	0xdf41
Falpha$I2SDATL$0$0 == 0xdf42
_I2SDATL	=	0xdf42
Falpha$I2SDATH$0$0 == 0xdf43
_I2SDATH	=	0xdf43
Falpha$I2SWCNT$0$0 == 0xdf44
_I2SWCNT	=	0xdf44
Falpha$I2SSTAT$0$0 == 0xdf45
_I2SSTAT	=	0xdf45
Falpha$I2SCLKF0$0$0 == 0xdf46
_I2SCLKF0	=	0xdf46
Falpha$I2SCLKF1$0$0 == 0xdf47
_I2SCLKF1	=	0xdf47
Falpha$I2SCLKF2$0$0 == 0xdf48
_I2SCLKF2	=	0xdf48
Falpha$USBADDR$0$0 == 0xde00
_USBADDR	=	0xde00
Falpha$USBPOW$0$0 == 0xde01
_USBPOW	=	0xde01
Falpha$USBIIF$0$0 == 0xde02
_USBIIF	=	0xde02
Falpha$USBOIF$0$0 == 0xde04
_USBOIF	=	0xde04
Falpha$USBCIF$0$0 == 0xde06
_USBCIF	=	0xde06
Falpha$USBIIE$0$0 == 0xde07
_USBIIE	=	0xde07
Falpha$USBOIE$0$0 == 0xde09
_USBOIE	=	0xde09
Falpha$USBCIE$0$0 == 0xde0b
_USBCIE	=	0xde0b
Falpha$USBFRML$0$0 == 0xde0c
_USBFRML	=	0xde0c
Falpha$USBFRMH$0$0 == 0xde0d
_USBFRMH	=	0xde0d
Falpha$USBINDEX$0$0 == 0xde0e
_USBINDEX	=	0xde0e
Falpha$USBMAXI$0$0 == 0xde10
_USBMAXI	=	0xde10
Falpha$USBCSIL$0$0 == 0xde11
_USBCSIL	=	0xde11
Falpha$USBCSIH$0$0 == 0xde12
_USBCSIH	=	0xde12
Falpha$USBMAXO$0$0 == 0xde13
_USBMAXO	=	0xde13
Falpha$USBCSOL$0$0 == 0xde14
_USBCSOL	=	0xde14
Falpha$USBCSOH$0$0 == 0xde15
_USBCSOH	=	0xde15
Falpha$USBCNTL$0$0 == 0xde16
_USBCNTL	=	0xde16
Falpha$USBCNTH$0$0 == 0xde17
_USBCNTH	=	0xde17
Falpha$USBF0$0$0 == 0xde20
_USBF0	=	0xde20
Falpha$USBF1$0$0 == 0xde22
_USBF1	=	0xde22
Falpha$USBF2$0$0 == 0xde24
_USBF2	=	0xde24
Falpha$USBF3$0$0 == 0xde26
_USBF3	=	0xde26
Falpha$USBF4$0$0 == 0xde28
_USBF4	=	0xde28
Falpha$USBF5$0$0 == 0xde2a
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
	C$alpha.c$50$1$1 ==.
;	apps/alpha/alpha.c:50: uint32 lastRedLedToggle = 0;
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
	C$alpha.c$51$1$1 ==.
;	apps/alpha/alpha.c:51: uint32 lastMotorActionTime = 0;
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
	C$alpha.c$52$1$1 ==.
;	apps/alpha/alpha.c:52: uint8 motorState = 0; // 0=Stop, 1=Forward, 2=Stop, 3=Reverse
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
	C$alpha.c$59$0$0 ==.
;	apps/alpha/alpha.c:59: void timer3Init()
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
	C$alpha.c$61$1$1 ==.
;	apps/alpha/alpha.c:61: T3CTL = 0b01110000;   // Prescaler 1:8, frequency = 11.7 kHz
	mov	_T3CTL,#0x70
	C$alpha.c$62$1$1 ==.
;	apps/alpha/alpha.c:62: T3CC0 = T3CC1 = 0;    // Set duty cycles to zero
	mov	_T3CC1,#0x00
	mov	_T3CC0,#0x00
	C$alpha.c$63$1$1 ==.
;	apps/alpha/alpha.c:63: T3CCTL0 = T3CCTL1 = 0b00100100;
	mov	_T3CCTL1,#0x24
	mov	_T3CCTL0,#0x24
	C$alpha.c$64$1$1 ==.
;	apps/alpha/alpha.c:64: PERCFG &= ~(1<<5);    // Alternate location
	mov	r7,_PERCFG
	anl	ar7,#0xDF
	mov	_PERCFG,r7
	C$alpha.c$65$1$1 ==.
;	apps/alpha/alpha.c:65: P1SEL |= (1<<3) | (1<<4);  // P1_3 and P1_4 as PWM
	orl	_P1SEL,#0x18
	C$alpha.c$66$1$1 ==.
	XG$timer3Init$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'updateHeartbeatLed'
;------------------------------------------------------------
	G$updateHeartbeatLed$0$0 ==.
	C$alpha.c$71$1$1 ==.
;	apps/alpha/alpha.c:71: void updateHeartbeatLed()
;	-----------------------------------------
;	 function updateHeartbeatLed
;	-----------------------------------------
_updateHeartbeatLed:
	C$alpha.c$74$1$1 ==.
;	apps/alpha/alpha.c:74: if (getMs() - lastRedLedToggle >= 500)
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
	C$alpha.c$76$3$3 ==.
;	apps/alpha/alpha.c:76: LED_RED_TOGGLE();
	xrl	_P2DIR,#0x02
	C$alpha.c$77$2$2 ==.
;	apps/alpha/alpha.c:77: lastRedLedToggle = getMs();
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
	C$alpha.c$79$2$1 ==.
	XG$updateHeartbeatLed$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'main'
;------------------------------------------------------------
	G$main$0$0 ==.
	C$alpha.c$98$2$1 ==.
;	apps/alpha/alpha.c:98: void main()
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
	C$alpha.c$100$1$1 ==.
;	apps/alpha/alpha.c:100: systemInit();
	lcall	_systemInit
	C$alpha.c$101$1$1 ==.
;	apps/alpha/alpha.c:101: usbInit();
	lcall	_usbInit
	C$alpha.c$104$2$2 ==.
;	apps/alpha/alpha.c:104: LED_RED(0);
	mov	r7,_P2DIR
	anl	ar7,#0xFD
	mov	_P2DIR,r7
	C$alpha.c$105$2$3 ==.
;	apps/alpha/alpha.c:105: LED_RED_TOGGLE();
	xrl	_P2DIR,#0x02
	C$alpha.c$107$1$1 ==.
;	apps/alpha/alpha.c:107: delayMs(200);
	mov	dptr,#0x00C8
	lcall	_delayMs
	C$alpha.c$110$1$1 ==.
;	apps/alpha/alpha.c:110: for(i = 0; i < 70; i++) {
	mov	r0,#_i
	clr	a
	movx	@r0,a
00104$:
	mov	r0,#_i
	movx	a,@r0
	cjne	a,#0x46,00113$
00113$:
	jnc	00107$
	C$alpha.c$111$3$5 ==.
;	apps/alpha/alpha.c:111: LED_RED_TOGGLE();
	xrl	_P2DIR,#0x02
	C$alpha.c$112$2$4 ==.
;	apps/alpha/alpha.c:112: boardService();
	lcall	_boardService
	C$alpha.c$113$2$4 ==.
;	apps/alpha/alpha.c:113: usbComService();
	lcall	_usbComService
	C$alpha.c$114$2$4 ==.
;	apps/alpha/alpha.c:114: delayMs(100);
	mov	dptr,#0x0064
	lcall	_delayMs
	C$alpha.c$110$1$1 ==.
;	apps/alpha/alpha.c:110: for(i = 0; i < 70; i++) {
	mov	r0,#_i
	movx	a,@r0
	add	a,#0x01
	movx	@r0,a
	sjmp	00104$
00107$:
	C$alpha.c$118$2$6 ==.
;	apps/alpha/alpha.c:118: LED_RED(0);
	mov	r7,_P2DIR
	anl	ar7,#0xFD
	mov	_P2DIR,r7
	C$alpha.c$122$1$1 ==.
;	apps/alpha/alpha.c:122: P1SEL = 0x00;     // Force ALL P1 pins to GPIO mode
	mov	_P1SEL,#0x00
	C$alpha.c$123$1$1 ==.
;	apps/alpha/alpha.c:123: P1DIR = 0x00;     // Start with all inputs
	mov	_P1DIR,#0x00
	C$alpha.c$124$1$1 ==.
;	apps/alpha/alpha.c:124: P1 = 0x00;        // Clear all output values
	mov	_P1,#0x00
	C$alpha.c$127$1$1 ==.
;	apps/alpha/alpha.c:127: T1CTL = 0x00;
	mov	_T1CTL,#0x00
	C$alpha.c$128$1$1 ==.
;	apps/alpha/alpha.c:128: T3CTL = 0x00;
	mov	_T3CTL,#0x00
	C$alpha.c$129$1$1 ==.
;	apps/alpha/alpha.c:129: T4CTL = 0x00;
	mov	_T4CTL,#0x00
	C$alpha.c$132$1$1 ==.
;	apps/alpha/alpha.c:132: P1DIR |= (1 << 1) | (1 << 2) | (1 << 7);  // RGB pins as outputs
	orl	_P1DIR,#0x86
	C$alpha.c$133$1$1 ==.
;	apps/alpha/alpha.c:133: P1DIR |= (1 << 5) | (1 << 6);  // Motor direction pins as outputs (both wheels)
	orl	_P1DIR,#0x60
	C$alpha.c$136$1$1 ==.
;	apps/alpha/alpha.c:136: P1SEL = 0x00;
	mov	_P1SEL,#0x00
	C$alpha.c$141$1$1 ==.
;	apps/alpha/alpha.c:141: P1 = 0xFF;
	mov	_P1,#0xFF
	C$alpha.c$142$1$1 ==.
;	apps/alpha/alpha.c:142: delayMs(1000);
	mov	dptr,#0x03E8
	lcall	_delayMs
	C$alpha.c$145$1$1 ==.
;	apps/alpha/alpha.c:145: P1 = 0b11111101;  // Only bit 1 is 0
	mov	_P1,#0xFD
	C$alpha.c$146$1$1 ==.
;	apps/alpha/alpha.c:146: delayMs(300);
	mov	dptr,#0x012C
	lcall	_delayMs
	C$alpha.c$149$1$1 ==.
;	apps/alpha/alpha.c:149: P1 = 0b11111011;  // Only bit 2 is 0
	mov	_P1,#0xFB
	C$alpha.c$150$1$1 ==.
;	apps/alpha/alpha.c:150: delayMs(300);
	mov	dptr,#0x012C
	lcall	_delayMs
	C$alpha.c$153$1$1 ==.
;	apps/alpha/alpha.c:153: P1 = 0b01111111;  // Only bit 7 is 0
	mov	_P1,#0x7F
	C$alpha.c$154$1$1 ==.
;	apps/alpha/alpha.c:154: delayMs(300);
	mov	dptr,#0x012C
	lcall	_delayMs
	C$alpha.c$157$1$1 ==.
;	apps/alpha/alpha.c:157: P1 = 0xFF;
	mov	_P1,#0xFF
	C$alpha.c$158$1$1 ==.
;	apps/alpha/alpha.c:158: delayMs(500);
	mov	dptr,#0x01F4
	lcall	_delayMs
	C$alpha.c$161$1$1 ==.
;	apps/alpha/alpha.c:161: timer3Init();
	lcall	_timer3Init
	C$alpha.c$166$1$1 ==.
;	apps/alpha/alpha.c:166: P1 = 0b10011110;  // Bits 5,6 = 0 (both forward), Bit 1 = 0 (RED LED ON)
	mov	_P1,#0x9E
	C$alpha.c$167$1$1 ==.
;	apps/alpha/alpha.c:167: T3CC0 = MOTOR_SPEED;
	mov	_T3CC0,#0x64
	C$alpha.c$168$1$1 ==.
;	apps/alpha/alpha.c:168: T3CC1 = MOTOR_SPEED / 2;
	mov	_T3CC1,#0x32
	C$alpha.c$169$1$1 ==.
;	apps/alpha/alpha.c:169: delayMs(2000);
	mov	dptr,#0x07D0
	lcall	_delayMs
	C$alpha.c$172$1$1 ==.
;	apps/alpha/alpha.c:172: T3CC0 = 0;
	mov	_T3CC0,#0x00
	C$alpha.c$173$1$1 ==.
;	apps/alpha/alpha.c:173: T3CC1 = 0;
	mov	_T3CC1,#0x00
	C$alpha.c$174$1$1 ==.
;	apps/alpha/alpha.c:174: P1 = 0b11111011;  // Bits 5,6 = 0 (stay forward), Bit 2 = 0 (GREEN LED ON)
	mov	_P1,#0xFB
	C$alpha.c$175$1$1 ==.
;	apps/alpha/alpha.c:175: delayMs(1000);
	mov	dptr,#0x03E8
	lcall	_delayMs
	C$alpha.c$178$1$1 ==.
;	apps/alpha/alpha.c:178: P1 = 0b01111111;  // Bits 5,6 = 1 (both reverse), Bit 7 = 0 (BLUE LED ON)
	mov	_P1,#0x7F
	C$alpha.c$179$1$1 ==.
;	apps/alpha/alpha.c:179: T3CC0 = MOTOR_SPEED / 2;
	mov	_T3CC0,#0x32
	C$alpha.c$180$1$1 ==.
;	apps/alpha/alpha.c:180: T3CC1 = MOTOR_SPEED;
	mov	_T3CC1,#0x64
	C$alpha.c$181$1$1 ==.
;	apps/alpha/alpha.c:181: delayMs(2000);
	mov	dptr,#0x07D0
	lcall	_delayMs
	C$alpha.c$184$1$1 ==.
;	apps/alpha/alpha.c:184: T3CC0 = 0;
	mov	_T3CC0,#0x00
	C$alpha.c$185$1$1 ==.
;	apps/alpha/alpha.c:185: T3CC1 = 0;
	mov	_T3CC1,#0x00
	C$alpha.c$186$1$1 ==.
;	apps/alpha/alpha.c:186: P1 = 0xFF;  // All LEDs off
	mov	_P1,#0xFF
	C$alpha.c$187$1$1 ==.
;	apps/alpha/alpha.c:187: delayMs(1000);
	mov	dptr,#0x03E8
	lcall	_delayMs
	C$alpha.c$190$1$1 ==.
;	apps/alpha/alpha.c:190: P1 = 0b10111100;  // Bit 5=0 (right forward), Bit 6=1 (left reverse), Bits 1,2=0 (RED+GREEN)
	mov	_P1,#0xBC
	C$alpha.c$191$1$1 ==.
;	apps/alpha/alpha.c:191: T3CC0 = MOTOR_SPEED;
	mov	_T3CC0,#0x64
	C$alpha.c$192$1$1 ==.
;	apps/alpha/alpha.c:192: T3CC1 = MOTOR_SPEED;
	mov	_T3CC1,#0x64
	C$alpha.c$193$1$1 ==.
;	apps/alpha/alpha.c:193: delayMs(2000);
	mov	dptr,#0x07D0
	lcall	_delayMs
	C$alpha.c$196$1$1 ==.
;	apps/alpha/alpha.c:196: T3CC0 = 0;
	mov	_T3CC0,#0x00
	C$alpha.c$197$1$1 ==.
;	apps/alpha/alpha.c:197: T3CC1 = 0;
	mov	_T3CC1,#0x00
	C$alpha.c$198$1$1 ==.
;	apps/alpha/alpha.c:198: P1 = 0b01111111;  // Bit 7 = 0 (BLUE LED ON)
	mov	_P1,#0x7F
	C$alpha.c$199$1$1 ==.
;	apps/alpha/alpha.c:199: delayMs(1000);
	mov	dptr,#0x03E8
	lcall	_delayMs
	C$alpha.c$202$1$1 ==.
;	apps/alpha/alpha.c:202: P1 = 0b11011101;  // Bit 5=1 (right reverse), Bit 6=0 (left forward), Bits 1,7=0 (RED+BLUE)
	mov	_P1,#0xDD
	C$alpha.c$203$1$1 ==.
;	apps/alpha/alpha.c:203: T3CC0 = MOTOR_SPEED;
	mov	_T3CC0,#0x64
	C$alpha.c$204$1$1 ==.
;	apps/alpha/alpha.c:204: T3CC1 = MOTOR_SPEED;
	mov	_T3CC1,#0x64
	C$alpha.c$205$1$1 ==.
;	apps/alpha/alpha.c:205: delayMs(2000);
	mov	dptr,#0x07D0
	lcall	_delayMs
	C$alpha.c$208$1$1 ==.
;	apps/alpha/alpha.c:208: T3CC0 = 0;
	mov	_T3CC0,#0x00
	C$alpha.c$209$1$1 ==.
;	apps/alpha/alpha.c:209: T3CC1 = 0;
	mov	_T3CC1,#0x00
	C$alpha.c$210$1$1 ==.
;	apps/alpha/alpha.c:210: P1 = 0xFF;
	mov	_P1,#0xFF
	C$alpha.c$211$1$1 ==.
;	apps/alpha/alpha.c:211: delayMs(500);
	mov	dptr,#0x01F4
	lcall	_delayMs
	C$alpha.c$214$1$1 ==.
;	apps/alpha/alpha.c:214: lastRedLedToggle = getMs();
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
	C$alpha.c$216$1$1 ==.
;	apps/alpha/alpha.c:216: while(1)
00102$:
	C$alpha.c$218$2$7 ==.
;	apps/alpha/alpha.c:218: boardService();
	lcall	_boardService
	C$alpha.c$219$2$7 ==.
;	apps/alpha/alpha.c:219: usbComService();
	lcall	_usbComService
	C$alpha.c$220$2$7 ==.
;	apps/alpha/alpha.c:220: updateHeartbeatLed();
	lcall	_updateHeartbeatLed
	sjmp	00102$
	C$alpha.c$222$1$1 ==.
	XG$main$0$0 ==.
	ret
	.area CSEG    (CODE)
	.area CONST   (CODE)
	.area XINIT   (CODE)
	.area CABS    (ABS,CODE)
