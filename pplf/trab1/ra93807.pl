:- use_module(library(plunit)).

:- begin_tests(program).
test(infeccao_garganta)  :- program('teste_infeccao_garganta.txt').
test(verruga)            :- program('teste_verruga.txt').
test(pneumonia)          :- program('teste_pneumonia.txt').
test(asma)               :- program('teste_asma.txt').
test(afta_bucal)         :- program('teste_afta.txt').
:- end_tests(program).

program(File) :-
	open(File, read, X),
	current_input(Stream),
	set_input(X),
	diagnostico,
	close(X),
	set_input(Stream).

imprimir_cab :-
	write('                    _ _ _              _____         _____  _                             _   _           '),nl,
	write('    /\\             (_) (_)            |  __ \\       |  __ \\(_)                           | | (_)          '),nl,
	write('   /  \\  _   ___  ___| |_  __ _ _ __  | |  | | ___  | |  | |_  __ _  __ _ _ __   ___  ___| |_ _  ___ ___  '),nl,
	write('  / /\\ \\| | | \\ \\/ / | | |/ _` | \'__| | |  | |/ _ \\ | |  | | |/ _` |/ _` | \'_ \\ / _ \\/ __| __| |/ __/ _ \\ '),nl,
	write(' / ____ \\ |_| |>  <| | | | (_| | |    | |__| |  __/ | |__| | | (_| | (_| | | | | (_) \\__ \\ |_| | (_| (_) |'),nl,
	write('/_/    \\_\\__,_/_/\\_\\_|_|_|\\__,_|_|    |_____/ \\___| |_____/|_|\\__,_|\\__, |_| |_|\\___/|___/\\__|_|\\___\\___/ '),nl,
	write('                                                                     __/ |                                '),nl,
	write('                                                                    |___/                                 '),nl.

imprimir_sintomas :-
	write('     0. Problemas Bucais'),nl,
	write('     1. Febre'),nl,
	write('     2. Diarreia'),nl,
	write('     3. Vomito'),nl,
	write('     4. Problemas de Pele'),nl,
	write('     5. Manchas e dermatites'),nl,
	write('     6. Dermatite com febre'),nl,
	write('     7. Tosse'),nl,
	write('     8. Problemas Respiratórios'),nl,
	write('     9. Garganta Inflamada'),nl.

switch(OPC_IDADE, OPC_SINT) :-
	OPC_SINT == '0' -> sintoma(problemas_bucais);
	OPC_SINT == '1' -> sintoma(febre, OPC_IDADE);
	OPC_SINT == '2' -> sintoma(diarreia, OPC_IDADE);
	OPC_SINT == '3' -> sintoma(vomito, OPC_IDADE);
	OPC_SINT == '4' -> sintoma(problemas_de_pele);
	OPC_SINT == '5' -> sintoma(manchas_e_dermatites);
	OPC_SINT == '6' -> sintoma(dermatite_febre);
	OPC_SINT == '7' -> sintoma(tosse, OPC_IDADE);
	OPC_SINT == '8' -> sintoma(problemas_respiratorios);
	OPC_SINT == '9' -> sintoma(garganta_inflamada).

diagnostico :-
	imprimir_cab,
	write('Qual a idade do paciente'),nl,
	write('   1. Ate 1 ano'),nl,
	write('   2. Acima de 1 ano.'),nl,
	leitura1(OPC_IDADE),nl,
	write('Qual sintoma o paciente esta sentindo:'),nl,
	imprimir_sintomas,nl,
	leitura2(OPC_SINT),
	switch(OPC_IDADE, OPC_SINT).


sintoma(diarreia, OPC_IDADE) :-
	(nl, OPC_IDADE == '1' -> arvore(t(pergunta(sintoma(diarreia), questao01), t(pergunta(sintoma(diarreia), questao02),t(pergunta(sintoma(diarreia), questao03),t(pergunta(sintoma(diarreia), questao04), t(pergunta(sintoma(diarreia), questao05),t(pergunta(sintoma(diarreia), questao06), possivel_causa(gastroenterite_alergia),possivel_causa(novos_alimentos)),possivel_causa(acucar)), possivel_causa(efeito_colateral)), possivel_causa(gastroenterite)), possivel_causa(intolerancia_alergia_etc)), possivel_causa(gastroenterite))));
	(nl, arvore(t(pergunta(sintoma(diarreia), questao07),t(pergunta(sintoma(diarreia), questao08), t(pergunta(sintoma(diarreia), questao09), t(pergunta(sintoma(diarreia), questao10),possivel_causa(diarreia),t(pergunta(sintoma(diarreia), questao12),possivel_causa(diarreia), possivel_causa(diarreia_crianca_pequena))),possivel_causa(efeito_colateral)),possivel_causa(constipacao_cronica)),t(pergunta(sintoma(diarreia), questao11),t(pergunta(sintoma(diarreia), questao13), possivel_causa(gastroenterite),possivel_causa(estress)),possivel_causa(gastroenterite))))).

sintoma(febre, OPC_IDADE) :-
	(nl, OPC_IDADE == '1' -> arvore(t(pergunta(sintoma(febre), questao01), t(pergunta(sintoma(febre), questao02),t(pergunta(sintoma(febre), questao03),t(pergunta(sintoma(febre), questao04),t(pergunta(sintoma(febre), questao05), t(pergunta(sintoma(febre), questao06), t(pergunta(sintoma(febre), questao07), t(pergunta(sintoma(febre), questao08), t(pergunta(sintoma(febre), questao09),possivel_causa(ndefinida),possivel_causa(superaquecimento)),possivel_causa(gastroenterite)),possivel_causa(infecção)),possivel_causa(meningite)),possivel_causa(resfriado)),possivel_causa(pneumonia_ou_branq)),possivel_causa(otite_interna)),sintoma(dermatite_febre)), possivel_causa(recemnascido))));
	(arvore(t(pergunta(sintoma(febre), questao02), t(pergunta(sintoma(febre), (questao10)),t(pergunta(sintoma(febre), questao11),t(pergunta(sintoma(febre), questao05), t(pergunta(sintoma(febre), questao12),t(pergunta(sintoma(febre), questao15),t(pergunta(sintoma(febre), questao16), t(pergunta(sintoma(febre), questao17), t(pergunta(sintoma(febre), questao18), possivel_causa(ndefinida), possivel_causa(superaquecimento)),possivel_causa(otite_interna)),possivel_causa(gastroenterite)),possivel_causa(infec_urinaria)), possivel_causa(caxumba)),t(pergunta(sintoma(febre), questao13),t(pergunta(sintoma(febre), questao14),possivel_causa(resfriado_gripe),possivel_causa(pneumonia)),possivel_causa(cviral_branquite))),possivel_causa(infecção)),possivel_causa(meningite)),sintoma(dermatite_febre)))).

