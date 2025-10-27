                              1 ;--------------------------------------------------------
                              2 ; File Created by SDCC : free open source ANSI-C Compiler
                              3 ; Version 3.1.0 #7066 (Nov 22 2011) (MINGW32)
                              4 ; This file was generated Thu Oct 23 16:10:43 2025
                              5 ;--------------------------------------------------------
                              6 	.module alpha
                              7 	.optsdcc -mmcs51 --model-medium
                              8 	
                              9 ;--------------------------------------------------------
                             10 ; Public variables in this module
                             11 ;--------------------------------------------------------
                             12 	.globl _main
                             13 	.globl _updateHeartbeatLed
                             14 	.globl _timer3Init
                             15 	.globl _usbComService
                             16 	.globl _usbInit
                             17 	.globl _delayMs
                             18 	.globl _getMs
                             19 	.globl _boardService
                             20 	.globl _systemInit
                             21 	.globl _i
                             22 	.globl _currentTime
                             23 	.globl _motorState
                             24 	.globl _lastMotorActionTime
                             25 	.globl _lastRedLedToggle
                             26 ;--------------------------------------------------------
                             27 ; special function registers
                             28 ;--------------------------------------------------------
                             29 	.area RSEG    (ABS,DATA)
   0000                      30 	.org 0x0000
                    0080     31 Falpha$P0$0$0 == 0x0080
                    0080     32 _P0	=	0x0080
                    0081     33 Falpha$SP$0$0 == 0x0081
                    0081     34 _SP	=	0x0081
                    0082     35 Falpha$DPL0$0$0 == 0x0082
                    0082     36 _DPL0	=	0x0082
                    0083     37 Falpha$DPH0$0$0 == 0x0083
                    0083     38 _DPH0	=	0x0083
                    0084     39 Falpha$DPL1$0$0 == 0x0084
                    0084     40 _DPL1	=	0x0084
                    0085     41 Falpha$DPH1$0$0 == 0x0085
                    0085     42 _DPH1	=	0x0085
                    0086     43 Falpha$U0CSR$0$0 == 0x0086
                    0086     44 _U0CSR	=	0x0086
                    0087     45 Falpha$PCON$0$0 == 0x0087
                    0087     46 _PCON	=	0x0087
                    0088     47 Falpha$TCON$0$0 == 0x0088
                    0088     48 _TCON	=	0x0088
                    0089     49 Falpha$P0IFG$0$0 == 0x0089
                    0089     50 _P0IFG	=	0x0089
                    008A     51 Falpha$P1IFG$0$0 == 0x008a
                    008A     52 _P1IFG	=	0x008a
                    008B     53 Falpha$P2IFG$0$0 == 0x008b
                    008B     54 _P2IFG	=	0x008b
                    008C     55 Falpha$PICTL$0$0 == 0x008c
                    008C     56 _PICTL	=	0x008c
                    008D     57 Falpha$P1IEN$0$0 == 0x008d
                    008D     58 _P1IEN	=	0x008d
                    008F     59 Falpha$P0INP$0$0 == 0x008f
                    008F     60 _P0INP	=	0x008f
                    0090     61 Falpha$P1$0$0 == 0x0090
                    0090     62 _P1	=	0x0090
                    0091     63 Falpha$RFIM$0$0 == 0x0091
                    0091     64 _RFIM	=	0x0091
                    0092     65 Falpha$DPS$0$0 == 0x0092
                    0092     66 _DPS	=	0x0092
                    0093     67 Falpha$MPAGE$0$0 == 0x0093
                    0093     68 _MPAGE	=	0x0093
                    0095     69 Falpha$ENDIAN$0$0 == 0x0095
                    0095     70 _ENDIAN	=	0x0095
                    0098     71 Falpha$S0CON$0$0 == 0x0098
                    0098     72 _S0CON	=	0x0098
                    009A     73 Falpha$IEN2$0$0 == 0x009a
                    009A     74 _IEN2	=	0x009a
                    009B     75 Falpha$S1CON$0$0 == 0x009b
                    009B     76 _S1CON	=	0x009b
                    009C     77 Falpha$T2CT$0$0 == 0x009c
                    009C     78 _T2CT	=	0x009c
                    009D     79 Falpha$T2PR$0$0 == 0x009d
                    009D     80 _T2PR	=	0x009d
                    009E     81 Falpha$T2CTL$0$0 == 0x009e
                    009E     82 _T2CTL	=	0x009e
                    00A0     83 Falpha$P2$0$0 == 0x00a0
                    00A0     84 _P2	=	0x00a0
                    00A1     85 Falpha$WORIRQ$0$0 == 0x00a1
                    00A1     86 _WORIRQ	=	0x00a1
                    00A2     87 Falpha$WORCTRL$0$0 == 0x00a2
                    00A2     88 _WORCTRL	=	0x00a2
                    00A3     89 Falpha$WOREVT0$0$0 == 0x00a3
                    00A3     90 _WOREVT0	=	0x00a3
                    00A4     91 Falpha$WOREVT1$0$0 == 0x00a4
                    00A4     92 _WOREVT1	=	0x00a4
                    00A5     93 Falpha$WORTIME0$0$0 == 0x00a5
                    00A5     94 _WORTIME0	=	0x00a5
                    00A6     95 Falpha$WORTIME1$0$0 == 0x00a6
                    00A6     96 _WORTIME1	=	0x00a6
                    00A8     97 Falpha$IEN0$0$0 == 0x00a8
                    00A8     98 _IEN0	=	0x00a8
                    00A9     99 Falpha$IP0$0$0 == 0x00a9
                    00A9    100 _IP0	=	0x00a9
                    00AB    101 Falpha$FWT$0$0 == 0x00ab
                    00AB    102 _FWT	=	0x00ab
                    00AC    103 Falpha$FADDRL$0$0 == 0x00ac
                    00AC    104 _FADDRL	=	0x00ac
                    00AD    105 Falpha$FADDRH$0$0 == 0x00ad
                    00AD    106 _FADDRH	=	0x00ad
                    00AE    107 Falpha$FCTL$0$0 == 0x00ae
                    00AE    108 _FCTL	=	0x00ae
                    00AF    109 Falpha$FWDATA$0$0 == 0x00af
                    00AF    110 _FWDATA	=	0x00af
                    00B1    111 Falpha$ENCDI$0$0 == 0x00b1
                    00B1    112 _ENCDI	=	0x00b1
                    00B2    113 Falpha$ENCDO$0$0 == 0x00b2
                    00B2    114 _ENCDO	=	0x00b2
                    00B3    115 Falpha$ENCCS$0$0 == 0x00b3
                    00B3    116 _ENCCS	=	0x00b3
                    00B4    117 Falpha$ADCCON1$0$0 == 0x00b4
                    00B4    118 _ADCCON1	=	0x00b4
                    00B5    119 Falpha$ADCCON2$0$0 == 0x00b5
                    00B5    120 _ADCCON2	=	0x00b5
                    00B6    121 Falpha$ADCCON3$0$0 == 0x00b6
                    00B6    122 _ADCCON3	=	0x00b6
                    00B8    123 Falpha$IEN1$0$0 == 0x00b8
                    00B8    124 _IEN1	=	0x00b8
                    00B9    125 Falpha$IP1$0$0 == 0x00b9
                    00B9    126 _IP1	=	0x00b9
                    00BA    127 Falpha$ADCL$0$0 == 0x00ba
                    00BA    128 _ADCL	=	0x00ba
                    00BB    129 Falpha$ADCH$0$0 == 0x00bb
                    00BB    130 _ADCH	=	0x00bb
                    00BC    131 Falpha$RNDL$0$0 == 0x00bc
                    00BC    132 _RNDL	=	0x00bc
                    00BD    133 Falpha$RNDH$0$0 == 0x00bd
                    00BD    134 _RNDH	=	0x00bd
                    00BE    135 Falpha$SLEEP$0$0 == 0x00be
                    00BE    136 _SLEEP	=	0x00be
                    00C0    137 Falpha$IRCON$0$0 == 0x00c0
                    00C0    138 _IRCON	=	0x00c0
                    00C1    139 Falpha$U0DBUF$0$0 == 0x00c1
                    00C1    140 _U0DBUF	=	0x00c1
                    00C2    141 Falpha$U0BAUD$0$0 == 0x00c2
                    00C2    142 _U0BAUD	=	0x00c2
                    00C4    143 Falpha$U0UCR$0$0 == 0x00c4
                    00C4    144 _U0UCR	=	0x00c4
                    00C5    145 Falpha$U0GCR$0$0 == 0x00c5
                    00C5    146 _U0GCR	=	0x00c5
                    00C6    147 Falpha$CLKCON$0$0 == 0x00c6
                    00C6    148 _CLKCON	=	0x00c6
                    00C7    149 Falpha$MEMCTR$0$0 == 0x00c7
                    00C7    150 _MEMCTR	=	0x00c7
                    00C9    151 Falpha$WDCTL$0$0 == 0x00c9
                    00C9    152 _WDCTL	=	0x00c9
                    00CA    153 Falpha$T3CNT$0$0 == 0x00ca
                    00CA    154 _T3CNT	=	0x00ca
                    00CB    155 Falpha$T3CTL$0$0 == 0x00cb
                    00CB    156 _T3CTL	=	0x00cb
                    00CC    157 Falpha$T3CCTL0$0$0 == 0x00cc
                    00CC    158 _T3CCTL0	=	0x00cc
                    00CD    159 Falpha$T3CC0$0$0 == 0x00cd
                    00CD    160 _T3CC0	=	0x00cd
                    00CE    161 Falpha$T3CCTL1$0$0 == 0x00ce
                    00CE    162 _T3CCTL1	=	0x00ce
                    00CF    163 Falpha$T3CC1$0$0 == 0x00cf
                    00CF    164 _T3CC1	=	0x00cf
                    00D0    165 Falpha$PSW$0$0 == 0x00d0
                    00D0    166 _PSW	=	0x00d0
                    00D1    167 Falpha$DMAIRQ$0$0 == 0x00d1
                    00D1    168 _DMAIRQ	=	0x00d1
                    00D2    169 Falpha$DMA1CFGL$0$0 == 0x00d2
                    00D2    170 _DMA1CFGL	=	0x00d2
                    00D3    171 Falpha$DMA1CFGH$0$0 == 0x00d3
                    00D3    172 _DMA1CFGH	=	0x00d3
                    00D4    173 Falpha$DMA0CFGL$0$0 == 0x00d4
                    00D4    174 _DMA0CFGL	=	0x00d4
                    00D5    175 Falpha$DMA0CFGH$0$0 == 0x00d5
                    00D5    176 _DMA0CFGH	=	0x00d5
                    00D6    177 Falpha$DMAARM$0$0 == 0x00d6
                    00D6    178 _DMAARM	=	0x00d6
                    00D7    179 Falpha$DMAREQ$0$0 == 0x00d7
                    00D7    180 _DMAREQ	=	0x00d7
                    00D8    181 Falpha$TIMIF$0$0 == 0x00d8
                    00D8    182 _TIMIF	=	0x00d8
                    00D9    183 Falpha$RFD$0$0 == 0x00d9
                    00D9    184 _RFD	=	0x00d9
                    00DA    185 Falpha$T1CC0L$0$0 == 0x00da
                    00DA    186 _T1CC0L	=	0x00da
                    00DB    187 Falpha$T1CC0H$0$0 == 0x00db
                    00DB    188 _T1CC0H	=	0x00db
                    00DC    189 Falpha$T1CC1L$0$0 == 0x00dc
                    00DC    190 _T1CC1L	=	0x00dc
                    00DD    191 Falpha$T1CC1H$0$0 == 0x00dd
                    00DD    192 _T1CC1H	=	0x00dd
                    00DE    193 Falpha$T1CC2L$0$0 == 0x00de
                    00DE    194 _T1CC2L	=	0x00de
                    00DF    195 Falpha$T1CC2H$0$0 == 0x00df
                    00DF    196 _T1CC2H	=	0x00df
                    00E0    197 Falpha$ACC$0$0 == 0x00e0
                    00E0    198 _ACC	=	0x00e0
                    00E1    199 Falpha$RFST$0$0 == 0x00e1
                    00E1    200 _RFST	=	0x00e1
                    00E2    201 Falpha$T1CNTL$0$0 == 0x00e2
                    00E2    202 _T1CNTL	=	0x00e2
                    00E3    203 Falpha$T1CNTH$0$0 == 0x00e3
                    00E3    204 _T1CNTH	=	0x00e3
                    00E4    205 Falpha$T1CTL$0$0 == 0x00e4
                    00E4    206 _T1CTL	=	0x00e4
                    00E5    207 Falpha$T1CCTL0$0$0 == 0x00e5
                    00E5    208 _T1CCTL0	=	0x00e5
                    00E6    209 Falpha$T1CCTL1$0$0 == 0x00e6
                    00E6    210 _T1CCTL1	=	0x00e6
                    00E7    211 Falpha$T1CCTL2$0$0 == 0x00e7
                    00E7    212 _T1CCTL2	=	0x00e7
                    00E8    213 Falpha$IRCON2$0$0 == 0x00e8
                    00E8    214 _IRCON2	=	0x00e8
                    00E9    215 Falpha$RFIF$0$0 == 0x00e9
                    00E9    216 _RFIF	=	0x00e9
                    00EA    217 Falpha$T4CNT$0$0 == 0x00ea
                    00EA    218 _T4CNT	=	0x00ea
                    00EB    219 Falpha$T4CTL$0$0 == 0x00eb
                    00EB    220 _T4CTL	=	0x00eb
                    00EC    221 Falpha$T4CCTL0$0$0 == 0x00ec
                    00EC    222 _T4CCTL0	=	0x00ec
                    00ED    223 Falpha$T4CC0$0$0 == 0x00ed
                    00ED    224 _T4CC0	=	0x00ed
                    00EE    225 Falpha$T4CCTL1$0$0 == 0x00ee
                    00EE    226 _T4CCTL1	=	0x00ee
                    00EF    227 Falpha$T4CC1$0$0 == 0x00ef
                    00EF    228 _T4CC1	=	0x00ef
                    00F0    229 Falpha$B$0$0 == 0x00f0
                    00F0    230 _B	=	0x00f0
                    00F1    231 Falpha$PERCFG$0$0 == 0x00f1
                    00F1    232 _PERCFG	=	0x00f1
                    00F2    233 Falpha$ADCCFG$0$0 == 0x00f2
                    00F2    234 _ADCCFG	=	0x00f2
                    00F3    235 Falpha$P0SEL$0$0 == 0x00f3
                    00F3    236 _P0SEL	=	0x00f3
                    00F4    237 Falpha$P1SEL$0$0 == 0x00f4
                    00F4    238 _P1SEL	=	0x00f4
                    00F5    239 Falpha$P2SEL$0$0 == 0x00f5
                    00F5    240 _P2SEL	=	0x00f5
                    00F6    241 Falpha$P1INP$0$0 == 0x00f6
                    00F6    242 _P1INP	=	0x00f6
                    00F7    243 Falpha$P2INP$0$0 == 0x00f7
                    00F7    244 _P2INP	=	0x00f7
                    00F8    245 Falpha$U1CSR$0$0 == 0x00f8
                    00F8    246 _U1CSR	=	0x00f8
                    00F9    247 Falpha$U1DBUF$0$0 == 0x00f9
                    00F9    248 _U1DBUF	=	0x00f9
                    00FA    249 Falpha$U1BAUD$0$0 == 0x00fa
                    00FA    250 _U1BAUD	=	0x00fa
                    00FB    251 Falpha$U1UCR$0$0 == 0x00fb
                    00FB    252 _U1UCR	=	0x00fb
                    00FC    253 Falpha$U1GCR$0$0 == 0x00fc
                    00FC    254 _U1GCR	=	0x00fc
                    00FD    255 Falpha$P0DIR$0$0 == 0x00fd
                    00FD    256 _P0DIR	=	0x00fd
                    00FE    257 Falpha$P1DIR$0$0 == 0x00fe
                    00FE    258 _P1DIR	=	0x00fe
                    00FF    259 Falpha$P2DIR$0$0 == 0x00ff
                    00FF    260 _P2DIR	=	0x00ff
                    FFFFD5D4    261 Falpha$DMA0CFG$0$0 == 0xffffd5d4
                    FFFFD5D4    262 _DMA0CFG	=	0xffffd5d4
                    FFFFD3D2    263 Falpha$DMA1CFG$0$0 == 0xffffd3d2
                    FFFFD3D2    264 _DMA1CFG	=	0xffffd3d2
                    FFFFADAC    265 Falpha$FADDR$0$0 == 0xffffadac
                    FFFFADAC    266 _FADDR	=	0xffffadac
                    FFFFBBBA    267 Falpha$ADC$0$0 == 0xffffbbba
                    FFFFBBBA    268 _ADC	=	0xffffbbba
                    FFFFDBDA    269 Falpha$T1CC0$0$0 == 0xffffdbda
                    FFFFDBDA    270 _T1CC0	=	0xffffdbda
                    FFFFDDDC    271 Falpha$T1CC1$0$0 == 0xffffdddc
                    FFFFDDDC    272 _T1CC1	=	0xffffdddc
                    FFFFDFDE    273 Falpha$T1CC2$0$0 == 0xffffdfde
                    FFFFDFDE    274 _T1CC2	=	0xffffdfde
                            275 ;--------------------------------------------------------
                            276 ; special function bits
                            277 ;--------------------------------------------------------
                            278 	.area RSEG    (ABS,DATA)
   0000                     279 	.org 0x0000
                    0080    280 Falpha$P0_0$0$0 == 0x0080
                    0080    281 _P0_0	=	0x0080
                    0081    282 Falpha$P0_1$0$0 == 0x0081
                    0081    283 _P0_1	=	0x0081
                    0082    284 Falpha$P0_2$0$0 == 0x0082
                    0082    285 _P0_2	=	0x0082
                    0083    286 Falpha$P0_3$0$0 == 0x0083
                    0083    287 _P0_3	=	0x0083
                    0084    288 Falpha$P0_4$0$0 == 0x0084
                    0084    289 _P0_4	=	0x0084
                    0085    290 Falpha$P0_5$0$0 == 0x0085
                    0085    291 _P0_5	=	0x0085
                    0086    292 Falpha$P0_6$0$0 == 0x0086
                    0086    293 _P0_6	=	0x0086
                    0087    294 Falpha$P0_7$0$0 == 0x0087
                    0087    295 _P0_7	=	0x0087
                    0088    296 Falpha$_TCON_0$0$0 == 0x0088
                    0088    297 __TCON_0	=	0x0088
                    0089    298 Falpha$RFTXRXIF$0$0 == 0x0089
                    0089    299 _RFTXRXIF	=	0x0089
                    008A    300 Falpha$_TCON_2$0$0 == 0x008a
                    008A    301 __TCON_2	=	0x008a
                    008B    302 Falpha$URX0IF$0$0 == 0x008b
                    008B    303 _URX0IF	=	0x008b
                    008C    304 Falpha$_TCON_4$0$0 == 0x008c
                    008C    305 __TCON_4	=	0x008c
                    008D    306 Falpha$ADCIF$0$0 == 0x008d
                    008D    307 _ADCIF	=	0x008d
                    008E    308 Falpha$_TCON_6$0$0 == 0x008e
                    008E    309 __TCON_6	=	0x008e
                    008F    310 Falpha$URX1IF$0$0 == 0x008f
                    008F    311 _URX1IF	=	0x008f
                    0090    312 Falpha$P1_0$0$0 == 0x0090
                    0090    313 _P1_0	=	0x0090
                    0091    314 Falpha$P1_1$0$0 == 0x0091
                    0091    315 _P1_1	=	0x0091
                    0092    316 Falpha$P1_2$0$0 == 0x0092
                    0092    317 _P1_2	=	0x0092
                    0093    318 Falpha$P1_3$0$0 == 0x0093
                    0093    319 _P1_3	=	0x0093
                    0094    320 Falpha$P1_4$0$0 == 0x0094
                    0094    321 _P1_4	=	0x0094
                    0095    322 Falpha$P1_5$0$0 == 0x0095
                    0095    323 _P1_5	=	0x0095
                    0096    324 Falpha$P1_6$0$0 == 0x0096
                    0096    325 _P1_6	=	0x0096
                    0097    326 Falpha$P1_7$0$0 == 0x0097
                    0097    327 _P1_7	=	0x0097
                    0098    328 Falpha$ENCIF_0$0$0 == 0x0098
                    0098    329 _ENCIF_0	=	0x0098
                    0099    330 Falpha$ENCIF_1$0$0 == 0x0099
                    0099    331 _ENCIF_1	=	0x0099
                    009A    332 Falpha$_SOCON2$0$0 == 0x009a
                    009A    333 __SOCON2	=	0x009a
                    009B    334 Falpha$_SOCON3$0$0 == 0x009b
                    009B    335 __SOCON3	=	0x009b
                    009C    336 Falpha$_SOCON4$0$0 == 0x009c
                    009C    337 __SOCON4	=	0x009c
                    009D    338 Falpha$_SOCON5$0$0 == 0x009d
                    009D    339 __SOCON5	=	0x009d
                    009E    340 Falpha$_SOCON6$0$0 == 0x009e
                    009E    341 __SOCON6	=	0x009e
                    009F    342 Falpha$_SOCON7$0$0 == 0x009f
                    009F    343 __SOCON7	=	0x009f
                    00A0    344 Falpha$P2_0$0$0 == 0x00a0
                    00A0    345 _P2_0	=	0x00a0
                    00A1    346 Falpha$P2_1$0$0 == 0x00a1
                    00A1    347 _P2_1	=	0x00a1
                    00A2    348 Falpha$P2_2$0$0 == 0x00a2
                    00A2    349 _P2_2	=	0x00a2
                    00A3    350 Falpha$P2_3$0$0 == 0x00a3
                    00A3    351 _P2_3	=	0x00a3
                    00A4    352 Falpha$P2_4$0$0 == 0x00a4
                    00A4    353 _P2_4	=	0x00a4
                    00A5    354 Falpha$P2_5$0$0 == 0x00a5
                    00A5    355 _P2_5	=	0x00a5
                    00A6    356 Falpha$P2_6$0$0 == 0x00a6
                    00A6    357 _P2_6	=	0x00a6
                    00A7    358 Falpha$P2_7$0$0 == 0x00a7
                    00A7    359 _P2_7	=	0x00a7
                    00A8    360 Falpha$RFTXRXIE$0$0 == 0x00a8
                    00A8    361 _RFTXRXIE	=	0x00a8
                    00A9    362 Falpha$ADCIE$0$0 == 0x00a9
                    00A9    363 _ADCIE	=	0x00a9
                    00AA    364 Falpha$URX0IE$0$0 == 0x00aa
                    00AA    365 _URX0IE	=	0x00aa
                    00AB    366 Falpha$URX1IE$0$0 == 0x00ab
                    00AB    367 _URX1IE	=	0x00ab
                    00AC    368 Falpha$ENCIE$0$0 == 0x00ac
                    00AC    369 _ENCIE	=	0x00ac
                    00AD    370 Falpha$STIE$0$0 == 0x00ad
                    00AD    371 _STIE	=	0x00ad
                    00AE    372 Falpha$_IEN06$0$0 == 0x00ae
                    00AE    373 __IEN06	=	0x00ae
                    00AF    374 Falpha$EA$0$0 == 0x00af
                    00AF    375 _EA	=	0x00af
                    00B8    376 Falpha$DMAIE$0$0 == 0x00b8
                    00B8    377 _DMAIE	=	0x00b8
                    00B9    378 Falpha$T1IE$0$0 == 0x00b9
                    00B9    379 _T1IE	=	0x00b9
                    00BA    380 Falpha$T2IE$0$0 == 0x00ba
                    00BA    381 _T2IE	=	0x00ba
                    00BB    382 Falpha$T3IE$0$0 == 0x00bb
                    00BB    383 _T3IE	=	0x00bb
                    00BC    384 Falpha$T4IE$0$0 == 0x00bc
                    00BC    385 _T4IE	=	0x00bc
                    00BD    386 Falpha$P0IE$0$0 == 0x00bd
                    00BD    387 _P0IE	=	0x00bd
                    00BE    388 Falpha$_IEN16$0$0 == 0x00be
                    00BE    389 __IEN16	=	0x00be
                    00BF    390 Falpha$_IEN17$0$0 == 0x00bf
                    00BF    391 __IEN17	=	0x00bf
                    00C0    392 Falpha$DMAIF$0$0 == 0x00c0
                    00C0    393 _DMAIF	=	0x00c0
                    00C1    394 Falpha$T1IF$0$0 == 0x00c1
                    00C1    395 _T1IF	=	0x00c1
                    00C2    396 Falpha$T2IF$0$0 == 0x00c2
                    00C2    397 _T2IF	=	0x00c2
                    00C3    398 Falpha$T3IF$0$0 == 0x00c3
                    00C3    399 _T3IF	=	0x00c3
                    00C4    400 Falpha$T4IF$0$0 == 0x00c4
                    00C4    401 _T4IF	=	0x00c4
                    00C5    402 Falpha$P0IF$0$0 == 0x00c5
                    00C5    403 _P0IF	=	0x00c5
                    00C6    404 Falpha$_IRCON6$0$0 == 0x00c6
                    00C6    405 __IRCON6	=	0x00c6
                    00C7    406 Falpha$STIF$0$0 == 0x00c7
                    00C7    407 _STIF	=	0x00c7
                    00D0    408 Falpha$P$0$0 == 0x00d0
                    00D0    409 _P	=	0x00d0
                    00D1    410 Falpha$F1$0$0 == 0x00d1
                    00D1    411 _F1	=	0x00d1
                    00D2    412 Falpha$OV$0$0 == 0x00d2
                    00D2    413 _OV	=	0x00d2
                    00D3    414 Falpha$RS0$0$0 == 0x00d3
                    00D3    415 _RS0	=	0x00d3
                    00D4    416 Falpha$RS1$0$0 == 0x00d4
                    00D4    417 _RS1	=	0x00d4
                    00D5    418 Falpha$F0$0$0 == 0x00d5
                    00D5    419 _F0	=	0x00d5
                    00D6    420 Falpha$AC$0$0 == 0x00d6
                    00D6    421 _AC	=	0x00d6
                    00D7    422 Falpha$CY$0$0 == 0x00d7
                    00D7    423 _CY	=	0x00d7
                    00D8    424 Falpha$T3OVFIF$0$0 == 0x00d8
                    00D8    425 _T3OVFIF	=	0x00d8
                    00D9    426 Falpha$T3CH0IF$0$0 == 0x00d9
                    00D9    427 _T3CH0IF	=	0x00d9
                    00DA    428 Falpha$T3CH1IF$0$0 == 0x00da
                    00DA    429 _T3CH1IF	=	0x00da
                    00DB    430 Falpha$T4OVFIF$0$0 == 0x00db
                    00DB    431 _T4OVFIF	=	0x00db
                    00DC    432 Falpha$T4CH0IF$0$0 == 0x00dc
                    00DC    433 _T4CH0IF	=	0x00dc
                    00DD    434 Falpha$T4CH1IF$0$0 == 0x00dd
                    00DD    435 _T4CH1IF	=	0x00dd
                    00DE    436 Falpha$OVFIM$0$0 == 0x00de
                    00DE    437 _OVFIM	=	0x00de
                    00DF    438 Falpha$_TIMIF7$0$0 == 0x00df
                    00DF    439 __TIMIF7	=	0x00df
                    00E0    440 Falpha$ACC_0$0$0 == 0x00e0
                    00E0    441 _ACC_0	=	0x00e0
                    00E1    442 Falpha$ACC_1$0$0 == 0x00e1
                    00E1    443 _ACC_1	=	0x00e1
                    00E2    444 Falpha$ACC_2$0$0 == 0x00e2
                    00E2    445 _ACC_2	=	0x00e2
                    00E3    446 Falpha$ACC_3$0$0 == 0x00e3
                    00E3    447 _ACC_3	=	0x00e3
                    00E4    448 Falpha$ACC_4$0$0 == 0x00e4
                    00E4    449 _ACC_4	=	0x00e4
                    00E5    450 Falpha$ACC_5$0$0 == 0x00e5
                    00E5    451 _ACC_5	=	0x00e5
                    00E6    452 Falpha$ACC_6$0$0 == 0x00e6
                    00E6    453 _ACC_6	=	0x00e6
                    00E7    454 Falpha$ACC_7$0$0 == 0x00e7
                    00E7    455 _ACC_7	=	0x00e7
                    00E8    456 Falpha$P2IF$0$0 == 0x00e8
                    00E8    457 _P2IF	=	0x00e8
                    00E9    458 Falpha$UTX0IF$0$0 == 0x00e9
                    00E9    459 _UTX0IF	=	0x00e9
                    00EA    460 Falpha$UTX1IF$0$0 == 0x00ea
                    00EA    461 _UTX1IF	=	0x00ea
                    00EB    462 Falpha$P1IF$0$0 == 0x00eb
                    00EB    463 _P1IF	=	0x00eb
                    00EC    464 Falpha$WDTIF$0$0 == 0x00ec
                    00EC    465 _WDTIF	=	0x00ec
                    00ED    466 Falpha$_IRCON25$0$0 == 0x00ed
                    00ED    467 __IRCON25	=	0x00ed
                    00EE    468 Falpha$_IRCON26$0$0 == 0x00ee
                    00EE    469 __IRCON26	=	0x00ee
                    00EF    470 Falpha$_IRCON27$0$0 == 0x00ef
                    00EF    471 __IRCON27	=	0x00ef
                    00F0    472 Falpha$B_0$0$0 == 0x00f0
                    00F0    473 _B_0	=	0x00f0
                    00F1    474 Falpha$B_1$0$0 == 0x00f1
                    00F1    475 _B_1	=	0x00f1
                    00F2    476 Falpha$B_2$0$0 == 0x00f2
                    00F2    477 _B_2	=	0x00f2
                    00F3    478 Falpha$B_3$0$0 == 0x00f3
                    00F3    479 _B_3	=	0x00f3
                    00F4    480 Falpha$B_4$0$0 == 0x00f4
                    00F4    481 _B_4	=	0x00f4
                    00F5    482 Falpha$B_5$0$0 == 0x00f5
                    00F5    483 _B_5	=	0x00f5
                    00F6    484 Falpha$B_6$0$0 == 0x00f6
                    00F6    485 _B_6	=	0x00f6
                    00F7    486 Falpha$B_7$0$0 == 0x00f7
                    00F7    487 _B_7	=	0x00f7
                    00F8    488 Falpha$U1ACTIVE$0$0 == 0x00f8
                    00F8    489 _U1ACTIVE	=	0x00f8
                    00F9    490 Falpha$U1TX_BYTE$0$0 == 0x00f9
                    00F9    491 _U1TX_BYTE	=	0x00f9
                    00FA    492 Falpha$U1RX_BYTE$0$0 == 0x00fa
                    00FA    493 _U1RX_BYTE	=	0x00fa
                    00FB    494 Falpha$U1ERR$0$0 == 0x00fb
                    00FB    495 _U1ERR	=	0x00fb
                    00FC    496 Falpha$U1FE$0$0 == 0x00fc
                    00FC    497 _U1FE	=	0x00fc
                    00FD    498 Falpha$U1SLAVE$0$0 == 0x00fd
                    00FD    499 _U1SLAVE	=	0x00fd
                    00FE    500 Falpha$U1RE$0$0 == 0x00fe
                    00FE    501 _U1RE	=	0x00fe
                    00FF    502 Falpha$U1MODE$0$0 == 0x00ff
                    00FF    503 _U1MODE	=	0x00ff
                            504 ;--------------------------------------------------------
                            505 ; overlayable register banks
                            506 ;--------------------------------------------------------
                            507 	.area REG_BANK_0	(REL,OVR,DATA)
   0000                     508 	.ds 8
                            509 ;--------------------------------------------------------
                            510 ; internal ram data
                            511 ;--------------------------------------------------------
                            512 	.area DSEG    (DATA)
                            513 ;--------------------------------------------------------
                            514 ; overlayable items in internal ram 
                            515 ;--------------------------------------------------------
                            516 	.area OSEG    (OVR,DATA)
                            517 ;--------------------------------------------------------
                            518 ; Stack segment in internal ram 
                            519 ;--------------------------------------------------------
                            520 	.area	SSEG	(DATA)
   0021                     521 __start__stack:
   0021                     522 	.ds	1
                            523 
                            524 ;--------------------------------------------------------
                            525 ; indirectly addressable internal ram data
                            526 ;--------------------------------------------------------
                            527 	.area ISEG    (DATA)
                            528 ;--------------------------------------------------------
                            529 ; absolute internal ram data
                            530 ;--------------------------------------------------------
                            531 	.area IABS    (ABS,DATA)
                            532 	.area IABS    (ABS,DATA)
                            533 ;--------------------------------------------------------
                            534 ; bit data
                            535 ;--------------------------------------------------------
                            536 	.area BSEG    (BIT)
                            537 ;--------------------------------------------------------
                            538 ; paged external ram data
                            539 ;--------------------------------------------------------
                            540 	.area PSEG    (PAG,XDATA)
                    0000    541 G$lastRedLedToggle$0$0==.
   F000                     542 _lastRedLedToggle::
   F000                     543 	.ds 4
                    0004    544 G$lastMotorActionTime$0$0==.
   F004                     545 _lastMotorActionTime::
   F004                     546 	.ds 4
                    0008    547 G$motorState$0$0==.
   F008                     548 _motorState::
   F008                     549 	.ds 1
                    0009    550 G$currentTime$0$0==.
   F009                     551 _currentTime::
   F009                     552 	.ds 4
                    000D    553 G$i$0$0==.
   F00D                     554 _i::
   F00D                     555 	.ds 1
                            556 ;--------------------------------------------------------
                            557 ; external ram data
                            558 ;--------------------------------------------------------
                            559 	.area XSEG    (XDATA)
                    DF00    560 Falpha$SYNC1$0$0 == 0xdf00
                    DF00    561 _SYNC1	=	0xdf00
                    DF01    562 Falpha$SYNC0$0$0 == 0xdf01
                    DF01    563 _SYNC0	=	0xdf01
                    DF02    564 Falpha$PKTLEN$0$0 == 0xdf02
                    DF02    565 _PKTLEN	=	0xdf02
                    DF03    566 Falpha$PKTCTRL1$0$0 == 0xdf03
                    DF03    567 _PKTCTRL1	=	0xdf03
                    DF04    568 Falpha$PKTCTRL0$0$0 == 0xdf04
                    DF04    569 _PKTCTRL0	=	0xdf04
                    DF05    570 Falpha$ADDR$0$0 == 0xdf05
                    DF05    571 _ADDR	=	0xdf05
                    DF06    572 Falpha$CHANNR$0$0 == 0xdf06
                    DF06    573 _CHANNR	=	0xdf06
                    DF07    574 Falpha$FSCTRL1$0$0 == 0xdf07
                    DF07    575 _FSCTRL1	=	0xdf07
                    DF08    576 Falpha$FSCTRL0$0$0 == 0xdf08
                    DF08    577 _FSCTRL0	=	0xdf08
                    DF09    578 Falpha$FREQ2$0$0 == 0xdf09
                    DF09    579 _FREQ2	=	0xdf09
                    DF0A    580 Falpha$FREQ1$0$0 == 0xdf0a
                    DF0A    581 _FREQ1	=	0xdf0a
                    DF0B    582 Falpha$FREQ0$0$0 == 0xdf0b
                    DF0B    583 _FREQ0	=	0xdf0b
                    DF0C    584 Falpha$MDMCFG4$0$0 == 0xdf0c
                    DF0C    585 _MDMCFG4	=	0xdf0c
                    DF0D    586 Falpha$MDMCFG3$0$0 == 0xdf0d
                    DF0D    587 _MDMCFG3	=	0xdf0d
                    DF0E    588 Falpha$MDMCFG2$0$0 == 0xdf0e
                    DF0E    589 _MDMCFG2	=	0xdf0e
                    DF0F    590 Falpha$MDMCFG1$0$0 == 0xdf0f
                    DF0F    591 _MDMCFG1	=	0xdf0f
                    DF10    592 Falpha$MDMCFG0$0$0 == 0xdf10
                    DF10    593 _MDMCFG0	=	0xdf10
                    DF11    594 Falpha$DEVIATN$0$0 == 0xdf11
                    DF11    595 _DEVIATN	=	0xdf11
                    DF12    596 Falpha$MCSM2$0$0 == 0xdf12
                    DF12    597 _MCSM2	=	0xdf12
                    DF13    598 Falpha$MCSM1$0$0 == 0xdf13
                    DF13    599 _MCSM1	=	0xdf13
                    DF14    600 Falpha$MCSM0$0$0 == 0xdf14
                    DF14    601 _MCSM0	=	0xdf14
                    DF15    602 Falpha$FOCCFG$0$0 == 0xdf15
                    DF15    603 _FOCCFG	=	0xdf15
                    DF16    604 Falpha$BSCFG$0$0 == 0xdf16
                    DF16    605 _BSCFG	=	0xdf16
                    DF17    606 Falpha$AGCCTRL2$0$0 == 0xdf17
                    DF17    607 _AGCCTRL2	=	0xdf17
                    DF18    608 Falpha$AGCCTRL1$0$0 == 0xdf18
                    DF18    609 _AGCCTRL1	=	0xdf18
                    DF19    610 Falpha$AGCCTRL0$0$0 == 0xdf19
                    DF19    611 _AGCCTRL0	=	0xdf19
                    DF1A    612 Falpha$FREND1$0$0 == 0xdf1a
                    DF1A    613 _FREND1	=	0xdf1a
                    DF1B    614 Falpha$FREND0$0$0 == 0xdf1b
                    DF1B    615 _FREND0	=	0xdf1b
                    DF1C    616 Falpha$FSCAL3$0$0 == 0xdf1c
                    DF1C    617 _FSCAL3	=	0xdf1c
                    DF1D    618 Falpha$FSCAL2$0$0 == 0xdf1d
                    DF1D    619 _FSCAL2	=	0xdf1d
                    DF1E    620 Falpha$FSCAL1$0$0 == 0xdf1e
                    DF1E    621 _FSCAL1	=	0xdf1e
                    DF1F    622 Falpha$FSCAL0$0$0 == 0xdf1f
                    DF1F    623 _FSCAL0	=	0xdf1f
                    DF23    624 Falpha$TEST2$0$0 == 0xdf23
                    DF23    625 _TEST2	=	0xdf23
                    DF24    626 Falpha$TEST1$0$0 == 0xdf24
                    DF24    627 _TEST1	=	0xdf24
                    DF25    628 Falpha$TEST0$0$0 == 0xdf25
                    DF25    629 _TEST0	=	0xdf25
                    DF2E    630 Falpha$PA_TABLE0$0$0 == 0xdf2e
                    DF2E    631 _PA_TABLE0	=	0xdf2e
                    DF2F    632 Falpha$IOCFG2$0$0 == 0xdf2f
                    DF2F    633 _IOCFG2	=	0xdf2f
                    DF30    634 Falpha$IOCFG1$0$0 == 0xdf30
                    DF30    635 _IOCFG1	=	0xdf30
                    DF31    636 Falpha$IOCFG0$0$0 == 0xdf31
                    DF31    637 _IOCFG0	=	0xdf31
                    DF36    638 Falpha$PARTNUM$0$0 == 0xdf36
                    DF36    639 _PARTNUM	=	0xdf36
                    DF37    640 Falpha$VERSION$0$0 == 0xdf37
                    DF37    641 _VERSION	=	0xdf37
                    DF38    642 Falpha$FREQEST$0$0 == 0xdf38
                    DF38    643 _FREQEST	=	0xdf38
                    DF39    644 Falpha$LQI$0$0 == 0xdf39
                    DF39    645 _LQI	=	0xdf39
                    DF3A    646 Falpha$RSSI$0$0 == 0xdf3a
                    DF3A    647 _RSSI	=	0xdf3a
                    DF3B    648 Falpha$MARCSTATE$0$0 == 0xdf3b
                    DF3B    649 _MARCSTATE	=	0xdf3b
                    DF3C    650 Falpha$PKTSTATUS$0$0 == 0xdf3c
                    DF3C    651 _PKTSTATUS	=	0xdf3c
                    DF3D    652 Falpha$VCO_VC_DAC$0$0 == 0xdf3d
                    DF3D    653 _VCO_VC_DAC	=	0xdf3d
                    DF40    654 Falpha$I2SCFG0$0$0 == 0xdf40
                    DF40    655 _I2SCFG0	=	0xdf40
                    DF41    656 Falpha$I2SCFG1$0$0 == 0xdf41
                    DF41    657 _I2SCFG1	=	0xdf41
                    DF42    658 Falpha$I2SDATL$0$0 == 0xdf42
                    DF42    659 _I2SDATL	=	0xdf42
                    DF43    660 Falpha$I2SDATH$0$0 == 0xdf43
                    DF43    661 _I2SDATH	=	0xdf43
                    DF44    662 Falpha$I2SWCNT$0$0 == 0xdf44
                    DF44    663 _I2SWCNT	=	0xdf44
                    DF45    664 Falpha$I2SSTAT$0$0 == 0xdf45
                    DF45    665 _I2SSTAT	=	0xdf45
                    DF46    666 Falpha$I2SCLKF0$0$0 == 0xdf46
                    DF46    667 _I2SCLKF0	=	0xdf46
                    DF47    668 Falpha$I2SCLKF1$0$0 == 0xdf47
                    DF47    669 _I2SCLKF1	=	0xdf47
                    DF48    670 Falpha$I2SCLKF2$0$0 == 0xdf48
                    DF48    671 _I2SCLKF2	=	0xdf48
                    DE00    672 Falpha$USBADDR$0$0 == 0xde00
                    DE00    673 _USBADDR	=	0xde00
                    DE01    674 Falpha$USBPOW$0$0 == 0xde01
                    DE01    675 _USBPOW	=	0xde01
                    DE02    676 Falpha$USBIIF$0$0 == 0xde02
                    DE02    677 _USBIIF	=	0xde02
                    DE04    678 Falpha$USBOIF$0$0 == 0xde04
                    DE04    679 _USBOIF	=	0xde04
                    DE06    680 Falpha$USBCIF$0$0 == 0xde06
                    DE06    681 _USBCIF	=	0xde06
                    DE07    682 Falpha$USBIIE$0$0 == 0xde07
                    DE07    683 _USBIIE	=	0xde07
                    DE09    684 Falpha$USBOIE$0$0 == 0xde09
                    DE09    685 _USBOIE	=	0xde09
                    DE0B    686 Falpha$USBCIE$0$0 == 0xde0b
                    DE0B    687 _USBCIE	=	0xde0b
                    DE0C    688 Falpha$USBFRML$0$0 == 0xde0c
                    DE0C    689 _USBFRML	=	0xde0c
                    DE0D    690 Falpha$USBFRMH$0$0 == 0xde0d
                    DE0D    691 _USBFRMH	=	0xde0d
                    DE0E    692 Falpha$USBINDEX$0$0 == 0xde0e
                    DE0E    693 _USBINDEX	=	0xde0e
                    DE10    694 Falpha$USBMAXI$0$0 == 0xde10
                    DE10    695 _USBMAXI	=	0xde10
                    DE11    696 Falpha$USBCSIL$0$0 == 0xde11
                    DE11    697 _USBCSIL	=	0xde11
                    DE12    698 Falpha$USBCSIH$0$0 == 0xde12
                    DE12    699 _USBCSIH	=	0xde12
                    DE13    700 Falpha$USBMAXO$0$0 == 0xde13
                    DE13    701 _USBMAXO	=	0xde13
                    DE14    702 Falpha$USBCSOL$0$0 == 0xde14
                    DE14    703 _USBCSOL	=	0xde14
                    DE15    704 Falpha$USBCSOH$0$0 == 0xde15
                    DE15    705 _USBCSOH	=	0xde15
                    DE16    706 Falpha$USBCNTL$0$0 == 0xde16
                    DE16    707 _USBCNTL	=	0xde16
                    DE17    708 Falpha$USBCNTH$0$0 == 0xde17
                    DE17    709 _USBCNTH	=	0xde17
                    DE20    710 Falpha$USBF0$0$0 == 0xde20
                    DE20    711 _USBF0	=	0xde20
                    DE22    712 Falpha$USBF1$0$0 == 0xde22
                    DE22    713 _USBF1	=	0xde22
                    DE24    714 Falpha$USBF2$0$0 == 0xde24
                    DE24    715 _USBF2	=	0xde24
                    DE26    716 Falpha$USBF3$0$0 == 0xde26
                    DE26    717 _USBF3	=	0xde26
                    DE28    718 Falpha$USBF4$0$0 == 0xde28
                    DE28    719 _USBF4	=	0xde28
                    DE2A    720 Falpha$USBF5$0$0 == 0xde2a
                    DE2A    721 _USBF5	=	0xde2a
                            722 ;--------------------------------------------------------
                            723 ; absolute external ram data
                            724 ;--------------------------------------------------------
                            725 	.area XABS    (ABS,XDATA)
                            726 ;--------------------------------------------------------
                            727 ; external initialized ram data
                            728 ;--------------------------------------------------------
                            729 	.area XISEG   (XDATA)
                            730 	.area HOME    (CODE)
                            731 	.area GSINIT0 (CODE)
                            732 	.area GSINIT1 (CODE)
                            733 	.area GSINIT2 (CODE)
                            734 	.area GSINIT3 (CODE)
                            735 	.area GSINIT4 (CODE)
                            736 	.area GSINIT5 (CODE)
                            737 	.area GSINIT  (CODE)
                            738 	.area GSFINAL (CODE)
                            739 	.area CSEG    (CODE)
                            740 ;--------------------------------------------------------
                            741 ; interrupt vector 
                            742 ;--------------------------------------------------------
                            743 	.area HOME    (CODE)
   0400                     744 __interrupt_vect:
   0400 02 04 6D            745 	ljmp	__sdcc_gsinit_startup
   0403 32                  746 	reti
   0404                     747 	.ds	7
   040B 32                  748 	reti
   040C                     749 	.ds	7
   0413 32                  750 	reti
   0414                     751 	.ds	7
   041B 32                  752 	reti
   041C                     753 	.ds	7
   0423 32                  754 	reti
   0424                     755 	.ds	7
   042B 32                  756 	reti
   042C                     757 	.ds	7
   0433 32                  758 	reti
   0434                     759 	.ds	7
   043B 32                  760 	reti
   043C                     761 	.ds	7
   0443 32                  762 	reti
   0444                     763 	.ds	7
   044B 32                  764 	reti
   044C                     765 	.ds	7
   0453 32                  766 	reti
   0454                     767 	.ds	7
   045B 32                  768 	reti
   045C                     769 	.ds	7
   0463 02 0A 2C            770 	ljmp	_ISR_T4
                            771 ;--------------------------------------------------------
                            772 ; global & static initialisations
                            773 ;--------------------------------------------------------
                            774 	.area HOME    (CODE)
                            775 	.area GSINIT  (CODE)
                            776 	.area GSFINAL (CODE)
                            777 	.area GSINIT  (CODE)
                            778 	.globl __sdcc_gsinit_startup
                            779 	.globl __sdcc_program_startup
                            780 	.globl __start__stack
                            781 	.globl __mcs51_genXINIT
                            782 	.globl __mcs51_genXRAMCLEAR
                            783 	.globl __mcs51_genRAMCLEAR
                    0000    784 	G$main$0$0 ==.
                    0000    785 	C$alpha.c$50$1$1 ==.
                            786 ;	apps/alpha/alpha.c:50: uint32 lastRedLedToggle = 0;
   04C6 78 00               787 	mov	r0,#_lastRedLedToggle
   04C8 E4                  788 	clr	a
   04C9 F2                  789 	movx	@r0,a
   04CA 08                  790 	inc	r0
   04CB F2                  791 	movx	@r0,a
   04CC 08                  792 	inc	r0
   04CD F2                  793 	movx	@r0,a
   04CE 08                  794 	inc	r0
   04CF F2                  795 	movx	@r0,a
                    000A    796 	G$main$0$0 ==.
                    000A    797 	C$alpha.c$51$1$1 ==.
                            798 ;	apps/alpha/alpha.c:51: uint32 lastMotorActionTime = 0;
   04D0 78 04               799 	mov	r0,#_lastMotorActionTime
   04D2 E4                  800 	clr	a
   04D3 F2                  801 	movx	@r0,a
   04D4 08                  802 	inc	r0
   04D5 F2                  803 	movx	@r0,a
   04D6 08                  804 	inc	r0
   04D7 F2                  805 	movx	@r0,a
   04D8 08                  806 	inc	r0
   04D9 F2                  807 	movx	@r0,a
                    0014    808 	G$main$0$0 ==.
                    0014    809 	C$alpha.c$52$1$1 ==.
                            810 ;	apps/alpha/alpha.c:52: uint8 motorState = 0; // 0=Stop, 1=Forward, 2=Stop, 3=Reverse
   04DA 78 08               811 	mov	r0,#_motorState
   04DC E4                  812 	clr	a
   04DD F2                  813 	movx	@r0,a
                            814 	.area GSFINAL (CODE)
   0506 02 04 66            815 	ljmp	__sdcc_program_startup
                            816 ;--------------------------------------------------------
                            817 ; Home
                            818 ;--------------------------------------------------------
                            819 	.area HOME    (CODE)
                            820 	.area HOME    (CODE)
   0466                     821 __sdcc_program_startup:
   0466 12 05 73            822 	lcall	_main
                            823 ;	return from main will lock up
   0469 80 FE               824 	sjmp .
                            825 ;--------------------------------------------------------
                            826 ; code
                            827 ;--------------------------------------------------------
                            828 	.area CSEG    (CODE)
                            829 ;------------------------------------------------------------
                            830 ;Allocation info for local variables in function 'timer3Init'
                            831 ;------------------------------------------------------------
                    0000    832 	G$timer3Init$0$0 ==.
                    0000    833 	C$alpha.c$59$0$0 ==.
                            834 ;	apps/alpha/alpha.c:59: void timer3Init()
                            835 ;	-----------------------------------------
                            836 ;	 function timer3Init
                            837 ;	-----------------------------------------
   0509                     838 _timer3Init:
                    0007    839 	ar7 = 0x07
                    0006    840 	ar6 = 0x06
                    0005    841 	ar5 = 0x05
                    0004    842 	ar4 = 0x04
                    0003    843 	ar3 = 0x03
                    0002    844 	ar2 = 0x02
                    0001    845 	ar1 = 0x01
                    0000    846 	ar0 = 0x00
                    0000    847 	C$alpha.c$61$1$1 ==.
                            848 ;	apps/alpha/alpha.c:61: T3CTL = 0b01110000;   // Prescaler 1:8, frequency = 11.7 kHz
   0509 75 CB 70            849 	mov	_T3CTL,#0x70
                    0003    850 	C$alpha.c$62$1$1 ==.
                            851 ;	apps/alpha/alpha.c:62: T3CC0 = T3CC1 = 0;    // Set duty cycles to zero
   050C 75 CF 00            852 	mov	_T3CC1,#0x00
   050F 75 CD 00            853 	mov	_T3CC0,#0x00
                    0009    854 	C$alpha.c$63$1$1 ==.
                            855 ;	apps/alpha/alpha.c:63: T3CCTL0 = T3CCTL1 = 0b00100100;
   0512 75 CE 24            856 	mov	_T3CCTL1,#0x24
   0515 75 CC 24            857 	mov	_T3CCTL0,#0x24
                    000F    858 	C$alpha.c$64$1$1 ==.
                            859 ;	apps/alpha/alpha.c:64: PERCFG &= ~(1<<5);    // Alternate location
   0518 AF F1               860 	mov	r7,_PERCFG
   051A 53 07 DF            861 	anl	ar7,#0xDF
   051D 8F F1               862 	mov	_PERCFG,r7
                    0016    863 	C$alpha.c$65$1$1 ==.
                            864 ;	apps/alpha/alpha.c:65: P1SEL |= (1<<3) | (1<<4);  // P1_3 and P1_4 as PWM
   051F 43 F4 18            865 	orl	_P1SEL,#0x18
                    0019    866 	C$alpha.c$66$1$1 ==.
                    0019    867 	XG$timer3Init$0$0 ==.
   0522 22                  868 	ret
                            869 ;------------------------------------------------------------
                            870 ;Allocation info for local variables in function 'updateHeartbeatLed'
                            871 ;------------------------------------------------------------
                    001A    872 	G$updateHeartbeatLed$0$0 ==.
                    001A    873 	C$alpha.c$71$1$1 ==.
                            874 ;	apps/alpha/alpha.c:71: void updateHeartbeatLed()
                            875 ;	-----------------------------------------
                            876 ;	 function updateHeartbeatLed
                            877 ;	-----------------------------------------
   0523                     878 _updateHeartbeatLed:
                    001A    879 	C$alpha.c$74$1$1 ==.
                            880 ;	apps/alpha/alpha.c:74: if (getMs() - lastRedLedToggle >= 500)
   0523 12 0A 51            881 	lcall	_getMs
   0526 AC 82               882 	mov	r4,dpl
   0528 AD 83               883 	mov	r5,dph
   052A AE F0               884 	mov	r6,b
   052C FF                  885 	mov	r7,a
   052D 78 00               886 	mov	r0,#_lastRedLedToggle
   052F D3                  887 	setb	c
   0530 E2                  888 	movx	a,@r0
   0531 9C                  889 	subb	a,r4
   0532 F4                  890 	cpl	a
   0533 B3                  891 	cpl	c
   0534 FC                  892 	mov	r4,a
   0535 B3                  893 	cpl	c
   0536 08                  894 	inc	r0
   0537 E2                  895 	movx	a,@r0
   0538 9D                  896 	subb	a,r5
   0539 F4                  897 	cpl	a
   053A B3                  898 	cpl	c
   053B FD                  899 	mov	r5,a
   053C B3                  900 	cpl	c
   053D 08                  901 	inc	r0
   053E E2                  902 	movx	a,@r0
   053F 9E                  903 	subb	a,r6
   0540 F4                  904 	cpl	a
   0541 B3                  905 	cpl	c
   0542 FE                  906 	mov	r6,a
   0543 B3                  907 	cpl	c
   0544 08                  908 	inc	r0
   0545 E2                  909 	movx	a,@r0
   0546 9F                  910 	subb	a,r7
   0547 F4                  911 	cpl	a
   0548 FF                  912 	mov	r7,a
   0549 C3                  913 	clr	c
   054A EC                  914 	mov	a,r4
   054B 94 F4               915 	subb	a,#0xF4
   054D ED                  916 	mov	a,r5
   054E 94 01               917 	subb	a,#0x01
   0550 EE                  918 	mov	a,r6
   0551 94 00               919 	subb	a,#0x00
   0553 EF                  920 	mov	a,r7
   0554 94 00               921 	subb	a,#0x00
   0556 40 1A               922 	jc	00103$
                    004F    923 	C$alpha.c$76$3$3 ==.
                            924 ;	apps/alpha/alpha.c:76: LED_RED_TOGGLE();
   0558 63 FF 02            925 	xrl	_P2DIR,#0x02
                    0052    926 	C$alpha.c$77$2$2 ==.
                            927 ;	apps/alpha/alpha.c:77: lastRedLedToggle = getMs();
   055B 12 0A 51            928 	lcall	_getMs
   055E AC 82               929 	mov	r4,dpl
   0560 AD 83               930 	mov	r5,dph
   0562 AE F0               931 	mov	r6,b
   0564 FF                  932 	mov	r7,a
   0565 78 00               933 	mov	r0,#_lastRedLedToggle
   0567 EC                  934 	mov	a,r4
   0568 F2                  935 	movx	@r0,a
   0569 08                  936 	inc	r0
   056A ED                  937 	mov	a,r5
   056B F2                  938 	movx	@r0,a
   056C 08                  939 	inc	r0
   056D EE                  940 	mov	a,r6
   056E F2                  941 	movx	@r0,a
   056F 08                  942 	inc	r0
   0570 EF                  943 	mov	a,r7
   0571 F2                  944 	movx	@r0,a
   0572                     945 00103$:
                    0069    946 	C$alpha.c$79$2$1 ==.
                    0069    947 	XG$updateHeartbeatLed$0$0 ==.
   0572 22                  948 	ret
                            949 ;------------------------------------------------------------
                            950 ;Allocation info for local variables in function 'main'
                            951 ;------------------------------------------------------------
                    006A    952 	G$main$0$0 ==.
                    006A    953 	C$alpha.c$98$2$1 ==.
                            954 ;	apps/alpha/alpha.c:98: void main()
                            955 ;	-----------------------------------------
                            956 ;	 function main
                            957 ;	-----------------------------------------
   0573                     958 _main:
                    006A    959 	C$alpha.c$100$1$1 ==.
                            960 ;	apps/alpha/alpha.c:100: systemInit();
   0573 12 06 99            961 	lcall	_systemInit
                    006D    962 	C$alpha.c$101$1$1 ==.
                            963 ;	apps/alpha/alpha.c:101: usbInit();
   0576 12 0A B8            964 	lcall	_usbInit
                    0070    965 	C$alpha.c$104$2$2 ==.
                            966 ;	apps/alpha/alpha.c:104: LED_RED(0);
   0579 AF FF               967 	mov	r7,_P2DIR
   057B 53 07 FD            968 	anl	ar7,#0xFD
   057E 8F FF               969 	mov	_P2DIR,r7
                    0077    970 	C$alpha.c$105$2$3 ==.
                            971 ;	apps/alpha/alpha.c:105: LED_RED_TOGGLE();
   0580 63 FF 02            972 	xrl	_P2DIR,#0x02
                    007A    973 	C$alpha.c$107$1$1 ==.
                            974 ;	apps/alpha/alpha.c:107: delayMs(200);
   0583 90 00 C8            975 	mov	dptr,#0x00C8
   0586 12 0A 7D            976 	lcall	_delayMs
                    0080    977 	C$alpha.c$110$1$1 ==.
                            978 ;	apps/alpha/alpha.c:110: for(i = 0; i < 70; i++) {
   0589 78 0D               979 	mov	r0,#_i
   058B E4                  980 	clr	a
   058C F2                  981 	movx	@r0,a
   058D                     982 00104$:
   058D 78 0D               983 	mov	r0,#_i
   058F E2                  984 	movx	a,@r0
   0590 B4 46 00            985 	cjne	a,#0x46,00113$
   0593                     986 00113$:
   0593 50 17               987 	jnc	00107$
                    008C    988 	C$alpha.c$111$3$5 ==.
                            989 ;	apps/alpha/alpha.c:111: LED_RED_TOGGLE();
   0595 63 FF 02            990 	xrl	_P2DIR,#0x02
                    008F    991 	C$alpha.c$112$2$4 ==.
                            992 ;	apps/alpha/alpha.c:112: boardService();
   0598 12 06 A6            993 	lcall	_boardService
                    0092    994 	C$alpha.c$113$2$4 ==.
                            995 ;	apps/alpha/alpha.c:113: usbComService();
   059B 12 08 CA            996 	lcall	_usbComService
                    0095    997 	C$alpha.c$114$2$4 ==.
                            998 ;	apps/alpha/alpha.c:114: delayMs(100);
   059E 90 00 64            999 	mov	dptr,#0x0064
   05A1 12 0A 7D           1000 	lcall	_delayMs
                    009B   1001 	C$alpha.c$110$1$1 ==.
                           1002 ;	apps/alpha/alpha.c:110: for(i = 0; i < 70; i++) {
   05A4 78 0D              1003 	mov	r0,#_i
   05A6 E2                 1004 	movx	a,@r0
   05A7 24 01              1005 	add	a,#0x01
   05A9 F2                 1006 	movx	@r0,a
   05AA 80 E1              1007 	sjmp	00104$
   05AC                    1008 00107$:
                    00A3   1009 	C$alpha.c$118$2$6 ==.
                           1010 ;	apps/alpha/alpha.c:118: LED_RED(0);
   05AC AF FF              1011 	mov	r7,_P2DIR
   05AE 53 07 FD           1012 	anl	ar7,#0xFD
   05B1 8F FF              1013 	mov	_P2DIR,r7
                    00AA   1014 	C$alpha.c$122$1$1 ==.
                           1015 ;	apps/alpha/alpha.c:122: P1SEL = 0x00;     // Force ALL P1 pins to GPIO mode
   05B3 75 F4 00           1016 	mov	_P1SEL,#0x00
                    00AD   1017 	C$alpha.c$123$1$1 ==.
                           1018 ;	apps/alpha/alpha.c:123: P1DIR = 0x00;     // Start with all inputs
   05B6 75 FE 00           1019 	mov	_P1DIR,#0x00
                    00B0   1020 	C$alpha.c$124$1$1 ==.
                           1021 ;	apps/alpha/alpha.c:124: P1 = 0x00;        // Clear all output values
   05B9 75 90 00           1022 	mov	_P1,#0x00
                    00B3   1023 	C$alpha.c$127$1$1 ==.
                           1024 ;	apps/alpha/alpha.c:127: T1CTL = 0x00;
   05BC 75 E4 00           1025 	mov	_T1CTL,#0x00
                    00B6   1026 	C$alpha.c$128$1$1 ==.
                           1027 ;	apps/alpha/alpha.c:128: T3CTL = 0x00;
   05BF 75 CB 00           1028 	mov	_T3CTL,#0x00
                    00B9   1029 	C$alpha.c$129$1$1 ==.
                           1030 ;	apps/alpha/alpha.c:129: T4CTL = 0x00;
   05C2 75 EB 00           1031 	mov	_T4CTL,#0x00
                    00BC   1032 	C$alpha.c$132$1$1 ==.
                           1033 ;	apps/alpha/alpha.c:132: P1DIR |= (1 << 1) | (1 << 2) | (1 << 7);  // RGB pins as outputs
   05C5 43 FE 86           1034 	orl	_P1DIR,#0x86
                    00BF   1035 	C$alpha.c$133$1$1 ==.
                           1036 ;	apps/alpha/alpha.c:133: P1DIR |= (1 << 5) | (1 << 6);  // Motor direction pins as outputs (both wheels)
   05C8 43 FE 60           1037 	orl	_P1DIR,#0x60
                    00C2   1038 	C$alpha.c$136$1$1 ==.
                           1039 ;	apps/alpha/alpha.c:136: P1SEL = 0x00;
   05CB 75 F4 00           1040 	mov	_P1SEL,#0x00
                    00C5   1041 	C$alpha.c$141$1$1 ==.
                           1042 ;	apps/alpha/alpha.c:141: P1 = 0xFF;
   05CE 75 90 FF           1043 	mov	_P1,#0xFF
                    00C8   1044 	C$alpha.c$142$1$1 ==.
                           1045 ;	apps/alpha/alpha.c:142: delayMs(1000);
   05D1 90 03 E8           1046 	mov	dptr,#0x03E8
   05D4 12 0A 7D           1047 	lcall	_delayMs
                    00CE   1048 	C$alpha.c$145$1$1 ==.
                           1049 ;	apps/alpha/alpha.c:145: P1 = 0b11111101;  // Only bit 1 is 0
   05D7 75 90 FD           1050 	mov	_P1,#0xFD
                    00D1   1051 	C$alpha.c$146$1$1 ==.
                           1052 ;	apps/alpha/alpha.c:146: delayMs(300);
   05DA 90 01 2C           1053 	mov	dptr,#0x012C
   05DD 12 0A 7D           1054 	lcall	_delayMs
                    00D7   1055 	C$alpha.c$149$1$1 ==.
                           1056 ;	apps/alpha/alpha.c:149: P1 = 0b11111011;  // Only bit 2 is 0
   05E0 75 90 FB           1057 	mov	_P1,#0xFB
                    00DA   1058 	C$alpha.c$150$1$1 ==.
                           1059 ;	apps/alpha/alpha.c:150: delayMs(300);
   05E3 90 01 2C           1060 	mov	dptr,#0x012C
   05E6 12 0A 7D           1061 	lcall	_delayMs
                    00E0   1062 	C$alpha.c$153$1$1 ==.
                           1063 ;	apps/alpha/alpha.c:153: P1 = 0b01111111;  // Only bit 7 is 0
   05E9 75 90 7F           1064 	mov	_P1,#0x7F
                    00E3   1065 	C$alpha.c$154$1$1 ==.
                           1066 ;	apps/alpha/alpha.c:154: delayMs(300);
   05EC 90 01 2C           1067 	mov	dptr,#0x012C
   05EF 12 0A 7D           1068 	lcall	_delayMs
                    00E9   1069 	C$alpha.c$157$1$1 ==.
                           1070 ;	apps/alpha/alpha.c:157: P1 = 0xFF;
   05F2 75 90 FF           1071 	mov	_P1,#0xFF
                    00EC   1072 	C$alpha.c$158$1$1 ==.
                           1073 ;	apps/alpha/alpha.c:158: delayMs(500);
   05F5 90 01 F4           1074 	mov	dptr,#0x01F4
   05F8 12 0A 7D           1075 	lcall	_delayMs
                    00F2   1076 	C$alpha.c$161$1$1 ==.
                           1077 ;	apps/alpha/alpha.c:161: timer3Init();
   05FB 12 05 09           1078 	lcall	_timer3Init
                    00F5   1079 	C$alpha.c$166$1$1 ==.
                           1080 ;	apps/alpha/alpha.c:166: P1 = 0b10011110;  // Bits 5,6 = 0 (both forward), Bit 1 = 0 (RED LED ON)
   05FE 75 90 9E           1081 	mov	_P1,#0x9E
                    00F8   1082 	C$alpha.c$167$1$1 ==.
                           1083 ;	apps/alpha/alpha.c:167: T3CC0 = MOTOR_SPEED;
   0601 75 CD 64           1084 	mov	_T3CC0,#0x64
                    00FB   1085 	C$alpha.c$168$1$1 ==.
                           1086 ;	apps/alpha/alpha.c:168: T3CC1 = MOTOR_SPEED / 2;
   0604 75 CF 32           1087 	mov	_T3CC1,#0x32
                    00FE   1088 	C$alpha.c$169$1$1 ==.
                           1089 ;	apps/alpha/alpha.c:169: delayMs(2000);
   0607 90 07 D0           1090 	mov	dptr,#0x07D0
   060A 12 0A 7D           1091 	lcall	_delayMs
                    0104   1092 	C$alpha.c$172$1$1 ==.
                           1093 ;	apps/alpha/alpha.c:172: T3CC0 = 0;
   060D 75 CD 00           1094 	mov	_T3CC0,#0x00
                    0107   1095 	C$alpha.c$173$1$1 ==.
                           1096 ;	apps/alpha/alpha.c:173: T3CC1 = 0;
   0610 75 CF 00           1097 	mov	_T3CC1,#0x00
                    010A   1098 	C$alpha.c$174$1$1 ==.
                           1099 ;	apps/alpha/alpha.c:174: P1 = 0b11111011;  // Bits 5,6 = 0 (stay forward), Bit 2 = 0 (GREEN LED ON)
   0613 75 90 FB           1100 	mov	_P1,#0xFB
                    010D   1101 	C$alpha.c$175$1$1 ==.
                           1102 ;	apps/alpha/alpha.c:175: delayMs(1000);
   0616 90 03 E8           1103 	mov	dptr,#0x03E8
   0619 12 0A 7D           1104 	lcall	_delayMs
                    0113   1105 	C$alpha.c$178$1$1 ==.
                           1106 ;	apps/alpha/alpha.c:178: P1 = 0b01111111;  // Bits 5,6 = 1 (both reverse), Bit 7 = 0 (BLUE LED ON)
   061C 75 90 7F           1107 	mov	_P1,#0x7F
                    0116   1108 	C$alpha.c$179$1$1 ==.
                           1109 ;	apps/alpha/alpha.c:179: T3CC0 = MOTOR_SPEED / 2;
   061F 75 CD 32           1110 	mov	_T3CC0,#0x32
                    0119   1111 	C$alpha.c$180$1$1 ==.
                           1112 ;	apps/alpha/alpha.c:180: T3CC1 = MOTOR_SPEED;
   0622 75 CF 64           1113 	mov	_T3CC1,#0x64
                    011C   1114 	C$alpha.c$181$1$1 ==.
                           1115 ;	apps/alpha/alpha.c:181: delayMs(2000);
   0625 90 07 D0           1116 	mov	dptr,#0x07D0
   0628 12 0A 7D           1117 	lcall	_delayMs
                    0122   1118 	C$alpha.c$184$1$1 ==.
                           1119 ;	apps/alpha/alpha.c:184: T3CC0 = 0;
   062B 75 CD 00           1120 	mov	_T3CC0,#0x00
                    0125   1121 	C$alpha.c$185$1$1 ==.
                           1122 ;	apps/alpha/alpha.c:185: T3CC1 = 0;
   062E 75 CF 00           1123 	mov	_T3CC1,#0x00
                    0128   1124 	C$alpha.c$186$1$1 ==.
                           1125 ;	apps/alpha/alpha.c:186: P1 = 0xFF;  // All LEDs off
   0631 75 90 FF           1126 	mov	_P1,#0xFF
                    012B   1127 	C$alpha.c$187$1$1 ==.
                           1128 ;	apps/alpha/alpha.c:187: delayMs(1000);
   0634 90 03 E8           1129 	mov	dptr,#0x03E8
   0637 12 0A 7D           1130 	lcall	_delayMs
                    0131   1131 	C$alpha.c$190$1$1 ==.
                           1132 ;	apps/alpha/alpha.c:190: P1 = 0b10111100;  // Bit 5=0 (right forward), Bit 6=1 (left reverse), Bits 1,2=0 (RED+GREEN)
   063A 75 90 BC           1133 	mov	_P1,#0xBC
                    0134   1134 	C$alpha.c$191$1$1 ==.
                           1135 ;	apps/alpha/alpha.c:191: T3CC0 = MOTOR_SPEED;
   063D 75 CD 64           1136 	mov	_T3CC0,#0x64
                    0137   1137 	C$alpha.c$192$1$1 ==.
                           1138 ;	apps/alpha/alpha.c:192: T3CC1 = MOTOR_SPEED;
   0640 75 CF 64           1139 	mov	_T3CC1,#0x64
                    013A   1140 	C$alpha.c$193$1$1 ==.
                           1141 ;	apps/alpha/alpha.c:193: delayMs(2000);
   0643 90 07 D0           1142 	mov	dptr,#0x07D0
   0646 12 0A 7D           1143 	lcall	_delayMs
                    0140   1144 	C$alpha.c$196$1$1 ==.
                           1145 ;	apps/alpha/alpha.c:196: T3CC0 = 0;
   0649 75 CD 00           1146 	mov	_T3CC0,#0x00
                    0143   1147 	C$alpha.c$197$1$1 ==.
                           1148 ;	apps/alpha/alpha.c:197: T3CC1 = 0;
   064C 75 CF 00           1149 	mov	_T3CC1,#0x00
                    0146   1150 	C$alpha.c$198$1$1 ==.
                           1151 ;	apps/alpha/alpha.c:198: P1 = 0b01111111;  // Bit 7 = 0 (BLUE LED ON)
   064F 75 90 7F           1152 	mov	_P1,#0x7F
                    0149   1153 	C$alpha.c$199$1$1 ==.
                           1154 ;	apps/alpha/alpha.c:199: delayMs(1000);
   0652 90 03 E8           1155 	mov	dptr,#0x03E8
   0655 12 0A 7D           1156 	lcall	_delayMs
                    014F   1157 	C$alpha.c$202$1$1 ==.
                           1158 ;	apps/alpha/alpha.c:202: P1 = 0b11011101;  // Bit 5=1 (right reverse), Bit 6=0 (left forward), Bits 1,7=0 (RED+BLUE)
   0658 75 90 DD           1159 	mov	_P1,#0xDD
                    0152   1160 	C$alpha.c$203$1$1 ==.
                           1161 ;	apps/alpha/alpha.c:203: T3CC0 = MOTOR_SPEED;
   065B 75 CD 64           1162 	mov	_T3CC0,#0x64
                    0155   1163 	C$alpha.c$204$1$1 ==.
                           1164 ;	apps/alpha/alpha.c:204: T3CC1 = MOTOR_SPEED;
   065E 75 CF 64           1165 	mov	_T3CC1,#0x64
                    0158   1166 	C$alpha.c$205$1$1 ==.
                           1167 ;	apps/alpha/alpha.c:205: delayMs(2000);
   0661 90 07 D0           1168 	mov	dptr,#0x07D0
   0664 12 0A 7D           1169 	lcall	_delayMs
                    015E   1170 	C$alpha.c$208$1$1 ==.
                           1171 ;	apps/alpha/alpha.c:208: T3CC0 = 0;
   0667 75 CD 00           1172 	mov	_T3CC0,#0x00
                    0161   1173 	C$alpha.c$209$1$1 ==.
                           1174 ;	apps/alpha/alpha.c:209: T3CC1 = 0;
   066A 75 CF 00           1175 	mov	_T3CC1,#0x00
                    0164   1176 	C$alpha.c$210$1$1 ==.
                           1177 ;	apps/alpha/alpha.c:210: P1 = 0xFF;
   066D 75 90 FF           1178 	mov	_P1,#0xFF
                    0167   1179 	C$alpha.c$211$1$1 ==.
                           1180 ;	apps/alpha/alpha.c:211: delayMs(500);
   0670 90 01 F4           1181 	mov	dptr,#0x01F4
   0673 12 0A 7D           1182 	lcall	_delayMs
                    016D   1183 	C$alpha.c$214$1$1 ==.
                           1184 ;	apps/alpha/alpha.c:214: lastRedLedToggle = getMs();
   0676 12 0A 51           1185 	lcall	_getMs
   0679 AC 82              1186 	mov	r4,dpl
   067B AD 83              1187 	mov	r5,dph
   067D AE F0              1188 	mov	r6,b
   067F FF                 1189 	mov	r7,a
   0680 78 00              1190 	mov	r0,#_lastRedLedToggle
   0682 EC                 1191 	mov	a,r4
   0683 F2                 1192 	movx	@r0,a
   0684 08                 1193 	inc	r0
   0685 ED                 1194 	mov	a,r5
   0686 F2                 1195 	movx	@r0,a
   0687 08                 1196 	inc	r0
   0688 EE                 1197 	mov	a,r6
   0689 F2                 1198 	movx	@r0,a
   068A 08                 1199 	inc	r0
   068B EF                 1200 	mov	a,r7
   068C F2                 1201 	movx	@r0,a
                    0184   1202 	C$alpha.c$216$1$1 ==.
                           1203 ;	apps/alpha/alpha.c:216: while(1)
   068D                    1204 00102$:
                    0184   1205 	C$alpha.c$218$2$7 ==.
                           1206 ;	apps/alpha/alpha.c:218: boardService();
   068D 12 06 A6           1207 	lcall	_boardService
                    0187   1208 	C$alpha.c$219$2$7 ==.
                           1209 ;	apps/alpha/alpha.c:219: usbComService();
   0690 12 08 CA           1210 	lcall	_usbComService
                    018A   1211 	C$alpha.c$220$2$7 ==.
                           1212 ;	apps/alpha/alpha.c:220: updateHeartbeatLed();
   0693 12 05 23           1213 	lcall	_updateHeartbeatLed
   0696 80 F5              1214 	sjmp	00102$
                    018F   1215 	C$alpha.c$222$1$1 ==.
                    018F   1216 	XG$main$0$0 ==.
   0698 22                 1217 	ret
                           1218 	.area CSEG    (CODE)
                           1219 	.area CONST   (CODE)
                           1220 	.area XINIT   (CODE)
                           1221 	.area CABS    (ABS,CODE)
