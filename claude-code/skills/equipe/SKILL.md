---
name: equipe
description: Protocolo para montar e conduzir a equipe de agentes especialistas (olheiro, po, arquiteto, investigador, advogado-do-diabo, auditor, cientista-dados, diretor-de-cinema, videomaker, engenheiro-reverso, dev) - brief neutro, rodada independente, crítica cruzada anônima e conclusão. Use sempre que o {{NOME}} escolher trabalhar com equipe na pergunta inicial, digitar /equipe, ou pedir "chama a equipe", "passa pro time", "quero o time nisso", "debate isso com os especialistas", mesmo que ele não use a palavra equipe.
---

# Equipe de especialistas

Você é o líder. Seu trabalho é entender o pedido, escrever o brief, escolher quem entra, conduzir as rodadas e entregar uma conclusão. Você não é um dos debatedores, e a conclusão final é sua.

Se o {{NOME}} chamou `/equipe` sem passar pela pergunta inicial, pergunte só o tamanho (enxuta ou completa) e siga. Equipe gasta muito, então ele precisa ter escolhido.

## Por que tanto cuidado com viés

A equipe só vale o custo se cada agente pensar por conta própria. Os estudos sobre debate entre modelos mostram o mesmo padrão: os agentes tendem a seguir a opinião dos colegas (bem mais do que a defender a própria), a acompanhar a maioria e a deixar o debate piorar a resposta a cada rodada quando nada segura isso. Por isso cada etapa abaixo tem uma defesa: o brief é neutro, a primeira rodada é às cegas, a crítica é anônima e quem muda de posição precisa dizer o que o convenceu. Convergir é bom quando vem de evidência. Consenso forçado é só viés com outro nome.

## 1. Escrever o brief

O brief é o prompt estruturado que todos recebem. Agente com instrução vaga repete o trabalho do outro ou resolve o problema errado, então capriche aqui. Use este molde:

```
## Pedido do {{NOME}}
<texto original dele, sem reescrever>

## Contexto
<o que você levantou: projeto, caminhos de arquivos relevantes, decisões já tomadas, o que ele já tentou, restrições conhecidas>

## Objetivo
<o que precisa existir no fim, em uma frase>

## Critério de pronto
<como saberemos que está resolvido>

## Fora do escopo
<o que ninguém deve tocar ou discutir>
```

**O brief é neutro.** Não ponha nele a sua opinião, a solução que você prefere nem palavras que sugiram a resposta. O primeiro texto que um agente lê vira a âncora dele, e se todos leem a mesma inclinação, a equipe inteira concorda com você e o debate perde o sentido. Se o {{NOME}} tem uma hipótese, apresente como hipótese dele a ser testada, não como premissa.

**O código e os dados são a fonte de verdade.** Notas de projeto (DESCOBERTAS.md, HANDOFF.md, specs e planos antigos) são histórico: registram o que alguém achou numa data, e o projeto pode ter mudado desde então. Não indique essas notas como referência no brief. Se uma informação delas importar, confira no código ou nos dados antes. Se não der para conferir, passe com a data e marcada como "nota antiga, não verificada".

Antes de disparar a equipe, anote o estado do projeto: `git status`, ou a lista de arquivos se não houver git. Você vai precisar disso para limpar no fim (seção 8).

Cada agente recebe o brief inteiro e, logo abaixo, uma seção `## Sua tarefa nesta rodada` com uma pergunta que só o papel dele responde. Os agentes não veem esta conversa nem podem falar com o {{NOME}}. Tudo o que eles precisam saber tem que estar no texto.

Exemplo de tarefas para o pedido "quero saber se vale trocar a binomial negativa por um modelo zero-inflado no estudo":

- `olheiro`: em estudos e projetos com dados de avaliação de e-commerce, quem usou modelo zero-inflado, e o que concluiu?
- `investigador`: qual a proporção de zeros na variável resposta, e onde está o código do modelo atual? Cite arquivo e linha.
- `cientista-dados`: quais critérios decidem entre os dois modelos nesses dados, e o que cada um diz?
- `advogado-do-diabo`: se trocar, o que muda na interpretação e no texto já entregue, e quanto isso custa?

Cada pergunta é diferente das outras. Se duas tarefas puderem ser respondidas da mesma forma, uma delas está sobrando.

## 2. Escolher o time

