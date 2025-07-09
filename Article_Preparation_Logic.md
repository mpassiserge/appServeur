# Logique de Préparation des Articles - GenOT_Ope2

## Vue d'ensemble
La fonction `GenOT_Ope2` implémente une logique sophistiquée pour la préparation des articles selon trois scénarios distincts basés sur la présence de gammes (tâches) et leur mode de génération.

## Variables Clés

```pascal
GammeTrouvee: boolean;     // Indique si l'opération a des gammes
GenereGam: boolean;        // Indique si les gammes doivent être générées
PreparationArticle: boolean; // Active la préparation des articles
```

## Détermination de la Logique

```pascal
// Recherche l'existence d'une gamme pour l'opération
if GetGamCount(ANumOpe) > 0 then
   GammeTrouvee := True
else
   GammeTrouvee := False;

// On génère les gammes lorsque l'opération en contient ET que le paramètre 
// "Ne pas générer les gammes" (ST_CRO) n'est pas coché
GenereGam := GammeTrouvee AND ((qyRecOpe.FieldByname('ST_CRO').asString='N') OR (qyRecOpe.FieldByname('ST_CRO').IsNull));
```

## Cas 1: Opération sans gamme mais comportant une liste d'articles

**Condition**: `GammeTrouvee = False` ET `PreparationArticle = True`

**Résultat**: Une ligne de préparation article est créée pour chaque article de l'opération sur le BT créé

```pascal
// Préparation des articles pour le BT
if PreparationArticle and (GenereGam = False) then
begin
  OTrace.StepTrace(TID,'Préparation Article ! (Ope : '+ IntToStr(ANumOpe));
  // Préparation des articles de l'opération
  Prepare_Article(Acoduti, StPrefix, qyRecOpeArt, ANumEQU, NumBT, NumOT, 1, ANumope, -1);
  
  // Pas de préparation des articles de gamme car GammeTrouvee = False
end;
```

### Fonction Prepare_Article pour les articles d'opération:
- **qyRecOpeArt**: Query des articles de l'opération
- **NumOT = 1**: Ordre de tâche 1 (BT principal)
- **ANumope**: ID de l'opération
- **-1**: Pas d'ordre de gamme spécifique

## Cas 2: Opération avec gamme ET gamme générée ET avec une liste d'articles

**Condition**: `GammeTrouvee = True` ET `GenereGam = True`

**Résultat**: 
- Aucune ligne de préparation article pour les articles de l'opération (ignorés)
- Une ligne de préparation article pour chaque article de la tâche sur l'OT créé pour cette tâche

```pascal
// Si on génère les gammes et que l'opération en contient
if (GenereGam) then
begin
  // Recherche des gammes pour l'opération
  qyRecGam.Close;
  qyRecGam.ParamByName('NumOpe').Value := ANumOpe;
  qyRecGam.Open;
  qyRecGam.First;
  
  while not qyRecGam.EOF do
  begin
    // Création d'un OT pour chaque gamme
    NumBT := OdataBAse.SQLGeneric.GetId('BT_getId');
    NumGam := qyRecGam.FieldByName('ID_NUMGAM').AsInteger;
    
    // ... création de l'OT ...
    
    // Préparation des articles pour les OT (articles de gamme uniquement)
    if PreparationArticle then
    begin
      OTrace.StepTrace(TID,'Préparation Article ! (Ope : '+ IntToStr(ANumOpe)+' - Gamme : '+inttostr(NBOT + qyRecGam.FieldByName('ID_ORD').AsInteger));
      // SEULEMENT les articles de la gamme, PAS les articles de l'opération
      Prepare_Article(Acoduti, StPrefix, qyRecArtGam, ANumEQU, NumBT, NumOT, NBOT + qyRecGam.FieldByName('ID_ORD').AsInteger, ANumope, qyRecGam.FieldByName('ID_ORD').AsInteger);
    end;
    
    qyRecGam.Next;
  end;
end;
```

### Fonction Prepare_Article pour les articles de gamme:
- **qyRecArtGam**: Query des articles de la gamme
- **NBOT + ID_ORD**: Numéro d'ordre de la tâche
- **ID_ORD**: Ordre spécifique de la gamme

**Note importante**: Les articles de l'opération (`qyRecOpeArt`) ne sont PAS traités dans ce cas.

## Cas 3: Opération avec gamme ET gamme NON générée ET avec une liste d'articles

**Condition**: `GammeTrouvee = True` ET `GenereGam = False`

**Résultat**:
- Une ligne de préparation article pour chaque article de l'opération sur le BT créé
- Une ligne de préparation article pour chaque article de la gamme sur le BT créé

```pascal
// Préparation des articles pour le BT
if PreparationArticle and (GenereGam = False) then
begin
  OTrace.StepTrace(TID,'Préparation Article ! (Ope : '+ IntToStr(ANumOpe));
  
  // 1. Préparation des articles de l'opération sur le BT
  Prepare_Article(Acoduti, StPrefix, qyRecOpeArt, ANumEQU, NumBT, NumOT, 1, ANumope, -1);
  
  // 2. Préparation des articles de TOUTES les gammes sur le BT
  qyRecGam.Close;
  qyRecGam.ParamByName('NumOpe').Value := ANumOpe;
  qyRecGam.Open;
  qyRecGam.First;
  
  if not qyRecGam.IsEmpty then
  begin
    while not qyRecGam.EOF do
    begin
      // Préparation des articles de chaque gamme
      Prepare_Article(Acoduti, StPrefix, qyRecArtGam, ANumEQU, NumBT, NumOT, NBOT + qyRecGam.FieldByName('ID_ORD').AsInteger, ANumope, qyRecGam.FieldByName('ID_ORD').AsInteger);
      qyRecGam.Next;
    end;
  end;
end;
```

### Double préparation:
1. **Articles d'opération**: Via `qyRecOpeArt` sur le BT (NumOT = 1)
2. **Articles de gamme**: Via `qyRecArtGam` pour chaque gamme sur le BT

## Synthèse des Comportements

| Cas | GammeTrouvee | GenereGam | Articles Opération | Articles Gamme | Cible |
|-----|--------------|-----------|-------------------|----------------|-------|
| 1   | False        | False     | ✅ Préparés       | ❌ N/A         | BT    |
| 2   | True         | True      | ❌ Ignorés        | ✅ Préparés    | OT    |
| 3   | True         | False     | ✅ Préparés       | ✅ Préparés    | BT    |

## Structure des Appels Prepare_Article

```pascal
procedure Prepare_Article(
  ACodUti: String,           // Code utilisateur
  StPrefix: String,          // Préfixe BT
  Query: TQuery,             // Query source des articles
  ANumEQU: Integer,          // Numéro équipement
  NumBT: Integer,            // Numéro BT cible
  NumOT: Integer,            // Numéro OT
  NumOrd: Integer,           // Numéro d'ordre
  ANumOpe: Integer,          // Numéro opération
  GammeOrd: Integer          // Ordre gamme (-1 si pas de gamme)
);
```

## Implications Métier

- **Cas 1**: Travail simple sans décomposition en tâches
- **Cas 2**: Travail complexe avec tâches indépendantes et articles spécifiques par tâche
- **Cas 3**: Travail complexe traité comme un bloc unique avec consolidation des articles

Cette logique permet une gestion flexible des ressources selon la complexité et le mode d'exécution souhaité pour les opérations de maintenance.