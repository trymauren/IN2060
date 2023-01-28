@ The two numbers we want to add
num1:  		 .word   0x40000000
num2:  		 .word   0x3F010000
normaliser:  .word   0x00ffffff
leading:     .word   0x00800000
maskMant:    .word   0x007fffff 
.text
.global main
main:
    LDR r12, normaliser
    LDR r9, maskMant
    LDR r8, leading
    LDR r0, num1
    LDR r1, num2
    
    LSR r2, r0, #23    @ eksponent til num1
    LSR r3, r1, #23    @ eksponent til num2
    
    AND r4, r0, r9     @ desimal til num1
    AND r5, r1, r9     @ desimal til num2
    
    MOV r10, #1        @ legger til 1 i r10
    
    CMP r2, #0         @ sjekker om eksponenten til num1 ikke er 0, i så fall legg til ledende 1- er på desimalen
    ORRNE r4, r4, r8   @ legger til ledende 1- er på desimalen til num1 hvis eksponenten ikke er 0
    
    CMP r3, #0         @ sjekker om eksponenten til num2 ikke er 0, i så fall legg til ledende 1- er på desimalen
    ORRNE r5, r5, r8   @ legger til ledende 1- er på desimalen til num1 hvis eksponenten ikke er 0
    
    CMP r3, r2
    SUBPL r7, r3, r2    @ sjekker hvilken eksponent som er størst, og lager forskjellen mellom eksponentene i r7
    SUBMI r7, r2, r3

    LSRMI r5, r5, r7   @ shifter desimal til num2 med diff av eksponentene hvis num2 sin eksponent er minst
    MOVMI r7, r2       @ setter eksponenten til det nye tallet til den største av eksponentene

    LSRPL r4, r4, r7   @ shifter desimal til num1 med diff av eksponentene hvis num2 sin eksponent er størst
    MOVPL r7, r3       @ setter eksponenten til det nye tallet til den største av eksponentene
    
    ADD r6, r4, r5     @ legger sammen desimalene i r6
    
    SUBS r12, r12, r6  @ sammenlikner skiftet desimal med normaliser-w
    
    ADDMI r7, r7, r10  @ legger til 1 på eksponenten hvis overflow på desimal- addisjon
    LSRMI r6, r6, #1   @ shifter desimal hvis sum av desimalene gir overflow
    
    LSL r6, r6, #9     @ fjerner ledende 1- er fra sum av desimaler
    LSR r6, r6, #9     @ -/-
    
    LSL r7, r7, #23    @ setter eksponentene på riktig plass
    ORR r0, r7, r6     @ assembler resultat
    
    BX lr

    

    
