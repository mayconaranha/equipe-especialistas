# Equipe de especialistas (MausBot + Claude Code)

Onze bots especialistas que trabalham juntos sob um líder. O líder escreve um brief neutro, cada especialista responde sozinho, depois todos criticam as posições dos outros sem saber quem escreveu cada uma, e o líder fecha a conclusão. Há também um ciclo de aprendizado: cada sessão vira uma entrada no registro, e as lições são revisadas toda semana.

Os mesmos bots existem em dois formatos:

- **`mausbot/`**: bots do OpenMausBot (instruções em `SOUL.md`, modelo e ferramentas em `bot.json`) e a skill do líder `equipe-mausbot`.
- **`claude-code/`**: subagentes do Claude Code (`~/.claude/agents`) e a skill `equipe` (chamada com `/equipe`).

## Os especialistas

| Bot | Papel | Modelo original | Ferramentas (MCP) | Skills |
|:-|:-|:-|:-|:-|
| Olheiro | Procura quem já resolveu problema parecido (GitHub, fóruns, docs, papers) | Grok 4.7 | fetch, context7 | deanpeters: research-synthesis, competitive-analysis-process |
| PO | Objetivo, escopo e critérios de aceite | Claude Sonnet 5.5 | | deanpeters: problem-statement, user-story, prioritization-advisor, jobs-to-be-done · mattpocock: to-spec |
| Arquiteto | 2 ou 3 abordagens, recomendação e plano | Claude Opus 5.5 | context7 | superpowers: brainstorming, writing-plans · mattpocock: codebase-design, improve-codebase-architecture |
| Investigador | Fatos do código, dos dados e das ferramentas do projeto | Gemini 4 Hydrogen | serena, context7, fetch | trailofbits: audit-context-building, entry-point-analyzer · mattpocock: research, diagnosing-bugs |
| Advogado do Diabo | Pre-mortem e riscos | Grok 4.7 | | trailofbits: sharp-edges, supply-chain-risk-auditor · mattpocock: grill-me |
| Auditor | Plano de verificação e checagem independente | DeepSeek V4 Pro | playwright, context7 | superpowers: verification-before-completion · trailofbits: property-based-testing, mutation-testing, differential-review |
| Cientista de Dados | Método estatístico, ML e interpretação | DeepSeek V4 Pro | context7 | K-Dense: exploratory-data-analysis, statistical-analysis, statistical-power, statsmodels, scikit-learn, shap |
| Dev | Único que escreve arquivos; implementa o plano aprovado | GPT-6.2-Astra (Codex) | context7, playwright | superpowers: test-driven-development, systematic-debugging, verification-before-completion · mattpocock: diagnosing-bugs |
| Engenheiro Reverso | Como um programa, app, APK ou site funciona por dentro | DeepSeek V4 Pro | REA pela linha de comando | reverse-engineer-anything (REA) · trailofbits: yara-rule-authoring, dwarf-expert, firebase-apk-scanner |
| Diretor de Cinema | Direção, storyboard e aprovação de cada vídeo | Claude Opus 5.5 | rea | earshot, ffmpeg-skill, hyperframes |
| Videomaker | Produz o vídeo inteiro: personagem, animação, narração, legenda, trilha e render | Claude Opus 5.5 | | hyperframes, hyperframes-cli, hyperframes-registry, earshot, ffmpeg-skill, video, ad-creative, remotion-* |

Os modelos são os que funcionaram melhor para cada papel. Dá para trocar por qualquer outro: as instruções não dependem do modelo.

## Instalação

Precisa de Windows, Git, Node 20+ e PowerShell. O Python e o `uv` só são necessários para as ferramentas `serena` e `fetch`.

```powershell
git clone https://github.com/mayconaranha/equipe-especialistas
cd equipe-especialistas
powershell -ExecutionPolicy Bypass -File .\install.ps1 -Nome "SeuNome"
```

O script:

