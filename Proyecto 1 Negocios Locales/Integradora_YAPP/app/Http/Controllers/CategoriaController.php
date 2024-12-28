<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Kreait\Firebase\Factory;

class CategoriaController extends Controller
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

    public function listarCategorias()
    {
        $categorias = $this->database->getReference('categoria_negocio')->getValue();
        return view('categorias.index', compact('categorias'));
    }

    public function agregarNuevaCategoria(Request $request)
    {
        $file = $request->file('image');
        $fileName = $file->getClientOriginalName();
        $bucket = $this->storage->getBucket();
        $bucket->upload(
            file_get_contents($file->getRealPath()),
            [
                'name' => $fileName
            ]
        );

        $imageUrl = $bucket->object($fileName)->signedUrl(new \DateTime('+6 months'));

        $newCategory = $this->database
            ->getReference('categoria_negocio')
            ->push([
                'img_url' => $imageUrl,
                'info' => $request->input('info'),
                'tipo_negocio' => $request->input('tipo_negocio')
            ]);

        return redirect()->route('categorias.index');
    }

    public function editarCategoria(Request $request, $id)
    {
        $categoria = $this->database->getReference('categoria_negocio/' . $id)->getValue();

        if ($request->isMethod('post')) {
            $file = $request->file('image');
            if ($file) {
                $fileName = $file->getClientOriginalName();
                $bucket = $this->storage->getBucket();
                $bucket->upload(
                    file_get_contents($file->getRealPath()),
                    [
                        'name' => $fileName
                    ]
                );

                $imageUrl = $bucket->object($fileName)->signedUrl(new \DateTime('+6 months'));
                $categoria['img_url'] = $imageUrl;
            }

            $categoria['info'] = $request->input('info');
            $categoria['tipo_negocio'] = $request->input('tipo_negocio');

            $this->database->getReference('categoria_negocio/' . $id)->set($categoria);

            return redirect()->route('categorias.index');
        }

        return view('categorias.edit', compact('categoria', 'id'));
    }

    public function eliminarCategoria($id)
    {
        $this->database->getReference('categoria_negocio/' . $id)->remove();
        return redirect()->route('categorias.index');
    }
}
