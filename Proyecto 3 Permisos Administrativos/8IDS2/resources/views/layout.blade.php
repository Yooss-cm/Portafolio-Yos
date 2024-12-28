<!DOCTYPE html>
    <head>
        <title> @yield('title')</title>
        <style>
            body{
                font-family: Arial, Helvetica, sans-serif;
                margin: 20px;
                text-align: center;
            }

            h1{
                color: black;
            }

            #saberBtn{
                background-color: #28A745;
                color: #FFF;
                padding: 10px 20px;
                font-size: 16px;
                cursor: pointer;
                border: none;
                border-radius: 5px;
            }

            h2{
                color: purple;
            }
            
        </style>
    </head>

    <body>
        <h1>Plantilla</h1>
        @yield('content');

</body>
</html>