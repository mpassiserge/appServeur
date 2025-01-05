
<?php

require 'vendor/autoload.php'; // Charger Guzzle (HTTP client)
use GuzzleHttp\Client;

define('SUPABASE_URL', 'https://zgxuufxasducuzijmbpg.supabase.co');
define('SUPABASE_KEY', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpneHV1Znhhc2R1Y3V6aWptYnBnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzU2MzI3NDgsImV4cCI6MjA1MTIwODc0OH0.jDItLRIiwzzNKhLgbPW0d7nTGpabMESP0aTOIYMvlro');
define('BUCKET_NAME', 'sergeApp');
try {
    // Initialisation du client Guzzle
    $client = new Client([
        'base_uri' => SUPABASE_URL,
        'headers' => [
            'Authorization' => 'Bearer ' . trim(SUPABASE_KEY),
            'Content-Type' => 'application/json',
        ],
    ]);

    if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_FILES['image']) && $_FILES['image']['error'] === UPLOAD_ERR_OK) {
        // Récupérer le fichier temporaire
        $tmpFile = $_FILES['image']['tmp_name'];
        // Générer un nom unique pour le fichier
        $fileName = uniqid() . "_" . str_replace(' ', '_', $_FILES['image']['name']);
        $fileName = preg_replace('/[^\w\-\.]/', '_', $fileName); // Remplace les caractères spéciaux


        // 1. Upload du fichier dans Supabase Storage
        $response = $client->request('POST', "/storage/v1/object/" . ltrim(BUCKET_NAME . '/' . $fileName, '/'), [
            'body' => fopen($tmpFile, 'r'), // Ouvrir le fichier
        ]);

        // Générer l'URL publique pour accéder à l'image après l'upload
        $imageUrl = SUPABASE_URL . "/storage/v1/object/public/" . ltrim(BUCKET_NAME . '/' . $fileName, '/');

        // 2. Stocker les métadonnées dans la base de données
        $databaseResponse = $client->request('POST', "/rest/v1/Images", [
            'headers' => ['Authorization' => 'Bearer ' . SUPABASE_KEY,
                'apikey' => SUPABASE_KEY, // Ajoutez cet en-tête
                'Content-Type' => 'application/json',],
            'body' => json_encode([
                'url' => $imageUrl,
                'photo' => $fileName,
                'created_at' => date('Y-m-d H:i:s'),
            ]),
        ]);

        // Si tout est ok, renvoyer une réponse
        echo json_encode(['success' => true, 'message' => 'Image uploadée avec succès !']);
    } else {
        echo json_encode(['success' => false, 'message' => 'Erreur lors de l\'upload.']);
    }
} catch (Exception $e) {
    // En cas d'erreur, renvoyer le message d'erreur
    echo json_encode(['success' => false, 'message' => $e->getMessage()]);
}
?>