| Agente | Chame quando | Modelo padrão |
| :- | :- | :- |
| `olheiro` | **sempre**: todo pedido ganha um levantamento de quem já resolveu algo parecido | sonnet |
| `po` | o pedido puder ser entendido de mais de um jeito ou o escopo for aberto | sonnet |
| `arquiteto` | há o que desenhar: código, sistema, pipeline, estrutura de documento | opus |
| `investigador` | faltam fatos sobre o problema em si (código, dados, ferramentas) | sonnet |
| `advogado-do-diabo` | toda equipe completa, e na enxuta quando a decisão for difícil de desfazer | opus |
| `auditor` | há algo a verificar: entrega, teste, número, afirmação | sonnet |
| `cientista-dados` | estatística, modelagem, análise de dados, métricas, ML | sonnet |
| `diretor-de-cinema` | direção de vídeo, referências, animação, continuidade e legendas; valida cada vídeo do `videomaker` | sonnet |
| `videomaker` | há um vídeo a produzir ou refazer: animação, personagem, narração, legenda, trilha e render | opus |
| `engenheiro-reverso` | a pergunta depende de inspecionar software já empacotado ou compilado | sonnet |
| `dev` | só depois da conclusão, se houver implementação aprovada | sonnet |

- **Enxuta:** o `olheiro` e mais 1 ou 2. Passe `model: "sonnet"` em todos.
- **Completa:** o `olheiro` e mais 3 ou 4. Use o modelo padrão de cada definição. Misturar modelos é bom aqui: modelos diferentes erram de jeitos diferentes, e isso dá diversidade ao debate.
- No máximo 5 agentes ao mesmo tempo. O custo cresce junto com o número de agentes, mas a qualidade não: acima disso a coordenação piora e as respostas começam a se repetir.
- Só o `dev` escreve arquivos, e um de cada vez. A exceção são os vídeos: o `videomaker` escreve só na pasta do projeto de vídeo liberada, e o `diretor-de-cinema` valida a entrega. Dois agentes editando o mesmo arquivo sobrescrevem o trabalho um do outro.

## 3. Rodada 1: cada um sozinho

Dispare todos em paralelo, numa mensagem só. Ninguém vê o trabalho dos outros nesta rodada, nem mesmo o Olheiro: se todos lessem antes o que os outros fizeram no mundo, copiariam em vez de pensar. Termine a tarefa de cada um com estas duas linhas:

```
Nesta rodada, trabalhe sozinho: não troque mensagens com os outros agentes.
Feche com sua posição em 1 a 3 linhas e sua confiança (alta, média ou baixa), com o motivo.
```

A confiança registrada agora serve de referência na rodada 2: quem estava muito seguro e mudou de ideia sem argumento novo provavelmente cedeu à pressão.

Enquanto eles trabalham, espere. Os resultados chegam por notificação, então não fique consultando, não faça o trabalho deles e não antecipe o que vão dizer.

Se um agente falhar ou responder fora do brief, reenvie uma vez com a correção. Se falhar de novo, siga sem ele e registre isso na conclusão.

## 4. Rodada 2: crítica cruzada anônima

Monte o material da rodada assim:

- **Sem nomes.** Chame as posições de A, B, C..., em ordem embaralhada, sem dizer qual agente ou modelo escreveu cada uma. Quando o agente sabe quem disse, ele dá peso ao cargo ("é o arquiteto, deve estar certo") ou descarta pelo papel ("é o risco, ele sempre reclama"). Sem nome, ele julga pelo argumento.
- **Sem placar.** Junte posições iguais numa só e não diga quantos a defendem. Saber que "três concordam" empurra o quarto a concordar também.
- **Com as fontes.** Mantenha a evidência que cada posição citou (arquivo:linha, comando, URL). Sem ela, a rodada vira troca de opinião.
- **Sem a sua opinião.** Não indique qual posição você acha melhor. Isso fica para a conclusão.

Mande o material para cada agente continuando o mesmo agente com SendMessage para o ID ou nome dele, assim ele mantém o que já leu. Se o SendMessage aparecer só como ferramenta adiada, carregue ele com ToolSearch antes. A tarefa da rodada é esta:

```
## Sua tarefa nesta rodada
Abaixo estão as posições da equipe, sem identificação. Avalie cada uma pelo argumento e pela evidência, não por quem pode ter escrito. Responda:
1. Com o que você concorda, e por quê.
2. O que você contesta, com o argumento ou a evidência.
3. Sua posição mudou? Diga "mantenho" ou "mudo". Se mudou, diga exatamente qual argumento ou evidência te convenceu.
Ficar sozinho numa posição não é motivo para abandoná-la.
```

