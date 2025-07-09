// ============================================================================
// MODIFICATIONS À APPORTER À LA PROCÉDURE TreatBT
// ============================================================================

// 1. AJOUT DES VARIABLES DANS LA SECTION VAR
var    pose,Typ,MatNumEmp:integer;
    tables:TStringList;
    extMustInsert,Many, WantSynchro:boolean;
    Paos,MatCodEmp,MatImp,MatContra:XMLString;
    aRep,Cri : WordBool;
    p,v:string;
    aUsa:double;
    ID_NUMADR,ID_NUMBT,ID_NUMEQU, ID_NUMMOD :Integer;
    ID_NUMADRBT,ID_NUMADREQU,ID_NUMADRMAT,NewNumAdr,ret,retadrmat,ID_NUMADRBTREP: Integer;
    ST_ADR, ST_ADRCOM, ST_CODPOS, ST_VIL, ID_CODPAY, ST_PAY, ST_GPS, ID_NUMMAT: string;
    NU_LATITUDE, NU_LONGITUDE: double;
    ID_NUMMOTLIG, ID_NUMLIE: Integer;
    proc_ret: integer;
    SorValue : TArray<String>;
    RESULTCODE : string;
    // *** AJOUT DES NOUVELLES VARIABLES ***
    ID_NUMOPE, ID_NUMGAM: Integer;

// 2. INITIALISATION DES VARIABLES AU DÉBUT DE LA PROCÉDURE
begin
  ID_NUMEQU := 0;
  // *** AJOUT DE L'INITIALISATION ***
  ID_NUMOPE := 0;
  ID_NUMGAM := 0;

// 3. RÉCUPÉRATION DES VALEURS APRÈS LoadZones('BT')
       //chargement des zones de l'écran
       LoadZones('BT');

       ID_NUMMOTLIG := StrToIntDef(Context.GetValue('ID_NUMMOTLIG'),0);
       
       // *** AJOUT DE LA RÉCUPÉRATION DES VALEURS ***
       ID_NUMOPE := StrToIntDef(Context.GetValue('ID_NUMOPE'), 0);
       ID_NUMGAM := StrToIntDef(Context.GetValue('ID_NUMGAM'), 0);

// 4. AJOUT DE LA VALIDATION DANS FillBTFields (section else de l'insertion)
       end else
       begin
           //remplissage des champs manquants du BT dans le context
         FillBTFields;
         
         // *** AJOUT DE LA RÉCUPÉRATION SI PAS ENCORE DÉFINIES ***
         if (ID_NUMOPE = 0) then
           ID_NUMOPE := StrToIntDef(Context.GetValue('ID_NUMOPE'), 0);
         if (ID_NUMGAM = 0) then
           ID_NUMGAM := StrToIntDef(Context.GetValue('ID_NUMGAM'), 0);
       end;

// 5. AJOUT DE LA VALIDATION OPÉRATION/GAMME APRÈS FillBTFields
       // *** AJOUT DE LA VALIDATION COHÉRENCE OPÉRATION/GAMME ***
       if (ID_NUMOPE > 0) and (ID_NUMGAM > 0) then
       begin
         // Vérifier que la gamme appartient bien à l'opération
         if not XDisp.GetOMGOpe.GamBelongsToOpe(ID_NUMGAM, ID_NUMOPE) then
         begin
           WarningCur.appendchild('ID_NUMGAM','W_WRONG');
           error := true;
         end;
       end;

// 6. AJOUT DU TRAITEMENT OPÉRATION/GAMME AVANT LA SECTION DES ADRESSES
       // *** AJOUT DU TRAITEMENT SPÉCIFIQUE OPÉRATION/GAMME ***
       if (ID_NUMOPE > 0) then
       begin
         // Mise à jour du contexte avec les informations de l'opération
         Context.SetValue('ID_NUMOPE', IntToStr(ID_NUMOPE));
         
         // Si pas de gamme spécifiée, on peut récupérer les gammes de l'opération
         if (ID_NUMGAM = 0) then
         begin
           // Optionnel : récupérer la première gamme de l'opération si elle existe
           ID_NUMGAM := XDisp.GetOMGOpe.OpeGetFirstGam(ID_NUMOPE);
           if (ID_NUMGAM > 0) then
             Context.SetValue('ID_NUMGAM', IntToStr(ID_NUMGAM));
         end else
         begin
           Context.SetValue('ID_NUMGAM', IntToStr(ID_NUMGAM));
         end;
         
         // Héritage des informations de l'opération vers le BT
         if Insertion then
         begin
           // Récupération de la description de l'opération/gamme
           if (ID_NUMGAM > 0) then
           begin
             // Si gamme spécifiée, prendre sa description
             if (Context.GetValue('ST_TRADEM') = '') then
               AddField('BT','varchar','ST_TRADEM', XDisp.GetOMGOpe.GamGetDescription(ID_NUMGAM));
             if (Context.GetValue('ST_TRA') = '') then  
               AddField('BT','varchar','ST_TRA', XDisp.GetOMGOpe.GamGetDescription(ID_NUMGAM));
           end else
           begin
             // Sinon prendre la description de l'opération
             if (Context.GetValue('ST_TRADEM') = '') then
               AddField('BT','varchar','ST_TRADEM', XDisp.GetOMGOpe.OpeGetDescription(ID_NUMOPE));
             if (Context.GetValue('ST_TRA') = '') then
               AddField('BT','varchar','ST_TRA', XDisp.GetOMGOpe.OpeGetDescription(ID_NUMOPE));
           end;
           
           // Héritage des durées
           if (Context.GetValue('NU_HEUPRE') = '') or (Context.GetValue('NU_HEUPRE') = '0') then
           begin
             if (ID_NUMGAM > 0) then
               AddField('BT','double','NU_HEUPRE', FloatToStr(XDisp.GetOMGOpe.GamGetDuration(ID_NUMGAM)))
             else
               AddField('BT','double','NU_HEUPRE', FloatToStr(XDisp.GetOMGOpe.OpeGetDuration(ID_NUMOPE)));
           end;
           
           // Héritage de l'intervention
           if (Context.GetValue('ID_CODINT') = '') then
           begin
             if (ID_NUMGAM > 0) then
               AddField('BT','varchar','ID_CODINT', XDisp.GetOMGOpe.GamGetIntervention(ID_NUMGAM))
             else
               AddField('BT','varchar','ID_CODINT', XDisp.GetOMGOpe.OpeGetIntervention(ID_NUMOPE));
           end;
         end;
       end;

