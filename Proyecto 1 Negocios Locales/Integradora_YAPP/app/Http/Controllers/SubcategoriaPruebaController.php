<?php

namespace App\Http\Controllers;

use Kreait\Firebase\Factory;
use Illuminate\Http\Request;

class SubcategoriaPruebaController extends Controller
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
    public function create()
    {
        // Obtener categorías para el formulario
        $categorias = $this->database->getReference('categoria_negocio')->getValue();
        return view('subcategoriasprueba.create', compact('categorias'));
    }

    public function agregarSubcategoria(Request $request)
    {
        // Validar la entrada
        // $request->validate([
        //     'nombre_negocio' => 'required|string|max:255',
        //     'direccion' => 'required|string|max:255',
        //     'telefono' => 'required|string|max:20',
        //     'correo' => 'required|email|max:255',
        //     'id_categoria' => 'required|string',
        //     'tipo_negocio' => 'nullable|string|max:255',
        //     'info' => 'nullable|string',
        //     'imagen' => 'nullable|image|max:2048', // Ajustar según el tamaño máximo permitido
        // ]);

        // Manejo de la imagen
        $imageUrl = null;
        if ($request->hasFile('imagen')) {
            $file = $request->file('imagen');
            $fileName = time() . '_' . $file->getClientOriginalName();
            $bucket = $this->storage->getBucket();
            $bucket->upload(
                file_get_contents($file->getRealPath()),
                [
                    'name' => $fileName,
                ]
            );

            $imageUrl = $bucket->object($fileName)->signedUrl(new \DateTime('+6 months'));
        }

        // Preparar los datos de la subcategoría
        $subcategoriaData = [
            'nombre_negocio' => $request->input('nombre_negocio'),
            'direccion' => $request->input('direccion'),
            'telefono' => $request->input('telefono'),
            'correo' => $request->input('correo'),
            'id_categoria' => $request->input('id_categoria'),
            'tipo_negocio' => $request->input('tipo_negocio'),
            'info' => $request->input('info'),
            'imagen' => $imageUrl,
            'facebook' => $request->input('facebook'),
            'instagram' => $request->input('instagram'),
            'telegram' => $request->input('telegram'),
            'tiktok' => $request->input('tiktok'),
            'whatsapp' => $request->input('whatsapp'),
            'youtube' => $request->input('youtube'),
        ];

        // Si se selecciona "Nueva Categoría", agregarla a la colección 'categoria_negocio'
        if ($request->input('id_categoria') === 'nueva_categoria' && $request->input('tipo_negocio')) {
            // Preparar los datos de la nueva categoría
            $nuevaCategoriaData = [
                //Agregar la imagen de la nueva categoria
                'img_url' => $imageUrl,
                'tipo_negocio' => $request->input('tipo_negocio'),
                'info' => $request->input('info'),
            ];

            // Almacenar en Firebase
            $newCategoryRef = $this->database->getReference('categoria_negocio')->push($nuevaCategoriaData);

            // Obtener el ID de la nueva categoría y actualizar el subcategoríaData
            $subcategoriaData['id_categoria'] = $newCategoryRef->getKey();
        }

        // Almacenar la subcategoría en Firebase
        $this->database
            ->getReference('subcategoria_prueba')
            ->push($subcategoriaData);

        return redirect()->route('subcategoriasprueba.index')->with('success', 'Subcategoría agregada exitosamente.');
    }

    public function index()
    {
        // Obtener las subcategorías de Firebase
        $subcategorias = $this->database->getReference('subcategoria_prueba')->getValue();

        // Convertir a un array si es necesario
        $subcategoriasArray = [];
        if ($subcategorias) {
            foreach ($subcategorias as $key => $subcategoria) {
                $subcategoriasArray[] = array_merge($subcategoria, ['id' => $key]);
            }
        }

        return view('subcategoriasprueba.index', [
            'subcategorias' => $subcategoriasArray,
        ]);
    }

    public function editarSubcategoria($id)
    {
        // Obtener la referencia de la subcategoría que se va a editar
        $subcategoriaRef = $this->database->getReference('subcategoria_prueba/' . $id);

        // Verificar si existe la subcategoría
        $subcategoria = $subcategoriaRef->getValue();
        if (!$subcategoria) {
            return redirect()->route('subcategoriasprueba.index')->with('error', 'Subcategoría no encontrada.');
        }

        // Obtener las categorías para mostrarlas en el select
        $categoriasRef = $this->database->getReference('categoria_negocio');
        $categorias = $categoriasRef->getValue();

        // Retornar la vista edit.blade.php y pasar los datos de la subcategoría y categorías
        return view('subcategoriasprueba.edit', [
            'subcategoria' => $subcategoria,
            'categorias' => $categorias,
            'id' => $id
        ]);
    }


    public function eliminarSubcategoria($id)
    {
        $this->database->getReference('subcategoria_prueba/' . $id)->remove();
        return redirect()->route('subcategoriasprueba.index');
    }
}



// public function editarSubcategoria(Request $request, $id)
//     {
//         $categorias = $this->database->getReference('categoria_negocio')->getValue();
//         $subcategoria = $this->database->getReference('subcategoria_negocio/' . $id)->getValue();

//         if ($request->isMethod('post')) {
//             $data = $request->all();
//             Log::info('Datos recibidos:', $data); // Agrega esto para depurar

//             $file = $request->file('imagen');

//             if ($file) {
//                 $fileName = $file->getClientOriginalName();
//                 $bucket = $this->storage->getBucket();
//                 $bucket->upload(
//                     file_get_contents($file->getRealPath()),
//                     [
//                         'name' => $fileName
//                     ]
//                 );

//                 $imageUrl = $bucket->object($fileName)->signedUrl(new \DateTime('+6 months'));
//                 $data['imagen'] = $imageUrl;
//             } else {
//                 $data['imagen'] = $subcategoria['imagen']; // Mantener la imagen existente si no se sube una nueva
//             }

//             // Actualizar los datos en Firebase
//             $this->database->getReference('subcategoria_negocio/' . $id)->update($data);
//             Log::info('Datos actualizados en Firebase:', $data); // Agrega esto para depurar

//             return redirect()->route('subcategorias.index');
//         }

//         return view('subcategorias.edit', compact('subcategoria', 'categorias', 'id'));
//     }