# ======================================================
# MENU DE SUPORTE TECNICO - AUTOMACAO
# ======================================================

function Pause {
    Write-Host ""
    Read-Host "Pressione ENTER para continuar"
}

function Banner {
    Clear-Host
    Write-Host "=================================================" -ForegroundColor Cyan
    Write-Host "          MENU DO SUPORTE TECNICO" -ForegroundColor Green
    Write-Host "               AUTOMACAO" -ForegroundColor Green
    Write-Host "=================================================" -ForegroundColor Cyan
    Write-Host ""
}

function Menu {
    Banner

    Write-Host "1.  Verificar/Agendar CHKDSK"
    Write-Host "2.  Reparar Arquivos de Sistema (SFC)"
    Write-Host "3.  Limpar Arquivos Temporarios"
    Write-Host "4.  Diagnostico de Memoria"
    Write-Host "5.  Teste de Rede (Ping + DNS)"
    Write-Host "6.  Abrir Gerenciador de Tarefas"
    Write-Host "7.  Windows Update"
    Write-Host "8.  Informacoes do Sistema"
    Write-Host "9.  Limpar Cache DNS"
    Write-Host "10. Reset da Pilha de Rede"
    Write-Host "11. Otimizar Disco"
    Write-Host "12. Firewall do Windows"
    Write-Host "13. Visualizar Logs de Eventos"
    Write-Host "14. Teste de Velocidade de Disco"
    Write-Host "15. Criar Ponto de Restauracao"
    Write-Host "16. Atualizar Programas"
    Write-Host "17. Forcar Politicas de Grupo"
    Write-Host "18. Ativar Conta Administrador"
    Write-Host "19. Drivers Ocultos"
    Write-Host "20. Testar Comunicacao de Rede"
    Write-Host "21. Exibir IPConfig Detalhado"
    Write-Host "22. Testar Portas Comuns"
    Write-Host "23. Renovar IP e Limpar ARP"
    Write-Host "24. Reset do Windows Update"
    Write-Host "25. Limpar Spooler de Impressao"
    Write-Host "26. Flush + Re-Register DNS"
    Write-Host "27. Ver Conexoes Ativas"
    Write-Host "28. Backup de Drivers"
    Write-Host "29. Sincronizar Hora"
    Write-Host "30. Sair"
    Write-Host ""
}

# LOOP PRINCIPAL
while ($true) {

    Menu
    $opcao = Read-Host "Escolha uma opcao (1-30)"

    switch ($opcao) {

        "1" {
            Write-Host "Executando CHKDSK..." -ForegroundColor Yellow
            chkdsk C: /f
            Pause
        }

        "2" {
            Write-Host "Reparando arquivos do sistema..." -ForegroundColor Yellow
            sfc /scannow
            DISM /Online /Cleanup-Image /RestoreHealth
            Pause
        }

        "3" {
            Write-Host "Limpando arquivos temporarios..." -ForegroundColor Yellow
            Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
            Remove-Item "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
            cleanmgr
            Pause
        }

        "4" {
            Write-Host "Abrindo diagnostico de memoria..."
            mdsched.exe
            Pause
        }

        "5" {
            Write-Host "Testando conectividade..."
            ping 8.8.8.8
            nslookup google.com
            Pause
        }

        "6" {
            taskmgr
        }

        "7" {
            Write-Host "Abrindo Windows Update..."
            start ms-settings:windowsupdate
            Pause
        }

        "8" {
            systeminfo
            Pause
        }

        "9" {
            ipconfig /flushdns
            Pause
        }

        "10" {
            netsh winsock reset
            netsh int ip reset
            Write-Host "Reinicie o computador apos concluir." -ForegroundColor Red
            Pause
        }

        "11" {
            defrag C: /O
            Pause
        }

        "12" {
            wf.msc
        }

        "13" {
            eventvwr
        }

        "14" {
            winsat disk
            Pause
        }

        "15" {
            Checkpoint-Computer -Description "Ponto_Restauracao_Suporte"
            Write-Host "Ponto criado com sucesso"
            Pause
        }

        "16" {
            winget upgrade --all
            Pause
        }

        "17" {
            gpupdate /force
            Pause
        }

        "18" {
            net user administrador /active:yes
            Write-Host "Conta Administrador ativada"
            Pause
        }

        "19" {
            start devmgmt.msc
            Pause
        }

        "20" {
            $hostName = Read-Host "Digite IP ou nome da maquina"
            ping $hostName
            Pause
        }

        "21" {
            ipconfig /all
            Pause
        }

        "22" {
            $ip = Read-Host "Digite IP ou hostname"

            Test-NetConnection $ip -Port 3389
            Test-NetConnection $ip -Port 445
            Test-NetConnection $ip -Port 80
            Test-NetConnection $ip -Port 443
            Test-NetConnection $ip -Port 53
            Test-NetConnection $ip -Port 22

            Pause
        }

        "23" {
            ipconfig /release
            ipconfig /renew
            arp -d *
            Pause
        }

        "24" {
            net stop wuauserv
            net stop bits

            Remove-Item "C:\Windows\SoftwareDistribution" -Recurse -Force -ErrorAction SilentlyContinue

            net start wuauserv
            net start bits

            Write-Host "Windows Update resetado"
            Pause
        }

        "25" {
            net stop spooler
            Remove-Item "C:\Windows\System32\spool\PRINTERS\*" -Force -ErrorAction SilentlyContinue
            net start spooler
            Write-Host "Fila de impressao limpa"
            Pause
        }

        "26" {
            ipconfig /flushdns
            ipconfig /registerdns
            Pause
        }

        "27" {
            netstat -ano
            Pause
        }

        "28" {
            $destino = "C:\BackupDrivers"

            if (!(Test-Path $destino)) {
                New-Item -ItemType Directory -Path $destino
            }

            pnputil /export-driver * $destino

            Write-Host "Backup salvo em $destino"
            Pause
        }

        "29" {
            w32tm /resync
            Pause
        }

        "30" {
            Write-Host "Saindo..." -ForegroundColor Yellow
            exit
        }
        
        default {
            Write-Host "Opcao invalida" -ForegroundColor Red
            Pause
        }
    }
}
