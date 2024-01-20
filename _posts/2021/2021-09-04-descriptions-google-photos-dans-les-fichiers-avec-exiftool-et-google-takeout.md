---
post_id: 5560
title: 'Descriptions Google Photos dans les fichiers avec exiftool et Google Takeout'
date: '2021-09-04T18:47:04+02:00'
last_modified_at: '2022-09-02T10:48:47+02:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=5560'
slug: descriptions-google-photos-dans-les-fichiers-avec-exiftool-et-google-takeout
permalink: /2021/09/descriptions-google-photos-dans-les-fichiers-avec-exiftool-et-google-takeout/
image: /files/exiftool_google.png
categories:
    - Informatique
tags:
    - 'Google Photos'
    - Photo
    - exif
    - exiftool
    - Script
    - takeout
lang: fr
featured: 180
---

Pour des photos prises avec un smartphone Android, [Google Photos](https://www.google.com/photos/about/) est très pratique pour partager facilement un album photo. J’y retrouve les différentes fonctions basiques dont j’ai besoin, ajout de commentaire, recadrage avec maintien des proportions, rotation et gestion du contraste/luminosité. Mais j’aime bien également conserver une copie de mes albums… S’i est possible de télécharger un album depuis l’interface, les photos ne contiennent malheureusement pas les commentaires. Heureusement il est possible de résoudre ça avec Google Takeout et exiftool.

Il faut d’abord demander l’extraction sur [Google Takeout](https://takeout.google.com/settings/takeout) désélectionnez tous les produits Google sauf Google Photos, et sélectionnez les albums qui vous intéressent via le bouton “Tous les albums photo inclus”:![](/files/GooglePhotos_Takeout.png){: .img-center}

Vous recevrez un mail une fois le processus d’extraction Google Takeout terminé pour aller télécharger l’archive. Une fois dézippée vous y retrouverez un répertoire par album avec pours chaque photo :

- Le fichier image original
- Un fichier portant le même nom avec l’extension json qui comporte les méta-données de la photo dans Google Photos
- Et si vous avez apporté des modifications, la photo modifiée suffixée par “-modifié”

Il y a également un autre fichier json qui comporte les méta-données de l’album.

Pour copier les méta-données Google du fichier JSON dans l’image le logiciel [exiftool](https://exiftool.org/) est une fois de plus parfait. J’utilise la commande suivante ([source](https://exiftool.org/forum/index.php?topic=11064.0)) :

```
exiftool -d %%Y -Copyright<"(c) ${DateTimeOriginal}"  -tagsfromfile "%%d/%%F.json" "-Keywords<Tags" "-Subject<Tags" "-Caption-Abstract<Description" "-ImageDescription<Description" "-Comment<Description" -Charset cp1252 -overwrite_original_in_place   -progress --ext json -r .
```

- `-d %%Y -Copyright<“(c) ${DateTimeOriginal}”` pour ajouter une mention de Copyright avec l’année. A noter qu’il faut positionner cette partie avant -tagsfromfile pour avoir accès aux tags du fichier source et que les guillemets sont obligatoires pour pouvoir utiliser l’affectation “&lt;“.
- `-tagsfromfile “%%d/%%F.json”` va lire le fichier json correspondant au nom du fichier et le parser pour mettre à disposition le contenu dans des tags
- `“-Keywords<Tags” “-Subject<Tags” “-Caption-Abstract<Description” “-ImageDescription<Description”` pour copier un certain nombre de tags dans les champs EXIF
- `“-Comment<Description” -Charset cp1252` pour copier le commentaire avec le bon encoding
- `-overwrite_original_in_place -progress –ext json -r .` pour traiter récursivement tous les fichiers à partir du répertoire courant, sauf les fichiers json, et sans faire de copie de sauvegarde

Et comme je suis flemmard, j’ai fait un script pour automatiser l’ensemble. Il me suffit de copier ce fichier dans le répertoire à traiter et de le lancer pour qu’il traite tous les sous répertoires. Deux petites complications notables dans ce script :

- Il remplace les fichiers originaux par les fichiers modifiés (ceux suffixés par -modifié) ; voir la première boucle for
- Il contient directement le script exiftool pour renommer sous Windows ([voir ce post](/2020/09/exiftool-config-file-to-rename-files-with-title-on-windows/)) pour n’avoir qu’un unique fichier à créer ; le script est temporairement écrit puis supprimé ; voir la deuxième boucle for qui extrait le script entre les deux balises à la fin

```batch
@echo off
echo Current Directory %~dp0

echo Save original filename
exiftool "-DocumentName<FileName"  -overwrite_original_in_place --ext json -r .

echo Replace original files with files modified in Google Photo (edit modif variable to match your local langage)
REM File must be saved to UTF8 or change the encoding below
chcp 65001
set modif=-modifiÃ©
setlocal enabledelayedexpansion
for /R %%f in (*%modif%*.*) do (
    set FileName=%%f
    set PrevName=%%~nxf
	set PrevFileName=!FileName:%modif%=!
	set NewName=!PrevName:%modif%=!
	del "!PrevFileName!"
	rename "%%f" "!NewName!"
)
endlocal

echo Set caption from Google + set copyright
REM Source : https://exiftool.org/forum/index.php?topic=11064.0 + /2020/09/exiftool-config-file-to-rename-files-with-title-on-windows/
exiftool -d %%Y "-Copyright<(c) ${DateTimeOriginal} - Remi Peyronnet"  -tagsfromfile "%%d/%%F.json" "-Keywords<Tags" "-Subject<Tags" "-Caption-Abstract<Description" "-ImageDescription<Description" "-Comment<Description" -Charset cp1252 -overwrite_original_in_place   -progress --ext json -r .

echo Rename
REM Create exiftool-rename config file
set exifcfg=exiftool-rename.cfg

REM Source : https://stackoverflow.com/questions/7308586/using-batch-echo-with-special-characters
for /f "useback delims=" %%_ in (%0) do (
  if "%%_"=="___ATAD___" set $=
  if defined $ echo(%%_ >> %exifcfg%
  if "%%_"=="___DATA___" set $=1
)

REM exiftool -config "%~dp0\exiftool-rename.txt" -d "%%Y-%%m-%%d %%H-%%M-%%S"  "-FileName<${DateTimeOriginal} - %%f - ${TitleWindows}..%%e"  -ext "%EXT%" -r .
exiftool -config "%~dp0\%exifcfg%" "-FileName<%%.2nC - %%f - ${TitleWindows}.%%e" --ext json  -r .
del %exifcfg%

echo Delete Google Photos json
del /s *.json

PAUSE
goto :eof

___DATA___
%Image::ExifTool::UserDefined = (
    'Image::ExifTool::Composite' => {
		# Valid Title for Windows Filename  (c) 2020 - Remi Peyronnet
        TitleWindows => {
            Require => 'ImageDescription',
			ValueConv => q{ 
				# Maximum length
				my $maxlen=70;
				# Forbidden chars in Windows filename
				my $forbidden = ('\/:*?"<>|'); 
				# Replace forbidden chars
				$val =~ s/[\\x00-\\x1f{$forbidden}]//g; 
				# No filename with trailing space
				$val =~ s/ *$//g; 
				# Truncate if too long
				if ( length($val) > $maxlen ) {
					$val = substr($val, 0, $maxlen - 3);
					#Truncate on last space
					$i = rindex($val, ' ');
					if ($i > 2) {
						$val = substr($val, 0, $i);
					}
					$val = $val . '...';
				}
				# Return value
				$val;
			},
        },
    },
);
___ATAD___

rem #
rem #

```

Version PowerShell modifiée en 2022 pour prendre en compte les modifications Google Photos (Fichiers modifiés via (1) et restauration du nom initial de prise de vue modifié par l’application Android en cas de modification)

```powershell
# Create exiftool configfile
$exiftoolcfg=Join-Path -Path (Get-Location) -ChildPath "exiftool-rename.cfg"
$exiftoolcfg_contents = @'
%Image::ExifTool::UserDefined = (
    'Image::ExifTool::Composite' => {
		# Valid Title for Windows Filename  (c) 2020 - Remi Peyronnet
        TitleWindows => {
            Require => 'ImageDescription',
			ValueConv => q{ 
				# Maximum length
				my $maxlen=70;
				# Forbidden chars in Windows filename
				my $forbidden = ('\/:*?"<>|'); 
				# Replace forbidden chars
				$val =~ s/[\\x00-\\x1f{$forbidden}]//g; 
				# No filename with trailing space
				$val =~ s/ *$//g; 
				# Truncate if too long
				if ( length($val) > $maxlen ) {
					$val = substr($val, 0, $maxlen - 3);
					#Truncate on last space
					$i = rindex($val, ' ');
					if ($i > 2) {
						$val = substr($val, 0, $i);
					}
					$val = $val . '...';
				}
				# Return value
				$val;
			},
        },
    },
);
'@

Add-Content -Path $exiftoolcfg -Value $exiftoolcfg_contents
Write-Output "Writing "$exiftoolcfg 

# Iterate through .json files
Get-ChildItem "." -Recurse -Filter *.json | Foreach-Object {

	#Get contents
    $json = Get-Content $_.FullName | Out-String | ConvertFrom-Json
	
	# Test if photo
	If($json.photoTakenTime) {

		Write-Output "Processing "$_.FullName 

		# Get extension of file
		$ext = $json.title.Split(".")[1]
	
		# Restore original filename (files modified in android application have an ugly name)
		$split = $json.title.Split("_IMG_")
		If ($split.Length -gt 1) {
			$orig = "IMG_" + $split[1]
		} Else { 
			$orig = $split[0]
		}

		# Filenames are truncated, so compute again
		$folder = $_.DirectoryName
		if ($json.title.Length -gt 47) {
			$trunc = $json.title.Substring(0,47)
		} else {
			$trunc = $json.title.Split('.')[0]
		}
		$modified = "(1)"

		$path_orig = Join-Path -Path $folder -ChildPath $orig
		$path_image = Join-Path -Path $folder -ChildPath $trunc'.'$ext
		$path_image_modified = Join-Path -Path $folder -ChildPath $trunc$modified'.'$ext

		# Rename image file
		If (Test-Path -Path $path_image_modified -PathType Leaf) {
			# Image modified, we rename and remove original
			Remove-Item -Path $path_image
			Rename-Item -Path $path_image_modified -NewName $path_orig
		} elseif ((Test-Path -Path $path_image -PathType Leaf) && ($path_orig -ne $path_image)) {
			# Image not modified, we rename
			Rename-Item -Path $path_image -NewName $path_orig
		} else {
			# Nothing to Do
		}

		# Rename JSON file according to image name
		If ($_.FullName -ne ($path_orig + ".json")) {
			Rename-Item -Path $_.FullName -NewName ($path_orig + ".json")
		}
		
		exiftool  `
			-d %Y '-Copyright<(c) ${CreateDate} - Remi Peyronnet'  `
			"-Creator=Remi Peyronnet"  `
			"-DocumentName=$orig"  `
			-tagsfromfile "%d/%F.json"  `
			"-Keywords<Tags"  `
			"-Subject<Tags"  `
			"-Caption-Abstract<Description"  `
			"-ImageDescription<Description"  `
			"-Comment<Description"  -Charset cp1252  `
			-charset filename=cp1252 `
			-overwrite_original_in_place    `
			-progress  `
			$path_orig
	}
	
}

# Final renaming (must be all at once to have correct numbering)
exiftool  `
	-config $exiftoolcfg  `
	-charset filename=cp1252 `
	'-FileName<%-.2nC - %f - ${TitleWindows}.%e' `
	"-FileCreateDate<CreateDate"  `
	"-FileModifyDate<CreateDate"  `
	-fileOrder CreateDate `
	-overwrite_original_in_place    `
	-ext jpg -ext mp4 -r .


# Clean JSON files
Remove-Item ".\*\*.json"

# Clean-up config file
Remove-Item -Path $exiftoolcfg

```

Ce script peut bien sur être adapté pour fonctionner sous Linux (et sera même beaucoup plus simple)