sintoma(vomito, OPC_IDADE) :-
	(nl, OPC_IDADE == '1' -> arvore(t(pergunta(sintoma(vomito), questao01), t(pergunta(sintoma(vomito), questao02), t(pergunta(sintoma(vomito), questao05),t(pergunta(sintoma(vomito), questao09),t(pergunta(sintoma(vomito), questao11),write('Seu bebe tiver vomitado uma só vez fora disso parece bastante bem, ele provavelmente não está seriamente doente. Contudo, ele provavelmente não está seriamente doente. Contudo, se ele vomitar repetidamente ou desenvolver quaisquer outros sintomas, procure um orientação médica.'),possivel_causa(obstrucao_intestinal)),possivel_causa(gastroenterite)),possivel_causa(branquiolite_coq) ), t(pergunta(sintoma(vomito), questao07), t(pergunta(sintoma(vomito), questao08),t(pergunta(sintoma(vomito), questao09),t(pergunta(sintoma(vomito), questao10),sintoma(febre,1), possivel_causa(bronquiolite_coq)),possivel_causa(gastroenterite)),possivel_causa(infec_urinaria) ),possivel_causa(roseola_meningite_infeccao))),t(pergunta(sintoma(vomito), questao04),t(pergunta(sintoma(vomito), questao02), t(pergunta(sintoma(vomito), questao05),t(pergunta(sintoma(vomito), questao09),t(pergunta(sintoma(vomito), questao11),write('Seu bebe tiver vomitado uma só vez fora disso parece bastante bem, ele provavelmente não está seriamente doente. Contudo, ele provavelmente não está seriamente doente. Contudo, se ele vomitar repetidamente ou desenvolver quaisquer outros sintomas, procure um orientação médica.'),possivel_causa(obstrucao_intestinal)),possivel_causa(gastroenterite)),possivel_causa(branquiolite_coq) ), t(pergunta(sintoma(vomito), questao07), t(pergunta(sintoma(vomito), questao08),t(pergunta(sintoma(vomito), questao09),t(pergunta(sintoma(vomito), questao10),sintoma(febre,1), possivel_causa(bronquiolite_coq)),possivel_causa(gastroenterite)),possivel_causa(infec_urinaria) ),possivel_causa(roseola_meningite_infeccao))),possivel_causa(regurgitacao)))));(nl,arvore(t(pergunta(sintoma(vomito), questao12), t(pergunta(sintoma(vomito), questao11), t(pergunta(sintoma(vomito), questao13), t(pergunta(sintoma(vomito), questao14),t(pergunta(sintoma(vomito), questao08),t(pergunta(sintoma(vomito), questao18),t(pergunta(sintoma(vomito), questao15),t(pergunta(sintoma(vomito), questao16),possivel_causa(ndefinida),possivel_causa(enjoo_de_viagem)),write('\nPOSSIVEL CAUSA É comum que crianças vomitem quando estão agitadas ou antes de eventos estressantes.')),possivel_causa(coqueluche)),possivel_causa(infec_urinaria)),possivel_causa(hepatite)), t(pergunta(sintoma(vomito), questao17),t(pergunta(sintoma(vomito), questao19),possivel_causa(ndefinida),possivel_causa(meningite_s) ),possivel_causa(ferimento_de_cabeca))),possivel_causa(obstrucao_intestinal)), possivel_causa(apendice)))).

sintoma(tosse, OPC_IDADE) :-
	(nl, OPC_IDADE == '1' -> possivel_causa(refriado_bronq_pneu);
	arvore(t(pergunta(sintoma(tosse), questao01),t(pergunta(sintoma(tosse), questao02), t(pergunta(sintoma(tosse), questao05), t(pergunta(sintoma(tosse), questao06),t(pergunta(sintoma(tosse), questao07),t(pergunta(sintoma(tosse), questao08),possivel_causa(engolio_obj),possivel_causa(resfriado_gripe)),t(pergunta(sintoma(tosse), questao09),t(pergunta(sintoma(tosse), questao10),t(pergunta(sintoma(tosse), questao11),t(pergunta(sintoma(tosse), questao12),possivel_causa(ndefinida), possivel_causa(irritacao_de_garganta_pulmoes)),possivel_causa(asma)),possivel_causa(tosse_apos_coqueluche)),possivel_causa(adenoides_aumentadas_refriado_rinite))),possivel_causa(coqueluche)),possivel_causa(asma)),t(pergunta(sintoma(tosse), questao03), t(pergunta(sintoma(tosse), questao04),possivel_causa(resfriado),possivel_causa(sarampo)),possivel_causa(coqueluche))), sintoma(problemas_respiratorios)))).


sintoma(dermatite_febre) :-
	arvore(t(pergunta(sintoma(dermatite_febre), questao01), t(pergunta(sintoma(dermatite_febre), questao02),t(pergunta(sintoma(dermatite_febre), questao03),t(pergunta(sintoma(dermatite_febre), questao04), t(pergunta(sintoma(dermatite_febre), questao09),possivel_causa(ndefinida),possivel_causa(entema_infeccioso)),t(pergunta(sintoma(dermatite_febre), questao08),possivel_causa(rubeola),possivel_causa(roseola))),possivel_causa(catapora)),t(pergunta(sintoma(dermatite_febre), questao05), t(pergunta(sintoma(dermatite_febre), questao06),t(pergunta(sintoma(dermatite_febre), questao07),possivel_causa(ndefinida),possivel_causa(efeito_colateral)),possivel_causa(escarlatina)),possivel_causa(sarampo_kawasaki))),possivel_causa(septicenia))).