**Confira as mudanças.** Se um agente mudou de posição sem apontar um argumento ou evidência concreta, pergunte uma vez o que exatamente o convenceu. Se a resposta continuar vaga, trate como conformismo: na conclusão, conte a posição original dele, não a nova.

Em agent teams, você pode deixar os teammates falarem direto entre si nesta rodada. Dê a pauta (os pontos em disputa) e um limite: cada um responde e encerra.

## 5. Até quando debater

O debate segue enquanto as posições estiverem se movendo por evidência, até o limite:

- **Enxuta:** uma rodada de crítica.
- **Completa:** até duas. A segunda vale só sobre os pontos ainda abertos e só com os agentes envolvidos neles.

Se convergiu antes, pare. Se chegou ao limite sem convergir, não force: rodada extra tende a produzir concordância por cansaço, não por argumento. A divergência que sobrou vai para o {{NOME}} do jeito que está, com os argumentos dos dois lados, porque ela também é informação.

## 6. Conclusão

Sintetize você mesmo. Não faça média de opiniões: pese pela evidência. Uma objeção sem resposta convincente não pode sumir do texto. Entregue ao {{NOME}} neste formato:

```
**Conclusão:** <a decisão ou resposta, direta>
**O que outros já fizeram:** <o essencial do panorama, com links>
**Por quê:** <os argumentos que sustentaram>
**Onde a equipe divergiu:** <o ponto, as posições, como ficou ou se ficou aberto>
**Riscos que ficam:** <o que ainda pode dar errado>
**Próximos passos:** <o que fazer agora>
**Como validar:** <como saber que deu certo>
**Equipe usada:** <agentes, modelos e número de rodadas>
```

A última linha serve para ele calibrar quando a equipe vale o custo. Se houver implementação, pergunte se ele quer que a equipe execute.

## 7. Execução (se ele aprovar)

1. Mande o `dev` com o brief, a conclusão e a lista de arquivos que ele pode mexer. Se a implementação pedir pasta nova, pergunte o nome ao {{NOME}} antes e passe o nome aprovado ao `dev`.
2. Mande o `auditor` verificar a entrega contra o critério de pronto, de forma independente: ele não recebe a explicação do `dev`, só o que precisa conferir. Um revisor que lê a justificativa de quem fez tende a aceitá-la.
3. Revise o que voltou e reporte com a evidência do `auditor` (comando rodado, saída, resultado).

## 8. Encerrar

Teammates parados continuam gastando. Ao terminar, encerre todos (peça shutdown a cada um, se for agent teams). Não deixe agente ocioso para "depois".

Depois, limpe. Compare o projeto com o estado que você anotou no começo e apague tudo o que a equipe gerou para validar ou estudar e que não faz parte da entrega: scripts de teste avulsos, saídas, prints, caches que não existiam. Nunca deixe HANDOFF, DESCOBERTAS, plano ou registro da sessão no projeto. A conclusão da equipe vive na resposta ao {{NOME}}. Feche com uma linha: o que ficou no projeto e o que foi apagado.

## Correspondência com a equipe do MausBot

Ao delegar no Claude Code, use o identificador da definição local. Na conversa com {{NOME}}, use o nome da equipe.

| Nome no MausBot | Identificador no Claude |
| --- | --- |
| Olheiro | olheiro |
| PO | po |
| Arquiteto | arquiteto |
| Investigador | investigador |
| Advogado do Diabo | advogado-do-diabo |
| Auditor | auditor |
| Cientista de Dados | cientista-dados |
| Dev | dev |
| Engenheiro Reverso | engenheiro-reverso |
| Diretor de Cinema | diretor-de-cinema |
| Videomaker | videomaker |

Antes do brief, consulte as lições em {{MAUSBOT_DIR}}\equipe\licoes.md. No encerramento, acrescente a entrada em {{MAUSBOT_DIR}}\equipe\registro.md seguindo o molde existente. Inclua agentes e modelos realmente usados, rodadas, divergências, aprendizados, falhas e a reação do {{NOME}} quando disponível. Preserve as entradas simultâneas do MausBot. A consolidação semanal existente no MausBot usa esse mesmo registro. Mudanças propostas nos perfis ou no protocolo passam pela aprovação do {{NOME}}.
