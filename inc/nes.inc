; important ports and locations on the nes

; cpu

ram 		= $0000
ppu		= $2000
apu		= $4000
rom		= $8000

stack 		= $100
oam 		= $200

page0		= $000
page1		= $100
page2		= $200
page3		= $300
page4		= $400
page5		= $500
page6		= $600
page7		= $700

ppuctrl		= $2000
ppumask		= $2001
ppustatus	= $2002
oamaddr		= $2003
oamdata		= $2004
ppuscroll	= $2005
ppuaddr		= $2006
ppudata		= $2007
oamdma		= $4014

; ppu

chr0		= $0000
chr1		= $1000
nt0		= $2000
nt1		= $2400
nt2		= $2800
nt3		= $2c00
pal		= $3f00
palbg		= $3f00
palfg		= $3f10
palbg0		= $3f00
palbg1		= $3f04
palbg2		= $3f08
palbg3		= $3f0c
palfg0		= $3f10
palfg1		= $3f14
palfg2		= $3f18
palfg3		= $3f1c