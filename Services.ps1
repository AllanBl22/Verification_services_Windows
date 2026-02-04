#--------------------Lister les services critiques--------------------

$ServicesCritiques = ('WinRM', 'RemoteRegistry', 'DHCP','DNS', 'DNSCache')



$ListesServices = Get-Service -Name $ServicesCritiques

#--------------------Fichiers CSV et Log--------------------
$CSVFile = "C:\Users\Administrateur\Documents\Listes_Services.csv"
$RapportFile = "C:\Users\Administrateur\Documents\Rapports_Services.csv"
$LogFile = "C:\Users\Administrateur\Documents\Services.log"



# -------------------- Fonction de log -----------------------
function Write-Log {
    param (
        [string]$Message,
        [ValidateSet("INFO","ERROR")]
        [string]$Level = "INFO"
    )

    $TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogLine = "$TimeStamp [$Level] $Message"

    # Écrire dans le fichier de log
    Add-Content -Path $LogFile -Value $LogLine

    # Affichage console coloré
    switch ($Level) {
        "INFO"    { Write-Host $LogLine -ForegroundColor Green }
        "ERROR"   { Write-Host $LogLine -ForegroundColor Red }
    }
}
#--------------------pour stocker les services déjà Running/start--------------------
$ServicesRunning = @()
$ServicesRedemarre = @()

#--------------------Trier l'ordre des status--------------------
$ordre = @{
    Running = 1
    Stopped = 2
    Paused  = 3
}

$ListesServices | Sort-Object { $ordre[$_.Status.ToString()] } | Select-Object Name, Status, DisplayName | Export-CSV -Path $CSVFile -Delimiter ";" -Encoding UTF8

#--------------------Vérification status + demarrage--------------------

ForEach ($Services in $ListesServices){

    
  

   if($Services.Status -eq "Stopped"){

     try{

        Start-Service -Name $Services.Name -ErrorAction stop
        Write-Log "Le service $($Services.Name) était arrêté et a été démarré : $_" -Level INFO
        
        # Ajouter au tableau des services redémarrés
        $ServicesRedemarre += $Services.Name

     }

     catch{
        Write-Log "Impossible de redémarrer le service $($Services.Name) : $_" -Level ERROR

     }
   }
     
      
   else{

        Write-Log "Le service $($Services.Name) est déjà en mode Running ! : $_" -Level INFO

        # Ajouter au tableau des services déjà Running
        $ServicesRunning += $Services.Name
   }

}

#--------------------Actualisation de l'etat des services + exportation des données dans un fichier CSV--------------------

Write-Log "******Résumé final******"
Write-Log "Services déjà en Running : $($ServicesRunning -join ', ')" -Level INFO
Write-Log "Services redémarrés: $($ServicesRedemarre -join ', ')" -Level INFO

$ListesServices = Get-Service -Name $ServicesCritiques
$ListesServices | Select-Object Name, Status, DisplayName| Export-Csv -Path $RapportFile -Delimiter ";"  -Encoding UTF8
