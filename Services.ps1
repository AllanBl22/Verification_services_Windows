#--------------------Lister les services critiques--------------------

$ServicesCritiques = ('WinRM', 'RemoteRegistry', 'DHCP','DNS', 'DNSCache')



$ListesServices = Get-Service -Name $ServicesCritiques

#--------------------Export fichier CSV--------------------
$CSVFile = "C:\Users\Administrateur\Documents\Listes_Services.csv"
$RapportFile = "C:\Users\Administrateur\Documents\Rapports_Services.csv"

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
        Write-Host "Le service $($Services.Name) était arrêté et a été démarré"
        


     }

     catch{
        Write-Host "Impossible de redémarrer le service $($Services.Name)"

     }
   }
     
      
   else{

        Write-Host "Le service $($Services.Name) est déjà en mode Running ! "
     
   }

}

#--------------------Actualisation de l'etat des services + exportation des données dans un fichier CSV--------------------
$ListesServices = Get-Service -Name $ServicesCritiques
$ListesServices | Select-Object Name, Status, DisplayName| Export-Csv -Path $RapportFile -Delimiter ";"  -Encoding UTF8