// 7. MODIFICATION DES APPELS Prepare_OT_INT EXISTANTS
          // MX1-0214 - Ajout des habilitations métiers depuis le modèle d'équipement et matricule
          id_nummat := Context.GetValue('ID_NUMMAT');
          if ID_NUMEQU > 0 then
          begin
              ID_NUMMOD := XDisp.GetOMGEqu.EquGetModFam(ID_NUMEQU);
              if ID_NUMMOD > 0 then
                  XDisp.GetOMGOpe.Prepare_OT_INT(Context.GetValue('ID_CODINT'),
                                                 Context.GetValue('ST_TRADEM'),
                                                 ID_NUMOPE, ID_NUMGAM, 0,  // *** AJOUT ID_NUMOPE et ID_NUMGAM ***
                                                 StrToIntdef(Context.getValue('ID_NUMBT'),0),
                                                 0, 0, 0, 0, False, False, Date, 0, False, True,
                                                 ID_NUMMOD, ID_NUMEQU, '');
          end;

          if ID_NUMMAT <> '' then
          begin
              ID_NUMMOD := XDisp.GetOMGMat.MatGetModFam(ID_NUMMAT);
              if ID_NUMMOD > 0 then
                  XDisp.GetOMGOpe.Prepare_OT_INT(Context.GetValue('ID_CODINT'),
                                                 Context.GetValue('ST_TRADEM'),
                                                 ID_NUMOPE, ID_NUMGAM, 0,  // *** AJOUT ID_NUMOPE et ID_NUMGAM ***
                                                 StrToIntdef(Context.getValue('ID_NUMBT'),0),
                                                 0, 0, 0, 0, False, False, Date, 0, False, True,
                                                 ID_NUMMOD, 0, ID_NUMMAT);
          end;

// 8. AJOUT DE LA PRÉPARATION DES ARTICLES (APRÈS LES APPELS Prepare_OT_INT)
          // *** AJOUT DE LA PRÉPARATION DES ARTICLES LIÉS À L'OPÉRATION/GAMME ***
          if (ID_NUMOPE > 0) and Insertion then
          begin
            if (ID_NUMGAM > 0) then
            begin
              // Préparation des articles spécifiques à la gamme
              XDisp.GetOMGOpe.Prepare_Article(Context.GetValue('ID_CODUTI'),
                                             Context.GetValue('ST_PREFIX'),
                                             nil, // qyRecArtGam - à adapter selon votre implémentation
                                             ID_NUMEQU,
                                             StrToIntdef(Context.getValue('ID_NUMBT'),0),
                                             StrToIntdef(Context.getValue('NU_NUMBT'),0),
                                             StrToIntdef(Context.getValue('NU_ORD'),1),
                                             ID_NUMOPE,
                                             ID_NUMGAM);
            end else
            begin
              // Préparation des articles de l'opération
              XDisp.GetOMGOpe.Prepare_Article(Context.GetValue('ID_CODUTI'),
                                             Context.GetValue('ST_PREFIX'),
                                             nil, // qyRecOpeArt - à adapter selon votre implémentation
                                             ID_NUMEQU,
                                             StrToIntdef(Context.getValue('ID_NUMBT'),0),
                                             StrToIntdef(Context.getValue('NU_NUMBT'),0),
                                             StrToIntdef(Context.getValue('NU_ORD'),1),
                                             ID_NUMOPE,
                                             -1);
            end;
          end;

// ============================================================================
// RÉSUMÉ DES MODIFICATIONS
// ============================================================================

/*
1. Ajout des variables ID_NUMOPE et ID_NUMGAM dans la section var
2. Initialisation de ces variables au début de la procédure
3. Récupération des valeurs depuis le contexte après LoadZones
4. Validation de la cohérence opération/gamme
5. Traitement spécifique avec héritage des informations
6. Modification des appels existants pour inclure les nouveaux paramètres
7. Ajout de la préparation des articles selon la logique opération/gamme

Ces modifications permettent :
- D'intégrer les informations d'opération et de gamme dans le BT
- D'hériter automatiquement des descriptions, durées et interventions
- De préparer les articles selon la logique définie précédemment
- De maintenir la cohérence entre opération et gamme
*/