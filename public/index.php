<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Galerie Supabase</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .gallery {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 15px;
            padding: 20px;
        }
        .gallery img {
            width: 100%;
            height: auto;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }
        .upload-form {
            margin: 20px auto;
            max-width: 500px;
            padding: 20px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }
    </style>
</head>
<body>

<div class="container">
    <h1 class="text-center mt-4">Galerie d'Images Supabase</h1>

    <!-- Formulaire Upload -->
    <div class="upload-form">
        <form id="uploadForm" action="traitement.php" method="POST" enctype="multipart/form-data">
            <div class="mb-3">
                <label for="image" class="form-label">Téléchargez une image</label>
                <input type="file" class="form-control" id="image" name="image" required>
            </div>
            <button type="submit" class="btn btn-primary w-100">Télécharger</button>
        </form>
    </div>

    <!-- Galerie -->
    <div class="gallery" id="gallery"></div>
</div>

<script>
    document.getElementById('uploadForm').addEventListener('submit', async (e) => {
        e.preventDefault();
        const formData = new FormData(e.target);

        try {
            const response = await fetch('traitement.php', { method: 'POST', body: formData });
            const result = await response.json(); // Récupérer la réponse JSON
            console.log('Response Text:', result);

            if (result.success) {
                alert('Image uploadée avec succès !');
                loadImages();
            } else {
                alert(result.message);
            }
        } catch (error) {
            console.error('Erreur lors du traitement:', error);
            alert('Une erreur est survenue. Veuillez réessayer.');
        }
    });

    async function loadImages() {
        try {
            const response = await fetch('display_images.php');
            const images = await response.json(); // Récupère la réponse JSON

            // Vérifiez si la réponse est bien un tableau
            if (Array.isArray(images)) {
                const gallery = document.getElementById('gallery');
                gallery.innerHTML = '';
                for (const img of images) {
                    const imgElement = document.createElement('img');
                    imgElement.src = img.url;
                    gallery.appendChild(imgElement);
                }
            } else {
                console.error('Les données reçues ne sont pas un tableau:', images);
                alert('Erreur: Les données ne sont pas dans le format attendu.');
            }
        } catch (error) {
            console.error('Erreur lors du chargement des images:', error);
            alert('Impossible de charger les images.');
        }
    }


    loadImages();

</script>

</body>
</html>
