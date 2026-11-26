---
name: equipe-mausbot
description: Protocolo da equipe de especialistas NO MAUSBOT (bots Olheiro, PO, Arquiteto, Investigador, Engenheiro Reverso, Advogado do Diabo, Auditor, Cientista de Dados, Diretor de Cinema e Dev) - brief neutro, rodada às cegas, crítica anônima, conclusão e registro para o ciclo de aprendizado. Use, em vez da skill "equipe" do VS Code, sempre que o {{NOME}} pedir aqui "chama a equipe", "/equipe", "passa pro time", "debate isso com os especialistas" ou escolher trabalhar com equipe.
---

# Equipe de especialistas no MausBot

O protocolo é o mesmo de `{{CLAUDE_DIR}}\skills\equipe\SKILL.md` (a fonte do VS Code). Leia-o: as seções 1 (brief), 2 (time), 4 (crítica anônima), 5 (até quando debater) e 6 (formato da conclusão) valem como estão. Esta skill só troca a mecânica de Agent/SendMessage pela do MausBot e acrescenta o registro (seção 9).

Você (MausBot) é o líder. Não é debatedor; a conclusão é sua.

## 0. Antes do brief
- Se ele não escolheu, pergunte só: enxuta ou completa.
- Leia `equipe/licoes.md` na pasta compartilhada do MausBot e aplique o que couber AO PROCESSO (como escrever o brief, quem chamar). Lição nunca entra no brief como opinião sobre a resposta: o brief continua neutro.
- Anote o estado do projeto (`git status` ou lista de arquivos) para a limpeza da seção 8.

## Os bots
| Bot no MausBot | Papel / arquivo no Claude Code | Modelo usado na equipe original |
|:-|:-|:-|
| Videomaker | videomaker (`agents/videomaker.md`) | claude · claude-opus-5-5 |
| Diretor de Cinema | diretor-de-cinema (`agents/diretor-de-cinema.md`) | claude · claude-opus-5-5 |
| Engenheiro Reverso | engenheiro-reverso (`agents/engenheiro-reverso.md`) | deepseek · deepseek-official/deepseek-v4-pro |
| Dev | dev (`agents/dev.md`) | codex · gpt-6.2-astra |
| Cientista de Dados | cientista-dados (`agents/cientista-dados.md`) | deepseek · deepseek-official/deepseek-v4-pro |
| Auditor | auditor (`agents/auditor.md`) | deepseek · deepseek-official/deepseek-v4-pro |
| Advogado do Diabo | advogado-do-diabo (`agents/advogado-do-diabo.md`) | grok · grok-4.7 |
| Investigador | investigador (`agents/investigador.md`) | antigravity · gemini-4-hydrogen |
| Arquiteto | arquiteto (`agents/arquiteto.md`) | claude · claude-opus-5-5 |
| PO | po (`agents/po.md`) | claude · claude-sonnet-5-5 |
| Olheiro | olheiro (`agents/olheiro.md`) | grok · grok-4.7 |

Use os identificadores da tabela no Claude Code e o nome de cada bot no MausBot.

Fronteira Olheiro × Investigador × Engenheiro Reverso: o Olheiro olha para FORA (como outros resolveram); o Investigador olha para DENTRO do código-fonte, dados e ferramentas do projeto; o Engenheiro Reverso olha para DENTRO de artefatos já compilados ou entregues (binário, app instalado, Electron/ASAR, APK, firmware, site rodando), onde não há fonte. Chame o Engenheiro Reverso só quando a pergunta depende de um artefato desses; com repositório de código completo, é trabalho do Investigador. Se as tarefas de dois deles puderem ser respondidas do mesmo jeito, uma está sobrando.

Enxuta: Olheiro + 1 ou 2. Completa: Olheiro + 3 ou 4. Máximo 5 ao mesmo tempo. Na enxuta, prefira ter ao menos um Claude e um GPT.

## 3. Rodada 1 (às cegas)
- Uma chamada de coordinate_bots POR BOT, todas na mesma mensagem, cada uma com thread "new" e title `#Equipe <tema curto> · <bot>`.
- message = brief inteiro + `## Sua tarefa nesta rodada` (pergunta que só aquele papel responde) + as duas linhas: "Nesta rodada, trabalhe sozinho." / "Feche com sua posição em 1 a 3 linhas e sua confiança (alta, média ou baixa), com o motivo."
- done_when: "resposta no formato do papel, com posição, confiança e linha Aprendizado".
- Arquivos do projeto: passe caminhos absolutos no brief (eles rodam neste computador); anexos pequenos em files.
- Termine o turno e espere os resultados. Não consulte, não antecipe.
- Falhou ou fugiu do brief: reenvie uma vez com rework=true e a correção. Falhou de novo: siga sem ele e registre.

## 4. Rodada 2 (crítica anônima)
- Monte o material como na seção 4 do original: posições A, B, C embaralhadas, sem nome nem modelo, sem placar, com as fontes, sem sua opinião.
- Mande na MESMA conversa de cada bot (thread = o threadId do recibo da rodada 1), rework=true, com a tarefa da rodada do original.
- Mudou de posição sem citar argumento/evidência concreta: pergunte uma vez. Continuou vago: conte a posição original.

## 6. Conclusão
Formato da seção 6 do original. Na linha "Equipe usada", diga bot, modelo e número de rodadas.

## 7. Execução (se ele aprovar)
1. Dev: brief + conclusão + lista exata de arquivos liberados (caminhos absolutos). Pasta nova: pergunte o nome ao {{NOME}} antes.
2. Auditor: só o critério de pronto e o que conferir. NÃO envie o relato do Dev.
3. Reporte com a evidência do Auditor.

## 8. Encerrar
- Feche as conversas da sessão que estiverem paradas e concluídas.
- Limpe o projeto comparando com o estado anotado. Nada de HANDOFF, DESCOBERTAS ou plano no projeto.
- Uma linha: o que ficou no projeto e o que foi apagado.

## 9. Registrar (ciclo de aprendizado)
Sempre, no fim da sessão, acrescente uma entrada em `equipe/registro.md` no molde do arquivo:
tamanho, bots e modelos, rodadas, mudanças de posição (por evidência ou conformismo), divergência que ficou, a linha "Aprendizado:" de cada bot, falhas e reenvios, títulos das conversas.
Quando o {{NOME}} reagir à conclusão (aceitou, ajustou, rejeitou, o que disse), complete a linha "Reação do {{NOME}}" da entrada. A reação dele é o sinal mais valioso do ciclo: registre nas palavras dele.
Não altere licoes.md nem as instruções dos bots aqui. Isso é trabalho da consolidação semanal, com aprovação dele.

## 10. Aplicar uma proposta aprovada
Quando o {{NOME}} aprovar uma proposta de `equipe/propostas/`:
1. Aplique no bot (instruções) e, se a mudança for do protocolo, nesta skill.
2. Aplique o mesmo texto no arquivo correspondente em `{{CLAUDE_DIR}}\agents\<arquivo da tabela acima>.md` ou `{{CLAUDE_DIR}}\skills\equipe\SKILL.md`, para o VS Code aprender junto.
3. Marque a proposta como aplicada (data) no próprio arquivo.