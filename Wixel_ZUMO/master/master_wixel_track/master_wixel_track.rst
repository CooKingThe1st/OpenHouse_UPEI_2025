                              1 ;--------------------------------------------------------
                              2 ; File Created by SDCC : free open source ANSI-C Compiler
                              3 ; Version 3.1.0 #7066 (Nov 22 2011) (MINGW32)
                              4 ; This file was generated Fri Oct 24 22:20:40 2025
                              5 ;--------------------------------------------------------
                              6 	.module master_wixel_track
                              7 	.optsdcc -mmcs51 --model-medium
                              8 	
                              9 ;--------------------------------------------------------
                             10 ; Public variables in this module
                             11 ;--------------------------------------------------------
                             12 	.globl _main
                             13 	.globl _initSystems
                             14 	.globl _processBytesFromUsb
                             15 	.globl _handleSerialTimeout
                             16 	.globl _processSerialPacket
                             17 	.globl _updateLeds
                             18 	.globl _sendRadioPacket
                             19 	.globl _radioInit
                             20 	.globl _failSafeBootloader
                             21 	.globl _sprintf
                             22 	.globl _usbComTxSend
                             23 	.globl _usbComRxReceiveByte
                             24 	.globl _usbComRxAvailable
                             25 	.globl _usbComService
                             26 	.globl _usbInit
                             27 	.globl _radioRegistersInit
                             28 	.globl _delayMs
                             29 	.globl _getMs
                             30 	.globl _boardService
                             31 	.globl _systemInit
                             32 	.globl _theta
                             33 	.globl _posY
                             34 	.globl _posX
                             35 	.globl _fsi
                             36 	.globl _responseLength
                             37 	.globl _radioTxPulseStart
                             38 	.globl _serialRxPulseStart
                             39 	.globl _lastHeartbeatTime
                             40 	.globl _lastRadioTxTime
                             41 	.globl _lastSerialRxTime
                             42 	.globl _slaveAddresses
                             43 	.globl _serialBufferIndex
                             44 	.globl _radioTxPulseActive
                             45 	.globl _serialRxPulseActive
                             46 ;--------------------------------------------------------
                             47 ; special function registers
                             48 ;--------------------------------------------------------
                             49 	.area RSEG    (ABS,DATA)
   0000                      50 	.org 0x0000
                    0080     51 Fmaster_wixel_track$P0$0$0 == 0x0080
                    0080     52 _P0	=	0x0080
                    0081     53 Fmaster_wixel_track$SP$0$0 == 0x0081
                    0081     54 _SP	=	0x0081
                    0082     55 Fmaster_wixel_track$DPL0$0$0 == 0x0082
                    0082     56 _DPL0	=	0x0082
                    0083     57 Fmaster_wixel_track$DPH0$0$0 == 0x0083
                    0083     58 _DPH0	=	0x0083
                    0084     59 Fmaster_wixel_track$DPL1$0$0 == 0x0084
                    0084     60 _DPL1	=	0x0084
                    0085     61 Fmaster_wixel_track$DPH1$0$0 == 0x0085
                    0085     62 _DPH1	=	0x0085
                    0086     63 Fmaster_wixel_track$U0CSR$0$0 == 0x0086
                    0086     64 _U0CSR	=	0x0086
                    0087     65 Fmaster_wixel_track$PCON$0$0 == 0x0087
                    0087     66 _PCON	=	0x0087
                    0088     67 Fmaster_wixel_track$TCON$0$0 == 0x0088
                    0088     68 _TCON	=	0x0088
                    0089     69 Fmaster_wixel_track$P0IFG$0$0 == 0x0089
                    0089     70 _P0IFG	=	0x0089
                    008A     71 Fmaster_wixel_track$P1IFG$0$0 == 0x008a
                    008A     72 _P1IFG	=	0x008a
                    008B     73 Fmaster_wixel_track$P2IFG$0$0 == 0x008b
                    008B     74 _P2IFG	=	0x008b
                    008C     75 Fmaster_wixel_track$PICTL$0$0 == 0x008c
                    008C     76 _PICTL	=	0x008c
                    008D     77 Fmaster_wixel_track$P1IEN$0$0 == 0x008d
                    008D     78 _P1IEN	=	0x008d
                    008F     79 Fmaster_wixel_track$P0INP$0$0 == 0x008f
                    008F     80 _P0INP	=	0x008f
                    0090     81 Fmaster_wixel_track$P1$0$0 == 0x0090
                    0090     82 _P1	=	0x0090
                    0091     83 Fmaster_wixel_track$RFIM$0$0 == 0x0091
                    0091     84 _RFIM	=	0x0091
                    0092     85 Fmaster_wixel_track$DPS$0$0 == 0x0092
                    0092     86 _DPS	=	0x0092
                    0093     87 Fmaster_wixel_track$MPAGE$0$0 == 0x0093
                    0093     88 _MPAGE	=	0x0093
                    0095     89 Fmaster_wixel_track$ENDIAN$0$0 == 0x0095
                    0095     90 _ENDIAN	=	0x0095
                    0098     91 Fmaster_wixel_track$S0CON$0$0 == 0x0098
                    0098     92 _S0CON	=	0x0098
                    009A     93 Fmaster_wixel_track$IEN2$0$0 == 0x009a
                    009A     94 _IEN2	=	0x009a
                    009B     95 Fmaster_wixel_track$S1CON$0$0 == 0x009b
                    009B     96 _S1CON	=	0x009b
                    009C     97 Fmaster_wixel_track$T2CT$0$0 == 0x009c
                    009C     98 _T2CT	=	0x009c
                    009D     99 Fmaster_wixel_track$T2PR$0$0 == 0x009d
                    009D    100 _T2PR	=	0x009d
                    009E    101 Fmaster_wixel_track$T2CTL$0$0 == 0x009e
                    009E    102 _T2CTL	=	0x009e
                    00A0    103 Fmaster_wixel_track$P2$0$0 == 0x00a0
                    00A0    104 _P2	=	0x00a0
                    00A1    105 Fmaster_wixel_track$WORIRQ$0$0 == 0x00a1
                    00A1    106 _WORIRQ	=	0x00a1
                    00A2    107 Fmaster_wixel_track$WORCTRL$0$0 == 0x00a2
                    00A2    108 _WORCTRL	=	0x00a2
                    00A3    109 Fmaster_wixel_track$WOREVT0$0$0 == 0x00a3
                    00A3    110 _WOREVT0	=	0x00a3
                    00A4    111 Fmaster_wixel_track$WOREVT1$0$0 == 0x00a4
                    00A4    112 _WOREVT1	=	0x00a4
                    00A5    113 Fmaster_wixel_track$WORTIME0$0$0 == 0x00a5
                    00A5    114 _WORTIME0	=	0x00a5
                    00A6    115 Fmaster_wixel_track$WORTIME1$0$0 == 0x00a6
                    00A6    116 _WORTIME1	=	0x00a6
                    00A8    117 Fmaster_wixel_track$IEN0$0$0 == 0x00a8
                    00A8    118 _IEN0	=	0x00a8
                    00A9    119 Fmaster_wixel_track$IP0$0$0 == 0x00a9
                    00A9    120 _IP0	=	0x00a9
                    00AB    121 Fmaster_wixel_track$FWT$0$0 == 0x00ab
                    00AB    122 _FWT	=	0x00ab
                    00AC    123 Fmaster_wixel_track$FADDRL$0$0 == 0x00ac
                    00AC    124 _FADDRL	=	0x00ac
                    00AD    125 Fmaster_wixel_track$FADDRH$0$0 == 0x00ad
                    00AD    126 _FADDRH	=	0x00ad
                    00AE    127 Fmaster_wixel_track$FCTL$0$0 == 0x00ae
                    00AE    128 _FCTL	=	0x00ae
                    00AF    129 Fmaster_wixel_track$FWDATA$0$0 == 0x00af
                    00AF    130 _FWDATA	=	0x00af
                    00B1    131 Fmaster_wixel_track$ENCDI$0$0 == 0x00b1
                    00B1    132 _ENCDI	=	0x00b1
                    00B2    133 Fmaster_wixel_track$ENCDO$0$0 == 0x00b2
                    00B2    134 _ENCDO	=	0x00b2
                    00B3    135 Fmaster_wixel_track$ENCCS$0$0 == 0x00b3
                    00B3    136 _ENCCS	=	0x00b3
                    00B4    137 Fmaster_wixel_track$ADCCON1$0$0 == 0x00b4
                    00B4    138 _ADCCON1	=	0x00b4
                    00B5    139 Fmaster_wixel_track$ADCCON2$0$0 == 0x00b5
                    00B5    140 _ADCCON2	=	0x00b5
                    00B6    141 Fmaster_wixel_track$ADCCON3$0$0 == 0x00b6
                    00B6    142 _ADCCON3	=	0x00b6
                    00B8    143 Fmaster_wixel_track$IEN1$0$0 == 0x00b8
                    00B8    144 _IEN1	=	0x00b8
                    00B9    145 Fmaster_wixel_track$IP1$0$0 == 0x00b9
                    00B9    146 _IP1	=	0x00b9
                    00BA    147 Fmaster_wixel_track$ADCL$0$0 == 0x00ba
                    00BA    148 _ADCL	=	0x00ba
                    00BB    149 Fmaster_wixel_track$ADCH$0$0 == 0x00bb
                    00BB    150 _ADCH	=	0x00bb
                    00BC    151 Fmaster_wixel_track$RNDL$0$0 == 0x00bc
                    00BC    152 _RNDL	=	0x00bc
                    00BD    153 Fmaster_wixel_track$RNDH$0$0 == 0x00bd
                    00BD    154 _RNDH	=	0x00bd
                    00BE    155 Fmaster_wixel_track$SLEEP$0$0 == 0x00be
                    00BE    156 _SLEEP	=	0x00be
                    00C0    157 Fmaster_wixel_track$IRCON$0$0 == 0x00c0
                    00C0    158 _IRCON	=	0x00c0
                    00C1    159 Fmaster_wixel_track$U0DBUF$0$0 == 0x00c1
                    00C1    160 _U0DBUF	=	0x00c1
                    00C2    161 Fmaster_wixel_track$U0BAUD$0$0 == 0x00c2
                    00C2    162 _U0BAUD	=	0x00c2
                    00C4    163 Fmaster_wixel_track$U0UCR$0$0 == 0x00c4
                    00C4    164 _U0UCR	=	0x00c4
                    00C5    165 Fmaster_wixel_track$U0GCR$0$0 == 0x00c5
                    00C5    166 _U0GCR	=	0x00c5
                    00C6    167 Fmaster_wixel_track$CLKCON$0$0 == 0x00c6
                    00C6    168 _CLKCON	=	0x00c6
                    00C7    169 Fmaster_wixel_track$MEMCTR$0$0 == 0x00c7
                    00C7    170 _MEMCTR	=	0x00c7
                    00C9    171 Fmaster_wixel_track$WDCTL$0$0 == 0x00c9
                    00C9    172 _WDCTL	=	0x00c9
                    00CA    173 Fmaster_wixel_track$T3CNT$0$0 == 0x00ca
                    00CA    174 _T3CNT	=	0x00ca
                    00CB    175 Fmaster_wixel_track$T3CTL$0$0 == 0x00cb
                    00CB    176 _T3CTL	=	0x00cb
                    00CC    177 Fmaster_wixel_track$T3CCTL0$0$0 == 0x00cc
                    00CC    178 _T3CCTL0	=	0x00cc
                    00CD    179 Fmaster_wixel_track$T3CC0$0$0 == 0x00cd
                    00CD    180 _T3CC0	=	0x00cd
                    00CE    181 Fmaster_wixel_track$T3CCTL1$0$0 == 0x00ce
                    00CE    182 _T3CCTL1	=	0x00ce
                    00CF    183 Fmaster_wixel_track$T3CC1$0$0 == 0x00cf
                    00CF    184 _T3CC1	=	0x00cf
                    00D0    185 Fmaster_wixel_track$PSW$0$0 == 0x00d0
                    00D0    186 _PSW	=	0x00d0
                    00D1    187 Fmaster_wixel_track$DMAIRQ$0$0 == 0x00d1
                    00D1    188 _DMAIRQ	=	0x00d1
                    00D2    189 Fmaster_wixel_track$DMA1CFGL$0$0 == 0x00d2
                    00D2    190 _DMA1CFGL	=	0x00d2
                    00D3    191 Fmaster_wixel_track$DMA1CFGH$0$0 == 0x00d3
                    00D3    192 _DMA1CFGH	=	0x00d3
                    00D4    193 Fmaster_wixel_track$DMA0CFGL$0$0 == 0x00d4
                    00D4    194 _DMA0CFGL	=	0x00d4
                    00D5    195 Fmaster_wixel_track$DMA0CFGH$0$0 == 0x00d5
                    00D5    196 _DMA0CFGH	=	0x00d5
                    00D6    197 Fmaster_wixel_track$DMAARM$0$0 == 0x00d6
                    00D6    198 _DMAARM	=	0x00d6
                    00D7    199 Fmaster_wixel_track$DMAREQ$0$0 == 0x00d7
                    00D7    200 _DMAREQ	=	0x00d7
                    00D8    201 Fmaster_wixel_track$TIMIF$0$0 == 0x00d8
                    00D8    202 _TIMIF	=	0x00d8
                    00D9    203 Fmaster_wixel_track$RFD$0$0 == 0x00d9
                    00D9    204 _RFD	=	0x00d9
                    00DA    205 Fmaster_wixel_track$T1CC0L$0$0 == 0x00da
                    00DA    206 _T1CC0L	=	0x00da
                    00DB    207 Fmaster_wixel_track$T1CC0H$0$0 == 0x00db
                    00DB    208 _T1CC0H	=	0x00db
                    00DC    209 Fmaster_wixel_track$T1CC1L$0$0 == 0x00dc
                    00DC    210 _T1CC1L	=	0x00dc
                    00DD    211 Fmaster_wixel_track$T1CC1H$0$0 == 0x00dd
                    00DD    212 _T1CC1H	=	0x00dd
                    00DE    213 Fmaster_wixel_track$T1CC2L$0$0 == 0x00de
                    00DE    214 _T1CC2L	=	0x00de
                    00DF    215 Fmaster_wixel_track$T1CC2H$0$0 == 0x00df
                    00DF    216 _T1CC2H	=	0x00df
                    00E0    217 Fmaster_wixel_track$ACC$0$0 == 0x00e0
                    00E0    218 _ACC	=	0x00e0
                    00E1    219 Fmaster_wixel_track$RFST$0$0 == 0x00e1
                    00E1    220 _RFST	=	0x00e1
                    00E2    221 Fmaster_wixel_track$T1CNTL$0$0 == 0x00e2
                    00E2    222 _T1CNTL	=	0x00e2
                    00E3    223 Fmaster_wixel_track$T1CNTH$0$0 == 0x00e3
                    00E3    224 _T1CNTH	=	0x00e3
                    00E4    225 Fmaster_wixel_track$T1CTL$0$0 == 0x00e4
                    00E4    226 _T1CTL	=	0x00e4
                    00E5    227 Fmaster_wixel_track$T1CCTL0$0$0 == 0x00e5
                    00E5    228 _T1CCTL0	=	0x00e5
                    00E6    229 Fmaster_wixel_track$T1CCTL1$0$0 == 0x00e6
                    00E6    230 _T1CCTL1	=	0x00e6
                    00E7    231 Fmaster_wixel_track$T1CCTL2$0$0 == 0x00e7
                    00E7    232 _T1CCTL2	=	0x00e7
                    00E8    233 Fmaster_wixel_track$IRCON2$0$0 == 0x00e8
                    00E8    234 _IRCON2	=	0x00e8
                    00E9    235 Fmaster_wixel_track$RFIF$0$0 == 0x00e9
                    00E9    236 _RFIF	=	0x00e9
                    00EA    237 Fmaster_wixel_track$T4CNT$0$0 == 0x00ea
                    00EA    238 _T4CNT	=	0x00ea
                    00EB    239 Fmaster_wixel_track$T4CTL$0$0 == 0x00eb
                    00EB    240 _T4CTL	=	0x00eb
                    00EC    241 Fmaster_wixel_track$T4CCTL0$0$0 == 0x00ec
                    00EC    242 _T4CCTL0	=	0x00ec
                    00ED    243 Fmaster_wixel_track$T4CC0$0$0 == 0x00ed
                    00ED    244 _T4CC0	=	0x00ed
                    00EE    245 Fmaster_wixel_track$T4CCTL1$0$0 == 0x00ee
                    00EE    246 _T4CCTL1	=	0x00ee
                    00EF    247 Fmaster_wixel_track$T4CC1$0$0 == 0x00ef
                    00EF    248 _T4CC1	=	0x00ef
                    00F0    249 Fmaster_wixel_track$B$0$0 == 0x00f0
                    00F0    250 _B	=	0x00f0
                    00F1    251 Fmaster_wixel_track$PERCFG$0$0 == 0x00f1
                    00F1    252 _PERCFG	=	0x00f1
                    00F2    253 Fmaster_wixel_track$ADCCFG$0$0 == 0x00f2
                    00F2    254 _ADCCFG	=	0x00f2
                    00F3    255 Fmaster_wixel_track$P0SEL$0$0 == 0x00f3
                    00F3    256 _P0SEL	=	0x00f3
                    00F4    257 Fmaster_wixel_track$P1SEL$0$0 == 0x00f4
                    00F4    258 _P1SEL	=	0x00f4
                    00F5    259 Fmaster_wixel_track$P2SEL$0$0 == 0x00f5
                    00F5    260 _P2SEL	=	0x00f5
                    00F6    261 Fmaster_wixel_track$P1INP$0$0 == 0x00f6
                    00F6    262 _P1INP	=	0x00f6
                    00F7    263 Fmaster_wixel_track$P2INP$0$0 == 0x00f7
                    00F7    264 _P2INP	=	0x00f7
                    00F8    265 Fmaster_wixel_track$U1CSR$0$0 == 0x00f8
                    00F8    266 _U1CSR	=	0x00f8
                    00F9    267 Fmaster_wixel_track$U1DBUF$0$0 == 0x00f9
                    00F9    268 _U1DBUF	=	0x00f9
                    00FA    269 Fmaster_wixel_track$U1BAUD$0$0 == 0x00fa
                    00FA    270 _U1BAUD	=	0x00fa
                    00FB    271 Fmaster_wixel_track$U1UCR$0$0 == 0x00fb
                    00FB    272 _U1UCR	=	0x00fb
                    00FC    273 Fmaster_wixel_track$U1GCR$0$0 == 0x00fc
                    00FC    274 _U1GCR	=	0x00fc
                    00FD    275 Fmaster_wixel_track$P0DIR$0$0 == 0x00fd
                    00FD    276 _P0DIR	=	0x00fd
                    00FE    277 Fmaster_wixel_track$P1DIR$0$0 == 0x00fe
                    00FE    278 _P1DIR	=	0x00fe
                    00FF    279 Fmaster_wixel_track$P2DIR$0$0 == 0x00ff
                    00FF    280 _P2DIR	=	0x00ff
                    FFFFD5D4    281 Fmaster_wixel_track$DMA0CFG$0$0 == 0xffffd5d4
                    FFFFD5D4    282 _DMA0CFG	=	0xffffd5d4
                    FFFFD3D2    283 Fmaster_wixel_track$DMA1CFG$0$0 == 0xffffd3d2
                    FFFFD3D2    284 _DMA1CFG	=	0xffffd3d2
                    FFFFADAC    285 Fmaster_wixel_track$FADDR$0$0 == 0xffffadac
                    FFFFADAC    286 _FADDR	=	0xffffadac
                    FFFFBBBA    287 Fmaster_wixel_track$ADC$0$0 == 0xffffbbba
                    FFFFBBBA    288 _ADC	=	0xffffbbba
                    FFFFDBDA    289 Fmaster_wixel_track$T1CC0$0$0 == 0xffffdbda
                    FFFFDBDA    290 _T1CC0	=	0xffffdbda
                    FFFFDDDC    291 Fmaster_wixel_track$T1CC1$0$0 == 0xffffdddc
                    FFFFDDDC    292 _T1CC1	=	0xffffdddc
                    FFFFDFDE    293 Fmaster_wixel_track$T1CC2$0$0 == 0xffffdfde
                    FFFFDFDE    294 _T1CC2	=	0xffffdfde
                            295 ;--------------------------------------------------------
                            296 ; special function bits
                            297 ;--------------------------------------------------------
                            298 	.area RSEG    (ABS,DATA)
   0000                     299 	.org 0x0000
                    0080    300 Fmaster_wixel_track$P0_0$0$0 == 0x0080
                    0080    301 _P0_0	=	0x0080
                    0081    302 Fmaster_wixel_track$P0_1$0$0 == 0x0081
                    0081    303 _P0_1	=	0x0081
                    0082    304 Fmaster_wixel_track$P0_2$0$0 == 0x0082
                    0082    305 _P0_2	=	0x0082
                    0083    306 Fmaster_wixel_track$P0_3$0$0 == 0x0083
                    0083    307 _P0_3	=	0x0083
                    0084    308 Fmaster_wixel_track$P0_4$0$0 == 0x0084
                    0084    309 _P0_4	=	0x0084
                    0085    310 Fmaster_wixel_track$P0_5$0$0 == 0x0085
                    0085    311 _P0_5	=	0x0085
                    0086    312 Fmaster_wixel_track$P0_6$0$0 == 0x0086
                    0086    313 _P0_6	=	0x0086
                    0087    314 Fmaster_wixel_track$P0_7$0$0 == 0x0087
                    0087    315 _P0_7	=	0x0087
                    0088    316 Fmaster_wixel_track$_TCON_0$0$0 == 0x0088
                    0088    317 __TCON_0	=	0x0088
                    0089    318 Fmaster_wixel_track$RFTXRXIF$0$0 == 0x0089
                    0089    319 _RFTXRXIF	=	0x0089
                    008A    320 Fmaster_wixel_track$_TCON_2$0$0 == 0x008a
                    008A    321 __TCON_2	=	0x008a
                    008B    322 Fmaster_wixel_track$URX0IF$0$0 == 0x008b
                    008B    323 _URX0IF	=	0x008b
                    008C    324 Fmaster_wixel_track$_TCON_4$0$0 == 0x008c
                    008C    325 __TCON_4	=	0x008c
                    008D    326 Fmaster_wixel_track$ADCIF$0$0 == 0x008d
                    008D    327 _ADCIF	=	0x008d
                    008E    328 Fmaster_wixel_track$_TCON_6$0$0 == 0x008e
                    008E    329 __TCON_6	=	0x008e
                    008F    330 Fmaster_wixel_track$URX1IF$0$0 == 0x008f
                    008F    331 _URX1IF	=	0x008f
                    0090    332 Fmaster_wixel_track$P1_0$0$0 == 0x0090
                    0090    333 _P1_0	=	0x0090
                    0091    334 Fmaster_wixel_track$P1_1$0$0 == 0x0091
                    0091    335 _P1_1	=	0x0091
                    0092    336 Fmaster_wixel_track$P1_2$0$0 == 0x0092
                    0092    337 _P1_2	=	0x0092
                    0093    338 Fmaster_wixel_track$P1_3$0$0 == 0x0093
                    0093    339 _P1_3	=	0x0093
                    0094    340 Fmaster_wixel_track$P1_4$0$0 == 0x0094
                    0094    341 _P1_4	=	0x0094
                    0095    342 Fmaster_wixel_track$P1_5$0$0 == 0x0095
                    0095    343 _P1_5	=	0x0095
                    0096    344 Fmaster_wixel_track$P1_6$0$0 == 0x0096
                    0096    345 _P1_6	=	0x0096
                    0097    346 Fmaster_wixel_track$P1_7$0$0 == 0x0097
                    0097    347 _P1_7	=	0x0097
                    0098    348 Fmaster_wixel_track$ENCIF_0$0$0 == 0x0098
                    0098    349 _ENCIF_0	=	0x0098
                    0099    350 Fmaster_wixel_track$ENCIF_1$0$0 == 0x0099
                    0099    351 _ENCIF_1	=	0x0099
                    009A    352 Fmaster_wixel_track$_SOCON2$0$0 == 0x009a
                    009A    353 __SOCON2	=	0x009a
                    009B    354 Fmaster_wixel_track$_SOCON3$0$0 == 0x009b
                    009B    355 __SOCON3	=	0x009b
                    009C    356 Fmaster_wixel_track$_SOCON4$0$0 == 0x009c
                    009C    357 __SOCON4	=	0x009c
                    009D    358 Fmaster_wixel_track$_SOCON5$0$0 == 0x009d
                    009D    359 __SOCON5	=	0x009d
                    009E    360 Fmaster_wixel_track$_SOCON6$0$0 == 0x009e
                    009E    361 __SOCON6	=	0x009e
                    009F    362 Fmaster_wixel_track$_SOCON7$0$0 == 0x009f
                    009F    363 __SOCON7	=	0x009f
                    00A0    364 Fmaster_wixel_track$P2_0$0$0 == 0x00a0
                    00A0    365 _P2_0	=	0x00a0
                    00A1    366 Fmaster_wixel_track$P2_1$0$0 == 0x00a1
                    00A1    367 _P2_1	=	0x00a1
                    00A2    368 Fmaster_wixel_track$P2_2$0$0 == 0x00a2
                    00A2    369 _P2_2	=	0x00a2
                    00A3    370 Fmaster_wixel_track$P2_3$0$0 == 0x00a3
                    00A3    371 _P2_3	=	0x00a3
                    00A4    372 Fmaster_wixel_track$P2_4$0$0 == 0x00a4
                    00A4    373 _P2_4	=	0x00a4
                    00A5    374 Fmaster_wixel_track$P2_5$0$0 == 0x00a5
                    00A5    375 _P2_5	=	0x00a5
                    00A6    376 Fmaster_wixel_track$P2_6$0$0 == 0x00a6
                    00A6    377 _P2_6	=	0x00a6
                    00A7    378 Fmaster_wixel_track$P2_7$0$0 == 0x00a7
                    00A7    379 _P2_7	=	0x00a7
                    00A8    380 Fmaster_wixel_track$RFTXRXIE$0$0 == 0x00a8
                    00A8    381 _RFTXRXIE	=	0x00a8
                    00A9    382 Fmaster_wixel_track$ADCIE$0$0 == 0x00a9
                    00A9    383 _ADCIE	=	0x00a9
                    00AA    384 Fmaster_wixel_track$URX0IE$0$0 == 0x00aa
                    00AA    385 _URX0IE	=	0x00aa
                    00AB    386 Fmaster_wixel_track$URX1IE$0$0 == 0x00ab
                    00AB    387 _URX1IE	=	0x00ab
                    00AC    388 Fmaster_wixel_track$ENCIE$0$0 == 0x00ac
                    00AC    389 _ENCIE	=	0x00ac
                    00AD    390 Fmaster_wixel_track$STIE$0$0 == 0x00ad
                    00AD    391 _STIE	=	0x00ad
                    00AE    392 Fmaster_wixel_track$_IEN06$0$0 == 0x00ae
                    00AE    393 __IEN06	=	0x00ae
                    00AF    394 Fmaster_wixel_track$EA$0$0 == 0x00af
                    00AF    395 _EA	=	0x00af
                    00B8    396 Fmaster_wixel_track$DMAIE$0$0 == 0x00b8
                    00B8    397 _DMAIE	=	0x00b8
                    00B9    398 Fmaster_wixel_track$T1IE$0$0 == 0x00b9
                    00B9    399 _T1IE	=	0x00b9
                    00BA    400 Fmaster_wixel_track$T2IE$0$0 == 0x00ba
                    00BA    401 _T2IE	=	0x00ba
                    00BB    402 Fmaster_wixel_track$T3IE$0$0 == 0x00bb
                    00BB    403 _T3IE	=	0x00bb
                    00BC    404 Fmaster_wixel_track$T4IE$0$0 == 0x00bc
                    00BC    405 _T4IE	=	0x00bc
                    00BD    406 Fmaster_wixel_track$P0IE$0$0 == 0x00bd
                    00BD    407 _P0IE	=	0x00bd
                    00BE    408 Fmaster_wixel_track$_IEN16$0$0 == 0x00be
                    00BE    409 __IEN16	=	0x00be
                    00BF    410 Fmaster_wixel_track$_IEN17$0$0 == 0x00bf
                    00BF    411 __IEN17	=	0x00bf
                    00C0    412 Fmaster_wixel_track$DMAIF$0$0 == 0x00c0
                    00C0    413 _DMAIF	=	0x00c0
                    00C1    414 Fmaster_wixel_track$T1IF$0$0 == 0x00c1
                    00C1    415 _T1IF	=	0x00c1
                    00C2    416 Fmaster_wixel_track$T2IF$0$0 == 0x00c2
                    00C2    417 _T2IF	=	0x00c2
                    00C3    418 Fmaster_wixel_track$T3IF$0$0 == 0x00c3
                    00C3    419 _T3IF	=	0x00c3
                    00C4    420 Fmaster_wixel_track$T4IF$0$0 == 0x00c4
                    00C4    421 _T4IF	=	0x00c4
                    00C5    422 Fmaster_wixel_track$P0IF$0$0 == 0x00c5
                    00C5    423 _P0IF	=	0x00c5
                    00C6    424 Fmaster_wixel_track$_IRCON6$0$0 == 0x00c6
                    00C6    425 __IRCON6	=	0x00c6
                    00C7    426 Fmaster_wixel_track$STIF$0$0 == 0x00c7
                    00C7    427 _STIF	=	0x00c7
                    00D0    428 Fmaster_wixel_track$P$0$0 == 0x00d0
                    00D0    429 _P	=	0x00d0
                    00D1    430 Fmaster_wixel_track$F1$0$0 == 0x00d1
                    00D1    431 _F1	=	0x00d1
                    00D2    432 Fmaster_wixel_track$OV$0$0 == 0x00d2
                    00D2    433 _OV	=	0x00d2
                    00D3    434 Fmaster_wixel_track$RS0$0$0 == 0x00d3
                    00D3    435 _RS0	=	0x00d3
                    00D4    436 Fmaster_wixel_track$RS1$0$0 == 0x00d4
                    00D4    437 _RS1	=	0x00d4
                    00D5    438 Fmaster_wixel_track$F0$0$0 == 0x00d5
                    00D5    439 _F0	=	0x00d5
                    00D6    440 Fmaster_wixel_track$AC$0$0 == 0x00d6
                    00D6    441 _AC	=	0x00d6
                    00D7    442 Fmaster_wixel_track$CY$0$0 == 0x00d7
                    00D7    443 _CY	=	0x00d7
                    00D8    444 Fmaster_wixel_track$T3OVFIF$0$0 == 0x00d8
                    00D8    445 _T3OVFIF	=	0x00d8
                    00D9    446 Fmaster_wixel_track$T3CH0IF$0$0 == 0x00d9
                    00D9    447 _T3CH0IF	=	0x00d9
                    00DA    448 Fmaster_wixel_track$T3CH1IF$0$0 == 0x00da
                    00DA    449 _T3CH1IF	=	0x00da
                    00DB    450 Fmaster_wixel_track$T4OVFIF$0$0 == 0x00db
                    00DB    451 _T4OVFIF	=	0x00db
                    00DC    452 Fmaster_wixel_track$T4CH0IF$0$0 == 0x00dc
                    00DC    453 _T4CH0IF	=	0x00dc
                    00DD    454 Fmaster_wixel_track$T4CH1IF$0$0 == 0x00dd
                    00DD    455 _T4CH1IF	=	0x00dd
                    00DE    456 Fmaster_wixel_track$OVFIM$0$0 == 0x00de
                    00DE    457 _OVFIM	=	0x00de
                    00DF    458 Fmaster_wixel_track$_TIMIF7$0$0 == 0x00df
                    00DF    459 __TIMIF7	=	0x00df
                    00E0    460 Fmaster_wixel_track$ACC_0$0$0 == 0x00e0
                    00E0    461 _ACC_0	=	0x00e0
                    00E1    462 Fmaster_wixel_track$ACC_1$0$0 == 0x00e1
                    00E1    463 _ACC_1	=	0x00e1
                    00E2    464 Fmaster_wixel_track$ACC_2$0$0 == 0x00e2
                    00E2    465 _ACC_2	=	0x00e2
                    00E3    466 Fmaster_wixel_track$ACC_3$0$0 == 0x00e3
                    00E3    467 _ACC_3	=	0x00e3
                    00E4    468 Fmaster_wixel_track$ACC_4$0$0 == 0x00e4
                    00E4    469 _ACC_4	=	0x00e4
                    00E5    470 Fmaster_wixel_track$ACC_5$0$0 == 0x00e5
                    00E5    471 _ACC_5	=	0x00e5
                    00E6    472 Fmaster_wixel_track$ACC_6$0$0 == 0x00e6
                    00E6    473 _ACC_6	=	0x00e6
                    00E7    474 Fmaster_wixel_track$ACC_7$0$0 == 0x00e7
                    00E7    475 _ACC_7	=	0x00e7
                    00E8    476 Fmaster_wixel_track$P2IF$0$0 == 0x00e8
                    00E8    477 _P2IF	=	0x00e8
                    00E9    478 Fmaster_wixel_track$UTX0IF$0$0 == 0x00e9
                    00E9    479 _UTX0IF	=	0x00e9
                    00EA    480 Fmaster_wixel_track$UTX1IF$0$0 == 0x00ea
                    00EA    481 _UTX1IF	=	0x00ea
                    00EB    482 Fmaster_wixel_track$P1IF$0$0 == 0x00eb
                    00EB    483 _P1IF	=	0x00eb
                    00EC    484 Fmaster_wixel_track$WDTIF$0$0 == 0x00ec
                    00EC    485 _WDTIF	=	0x00ec
                    00ED    486 Fmaster_wixel_track$_IRCON25$0$0 == 0x00ed
                    00ED    487 __IRCON25	=	0x00ed
                    00EE    488 Fmaster_wixel_track$_IRCON26$0$0 == 0x00ee
                    00EE    489 __IRCON26	=	0x00ee
                    00EF    490 Fmaster_wixel_track$_IRCON27$0$0 == 0x00ef
                    00EF    491 __IRCON27	=	0x00ef
                    00F0    492 Fmaster_wixel_track$B_0$0$0 == 0x00f0
                    00F0    493 _B_0	=	0x00f0
                    00F1    494 Fmaster_wixel_track$B_1$0$0 == 0x00f1
                    00F1    495 _B_1	=	0x00f1
                    00F2    496 Fmaster_wixel_track$B_2$0$0 == 0x00f2
                    00F2    497 _B_2	=	0x00f2
                    00F3    498 Fmaster_wixel_track$B_3$0$0 == 0x00f3
                    00F3    499 _B_3	=	0x00f3
                    00F4    500 Fmaster_wixel_track$B_4$0$0 == 0x00f4
                    00F4    501 _B_4	=	0x00f4
                    00F5    502 Fmaster_wixel_track$B_5$0$0 == 0x00f5
                    00F5    503 _B_5	=	0x00f5
                    00F6    504 Fmaster_wixel_track$B_6$0$0 == 0x00f6
                    00F6    505 _B_6	=	0x00f6
                    00F7    506 Fmaster_wixel_track$B_7$0$0 == 0x00f7
                    00F7    507 _B_7	=	0x00f7
                    00F8    508 Fmaster_wixel_track$U1ACTIVE$0$0 == 0x00f8
                    00F8    509 _U1ACTIVE	=	0x00f8
                    00F9    510 Fmaster_wixel_track$U1TX_BYTE$0$0 == 0x00f9
                    00F9    511 _U1TX_BYTE	=	0x00f9
                    00FA    512 Fmaster_wixel_track$U1RX_BYTE$0$0 == 0x00fa
                    00FA    513 _U1RX_BYTE	=	0x00fa
                    00FB    514 Fmaster_wixel_track$U1ERR$0$0 == 0x00fb
                    00FB    515 _U1ERR	=	0x00fb
                    00FC    516 Fmaster_wixel_track$U1FE$0$0 == 0x00fc
                    00FC    517 _U1FE	=	0x00fc
                    00FD    518 Fmaster_wixel_track$U1SLAVE$0$0 == 0x00fd
                    00FD    519 _U1SLAVE	=	0x00fd
                    00FE    520 Fmaster_wixel_track$U1RE$0$0 == 0x00fe
                    00FE    521 _U1RE	=	0x00fe
                    00FF    522 Fmaster_wixel_track$U1MODE$0$0 == 0x00ff
                    00FF    523 _U1MODE	=	0x00ff
                            524 ;--------------------------------------------------------
                            525 ; overlayable register banks
                            526 ;--------------------------------------------------------
                            527 	.area REG_BANK_0	(REL,OVR,DATA)
   0000                     528 	.ds 8
                            529 ;--------------------------------------------------------
                            530 ; internal ram data
                            531 ;--------------------------------------------------------
                            532 	.area DSEG    (DATA)
                    0000    533 Lmaster_wixel_track.updateLeds$sloc0$1$0==.
   0008                     534 _updateLeds_sloc0_1_0:
   0008                     535 	.ds 4
                            536 ;--------------------------------------------------------
                            537 ; overlayable items in internal ram 
                            538 ;--------------------------------------------------------
                            539 	.area OSEG    (OVR,DATA)
                            540 ;--------------------------------------------------------
                            541 ; Stack segment in internal ram 
                            542 ;--------------------------------------------------------
                            543 	.area	SSEG	(DATA)
   0023                     544 __start__stack:
   0023                     545 	.ds	1
                            546 
                            547 ;--------------------------------------------------------
                            548 ; indirectly addressable internal ram data
                            549 ;--------------------------------------------------------
                            550 	.area ISEG    (DATA)
                            551 ;--------------------------------------------------------
                            552 ; absolute internal ram data
                            553 ;--------------------------------------------------------
                            554 	.area IABS    (ABS,DATA)
                            555 	.area IABS    (ABS,DATA)
                            556 ;--------------------------------------------------------
                            557 ; bit data
                            558 ;--------------------------------------------------------
                            559 	.area BSEG    (BIT)
                    0000    560 G$serialRxPulseActive$0$0==.
   0000                     561 _serialRxPulseActive::
   0000                     562 	.ds 1
                    0001    563 G$radioTxPulseActive$0$0==.
   0001                     564 _radioTxPulseActive::
   0001                     565 	.ds 1
                            566 ;--------------------------------------------------------
                            567 ; paged external ram data
                            568 ;--------------------------------------------------------
                            569 	.area PSEG    (PAG,XDATA)
                    0000    570 G$serialBufferIndex$0$0==.
   F000                     571 _serialBufferIndex::
   F000                     572 	.ds 1
                    0001    573 G$slaveAddresses$0$0==.
   F001                     574 _slaveAddresses::
   F001                     575 	.ds 4
                    0005    576 G$lastSerialRxTime$0$0==.
   F005                     577 _lastSerialRxTime::
   F005                     578 	.ds 4
                    0009    579 G$lastRadioTxTime$0$0==.
   F009                     580 _lastRadioTxTime::
   F009                     581 	.ds 4
                    000D    582 G$lastHeartbeatTime$0$0==.
   F00D                     583 _lastHeartbeatTime::
   F00D                     584 	.ds 4
                    0011    585 G$serialRxPulseStart$0$0==.
   F011                     586 _serialRxPulseStart::
   F011                     587 	.ds 2
                    0013    588 G$radioTxPulseStart$0$0==.
   F013                     589 _radioTxPulseStart::
   F013                     590 	.ds 2
                    0015    591 G$responseLength$0$0==.
   F015                     592 _responseLength::
   F015                     593 	.ds 1
                    0016    594 G$fsi$0$0==.
   F016                     595 _fsi::
   F016                     596 	.ds 1
                    0017    597 G$posX$0$0==.
   F017                     598 _posX::
   F017                     599 	.ds 2
                    0019    600 G$posY$0$0==.
   F019                     601 _posY::
   F019                     602 	.ds 2
                    001B    603 G$theta$0$0==.
   F01B                     604 _theta::
   F01B                     605 	.ds 1
                    001C    606 Lmaster_wixel_track.processSerialPacket$data3$1$1==.
   F01C                     607 _processSerialPacket_data3_1_1:
   F01C                     608 	.ds 2
                    001E    609 Lmaster_wixel_track.processSerialPacket$data4$1$1==.
   F01E                     610 _processSerialPacket_data4_1_1:
   F01E                     611 	.ds 2
                    0020    612 Lmaster_wixel_track.processSerialPacket$posX$1$1==.
   F020                     613 _processSerialPacket_posX_1_1:
   F020                     614 	.ds 2
                    0022    615 Lmaster_wixel_track.processSerialPacket$cmdStr$1$1==.
   F022                     616 _processSerialPacket_cmdStr_1_1:
   F022                     617 	.ds 16
                            618 ;--------------------------------------------------------
                            619 ; external ram data
                            620 ;--------------------------------------------------------
                            621 	.area XSEG    (XDATA)
                    DF00    622 Fmaster_wixel_track$SYNC1$0$0 == 0xdf00
                    DF00    623 _SYNC1	=	0xdf00
                    DF01    624 Fmaster_wixel_track$SYNC0$0$0 == 0xdf01
                    DF01    625 _SYNC0	=	0xdf01
                    DF02    626 Fmaster_wixel_track$PKTLEN$0$0 == 0xdf02
                    DF02    627 _PKTLEN	=	0xdf02
                    DF03    628 Fmaster_wixel_track$PKTCTRL1$0$0 == 0xdf03
                    DF03    629 _PKTCTRL1	=	0xdf03
                    DF04    630 Fmaster_wixel_track$PKTCTRL0$0$0 == 0xdf04
                    DF04    631 _PKTCTRL0	=	0xdf04
                    DF05    632 Fmaster_wixel_track$ADDR$0$0 == 0xdf05
                    DF05    633 _ADDR	=	0xdf05
                    DF06    634 Fmaster_wixel_track$CHANNR$0$0 == 0xdf06
                    DF06    635 _CHANNR	=	0xdf06
                    DF07    636 Fmaster_wixel_track$FSCTRL1$0$0 == 0xdf07
                    DF07    637 _FSCTRL1	=	0xdf07
                    DF08    638 Fmaster_wixel_track$FSCTRL0$0$0 == 0xdf08
                    DF08    639 _FSCTRL0	=	0xdf08
                    DF09    640 Fmaster_wixel_track$FREQ2$0$0 == 0xdf09
                    DF09    641 _FREQ2	=	0xdf09
                    DF0A    642 Fmaster_wixel_track$FREQ1$0$0 == 0xdf0a
                    DF0A    643 _FREQ1	=	0xdf0a
                    DF0B    644 Fmaster_wixel_track$FREQ0$0$0 == 0xdf0b
                    DF0B    645 _FREQ0	=	0xdf0b
                    DF0C    646 Fmaster_wixel_track$MDMCFG4$0$0 == 0xdf0c
                    DF0C    647 _MDMCFG4	=	0xdf0c
                    DF0D    648 Fmaster_wixel_track$MDMCFG3$0$0 == 0xdf0d
                    DF0D    649 _MDMCFG3	=	0xdf0d
                    DF0E    650 Fmaster_wixel_track$MDMCFG2$0$0 == 0xdf0e
                    DF0E    651 _MDMCFG2	=	0xdf0e
                    DF0F    652 Fmaster_wixel_track$MDMCFG1$0$0 == 0xdf0f
                    DF0F    653 _MDMCFG1	=	0xdf0f
                    DF10    654 Fmaster_wixel_track$MDMCFG0$0$0 == 0xdf10
                    DF10    655 _MDMCFG0	=	0xdf10
                    DF11    656 Fmaster_wixel_track$DEVIATN$0$0 == 0xdf11
                    DF11    657 _DEVIATN	=	0xdf11
                    DF12    658 Fmaster_wixel_track$MCSM2$0$0 == 0xdf12
                    DF12    659 _MCSM2	=	0xdf12
                    DF13    660 Fmaster_wixel_track$MCSM1$0$0 == 0xdf13
                    DF13    661 _MCSM1	=	0xdf13
                    DF14    662 Fmaster_wixel_track$MCSM0$0$0 == 0xdf14
                    DF14    663 _MCSM0	=	0xdf14
                    DF15    664 Fmaster_wixel_track$FOCCFG$0$0 == 0xdf15
                    DF15    665 _FOCCFG	=	0xdf15
                    DF16    666 Fmaster_wixel_track$BSCFG$0$0 == 0xdf16
                    DF16    667 _BSCFG	=	0xdf16
                    DF17    668 Fmaster_wixel_track$AGCCTRL2$0$0 == 0xdf17
                    DF17    669 _AGCCTRL2	=	0xdf17
                    DF18    670 Fmaster_wixel_track$AGCCTRL1$0$0 == 0xdf18
                    DF18    671 _AGCCTRL1	=	0xdf18
                    DF19    672 Fmaster_wixel_track$AGCCTRL0$0$0 == 0xdf19
                    DF19    673 _AGCCTRL0	=	0xdf19
                    DF1A    674 Fmaster_wixel_track$FREND1$0$0 == 0xdf1a
                    DF1A    675 _FREND1	=	0xdf1a
                    DF1B    676 Fmaster_wixel_track$FREND0$0$0 == 0xdf1b
                    DF1B    677 _FREND0	=	0xdf1b
                    DF1C    678 Fmaster_wixel_track$FSCAL3$0$0 == 0xdf1c
                    DF1C    679 _FSCAL3	=	0xdf1c
                    DF1D    680 Fmaster_wixel_track$FSCAL2$0$0 == 0xdf1d
                    DF1D    681 _FSCAL2	=	0xdf1d
                    DF1E    682 Fmaster_wixel_track$FSCAL1$0$0 == 0xdf1e
                    DF1E    683 _FSCAL1	=	0xdf1e
                    DF1F    684 Fmaster_wixel_track$FSCAL0$0$0 == 0xdf1f
                    DF1F    685 _FSCAL0	=	0xdf1f
                    DF23    686 Fmaster_wixel_track$TEST2$0$0 == 0xdf23
                    DF23    687 _TEST2	=	0xdf23
                    DF24    688 Fmaster_wixel_track$TEST1$0$0 == 0xdf24
                    DF24    689 _TEST1	=	0xdf24
                    DF25    690 Fmaster_wixel_track$TEST0$0$0 == 0xdf25
                    DF25    691 _TEST0	=	0xdf25
                    DF2E    692 Fmaster_wixel_track$PA_TABLE0$0$0 == 0xdf2e
                    DF2E    693 _PA_TABLE0	=	0xdf2e
                    DF2F    694 Fmaster_wixel_track$IOCFG2$0$0 == 0xdf2f
                    DF2F    695 _IOCFG2	=	0xdf2f
                    DF30    696 Fmaster_wixel_track$IOCFG1$0$0 == 0xdf30
                    DF30    697 _IOCFG1	=	0xdf30
                    DF31    698 Fmaster_wixel_track$IOCFG0$0$0 == 0xdf31
                    DF31    699 _IOCFG0	=	0xdf31
                    DF36    700 Fmaster_wixel_track$PARTNUM$0$0 == 0xdf36
                    DF36    701 _PARTNUM	=	0xdf36
                    DF37    702 Fmaster_wixel_track$VERSION$0$0 == 0xdf37
                    DF37    703 _VERSION	=	0xdf37
                    DF38    704 Fmaster_wixel_track$FREQEST$0$0 == 0xdf38
                    DF38    705 _FREQEST	=	0xdf38
                    DF39    706 Fmaster_wixel_track$LQI$0$0 == 0xdf39
                    DF39    707 _LQI	=	0xdf39
                    DF3A    708 Fmaster_wixel_track$RSSI$0$0 == 0xdf3a
                    DF3A    709 _RSSI	=	0xdf3a
                    DF3B    710 Fmaster_wixel_track$MARCSTATE$0$0 == 0xdf3b
                    DF3B    711 _MARCSTATE	=	0xdf3b
                    DF3C    712 Fmaster_wixel_track$PKTSTATUS$0$0 == 0xdf3c
                    DF3C    713 _PKTSTATUS	=	0xdf3c
                    DF3D    714 Fmaster_wixel_track$VCO_VC_DAC$0$0 == 0xdf3d
                    DF3D    715 _VCO_VC_DAC	=	0xdf3d
                    DF40    716 Fmaster_wixel_track$I2SCFG0$0$0 == 0xdf40
                    DF40    717 _I2SCFG0	=	0xdf40
                    DF41    718 Fmaster_wixel_track$I2SCFG1$0$0 == 0xdf41
                    DF41    719 _I2SCFG1	=	0xdf41
                    DF42    720 Fmaster_wixel_track$I2SDATL$0$0 == 0xdf42
                    DF42    721 _I2SDATL	=	0xdf42
                    DF43    722 Fmaster_wixel_track$I2SDATH$0$0 == 0xdf43
                    DF43    723 _I2SDATH	=	0xdf43
                    DF44    724 Fmaster_wixel_track$I2SWCNT$0$0 == 0xdf44
                    DF44    725 _I2SWCNT	=	0xdf44
                    DF45    726 Fmaster_wixel_track$I2SSTAT$0$0 == 0xdf45
                    DF45    727 _I2SSTAT	=	0xdf45
                    DF46    728 Fmaster_wixel_track$I2SCLKF0$0$0 == 0xdf46
                    DF46    729 _I2SCLKF0	=	0xdf46
                    DF47    730 Fmaster_wixel_track$I2SCLKF1$0$0 == 0xdf47
                    DF47    731 _I2SCLKF1	=	0xdf47
                    DF48    732 Fmaster_wixel_track$I2SCLKF2$0$0 == 0xdf48
                    DF48    733 _I2SCLKF2	=	0xdf48
                    DE00    734 Fmaster_wixel_track$USBADDR$0$0 == 0xde00
                    DE00    735 _USBADDR	=	0xde00
                    DE01    736 Fmaster_wixel_track$USBPOW$0$0 == 0xde01
                    DE01    737 _USBPOW	=	0xde01
                    DE02    738 Fmaster_wixel_track$USBIIF$0$0 == 0xde02
                    DE02    739 _USBIIF	=	0xde02
                    DE04    740 Fmaster_wixel_track$USBOIF$0$0 == 0xde04
                    DE04    741 _USBOIF	=	0xde04
                    DE06    742 Fmaster_wixel_track$USBCIF$0$0 == 0xde06
                    DE06    743 _USBCIF	=	0xde06
                    DE07    744 Fmaster_wixel_track$USBIIE$0$0 == 0xde07
                    DE07    745 _USBIIE	=	0xde07
                    DE09    746 Fmaster_wixel_track$USBOIE$0$0 == 0xde09
                    DE09    747 _USBOIE	=	0xde09
                    DE0B    748 Fmaster_wixel_track$USBCIE$0$0 == 0xde0b
                    DE0B    749 _USBCIE	=	0xde0b
                    DE0C    750 Fmaster_wixel_track$USBFRML$0$0 == 0xde0c
                    DE0C    751 _USBFRML	=	0xde0c
                    DE0D    752 Fmaster_wixel_track$USBFRMH$0$0 == 0xde0d
                    DE0D    753 _USBFRMH	=	0xde0d
                    DE0E    754 Fmaster_wixel_track$USBINDEX$0$0 == 0xde0e
                    DE0E    755 _USBINDEX	=	0xde0e
                    DE10    756 Fmaster_wixel_track$USBMAXI$0$0 == 0xde10
                    DE10    757 _USBMAXI	=	0xde10
                    DE11    758 Fmaster_wixel_track$USBCSIL$0$0 == 0xde11
                    DE11    759 _USBCSIL	=	0xde11
                    DE12    760 Fmaster_wixel_track$USBCSIH$0$0 == 0xde12
                    DE12    761 _USBCSIH	=	0xde12
                    DE13    762 Fmaster_wixel_track$USBMAXO$0$0 == 0xde13
                    DE13    763 _USBMAXO	=	0xde13
                    DE14    764 Fmaster_wixel_track$USBCSOL$0$0 == 0xde14
                    DE14    765 _USBCSOL	=	0xde14
                    DE15    766 Fmaster_wixel_track$USBCSOH$0$0 == 0xde15
                    DE15    767 _USBCSOH	=	0xde15
                    DE16    768 Fmaster_wixel_track$USBCNTL$0$0 == 0xde16
                    DE16    769 _USBCNTL	=	0xde16
                    DE17    770 Fmaster_wixel_track$USBCNTH$0$0 == 0xde17
                    DE17    771 _USBCNTH	=	0xde17
                    DE20    772 Fmaster_wixel_track$USBF0$0$0 == 0xde20
                    DE20    773 _USBF0	=	0xde20
                    DE22    774 Fmaster_wixel_track$USBF1$0$0 == 0xde22
                    DE22    775 _USBF1	=	0xde22
                    DE24    776 Fmaster_wixel_track$USBF2$0$0 == 0xde24
                    DE24    777 _USBF2	=	0xde24
                    DE26    778 Fmaster_wixel_track$USBF3$0$0 == 0xde26
                    DE26    779 _USBF3	=	0xde26
                    DE28    780 Fmaster_wixel_track$USBF4$0$0 == 0xde28
                    DE28    781 _USBF4	=	0xde28
                    DE2A    782 Fmaster_wixel_track$USBF5$0$0 == 0xde2a
                    DE2A    783 _USBF5	=	0xde2a
                    0000    784 Fmaster_wixel_track$txPacket$0$0==.
   F070                     785 _txPacket:
   F070                     786 	.ds 65
                    0041    787 Fmaster_wixel_track$serialBuffer$0$0==.
   F0B1                     788 _serialBuffer:
   F0B1                     789 	.ds 100
                    00A5    790 Fmaster_wixel_track$serialResponse$0$0==.
   F115                     791 _serialResponse:
   F115                     792 	.ds 64
                            793 ;--------------------------------------------------------
                            794 ; absolute external ram data
                            795 ;--------------------------------------------------------
                            796 	.area XABS    (ABS,XDATA)
                            797 ;--------------------------------------------------------
                            798 ; external initialized ram data
                            799 ;--------------------------------------------------------
                            800 	.area XISEG   (XDATA)
                            801 	.area HOME    (CODE)
                            802 	.area GSINIT0 (CODE)
                            803 	.area GSINIT1 (CODE)
                            804 	.area GSINIT2 (CODE)
                            805 	.area GSINIT3 (CODE)
                            806 	.area GSINIT4 (CODE)
                            807 	.area GSINIT5 (CODE)
                            808 	.area GSINIT  (CODE)
                            809 	.area GSFINAL (CODE)
                            810 	.area CSEG    (CODE)
                            811 ;--------------------------------------------------------
                            812 ; interrupt vector 
                            813 ;--------------------------------------------------------
                            814 	.area HOME    (CODE)
   0400                     815 __interrupt_vect:
   0400 02 04 6D            816 	ljmp	__sdcc_gsinit_startup
   0403 32                  817 	reti
   0404                     818 	.ds	7
   040B 32                  819 	reti
   040C                     820 	.ds	7
   0413 32                  821 	reti
   0414                     822 	.ds	7
   041B 32                  823 	reti
   041C                     824 	.ds	7
   0423 32                  825 	reti
   0424                     826 	.ds	7
   042B 32                  827 	reti
   042C                     828 	.ds	7
   0433 32                  829 	reti
   0434                     830 	.ds	7
   043B 32                  831 	reti
   043C                     832 	.ds	7
   0443 32                  833 	reti
   0444                     834 	.ds	7
   044B 32                  835 	reti
   044C                     836 	.ds	7
   0453 32                  837 	reti
   0454                     838 	.ds	7
   045B 32                  839 	reti
   045C                     840 	.ds	7
   0463 02 16 47            841 	ljmp	_ISR_T4
                            842 ;--------------------------------------------------------
                            843 ; global & static initialisations
                            844 ;--------------------------------------------------------
                            845 	.area HOME    (CODE)
                            846 	.area GSINIT  (CODE)
                            847 	.area GSFINAL (CODE)
                            848 	.area GSINIT  (CODE)
                            849 	.globl __sdcc_gsinit_startup
                            850 	.globl __sdcc_program_startup
                            851 	.globl __start__stack
                            852 	.globl __mcs51_genXINIT
                            853 	.globl __mcs51_genXRAMCLEAR
                            854 	.globl __mcs51_genRAMCLEAR
                    0000    855 	G$main$0$0 ==.
                    0000    856 	C$master_wixel_track.c$74$1$1 ==.
                            857 ;	apps/master_wixel_track/master_wixel_track.c:74: BIT serialRxPulseActive = 0;
   04C6 C2 00               858 	clr	_serialRxPulseActive
                    0002    859 	G$main$0$0 ==.
                    0002    860 	C$master_wixel_track.c$76$1$1 ==.
                            861 ;	apps/master_wixel_track/master_wixel_track.c:76: BIT radioTxPulseActive = 0;
   04C8 C2 01               862 	clr	_radioTxPulseActive
                    0004    863 	G$main$0$0 ==.
                    0004    864 	C$master_wixel_track.c$60$1$1 ==.
                            865 ;	apps/master_wixel_track/master_wixel_track.c:60: uint8 serialBufferIndex = 0;
   04CA 78 00               866 	mov	r0,#_serialBufferIndex
   04CC E4                  867 	clr	a
   04CD F2                  868 	movx	@r0,a
                    0008    869 	G$main$0$0 ==.
                    0008    870 	C$master_wixel_track.c$66$1$1 ==.
                            871 ;	apps/master_wixel_track/master_wixel_track.c:66: uint8 slaveAddresses[NUM_SLAVES] = {SLAVE_1_ADDRESS, SLAVE_2_ADDRESS, SLAVE_3_ADDRESS, SLAVE_4_ADDRESS};
   04CE 78 01               872 	mov	r0,#_slaveAddresses
   04D0 74 01               873 	mov	a,#0x01
   04D2 F2                  874 	movx	@r0,a
   04D3 78 02               875 	mov	r0,#(_slaveAddresses + 0x0001)
   04D5 74 02               876 	mov	a,#0x02
   04D7 F2                  877 	movx	@r0,a
   04D8 78 03               878 	mov	r0,#(_slaveAddresses + 0x0002)
   04DA 74 03               879 	mov	a,#0x03
   04DC F2                  880 	movx	@r0,a
   04DD 78 04               881 	mov	r0,#(_slaveAddresses + 0x0003)
   04DF 74 04               882 	mov	a,#0x04
   04E1 F2                  883 	movx	@r0,a
                    001C    884 	G$main$0$0 ==.
                    001C    885 	C$master_wixel_track.c$69$1$1 ==.
                            886 ;	apps/master_wixel_track/master_wixel_track.c:69: uint32 lastSerialRxTime = 0;
   04E2 78 05               887 	mov	r0,#_lastSerialRxTime
   04E4 E4                  888 	clr	a
   04E5 F2                  889 	movx	@r0,a
   04E6 08                  890 	inc	r0
   04E7 F2                  891 	movx	@r0,a
   04E8 08                  892 	inc	r0
   04E9 F2                  893 	movx	@r0,a
   04EA 08                  894 	inc	r0
   04EB F2                  895 	movx	@r0,a
                    0026    896 	G$main$0$0 ==.
                    0026    897 	C$master_wixel_track.c$70$1$1 ==.
                            898 ;	apps/master_wixel_track/master_wixel_track.c:70: uint32 lastRadioTxTime = 0;
   04EC 78 09               899 	mov	r0,#_lastRadioTxTime
   04EE E4                  900 	clr	a
   04EF F2                  901 	movx	@r0,a
   04F0 08                  902 	inc	r0
   04F1 F2                  903 	movx	@r0,a
   04F2 08                  904 	inc	r0
   04F3 F2                  905 	movx	@r0,a
   04F4 08                  906 	inc	r0
   04F5 F2                  907 	movx	@r0,a
                    0030    908 	G$main$0$0 ==.
                    0030    909 	C$master_wixel_track.c$71$1$1 ==.
                            910 ;	apps/master_wixel_track/master_wixel_track.c:71: uint32 lastHeartbeatTime = 0;
   04F6 78 0D               911 	mov	r0,#_lastHeartbeatTime
   04F8 E4                  912 	clr	a
   04F9 F2                  913 	movx	@r0,a
   04FA 08                  914 	inc	r0
   04FB F2                  915 	movx	@r0,a
   04FC 08                  916 	inc	r0
   04FD F2                  917 	movx	@r0,a
   04FE 08                  918 	inc	r0
   04FF F2                  919 	movx	@r0,a
                    003A    920 	G$main$0$0 ==.
                    003A    921 	C$master_wixel_track.c$75$1$1 ==.
                            922 ;	apps/master_wixel_track/master_wixel_track.c:75: uint16 serialRxPulseStart = 0;
   0500 78 11               923 	mov	r0,#_serialRxPulseStart
   0502 E4                  924 	clr	a
   0503 F2                  925 	movx	@r0,a
   0504 08                  926 	inc	r0
   0505 F2                  927 	movx	@r0,a
                    0040    928 	G$main$0$0 ==.
                    0040    929 	C$master_wixel_track.c$77$1$1 ==.
                            930 ;	apps/master_wixel_track/master_wixel_track.c:77: uint16 radioTxPulseStart = 0;
   0506 78 13               931 	mov	r0,#_radioTxPulseStart
   0508 E4                  932 	clr	a
   0509 F2                  933 	movx	@r0,a
   050A 08                  934 	inc	r0
   050B F2                  935 	movx	@r0,a
                    0046    936 	G$main$0$0 ==.
                    0046    937 	C$master_wixel_track.c$85$1$1 ==.
                            938 ;	apps/master_wixel_track/master_wixel_track.c:85: int16 posX = 0;
   050C 78 17               939 	mov	r0,#_posX
   050E E4                  940 	clr	a
   050F F2                  941 	movx	@r0,a
   0510 08                  942 	inc	r0
   0511 F2                  943 	movx	@r0,a
                    004C    944 	G$main$0$0 ==.
                    004C    945 	C$master_wixel_track.c$86$1$1 ==.
                            946 ;	apps/master_wixel_track/master_wixel_track.c:86: int16 posY = 0;
   0512 78 19               947 	mov	r0,#_posY
   0514 E4                  948 	clr	a
   0515 F2                  949 	movx	@r0,a
   0516 08                  950 	inc	r0
   0517 F2                  951 	movx	@r0,a
                    0052    952 	G$main$0$0 ==.
                    0052    953 	C$master_wixel_track.c$87$1$1 ==.
                            954 ;	apps/master_wixel_track/master_wixel_track.c:87: int8 theta = 0;
   0518 78 1B               955 	mov	r0,#_theta
   051A E4                  956 	clr	a
   051B F2                  957 	movx	@r0,a
                            958 	.area GSFINAL (CODE)
   0544 02 04 66            959 	ljmp	__sdcc_program_startup
                            960 ;--------------------------------------------------------
                            961 ; Home
                            962 ;--------------------------------------------------------
                            963 	.area HOME    (CODE)
                            964 	.area HOME    (CODE)
   0466                     965 __sdcc_program_startup:
   0466 12 0C 39            966 	lcall	_main
                            967 ;	return from main will lock up
   0469 80 FE               968 	sjmp .
                            969 ;--------------------------------------------------------
                            970 ; code
                            971 ;--------------------------------------------------------
                            972 	.area CSEG    (CODE)
                            973 ;------------------------------------------------------------
                            974 ;Allocation info for local variables in function 'failSafeBootloader'
                            975 ;------------------------------------------------------------
                    0000    976 	G$failSafeBootloader$0$0 ==.
                    0000    977 	C$master_wixel_track.c$90$0$0 ==.
                            978 ;	apps/master_wixel_track/master_wixel_track.c:90: void failSafeBootloader()
                            979 ;	-----------------------------------------
                            980 ;	 function failSafeBootloader
                            981 ;	-----------------------------------------
   0547                     982 _failSafeBootloader:
                    0007    983 	ar7 = 0x07
                    0006    984 	ar6 = 0x06
                    0005    985 	ar5 = 0x05
                    0004    986 	ar4 = 0x04
                    0003    987 	ar3 = 0x03
                    0002    988 	ar2 = 0x02
                    0001    989 	ar1 = 0x01
                    0000    990 	ar0 = 0x00
                    0000    991 	C$master_wixel_track.c$92$2$2 ==.
                            992 ;	apps/master_wixel_track/master_wixel_track.c:92: LED_YELLOW(0);
   0547 AF FF               993 	mov	r7,_P2DIR
   0549 53 07 FB            994 	anl	ar7,#0xFB
   054C 8F FF               995 	mov	_P2DIR,r7
                    0007    996 	C$master_wixel_track.c$93$2$3 ==.
                            997 ;	apps/master_wixel_track/master_wixel_track.c:93: LED_YELLOW_TOGGLE();
   054E 63 FF 04            998 	xrl	_P2DIR,#0x04
                    000A    999 	C$master_wixel_track.c$94$1$1 ==.
                           1000 ;	apps/master_wixel_track/master_wixel_track.c:94: delayMs(200);
   0551 90 00 C8           1001 	mov	dptr,#0x00C8
   0554 12 16 98           1002 	lcall	_delayMs
                    0010   1003 	C$master_wixel_track.c$96$1$1 ==.
                           1004 ;	apps/master_wixel_track/master_wixel_track.c:96: for(fsi = 0; fsi < 20; fsi++)
   0557 78 16              1005 	mov	r0,#_fsi
   0559 E4                 1006 	clr	a
   055A F2                 1007 	movx	@r0,a
   055B                    1008 00101$:
   055B 78 16              1009 	mov	r0,#_fsi
   055D E2                 1010 	movx	a,@r0
   055E B4 14 00           1011 	cjne	a,#0x14,00109$
   0561                    1012 00109$:
   0561 50 14              1013 	jnc	00104$
                    001C   1014 	C$master_wixel_track.c$98$3$5 ==.
                           1015 ;	apps/master_wixel_track/master_wixel_track.c:98: LED_YELLOW_TOGGLE();
   0563 63 FF 04           1016 	xrl	_P2DIR,#0x04
                    001F   1017 	C$master_wixel_track.c$99$2$4 ==.
                           1018 ;	apps/master_wixel_track/master_wixel_track.c:99: boardService();
   0566 12 15 79           1019 	lcall	_boardService
                    0022   1020 	C$master_wixel_track.c$100$2$4 ==.
                           1021 ;	apps/master_wixel_track/master_wixel_track.c:100: delayMs(100);
   0569 90 00 64           1022 	mov	dptr,#0x0064
   056C 12 16 98           1023 	lcall	_delayMs
                    0028   1024 	C$master_wixel_track.c$96$1$1 ==.
                           1025 ;	apps/master_wixel_track/master_wixel_track.c:96: for(fsi = 0; fsi < 20; fsi++)
   056F 78 16              1026 	mov	r0,#_fsi
   0571 E2                 1027 	movx	a,@r0
   0572 24 01              1028 	add	a,#0x01
   0574 F2                 1029 	movx	@r0,a
   0575 80 E4              1030 	sjmp	00101$
   0577                    1031 00104$:
                    0030   1032 	C$master_wixel_track.c$103$2$6 ==.
                           1033 ;	apps/master_wixel_track/master_wixel_track.c:103: LED_YELLOW(0);
   0577 AF FF              1034 	mov	r7,_P2DIR
   0579 53 07 FB           1035 	anl	ar7,#0xFB
   057C 8F FF              1036 	mov	_P2DIR,r7
                    0037   1037 	C$master_wixel_track.c$104$2$6 ==.
                    0037   1038 	XG$failSafeBootloader$0$0 ==.
   057E 22                 1039 	ret
                           1040 ;------------------------------------------------------------
                           1041 ;Allocation info for local variables in function 'radioInit'
                           1042 ;------------------------------------------------------------
                    0038   1043 	G$radioInit$0$0 ==.
                    0038   1044 	C$master_wixel_track.c$106$2$6 ==.
                           1045 ;	apps/master_wixel_track/master_wixel_track.c:106: void radioInit()
                           1046 ;	-----------------------------------------
                           1047 ;	 function radioInit
                           1048 ;	-----------------------------------------
   057F                    1049 _radioInit:
                    0038   1050 	C$master_wixel_track.c$108$1$1 ==.
                           1051 ;	apps/master_wixel_track/master_wixel_track.c:108: radioRegistersInit();
   057F 12 1F 11           1052 	lcall	_radioRegistersInit
                    003B   1053 	C$master_wixel_track.c$110$1$1 ==.
                           1054 ;	apps/master_wixel_track/master_wixel_track.c:110: CHANNR = 128;
   0582 90 DF 06           1055 	mov	dptr,#_CHANNR
   0585 74 80              1056 	mov	a,#0x80
   0587 F0                 1057 	movx	@dptr,a
                    0041   1058 	C$master_wixel_track.c$111$1$1 ==.
                           1059 ;	apps/master_wixel_track/master_wixel_track.c:111: PKTLEN = RADIO_PACKET_SIZE;     // HARDCODED: 64 bytes for 4 slaves
   0588 90 DF 02           1060 	mov	dptr,#_PKTLEN
   058B 74 40              1061 	mov	a,#0x40
   058D F0                 1062 	movx	@dptr,a
                    0047   1063 	C$master_wixel_track.c$113$1$1 ==.
                           1064 ;	apps/master_wixel_track/master_wixel_track.c:113: MCSM0 = 0x14;
   058E 90 DF 14           1065 	mov	dptr,#_MCSM0
   0591 74 14              1066 	mov	a,#0x14
   0593 F0                 1067 	movx	@dptr,a
                    004D   1068 	C$master_wixel_track.c$114$1$1 ==.
                           1069 ;	apps/master_wixel_track/master_wixel_track.c:114: MCSM1 = 0x00;
   0594 90 DF 13           1070 	mov	dptr,#_MCSM1
   0597 E4                 1071 	clr	a
   0598 F0                 1072 	movx	@dptr,a
                    0052   1073 	C$master_wixel_track.c$115$1$1 ==.
                           1074 ;	apps/master_wixel_track/master_wixel_track.c:115: IOCFG2 = 0b011011;
   0599 90 DF 2F           1075 	mov	dptr,#_IOCFG2
   059C 74 1B              1076 	mov	a,#0x1B
   059E F0                 1077 	movx	@dptr,a
                    0058   1078 	C$master_wixel_track.c$118$1$1 ==.
                           1079 ;	apps/master_wixel_track/master_wixel_track.c:118: dmaConfig.radio.DC6 = 19;
   059F 90 F1 68           1080 	mov	dptr,#(_dmaConfig + 0x0006)
   05A2 74 13              1081 	mov	a,#0x13
   05A4 F0                 1082 	movx	@dptr,a
                    005E   1083 	C$master_wixel_track.c$119$1$1 ==.
                           1084 ;	apps/master_wixel_track/master_wixel_track.c:119: dmaConfig.radio.SRCADDRH = (unsigned int)txPacket >> 8;
   05A5 7E 70              1085 	mov	r6,#_txPacket
   05A7 7F F0              1086 	mov	r7,#(_txPacket >> 8)
   05A9 8F 06              1087 	mov	ar6,r7
   05AB 90 F1 62           1088 	mov	dptr,#_dmaConfig
   05AE EE                 1089 	mov	a,r6
   05AF F0                 1090 	movx	@dptr,a
                    0069   1091 	C$master_wixel_track.c$120$1$1 ==.
                           1092 ;	apps/master_wixel_track/master_wixel_track.c:120: dmaConfig.radio.SRCADDRL = (unsigned int)txPacket;
   05B0 7E 70              1093 	mov	r6,#_txPacket
   05B2 7F F0              1094 	mov	r7,#(_txPacket >> 8)
   05B4 90 F1 63           1095 	mov	dptr,#(_dmaConfig + 0x0001)
   05B7 EE                 1096 	mov	a,r6
   05B8 F0                 1097 	movx	@dptr,a
                    0072   1098 	C$master_wixel_track.c$121$1$1 ==.
                           1099 ;	apps/master_wixel_track/master_wixel_track.c:121: dmaConfig.radio.DESTADDRH = XDATA_SFR_ADDRESS(RFD) >> 8;
   05B9 7E D9              1100 	mov	r6,#_RFD
   05BB 7F 00              1101 	mov	r7,#0x00
   05BD 74 DF              1102 	mov	a,#0xDF
   05BF 2F                 1103 	add	a,r7
   05C0 FE                 1104 	mov	r6,a
   05C1 90 F1 64           1105 	mov	dptr,#(_dmaConfig + 0x0002)
   05C4 EE                 1106 	mov	a,r6
   05C5 F0                 1107 	movx	@dptr,a
                    007F   1108 	C$master_wixel_track.c$122$1$1 ==.
                           1109 ;	apps/master_wixel_track/master_wixel_track.c:122: dmaConfig.radio.DESTADDRL = XDATA_SFR_ADDRESS(RFD);
   05C6 7E D9              1110 	mov	r6,#_RFD
   05C8 90 F1 65           1111 	mov	dptr,#(_dmaConfig + 0x0003)
   05CB EE                 1112 	mov	a,r6
   05CC F0                 1113 	movx	@dptr,a
                    0086   1114 	C$master_wixel_track.c$123$1$1 ==.
                           1115 ;	apps/master_wixel_track/master_wixel_track.c:123: dmaConfig.radio.LENL = 1 + RADIO_PACKET_SIZE;
   05CD 90 F1 67           1116 	mov	dptr,#(_dmaConfig + 0x0005)
   05D0 74 41              1117 	mov	a,#0x41
   05D2 F0                 1118 	movx	@dptr,a
                    008C   1119 	C$master_wixel_track.c$124$1$1 ==.
                           1120 ;	apps/master_wixel_track/master_wixel_track.c:124: dmaConfig.radio.VLEN_LENH = 0b00100000;
   05D3 90 F1 66           1121 	mov	dptr,#(_dmaConfig + 0x0004)
   05D6 74 20              1122 	mov	a,#0x20
   05D8 F0                 1123 	movx	@dptr,a
                    0092   1124 	C$master_wixel_track.c$125$1$1 ==.
                           1125 ;	apps/master_wixel_track/master_wixel_track.c:125: dmaConfig.radio.DC7 = 0x40;
   05D9 90 F1 69           1126 	mov	dptr,#(_dmaConfig + 0x0007)
   05DC 74 40              1127 	mov	a,#0x40
   05DE F0                 1128 	movx	@dptr,a
                    0098   1129 	C$master_wixel_track.c$127$1$1 ==.
                           1130 ;	apps/master_wixel_track/master_wixel_track.c:127: txPacket[0] = RADIO_PACKET_SIZE;
   05DF 90 F0 70           1131 	mov	dptr,#_txPacket
   05E2 74 40              1132 	mov	a,#0x40
   05E4 F0                 1133 	movx	@dptr,a
                    009E   1134 	C$master_wixel_track.c$129$1$1 ==.
                           1135 ;	apps/master_wixel_track/master_wixel_track.c:129: RFST = 4;
   05E5 75 E1 04           1136 	mov	_RFST,#0x04
                    00A1   1137 	C$master_wixel_track.c$130$1$1 ==.
                    00A1   1138 	XG$radioInit$0$0 ==.
   05E8 22                 1139 	ret
                           1140 ;------------------------------------------------------------
                           1141 ;Allocation info for local variables in function 'sendRadioPacket'
                           1142 ;------------------------------------------------------------
                    00A2   1143 	G$sendRadioPacket$0$0 ==.
                    00A2   1144 	C$master_wixel_track.c$134$1$1 ==.
                           1145 ;	apps/master_wixel_track/master_wixel_track.c:134: void sendRadioPacket()
                           1146 ;	-----------------------------------------
                           1147 ;	 function sendRadioPacket
                           1148 ;	-----------------------------------------
   05E9                    1149 _sendRadioPacket:
                    00A2   1150 	C$master_wixel_track.c$136$1$1 ==.
                           1151 ;	apps/master_wixel_track/master_wixel_track.c:136: if (MARCSTATE == 1)
   05E9 90 DF 3B           1152 	mov	dptr,#_MARCSTATE
   05EC E0                 1153 	movx	a,@dptr
   05ED FF                 1154 	mov	r7,a
   05EE BF 01 34           1155 	cjne	r7,#0x01,00103$
                    00AA   1156 	C$master_wixel_track.c$138$2$2 ==.
                           1157 ;	apps/master_wixel_track/master_wixel_track.c:138: RFIF &= ~(1<<4);
   05F1 AF E9              1158 	mov	r7,_RFIF
   05F3 53 07 EF           1159 	anl	ar7,#0xEF
   05F6 8F E9              1160 	mov	_RFIF,r7
                    00B1   1161 	C$master_wixel_track.c$139$2$2 ==.
                           1162 ;	apps/master_wixel_track/master_wixel_track.c:139: DMAARM |= (1<<DMA_CHANNEL_RADIO);
   05F8 43 D6 02           1163 	orl	_DMAARM,#0x02
                    00B4   1164 	C$master_wixel_track.c$140$2$2 ==.
                           1165 ;	apps/master_wixel_track/master_wixel_track.c:140: RFST = 3;
   05FB 75 E1 03           1166 	mov	_RFST,#0x03
                    00B7   1167 	C$master_wixel_track.c$142$2$2 ==.
                           1168 ;	apps/master_wixel_track/master_wixel_track.c:142: radioTxPulseActive = 1;
   05FE D2 01              1169 	setb	_radioTxPulseActive
                    00B9   1170 	C$master_wixel_track.c$143$2$2 ==.
                           1171 ;	apps/master_wixel_track/master_wixel_track.c:143: radioTxPulseStart = (uint16)getMs();
   0600 12 16 6C           1172 	lcall	_getMs
   0603 AC 82              1173 	mov	r4,dpl
   0605 AD 83              1174 	mov	r5,dph
   0607 78 13              1175 	mov	r0,#_radioTxPulseStart
   0609 EC                 1176 	mov	a,r4
   060A F2                 1177 	movx	@r0,a
   060B 08                 1178 	inc	r0
   060C ED                 1179 	mov	a,r5
   060D F2                 1180 	movx	@r0,a
                    00C7   1181 	C$master_wixel_track.c$145$2$2 ==.
                           1182 ;	apps/master_wixel_track/master_wixel_track.c:145: lastRadioTxTime = getMs();
   060E 12 16 6C           1183 	lcall	_getMs
   0611 AC 82              1184 	mov	r4,dpl
   0613 AD 83              1185 	mov	r5,dph
   0615 AE F0              1186 	mov	r6,b
   0617 FF                 1187 	mov	r7,a
   0618 78 09              1188 	mov	r0,#_lastRadioTxTime
   061A EC                 1189 	mov	a,r4
   061B F2                 1190 	movx	@r0,a
   061C 08                 1191 	inc	r0
   061D ED                 1192 	mov	a,r5
   061E F2                 1193 	movx	@r0,a
   061F 08                 1194 	inc	r0
   0620 EE                 1195 	mov	a,r6
   0621 F2                 1196 	movx	@r0,a
   0622 08                 1197 	inc	r0
   0623 EF                 1198 	mov	a,r7
   0624 F2                 1199 	movx	@r0,a
   0625                    1200 00103$:
                    00DE   1201 	C$master_wixel_track.c$147$2$1 ==.
                    00DE   1202 	XG$sendRadioPacket$0$0 ==.
   0625 22                 1203 	ret
                           1204 ;------------------------------------------------------------
                           1205 ;Allocation info for local variables in function 'updateLeds'
                           1206 ;------------------------------------------------------------
                           1207 ;sloc0                     Allocated with name '_updateLeds_sloc0_1_0'
                           1208 ;------------------------------------------------------------
                    00DF   1209 	G$updateLeds$0$0 ==.
                    00DF   1210 	C$master_wixel_track.c$151$2$1 ==.
                           1211 ;	apps/master_wixel_track/master_wixel_track.c:151: void updateLeds()
                           1212 ;	-----------------------------------------
                           1213 ;	 function updateLeds
                           1214 ;	-----------------------------------------
   0626                    1215 _updateLeds:
                    00DF   1216 	C$master_wixel_track.c$153$1$1 ==.
                           1217 ;	apps/master_wixel_track/master_wixel_track.c:153: uint16 now = (uint16)getMs();
   0626 12 16 6C           1218 	lcall	_getMs
   0629 AC 82              1219 	mov	r4,dpl
   062B AD 83              1220 	mov	r5,dph
   062D AE F0              1221 	mov	r6,b
   062F FF                 1222 	mov	r7,a
                    00E9   1223 	C$master_wixel_track.c$156$1$1 ==.
                           1224 ;	apps/master_wixel_track/master_wixel_track.c:156: if (serialRxPulseActive)
   0630 30 00 27           1225 	jnb	_serialRxPulseActive,00105$
                    00EC   1226 	C$master_wixel_track.c$158$2$2 ==.
                           1227 ;	apps/master_wixel_track/master_wixel_track.c:158: if ((uint16)(now - serialRxPulseStart) < SERIAL_RX_PULSE)
   0633 78 11              1228 	mov	r0,#_serialRxPulseStart
   0635 D3                 1229 	setb	c
   0636 E2                 1230 	movx	a,@r0
   0637 9C                 1231 	subb	a,r4
   0638 F4                 1232 	cpl	a
   0639 B3                 1233 	cpl	c
   063A FE                 1234 	mov	r6,a
   063B B3                 1235 	cpl	c
   063C 08                 1236 	inc	r0
   063D E2                 1237 	movx	a,@r0
   063E 9D                 1238 	subb	a,r5
   063F F4                 1239 	cpl	a
   0640 FF                 1240 	mov	r7,a
   0641 C3                 1241 	clr	c
   0642 EE                 1242 	mov	a,r6
   0643 94 64              1243 	subb	a,#0x64
   0645 EF                 1244 	mov	a,r7
   0646 94 00              1245 	subb	a,#0x00
   0648 50 05              1246 	jnc	00102$
                    0103   1247 	C$master_wixel_track.c$160$4$4 ==.
                           1248 ;	apps/master_wixel_track/master_wixel_track.c:160: LED_RED(1);
   064A 43 FF 02           1249 	orl	_P2DIR,#0x02
   064D 80 12              1250 	sjmp	00106$
   064F                    1251 00102$:
                    0108   1252 	C$master_wixel_track.c$164$4$6 ==.
                           1253 ;	apps/master_wixel_track/master_wixel_track.c:164: LED_RED(0);
   064F AF FF              1254 	mov	r7,_P2DIR
   0651 53 07 FD           1255 	anl	ar7,#0xFD
   0654 8F FF              1256 	mov	_P2DIR,r7
                    010F   1257 	C$master_wixel_track.c$165$3$5 ==.
                           1258 ;	apps/master_wixel_track/master_wixel_track.c:165: serialRxPulseActive = 0;
   0656 C2 00              1259 	clr	_serialRxPulseActive
   0658 80 07              1260 	sjmp	00106$
   065A                    1261 00105$:
                    0113   1262 	C$master_wixel_track.c$170$3$8 ==.
                           1263 ;	apps/master_wixel_track/master_wixel_track.c:170: LED_RED(0);
   065A AF FF              1264 	mov	r7,_P2DIR
   065C 53 07 FD           1265 	anl	ar7,#0xFD
   065F 8F FF              1266 	mov	_P2DIR,r7
   0661                    1267 00106$:
                    011A   1268 	C$master_wixel_track.c$174$1$1 ==.
                           1269 ;	apps/master_wixel_track/master_wixel_track.c:174: if (radioTxPulseActive)
   0661 30 01 27           1270 	jnb	_radioTxPulseActive,00111$
                    011D   1271 	C$master_wixel_track.c$176$2$9 ==.
                           1272 ;	apps/master_wixel_track/master_wixel_track.c:176: if ((uint16)(now - radioTxPulseStart) < RADIO_TX_PULSE)
   0664 78 13              1273 	mov	r0,#_radioTxPulseStart
   0666 D3                 1274 	setb	c
   0667 E2                 1275 	movx	a,@r0
   0668 9C                 1276 	subb	a,r4
   0669 F4                 1277 	cpl	a
   066A B3                 1278 	cpl	c
   066B FE                 1279 	mov	r6,a
   066C B3                 1280 	cpl	c
   066D 08                 1281 	inc	r0
   066E E2                 1282 	movx	a,@r0
   066F 9D                 1283 	subb	a,r5
   0670 F4                 1284 	cpl	a
   0671 FF                 1285 	mov	r7,a
   0672 C3                 1286 	clr	c
   0673 EE                 1287 	mov	a,r6
   0674 94 64              1288 	subb	a,#0x64
   0676 EF                 1289 	mov	a,r7
   0677 94 00              1290 	subb	a,#0x00
   0679 50 05              1291 	jnc	00108$
                    0134   1292 	C$master_wixel_track.c$178$4$11 ==.
                           1293 ;	apps/master_wixel_track/master_wixel_track.c:178: LED_GREEN(1);
   067B 43 FF 10           1294 	orl	_P2DIR,#0x10
   067E 80 12              1295 	sjmp	00112$
   0680                    1296 00108$:
                    0139   1297 	C$master_wixel_track.c$182$4$13 ==.
                           1298 ;	apps/master_wixel_track/master_wixel_track.c:182: LED_GREEN(0);
   0680 AF FF              1299 	mov	r7,_P2DIR
   0682 53 07 EF           1300 	anl	ar7,#0xEF
   0685 8F FF              1301 	mov	_P2DIR,r7
                    0140   1302 	C$master_wixel_track.c$183$3$12 ==.
                           1303 ;	apps/master_wixel_track/master_wixel_track.c:183: radioTxPulseActive = 0;
   0687 C2 01              1304 	clr	_radioTxPulseActive
   0689 80 07              1305 	sjmp	00112$
   068B                    1306 00111$:
                    0144   1307 	C$master_wixel_track.c$188$3$15 ==.
                           1308 ;	apps/master_wixel_track/master_wixel_track.c:188: LED_GREEN(0);
   068B AF FF              1309 	mov	r7,_P2DIR
   068D 53 07 EF           1310 	anl	ar7,#0xEF
   0690 8F FF              1311 	mov	_P2DIR,r7
   0692                    1312 00112$:
                    014B   1313 	C$master_wixel_track.c$192$1$1 ==.
                           1314 ;	apps/master_wixel_track/master_wixel_track.c:192: if ((uint16)(now - lastHeartbeatTime) >= HEARTBEAT_PERIOD)
   0692 8C 08              1315 	mov	_updateLeds_sloc0_1_0,r4
   0694 8D 09              1316 	mov	(_updateLeds_sloc0_1_0 + 1),r5
   0696 75 0A 00           1317 	mov	(_updateLeds_sloc0_1_0 + 2),#0x00
   0699 75 0B 00           1318 	mov	(_updateLeds_sloc0_1_0 + 3),#0x00
   069C 78 0D              1319 	mov	r0,#_lastHeartbeatTime
   069E D3                 1320 	setb	c
   069F E2                 1321 	movx	a,@r0
   06A0 95 08              1322 	subb	a,_updateLeds_sloc0_1_0
   06A2 F4                 1323 	cpl	a
   06A3 B3                 1324 	cpl	c
   06A4 FA                 1325 	mov	r2,a
   06A5 B3                 1326 	cpl	c
   06A6 08                 1327 	inc	r0
   06A7 E2                 1328 	movx	a,@r0
   06A8 95 09              1329 	subb	a,(_updateLeds_sloc0_1_0 + 1)
   06AA F4                 1330 	cpl	a
   06AB B3                 1331 	cpl	c
   06AC FB                 1332 	mov	r3,a
   06AD B3                 1333 	cpl	c
   06AE 08                 1334 	inc	r0
   06AF E2                 1335 	movx	a,@r0
   06B0 95 0A              1336 	subb	a,(_updateLeds_sloc0_1_0 + 2)
   06B2 F4                 1337 	cpl	a
   06B3 B3                 1338 	cpl	c
   06B4 FE                 1339 	mov	r6,a
   06B5 B3                 1340 	cpl	c
   06B6 08                 1341 	inc	r0
   06B7 E2                 1342 	movx	a,@r0
   06B8 95 0B              1343 	subb	a,(_updateLeds_sloc0_1_0 + 3)
   06BA F4                 1344 	cpl	a
   06BB FF                 1345 	mov	r7,a
   06BC C3                 1346 	clr	c
   06BD EA                 1347 	mov	a,r2
   06BE 94 F4              1348 	subb	a,#0xF4
   06C0 EB                 1349 	mov	a,r3
   06C1 94 01              1350 	subb	a,#0x01
   06C3 40 14              1351 	jc	00115$
                    017E   1352 	C$master_wixel_track.c$194$3$17 ==.
                           1353 ;	apps/master_wixel_track/master_wixel_track.c:194: LED_YELLOW_TOGGLE();
   06C5 63 FF 04           1354 	xrl	_P2DIR,#0x04
                    0181   1355 	C$master_wixel_track.c$195$2$16 ==.
                           1356 ;	apps/master_wixel_track/master_wixel_track.c:195: lastHeartbeatTime = now;
   06C8 78 0D              1357 	mov	r0,#_lastHeartbeatTime
   06CA E5 08              1358 	mov	a,_updateLeds_sloc0_1_0
   06CC F2                 1359 	movx	@r0,a
   06CD 08                 1360 	inc	r0
   06CE E5 09              1361 	mov	a,(_updateLeds_sloc0_1_0 + 1)
   06D0 F2                 1362 	movx	@r0,a
   06D1 08                 1363 	inc	r0
   06D2 E5 0A              1364 	mov	a,(_updateLeds_sloc0_1_0 + 2)
   06D4 F2                 1365 	movx	@r0,a
   06D5 08                 1366 	inc	r0
   06D6 E5 0B              1367 	mov	a,(_updateLeds_sloc0_1_0 + 3)
   06D8 F2                 1368 	movx	@r0,a
   06D9                    1369 00115$:
                    0192   1370 	C$master_wixel_track.c$197$2$1 ==.
                    0192   1371 	XG$updateLeds$0$0 ==.
   06D9 22                 1372 	ret
                           1373 ;------------------------------------------------------------
                           1374 ;Allocation info for local variables in function 'processSerialPacket'
                           1375 ;------------------------------------------------------------
                    0193   1376 	G$processSerialPacket$0$0 ==.
                    0193   1377 	C$master_wixel_track.c$200$2$1 ==.
                           1378 ;	apps/master_wixel_track/master_wixel_track.c:200: void processSerialPacket()
                           1379 ;	-----------------------------------------
                           1380 ;	 function processSerialPacket
                           1381 ;	-----------------------------------------
   06DA                    1382 _processSerialPacket:
                    0193   1383 	C$master_wixel_track.c$215$1$1 ==.
                           1384 ;	apps/master_wixel_track/master_wixel_track.c:215: responseLength = 0;
   06DA 78 15              1385 	mov	r0,#_responseLength
   06DC E4                 1386 	clr	a
   06DD F2                 1387 	movx	@r0,a
                    0197   1388 	C$master_wixel_track.c$218$1$1 ==.
                           1389 ;	apps/master_wixel_track/master_wixel_track.c:218: if (serialBufferIndex != RADIO_PACKET_SIZE)
   06DE 78 00              1390 	mov	r0,#_serialBufferIndex
   06E0 E2                 1391 	movx	a,@r0
   06E1 B4 40 02           1392 	cjne	a,#0x40,00139$
   06E4 80 3D              1393 	sjmp	00102$
   06E6                    1394 00139$:
                    019F   1395 	C$master_wixel_track.c$220$2$2 ==.
                           1396 ;	apps/master_wixel_track/master_wixel_track.c:220: responseLength = sprintf((char*)serialResponse, "ERROR: Expected 64 bytes, got %d\r\n", serialBufferIndex);
   06E6 78 00              1397 	mov	r0,#_serialBufferIndex
   06E8 E2                 1398 	movx	a,@r0
   06E9 FE                 1399 	mov	r6,a
   06EA 7F 00              1400 	mov	r7,#0x00
   06EC C0 06              1401 	push	ar6
   06EE C0 07              1402 	push	ar7
   06F0 74 32              1403 	mov	a,#__str_0
   06F2 C0 E0              1404 	push	acc
   06F4 74 20              1405 	mov	a,#(__str_0 >> 8)
   06F6 C0 E0              1406 	push	acc
   06F8 74 80              1407 	mov	a,#0x80
   06FA C0 E0              1408 	push	acc
   06FC 74 15              1409 	mov	a,#_serialResponse
   06FE C0 E0              1410 	push	acc
   0700 74 F1              1411 	mov	a,#(_serialResponse >> 8)
   0702 C0 E0              1412 	push	acc
   0704 E4                 1413 	clr	a
   0705 C0 E0              1414 	push	acc
   0707 12 17 95           1415 	lcall	_sprintf
   070A AE 82              1416 	mov	r6,dpl
   070C E5 81              1417 	mov	a,sp
   070E 24 F8              1418 	add	a,#0xf8
   0710 F5 81              1419 	mov	sp,a
   0712 78 15              1420 	mov	r0,#_responseLength
   0714 EE                 1421 	mov	a,r6
   0715 F2                 1422 	movx	@r0,a
                    01CF   1423 	C$master_wixel_track.c$221$2$2 ==.
                           1424 ;	apps/master_wixel_track/master_wixel_track.c:221: usbComTxSend(serialResponse, responseLength);
   0716 78 38              1425 	mov	r0,#_usbComTxSend_PARM_2
   0718 EE                 1426 	mov	a,r6
   0719 F2                 1427 	movx	@r0,a
   071A 90 F1 15           1428 	mov	dptr,#_serialResponse
   071D 12 0E 80           1429 	lcall	_usbComTxSend
                    01D9   1430 	C$master_wixel_track.c$222$2$2 ==.
                           1431 ;	apps/master_wixel_track/master_wixel_track.c:222: return;
   0720 02 0A 50           1432 	ljmp	00124$
   0723                    1433 00102$:
                    01DC   1434 	C$master_wixel_track.c$226$1$1 ==.
                           1435 ;	apps/master_wixel_track/master_wixel_track.c:226: for (slaveIndex = 0; slaveIndex < NUM_SLAVES; slaveIndex++)
   0723 7F 00              1436 	mov	r7,#0x00
   0725 7E 00              1437 	mov	r6,#0x00
   0727                    1438 00116$:
   0727 BE 04 00           1439 	cjne	r6,#0x04,00140$
   072A                    1440 00140$:
   072A 50 5B              1441 	jnc	00119$
                    01E5   1442 	C$master_wixel_track.c$228$2$3 ==.
                           1443 ;	apps/master_wixel_track/master_wixel_track.c:228: uint8 serialOffset = slaveIndex * BYTES_PER_SLAVE;
   072C EE                 1444 	mov	a,r6
   072D C4                 1445 	swap	a
   072E 54 F0              1446 	anl	a,#0xF0
                    01E9   1447 	C$master_wixel_track.c$230$2$3 ==.
                           1448 ;	apps/master_wixel_track/master_wixel_track.c:230: if (serialBuffer[serialOffset + BYTES_PER_SLAVE - 1] != MESSAGE_DELIMITER)
   0730 24 0F              1449 	add	a,#0x0F
   0732 24 B1              1450 	add	a,#_serialBuffer
   0734 F5 82              1451 	mov	dpl,a
   0736 E4                 1452 	clr	a
   0737 34 F0              1453 	addc	a,#(_serialBuffer >> 8)
   0739 F5 83              1454 	mov	dph,a
   073B E0                 1455 	movx	a,@dptr
   073C FD                 1456 	mov	r5,a
   073D BD FF 02           1457 	cjne	r5,#0xFF,00142$
   0740 80 40              1458 	sjmp	00118$
   0742                    1459 00142$:
                    01FB   1460 	C$master_wixel_track.c$232$3$4 ==.
                           1461 ;	apps/master_wixel_track/master_wixel_track.c:232: responseLength = sprintf((char*)serialResponse, "ERROR: Invalid delimiter for slave %d\r\n", slaveIndex + 1);
   0742 8F 04              1462 	mov	ar4,r7
   0744 7D 00              1463 	mov	r5,#0x00
   0746 0C                 1464 	inc	r4
   0747 BC 00 01           1465 	cjne	r4,#0x00,00143$
   074A 0D                 1466 	inc	r5
   074B                    1467 00143$:
   074B C0 04              1468 	push	ar4
   074D C0 05              1469 	push	ar5
   074F 74 55              1470 	mov	a,#__str_1
   0751 C0 E0              1471 	push	acc
   0753 74 20              1472 	mov	a,#(__str_1 >> 8)
   0755 C0 E0              1473 	push	acc
   0757 74 80              1474 	mov	a,#0x80
   0759 C0 E0              1475 	push	acc
   075B 74 15              1476 	mov	a,#_serialResponse
   075D C0 E0              1477 	push	acc
   075F 74 F1              1478 	mov	a,#(_serialResponse >> 8)
   0761 C0 E0              1479 	push	acc
   0763 E4                 1480 	clr	a
   0764 C0 E0              1481 	push	acc
   0766 12 17 95           1482 	lcall	_sprintf
   0769 AC 82              1483 	mov	r4,dpl
   076B E5 81              1484 	mov	a,sp
   076D 24 F8              1485 	add	a,#0xf8
   076F F5 81              1486 	mov	sp,a
   0771 78 15              1487 	mov	r0,#_responseLength
   0773 EC                 1488 	mov	a,r4
   0774 F2                 1489 	movx	@r0,a
                    022E   1490 	C$master_wixel_track.c$233$3$4 ==.
                           1491 ;	apps/master_wixel_track/master_wixel_track.c:233: usbComTxSend(serialResponse, responseLength);
   0775 78 38              1492 	mov	r0,#_usbComTxSend_PARM_2
   0777 EC                 1493 	mov	a,r4
   0778 F2                 1494 	movx	@r0,a
   0779 90 F1 15           1495 	mov	dptr,#_serialResponse
   077C 12 0E 80           1496 	lcall	_usbComTxSend
                    0238   1497 	C$master_wixel_track.c$234$3$4 ==.
                           1498 ;	apps/master_wixel_track/master_wixel_track.c:234: return;
   077F 02 0A 50           1499 	ljmp	00124$
   0782                    1500 00118$:
                    023B   1501 	C$master_wixel_track.c$226$1$1 ==.
                           1502 ;	apps/master_wixel_track/master_wixel_track.c:226: for (slaveIndex = 0; slaveIndex < NUM_SLAVES; slaveIndex++)
   0782 0E                 1503 	inc	r6
   0783 8E 07              1504 	mov	ar7,r6
   0785 80 A0              1505 	sjmp	00116$
   0787                    1506 00119$:
                    0240   1507 	C$master_wixel_track.c$239$1$1 ==.
                           1508 ;	apps/master_wixel_track/master_wixel_track.c:239: for (i = 0; i < RADIO_PACKET_SIZE; i++)
   0787 7F 00              1509 	mov	r7,#0x00
   0789                    1510 00120$:
   0789 BF 40 00           1511 	cjne	r7,#0x40,00144$
   078C                    1512 00144$:
   078C 50 1F              1513 	jnc	00123$
                    0247   1514 	C$master_wixel_track.c$241$2$5 ==.
                           1515 ;	apps/master_wixel_track/master_wixel_track.c:241: txPacket[1 + i] = serialBuffer[i];
   078E EF                 1516 	mov	a,r7
   078F 04                 1517 	inc	a
   0790 FE                 1518 	mov	r6,a
   0791 24 70              1519 	add	a,#_txPacket
   0793 FC                 1520 	mov	r4,a
   0794 E4                 1521 	clr	a
   0795 34 F0              1522 	addc	a,#(_txPacket >> 8)
   0797 FD                 1523 	mov	r5,a
   0798 EF                 1524 	mov	a,r7
   0799 24 B1              1525 	add	a,#_serialBuffer
   079B F5 82              1526 	mov	dpl,a
   079D E4                 1527 	clr	a
   079E 34 F0              1528 	addc	a,#(_serialBuffer >> 8)
   07A0 F5 83              1529 	mov	dph,a
   07A2 E0                 1530 	movx	a,@dptr
   07A3 FB                 1531 	mov	r3,a
   07A4 8C 82              1532 	mov	dpl,r4
   07A6 8D 83              1533 	mov	dph,r5
   07A8 F0                 1534 	movx	@dptr,a
                    0262   1535 	C$master_wixel_track.c$239$1$1 ==.
                           1536 ;	apps/master_wixel_track/master_wixel_track.c:239: for (i = 0; i < RADIO_PACKET_SIZE; i++)
   07A9 8E 07              1537 	mov	ar7,r6
   07AB 80 DC              1538 	sjmp	00120$
   07AD                    1539 00123$:
                    0266   1540 	C$master_wixel_track.c$245$1$1 ==.
                           1541 ;	apps/master_wixel_track/master_wixel_track.c:245: sendRadioPacket();
   07AD 12 05 E9           1542 	lcall	_sendRadioPacket
                    0269   1543 	C$master_wixel_track.c$248$1$1 ==.
                           1544 ;	apps/master_wixel_track/master_wixel_track.c:248: serialRxPulseActive = 1;
   07B0 D2 00              1545 	setb	_serialRxPulseActive
                    026B   1546 	C$master_wixel_track.c$249$1$1 ==.
                           1547 ;	apps/master_wixel_track/master_wixel_track.c:249: serialRxPulseStart = (uint16)getMs();
   07B2 12 16 6C           1548 	lcall	_getMs
   07B5 AC 82              1549 	mov	r4,dpl
   07B7 AD 83              1550 	mov	r5,dph
   07B9 78 11              1551 	mov	r0,#_serialRxPulseStart
   07BB EC                 1552 	mov	a,r4
   07BC F2                 1553 	movx	@r0,a
   07BD 08                 1554 	inc	r0
   07BE ED                 1555 	mov	a,r5
   07BF F2                 1556 	movx	@r0,a
                    0279   1557 	C$master_wixel_track.c$251$1$1 ==.
                           1558 ;	apps/master_wixel_track/master_wixel_track.c:251: lastSerialRxTime = getMs();
   07C0 12 16 6C           1559 	lcall	_getMs
   07C3 AC 82              1560 	mov	r4,dpl
   07C5 AD 83              1561 	mov	r5,dph
   07C7 AE F0              1562 	mov	r6,b
   07C9 FF                 1563 	mov	r7,a
   07CA 78 05              1564 	mov	r0,#_lastSerialRxTime
   07CC EC                 1565 	mov	a,r4
   07CD F2                 1566 	movx	@r0,a
   07CE 08                 1567 	inc	r0
   07CF ED                 1568 	mov	a,r5
   07D0 F2                 1569 	movx	@r0,a
   07D1 08                 1570 	inc	r0
   07D2 EE                 1571 	mov	a,r6
   07D3 F2                 1572 	movx	@r0,a
   07D4 08                 1573 	inc	r0
   07D5 EF                 1574 	mov	a,r7
   07D6 F2                 1575 	movx	@r0,a
                    0290   1576 	C$master_wixel_track.c$256$1$1 ==.
                           1577 ;	apps/master_wixel_track/master_wixel_track.c:256: posX = (int16)((serialBuffer[1] << 8) | serialBuffer[2]);
   07D7 90 F0 B2           1578 	mov	dptr,#(_serialBuffer + 0x0001)
   07DA E0                 1579 	movx	a,@dptr
   07DB FE                 1580 	mov	r6,a
   07DC 7F 00              1581 	mov	r7,#0x00
   07DE 90 F0 B3           1582 	mov	dptr,#(_serialBuffer + 0x0002)
   07E1 E0                 1583 	movx	a,@dptr
   07E2 FD                 1584 	mov	r5,a
   07E3 7C 00              1585 	mov	r4,#0x00
   07E5 78 20              1586 	mov	r0,#_processSerialPacket_posX_1_1
   07E7 ED                 1587 	mov	a,r5
   07E8 4F                 1588 	orl	a,r7
   07E9 F2                 1589 	movx	@r0,a
   07EA EC                 1590 	mov	a,r4
   07EB 4E                 1591 	orl	a,r6
   07EC 08                 1592 	inc	r0
   07ED F2                 1593 	movx	@r0,a
                    02A7   1594 	C$master_wixel_track.c$257$1$1 ==.
                           1595 ;	apps/master_wixel_track/master_wixel_track.c:257: posY = (int16)((serialBuffer[3] << 8) | serialBuffer[4]);
   07EE 90 F0 B4           1596 	mov	dptr,#(_serialBuffer + 0x0003)
   07F1 E0                 1597 	movx	a,@dptr
   07F2 FC                 1598 	mov	r4,a
   07F3 7D 00              1599 	mov	r5,#0x00
   07F5 90 F0 B5           1600 	mov	dptr,#(_serialBuffer + 0x0004)
   07F8 E0                 1601 	movx	a,@dptr
   07F9 7A 00              1602 	mov	r2,#0x00
   07FB 42 05              1603 	orl	ar5,a
   07FD EA                 1604 	mov	a,r2
   07FE 42 04              1605 	orl	ar4,a
                    02B9   1606 	C$master_wixel_track.c$258$1$1 ==.
                           1607 ;	apps/master_wixel_track/master_wixel_track.c:258: theta = (int8)(serialBuffer[5]);
   0800 90 F0 B6           1608 	mov	dptr,#(_serialBuffer + 0x0005)
   0803 E0                 1609 	movx	a,@dptr
   0804 FB                 1610 	mov	r3,a
   0805 78 1B              1611 	mov	r0,#_theta
   0807 F2                 1612 	movx	@r0,a
                    02C1   1613 	C$master_wixel_track.c$261$1$1 ==.
                           1614 ;	apps/master_wixel_track/master_wixel_track.c:261: if (serialBuffer[6] != CMD_AUX)
   0808 90 F0 B7           1615 	mov	dptr,#(_serialBuffer + 0x0006)
   080B E0                 1616 	movx	a,@dptr
   080C FA                 1617 	mov	r2,a
   080D BA 14 03           1618 	cjne	r2,#0x14,00146$
   0810 02 0A 0A           1619 	ljmp	00114$
   0813                    1620 00146$:
                    02CC   1621 	C$master_wixel_track.c$263$1$1 ==.
                           1622 ;	apps/master_wixel_track/master_wixel_track.c:263: cmd = serialBuffer[6];
   0813 C0 05              1623 	push	ar5
   0815 C0 04              1624 	push	ar4
                    02D0   1625 	C$master_wixel_track.c$264$2$6 ==.
                           1626 ;	apps/master_wixel_track/master_wixel_track.c:264: data3 = (int16)((serialBuffer[7] << 8) | serialBuffer[8]);
   0817 90 F0 B8           1627 	mov	dptr,#(_serialBuffer + 0x0007)
   081A E0                 1628 	movx	a,@dptr
   081B FC                 1629 	mov	r4,a
   081C 7D 00              1630 	mov	r5,#0x00
   081E 90 F0 B9           1631 	mov	dptr,#(_serialBuffer + 0x0008)
   0821 E0                 1632 	movx	a,@dptr
   0822 FF                 1633 	mov	r7,a
   0823 7E 00              1634 	mov	r6,#0x00
   0825 78 1C              1635 	mov	r0,#_processSerialPacket_data3_1_1
   0827 EF                 1636 	mov	a,r7
   0828 4D                 1637 	orl	a,r5
   0829 F2                 1638 	movx	@r0,a
   082A EE                 1639 	mov	a,r6
   082B 4C                 1640 	orl	a,r4
   082C 08                 1641 	inc	r0
   082D F2                 1642 	movx	@r0,a
                    02E7   1643 	C$master_wixel_track.c$265$2$6 ==.
                           1644 ;	apps/master_wixel_track/master_wixel_track.c:265: data4 = (int16)((serialBuffer[9] << 8) | serialBuffer[10]);
   082E 90 F0 BA           1645 	mov	dptr,#(_serialBuffer + 0x0009)
   0831 E0                 1646 	movx	a,@dptr
   0832 FE                 1647 	mov	r6,a
   0833 7F 00              1648 	mov	r7,#0x00
   0835 90 F0 BB           1649 	mov	dptr,#(_serialBuffer + 0x000a)
   0838 E0                 1650 	movx	a,@dptr
   0839 FD                 1651 	mov	r5,a
   083A 7C 00              1652 	mov	r4,#0x00
   083C 78 1E              1653 	mov	r0,#_processSerialPacket_data4_1_1
   083E ED                 1654 	mov	a,r5
   083F 4F                 1655 	orl	a,r7
   0840 F2                 1656 	movx	@r0,a
   0841 EC                 1657 	mov	a,r4
   0842 4E                 1658 	orl	a,r6
   0843 08                 1659 	inc	r0
   0844 F2                 1660 	movx	@r0,a
                    02FE   1661 	C$master_wixel_track.c$268$2$6 ==.
                           1662 ;	apps/master_wixel_track/master_wixel_track.c:268: switch(cmd)
   0845 BA 10 06           1663 	cjne	r2,#0x10,00147$
   0848 D0 04              1664 	pop	ar4
   084A D0 05              1665 	pop	ar5
   084C 80 23              1666 	sjmp	00105$
   084E                    1667 00147$:
   084E D0 04              1668 	pop	ar4
   0850 D0 05              1669 	pop	ar5
   0852 BA 11 02           1670 	cjne	r2,#0x11,00148$
   0855 80 46              1671 	sjmp	00106$
   0857                    1672 00148$:
   0857 BA 12 02           1673 	cjne	r2,#0x12,00149$
   085A 80 6D              1674 	sjmp	00107$
   085C                    1675 00149$:
   085C BA 13 03           1676 	cjne	r2,#0x13,00150$
   085F 02 08 F5           1677 	ljmp	00108$
   0862                    1678 00150$:
   0862 BA 14 03           1679 	cjne	r2,#0x14,00151$
   0865 02 09 21           1680 	ljmp	00109$
   0868                    1681 00151$:
   0868 BA 15 03           1682 	cjne	r2,#0x15,00152$
   086B 02 09 4C           1683 	ljmp	00110$
   086E                    1684 00152$:
   086E 02 09 77           1685 	ljmp	00111$
                    032A   1686 	C$master_wixel_track.c$270$3$7 ==.
                           1687 ;	apps/master_wixel_track/master_wixel_track.c:270: case CMD_STOP:
   0871                    1688 00105$:
                    032A   1689 	C$master_wixel_track.c$271$3$7 ==.
                           1690 ;	apps/master_wixel_track/master_wixel_track.c:271: sprintf(cmdStr, "STOP");
   0871 C0 05              1691 	push	ar5
   0873 C0 04              1692 	push	ar4
   0875 74 7D              1693 	mov	a,#__str_2
   0877 C0 E0              1694 	push	acc
   0879 74 20              1695 	mov	a,#(__str_2 >> 8)
   087B C0 E0              1696 	push	acc
   087D 74 80              1697 	mov	a,#0x80
   087F C0 E0              1698 	push	acc
   0881 74 22              1699 	mov	a,#_processSerialPacket_cmdStr_1_1
   0883 C0 E0              1700 	push	acc
   0885 74 F0              1701 	mov	a,#(_processSerialPacket_cmdStr_1_1 >> 8)
   0887 C0 E0              1702 	push	acc
   0889 74 60              1703 	mov	a,#0x60
   088B C0 E0              1704 	push	acc
   088D 12 17 95           1705 	lcall	_sprintf
   0890 E5 81              1706 	mov	a,sp
   0892 24 FA              1707 	add	a,#0xfa
   0894 F5 81              1708 	mov	sp,a
   0896 D0 04              1709 	pop	ar4
   0898 D0 05              1710 	pop	ar5
                    0353   1711 	C$master_wixel_track.c$272$3$7 ==.
                           1712 ;	apps/master_wixel_track/master_wixel_track.c:272: break;
   089A 02 09 A0           1713 	ljmp	00112$
                    0356   1714 	C$master_wixel_track.c$273$3$7 ==.
                           1715 ;	apps/master_wixel_track/master_wixel_track.c:273: case CMD_GO_TO:
   089D                    1716 00106$:
                    0356   1717 	C$master_wixel_track.c$274$3$7 ==.
                           1718 ;	apps/master_wixel_track/master_wixel_track.c:274: sprintf(cmdStr, "GO_TO");
   089D C0 05              1719 	push	ar5
   089F C0 04              1720 	push	ar4
   08A1 74 82              1721 	mov	a,#__str_3
   08A3 C0 E0              1722 	push	acc
   08A5 74 20              1723 	mov	a,#(__str_3 >> 8)
   08A7 C0 E0              1724 	push	acc
   08A9 74 80              1725 	mov	a,#0x80
   08AB C0 E0              1726 	push	acc
   08AD 74 22              1727 	mov	a,#_processSerialPacket_cmdStr_1_1
   08AF C0 E0              1728 	push	acc
   08B1 74 F0              1729 	mov	a,#(_processSerialPacket_cmdStr_1_1 >> 8)
   08B3 C0 E0              1730 	push	acc
   08B5 74 60              1731 	mov	a,#0x60
   08B7 C0 E0              1732 	push	acc
   08B9 12 17 95           1733 	lcall	_sprintf
   08BC E5 81              1734 	mov	a,sp
   08BE 24 FA              1735 	add	a,#0xfa
   08C0 F5 81              1736 	mov	sp,a
   08C2 D0 04              1737 	pop	ar4
   08C4 D0 05              1738 	pop	ar5
                    037F   1739 	C$master_wixel_track.c$275$3$7 ==.
                           1740 ;	apps/master_wixel_track/master_wixel_track.c:275: break;
   08C6 02 09 A0           1741 	ljmp	00112$
                    0382   1742 	C$master_wixel_track.c$276$3$7 ==.
                           1743 ;	apps/master_wixel_track/master_wixel_track.c:276: case CMD_PREP:
   08C9                    1744 00107$:
                    0382   1745 	C$master_wixel_track.c$277$3$7 ==.
                           1746 ;	apps/master_wixel_track/master_wixel_track.c:277: sprintf(cmdStr, "PREP");
   08C9 C0 05              1747 	push	ar5
   08CB C0 04              1748 	push	ar4
   08CD 74 88              1749 	mov	a,#__str_4
   08CF C0 E0              1750 	push	acc
   08D1 74 20              1751 	mov	a,#(__str_4 >> 8)
   08D3 C0 E0              1752 	push	acc
   08D5 74 80              1753 	mov	a,#0x80
   08D7 C0 E0              1754 	push	acc
   08D9 74 22              1755 	mov	a,#_processSerialPacket_cmdStr_1_1
   08DB C0 E0              1756 	push	acc
   08DD 74 F0              1757 	mov	a,#(_processSerialPacket_cmdStr_1_1 >> 8)
   08DF C0 E0              1758 	push	acc
   08E1 74 60              1759 	mov	a,#0x60
   08E3 C0 E0              1760 	push	acc
   08E5 12 17 95           1761 	lcall	_sprintf
   08E8 E5 81              1762 	mov	a,sp
   08EA 24 FA              1763 	add	a,#0xfa
   08EC F5 81              1764 	mov	sp,a
   08EE D0 04              1765 	pop	ar4
   08F0 D0 05              1766 	pop	ar5
                    03AB   1767 	C$master_wixel_track.c$278$3$7 ==.
                           1768 ;	apps/master_wixel_track/master_wixel_track.c:278: break;
   08F2 02 09 A0           1769 	ljmp	00112$
                    03AE   1770 	C$master_wixel_track.c$279$3$7 ==.
                           1771 ;	apps/master_wixel_track/master_wixel_track.c:279: case CMD_RUN:
   08F5                    1772 00108$:
                    03AE   1773 	C$master_wixel_track.c$280$3$7 ==.
                           1774 ;	apps/master_wixel_track/master_wixel_track.c:280: sprintf(cmdStr, "RUN");
   08F5 C0 05              1775 	push	ar5
   08F7 C0 04              1776 	push	ar4
   08F9 74 8D              1777 	mov	a,#__str_5
   08FB C0 E0              1778 	push	acc
   08FD 74 20              1779 	mov	a,#(__str_5 >> 8)
   08FF C0 E0              1780 	push	acc
   0901 74 80              1781 	mov	a,#0x80
   0903 C0 E0              1782 	push	acc
   0905 74 22              1783 	mov	a,#_processSerialPacket_cmdStr_1_1
   0907 C0 E0              1784 	push	acc
   0909 74 F0              1785 	mov	a,#(_processSerialPacket_cmdStr_1_1 >> 8)
   090B C0 E0              1786 	push	acc
   090D 74 60              1787 	mov	a,#0x60
   090F C0 E0              1788 	push	acc
   0911 12 17 95           1789 	lcall	_sprintf
   0914 E5 81              1790 	mov	a,sp
   0916 24 FA              1791 	add	a,#0xfa
   0918 F5 81              1792 	mov	sp,a
   091A D0 04              1793 	pop	ar4
   091C D0 05              1794 	pop	ar5
                    03D7   1795 	C$master_wixel_track.c$281$3$7 ==.
                           1796 ;	apps/master_wixel_track/master_wixel_track.c:281: break;
   091E 02 09 A0           1797 	ljmp	00112$
                    03DA   1798 	C$master_wixel_track.c$282$3$7 ==.
                           1799 ;	apps/master_wixel_track/master_wixel_track.c:282: case CMD_AUX:
   0921                    1800 00109$:
                    03DA   1801 	C$master_wixel_track.c$283$3$7 ==.
                           1802 ;	apps/master_wixel_track/master_wixel_track.c:283: sprintf(cmdStr, "AUX");
   0921 C0 05              1803 	push	ar5
   0923 C0 04              1804 	push	ar4
   0925 74 91              1805 	mov	a,#__str_6
   0927 C0 E0              1806 	push	acc
   0929 74 20              1807 	mov	a,#(__str_6 >> 8)
   092B C0 E0              1808 	push	acc
   092D 74 80              1809 	mov	a,#0x80
   092F C0 E0              1810 	push	acc
   0931 74 22              1811 	mov	a,#_processSerialPacket_cmdStr_1_1
   0933 C0 E0              1812 	push	acc
   0935 74 F0              1813 	mov	a,#(_processSerialPacket_cmdStr_1_1 >> 8)
   0937 C0 E0              1814 	push	acc
   0939 74 60              1815 	mov	a,#0x60
   093B C0 E0              1816 	push	acc
   093D 12 17 95           1817 	lcall	_sprintf
   0940 E5 81              1818 	mov	a,sp
   0942 24 FA              1819 	add	a,#0xfa
   0944 F5 81              1820 	mov	sp,a
   0946 D0 04              1821 	pop	ar4
   0948 D0 05              1822 	pop	ar5
                    0403   1823 	C$master_wixel_track.c$284$3$7 ==.
                           1824 ;	apps/master_wixel_track/master_wixel_track.c:284: break;
                    0403   1825 	C$master_wixel_track.c$285$3$7 ==.
                           1826 ;	apps/master_wixel_track/master_wixel_track.c:285: case CMD_CALIBRATE:
   094A 80 54              1827 	sjmp	00112$
   094C                    1828 00110$:
                    0405   1829 	C$master_wixel_track.c$286$3$7 ==.
                           1830 ;	apps/master_wixel_track/master_wixel_track.c:286: sprintf(cmdStr, "CALIBRATE");
   094C C0 05              1831 	push	ar5
   094E C0 04              1832 	push	ar4
   0950 74 95              1833 	mov	a,#__str_7
   0952 C0 E0              1834 	push	acc
   0954 74 20              1835 	mov	a,#(__str_7 >> 8)
   0956 C0 E0              1836 	push	acc
   0958 74 80              1837 	mov	a,#0x80
   095A C0 E0              1838 	push	acc
   095C 74 22              1839 	mov	a,#_processSerialPacket_cmdStr_1_1
   095E C0 E0              1840 	push	acc
   0960 74 F0              1841 	mov	a,#(_processSerialPacket_cmdStr_1_1 >> 8)
   0962 C0 E0              1842 	push	acc
   0964 74 60              1843 	mov	a,#0x60
   0966 C0 E0              1844 	push	acc
   0968 12 17 95           1845 	lcall	_sprintf
   096B E5 81              1846 	mov	a,sp
   096D 24 FA              1847 	add	a,#0xfa
   096F F5 81              1848 	mov	sp,a
   0971 D0 04              1849 	pop	ar4
   0973 D0 05              1850 	pop	ar5
                    042E   1851 	C$master_wixel_track.c$287$3$7 ==.
                           1852 ;	apps/master_wixel_track/master_wixel_track.c:287: break;
                    042E   1853 	C$master_wixel_track.c$288$3$7 ==.
                           1854 ;	apps/master_wixel_track/master_wixel_track.c:288: default:
   0975 80 29              1855 	sjmp	00112$
   0977                    1856 00111$:
                    0430   1857 	C$master_wixel_track.c$289$3$7 ==.
                           1858 ;	apps/master_wixel_track/master_wixel_track.c:289: sprintf(cmdStr, "UNKNOWN");
   0977 C0 05              1859 	push	ar5
   0979 C0 04              1860 	push	ar4
   097B 74 9F              1861 	mov	a,#__str_8
   097D C0 E0              1862 	push	acc
   097F 74 20              1863 	mov	a,#(__str_8 >> 8)
   0981 C0 E0              1864 	push	acc
   0983 74 80              1865 	mov	a,#0x80
   0985 C0 E0              1866 	push	acc
   0987 74 22              1867 	mov	a,#_processSerialPacket_cmdStr_1_1
   0989 C0 E0              1868 	push	acc
   098B 74 F0              1869 	mov	a,#(_processSerialPacket_cmdStr_1_1 >> 8)
   098D C0 E0              1870 	push	acc
   098F 74 60              1871 	mov	a,#0x60
   0991 C0 E0              1872 	push	acc
   0993 12 17 95           1873 	lcall	_sprintf
   0996 E5 81              1874 	mov	a,sp
   0998 24 FA              1875 	add	a,#0xfa
   099A F5 81              1876 	mov	sp,a
   099C D0 04              1877 	pop	ar4
   099E D0 05              1878 	pop	ar5
                    0459   1879 	C$master_wixel_track.c$290$2$6 ==.
                           1880 ;	apps/master_wixel_track/master_wixel_track.c:290: }
   09A0                    1881 00112$:
                    0459   1882 	C$master_wixel_track.c$298$2$6 ==.
                           1883 ;	apps/master_wixel_track/master_wixel_track.c:298: cmdStr,
                    0459   1884 	C$master_wixel_track.c$297$2$6 ==.
                           1885 ;	apps/master_wixel_track/master_wixel_track.c:297: theta,
   09A0 78 1B              1886 	mov	r0,#_theta
   09A2 E2                 1887 	movx	a,@r0
   09A3 FE                 1888 	mov	r6,a
   09A4 E2                 1889 	movx	a,@r0
   09A5 33                 1890 	rlc	a
   09A6 95 E0              1891 	subb	a,acc
   09A8 FF                 1892 	mov	r7,a
                    0462   1893 	C$master_wixel_track.c$294$2$6 ==.
                           1894 ;	apps/master_wixel_track/master_wixel_track.c:294: "Slave 1 Pos: (%d, %d, %d) CMD %s %d, %d, etc\r\n",
                    0462   1895 	C$master_wixel_track.c$293$2$6 ==.
                           1896 ;	apps/master_wixel_track/master_wixel_track.c:293: responseLength = sprintf((char*)serialResponse, 
   09A9 78 1E              1897 	mov	r0,#_processSerialPacket_data4_1_1
   09AB E2                 1898 	movx	a,@r0
   09AC C0 E0              1899 	push	acc
   09AE 08                 1900 	inc	r0
   09AF E2                 1901 	movx	a,@r0
   09B0 C0 E0              1902 	push	acc
   09B2 78 1C              1903 	mov	r0,#_processSerialPacket_data3_1_1
   09B4 E2                 1904 	movx	a,@r0
   09B5 C0 E0              1905 	push	acc
   09B7 08                 1906 	inc	r0
   09B8 E2                 1907 	movx	a,@r0
   09B9 C0 E0              1908 	push	acc
   09BB 74 22              1909 	mov	a,#_processSerialPacket_cmdStr_1_1
   09BD C0 E0              1910 	push	acc
   09BF 74 F0              1911 	mov	a,#(_processSerialPacket_cmdStr_1_1 >> 8)
   09C1 C0 E0              1912 	push	acc
   09C3 74 60              1913 	mov	a,#0x60
   09C5 C0 E0              1914 	push	acc
   09C7 C0 06              1915 	push	ar6
   09C9 C0 07              1916 	push	ar7
   09CB C0 05              1917 	push	ar5
   09CD C0 04              1918 	push	ar4
   09CF 78 20              1919 	mov	r0,#_processSerialPacket_posX_1_1
   09D1 E2                 1920 	movx	a,@r0
   09D2 C0 E0              1921 	push	acc
   09D4 08                 1922 	inc	r0
   09D5 E2                 1923 	movx	a,@r0
   09D6 C0 E0              1924 	push	acc
   09D8 74 A7              1925 	mov	a,#__str_9
   09DA C0 E0              1926 	push	acc
   09DC 74 20              1927 	mov	a,#(__str_9 >> 8)
   09DE C0 E0              1928 	push	acc
   09E0 74 80              1929 	mov	a,#0x80
   09E2 C0 E0              1930 	push	acc
   09E4 74 15              1931 	mov	a,#_serialResponse
   09E6 C0 E0              1932 	push	acc
   09E8 74 F1              1933 	mov	a,#(_serialResponse >> 8)
   09EA C0 E0              1934 	push	acc
   09EC E4                 1935 	clr	a
   09ED C0 E0              1936 	push	acc
   09EF 12 17 95           1937 	lcall	_sprintf
   09F2 AE 82              1938 	mov	r6,dpl
   09F4 E5 81              1939 	mov	a,sp
   09F6 24 ED              1940 	add	a,#0xed
   09F8 F5 81              1941 	mov	sp,a
   09FA 78 15              1942 	mov	r0,#_responseLength
   09FC EE                 1943 	mov	a,r6
   09FD F2                 1944 	movx	@r0,a
                    04B7   1945 	C$master_wixel_track.c$300$2$6 ==.
                           1946 ;	apps/master_wixel_track/master_wixel_track.c:300: usbComTxSend(serialResponse, responseLength);
   09FE 78 38              1947 	mov	r0,#_usbComTxSend_PARM_2
   0A00 EE                 1948 	mov	a,r6
   0A01 F2                 1949 	movx	@r0,a
   0A02 90 F1 15           1950 	mov	dptr,#_serialResponse
   0A05 12 0E 80           1951 	lcall	_usbComTxSend
   0A08 80 46              1952 	sjmp	00124$
   0A0A                    1953 00114$:
                    04C3   1954 	C$master_wixel_track.c$311$2$8 ==.
                           1955 ;	apps/master_wixel_track/master_wixel_track.c:311: theta);
   0A0A EB                 1956 	mov	a,r3
   0A0B 33                 1957 	rlc	a
   0A0C 95 E0              1958 	subb	a,acc
   0A0E FF                 1959 	mov	r7,a
                    04C8   1960 	C$master_wixel_track.c$308$2$8 ==.
                           1961 ;	apps/master_wixel_track/master_wixel_track.c:308: "AUX: Slave 1 Pos: (%d, %d, %d)\r\n",
                    04C8   1962 	C$master_wixel_track.c$307$2$8 ==.
                           1963 ;	apps/master_wixel_track/master_wixel_track.c:307: responseLength = sprintf((char*)serialResponse, 
   0A0F C0 03              1964 	push	ar3
   0A11 C0 07              1965 	push	ar7
   0A13 C0 05              1966 	push	ar5
   0A15 C0 04              1967 	push	ar4
   0A17 78 20              1968 	mov	r0,#_processSerialPacket_posX_1_1
   0A19 E2                 1969 	movx	a,@r0
   0A1A C0 E0              1970 	push	acc
   0A1C 08                 1971 	inc	r0
   0A1D E2                 1972 	movx	a,@r0
   0A1E C0 E0              1973 	push	acc
   0A20 74 D6              1974 	mov	a,#__str_10
   0A22 C0 E0              1975 	push	acc
   0A24 74 20              1976 	mov	a,#(__str_10 >> 8)
   0A26 C0 E0              1977 	push	acc
   0A28 74 80              1978 	mov	a,#0x80
   0A2A C0 E0              1979 	push	acc
   0A2C 74 15              1980 	mov	a,#_serialResponse
   0A2E C0 E0              1981 	push	acc
   0A30 74 F1              1982 	mov	a,#(_serialResponse >> 8)
   0A32 C0 E0              1983 	push	acc
   0A34 E4                 1984 	clr	a
   0A35 C0 E0              1985 	push	acc
   0A37 12 17 95           1986 	lcall	_sprintf
   0A3A AE 82              1987 	mov	r6,dpl
   0A3C E5 81              1988 	mov	a,sp
   0A3E 24 F4              1989 	add	a,#0xf4
   0A40 F5 81              1990 	mov	sp,a
   0A42 78 15              1991 	mov	r0,#_responseLength
   0A44 EE                 1992 	mov	a,r6
   0A45 F2                 1993 	movx	@r0,a
                    04FF   1994 	C$master_wixel_track.c$312$2$8 ==.
                           1995 ;	apps/master_wixel_track/master_wixel_track.c:312: usbComTxSend(serialResponse, responseLength);
   0A46 78 38              1996 	mov	r0,#_usbComTxSend_PARM_2
   0A48 EE                 1997 	mov	a,r6
   0A49 F2                 1998 	movx	@r0,a
   0A4A 90 F1 15           1999 	mov	dptr,#_serialResponse
   0A4D 12 0E 80           2000 	lcall	_usbComTxSend
   0A50                    2001 00124$:
                    0509   2002 	C$master_wixel_track.c$314$1$1 ==.
                    0509   2003 	XG$processSerialPacket$0$0 ==.
   0A50 22                 2004 	ret
                           2005 ;------------------------------------------------------------
                           2006 ;Allocation info for local variables in function 'handleSerialTimeout'
                           2007 ;------------------------------------------------------------
                    050A   2008 	G$handleSerialTimeout$0$0 ==.
                    050A   2009 	C$master_wixel_track.c$317$1$1 ==.
                           2010 ;	apps/master_wixel_track/master_wixel_track.c:317: void handleSerialTimeout()
                           2011 ;	-----------------------------------------
                           2012 ;	 function handleSerialTimeout
                           2013 ;	-----------------------------------------
   0A51                    2014 _handleSerialTimeout:
                    050A   2015 	C$master_wixel_track.c$319$1$1 ==.
                           2016 ;	apps/master_wixel_track/master_wixel_track.c:319: uint32 timeSinceLastRx = getMs() - lastSerialRxTime;
   0A51 12 16 6C           2017 	lcall	_getMs
   0A54 AC 82              2018 	mov	r4,dpl
   0A56 AD 83              2019 	mov	r5,dph
   0A58 AE F0              2020 	mov	r6,b
   0A5A FF                 2021 	mov	r7,a
   0A5B 78 05              2022 	mov	r0,#_lastSerialRxTime
   0A5D D3                 2023 	setb	c
   0A5E E2                 2024 	movx	a,@r0
   0A5F 9C                 2025 	subb	a,r4
   0A60 F4                 2026 	cpl	a
   0A61 B3                 2027 	cpl	c
   0A62 FC                 2028 	mov	r4,a
   0A63 B3                 2029 	cpl	c
   0A64 08                 2030 	inc	r0
   0A65 E2                 2031 	movx	a,@r0
   0A66 9D                 2032 	subb	a,r5
   0A67 F4                 2033 	cpl	a
   0A68 B3                 2034 	cpl	c
   0A69 FD                 2035 	mov	r5,a
   0A6A B3                 2036 	cpl	c
   0A6B 08                 2037 	inc	r0
   0A6C E2                 2038 	movx	a,@r0
   0A6D 9E                 2039 	subb	a,r6
   0A6E F4                 2040 	cpl	a
   0A6F B3                 2041 	cpl	c
   0A70 FE                 2042 	mov	r6,a
   0A71 B3                 2043 	cpl	c
   0A72 08                 2044 	inc	r0
   0A73 E2                 2045 	movx	a,@r0
   0A74 9F                 2046 	subb	a,r7
   0A75 F4                 2047 	cpl	a
   0A76 FF                 2048 	mov	r7,a
                    0530   2049 	C$master_wixel_track.c$321$1$1 ==.
                           2050 ;	apps/master_wixel_track/master_wixel_track.c:321: if (timeSinceLastRx >= SERIAL_RX_TIMEOUT)
   0A77 C3                 2051 	clr	c
   0A78 EC                 2052 	mov	a,r4
   0A79 94 60              2053 	subb	a,#0x60
   0A7B ED                 2054 	mov	a,r5
   0A7C 94 EA              2055 	subb	a,#0xEA
   0A7E EE                 2056 	mov	a,r6
   0A7F 94 00              2057 	subb	a,#0x00
   0A81 EF                 2058 	mov	a,r7
   0A82 94 00              2059 	subb	a,#0x00
   0A84 50 03              2060 	jnc	00120$
   0A86 02 0B 71           2061 	ljmp	00111$
   0A89                    2062 00120$:
                    0542   2063 	C$master_wixel_track.c$328$3$3 ==.
                           2064 ;	apps/master_wixel_track/master_wixel_track.c:328: for (slaveIndex = 0; slaveIndex < NUM_SLAVES; slaveIndex++)
   0A89 7F 00              2065 	mov	r7,#0x00
   0A8B                    2066 00107$:
   0A8B BF 04 00           2067 	cjne	r7,#0x04,00121$
   0A8E                    2068 00121$:
   0A8E 40 03              2069 	jc	00122$
   0A90 02 0B 27           2070 	ljmp	00110$
   0A93                    2071 00122$:
                    054C   2072 	C$master_wixel_track.c$330$3$3 ==.
                           2073 ;	apps/master_wixel_track/master_wixel_track.c:330: txOffset = 1 + (slaveIndex * BYTES_PER_SLAVE);
   0A93 EF                 2074 	mov	a,r7
   0A94 C4                 2075 	swap	a
   0A95 54 F0              2076 	anl	a,#0xF0
   0A97 FE                 2077 	mov	r6,a
   0A98 0E                 2078 	inc	r6
                    0552   2079 	C$master_wixel_track.c$332$3$3 ==.
                           2080 ;	apps/master_wixel_track/master_wixel_track.c:332: txPacket[txOffset + 0] = slaveAddresses[slaveIndex];  // ADD
   0A99 EE                 2081 	mov	a,r6
   0A9A 24 70              2082 	add	a,#_txPacket
   0A9C F5 82              2083 	mov	dpl,a
   0A9E E4                 2084 	clr	a
   0A9F 34 F0              2085 	addc	a,#(_txPacket >> 8)
   0AA1 F5 83              2086 	mov	dph,a
   0AA3 EF                 2087 	mov	a,r7
   0AA4 24 01              2088 	add	a,#_slaveAddresses
   0AA6 F9                 2089 	mov	r1,a
   0AA7 E3                 2090 	movx	a,@r1
   0AA8 F0                 2091 	movx	@dptr,a
                    0562   2092 	C$master_wixel_track.c$333$3$3 ==.
                           2093 ;	apps/master_wixel_track/master_wixel_track.c:333: txPacket[txOffset + 1] = 0x00;  // X high
   0AA9 EE                 2094 	mov	a,r6
   0AAA 04                 2095 	inc	a
   0AAB 24 70              2096 	add	a,#_txPacket
   0AAD F5 82              2097 	mov	dpl,a
   0AAF E4                 2098 	clr	a
   0AB0 34 F0              2099 	addc	a,#(_txPacket >> 8)
   0AB2 F5 83              2100 	mov	dph,a
   0AB4 E4                 2101 	clr	a
   0AB5 F0                 2102 	movx	@dptr,a
                    056F   2103 	C$master_wixel_track.c$334$3$3 ==.
                           2104 ;	apps/master_wixel_track/master_wixel_track.c:334: txPacket[txOffset + 2] = 0x00;  // X low
   0AB6 74 02              2105 	mov	a,#0x02
   0AB8 2E                 2106 	add	a,r6
   0AB9 24 70              2107 	add	a,#_txPacket
   0ABB F5 82              2108 	mov	dpl,a
   0ABD E4                 2109 	clr	a
   0ABE 34 F0              2110 	addc	a,#(_txPacket >> 8)
   0AC0 F5 83              2111 	mov	dph,a
   0AC2 E4                 2112 	clr	a
   0AC3 F0                 2113 	movx	@dptr,a
                    057D   2114 	C$master_wixel_track.c$335$3$3 ==.
                           2115 ;	apps/master_wixel_track/master_wixel_track.c:335: txPacket[txOffset + 3] = 0x00;  // Y high
   0AC4 74 03              2116 	mov	a,#0x03
   0AC6 2E                 2117 	add	a,r6
   0AC7 24 70              2118 	add	a,#_txPacket
   0AC9 F5 82              2119 	mov	dpl,a
   0ACB E4                 2120 	clr	a
   0ACC 34 F0              2121 	addc	a,#(_txPacket >> 8)
   0ACE F5 83              2122 	mov	dph,a
   0AD0 E4                 2123 	clr	a
   0AD1 F0                 2124 	movx	@dptr,a
                    058B   2125 	C$master_wixel_track.c$336$3$3 ==.
                           2126 ;	apps/master_wixel_track/master_wixel_track.c:336: txPacket[txOffset + 4] = 0x00;  // Y low
   0AD2 74 04              2127 	mov	a,#0x04
   0AD4 2E                 2128 	add	a,r6
   0AD5 24 70              2129 	add	a,#_txPacket
   0AD7 F5 82              2130 	mov	dpl,a
   0AD9 E4                 2131 	clr	a
   0ADA 34 F0              2132 	addc	a,#(_txPacket >> 8)
   0ADC F5 83              2133 	mov	dph,a
   0ADE E4                 2134 	clr	a
   0ADF F0                 2135 	movx	@dptr,a
                    0599   2136 	C$master_wixel_track.c$337$3$3 ==.
                           2137 ;	apps/master_wixel_track/master_wixel_track.c:337: txPacket[txOffset + 5] = 0x00;  // Theta
   0AE0 74 05              2138 	mov	a,#0x05
   0AE2 2E                 2139 	add	a,r6
   0AE3 24 70              2140 	add	a,#_txPacket
   0AE5 F5 82              2141 	mov	dpl,a
   0AE7 E4                 2142 	clr	a
   0AE8 34 F0              2143 	addc	a,#(_txPacket >> 8)
   0AEA F5 83              2144 	mov	dph,a
   0AEC E4                 2145 	clr	a
   0AED F0                 2146 	movx	@dptr,a
                    05A7   2147 	C$master_wixel_track.c$338$3$3 ==.
                           2148 ;	apps/master_wixel_track/master_wixel_track.c:338: txPacket[txOffset + 6] = CMD_STOP;  // Command
   0AEE 74 06              2149 	mov	a,#0x06
   0AF0 2E                 2150 	add	a,r6
   0AF1 24 70              2151 	add	a,#_txPacket
   0AF3 F5 82              2152 	mov	dpl,a
   0AF5 E4                 2153 	clr	a
   0AF6 34 F0              2154 	addc	a,#(_txPacket >> 8)
   0AF8 F5 83              2155 	mov	dph,a
   0AFA 74 10              2156 	mov	a,#0x10
   0AFC F0                 2157 	movx	@dptr,a
                    05B6   2158 	C$master_wixel_track.c$340$2$1 ==.
                           2159 ;	apps/master_wixel_track/master_wixel_track.c:340: for (i = 7; i < 15; i++)
   0AFD 7D 07              2160 	mov	r5,#0x07
   0AFF                    2161 00103$:
   0AFF BD 0F 00           2162 	cjne	r5,#0x0F,00123$
   0B02                    2163 00123$:
   0B02 50 10              2164 	jnc	00106$
                    05BD   2165 	C$master_wixel_track.c$342$4$4 ==.
                           2166 ;	apps/master_wixel_track/master_wixel_track.c:342: txPacket[txOffset + i] = 0x00;  // Data3-Data13
   0B04 ED                 2167 	mov	a,r5
   0B05 2E                 2168 	add	a,r6
   0B06 24 70              2169 	add	a,#_txPacket
   0B08 F5 82              2170 	mov	dpl,a
   0B0A E4                 2171 	clr	a
   0B0B 34 F0              2172 	addc	a,#(_txPacket >> 8)
   0B0D F5 83              2173 	mov	dph,a
   0B0F E4                 2174 	clr	a
   0B10 F0                 2175 	movx	@dptr,a
                    05CA   2176 	C$master_wixel_track.c$340$3$3 ==.
                           2177 ;	apps/master_wixel_track/master_wixel_track.c:340: for (i = 7; i < 15; i++)
   0B11 0D                 2178 	inc	r5
   0B12 80 EB              2179 	sjmp	00103$
   0B14                    2180 00106$:
                    05CD   2181 	C$master_wixel_track.c$345$3$3 ==.
                           2182 ;	apps/master_wixel_track/master_wixel_track.c:345: txPacket[txOffset + 15] = MESSAGE_DELIMITER;
   0B14 74 0F              2183 	mov	a,#0x0F
   0B16 2E                 2184 	add	a,r6
   0B17 24 70              2185 	add	a,#_txPacket
   0B19 F5 82              2186 	mov	dpl,a
   0B1B E4                 2187 	clr	a
   0B1C 34 F0              2188 	addc	a,#(_txPacket >> 8)
   0B1E F5 83              2189 	mov	dph,a
   0B20 74 FF              2190 	mov	a,#0xFF
   0B22 F0                 2191 	movx	@dptr,a
                    05DC   2192 	C$master_wixel_track.c$328$2$2 ==.
                           2193 ;	apps/master_wixel_track/master_wixel_track.c:328: for (slaveIndex = 0; slaveIndex < NUM_SLAVES; slaveIndex++)
   0B23 0F                 2194 	inc	r7
   0B24 02 0A 8B           2195 	ljmp	00107$
   0B27                    2196 00110$:
                    05E0   2197 	C$master_wixel_track.c$348$2$2 ==.
                           2198 ;	apps/master_wixel_track/master_wixel_track.c:348: sendRadioPacket();
   0B27 12 05 E9           2199 	lcall	_sendRadioPacket
                    05E3   2200 	C$master_wixel_track.c$350$2$2 ==.
                           2201 ;	apps/master_wixel_track/master_wixel_track.c:350: responseLength = sprintf((char*)serialResponse, "[TIMEOUT] No serial data for 60s, sent STOP to all slaves\r\n");
   0B2A 74 F7              2202 	mov	a,#__str_11
   0B2C C0 E0              2203 	push	acc
   0B2E 74 20              2204 	mov	a,#(__str_11 >> 8)
   0B30 C0 E0              2205 	push	acc
   0B32 74 80              2206 	mov	a,#0x80
   0B34 C0 E0              2207 	push	acc
   0B36 74 15              2208 	mov	a,#_serialResponse
   0B38 C0 E0              2209 	push	acc
   0B3A 74 F1              2210 	mov	a,#(_serialResponse >> 8)
   0B3C C0 E0              2211 	push	acc
   0B3E E4                 2212 	clr	a
   0B3F C0 E0              2213 	push	acc
   0B41 12 17 95           2214 	lcall	_sprintf
   0B44 AE 82              2215 	mov	r6,dpl
   0B46 E5 81              2216 	mov	a,sp
   0B48 24 FA              2217 	add	a,#0xfa
   0B4A F5 81              2218 	mov	sp,a
   0B4C 78 15              2219 	mov	r0,#_responseLength
   0B4E EE                 2220 	mov	a,r6
   0B4F F2                 2221 	movx	@r0,a
                    0609   2222 	C$master_wixel_track.c$351$2$2 ==.
                           2223 ;	apps/master_wixel_track/master_wixel_track.c:351: usbComTxSend(serialResponse, responseLength);
   0B50 78 38              2224 	mov	r0,#_usbComTxSend_PARM_2
   0B52 EE                 2225 	mov	a,r6
   0B53 F2                 2226 	movx	@r0,a
   0B54 90 F1 15           2227 	mov	dptr,#_serialResponse
   0B57 12 0E 80           2228 	lcall	_usbComTxSend
                    0613   2229 	C$master_wixel_track.c$353$2$2 ==.
                           2230 ;	apps/master_wixel_track/master_wixel_track.c:353: lastSerialRxTime = getMs();
   0B5A 12 16 6C           2231 	lcall	_getMs
   0B5D AC 82              2232 	mov	r4,dpl
   0B5F AD 83              2233 	mov	r5,dph
   0B61 AE F0              2234 	mov	r6,b
   0B63 FF                 2235 	mov	r7,a
   0B64 78 05              2236 	mov	r0,#_lastSerialRxTime
   0B66 EC                 2237 	mov	a,r4
   0B67 F2                 2238 	movx	@r0,a
   0B68 08                 2239 	inc	r0
   0B69 ED                 2240 	mov	a,r5
   0B6A F2                 2241 	movx	@r0,a
   0B6B 08                 2242 	inc	r0
   0B6C EE                 2243 	mov	a,r6
   0B6D F2                 2244 	movx	@r0,a
   0B6E 08                 2245 	inc	r0
   0B6F EF                 2246 	mov	a,r7
   0B70 F2                 2247 	movx	@r0,a
   0B71                    2248 00111$:
                    062A   2249 	C$master_wixel_track.c$355$2$1 ==.
                    062A   2250 	XG$handleSerialTimeout$0$0 ==.
   0B71 22                 2251 	ret
                           2252 ;------------------------------------------------------------
                           2253 ;Allocation info for local variables in function 'processBytesFromUsb'
                           2254 ;------------------------------------------------------------
                    062B   2255 	G$processBytesFromUsb$0$0 ==.
                    062B   2256 	C$master_wixel_track.c$357$2$1 ==.
                           2257 ;	apps/master_wixel_track/master_wixel_track.c:357: void processBytesFromUsb()
                           2258 ;	-----------------------------------------
                           2259 ;	 function processBytesFromUsb
                           2260 ;	-----------------------------------------
   0B72                    2261 _processBytesFromUsb:
                    062B   2262 	C$master_wixel_track.c$361$2$2 ==.
                           2263 ;	apps/master_wixel_track/master_wixel_track.c:361: while (usbComRxAvailable() && serialBufferIndex < 100)
   0B72                    2264 00104$:
   0B72 12 0D 13           2265 	lcall	_usbComRxAvailable
   0B75 E5 82              2266 	mov	a,dpl
   0B77 60 32              2267 	jz	00107$
   0B79 78 00              2268 	mov	r0,#_serialBufferIndex
   0B7B E2                 2269 	movx	a,@r0
   0B7C B4 64 00           2270 	cjne	a,#0x64,00114$
   0B7F                    2271 00114$:
   0B7F 50 2A              2272 	jnc	00107$
                    063A   2273 	C$master_wixel_track.c$363$2$2 ==.
                           2274 ;	apps/master_wixel_track/master_wixel_track.c:363: byteReceived = usbComRxReceiveByte();
   0B81 12 0D 3D           2275 	lcall	_usbComRxReceiveByte
   0B84 AF 82              2276 	mov	r7,dpl
                    063F   2277 	C$master_wixel_track.c$365$2$2 ==.
                           2278 ;	apps/master_wixel_track/master_wixel_track.c:365: serialBuffer[serialBufferIndex] = byteReceived;
   0B86 78 00              2279 	mov	r0,#_serialBufferIndex
   0B88 E2                 2280 	movx	a,@r0
   0B89 24 B1              2281 	add	a,#_serialBuffer
   0B8B F5 82              2282 	mov	dpl,a
   0B8D E4                 2283 	clr	a
   0B8E 34 F0              2284 	addc	a,#(_serialBuffer >> 8)
   0B90 F5 83              2285 	mov	dph,a
   0B92 EF                 2286 	mov	a,r7
   0B93 F0                 2287 	movx	@dptr,a
                    064D   2288 	C$master_wixel_track.c$366$2$2 ==.
                           2289 ;	apps/master_wixel_track/master_wixel_track.c:366: serialBufferIndex++;
   0B94 78 00              2290 	mov	r0,#_serialBufferIndex
   0B96 E2                 2291 	movx	a,@r0
   0B97 24 01              2292 	add	a,#0x01
   0B99 F2                 2293 	movx	@r0,a
                    0653   2294 	C$master_wixel_track.c$369$2$2 ==.
                           2295 ;	apps/master_wixel_track/master_wixel_track.c:369: if (serialBufferIndex >= RADIO_PACKET_SIZE)
   0B9A 78 00              2296 	mov	r0,#_serialBufferIndex
   0B9C E2                 2297 	movx	a,@r0
   0B9D B4 40 00           2298 	cjne	a,#0x40,00116$
   0BA0                    2299 00116$:
   0BA0 40 D0              2300 	jc	00104$
                    065B   2301 	C$master_wixel_track.c$371$3$3 ==.
                           2302 ;	apps/master_wixel_track/master_wixel_track.c:371: processSerialPacket();
   0BA2 12 06 DA           2303 	lcall	_processSerialPacket
                    065E   2304 	C$master_wixel_track.c$372$3$3 ==.
                           2305 ;	apps/master_wixel_track/master_wixel_track.c:372: serialBufferIndex = 0;
   0BA5 78 00              2306 	mov	r0,#_serialBufferIndex
   0BA7 E4                 2307 	clr	a
   0BA8 F2                 2308 	movx	@r0,a
   0BA9 80 C7              2309 	sjmp	00104$
   0BAB                    2310 00107$:
                    0664   2311 	C$master_wixel_track.c$375$1$1 ==.
                    0664   2312 	XG$processBytesFromUsb$0$0 ==.
   0BAB 22                 2313 	ret
                           2314 ;------------------------------------------------------------
                           2315 ;Allocation info for local variables in function 'initSystems'
                           2316 ;------------------------------------------------------------
                    0665   2317 	G$initSystems$0$0 ==.
                    0665   2318 	C$master_wixel_track.c$379$1$1 ==.
                           2319 ;	apps/master_wixel_track/master_wixel_track.c:379: void initSystems()
                           2320 ;	-----------------------------------------
                           2321 ;	 function initSystems
                           2322 ;	-----------------------------------------
   0BAC                    2323 _initSystems:
                    0665   2324 	C$master_wixel_track.c$381$1$1 ==.
                           2325 ;	apps/master_wixel_track/master_wixel_track.c:381: failSafeBootloader();
   0BAC 12 05 47           2326 	lcall	_failSafeBootloader
                    0668   2327 	C$master_wixel_track.c$382$1$1 ==.
                           2328 ;	apps/master_wixel_track/master_wixel_track.c:382: systemInit();
   0BAF 12 15 6C           2329 	lcall	_systemInit
                    066B   2330 	C$master_wixel_track.c$383$1$1 ==.
                           2331 ;	apps/master_wixel_track/master_wixel_track.c:383: usbInit();
   0BB2 12 0F 06           2332 	lcall	_usbInit
                    066E   2333 	C$master_wixel_track.c$384$1$1 ==.
                           2334 ;	apps/master_wixel_track/master_wixel_track.c:384: radioInit();
   0BB5 12 05 7F           2335 	lcall	_radioInit
                    0671   2336 	C$master_wixel_track.c$386$1$1 ==.
                           2337 ;	apps/master_wixel_track/master_wixel_track.c:386: lastSerialRxTime = getMs();
   0BB8 12 16 6C           2338 	lcall	_getMs
   0BBB AC 82              2339 	mov	r4,dpl
   0BBD AD 83              2340 	mov	r5,dph
   0BBF AE F0              2341 	mov	r6,b
   0BC1 FF                 2342 	mov	r7,a
   0BC2 78 05              2343 	mov	r0,#_lastSerialRxTime
   0BC4 EC                 2344 	mov	a,r4
   0BC5 F2                 2345 	movx	@r0,a
   0BC6 08                 2346 	inc	r0
   0BC7 ED                 2347 	mov	a,r5
   0BC8 F2                 2348 	movx	@r0,a
   0BC9 08                 2349 	inc	r0
   0BCA EE                 2350 	mov	a,r6
   0BCB F2                 2351 	movx	@r0,a
   0BCC 08                 2352 	inc	r0
   0BCD EF                 2353 	mov	a,r7
   0BCE F2                 2354 	movx	@r0,a
                    0688   2355 	C$master_wixel_track.c$387$1$1 ==.
                           2356 ;	apps/master_wixel_track/master_wixel_track.c:387: lastRadioTxTime = getMs();
   0BCF 12 16 6C           2357 	lcall	_getMs
   0BD2 AC 82              2358 	mov	r4,dpl
   0BD4 AD 83              2359 	mov	r5,dph
   0BD6 AE F0              2360 	mov	r6,b
   0BD8 FF                 2361 	mov	r7,a
   0BD9 78 09              2362 	mov	r0,#_lastRadioTxTime
   0BDB EC                 2363 	mov	a,r4
   0BDC F2                 2364 	movx	@r0,a
   0BDD 08                 2365 	inc	r0
   0BDE ED                 2366 	mov	a,r5
   0BDF F2                 2367 	movx	@r0,a
   0BE0 08                 2368 	inc	r0
   0BE1 EE                 2369 	mov	a,r6
   0BE2 F2                 2370 	movx	@r0,a
   0BE3 08                 2371 	inc	r0
   0BE4 EF                 2372 	mov	a,r7
   0BE5 F2                 2373 	movx	@r0,a
                    069F   2374 	C$master_wixel_track.c$388$1$1 ==.
                           2375 ;	apps/master_wixel_track/master_wixel_track.c:388: lastHeartbeatTime = getMs();
   0BE6 12 16 6C           2376 	lcall	_getMs
   0BE9 AC 82              2377 	mov	r4,dpl
   0BEB AD 83              2378 	mov	r5,dph
   0BED AE F0              2379 	mov	r6,b
   0BEF FF                 2380 	mov	r7,a
   0BF0 78 0D              2381 	mov	r0,#_lastHeartbeatTime
   0BF2 EC                 2382 	mov	a,r4
   0BF3 F2                 2383 	movx	@r0,a
   0BF4 08                 2384 	inc	r0
   0BF5 ED                 2385 	mov	a,r5
   0BF6 F2                 2386 	movx	@r0,a
   0BF7 08                 2387 	inc	r0
   0BF8 EE                 2388 	mov	a,r6
   0BF9 F2                 2389 	movx	@r0,a
   0BFA 08                 2390 	inc	r0
   0BFB EF                 2391 	mov	a,r7
   0BFC F2                 2392 	movx	@r0,a
                    06B6   2393 	C$master_wixel_track.c$390$1$1 ==.
                           2394 ;	apps/master_wixel_track/master_wixel_track.c:390: responseLength = sprintf((char*)serialResponse, "Master Wixel Ready - 4 SLAVES HARDCODED (PKTLEN=%d)\r\n", PKTLEN);
   0BFD 90 DF 02           2395 	mov	dptr,#_PKTLEN
   0C00 E0                 2396 	movx	a,@dptr
   0C01 FF                 2397 	mov	r7,a
   0C02 7E 00              2398 	mov	r6,#0x00
   0C04 C0 07              2399 	push	ar7
   0C06 C0 06              2400 	push	ar6
   0C08 74 33              2401 	mov	a,#__str_12
   0C0A C0 E0              2402 	push	acc
   0C0C 74 21              2403 	mov	a,#(__str_12 >> 8)
   0C0E C0 E0              2404 	push	acc
   0C10 74 80              2405 	mov	a,#0x80
   0C12 C0 E0              2406 	push	acc
   0C14 74 15              2407 	mov	a,#_serialResponse
   0C16 C0 E0              2408 	push	acc
   0C18 74 F1              2409 	mov	a,#(_serialResponse >> 8)
   0C1A C0 E0              2410 	push	acc
   0C1C E4                 2411 	clr	a
   0C1D C0 E0              2412 	push	acc
   0C1F 12 17 95           2413 	lcall	_sprintf
   0C22 AE 82              2414 	mov	r6,dpl
   0C24 E5 81              2415 	mov	a,sp
   0C26 24 F8              2416 	add	a,#0xf8
   0C28 F5 81              2417 	mov	sp,a
   0C2A 78 15              2418 	mov	r0,#_responseLength
   0C2C EE                 2419 	mov	a,r6
   0C2D F2                 2420 	movx	@r0,a
                    06E7   2421 	C$master_wixel_track.c$391$1$1 ==.
                           2422 ;	apps/master_wixel_track/master_wixel_track.c:391: usbComTxSend(serialResponse, responseLength);
   0C2E 78 38              2423 	mov	r0,#_usbComTxSend_PARM_2
   0C30 EE                 2424 	mov	a,r6
   0C31 F2                 2425 	movx	@r0,a
   0C32 90 F1 15           2426 	mov	dptr,#_serialResponse
   0C35 12 0E 80           2427 	lcall	_usbComTxSend
                    06F1   2428 	C$master_wixel_track.c$392$1$1 ==.
                    06F1   2429 	XG$initSystems$0$0 ==.
   0C38 22                 2430 	ret
                           2431 ;------------------------------------------------------------
                           2432 ;Allocation info for local variables in function 'main'
                           2433 ;------------------------------------------------------------
                    06F2   2434 	G$main$0$0 ==.
                    06F2   2435 	C$master_wixel_track.c$394$1$1 ==.
                           2436 ;	apps/master_wixel_track/master_wixel_track.c:394: void main()
                           2437 ;	-----------------------------------------
                           2438 ;	 function main
                           2439 ;	-----------------------------------------
   0C39                    2440 _main:
                    06F2   2441 	C$master_wixel_track.c$396$1$1 ==.
                           2442 ;	apps/master_wixel_track/master_wixel_track.c:396: initSystems();
   0C39 12 0B AC           2443 	lcall	_initSystems
                    06F5   2444 	C$master_wixel_track.c$398$1$1 ==.
                           2445 ;	apps/master_wixel_track/master_wixel_track.c:398: while(1)
   0C3C                    2446 00102$:
                    06F5   2447 	C$master_wixel_track.c$400$2$2 ==.
                           2448 ;	apps/master_wixel_track/master_wixel_track.c:400: boardService();
   0C3C 12 15 79           2449 	lcall	_boardService
                    06F8   2450 	C$master_wixel_track.c$401$2$2 ==.
                           2451 ;	apps/master_wixel_track/master_wixel_track.c:401: usbComService();
   0C3F 12 0D A4           2452 	lcall	_usbComService
                    06FB   2453 	C$master_wixel_track.c$403$2$2 ==.
                           2454 ;	apps/master_wixel_track/master_wixel_track.c:403: processBytesFromUsb();
   0C42 12 0B 72           2455 	lcall	_processBytesFromUsb
                    06FE   2456 	C$master_wixel_track.c$404$2$2 ==.
                           2457 ;	apps/master_wixel_track/master_wixel_track.c:404: handleSerialTimeout();
   0C45 12 0A 51           2458 	lcall	_handleSerialTimeout
                    0701   2459 	C$master_wixel_track.c$405$2$2 ==.
                           2460 ;	apps/master_wixel_track/master_wixel_track.c:405: updateLeds();
   0C48 12 06 26           2461 	lcall	_updateLeds
   0C4B 80 EF              2462 	sjmp	00102$
                    0706   2463 	C$master_wixel_track.c$407$1$1 ==.
                    0706   2464 	XG$main$0$0 ==.
   0C4D 22                 2465 	ret
                           2466 	.area CSEG    (CODE)
                           2467 	.area CONST   (CODE)
                    0000   2468 Fmaster_wixel_track$_str_0$0$0 == .
   2032                    2469 __str_0:
   2032 45 52 52 4F 52 3A  2470 	.ascii "ERROR: Expected 64 bytes, got %d"
        20 45 78 70 65 63
        74 65 64 20 36 34
        20 62 79 74 65 73
        2C 20 67 6F 74 20
        25 64
   2052 0D                 2471 	.db 0x0D
   2053 0A                 2472 	.db 0x0A
   2054 00                 2473 	.db 0x00
                    0023   2474 Fmaster_wixel_track$_str_1$0$0 == .
   2055                    2475 __str_1:
   2055 45 52 52 4F 52 3A  2476 	.ascii "ERROR: Invalid delimiter for slave %d"
        20 49 6E 76 61 6C
        69 64 20 64 65 6C
        69 6D 69 74 65 72
        20 66 6F 72 20 73
        6C 61 76 65 20 25
        64
   207A 0D                 2477 	.db 0x0D
   207B 0A                 2478 	.db 0x0A
   207C 00                 2479 	.db 0x00
                    004B   2480 Fmaster_wixel_track$_str_2$0$0 == .
   207D                    2481 __str_2:
   207D 53 54 4F 50        2482 	.ascii "STOP"
   2081 00                 2483 	.db 0x00
                    0050   2484 Fmaster_wixel_track$_str_3$0$0 == .
   2082                    2485 __str_3:
   2082 47 4F 5F 54 4F     2486 	.ascii "GO_TO"
   2087 00                 2487 	.db 0x00
                    0056   2488 Fmaster_wixel_track$_str_4$0$0 == .
   2088                    2489 __str_4:
   2088 50 52 45 50        2490 	.ascii "PREP"
   208C 00                 2491 	.db 0x00
                    005B   2492 Fmaster_wixel_track$_str_5$0$0 == .
   208D                    2493 __str_5:
   208D 52 55 4E           2494 	.ascii "RUN"
   2090 00                 2495 	.db 0x00
                    005F   2496 Fmaster_wixel_track$_str_6$0$0 == .
   2091                    2497 __str_6:
   2091 41 55 58           2498 	.ascii "AUX"
   2094 00                 2499 	.db 0x00
                    0063   2500 Fmaster_wixel_track$_str_7$0$0 == .
   2095                    2501 __str_7:
   2095 43 41 4C 49 42 52  2502 	.ascii "CALIBRATE"
        41 54 45
   209E 00                 2503 	.db 0x00
                    006D   2504 Fmaster_wixel_track$_str_8$0$0 == .
   209F                    2505 __str_8:
   209F 55 4E 4B 4E 4F 57  2506 	.ascii "UNKNOWN"
        4E
   20A6 00                 2507 	.db 0x00
                    0075   2508 Fmaster_wixel_track$_str_9$0$0 == .
   20A7                    2509 __str_9:
   20A7 53 6C 61 76 65 20  2510 	.ascii "Slave 1 Pos: (%d, %d, %d) CMD %s %d, %d, etc"
        31 20 50 6F 73 3A
        20 28 25 64 2C 20
        25 64 2C 20 25 64
        29 20 43 4D 44 20
        25 73 20 25 64 2C
        20 25 64 2C 20 65
        74 63
   20D3 0D                 2511 	.db 0x0D
   20D4 0A                 2512 	.db 0x0A
   20D5 00                 2513 	.db 0x00
                    00A4   2514 Fmaster_wixel_track$_str_10$0$0 == .
   20D6                    2515 __str_10:
   20D6 41 55 58 3A 20 53  2516 	.ascii "AUX: Slave 1 Pos: (%d, %d, %d)"
        6C 61 76 65 20 31
        20 50 6F 73 3A 20
        28 25 64 2C 20 25
        64 2C 20 25 64 29
   20F4 0D                 2517 	.db 0x0D
   20F5 0A                 2518 	.db 0x0A
   20F6 00                 2519 	.db 0x00
                    00C5   2520 Fmaster_wixel_track$_str_11$0$0 == .
   20F7                    2521 __str_11:
   20F7 5B 54 49 4D 45 4F  2522 	.ascii "[TIMEOUT] No serial data for 60s, sent STOP to all slaves"
        55 54 5D 20 4E 6F
        20 73 65 72 69 61
        6C 20 64 61 74 61
        20 66 6F 72 20 36
        30 73 2C 20 73 65
        6E 74 20 53 54 4F
        50 20 74 6F 20 61
        6C 6C 20 73 6C 61
        76 65 73
   2130 0D                 2523 	.db 0x0D
   2131 0A                 2524 	.db 0x0A
   2132 00                 2525 	.db 0x00
                    0101   2526 Fmaster_wixel_track$_str_12$0$0 == .
   2133                    2527 __str_12:
   2133 4D 61 73 74 65 72  2528 	.ascii "Master Wixel Ready - 4 SLAVES HARDCODED (PKTLEN=%d)"
        20 57 69 78 65 6C
        20 52 65 61 64 79
        20 2D 20 34 20 53
        4C 41 56 45 53 20
        48 41 52 44 43 4F
        44 45 44 20 28 50
        4B 54 4C 45 4E 3D
        25 64 29
   2166 0D                 2529 	.db 0x0D
   2167 0A                 2530 	.db 0x0A
   2168 00                 2531 	.db 0x00
                           2532 	.area XINIT   (CODE)
                           2533 	.area CABS    (ABS,CODE)
