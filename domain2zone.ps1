
Add-Type -AssemblyName System.Windows.Forms;

$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ InitialDirectory = [Environment]::GetFolderPath('Desktop') };
if(!(Test-Path("C:\BLACKLIST\named.conf.blocked"))){mkdir C:\BLACKLIST\ ;}

clear;
try{


$file = $FileBrowser.ShowDialog();




cd C:\BLACKLIST\

echo "" > blacklist.txt

clear
echo "Analizando Archivo";

$lineas = 0;
$caracteres = 0;
foreach($line in Get-Content $FileBrowser.FileName) {
    
    $lineas = $lineas+1;

    $caracteres = $caracteres + $line.Length;

}

$tamanoArchivo = ($caracteres);
$tamanoArchivoFinal = $tamanoArchivo + (60 * $lineas);

$tamanoArchivo = $tamanoArchivo/1048576;
$tamanoArchivoFinal = $tamanoArchivoFinal/1048576;

$tamanoArchivo = [math]::round($tamanoArchivo,3);
$tamanoArchivoFinal = [math]::round($tamanoArchivoFinal,3);

echo "Se han detectado $lineas dominios"
echo "El archivo actualmente ocupa $tamanoArchivo MB";

echo "La blacklist ocupara $tamanoArchivoFinal MB ¿Quieres continuar? S/n";
$respuesta=Read-Host;

if($respuesta -eq "s" -or $respuesta -eq "S" -or $respuesta -eq ""){
    
    
    $lineasentrecien = $lineas/100;

    $contador = 0;
    $porcentajeABS = 0;
    $porcentajeSiguiente = 0;

    foreach($line in Get-Content $FileBrowser.FileName) {
          $contador = $contador + 1;
          Add-Content C:\BLACKLIST\named.conf.blocked  "zone `"$line`"  { type master; notify no; file `"null.zone.file`"; };";
          $porcentaje = $contador / $lineasentrecien;
          
                    
          if($porcentaje -ge $porcentajeSiguiente){

          $porcentajeABS = [math]::round($porcentaje);

          clear;

          echo "Generando blacklist: $porcentajeABS %";
          $porcentajeSiguiente = $porcentajeABS + 1;
          
          }    
          
                
          

        

    }
    
        sleep(1);

        echo "Tienes tu archivo listo en C:\BLACKLIST\named.conf.blocked";
	
    }
    elseif($respuesta -eq "n" -or $respuesta -eq "N"){
        
        exit;
    
    }
    

    else{
        
        echo "Por favor contesta solo con s o n";

           
    }



}

catch{
	clear;

	"ERROR: Comprueba que has seleccionado el archivo correcto";

	sleep(1);
}