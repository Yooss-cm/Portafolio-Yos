<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Kreait\Firebase\Factory;
use Illuminate\Support\Facades\Log;

class SubcategoriaController extends Controller
{
    protected $database;
    protected $storage;

    public function __construct()
    {
        // Aqui se cargan las credenciales y la URL desde el archivo .env
        $firebase = (new Factory)
            ->withServiceAccount(env('FIREBASE_CREDENTIALS'))  // Llama a la ruta desde el .env
            ->withDatabaseUri(env('FIREBASE_DATABASE_URL'));   // URL también desde el .env

        $this->database = $firebase->createDatabase();
        $this->storage = $firebase->createStorage();
    }

    public function listarSubcategorias()
    {
        $subcategorias = $this->database->getReference('subcategoria_negocio')->getValue();
        return view('subcategorias.index', compact('subcategorias'));
    }

    public function agregarNuevaSubcategoria(Request $request)
    {
        $categorias = $this->database->getReference('categoria_negocio')->getValue();

        if ($request->isMethod('post')) {
            $data = $request->all();

            // Manejar la imagen
            $file = $request->file('imagen');
            if ($file) {
                $fileName = $file->getClientOriginalName();
                $bucket = $this->storage->getBucket();
                $bucket->upload(
                    file_get_contents($file->getRealPath()),
                    [
                        'name' => $fileName
                    ]
                );
                // Obtener URL de la imagen subida
                $imageUrl = $bucket->object($fileName)->signedUrl(new \DateTime('+6 months'));
                $data['imagen'] = $imageUrl;
            }

            $data['horario'] = $request->input('horario');  // Actualizar el horario
            $data['correo'] = $request->input('correo') ?? '';  // Asigna cadena vacía si es nulo
            $data['instagram'] = $request->input('instagram') ?? '';
            $data['telefono'] = $request->input('telefono') ? str_replace(' ', '', $request->input('telefono')) : 0;
            $data['whatsapp'] = $request->input('whatsapp') ? str_replace(' ', '', $request->input('whatsapp')) : 0;
            $data['telegram'] = $request->input('telegram') ? str_replace(' ', '', $request->input('telegram')) : 0;
            $data['youtube'] = $request->input('youtube') ?? '';
            $data['tiktok'] = $request->input('tiktok') ?? '';
            $data['facebook'] = $request->input('facebook') ?? '';


            // Convertir las horas de apertura y cierre a UTC antes de almacenarlas
            $horaApertura = new \DateTime($request->input('hora_apertura'), new \DateTimeZone('America/Mexico_City'));
            $horaApertura->setTimezone(new \DateTimeZone('UTC'));
            $data['hora_apertura'] = $horaApertura->getTimestamp();

            $horaCierre = new \DateTime($request->input('hora_cierre'), new \DateTimeZone('America/Mexico_City'));
            $horaCierre->setTimezone(new \DateTimeZone('UTC'));
            $data['hora_cierre'] = $horaCierre->getTimestamp();

            // Guardar los datos en Firebase
            $this->database->getReference('subcategoria_negocio')->push($data);

            return redirect()->route('subcategorias.index');
        }

        return view('subcategorias.create', compact('categorias'));
    }



    public function editarSubcategoria(Request $request, $id)
    {
        $categorias = $this->database->getReference('categoria_negocio')->getValue();
        $subcategoria = $this->database->getReference('subcategoria_negocio/' . $id)->getValue();

        if ($request->isMethod('post')) {
            $data = $request->all();
            Log::info('Datos recibidos:', $data); // Para depuración

            // Manejar la imagen (si se sube una nueva)
            $file = $request->file('imagen');
            if ($file) {
                $fileName = $file->getClientOriginalName();
                $bucket = $this->storage->getBucket();
                $bucket->upload(
                    file_get_contents($file->getRealPath()),
                    [
                        'name' => $fileName
                    ]
                );
                // Obtener URL de la imagen
                $imageUrl = $bucket->object($fileName)->signedUrl(new \DateTime('+6 months'));
                $data['imagen'] = $imageUrl;
            } else {
                // Mantener la imagen existente si no se sube una nueva
                $data['imagen'] = $subcategoria['imagen'];
            }

            // Actualizar los nuevos campos
            $data['horario'] = $request->input('horario');  // Actualizar el horario
            $data['correo'] = $request->input('correo') ?? '';  // Asigna cadena vacía si es nulo
            $data['instagram'] = $request->input('instagram') ?? '';
            // $data['telefono'] = $request->input('telefono') ?? 0;  // Asignar 0 como número entero
            // $data['whatsapp'] = $request->input('whatsapp') ?? 0;  // Asignar 0 como número entero
            // $data['telegram'] = $request->input('telegram') ?? 0;  // Asignar 0 como número entero
            $data['telefono'] = $request->input('telefono') ? str_replace(' ', '', $request->input('telefono')) : 0;
            $data['whatsapp'] = $request->input('whatsapp') ? str_replace(' ', '', $request->input('whatsapp')) : 0;
            $data['telegram'] = $request->input('telegram') ? str_replace(' ', '', $request->input('telegram')) : 0;
            $data['youtube'] = $request->input('youtube') ?? '';
            $data['tiktok'] = $request->input('tiktok') ?? '';
            $data['facebook'] = $request->input('facebook') ?? '';
            //Agrega más datos si quieres

            // Convertir las horas de apertura y cierre a UTC antes de almacenarlas
            $horaApertura = new \DateTime($request->input('hora_apertura'), new \DateTimeZone('America/Mexico_City'));
            $horaApertura->setTimezone(new \DateTimeZone('UTC'));
            $data['hora_apertura'] = $horaApertura->getTimestamp();

            $horaCierre = new \DateTime($request->input('hora_cierre'), new \DateTimeZone('America/Mexico_City'));
            $horaCierre->setTimezone(new \DateTimeZone('UTC'));
            $data['hora_cierre'] = $horaCierre->getTimestamp();

            // Actualizar los datos en Firebase
            $this->database->getReference('subcategoria_negocio/' . $id)->update($data);
            Log::info('Datos actualizados en Firebase:', $data); // Para depuración

            return redirect()->route('subcategorias.index');
        }

        // Convertir los timestamps de la base de datos en un formato de hora para el formulario
        $subcategoria['hora_apertura'] = (new \DateTime('@' . $subcategoria['hora_apertura']))->setTimezone(new \DateTimeZone('America/Mexico_City'))->format('h:i A');
        $subcategoria['hora_cierre'] = (new \DateTime('@' . $subcategoria['hora_cierre']))->setTimezone(new \DateTimeZone('America/Mexico_City'))->format('h:i A');


        return view('subcategorias.edit', compact('subcategoria', 'categorias', 'id'));
    }



    public function eliminarSubcategoria($id)
    {
        $this->database->getReference('subcategoria_negocio/' . $id)->remove();
        return redirect()->route('subcategorias.index');
    }
}


// Reglas Firebase DB
// {
//     "rules": {
//       ".read": "now < 1730440800000",  // 2024-11-1
//       ".write": "now < 1730440800000",  // 2024-11-1
//     }
//   }