sintoma(problemas_de_pele) :-
	arvore(t(pergunta(sintoma(problemas_de_pele), questao01), t(pergunta(sintoma(problemas_de_pele), questao03),t(pergunta(sintoma(problemas_de_pele), questao04),possivel_causa(ndefinida),t(pergunta(sintoma(problemas_de_pele), questao05),doenca(ndefinida),possivel_causa(crosta_lactea) ) ),possivel_causa(crosta_lactea) ), t(pergunta(sintoma(problemas_de_pele), questao02), t(pergunta(sintoma(problemas_de_pele), questao06), t(pergunta(sintoma(problemas_de_pele), questao07),possivel_causa(ndefinida),t(pergunta(sintoma(problemas_de_pele), questao08),t(pergunta(sintoma(problemas_de_pele), questao10),sintoma(manchas_e_dermatites),sintoma(dermatite_febre)),possivel_causa(irritacao_da_pele))), possivel_causa(assadura)), possivel_causa(eczema)))).

sintoma(manchas_e_dermatites) :-
	arvore(t(pergunta(sintoma(manchas_e_dermatites), questao01),t(pergunta(sintoma(manchas_e_dermatites), questao02),t(pergunta(sintoma(manchas_e_dermatites), questao03),t(pergunta(sintoma(manchas_e_dermatites), questao04),t(pergunta(sintoma(manchas_e_dermatites), questao05),t(pergunta(sintoma(manchas_e_dermatites), questao06),t(pergunta(sintoma(manchas_e_dermatites), questao07),t(pergunta(sintoma(manchas_e_dermatites), questao05),possivel_causa(ndefinida),possivel_causa(reacao_a_medicacao)),possivel_causa(brotoeja)),possivel_causa(furunculo)),possivel_causa(verruga)),possivel_causa(impetigo)),possivel_causa(molusco_contagioso)),t(pergunta(sintoma(manchas_e_dermatites), questao09),t(pergunta(sintoma(manchas_e_dermatites), questao10),t(pergunta(sintoma(manchas_e_dermatites), questao11),t(pergunta(sintoma(manchas_e_dermatites), questao12),t(pergunta(sintoma(manchas_e_dermatites), questao08),possivel_causa(ndefinida),possivel_causa(reacao_a_medicacao)),t(pergunta(sintoma(manchas_e_dermatites), questao13),possivel_causa(urticaria),possivel_causa(reacao_alergica))),possivel_causa(picadas_de_insetos)),possivel_causa(micose_psoriase) ),possivel_causa(eczema) )),sintoma(dermatite_febre))).

sintoma(problemas_respiratorios) :-
	arvore(t(pergunta(sintoma(problemas_respiratorios), questao01),t(pergunta(sintoma(problemas_respiratorios), questao02),t(pergunta(sintoma(problemas_respiratorios), questao03), t(pergunta(sintoma(problemas_respiratorios), questao07), t(pergunta(sintoma(problemas_respiratorios), questao08), t(pergunta(sintoma(problemas_respiratorios), questao09), possivel_causa(asma_branq), possivel_causa(crupe_viral)), possivel_causa(pneumonia_bronq_crupe)),possivel_causa(asma)), t(pergunta(sintoma(problemas_respiratorios), questao06) , t(pergunta(sintoma(problemas_respiratorios), questao07), t(pergunta(sintoma(problemas_respiratorios), questao08), t(pergunta(sintoma(problemas_respiratorios), questao09), possivel_causa(asma_branq), possivel_causa(crupe_viral)), possivel_causa(pneumonia_bronq_crupe)),possivel_causa(asma)), possivel_causa(laringe_ondulando))),t(pergunta(sintoma(problemas_respiratorios), questao05), possivel_causa(pneumonia_bronq_crupe),possivel_causa(ataque_grave_asma))), t(pergunta(sintoma(problemas_respiratorios), questao04),t(pergunta(sintoma(problemas_respiratorios), questao02),t(pergunta(sintoma(problemas_respiratorios), questao03), t(pergunta(sintoma(problemas_respiratorios), questao07), t(pergunta(sintoma(problemas_respiratorios), questao08), t(pergunta(sintoma(problemas_respiratorios), questao09), possivel_causa(asma_branq), possivel_causa(crupe_viral)), possivel_causa(pneumonia_bronq_crupe)),possivel_causa(asma)), t(pergunta(sintoma(problemas_respiratorios), questao06) , t(pergunta(sintoma(problemas_respiratorios), questao07), t(pergunta(sintoma(problemas_respiratorios), questao08), t(pergunta(sintoma(problemas_respiratorios), questao09), possivel_causa(asma_branq), possivel_causa(crupe_viral)), possivel_causa(pneumonia_bronq_crupe)),possivel_causa(asma)), possivel_causa(laringe_ondulando))),t(pergunta(sintoma(problemas_respiratorios), questao05), possivel_causa(pneumonia_bronq_crupe),possivel_causa(ataque_grave_asma))),possivel_causa(engolio_obj)))).

sintoma(garganta_inflamada) :-
	arvore(t(pergunta(sintoma(garganta_inflamada), questao01), t(pergunta(sintoma(garganta_inflamada), questao04),possivel_causa(infeccao_irritacao),possivel_causa(resfriado_rinite)), t(pergunta(sintoma(garganta_inflamada), questao02), t(pergunta(sintoma(garganta_inflamada), questao03),possivel_causa(infeccao_irritacao),possivel_causa(infeccao_garganta)),possivel_causa(escalatina)))).

sintoma(problemas_bucais) :-
	arvore(t(pergunta(sintoma(problemas_bucais), questao01),t(pergunta(sintoma(problemas_bucais), questao02),t(pergunta(sintoma(problemas_bucais), questao03),t(pergunta(sintoma(problemas_bucais), questao04),possivel_causa(ndefinida),t(pergunta(sintoma(problemas_bucais), questao06),t(pergunta(sintoma(problemas_bucais), questao11),possivel_causa(ndefinida),possivel_causa(afta_bucal)),t(pergunta(sintoma(problemas_bucais), questao10),possivel_causa(ulceras_bucais),possivel_causa(mao_pe_boca)))),t(pergunta(sintoma(problemas_bucais), questao05),possivel_causa(gengivite),possivel_causa(denticao))),possivel_causa(ulceras_bucais)),t(pergunta(sintoma(problemas_bucais), questao07),t(pergunta(sintoma(problemas_bucais), questao08),t(pergunta(sintoma(problemas_bucais), questao09), possivel_causa(ndefinida),possivel_causa(impedigo)),possivel_causa(dermatite_perioral_infantil)),possivel_causa(herpes_labial)))).

possivel_causa(afta_bucal) :-
	nl, write('POSSIVEL CAUSA Afta bucal').
