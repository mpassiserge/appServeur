<?php

require 'vendor/autoload.php';

use GuzzleHttp\Client;

define('SUPABASE_URL', 'https://zgxuufxasducuzijmbpg.supabase.co');
define('SUPABASE_KEY', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpneHV1Znhhc2R1Y3V6aWptYnBnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzU2MzI3NDgsImV4cCI6MjA1MTIwODc0OH0.jDItLRIiwzzNKhLgbPW0d7nTGpabMESP0aTOIYMvlro');
define('BUCKET_NAME', 'sergeApp');
define('TABLE_NAME', 'Images');
try {
    $client = new Client([
        'base_uri' => SUPABASE_URL,
        'headers' => [
            'Authorization' => 'Bearer ' . SUPABASE_KEY,
            'apikey' => SUPABASE_KEY,// Ajout de l'en-tête requis
            'Content-Type' => 'application/json',
        ]
        
    ]);

    // Inclure l'API Key dans les en-têtes de la requête
      // Correction du chemin
      $response = $client->request('GET', "/rest/v1/" . TABLE_NAME, [
        'query' => ['select' => '*'] // Sélection de toutes les colonnes
    ]);

    echo $response->getBody();
} catch (Exception $e) {
    echo json_encode(['success' => false, 'message' => $e->getMessage()]);
}
?>