1. Baixa as skills de terceiros: os cinco repositórios de método (superpowers, mattpocock, trailofbits, deanpeters, K-Dense), na versão testada, em `~/.claude/skills/vendor`, e as skills de vídeo e de engenharia reversa pelo `npx skills add`.
2. Instala os 11 agentes em `~/.claude/agents` e a skill `equipe` em `~/.claude/skills/equipe`, já com seu nome e os seus caminhos.
3. Gera em `saida/mausbot/` as instruções finais de cada bot do MausBot, a skill do líder e a pasta `equipe/` do ciclo de aprendizado.

Opções: `-ClaudeDir` (padrão `~/.claude`), `-ToolsDir` (onde ficam Node, Ghidra e JDK do REA; padrão `~/tools`), `-MausbotDir` (a pasta compartilhada do seu bot principal no MausBot; padrão `saida/mausbot`), `-SemTerceiros` (não baixa as skills de terceiros).

### No Claude Code

Depois do script, os agentes já aparecem. Digite `/equipe` ou peça "chama a equipe".

### No MausBot

Abra o seu bot principal (o Chief of Staff) e peça:

> Crie os 11 bots descritos em `<caminho>\saida\mausbot\bots`. Para cada pasta, use o nome e o título do `bot.json`, as instruções do `SOUL.md`, o modelo indicado (ou o mais próximo que eu tiver) e ligue os servidores MCP listados em `mcpServers`. Depois salve `saida\mausbot\skills\equipe-mausbot\SKILL.md` como uma skill sua e copie a pasta `saida\mausbot\equipe` para a sua pasta compartilhada.

Se você passou `-MausbotDir`, a pasta `equipe/` já vai direto para o lugar certo.

### Ferramentas (MCP)

`mcp-servers.example.json` tem a configuração dos cinco servidores. Instale o que for usar:

```powershell
npm i -g @upstash/context7-mcp @playwright/mcp rea-agents
npx playwright install chromium
uv tool install mcp-server-fetch
uv tool install serena-agent
```

O Videomaker e o Diretor de Cinema também usam o comando `earshot` (instale como diz https://github.com/Leonxlnx/earshot). O REA precisa do Ghidra e de um JDK (veja https://github.com/morluto/rea). Depois rode `rea doctor` para conferir.

No MausBot, adicione cada servidor em Configurações e ligue nos bots da tabela. No Claude Code, use `claude mcp add`.

## Origem das skills

| Skill | Repositório | Licença |
|:-|:-|:-|
| superpowers | https://github.com/obra/superpowers | ver repositório |
| mattpocock | https://github.com/mattpocock/skills | ver repositório |
| trailofbits | https://github.com/trailofbits/skills | ver repositório |
| Product Manager Skills | https://github.com/deanpeters/Product-Manager-Skills | ver repositório |
| scientific-agent-skills | https://github.com/K-Dense-AI/scientific-agent-skills | ver repositório |
| hyperframes | https://github.com/heygen-com/hyperframes | Apache-2.0 |
| remotion | https://github.com/remotion-dev/skills | ver repositório |
| earshot | https://github.com/Leonxlnx/earshot | MIT |
| ffmpeg-skill | https://github.com/kajisho5/ffmpeg-skill | MIT |
| video, ad-creative | https://github.com/coreyhaines31/marketingskills | MIT |
| reverse-engineer-anything (REA) | https://github.com/morluto/rea | MIT |

As skills de terceiros não estão copiadas aqui: o script baixa cada uma do repositório original. Este repositório tem só as instruções dos bots e o protocolo da equipe.

## Ajustes que valem a pena

- **Videomaker:** a seção "Marca do projeto" está em branco. Preencha com a paleta, o logo e a pasta do seu projeto, ou apague.
- **Ferramentas da máquina:** o Videomaker cita FFmpeg 8.1, Node 25, Python 3.14, edge-tts e faster-whisper. Instale ou ajuste o texto.
- **Arquiteto:** assume que você trabalha sozinho e tem orçamento limitado. Mude se não for o caso.