possivel_causa(mao_pe_boca) :-
	nl, write('POSSIVEL CAUSA Síndrome mão-pé-boca').
possivel_causa(denticao) :-
	nl, write('POSSIVEL CAUSA Dentição').
possivel_causa(gengivite) :-
	nl, write('POSSIVEL CAUSA Gengivite').
possivel_causa(ulceras_bucais) :-
	nl, write('POSSIVEL CAUSA Úlcera bucais').
possivel_causa(impedigo) :-
	nl, write('POSSIVEL CAUSA Impetigo').
possivel_causa(dermatite_perioral_infantil) :-
	nl, write('POSSIVEL CAUSA Dermatite perioral infantil, ou seja, uma irritação da pele em torno da boca que aparece quando o bebê baba, fica constantemente passando a língua na área ou chupa o dedo.').
possivel_causa(herpes_labial) :-
	nl, write('POSSIVEL CAUSA Herpes labial').
possivel_causa(resfriado_rinite) :-
	nl, write('POSSIVEIS CAUSAS Resfriado ou rinite alérgica').
possivel_causa(infeccao_garganta) :-
	nl, write('POSSIVEL CAUSA Infecção de Garganta').
possivel_causa(infeccao_irritacao) :-
	nl, write('POSSIVEIS CAUSAS Inframação causada por uma pequena infecção de garganta ou irritação da garganta').
possivel_causa(escalatina) :-
	nl, write('POSSIVEL CAUSA Escalatina').
possivel_causa(irritacao_de_garganta_pulmoes) :-
	nl, write('POSSIVEL CAUSA Irritação de garganta e pulmões por ter ficado em um ambiente onde se fumava').
possivel_causa(tosse_apos_coqueluche) :-
	nl, write('POSSIVEL CAUSA Tosse que persiste após coqueluche').
possivel_causa(adenoides_aumentadas_refriado_rinite) :-
	nl, write('POSSIVEIS CAUSAS Adenoides aumentadas, resfriados recorrentes ou rinite alérgica').
possivel_causa(resfriado_gripe) :-
	nl, write('POSSIVEIS CAUSAS Resfriado ou gripe(influenza)').
possivel_causa(resfriado) :-
	nl, write('POSSIVEL CAUSA Resfriado').
possivel_causa(crupe_viral) :-
	nl, write('POSSIVEL CAUSA Crupe Viral(laringotranqueobranquite)').
possivel_causa(asma_branq) :-
	nl, write('POSSIVEIS CAUSAS Asma ou branquite').
possivel_causa(refriado_bronq_pneu) :-
	nl, write('POSSIVEIS CAUSAS Resfriado, bronquiolite, bronquite, pneumonia').
possivel_causa(asma) :-
	nl, write('POSSIVEL CAUSA Asma').
possivel_causa(laringe_ondulando) :-
	nl, write('POSSIVEL CAUSA A caixa de voz (laringe) de seu bebê pode estar ondulando durante a aspiração, causando um ruído. Na maioria dos casos, esse problema precisa de tratamento e melhora na idade entre 18 meses e 2 anos. Contudo, se você estiver preocupado com a respiração de seu filho leve-o ao médico imediatamente.').
possivel_causa(pneumonia_bronq_crupe) :-
	nl, write('POSIVEIS CAUSAS Pneumonia, bronquiolite, bronquite ou crupe viral').
possivel_causa(ataque_grave_asma) :-
	nl, write('POSSIVEL CAUSA Ataque grave de asma').
possivel_causa(engolio_obj) :-
	nl, write('POSSIVEL CAUSA Seu filho pode estar sufocando com um objeto que colocou na boca e engoliu').
possivel_causa(urticaria) :-
	nl, write('POSSIVEL CAUSA Urticária').
possivel_causa(picadas_de_insetos) :-
	nl, write('POSSIVEL CAUSA Picadas de insetos, possivelmente de mosquitos ou pulgas(de cães e gatos)').
possivel_causa(reacao_alergica) :-
	nl, write('POSSIVEL CAUSA Reação alérgica, que pode ser cuasada por uma picada de inseto, amendoim u outros fatores, e que pode levar a um choque anafilático.').
possivel_causa(reacao_a_medicacao) :-
	nl, write('POSSIVEL CAUSA Reação à medicação').
possivel_causa(irritacao_da_pele) :-
	nl, write('Pequena irritação da pele. Procure orientação médica se a erupção na pele persistir por mais de um dia ou se seu bebê ficar com mal-estar geral').
possivel_causa(micose_psoriase) :-
	nl, write('POSSIVEIS CAUSAS Micose ou psoríase').
possivel_causa(brotoeja) :-
	nl, write('POSSIVEL CAUSA Brotoeja').
possivel_causa(furunculo) :-
	nl, write('POSSIVEL CAUSA Furúnculo').
possivel_causa(molusco_contagioso) :-
	nl, write('POSSIVEL CAUSA Molusco Contagioso').
possivel_causa(impetigo) :-
	nl, write('POSSIVEL CAUSA Impedigo').
possivel_causa(verruga) :-
	nl, write('POSSIVEL CAUSA Verruga').
possivel_causa(eczema) :-
	nl, write('POSSIVEL CAUSA Eczema').
possivel_causa(crosta_lactea) :-
	nl, write('POSSIVEL CAUSA Crosta láctea (dermatite seborreica infantil)').
possivel_causa(assadura) :-
	nl, write('POSSIVEL CAUSA Assadura').
possivel_causa(meningite_s) :-
	nl, write('POSSIVEL CAUSA Meningite.').
possivel_causa(ferimento_de_cabeca) :-
	nl, write('POSSIVEL CAUSA Ferimento de cabeça.').
possivel_causa(enjoo_de_viagem) :-
	nl, write('POSSIVEL CAUSA Enjoo de Viagem.').
possivel_causa(hepatite) :-
	nl, write('POSSIVEL CAUSA Hepatite.').
possivel_causa(apendice) :-
	nl, write('POSSIVEL CAUSA Apendicite').
possivel_causa(bronquiolite_coq) :-
	nl, write('POSSIVEIS CAUSAS Bronquiolite').
possivel_causa(obstrucao_intestinal) :-
	nl, write('POSSIVEL CAUSA Obstrução intestinal.').
possivel_causa(rubeola) :-
	nl, write('POSSIVEL CAUSA Rubeola').
possivel_causa(roseola) :-
	nl, write('POSSIVEL CAUSA Roseola ou exantema súbito').
