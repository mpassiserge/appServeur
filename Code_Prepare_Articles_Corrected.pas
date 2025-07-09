// Code corrigé - Logique de préparation des articles dans GenOT_Ope2

// ============================================================================
// DETERMINATION DE LA LOGIQUE
// ============================================================================

// Recherche l'existence d'une gamme pour l'opération
if GetGamCount(ANumOpe) > 0 then
   GammeTrouvee := True
else
   GammeTrouvee := False;

// On génère les gammes lorsque l'opération en contient ET que le paramètre 
// "Ne pas générer les gammes" (ST_CRO) n'est pas coché
GenereGam := GammeTrouvee AND ((qyRecOpe.FieldByname('ST_CRO').asString='N') OR (qyRecOpe.FieldByname('ST_CRO').IsNull));

// ============================================================================
// CAS 1 & 3: OPERATION SANS GAMME OU AVEC GAMMES NON GENEREES
// ============================================================================

// Création du BT principal (ordre 1 ou 0 selon le cas)
if (NbOT<=1) or ((NbOT>1) and (not GenereGam)) then
begin
  OdataBase.DatabaseStartTransaction;
  
  // Insertion d'un nouveau BT
  NumBT := OdataBase.SQLGeneric.GetId('BT_getId');
  
  // Configuration du BT selon le cas
  if GenereGam then
  begin
    // Cas où on va générer les gammes après (Cas 2)
    qyInsertBT.ParamByName('StOT').Value := 'O';
    qyInsertBT.ParamByName('StEta').Value := Null;
    qyInsertBT.ParamByName('NuOrd').Value := 0;
  end
  else // GenereGam = False (Cas 1 et 3)
  begin
    // Cas 1: Opération sans gamme
    // Cas 3: Opération avec gammes non générées
    qyInsertBT.ParamByName('StOT').Value := 'N';
    qyInsertBT.ParamByName('StEta').Value := StEtat;
    qyInsertBT.ParamByName('NuOrd').Value := NbOT + 1;
  end;
  
  // ... autres paramètres du BT ...
  
  qyInsertBT.ExecSQL;
  qyInsertBT.Close;
end;

// ============================================================================
// PREPARATION DES ARTICLES - CAS 1 ET 3
// ============================================================================

// Préparation des articles pour le BT (Cas 1 et 3 uniquement)
if PreparationArticle and (GenereGam = False) then
begin
  OTrace.StepTrace(TID,'Préparation Article ! (Ope : '+ IntToStr(ANumOpe)+' - '+booltostr(GenereGam,true));
  
  // 1. TOUJOURS préparer les articles de l'opération sur le BT
  // - Cas 1 (GammeTrouvee = False): Articles d'opération car pas de gammes
  // - Cas 3 (GammeTrouvee = True, GenereGam = False): Articles d'opération + articles de gamme
  Prepare_Article(Acoduti, StPrefix, qyRecOpeArt, ANumEQU, NumBT, NumOT, 1, ANumope, -1);
  
  // 2. Si des gammes existent (Cas 3), préparer AUSSI les articles de gamme sur le BT
  if GammeTrouvee then
  begin
    // Parcourir toutes les gammes pour récupérer leurs articles
    qyRecGam.Close;
    qyRecGam.ParamByName('NumOpe').Value := ANumOpe;
    qyRecGam.Open;
    qyRecGam.First;
    
    if not qyRecGam.IsEmpty then
    begin
      while not qyRecGam.EOF do
      begin
        // Préparation des articles de chaque gamme sur le BT (pas sur OT séparés)
        Prepare_Article(Acoduti, StPrefix, qyRecArtGam, ANumEQU, NumBT, NumOT, NBOT + qyRecGam.FieldByName('ID_ORD').AsInteger, ANumope, qyRecGam.FieldByName('ID_ORD').AsInteger);
        qyRecGam.Next;
      end;
    end;
    qyRecGam.Close;
  end;
end;

// ============================================================================
// CAS 2: GENERATION DES GAMMES SEPAREES
// ============================================================================

if (GenereGam) then
begin
  // Recherche des gammes pour l'opération en cours de traitement
  qyRecGam.Close;
  qyRecGam.ParamByName('NumOpe').Value := ANumOpe;
  qyRecGam.Open;
  qyRecGam.First;
  
  while not qyRecGam.EOF do
  begin
    // Création d'un OT séparé pour chaque gamme
    NumBT := OdataBAse.SQLGeneric.GetId('BT_getId');
    NumGam := qyRecGam.FieldByName('ID_NUMGAM').AsInteger;
    
    // Configuration de l'OT
    qyInsertBT.ParamByName('IdNumBT').Value := NumBT;
    if(NumGam > 0) then
      qyInsertBT.ParamByName('IdNumGam').Value := NumGam;
    qyInsertBT.ParamByName('NuOrd').Value := NBOT + qyRecGam.FieldByName('ID_ORD').AsInteger;
    qyInsertBT.ParamByName('StSta').Value := 'I'; // OT
    qyInsertBT.ParamByName('StOT').Value := 'N';
    
    // ... autres paramètres de l'OT ...
    
    qyInsertBT.ExecSQL;
    qyInsertBT.Close;
    
    // ========================================================================
    // PREPARATION DES ARTICLES - CAS 2 UNIQUEMENT
    // ========================================================================
    
    // Préparation des articles pour les OT (articles de gamme uniquement)
    if PreparationArticle then
    begin
      OTrace.StepTrace(TID,'Préparation Article ! (Ope : '+ IntToStr(ANumOpe)+' - Gamme : '+inttostr(NBOT + qyRecGam.FieldByName('ID_ORD').AsInteger));
      
      // SEULEMENT les articles de la gamme spécifique
      // Les articles de l'opération (qyRecOpeArt) sont IGNORES dans ce cas
      Prepare_Article(Acoduti, StPrefix, qyRecArtGam, ANumEQU, NumBT, NumOT, NBOT + qyRecGam.FieldByName('ID_ORD').AsInteger, ANumope, qyRecGam.FieldByName('ID_ORD').AsInteger);
    end;
    
    qyRecGam.Next;
  end;
  qyRecGam.Close;
end;

// ============================================================================
// RESUME DE LA LOGIQUE
// ============================================================================

{
CAS 1: GammeTrouvee = False, GenereGam = False
- Articles d'opération → Préparés sur BT
- Articles de gamme → N/A (pas de gammes)

CAS 2: GammeTrouvee = True, GenereGam = True  
- Articles d'opération → IGNORES
- Articles de gamme → Préparés sur OT séparés (un OT par gamme)

CAS 3: GammeTrouvee = True, GenereGam = False
- Articles d'opération → Préparés sur BT
- Articles de gamme → Préparés sur BT (consolidés avec les articles d'opération)
}

// ============================================================================
// SIGNATURE DE LA PROCEDURE PREPARE_ARTICLE
// ============================================================================

procedure Prepare_Article(
  ACodUti: String,           // Code utilisateur
  StPrefix: String,          // Préfixe BT
  QuerySource: TQuery,       // qyRecOpeArt OU qyRecArtGam selon le cas
  ANumEQU: Integer,          // Numéro équipement
  NumBT: Integer,            // ID du BT/OT cible
  NumOT: Integer,            // Numéro BT
  NumOrd: Integer,           // Numéro d'ordre (1 pour BT, ID_ORD pour gammes)
  ANumOpe: Integer,          // Numéro opération source
  GammeOrd: Integer          // Ordre gamme (-1 pour opération, ID_ORD pour gamme)
);