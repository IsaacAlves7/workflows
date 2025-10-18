# ⏱ CRON
<img src="https://user-images.githubusercontent.com/61624336/234996362-0217ee9a-b372-4567-b770-28a6a9102c1f.png" height="77" align="right">

**Cron** é um agendador de tarefas utilizado principalmente em sistemas Unix e Linux, cuja função é executar comandos ou scripts de forma automática em horários e intervalos específicos definidos pelo usuário. Ele funciona a partir de um daemon chamado `cron`, que fica rodando em segundo plano, monitorando os arquivos de agendamento chamados `crontabs`, e executando as tarefas nos momentos indicados. A configuração de uma tarefa cron é feita através de uma sintaxe específica que define o minuto, a hora, o dia do mês, o mês, o dia da semana e o comando a ser executado, tudo em uma linha só, o que permite um controle bastante preciso sobre quando as tarefas devem rodar.

Resumindo, o serviço **CRON** é responsável por executar tarefas agendadas de forma automática e recorrente de acordo com a peridiocidade que você definir. E uma dessas tarefas que o serviço Cron irá executar são os serviços **cron jobs**. E para gerenciar esses cron-jobs, iremos precisar de uma tabela chamada **cron-tab**. O cron (ou mais precisamente, o daemon cron) já vem nativo na maioria dos sistemas operacionais Unix-like.

É necessário utilizar o prompt de comando ou Terminal para utilizar o CRON (sistema operacional Linux ou macOS). Portanto, o Cron é um serviço iniciado no plano de fundo, ele é instalado no processo de BOOT da máquina e fica verificando a todo momento se tem tarefas agendadas para ele executar.

Ver o status do cron:

```bash
sudo service cron status
```

Iniciar o processo cron:

```sh
sudo service cron start
```

No Windows, o equivalente a um cron job do Linux é o Agendador de Tarefas (Task Scheduler). Para criar uma tarefa agendada via linha de comando (CMD), você pode usar o utilitário schtasks.exe, que já vem instalado no sistema.

Exemplo: Agendar um script para rodar todos os dias às 14h. Suponha que você tenha um script chamado `meuscript.bat` localizado em `C:\Scripts\meuscript.bat`. Abra o CMD como Administrador e execute:

```cmd
schtasks /create /tn "RodarMeuScript" /tr "C:\Scripts\meuscript.bat" /sc daily /st 14:00
```

No contexto do PHP e, especialmente, do Laravel, o `cron` é fundamental para automatizar tarefas recorrentes dentro da aplicação. Em PHP puro, é comum utilizar scripts que precisam rodar periodicamente para limpar cache, gerar relatórios, enviar notificações por e-mail ou qualquer outro tipo de processamento assíncrono. Esses scripts podem ser configurados no sistema operacional para serem executados via cron, que chamaria o interpretador do PHP passando o caminho do script como argumento. Já no Laravel, há uma estrutura mais refinada para lidar com agendamentos, chamada de task scheduling, que abstrai a complexidade do `crontab` e permite definir tarefas programadas diretamente dentro do código da aplicação, de forma mais expressiva e controlada, através do método `schedule` do `Kernel.php`.

Apesar dessa abstração que o Laravel oferece, o uso do cron em si ainda é necessário, porque é ele quem dispara a execução do agendador do Laravel. Ou seja, ao invés de criar uma entrada para cada tarefa dentro do `crontab`, você configura uma única linha que roda a cada minuto, chamando o comando `php artisan schedule:run`. Esse comando verifica todas as tarefas programadas no Laravel e executa somente as que devem rodar naquele momento, com base nas condições especificadas pelo desenvolvedor. Essa abordagem centraliza e organiza melhor a automação, tornando mais fácil manter e evoluir o sistema, especialmente em ambientes complexos com múltiplas tarefas periódicas.

Portanto, mesmo em aplicações modernas como as feitas com Laravel, o cron ainda é uma engrenagem essencial. Ele continua sendo o motor silencioso que dispara a execução automática de rotinas críticas para o funcionamento contínuo e eficiente da aplicação, sendo altamente confiável, leve e nativo nos sistemas Unix-like.

Com Python também é muito comum usar o `cron` para agendar a execução de scripts. O funcionamento é o mesmo que em qualquer outro contexto: o cron chama o interpretador Python (`python` ou `python3`, dependendo do ambiente) passando o caminho do script `.py` como argumento. Isso permite automatizar tarefas como extração de dados, envios de relatórios, execução de web scrapers, limpeza de arquivos temporários, integração com APIs e muitos outros tipos de processamento automático.

Python se integra muito bem com cron, sendo uma das formas mais simples e confiáveis de rodar scripts Python de forma periódica em produção. 

Por exemplo, se você tem um script Python chamado `processar_dados.py`, você poderia adicionar ao seu `crontab` uma linha como:

```bash
*/30 * * * * /usr/bin/python3 /caminho/para/processar_dados.py
```

Essa linha executaria o script a cada 30 minutos. Para garantir que o script funcione corretamente, é importante configurar corretamente os caminhos absolutos e garantir que as permissões e ambientes estejam acessíveis (por exemplo, variáveis de ambiente, diretórios virtuais, dependências etc.).

Em ambientes mais robustos, como quando se usa Python com frameworks como Django ou Flask, também é comum centralizar a lógica de agendamento e acionar os scripts com cron, da mesma forma que o Laravel faz com `schedule:run`. O Django, por exemplo, não tem um sistema de agendamento interno como o Laravel, então você geralmente define suas tarefas em arquivos separados (ou usa bibliotecas como `django-celery` com agendadores próprios), e o cron serve como mecanismo de disparo externo.

![Data version control](https://github.com/user-attachments/assets/859dc68c-33da-4cc2-8d80-9ce1ecc67b43)