possivel_causa(entema_infeccioso) :-
	nl, write('POSSIVEL CAUSA Entema infeccioso.').
possivel_causa(sarampo_kawasaki) :-
	nl,write('POSSIVEIS CAUSAS Sarampo ou, mais raro, sindrome de Kawasaki').
possivel_causa(sarampo) :-
	nl, write('POSSIVEL CAUSA Sarampo').
possivel_causa(septicenia) :-
	nl,write('POSSIVEIS CAUSAS Infecção generalizada(sipticenia) devido a uma bactéria que causa meningite').
possivel_causa(escarlatina) :-
	nl, write('POSSIVEL CAUSA Escarlatina').
possivel_causa(catapora) :-
	nl, write('POSSIVEL CAUSA Catapora').
possivel_causa(caxumba) :-
	nl,write('POSSIVEIS CAUSA Caxumba ou abscesso dentário.'), nl.
possivel_causa(cviral_branquite) :-
	nl,write('POSSIVEIS CAUSAS Crupe viral ou branquite'),nl.
possivel_causa(otite_interna) :-
	nl, write('POSSÍVEL CAUSA Otite interna.').
possivel_causa(pneumonia_ou_branq) :-
	nl, write('POSSÍVEIS CAISAS Pneumonia ou branquiolite.'),nl,
	write('URGENTE: Procure orientação médica imediatamente.').
possivel_causa(pneumonia) :-
	nl, write('POSSIVEL CAUSA Pneumonia'), nl, write('URGENTE Procure orientação médica imediatamente').
possivel_causa(resfriado_gripe) :-
	nl, write('POSSIVEIS CAUSA Resfriado ou Gripe').
possivel_causa(resfriado) :-
	nl, write('POSSÌVEIS CAUSAS Resfriado ou, possivelmente, gripe (influenza), ou, mais raramente, sarampo.').
possivel_causa(infecção) :-
	nl, write('POSSIVEL CAUSA Infecçao de garganta.').
possivel_causa(gastroenterite) :-
	nl, write('POSSIVEL CAUSA Gastroenterite.').
possivel_causa(gastroenterite_alergia) :-
	nl, write('POSSIVEIS CAUSAS Gastroentetira branda ou alergia alimentar.').
possivel_causa(superaquecimento) :-
	nl, write('POSSIVEL CAUSA Ele(a) pode estar seperaquecido(a).').
possivel_causa(meningite) :-
	nl, write('POSSÍVEIS CAUSAS Meningite ou infecção do sistema urinário.').
possivel_causa(infec_urinaria) :-
	nl, write('POSSIVEL CAUSA Infecção do Sistema Urinário').
possivel_causa(recemnascido) :-
	nl, write('POSSÍVEL CAUSA Febre em bebês abaixo de 6 meses é incomum e pode indicar uma doença séria.'), nl, write('URGENTE: Procure orientação médica imediatamente').
possivel_causa(ndefinida) :-
	nl,write('Procure orientação médica.').
possivel_causa(intolerancia_alergia_etc) :-
	nl, write('POSSIVEIS CAUSAS Intolerancia alimentar é a causa mais provável de diarreia persistente em crianças pequenas. Outras possiveis causas includem alergia alimentar, giardiase, doença celiaca e fibrose cistica, mas estas são muito menos comuns').
possivel_causa(efeito_colateral) :-
	nl, write('POSSIVEL CAUSA Efeito colateral do medicamento').
possivel_causa(acucar) :-
	nl, write('Em grandes quantidades, o açucar de sucos ou polpas de fruta pode causar diarreia').
possivel_causa(novos_alimentos) :-
	nl, write('Novos alimentos podem causar diarreia, mas geralmente apenas por pouco tempo.').
possivel_causa(estress) :-
	nl, write('POSSIVEL CAUSA Tensão ou estresse emocional.').
possivel_causa(constipacao_cronica) :-
	nl, write('POSSIVEL CAUSA Eliminação de fezes em resultado de constipação crônica.').
possivel_causa(diarreia) :-
	nl, write('POSSIVEIS CAUSA As causas mais prováveis de diarreia em crianças são intolerância alimentar, alergia alimentar ou glandiase. Outras possibilidades incluem doença celiaca e fibrose cistica, mas estas são muito menos comuns.').
possivel_causa(diarreia_crianca_pequena) :-
	nl, write('POSSIVEL CAUSA Diarreia de criança pequena.').
possivel_causa(regurgitacao) :-
	nl, write('POSSIVEIS CAUSAS Regurgitação (cospe leite, etc) que pode ser decorrente de gases (flutulência) ou de refluxo.').
possivel_causa(branquiolite_coq) :-
	nl, write('POSSIVEIS CAUSAS Branquiolite ou coqueluche').
possivel_causa(gastroenterite) :-
	nl, write('POSSIVEL CAUSA Gastroenterite').
possivel_causa(roseola_meningite_infeccao) :-
	nl, write('POSSIVEIS CAUSAS Roséola ou exantema súbito, meningite ou infecção do sistema urinário.').
possivel_causa(coqueluche) :-
	nl, write('POSSIVEL CAUSA Coqueluche').

pergunta(sintoma(febre), questao01) :-
	write('O paciente tem menos de 6 meses?(s ou n)'),nl.
pergunta(sintoma(febre), questao02) :-
	write('O paciente está com alguma erupçao na pele?(s ou n)'),nl.
pergunta(sintoma(febre), questao03) :-
	write('O paciente chora e puxa uma orelha ou acorda gritando?(s ou n)'),nl.
pergunta(sintoma(febre), questao04) :-
	write('O ritmo respiratório do paciente está mais rápido do que o normal?(s ou n)'),nl.
pergunta(sintoma(febre), questao05) :-
	write('O paciente tem tosse ou coriza?(s ou n)'),nl.
pergunta(sintoma(febre), questao06) :-
	write('O paciente apresenta um dos seguintes sintomas: vômito sem diarreia,sonolência anormal, irritabilidade incomum?(s ou n)'), nl.
pergunta(sintoma(febre), questao07) :-
	write('O paciente rejeita comida solida?(s ou n)'), nl.
pergunta(sintoma(febre), questao08) :-
        write('O paciente sofre de vômito e diarreia?(s ou n)'), nl.
pergunta(sintoma(febre), questao09) :-
	write('O paciente está com muita roupa ou o recinto está muito quente? (s ou n)'),nl.
pergunta(sintoma(febre), questao10) :-
	write('O paciente parece não estar bem e também tem algum dos sintomas: pescoço duro, dor de cabeça, sonolência anormal, irritabilidade incomum, dor nos braços ou nas pernas, mãos ou pés frios?(s ou n)'),nl.
pergunta(sintoma(febre), questao11) :-
	write('O paciente rejeita comida solida ou sua garganta está inflamada?(s ou n)'), nl.
pergunta(sintoma(febre), questao12) :-
	write('O paciente tem um inchaço em um lado de sua face?(s ou n)'), nl.
pergunta(sintoma(febre), questao13) :-
	write('A respitação do paciente está incomumente ruidosa?(s ou n)'),nl.
pergunta(sintoma(febre), questao14) :-
	write('A respitação do paciente está incomumente rápida?(s ou n)'), nl.
pergunta(sintoma(febre), questao15) :-
	write('O paciente precisa urinar mais do que normalmente ou se queixa de dor ou uma sensação ardente ao urinar?(s ou n)'), nl.
pergunta(sintoma(febre), questao16) :-
	write('O paciente sofre de vômito com ou sem diarreia?(s ou n)'), nl.
pergunta(sintoma(febre), questao17) :-
	write('O paciente está com dor na orelha ou puza uma orelha ou, à noite, acorda gritando?(s ou n)'), nl.
pergunta(sintoma(febre), questao18) :-
	write('O paciente ficou muito tempo no sol ou por várias horas em um espaço quente?(s ou n)'), nl.

pergunta(sintoma(diarreia), questao01) :-
	write('O paciente tem febre?(s ou n)'),nl.
pergunta(sintoma(diarreia), questao02) :-
	write('A diarreia já dura duas semanas ou mais?(s ou n)'),nl.
pergunta(sintoma(diarreia), questao03) :-
	write('O paciente teve nos últimos dias um dos seguintes sintomas: vômito, pouco apetite, letargia?(s ou n)'),nl.
pergunta(sintoma(diarreia), questao04) :-
	write('Você tem dado ao um medicamento receitado para algum outro problema?(s ou n)'),nl.
pergunta(sintoma(diarreia), questao05) :-
	write('Você tem incluido na alimentação de mais sucos ou polpas de fruta do que o habitual?(s ou n)'),nl.
pergunta(sintoma(diarreia), questao06) :-
	write('Nas últimas 24 horas, você introduziu na alimentação de um alimento novo?'),nl.
pergunta(sintoma(diarreia), questao07) :-
	write('A diarreia começou nos últimos três dias?(s ou n)'),nl.
pergunta(sintoma(diarreia), questao08) :-
	write('O paciente estava constipado e com diarreia ao mesmo tempo?(s ou n)'),nl.
pergunta(sintoma(diarreia), questao09) :-
	write('O paciente tem tomado algum medicamento?(s ou n)'),nl.
pergunta(sintoma(diarreia), questao10) :-
	write('As vezes o paciente contêm pedacinhos reconheciveis de comida?(s ou n)'),nl.
pergunta(sintoma(diarreia), questao11) :-
	write('O paciente tem algum dos seguintes sintomas: dores abnominais, vômito, febre?(s ou n)'),nl.
pergunta(sintoma(diarreia), questao12) :-
	write('O paciente tem menos de três anos?(s ou n)'),nl.
pergunta(sintoma(diarreia), questao13) :-
	write('A diarreia começou logo antes de um evento ou período emocionante ou estressante?(s ou n)'),nl.

pergunta(sintoma(dermatite_febre), questao01) :-
	write('A erupção na pele do paciente consiste em manchas achatadas que não desaparecem quando apertadas?(s ou n)'),nl.
pergunta(sintoma(dermatite_febre), questao02) :-
	write('A erupção cutânea (dermatite) é suave e vermelha ou de manchas elevadas vermelhas que desvanevem quando apertadas?(s ou n)'),nl.
pergunta(sintoma(dermatite_febre), questao03) :-
	write('Há grupos de manchas irritadas que criam bolhas e secam em crostas?(s ou n)'),nl.
pergunta(sintoma(dermatite_febre), questao04) :-
	write('A erupção na pele consiste em manchas achatadas cor-de-rosa que começam no rosto ou no tronco?(s ou n)'),nl.
pergunta(sintoma(dermatite_febre), questao05) :-
	write('Antes do surgimento da erupção cutânea (dermatite), o paciente teve também um desses sintomas: coriza, tosse, olhos vermelhos?(s ou n)'),nl.
pergunta(sintoma(dermatite_febre), questao06) :-
	write('O paciente tem dor de garganta e/ou vômito?(s ou n)'),nl.
pergunta(sintoma(dermatite_febre), questao07) :-
	write('O paciente tomou algum medicamento durante a última semana?(s ou n)'),nl.
pergunta(sintoma(dermatite_febre), questao08) :-
	write('A temperatura do paciente foi de 38C ou mais, três ou quatro dias antes do surigmentoda erupção cultânea(dermatite)?(s ou n)'),nl.
pergunta(sintoma(dermatite_febre), questao09) :-
	write('A erupção na pele do paciente é vermelha e brilhante e está limitada ás bochechas?(s ou n)'),nl.

pergunta(sintoma(vomito), questao01) :-
	write('O paciente parece estar bem e aceita ser alimentado como sempre?(s ou n)'),nl.
pergunta(sintoma(vomito), questao02) :-
	write('O paciente tem febre?(s ou n)'),nl.
pergunta(sintoma(vomito), questao04) :-
	write('O leite saiu sem esforço?(s ou n)'),nl.
pergunta(sintoma(vomito), questao05) :-
	write('O paciente está com tosse?(s ou n)'),nl.
pergunta(sintoma(vomito), questao06) :-
	write('O paciente está com diarreia?(s ou n)'),nl.
pergunta(sintoma(vomito), questao07) :-
	write('O paciente está anormalmente sonolento ou rejeita ser alimentado?(s ou n)'),nl.
pergunta(sintoma(vomito), questao08) :-
	write('O paciente apresenta dois ou mais dos seguintes sintomas: febre, dor ao urinar, dores abnominais, faz xixi na cama?(s ou n)'),nl.
pergunta(sintoma(vomito), questao09) :-
	write('O paciente está com diarreia?(s ou n)'),nl.
pergunta(sintoma(vomito), questao10) :-
	write('O paciente está com tosse?(s ou n)'),nl.
pergunta(sintoma(vomito), questao11) :-
	write('O vomito do paciente e de cor esverdeada?(s ou n)'),nl.
pergunta(sintoma(vomito), questao12) :-
	write('O paciente teve dor constante por seis horas?(s ou n)'),nl.
pergunta(sintoma(vomito), questao13) :-
	write('O paciente esta anormalmente sonolento?(s ou n)'),nl.
pergunta(sintoma(vomito), questao14) :-
	write('O paciente está com as fezes pálidas e a urina incomumente escura?(s ou n)'),nl.
pergunta(sintoma(vomito), questao15) :-
	write('O paciente estava muito agitado ou irritado antes de vomitar?(s ou n)'),nl.
pergunta(sintoma(vomito), questao16) :-
	write('O vomito ocorreu durante ou logo após uma viagem?(s ou n)'),nl.
pergunta(sintoma(vomito), questao17) :-
	write('O paciente sofreu alguma pancada na cabeça nos últimos dias?(s ou n)'),nl.
pergunta(sintoma(vomito), questao18) :-
	write('O vomito é seguido por crises de tosse?(s ou n)'),nl.
pergunta(sintoma(vomito), questao19) :-
	write('O paciente tem um dos seguintes sintomas: dor de cabeça, manchas achatadas, cor-de-rosa ou roxas que não desaparecem quando apertadas?(s ou n)'),nl.

pergunta(sintoma(problemas_de_pele), questao01) :-
	write('O paciente tem 3 meses ou mais?(s ou n)'),nl.
pergunta(sintoma(problemas_de_pele), questao02) :-
	write('O paciente tem alguma erupção na pele com escamas e que coça no rosto, no lado interno dos cotovelos ou atrás dos joelhos?(s ou n)'),nl.
pergunta(sintoma(problemas_de_pele), questao03) :-
	write('O paciente tem placas amarelas com crostas no couro cabeludo(s ou n)?'),nl.
pergunta(sintoma(problemas_de_pele), questao04) :-
	write('O paciente está com uma erupção na pele inflamada com escamas?(s ou n)'),nl.
pergunta(sintoma(problemas_de_pele), questao05) :-
	write('A erupção cutânea está em dois ou mais dos seguintes lugares: pescoço, atrás das orelhas, rosto, verilha, axilas?(s ou n)'),nl.
pergunta(sintoma(problemas_de_pele), questao06) :-
	write('O paciente está com manchas inflamadas na área da fralda?(s ou n)'),nl.
pergunta(sintoma(problemas_de_pele), questao07) :-
	write('O paciente apresenta manchas ou marcas em alguma parte do corpo?(s ou n)'),nl.
pergunta(sintoma(problemas_de_pele), questao08) :-
	write('O paciente está bem e come normalmente?(s ou n)'),nl.
pergunta(sintoma(problemas_de_pele), questao10) :-
	write('O paciente tem febre?(s ou n)'),nl.

pergunta(sintoma(manchas_e_dermatites), questao01) :-
	write('O paciente tem febre?(s ou n)'),nl.
pergunta(sintoma(manchas_e_dermatites), questao02) :-
	write('O paciente tem coceira?(s ou n)'),nl.
pergunta(sintoma(manchas_e_dermatites), questao03) :-
	write('O paciente tem grupos de caroços, cada um com uma depressão central?(s ou n)'),nl.
pergunta(sintoma(manchas_e_dermatites), questao04) :-
	write('O paciente tem áreas cheias de pus ou crostas amareladas, muitas vezes no rosto?(s ou n)'),nl.
pergunta(sintoma(manchas_e_dermatites), questao05) :-
	write('O paciente tem um ou mais caroços firmes e ásperos?(s ou n)'),nl.
pergunta(sintoma(manchas_e_dermatites), questao06) :-
	write('O paciente tem um caroço dolorido vermelho, eventualmente com um pico amarelo?(s ou n)'),nl.
pergunta(sintoma(manchas_e_dermatites), questao07) :-
	write('O paciente está com manchas pequenas vermelhas e irritadas ou bolhas cheias de liquido?(s ou n)'),nl.
pergunta(sintoma(manchas_e_dermatites), questao08) :-
	write('O paciente está tomando algum medicamento?(s ou n)'),nl.
pergunta(sintoma(manchas_e_dermatites), questao09) :-
	write('O paciente está com a pele vermelha e inflamada, talvez com bolhas ou secreção, principalmente no rosto e em torno das juntas?(s ou n)'),nl.
pergunta(sintoma(manchas_e_dermatites), questao10) :-
	write('O paciente está com a pele vermelha e inflamada, com extremidades claramente definidas e com escamas?(s ou n)'),nl.
pergunta(sintoma(manchas_e_dermatites), questao11) :-
	write('O paciente está com manchas pequenas e inflamadas em uma área?(s ou n)'),nl.
pergunta(sintoma(manchas_e_dermatites), questao12) :-
	write('O paciente está com manchas vermelhas levemente elevadas e brilhante?(s ou n)'),nl.
pergunta(sintoma(manchas_e_dermatites), questao13) :-
	write('O rosto ou a boca do paciente estão inchados?(s ou n)'),nl.

pergunta(sintoma(problemas_respiratorios), questao01) :-
	write('Os problemas respiratorios do paciente começaram de repente, alguns minutos atrás?(s ou n)'),nl.
pergunta(sintoma(problemas_respiratorios), questao02) :-
	write('Há algum sinal de perigo?(s ou n)'),nl,
	write('    SINAIS DE PERIGO'),nl,
	write('        -Lábios ou língua azulados.'),nl,
	write('        -Sonolência anormal.'),nl,
	write('        -Incapacidade de falar ou emitir sons normalmente.'),nl,
	write('        -Respiração difícil - as áreas entre as costelas e abaixo delas, bem como as narinas, tremem a cada respiro.'),nl.
pergunta(sintoma(problemas_respiratorios), questao03) :-
	write('O paciente tem menos de 18 meses?(s ou n)'),nl.
pergunta(sintoma(problemas_respiratorios), questao04) :-
	write('O paciente poderia estar sufocando com algum material objeto pequeno?(s ou n)'),nl.
pergunta(sintoma(problemas_respiratorios), questao05) :-
	write('O paciente já teve no passado um ataque de asma ou está em tratamento para asma?(s ou n)'),nl.
pergunta(sintoma(problemas_respiratorios), questao06) :-
	write('O paciente teve desde o nascimento uma respiração ruidosa, mas, fora isso, está bem?(s ou n)'),nl.
pergunta(sintoma(problemas_respiratorios), questao07) :-
	write('O paciente sofre repetidamente de um dos seguintes sintomas?(s ou n)'),nl,
	write('        -Arquejar'),nl,
	write('        -Respiração curta'),nl,
	write('        -Tosse à noite'),nl.
pergunta(sintoma(problemas_respiratorios), questao08) :-
	write('O paciente tem respiração rápida, febre e tosse?(s ou n)'),nl.
pergunta(sintoma(problemas_respiratorios), questao09) :-
	write('O paciente está rouco, tem respiração ruidosa e tosse "berrante"?(s ou n)'),nl.

pergunta(sintoma(tosse), questao01) :-
	write('A respiração do paciente está anormalmente rápida ou ruidosa?(s ou n)'),nl.
pergunta(sintoma(tosse), questao02) :-
	write('O paciente tem febre?(s ou n)'),nl.
pergunta(sintoma(tosse), questao03) :-
	write('A tosse vem em ataques que terminam em uma arfada e/ ou vem acompanhado por vômito?(s ou n)'),nl.
pergunta(sintoma(tosse), questao04) :-
	write('O paciente tem alguma erupção na pele ou teve recentemente contato com alguém que tinha sarampo?(s ou n)'),nl.
pergunta(sintoma(tosse), questao05) :-
	write('O paciente está tossindo principalmente à noite, mas muito menos durante o dia?(s ou n)'),nl.
pergunta(sintoma(tosse), questao06) :-
	write('A tosse vem em ataques que terminam em uma arfada e/ou vem acompanhada por vômito?(s ou n)'),nl.
pergunta(sintoma(tosse), questao07) :-
	write('O paciente tem tossido por 24 horas ou mais?(s ou n)'),nl.
pergunta(sintoma(tosse), questao08) :-
	write('O paciente está com o nariz entupido ou com coriza?(s ou n)'),nl.
pergunta(sintoma(tosse), questao09) :-
	write('O nariz de seu filho está sempre com coriza?(s ou n)'),nl.
pergunta(sintoma(tosse), questao10) :-
	write('O paciente teve coqueluche nos últimos meses?(s ou n)'),nl.
pergunta(sintoma(tosse), questao11) :-
	write('O paciente foi diagnosticado com asma?'),nl.
pergunta(sintoma(tosse), questao12) :-
	write('Alguém na casa do paciente fuma ou o paciente fumou?(s ou n)'),nl.

pergunta(sintoma(garganta_inflamada), questao01) :-
	write('O paciente tem febre e parece não estar bem?(s ou n)'),nl.
pergunta(sintoma(garganta_inflamada), questao02) :-
	write('O paciente tem vômito, erupção na pele e a língua e a garganta estão brilhantes e vermelhas?(s ou n)'),nl.
pergunta(sintoma(garganta_inflamada), questao03) :-
	write('O paciente sente dor ao tentar engolir algo ou não quer comer alimentos sólidos?(s ou n)'),nl.
pergunta(sintoma(garganta_inflamada), questao04) :-
	write('O paciente está espirrando, tem coriza e tosse?(s ou n)'),nl.

pergunta(sintoma(problemas_bucais), questao01) :-
	write('O paciente tem áreas doloridas nos lábios ou em torno deles?(s ou n)'),nl.
pergunta(sintoma(problemas_bucais), questao02) :-
	write('O paciente está com uma dor que afeta somente a língua?(s ou n)'),nl.
pergunta(sintoma(problemas_bucais), questao03) :-
	write('O paciente tem gengivas doloridas, vermelhas ou inchadas?(s ou n)'),nl.
pergunta(sintoma(problemas_bucais), questao04) :-
	write('O paciente tem áreas doloridas e de cor diferente dentro da boca e na língua?(s ou n)'),nl.
pergunta(sintoma(problemas_bucais), questao05) :-
	write('O paciente poderia estar com dentição?(s ou n)'),nl.
pergunta(sintoma(problemas_bucais), questao06) :-
	write('As áreas parecem feridas com centro cinzentos?(s ou n)'),nl.
pergunta(sintoma(problemas_bucais), questao07) :-
	write('Há pequenas bolhas ou feridas nos lábios ou em torno deles?(s ou n)'),nl.
pergunta(sintoma(problemas_bucais), questao08) :-
	write('As áreas em torno da boca ou as fendas nos extremos dos lábios estão avermelhados?(s ou n)'),nl.
pergunta(sintoma(problemas_bucais), questao09) :-
	write('Em torno dos lábios há crostas cor de palha ou em mel?(s ou n)'),nl.
pergunta(sintoma(problemas_bucais), questao10) :-
	write('O paciente tem manchas nas mãos e nos pés?(s ou n)'),nl.
pergunta(sintoma(problemas_bucais), questao11) :-
	write('As manchas são de cor amarelo-creme e saem facilmente ao passar a unha?(s ou n)'),nl.


arvore(nil) :- !.
arvore(t(X, L, R)) :-
	X,
	leitura3(OPC),
	(OPC == 's' -> arvore(R);arvore(L)),!.
arvore(X) :-
	X.

leitura1(OPC) :-
	get_char(Y), get_char(L),
	leitura(L,OPC)->((Y == '1'; Y == '2') -> OPC = Y; opcao_valida,leitura1(OPC),!); opcao_valida,leitura1(OPC).
leitura2(OPC) :-
	get_char(Y), get_char(L),
	leitura(L,OPC)->((Y == '1'; Y == '2'; Y == '3'; Y == '4'; Y == '5'; Y == '6'; Y == '7'; Y == '8'; Y == '9'; Y == '0') -> OPC = Y;opcao_valida,leitura2(OPC),!);
	                opcao_valida,leitura2(OPC).
leitura3(OPC) :-
	get_char(Y), get_char(L),
	leitura(L,OPC)->((Y == 's'; Y == 'n') -> OPC = Y;opcao_valida,leitura3(OPC),!); opcao_valida,leitura3(OPC).
leitura('\n', _) :- !.
leitura(' ', _) :- !.
leitura(_, OPC) :-
	get_char(Next),
	leitura(Next,OPC),0==1.

opcao_valida :- write('Escolha uma opção válida!\n').
